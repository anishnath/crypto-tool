<!DOCTYPE html>
<html>
<head>
   <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <title> Codecs | URLEncode |  simple URL Encoder</title>
  <meta name="description" content="Encode your URL string with this best easy to use online tool." />
  <meta name="keywords" content="url, decode, encode, online, tool  keyboard, html, codes, html, codes, hash, functions, url, tld, encode, decode"/>
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
                  $('#outputtext1').html('<img src="images/712.GIF"> loading...');
         			 event.preventDefault();
                        $.ajax({
                            type: "POST",
                            url: "StringFunctionality", //this is my servlet
                
                           data: $("#form").serialize(),
                            success: function(msg){    
                            		    $('#outputtext').empty();
                            		    $('#outputtext1').empty();
                                     $('#outputtext').append(msg);
                                     
                            }
                        }); 
                    });
        });
   
    </script>
</head>
<body>
	<div id="page">
<%@ include file="include.jsp" %> 
<article id="contentWrapper" role="main">
			<section id="content">
<small><a href="http://en.wikipedia.org/wiki/Percent-encoding">From Wiki</a> </small>
<br>
<b>Percent-encoding, also known as URL encoding,</b> is a mechanism for encoding information in a Uniform Resource Identifier (URI) under certain circumstances. Although it is known as URL encoding it is, in fact, used more generally within the main Uniform Resource Identifier (URI) set, which includes both Uniform Resource Locator (URL) and Uniform Resource Name (URN). As such, it is also used in the preparation of data of the application/x-www-form-urlencoded media type, as is often used in the submission of HTML form data in HTTP requests.
<br>
<br>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
		<div id="outputtext1"> </div>
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

				<%@ include file="footer.jsp"%>
				<pre class="newpage"><span style="text-decoration: underline;"><strong>Reserved Characters<br /></strong></span>The purpose of reserved characters is to provide a set of delimiting<br />characters that are distinguishable from other data within a URI.<br />reserved = gen-delims / sub-delims <br />gen-delims = ":" / "/" / "?" / "#" / "[" / "]" / "@" <br />sub-delims = "!" / "$" / "&amp;" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="<br /><br /><span style="text-decoration: underline;"><strong>Percent-Encoding<br /></strong></span>A percent-encoded octet is encoded as a character triplet, consisting of the percent character "%" followed by the two
hexadecimal digits representing that octet's numeric value for example  the percent-encoding for the binary octet
"00100000" (ABNF: %x20), which in US-ASCII corresponds to the <strong>space character (SP)</strong></pre>
<pre class="newpage">Because the percent ("%") character serves as the indicator for percent-encoded octets, it must be percent-encoded as "%25" for that
octet to be used as data within a URI.<span style="text-decoration: underline;"><strong><br /><br /></strong></span>The reserved character&nbsp;<code>/</code>, for example, if used in the "path" component of a URI, <br />has the special meaning of being a delimiter&nbsp;<em>between</em>&nbsp;path segments. <br />If, according to a given URI scheme,&nbsp;<code>/</code>&nbsp;needs to be&nbsp;<em>in</em>&nbsp;a path segment, <br />then the three characters&nbsp;<code>%2F</code>&nbsp;or&nbsp;<code>%2f</code>&nbsp;must be used in the segment instead of a raw&nbsp;<code>/</code>.<span style="text-decoration: underline;"><br /><br /></span></pre>
<pre class="newpage">The following are two example URIs and their component parts:

         foo://example.com:8042/over/there?name=ferret#nose
         \_/   \______________/\_________/ \_________/ \__/
          |           |            |            |        |
       scheme     authority       path        query   fragment
          |   _____________________|__
         / \ /                        \
         urn:example:animal:ferret:nose
</pre>
				<pre class="newpage"><span style="text-decoration: underline;"><br /><strong><br /><br /></strong></span></pre>
				<pre class="newpage">&nbsp;</pre>

	
			</section>
		</article>
		
	</div>
</body>
</html>