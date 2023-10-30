<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Generate random strings and numbers with different options and lengths using this online tool. Choose from various character sets and customize the length. Fast and easy random string and number generator.">
    <meta name="keywords" content="random generator, string generator, number generator, random characters, utility tool">
   
    <title>Random String and Number Generator</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
    <style>
        #downloadLink {
            display: none;
        }
    </style>
    
    <script type="application/ld+json">
{
    "@context": "http://schema.org",
    "@type": "WebApplication",
    "name": "Random String and Number Generator",
    "description": "Generate random strings and numbers with different options and lengths.",
    "version": "1.0.0",
    "operatingSystem": "Any",
    "applicationCategory": "Utility",
    "keywords": "random generator, string generator, number generator, random characters, utility tool",
    "url": "https://8gwifi.org/random-string.jsp"
}
</script>
    
    
</head>

<%@ include file="body-script.jsp"%>
    <div class="container mt-5">
        <h1 class="mb-4">Random String and Number Generator</h1>
        <form id="randomGeneratorForm">
            <div class="form-group">
                <label for="options">Select Options:</label>
                <select class="form-control" id="options" name="options">
                    <option value="lowercase">a-z lowercase</option>
                    <option value="uppercase">A-Z uppercase</option>
                    <option value="mixedcase">a-zA-Z mixed case</option>
                    <option value="lowercaseNumbers">a-z0-9 lowercase</option>
                    <option value="uppercaseNumbers">A-Z0-9 uppercase</option>
                    <option value="mixedcaseNumbers">a-zA-Z0-9 mixed case</option>
                    <option value="numbers">0-9 numbers</option>
                </select>
            </div>
            <div class="form-group">
                <label for="length">Length:</label>
                <input type="number" class="form-control" id="length" name="length" value="64" min="1">
            </div>
            <div class="form-group">
                <label for="numOutputs">Number of Outputs:</label>
                <input type="number" class="form-control" id="numOutputs" name="numOutputs" value="1" min="1">
            </div>
            <button type="button" class="btn btn-primary" id="generateBtn">Generate</button>
        </form>
        <div class="form-group">
            <label for="generatedStrings">Generated String(s):</label>
            <textarea class="form-control" id="generatedStrings" rows="5" readonly></textarea>
        </div>

        <div class="form-group">
            <a id="downloadLink" class="btn btn-secondary" download="generated_strings.txt">Download</a>
            <button id="copyBtn" class="btn btn-secondary" disabled>Copy to Clipboard</button>
        </div>

        <div class="form-group">
            
        </div>
    </div>

    <!-- jQuery and Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <script>
        document.getElementById('generateBtn').addEventListener('click', function () {
            var options = document.getElementById('options').value;
            var length = document.getElementById('length').value;
            var numOutputs = document.getElementById('numOutputs').value;
            var generatedStrings = [];

            for (var j = 0; j < numOutputs; j++) {
                var generatedString = '';
                var characters = '';

                if (options === 'custom') {
                    generatedString = customString.substring(0, length);
                } else {
                    if (options.includes('lowercase')) {
                        characters += 'abcdefghijklmnopqrstuvwxyz';
                    }
                    if (options.includes('uppercase')) {
                        characters += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                    }
                    if (options.includes('mixedcase')) {
                        characters += 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
                    }
                    if (options.includes('numbers')) {
                        characters += '0123456789';
                    }
                    if (options.includes('lowercaseNumbers')) {
                        characters += 'abcdefghijklmnopqrstuvwxyz0123456789';
                    }
                    if (options.includes('uppercaseNumbers')) {
                        characters += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
                    }
                    if (options.includes('mixedcaseNumbers')) {
                        characters += 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
                    }

                    for (var i = 0; i < length; i++) {
                        generatedString += characters.charAt(Math.floor(Math.random() * characters.length));
                    }
                }

                generatedStrings.push(generatedString);
            }
            var generatedStringsTextarea = document.getElementById('generatedStrings');
            generatedStringsTextarea.value = generatedStrings.join('\n');
            generatedStringsTextarea.rows = generatedStrings.length;

            // var blob = new Blob([generatedStrings.join('\n')], { type: 'text/plain' });
            // var downloadLink = document.getElementById('downloadLink');
            // downloadLink.href = URL.createObjectURL(blob);

            var downloadLink = document.getElementById('downloadLink');
             if (generatedStrings.length > 0) {
                downloadLink.style.display = 'inline-block';
                copyBtn.removeAttribute('disabled');
                // Create a Blob with the generated strings
                var blob = new Blob([generatedStrings.join('\n')], { type: 'text/plain' });
                // Set the download link's href to the Blob URL
                downloadLink.href = URL.createObjectURL(blob);

                copyBtn.addEventListener('click', function() {
                    generatedStringsTextarea.select();
                    document.execCommand('copy');
                });

            } else {
                // Hide the download button if there is no generated data
                downloadLink.style.display = 'none';
            }
            
        });
    </script>

  <div class="card my-4">
            <h5 class="card-header">Try Other Convertor</h5>
            <div class="card-body">
              <div class="row">
                <div>
                <ul>
                    <li><a href="qrcodegen.jsp">QR Code Generate</a></li>
                    <li><a href="hexdump.jsp">Online Hexdump Generate</a></li>
                    <li><a href="diff.jsp">Compare text differences</a></li>
                    <li><a href="UrlEncodeDecodeFunctions.jsp">URL Encoders/Decoders</a></li>
                    <li><a href="HexToStringFunctions.jsp">Hex To String Conversion</a></li>
                    <li><a href="HexToStringFunctions.jsp">String To Hex Conversion</a></li>
                    <li><a href="base64Hex.jsp">Base64 To Hex (ViceVersa)</a></li>
                    <li><a href="Base64Functions.jsp">Base64 Encode/Decode</a></li>
                    <li><a href="base64image.jsp">Base64 Image Converter(data:image/png)</a></li>
                    <li><a href="StringFunctions.jsp">Various String Functions</a></li>
                    <li><a href="jsonparser.jsp">JSON-2-YAML/XML</a></li>
                    <li><a href="yamlparser.jsp">YAML-2-JSON/XML</a></li>
                    <li><a href="xml2json.jsp">XML-2-JSON/YAML</a></li>
                    <li><a href="random-string.jsp">Random Number Generator</a></li>
                    <li><a href="contactus.jsp">Feature Request</a></li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
    
<%@ include file="addcomments.jsp"%>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
