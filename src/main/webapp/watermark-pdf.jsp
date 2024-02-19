<%--
  Created by IntelliJ IDEA.
  User: anish
  Date: 19/02/24
  Time: 8:36 pm
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<html>
<head>
    <title>Add a watermark to a PDF. Add text , QR code or image to a PDF</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PDF Watermark Tool</title>
    <meta name="description" content="Add custom text or QR code watermarks to your PDF documents online. Easily secure and brand your PDF files.">
    <%@ include file="header-script.jsp"%>
    <script type="application/ld+json">
        {
            "@context": "http://schema.org",
            "@type": "WebApplication",
            "name": "PDF Watermark Tool",
            "url": "https://8gwifi.org/merge-pdf.jsp",
            "description": "This web application allows users to add custom text or QR code watermarks to PDF documents online, providing an easy way to secure and brand PDF files.",
            "applicationCategory": "Utility",
            "operatingSystem": "All"
        }
    </script>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-5">
    <h2 class="mb-3">Add Watermark into the PDF files</h2>
    <p>This tool allows you to easily add custom text or QR code watermarks to your PDF documents. Secure and brand your PDF files effortlessly.</p>
    <div id="pdfUploader" class="mb-3">
        <div class="mb-2">
            <label for="pdfInput" class="form-label">Upload PDF</label>
            <input type="file" id="pdfInput" accept="application/pdf" class="form-control">
        </div>
        <div class="mb-2">
            <label for="watermarkText" class="form-label">Watermark Text</label>
            <input type="text" id="watermarkText" placeholder="CONFIDENTIAL" value="MADE BY 8GWIFI.ORG" class="form-control">
        </div>
        <div class="mb-2">
            <label for="watermarkColor" class="form-label">Watermark Color</label>
            <input type="color" id="watermarkColor" name="watermarkColor" value="#FF0000" class="form-control">
        </div>
        <div class="mb-2">
            <label for="fontSizeSlider" class="form-label">Font Size</label>
            <input type="range" id="fontSizeSlider" min="10" max="100" value="50" class="form-range">
            <span id="fontSizeValue">50</span>
        </div>
        <div class="mb-2">
            <label for="watermarkPosition" class="form-label">Watermark Position</label>
            <select id="watermarkPosition" class="form-select">
                <option value="center">Center</option>
                <option value="top-left">Top Left</option>
                <option value="top-right">Top Right</option>
                <option value="bottom-left">Bottom Left</option>
                <option value="bottom-right">Bottom Right</option>
            </select>
        </div>
        <div class="mb-2">
            <label for="watermarkType" class="form-label">Watermark Type</label>
            <select id="watermarkType" class="form-select">
                <option value="text">Text</option>
                <option value="qr">QR Code</option>
            </select>
        </div>
        <button class="btn btn-primary" onclick="addWatermark()">Add Watermark</button>
    </div>
    <button id="downloadBtn" class="btn btn-success" style="display:none;">Download Watermarked PDF</button>
    <div id="downloadMessage" class="alert alert-success" style="display: none;">
        Your file has been successfully downloaded.
    </div>
</div>

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
<script src="https://cdn.jsdelivr.net/npm/qrcode@1.4.4/build/qrcode.min.js"></script>
<script src="../js/watermark-pdf.js"></script>
<script>
    document.getElementById('fontSizeSlider').oninput = function() {
        document.getElementById('fontSizeValue').textContent = this.value;
    }
</script>

<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div class="row">
<%@ include file="body-close.jsp"%>


