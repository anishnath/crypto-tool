<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
     <title>URL Shortener - Shorten and Share Your Links Instantly</title>
    <!-- Bootstrap CSS -->
    <%@ include file="header-script.jsp"%>
    
    <meta name="description" content="URL Shortener - Shorten long URLs quickly and effortlessly with our online service. Track your links, generate QR codes, and manage multiple URLs with ease.">
    <meta name="keywords" content="URL Shortener, Shorten URLs, Link Shortener, QR Code Generator, Online Service, Web Tool">
    <script type="application/ld+json">
        {
            "@context": "http://schema.org",
            "@type": "WebApplication",
            "name": "URL Shortener",
            "description": "Shorten long URLs quickly and effortlessly with our online service. Track your links, generate QR codes, and manage multiple URLs with ease.",
            "keywords": "URL Shortener, Shorten URLs, Link Shortener, QR Code Generator, Online Service, Web Tool",
            "url": "https://8gwifi.org/short.jsp",
            "applicationCategory": "Web Application",
            "operatingSystem": "Any",
            "aggregateRating": {
                "@type": "AggregateRating",
                "ratingValue": "4.9",
                "reviewCount": "100"
            },
            "offers": {
                "@type": "Offer",
                "price": "0",
                "priceCurrency": "USD"
            }
        }
    </script>
</head>
<%@ include file="body-script.jsp"%>

