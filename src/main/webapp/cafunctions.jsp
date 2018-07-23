<!DOCTYPE html>
<html>
<head>

	<title>Online Test rootCA/IntermediateCA,Certs Generation </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Online generate rootCA/IntermediateCA server certificate, Generate Test ca certificate authority,Create your own certificate authority (for testing)">
	<meta name="keywords"
		  content="generate certificate online,what is an intermediate certificate,root certificate vs server certificate,openssl create ca and sign certificate,openssl create intermediate ca,trial certificate online,test ca certificate generate online, generate ca authority,create your own certificate authority,ssl certificate check,digicert ssl checker,openssl create ca and sign certificate,openssl create intermediate ca
 ">
	<%@ include file="include_css.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {

			$('#generateca').click(function (event)
			{
				//
				$('#form').delay(200).submit()

			});

			$('#form').submit(function (event)
			{
				//
				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type: "POST",
					url: "GenCAFunctionality", //this is my servlet
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
<div id="page">
	<%@ include file="include.jsp" %>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	<article id="contentWrapper" role="main">
		<section id="content">
			<form id="form" method="POST">
				<input type="hidden" name="methodName" id="methodName"
					   value="GENERATE_TEST_CA">
				<fieldset name="Generate Test CA Certificate">
					<legend>
						<B>Generate Test CA Certificate </B>
					</legend>
					Provide CN (Hostname)<input id="p_dns_name" type="text" name="p_dns_name"
												value="">
					<input type="button" id="generateca" name="generateca" value="Click">
					<div id="output"></div>
				</fieldset>

			</form>
			<%@ include file="include_security_links.jsp"%>
			<%@ include file="footer.jsp"%>
		</section>
	</article>
</div>
</body>
</html>