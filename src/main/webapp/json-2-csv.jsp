<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    <meta name="googlebot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />
    <title>JSON to CSV Converter</title>
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "SoftwareApplication",
            "name": "JSON to CSV Converter",
            "description": "A tool to convert JSON data into CSV format and display it in a table.",
            "applicationCategory": "WebApplication",
            "operatingSystem": "All"
        }
    </script>
    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
<h2 class="mb-3">JSON to CSV Converter</h2>
<input type="file" id="jsonFile" class="form-control mb-3" accept="application/json">
<input type="text" id="jsonUrl" class="form-control mb-3" placeholder="Enter JSON URL">
<textarea id="jsonText" class="form-control mb-3" rows="5" placeholder="Paste JSON here"></textarea>
<button class="btn btn-primary mb-3" onclick="convertFromFile()">Convert from File</button>
<button class="btn btn-secondary mb-3" onclick="convertFromUrl()">Convert from URL</button>
<button class="btn btn-info mb-3" onclick="convertFromText()">Convert from Pasted JSON</button>
<p id="error-message" class="text-danger" style="display: none;"></p>
<br>
<a id="downloadLink" class="btn btn-success mb-3" style="display:none">Download CSV</a>
<div class="table-responsive">
    <table class="table table-bordered" id="csvTable" style="display:none;">
        <thead class="table-dark" id="tableHead"></thead>
        <tbody id="tableBody"></tbody>
    </table>
</div>

<script>
    function convertFromFile() {
        const fileInput = document.getElementById('jsonFile');
        const file = fileInput.files[0];
        if (!file) {
            alert("Please upload a JSON file.");
            return;
        }

        const reader = new FileReader();
        reader.onload = function(event) {
            processJson(event.target.result);
        };
        reader.readAsText(file);
    }

    function convertFromUrl() {
        const url = document.getElementById('jsonUrl').value;
        if (!url) {
            alert("Please enter a valid JSON URL.");
            return;
        }

        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Failed to fetch JSON from the server.");
                }
                return response.json();
            })
            .then(jsonData => processJson(JSON.stringify(jsonData)))
            .catch(error => {
                console.error("Error fetching JSON:", error);
                document.getElementById("error-message").textContent = "Failed to fetch JSON. Possible CORS issue. Try downloading the JSON file manually and uploading it.";
                document.getElementById("error-message").style.display = "block";
            });
    }

    function convertFromText() {
        const jsonText = document.getElementById('jsonText').value;
        if (!jsonText.trim()) {
            alert("Please paste JSON data.");
            return;
        }
        processJson(jsonText);
    }

    function processJson(jsonString) {
        try {
            const jsonData = JSON.parse(jsonString);
            const csv = convertJsonToCsv(jsonData);
            displayTable(jsonData);
            downloadCsv(csv);
            document.getElementById("error-message").style.display = "none";
        } catch (error) {
            alert("Invalid JSON file.");
        }
    }

    function convertJsonToCsv(jsonData) {
        let dataArray = [];
        if (Array.isArray(jsonData)) {
            dataArray = jsonData;
        } else if (typeof jsonData === 'object') {
            for (const key in jsonData) {
                if (Array.isArray(jsonData[key])) {
                    dataArray = jsonData[key];
                    break;
                }
            }
        }
        if (dataArray.length === 0) {
            alert("No valid array found in JSON.");
            return "";
        }

        const headers = Object.keys(dataArray[0]);
        const csvRows = [];
        csvRows.push(headers.join(","));

        dataArray.forEach(obj => {
            const values = headers.map(header => {
                if (Array.isArray(obj[header])) {
                    return '"' + obj[header].join("; ") + '"';
                }
                return JSON.stringify(obj[header] || "");
            });
            csvRows.push(values.join(","));
        });

        return csvRows.join("\n");
    }

    function displayTable(jsonData) {
        let dataArray = [];
        if (Array.isArray(jsonData)) {
            dataArray = jsonData;
        } else if (typeof jsonData === 'object') {
            for (const key in jsonData) {
                if (Array.isArray(jsonData[key])) {
                    dataArray = jsonData[key];
                    break;
                }
            }
        }
        if (dataArray.length === 0) return;

        const table = document.getElementById("csvTable");
        const tableHead = document.getElementById("tableHead");
        const tableBody = document.getElementById("tableBody");

        tableHead.innerHTML = "";
        tableBody.innerHTML = "";

        const headers = Object.keys(dataArray[0]);
        const headerRow = document.createElement("tr");
        headers.forEach(header => {
            const th = document.createElement("th");
            th.textContent = header;
            headerRow.appendChild(th);
        });
        tableHead.appendChild(headerRow);

        dataArray.forEach(row => {
            const tr = document.createElement("tr");
            headers.forEach(header => {
                const td = document.createElement("td");
                td.textContent = Array.isArray(row[header]) ? row[header].join("; ") : row[header];
                tr.appendChild(td);
            });
            tableBody.appendChild(tr);
        });

        table.style.display = "table";
    }

    function downloadCsv(csv) {
        const blob = new Blob([csv], { type: "text/csv" });
        const url = URL.createObjectURL(blob);
        const downloadLink = document.getElementById('downloadLink');
        downloadLink.href = url;
        downloadLink.download = "converted.csv";
        downloadLink.style.display = "block";
        downloadLink.innerText = "Download CSV";
    }
</script>
<hr>
<div class="sharethis-inline-share-buttons"></div>

<hr>
<h2 class="mt-4">Try Other Convertor</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="yamlparser.jsp">YAML-2-JSON/XML</a></li>
            <li><a href="xml2json.jsp">XML-2-JSON/YAML</a></li>
            <li><a href="jsonparser.jsp">JSON-2-YAML/XML</a></li>
            <li><a href="csv-2-json.jsp">CSV-2-JSON</a></li>
        </ul>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
