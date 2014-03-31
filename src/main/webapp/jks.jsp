<%@page import="java.util.Set"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="keywords"
	content="online certificate management, keytool generation online" />
<meta name="language" content="en" />
<meta name="robots" content="index, follow" />
<meta name="revisit-after" content="3 month" />
<meta name="description"
	content="keytool is a key and certificate management utility. It allows users to administer their own public/private key pairs and associated certificates for use in self-authentication" />
<title>keytool - Key and Certificate Management Tool Online</title>
<%@ include file="include_css.jsp"%>
</head>
<body>

<div id="page">

	<%@ include file="include.jsp"%>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	
		<article id="contentWrapper" role="main">
			<section id="content">
			Online keytool - Key and Certificate Management Tool
Manages a keystore (database) of cryptographic keys, X.509 certificate chains, and trusted certificates.
	<form id="form" method="POST" enctype="multipart/form-data"
		action="JKSManagementFunctionality">
		<fieldset>
		<legend><b>Upload Keystore/Trustore</b></legend>
		<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;border-color:#aaa;}
.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;border-color:#aaa;color:#333;background-color:#fff;}
.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;border-color:#aaa;color:#fff;background-color:#f38630;}
.tg .tg-s6z2{text-align:center}
.tg .tg-z2zr{background-color:#FCFBE3}
</style>
<table class="tg">
  <tr>
    <th class="tg-s6z2">Keystore/trustore file</th>
    <th class="tg-031e" colspan="2"><input type="file" name="upfile"></th>
  </tr>
  <tr>
    <td class="tg-031e">Store password</td>
    <td class="tg-z2zr" colspan="2"><input type="text" value="<%=session.getAttribute("storepassword")%>" name="storepassword" id="storepassword" ></td>
  </tr>
  <tr>
    <td class="tg-031e" colspan="3"><input
			type="submit" value="Press"> to upload the file! <input
			type="hidden" name="md5" value="<%=session.getAttribute("md5")%>"></td>
  </tr>
  <%
  String obj1 = (String)session.getAttribute("Error");
  
  if(obj1!=null && !obj1
		  .isEmpty())
  {
  
  %>
  <tr>
   <td class="tg-031e" colspan="3"><font color="red"><%=obj1 %></font> </td>
  </tr>
  <% } %>
</table>
		</fieldset>
		
		<%
			Object obj = session.getAttribute("displayAliases");
			//System.out.println(obj);

			if (obj != null) {
				Map<String, Object> map = (Map) obj;
				Iterator it = map.entrySet().iterator();
				while (it.hasNext()) {
					Map.Entry pairs = (Map.Entry) it.next();
					final String Totalaliases = (String) pairs.getKey();
		%>
		<fieldset name="JKS Functionality">
			<legend>
				<B>JKS Aliases (<%=Totalaliases%>) found
				</B>
			</legend>

			<%
				List<String> aliases = (List<String>) pairs.getValue();
						// System.out.println(pairs.getKey() + " = " + pairs.getValue());
						it.remove(); // avoids a ConcurrentModificationException
						 
						 String aliasName = (String) session.getAttribute("aliasName");
						for (String element : aliases) {
							String checked = "";  
							if(aliasName!=null)
							{
								if(aliasName.equals(element))
								{
									checked="checked";
								}
							}
							
			%>
			<input type="radio" id="<%=element%>" <%=checked %> name="aliasname"
				value="<%=element%>"><%=element%>

			<%
							
				}
			%>
			<input type="submit" name="GetDetails" value="GetDetails">
		</fieldset>
		<%
			}
			}
		%>

		<%
			Object displayAliasesDetails = session
					.getAttribute("displayAliasesDetails");

			//System.out.println(displayAliasesDetails.getClass());
			if (displayAliasesDetails != null) {
				String aliasName = (String) session.getAttribute("aliasName");
				Map<String, Object> m = (Map<String, Object>) displayAliasesDetails;
				if (m.get(aliasName) != null) {
					//System.out.print("The Class" + m.get(aliasName).getClass());
					if (m.get(aliasName) instanceof sun.security.x509.X509CertImpl) {

						sun.security.x509.X509CertImpl cert = (sun.security.x509.X509CertImpl) m
								.get(aliasName);
		%>
		<fieldset>
			<legend>Alias Details</legend>
			<table
				style="border-collapse: collapse; border-spacing: 0; border-color: #bbb">
				<tr>
					<th
						style="font-family: Arial, sans-serif; font-size: 14px; font-weight: normal; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #493F3F; background-color: #9DE0AD; text-align: center">Alias</th>
					<th
						style="font-family: Arial, sans-serif; font-size: 14px; font-weight: normal; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #493F3F; background-color: #9DE0AD"
						colspan="2">Certificate Details</th>
					<th
						style="font-family: Arial, sans-serif; font-size: 14px; font-weight: normal; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #493F3F; background-color: #9DE0AD; text-align: center">Encoded PEM  <input type="submit" name="export" value="export"></th>

				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB; text-align: right"
						rowspan="14"><%=aliasName%></td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">version</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.getVersion()%></td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"
						rowspan="14">
						-----BEGIN CERTIFICATE-----<br>
						<%=new sun.misc.BASE64Encoder().encode(cert
								.getEncoded())%><br>
								-----END CERTIFICATE-----</td>
				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">Subject</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB; text-align: right"><%=cert.getSubjectDN()%></td>
				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">Issuer
						DN</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.getIssuerDN()%></td>
				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">Signature
						Algorithm</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB; text-align: right"><%=cert.getSigAlgName()%></td>
				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">Key</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.getSigAlgName()%></td>
				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">BasicConstraints</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.getBasicConstraints()%></td>
				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">BasicConstraintsExtension
						exponent</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.getBasicConstraintsExtension()%></td>
				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">CRLDistributionPointsExtension</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.getCRLDistributionPointsExtension()%></td>
				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">CertificatePoliciesExtension
						Extensions</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.getCertificatePoliciesExtension()%></td>
				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">CriticalExtensionOIDs</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB">
						<%
							Set<String> Oids = cert.getCriticalExtensionOIDs();
										if (Oids != null) {
											Iterator it = Oids.iterator();

											while (it.hasNext()) {
						%> <%=it.next()%> <%
 	}
 				}
 %>
					</td>
				</tr>
				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">isSelfIssued</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.isSelfIssued(cert)%></td>
				</tr>

				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">Type</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.getName()%></td>
				</tr>

				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">Not
						After</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.getNotAfter()%></td>
				</tr>

				<tr>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #C2FFD6">Not
						Before</td>
					<td
						style="font-family: Arial, sans-serif; font-size: 14px; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #594F4F; background-color: #E0FFEB"><%=cert.getNotBefore()%></td>
				</tr>

			</table>


		</fieldset>
		<%
			}
				}
			}
		%>


	</form>
	<%@ include file="include_security_links.jsp"%>
<%@ include file="footer.jsp"%>
		
			</section>
		</article>
		
	</div>
</body>
</html>