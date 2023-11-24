<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"> -->
    <title>Download File</title>
    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
<h1 class="mt-4">PGP File Info</h1>
    <div class="container mt-5">
        <div class="card">
            <div class="card-body">
                <%-- Access the presigned URL from the request attribute --%>
                <%
                    String presignedUrl = (String) session.getAttribute("presignedUrl");
                    String file_name = (String) session.getAttribute("file_name");
                    session.removeAttribute("presignedUrl");
                    session.removeAttribute("file_name");
                    
                    if (file_name==null) {
                    	response.sendRedirect(request.getContextPath()+"/pgp-upload.jsp");
                    } 
                           
                    if (presignedUrl != null) {
                        %>
                        <p class="text-success">File <strong><%=file_name %></strong> <a id="downloadLink" href="<%= presignedUrl %>"  download> Click for Download</a></p>

                        <%
                    } else {
                        %>
                        <p class="text-danger">The specified file <strong><%=file_name %></strong> doesn't exist.</p>
                        <%
                    }
                %>
            </div>
        </div>
    </div>

   <!--  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script> -->
    
     <script>
                            // Simulate a click on the hidden link
                            document.getElementById('downloadLink').click();
                            alert("File '" + <%= file_name %> + "' downloaded successfully!");
                        </script>

<%@ include file="footer_adsense.jsp"%>


<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>


<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div class="row">

<%@ include file="body-close.jsp"%>

