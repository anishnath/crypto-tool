<%@page import="java.util.Set"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
	<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Online truststore,keystore viewer online ",
  "image" : "https://8gwifi.org/images/site/jks.png",
  "url" : "https://8gwifi.org/jks.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2017-09-25",
  "applicationCategory" : [ "online keytool","keystore viewer online","export keystore certificate in pem","keystore online","truststore online"],
  "downloadUrl" : "https://8gwifi.org/jks.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu,Android,iPhone",
  "requirements" : "java keystore, java keytool, keytool keystore, common keytool commands, java create jks, online keystore,openssl, openssl commands, common openssl commands, export pem from keytstore,export certificate in pem format trusstore,keytool online,online keytool,keystore online,jks file viewer online , Generate a Java keystore and key pair , Generate a certificate signing request (CSR) for an existing Java keystore,Import a root or intermediate CA certificate to an existing Java keystore",
  "softwareVersion" : "v1.0"
}
</script>

<meta name="robots" content="index,follow" />
	<meta name="keywords" content="Online keytool, Key and Certificate Management Tool Viewer , keystore viewer, java keystore openssl , java keytool command" />
<meta name="googlebot" content="index,follow" />
<meta name="resource-type" content="document" />
<meta name="classification" content="tools" />
<meta name="language" content="en" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="keytool is a key and certificate management utility. It allows users to administer their own public/private key pairs and associated certificates for use in self-authentication" />
<title>keytool - Key and Certificate Management Tool Online</title>

<%@ include file="header-script.jsp"%>

</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Online keytool Key and Certificate Management Tool Viewer</h1>
<hr>


<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>


<p>Online keytool - Upload keystore view all the aliases and delete aliases, export keystore after deleting aliases. Though your keystore is not stored in our system, <mark>please don't use any production keystore, use only test keystore </mark> alternatively you can <a href="https://leanpub.com/crypto/"> download and install </a> this product on your enviroment for extra security </p>
	<form id="form" method="POST" enctype="multipart/form-data"
		action="JKSManagementFunctionality">

<table class="table table-responsive">
  <tr>
    <th>Keystore/trustore file viewer</th>
    <th  colspan="2"><input type="file" name="upfile"></th>

  </tr>
  <tr>
    <td class="tg-031e">Key Store password (For deleting Alias)</td>
    <%
    String value =(String)session.getAttribute("storepassword");
    if(null==value)
    {
    	value="";
    }

    %>
    <td colspan="2"><input type="text" value="<%=value%>" name="storepassword" id="storepassword" ></td>
  </tr>
  <tr>
    <td class="tg-031e" colspan="3"><input
			type="submit" class="btn btn-primary" value="Upload Keystore to view Aliases"> <input
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
      	<th>You are working on (<%=fileName%>)
			<button type="submit" class="btn btn-light" name="exportKeyStore" value="exportKeyStore">Export Keystore After Delete Aliases</button>
    <!-- <input type="image" src="images/icon_import-export.png" height="20" width="20" border="0" name="exportKeyStore" title="Export the Keystore " value="exportKeyStore" alt="exportKeyStore" /> -->
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
   <td colspan="3"><font color="red"><%=obj1 %></font> </td>
  </tr>
  <% } %>
</table>


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

		<hr>

		<h2 class="mt-4">JKS Entry (<%=Totalaliases%>) found </h2>


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
		<label class="radio-inline"><input type="radio" id="<%=element%>" <%=checked %> name="aliasname"
				value="<%=element%>"><%=element%>  </label>

			<%

				}
			%>

			<button type="submit" class="btn btn-primary" name="GetDetails" value="GetDetails">Get Alias Details</button>
			<button type="submit" class="btn btn-secondary" name="deleteAlias" value="deleteAlias">Delete Alias </button>

			<!--<input type="image" src="images/icon_view.png" title="get details of the Alias" height="20" width="20" border="0" name="GetDetails" value="GetDetails" alt="GetDetails" />
			<input type="image" src="images/icon_delete.png" title="delete alias" height="20" width="20" border="0" alt="delete alias" name="deleteAlias" value="deleteAlias" />-->
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
		<h3 class="mt-4"> Alias Details </h3>
			<table class="table table-striped">
				<thead class="thead-dark">
				<tr>
					<th
						>Alias</th>
					<th colspan="4">Certificate Details</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td rowspan="16"><%=aliasName%></td>
					<td>version</td>
					<td><%=cert.getVersion()%></td>
				</tr>
				<tr>
					<td>Subject</td>
					<td><%=cert.getSubjectDN()%></td>
				</tr>
				<tr>
					<td>Issuer
						DN</td>
					<td><%=cert.getIssuerDN()%></td>
				</tr>
				<tr>
					<td>Signature Algorithm</td>
					<td><%=cert.getSigAlgName()%></td>
				</tr>
				<tr>
					<td>Signature</td>
					<td><textarea class="form-control" rows="5" readonly><%= org.apache.commons.codec.binary.Hex.encodeHex(cert.getSignature())%></textarea></td>
				</tr>

				<% if (cert.getPublicKey()!=null ) {
				%>
				<tr>
					<td>Public Key</td>
					<td><textarea class="form-control" rows="5" readonly><%= org.apache.commons.codec.binary.Hex.encodeHex(cert.getPublicKey().getEncoded())%></textarea></td>
				</tr>

				<% } %>


				<% if (cert.getSerialNumberObject()!=null ) {  %>
				<tr>
					<td>Serial Number </td>
					<td><%= cert.getSerialNumberObject().getNumber()%></td>
				</tr>

				<% } %>


				<tr>
					<td>BasicConstraints</td>
					<td><%=cert.getBasicConstraints()%></td>
				</tr>
				<tr>
					<td>BasicConstraintsExtension</td>
					<td><%=cert.getBasicConstraintsExtension()%></td>
				</tr>
				<tr>
					<td>CRLDistributionPointsExtension</td>
					<td><%=cert.getCRLDistributionPointsExtension()%></td>
				</tr>
				<tr>
					<td>CertificatePoliciesExtensions</td>
					<td><%=cert.getCertificatePoliciesExtension()%></td>
				</tr>
				<tr>
					<td>CriticalExtensionOIDs</td>
					<td>
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
					<td>isSelfIssued</td>
					<td><%=cert.isSelfIssued(cert)%></td>
				</tr>

				<tr>
					<td>Type</td>
					<td><%=cert.getName()%></td>
				</tr>

				<tr>
					<td>NotAfter</td>
					<td><%=cert.getNotAfter()%></td>
				</tr>

				<tr>
					<td>NotBefore</td>
					<td><%=cert.getNotBefore()%></td>
				</tr>


				<tr>
					<td>Dump </td>
						<% if (cert.toString()!=null ) {
				%>

					<td colspan="3"><textarea class="form-control" rows="5" readonly><%= cert.toString()%></textarea></td>
				</tr>

				<% } %>
				</tr>

				</tbody>
			</table>

		<%
			}
				}
			}
		%>


	</form>


<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="thersaalgorithm">Java Keytool Command</h2>

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


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
