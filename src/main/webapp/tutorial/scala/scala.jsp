<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">

<html>

<head>
<title>Scala By Example</title>
<%@ include file="../include_scripthighighlight.jsp"%>
<meta name="description"
	content="Scala  Learning Scala Programming Language in simple and easy steps . A beginner's tutorial containing complete knowledge of Scala Syntax Object Oriented Language, Traits, Methods, Pattern Matching, Tuples, Annotations, Extractors.">
<meta name="keywords"
	content="Scala, Tutorials, Learning, Beginners, Basics, Object Oriented Language, Methods, Traits, Oriented Language, Methods, Pattern Matching, Tuples, Annotations, Designators.">
<style type="text/css" media="screen">
@import "<%=request.getContextPath()%>/css/Two_Column-Left Menu.css";
</style>
</head>

<body>

	<div id="Header">The Online Tool for Online People <a href="<%=request.getContextPath() %>">Back</a></div>

	<div id="Content">
	<%
	String fName = (String)session.getAttribute("fName");
			
			if(fName==null || fName.isEmpty())
			{
				fName="";
			}
	%>
		<h1>Scala By Examples <%=fName %></h1>
		<pre class="brush: js;">
		<%
			String fileContent = (String) session.getAttribute("fileContent");
			if (fileContent != null && !fileContent.isEmpty()) {
		%>
		<%=fileContent%>
		<%
			}
		%>
</pre>
	</div>

	<div id="Menu">

		<%
			Map<String, String> map = (Map<String, String>) session
					.getAttribute("scalafileNameMap");
			if (map != null) {
				for (String key : map.keySet()) {

					final String fileName = (String) key;
					String urlName = request.getContextPath()
							+ "/TutorialFunctionality?tutorial=Scala&fileName="
							+ fileName;
		%>
		<a href="<%=urlName%>" title="Scala Tutorial <%=fileName%>"><%=fileName%></a><br>
		<%
			}
			}
		%>
	</div>
</body>
</html>