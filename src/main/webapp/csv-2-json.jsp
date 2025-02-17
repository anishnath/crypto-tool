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
    <title>CSV to JSON Converter</title>
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "SoftwareApplication",
            "name": "CSV to JSON/YAML Converter",
            "description": "A tool to convert CSV data into JSON and YAML formats, display the results, and provide download options.",
            "applicationCategory": "WebApplication",
            "operatingSystem": "All"
        }
    </script>
    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
<h2 class="mb-3">CSV to JSON Converter</h2>
<input type="file" id="csvFile" class="form-control mb-3" accept="text/csv">
<textarea id="csvText" class="form-control mb-3" rows="5" placeholder="Paste CSV here"></textarea>
<label class="form-label">Delimiter for Arrays (optional, e.g., ; )</label>
<input type="text" id="delimiter" class="form-control mb-3" placeholder="Leave blank for normal K,V handling">
<button class="btn btn-primary mb-3" onclick="convertFromFile()">Convert from File</button>
<button class="btn btn-secondary mb-3" onclick="convertFromText()">Convert from Pasted CSV</button>
<p id="error-message" class="text-danger" style="display: none;"></p>
<a id="downloadJson" class="btn btn-success mb-3" style="display:none">Download JSON</a>
<button class="btn btn-info mb-3" onclick="copyToClipboard()">Copy JSON</button>
<pre id="jsonOutput" class="bg-light p-3 border" style="display:none; white-space: pre-wrap;"></pre>

<script>
    function convertFromFile() {
        const fileInput = document.getElementById('csvFile');
        const file = fileInput.files[0];
        if (!file) {
            alert("Please upload a CSV file.");
            return;
        }
        const reader = new FileReader();
        reader.onload = function(event) {
            processCsv(event.target.result);
        };
        reader.readAsText(file);
    }

    function convertFromText() {
        const csvText = document.getElementById('csvText').value;
        if (!csvText.trim()) {
            alert("Please paste CSV data.");
            return;
        }
        processCsv(csvText);
    }

    function processCsv(csvString) {
        const delimiterInput = document.getElementById('delimiter').value.trim();
        const delimiter = delimiterInput ? delimiterInput : null;
        const rows = csvString.trim().split("\n");
        const headers = rows.shift().split(",");
        const jsonData = rows.map(row => {
            const values = row.split(",");
            let obj = {};
            headers.forEach((header, index) => {
                let value = values[index].trim();
                if (delimiter && value.includes(delimiter)) {
                    value = value.split(delimiter).map(item => item.trim());
                }
                obj[header] = value;
            });
            return obj;
        });
        displayJson(jsonData);
        downloadJson(jsonData);
    }

    function displayJson(jsonData) {
        const jsonOutput = document.getElementById('jsonOutput');
        jsonOutput.textContent = JSON.stringify(jsonData, null, 2);
        jsonOutput.style.display = "block";
    }

    function displayYaml(jsonData) {
        const yamlOutput = document.getElementById('yamlOutput');
        yamlOutput.textContent = jsonToYaml(jsonData);
        yamlOutput.style.display = "block";
    }

    function downloadJson(jsonData) {
        const blob = new Blob([JSON.stringify(jsonData, null, 2)], { type: "application/json" });
        const url = URL.createObjectURL(blob);
        const downloadLink = document.getElementById('downloadJson');
        downloadLink.href = url;
        downloadLink.download = "converted.json";
        downloadLink.style.display = "block";
        downloadLink.innerText = "Download JSON";
    }

    function downloadYaml(jsonData) {
        const yaml = jsonToYaml(jsonData);
        const blob = new Blob([yaml], { type: "text/yaml" });
        const url = URL.createObjectURL(blob);
        const downloadLink = document.getElementById('downloadYaml');
        downloadLink.href = url;
        downloadLink.download = "converted.yaml";
        downloadLink.style.display = "block";
        downloadLink.innerText = "Download YAML";
    }

    function jsonToYaml(jsonData) {
        return jsonData.map(obj => {
            return Object.entries(obj)
                .map(([key, value]) => `${key}: ${Array.isArray(value) ? "[ " + value.join(", ") + " ]" : value}`)
                .join("\n");
        }).join("\n---\n");
    }

    function copyToClipboard() {
        const jsonOutput = document.getElementById('jsonOutput');
        navigator.clipboard.writeText(jsonOutput.textContent).then(() => {
            alert("JSON copied to clipboard!");
        }).catch(err => {
            alert("Failed to copy JSON: " + err);
        });
    }

    function copyYamlToClipboard() {
        const yamlOutput = document.getElementById('yamlOutput');
        navigator.clipboard.writeText(yamlOutput.textContent).then(() => {
            alert("YAML copied to clipboard!");
        }).catch(err => {
            alert("Failed to copy YAML: " + err);
        });
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
            <li><a href="json-2-csv.jsp">JSON-2-CSV</a></li>
        </ul>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
