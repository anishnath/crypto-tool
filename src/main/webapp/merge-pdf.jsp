<%--
  Created by IntelliJ IDEA.
  User: anish
  Date: 17/02/24
  Time: 12:22 am
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Merge PDF files online. Free service to merge PDF</title>
    <meta name="description" content="Select multiple PDF files and merge them in seconds. Merge & combine PDF files online, easily and free."/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <meta name="author" content="8gwifi.org"/>
    <meta name="keywords" content="Merge PDF, split PDF, combine PDF, extract PDF, compress PDF, convert PDF, Word to PDF, Excel to PDF, Powerpoint to PDF, PDF to JPG, JPG to PDF"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <%@ include file="header-script.jsp"%>

    <script type="application/ld+json">
        {
            "@context": "http://schema.org",
            "@type": "WebApplication",
            "name": "Merge PDF Files Online",
            "description": "This free online tool allows you to easily combine multiple PDF documents into a single PDF file. Simply upload your files, arrange them in your preferred order, and click 'Merge PDFs' to create a single document. Perfect for consolidating documents, reports, or slides into one file, our tool is designed with simplicity and efficiency in mind. No registration is required, and your files are processed securely.",
            "url": "https://8gwifi.org/merge-pdf.jsp",
            "image": "https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/images/site/merge-pdf.png",
            "applicationCategory": "Utility",
            "offers": {
                "@type": "Offer",
                "price": "0.00",
                "priceCurrency": "USD"
            },
            "browserRequirements": "Requires JavaScript. Compatible with most modern web browsers.",
            "operatingSystem": "All"
        }
    </script>

</head>
<%@ include file="body-script.jsp"%>
<h1 class="mt-4">Merge PDF Files Online</h1>
<p>This free online tool allows you to easily combine multiple PDF documents into a single PDF file. Simply upload your files, arrange them in your preferred order, and click 'Merge PDFs' to create a single document.</p>
<%@ include file="footer_adsense.jsp"%>

<hr>
    <div id="pdfUploader">
        <input type="file" id="pdfInput" multiple accept="application/pdf">
        <button class="btn btn-primary" onclick="uploadPDFs()">Upload PDFs</button>
    </div>
    <ul id="pdfList" class="list-group mt-3"></ul>
    <!-- Initially hidden Merge PDFs button -->
    <button id="mergeBtn" class="btn btn-success mt-3" onclick="mergePDFs()" style="display:none;">Merge PDFs</button>
    <div id="downloadButtonContainer"></div>
    <!-- Initially not included Download button -->
<hr>
<div class="sharethis-inline-share-buttons"></div>

<h2 class="mt-4">Try Other PDF Tool</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="merge-pdf.jsp">Merge PDF Files</a></li>
            <li><a href="watermark-pdf.jsp">Add watermark into a PDF</a></li>
        </ul>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<hr>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf-lib/1.16.0/pdf-lib.min.js"></script>
<script src="../js/mergepdf.js"></script>


<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div class="row">
<%@ include file="body-close.jsp"%>

