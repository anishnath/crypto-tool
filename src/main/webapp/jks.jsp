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
<meta name="keywords" content="java keystore, java keytool, keytool keystore, common keytool commands, java create jks, online keystore,openssl, openssl commands, common openssl commands, export pem from keytstore,export certificate in pem format trusstore,keytool online,online keytool,keystore online,jks file viewer online"/>
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
.tg  {border-collapse:collapse;border-spacing:0;border-color:#aab;}
.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;border-color:#aaa;color:#333;background-color:#fff;}
.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;border-color:#aaa;color:#fff;background-color:#f39630;}
.tg .tg-s6z2{text-align:center}
.tg .tg-z2zr{background-color:#FCABE3}
</style>
<table class="tg">
  <tr>
    <th class="tg-s6z2">Keystore/trustore file</th>
    <th class="tg-031e" colspan="2"><input type="file" name="upfile"></th>

  </tr>
  <tr>
    <td class="tg-031e">Store password</td>
    <%
    String value =(String)session.getAttribute("storepassword");
    if(null==value)
    {
    	value="";
    }

    %>
    <td class="tg-z2zr" colspan="2"><input type="text" value="<%=value%>" name="storepassword" id="storepassword" ></td>
  </tr>
  <tr>
    <td class="tg-031e" colspan="3"><input
			type="submit" value="Press"> to upload the file! <input
			type="hidden" name="md5" value="<%=session.getAttribute("md5")%>">
			
			<input
			type="hidden" name="fileName" value="<%=session.getAttribute("fileName")%>">
			
			</td>
  </tr>
  <%
  Object obj2 = (Object)session.getAttribute("displayAliases");
  if(obj2!=null )
  {
	  String fileName = (String)session.getAttribute("fileName");
	  if(fileName==null || fileName.isEmpty())
	  {
		  fileName="";
	  }
  %>
  <tr>
      	<th>Export Keystore	(<%=fileName%>)		
    <input type="image" src="images/icon_import-export.png" height="20" width="20" border="0" name="exportKeyStore" title="Export the Keystore " value="exportKeyStore" alt="exportKeyStore" />
    </th>
  </tr>
  <%
  }
  %>
  
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
		<fieldset class="tg-031e" name="JKS Functionality">
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
			<input type="image" src="images/icon_view.png" title="get details of the Alias" height="20" width="20" border="0" name="GetDetails" value="GetDetails" alt="GetDetails" />
			<input type="image" src="images/icon_delete.png" title="delete alias" height="20" width="20" border="0" alt="delete alias" name="deleteAlias" value="deleteAlias" />
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
						style="font-family: Arial, sans-serif; font-size: 14px; font-weight: normal; padding: 10px 5px; border-style: solid; border-width: 1px; overflow: hidden; word-break: normal; border-color: #bbb; color: #493F3F; background-color: #9DE0AD; text-align: center">Export Encoded PEM <input type="image" src="images/icon_import-export.png" height="20" width="20" border="0" name="export" title="Export PEM" value="export" alt="export" /> </th>

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

				<br>
				<br>
				<%@ include file="footer.jsp"%>
				<br>
				<br>
				<h2>Java Keytool Commands</h2>
				<p>These commands allow you to generate a new Java Keytool keystore file, create a CSR, and import certificates. Any root or intermediate certificates will need to be imported before importing the primary certificate for your domain.</p>
				<ul>
					<li><strong>Generate a Java keystore and key pair</strong>
						<p>keytool -genkey -alias&nbsp;mydomain&nbsp;-keyalg RSA -keystore&nbsp;keystore.jks&nbsp;-keysize 2048</p>
					</li>
					<li><strong>Generate a certificate signing request (CSR) for an existing Java keystore</strong>
						<p>keytool -certreq -alias&nbsp;mydomain&nbsp;-keystore&nbsp;keystore.jks&nbsp;-file 8gwifi.csr</p>
					</li>
					<li><strong>Import a root or intermediate CA certificate to an existing Java keystore</strong>
						<p>keytool -import -trustcacerts -alias root -file 8gwifiCA.crt&nbsp;-keystore&nbsp;keystore.jks</p>
					</li>
					<li><strong>Import a signed primary certificate to an existing Java keystore</strong>
						<p>keytool -import -trustcacerts -alias&nbsp;mydomain&nbsp;-file&nbsp;mydomain.crt&nbsp;-keystore&nbsp;keystore.jks</p>
					</li>
					<li><strong>Generate a keystore and self-signed certificate</strong>&nbsp;&nbsp;
						<p>keytool -genkey -keyalg RSA -alias selfsigned -keystore&nbsp;keystore.jks&nbsp;-storepass&nbsp;password&nbsp;-validity 360 -keysize 2048</p>
					</li>
					<li><strong>Check a stand-alone certificate</strong>
						<p>keytool -printcert -v -file 8gwifi.crt</p>
					</li>
					<li><strong>Check which certificates are in a Java keystore</strong>
						<p>keytool -list -v -keystore&nbsp;keystore.jks</p>
					</li>
					<li><strong>Check a particular keystore entry using an alias</strong>
						<p>keytool -list -v -keystore&nbsp;keystore.jks&nbsp;-alias mydomain</p>
					</li>
					<li><strong>Delete a certificate from a Java Keytool keystore</strong>
						<p>keytool -delete -alias&nbsp;8gwifi -keystore&nbsp;keystore.jks</p>
					</li>
					<li><strong>Change a Java keystore password</strong>
						<p>keytool -storepasswd -new new_storepass -keystore&nbsp;keystore.jks</p>
					</li>
					<li><strong>Export a certificate from a keystore</strong>
						<p>keytool -export -alias&nbsp;mydomain&nbsp;-file&nbsp;mydomain.crt&nbsp;-keystore&nbsp;keystore.jks</p>
					</li>
					<li><strong>List Trusted CA Certs</strong>
						<p>keytool -list -v -keystore $JAVA_HOME/jre/lib/security/cacerts</p>
					</li>
					<li><strong>Import New CA into Trusted Certs</strong>
						<p>keytool -import -trustcacerts -file&nbsp;/path/to/ca/ca.pem&nbsp;-alias&nbsp;CA_ALIAS&nbsp;-keystore $JAVA_HOME/jre/lib/security/cacerts</p>
					</li>
					<li></li>
				</ul>
				<h2>OpenSSL Commands</h2>
				<ul>
					<li><strong>Generate a new private key and Certificate Signing Request</strong>
						<pre>openssl req -out CSR.csr -new -newkey rsa:2048 -nodes -keyout privatekey.key</pre>
					</li>
					<li><strong>Generate a self-signed certificate&nbsp;</strong>
						<pre>openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout privatekey.key -out certificate.crt</pre>
					</li>
					<li><strong>Generate a certificate signing request (CSR) for an existing private key</strong>
						<pre>openssl req -out CSR.csr -key privatekey.key -new</pre>
					</li>
					<li><strong>Generate a certificate signing request based on an existing certificate</strong>
						<pre>openssl x509 -x509toreq -in certificate.crt -out CSR.csr -signkey privatekey.key</pre>
					</li>
					<li><strong>Remove a passphrase from a private key</strong>
						<pre>openssl rsa -in privateKey.pem -out newprivatekey.pem</pre>
					</li>
					<li><strong>Convert a DER file (.crt .cer .der) to PEM</strong>
						<pre>openssl x509 -inform der -in certificate.cer -out certificate.pem</pre>
					</li>
					<li><strong>Convert a PEM file to DER</strong>
						<pre>openssl x509 -outform der -in certificate.pem -out certificate.der</pre>
					</li>
					<li><strong>Convert a PKCS#12 file (</strong><strong>.pfx .p12</strong><strong>) containing a private key and certificates to PEM</strong>
						<pre>openssl pkcs12 -in keyStore.pfx -out keystore.pem -nodes</pre>
						<p>You can add -nocerts to only output the private key or add -nokeys to only output the certificates.</p>
					</li>
					<li><strong>Convert a PEM certificate file and a private key to PKCS#12 (.pfx .p12)</strong>
						<pre>openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key -in certificate.crt -certfile </pre>
					</li>
				</ul>
				<p>&nbsp;</p>


	<%@ include file="include_security_links.jsp"%>

		
			</section>
		</article>
		
	</div>
</body>
</html>