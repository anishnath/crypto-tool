<!DOCTYPE html>
<html>
<head>
	<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
	<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Online yaml to json convertor",
  "image" : "https://8gwifi.org/images/site/yamlparser.png",
  "url" : "https://8gwifi.org/yamlparser.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2018-12-12",
  "applicationCategory" : [ "online yaml to json", "yaml to xml", "convert yaml to json" ,"yaml parser"],
  "downloadUrl" : "https://8gwifi.org/yamlparser.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu,Android,iPhone",
  "requirements" : "yaml to json convertor online",
  "softwareVersion" : "v1.0"
}
</script>
	<title>yaml to json convertor online</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="keywords" content="yaml to json, yaml to xml, online yaml to json, convert yaml to json, yaml parser "/>
	<meta name="description" content="yaml to json convertor online, yaml parser, yaml to xml conversion" />

	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<script type="text/javascript">
		$(document).ready(function() {

			$('#encryptmsg').show();
			$('#descryptmsg').hide();

			$('#encrypt').click(function (event)
			{
				//
				$('#encryptmsg').show();
				$('#descryptmsg').hide();

			});

			$('#decrypt').click(function (event)
			{
				//
				$('#encryptmsg').hide();
				$('#descryptmsg').show();

			});

			$('#submit').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#form').submit(function(event) {
				//
				$('#output1').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "JSONFunctionality", //this is my servlet

					data : $("#form").serialize(),
					success : function(msg) {
						$('#output').empty();
						$('#output').append(msg);

					}
				});
			});
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">YAML-TO-JSON/XML CONVERTOR</h1>
<p>Input YAML data and get JSON/XML output</p>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<hr>


			<form id="form" method="POST">
				<input type="hidden" name="methodName" id="methodName" value="yaml_to_json">


				<div class="form-group row">
					<label for="input"  class="font-weight-bold col-sm-2 col-form-label">YAML</label>
					<div class="col-sm-10">
						<textarea rows="10" cols="10" class="form-control" name="input" id="input">apiVersion: apps/v1beta1
kind: Deployment
metadata:
  annotations:
    ABC: '123'
    XYZ: '761'
  labels: &id001
    TRT: '113'
    OIU: '981'
  name: random
  namespace: default</textarea>
					</div>
				</div>
					<input class="btn btn-primary" type="submit" id="submit" name="YAML2JSON">

			</form>
<div id="output"></div>

<hr>

<h2 class="mt-4">Try Other Convertor</h2>
<div class="row">
	<div>
		<ul>
			<li><a href="jsonparser.jsp">JSON-2-YAML/XML</a></li>
			<li><a href="yamlparser.jsp">YAML-2-JSON/XML</a></li>
			<li><a href="xml2json.jsp">XML-2-JSON/YAML</a></li>
		</ul>
	</div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>