<h1 class="mb-4">URL Shortener - Shorten and Share Your Links Instantly</h1>
<hr>

    <div class="container mt-5">
    
        <div class="row">
            <div class="col-md-6 offset-md-3">
                <form id="urlForm">
                    <div class="form-group">
                        <label for="originalUrl">Enter URL:</label>
                        <input type="url" class="form-control" id="originalUrl" name="url" placeholder="Enter your long URL" required>
                        <input type="hidden" name="j_csrf"  id = "j_csrf" value="<%=request.getSession().getId() %>" >
                    </div>
                    <div class="form-group">
                        <label for="group">Enter Group (Optional):</label>
                        <input type="text" class="form-control" value="9R_5SPw" id="group" name="group" placeholder="Enter group name">
                        <small>Keep a unique group name to add multiple url under the same group, keep it unique for future reference </small>
                    </div>
                    <button type="submit" class="btn btn-primary">Shorten or View Analytics</button>
                </form>
                <div id="table-container"></div> 
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and jQuery (optional) -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.rawgit.com/davidshimjs/qrcodejs/gh-pages/qrcode.min.js"></script>

    <script>
    
    function isValidURL(url) {
        // Regular expression for validating an URL
        var urlRegex = /^(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(:[0-9]+)?(\/\S*)?$/;
        return urlRegex.test(url);
    }
    
    function generateShortCode() {
        // Generate a 5-byte array for short code
        var bytes = new Uint8Array(5);
        window.crypto.getRandomValues(bytes);

        // Encode bytes to Base64 without padding
        var base64Chars =
            'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
        var base64 = '';
        for (var i = 0; i < bytes.length; i += 3) {
            var chunk = (bytes[i] << 16) | (bytes[i + 1] << 8) | bytes[i + 2];
            for (var j = 0; j < 4; j++) {
                if (i * 8 + j * 6 <= bytes.length * 8) {
                    base64 += base64Chars.charAt((chunk >> 6 * (3 - j)) & 0x3f);
                } else {
                    base64 += '=';
                }
            }
        }
        return base64;
    }
    
 // Set group input field value to the generated short code when the page loads
    window.onload = function() {
        var generatedShortCode = generateShortCode();
        document.getElementById("group").value = generatedShortCode;
    };


    
        document.getElementById("urlForm").addEventListener("submit", function(event) {
            event.preventDefault();
            var originalUrl = document.getElementById("originalUrl").value;
            var group = document.getElementById("group").value;
            var j_csrf = document.getElementById("j_csrf").value;
            
            if (!isValidURL(originalUrl)) {
                // Display an alert box for invalid URL
                alert("URL Invalid");
                return;
            }
            
            fetch("s", {
                method: "POST",
                body: "url=" + encodeURIComponent(originalUrl) + "&group=" + group + "&j_csrf=" + j_csrf,
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                }
            })
            .then(response => response.json()) // Parse JSON response
            .then(data => {
            	
            	
            	
            	
            	var lurls = data.lurls
            	var currentUrl = window.location.href;
            	var shortenedUrl = currentUrl.replace("short.jsp", data.shortUrl);
            	                
                
                // Header properties
                var headerProperties = ['Click Count', 'Short URL', 'QR Code'];

                // Create a new table
                var table = document.createElement('table');
                table.className = 'table';

                // Create table header
                var tableHeader = document.createElement('thead');
                var headerRow = document.createElement('tr');

                headerProperties.forEach(function (property) {
                    var headerCell = document.createElement('th');
                    headerCell.innerText = property;
                    headerRow.appendChild(headerCell);
                });

                tableHeader.appendChild(headerRow);
                table.appendChild(tableHeader);

                // Create table body and add data rows
                var tableBody = document.createElement('tbody');
                var dataValues = [data.clickCount, shortenedUrl];

                var dataRow = document.createElement('tr');
                dataValues.forEach(function (value, index) {
                    var valueCell = document.createElement('td');
                    if (index === 1) {
                        // Add shortened URL as a link with target blank
                        var link = document.createElement('a');
                        link.href = value;
                        link.target = '_blank';
                        link.textContent = value;
                        valueCell.appendChild(link);
                    } else {
                        // Add other values directly
                        valueCell.innerText = value;
                    }
                    //valueCell.innerText = value;
                    dataRow.appendChild(valueCell);
                });

                // Create QR Code cell
                var qrCodeCell = document.createElement('td');
                var qrCodeDiv = document.createElement('div');
                var qr = new QRCode(qrCodeDiv, {
                    text: shortenedUrl,
                    width: 128,
                    height: 128
                });

                qrCodeCell.appendChild(qrCodeDiv);
                dataRow.appendChild(qrCodeCell);

                tableBody.appendChild(dataRow);
                table.appendChild(tableBody);

                // Append the table to the container
                var tableContainer = document.getElementById('table-container');
                tableContainer.innerHTML = '';
                tableContainer.appendChild(table);
                
                
                // This Logic conatins more url 
                var container = document.getElementById('table-container');
                
                var heading = document.createElement('h4');
                heading.textContent = 'URLs belong to this Group [' + data.group + "]";
                container.appendChild(heading);
                
                var table = document.createElement('table');
                table.className = 'table';
             // Create table header
                var thead = document.createElement('thead');
                var headerRow = thead.insertRow();
                var headers = ['Click Count', 'Original URL', 'Short URL'];
                
                headers.forEach(function(headerText) {
                    var headerCell = document.createElement('th');
                    headerCell.textContent = headerText;
                    headerRow.appendChild(headerCell);
                });
                table.appendChild(thead);
                
                
                
             // Create table body
                var tbody = document.createElement('tbody');
                lurls.forEach(function(item) {
                    var row = tbody.insertRow();
                    var cell1 = row.insertCell(0);
                    var cell2 = row.insertCell(1);
                    var cell3 = row.insertCell(2);

                    cell1.textContent = item.clickCount;
                    cell2.innerHTML = '<code>' + item.originalUrl + '</code>';
                    shortenedUrl =  currentUrl.replace("short.jsp", "s/" + item.shortCode);
                    console.log(shortenedUrl)
                 // Add shortened URL as a link with target blank
                    cell3.innerHTML = '<a href="' + shortenedUrl + '" target="_blank">' + item.shortCode + '</a>';

                    
                 // Generate QR code for shortenedUrl and add it to the row
                    var qrCodeCell = document.createElement('td');
                    var qrCodeDiv = document.createElement('div');
                    var qr = new QRCode(qrCodeDiv, {
                        text: shortenedUrl,
                        width: 128,
                        height: 128
                    });
                    qrCodeCell.appendChild(qrCodeDiv);
                    row.appendChild(qrCodeCell);
                });

                table.appendChild(tbody);

                // Append the table to the container
                container.appendChild(table);
                
                
            })
            .catch(error => console.error(error));
        });
    </script>
<hr>
<p>Welcome to our advanced URL Shortener service! Need to share long, cumbersome URLs quickly and effortlessly? Look no further. Our user-friendly online tool lets you shorten URLs with a click, making them neat and easy to share. Not just that, you can track the performance of your links, generate QR codes for seamless sharing, and manage multiple URLs effortlessly. Experience the power of simplicity – shorten your URLs hassle-free, monitor their effectiveness, and enhance your online experience with our cutting-edge URL Shortener.</p>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
