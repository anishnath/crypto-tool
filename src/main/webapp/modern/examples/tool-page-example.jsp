<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%--
    Example Tool Page with Full SEO
    This shows how to implement a tool page with maximum SEO
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- SEO for Tool Page -->
    <jsp:include page="../components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Base64 Encoder/Decoder" />
        <jsp:param name="toolDescription" value="Encode text or binary data to Base64 format and decode Base64 strings back to original data. Supports UTF-8 encoding, works with images, files, and text. Fast, secure, client-side processing." />
        <jsp:param name="toolCategory" value="Encoders & Converters" />
        <jsp:param name="toolUrl" value="Base64Functions.jsp" />
        <jsp:param name="toolKeywords" value="base64, encode, decode, converter, online, base64 encoder, base64 decoder, base64 string, base64 image" />
        <jsp:param name="hasSteps" value="true" />
    </jsp:include>

    <!-- Modern Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

    <!-- Design System -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css">
    
    <!-- Ad System -->
    <%@ include file="../ads/ad-init.jsp" %>

    <%@ include file="../../header-script.jsp"%>
</head>

<body>
    <!-- Navigation -->
    <%@ include file="../components/nav-header.jsp" %>

    <!-- Breadcrumbs -->
    <nav class="breadcrumbs" aria-label="Breadcrumb">
        <div class="breadcrumbs-container">
            <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
            <span class="breadcrumb-separator">/</span>
            <a href="<%=request.getContextPath()%>/index.jsp#encoders">Encoders</a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">Base64 Encoder/Decoder</span>
        </div>
    </nav>

    <!-- Tool Header -->
    <header class="tool-header">
        <div class="tool-header-container">
            <div class="tool-header-content">
                <h1 class="tool-page-title">Base64 Encoder/Decoder</h1>
                <p class="tool-page-description">Encode text or binary data to Base64 format and decode Base64 strings back to original data. Supports UTF-8 encoding, works with images, files, and text. Fast, secure, client-side processing.</p>
                <div class="tool-meta">
                    <span class="tool-category-badge">Encoders & Converters</span>
                    <span class="tool-badge">✓ Free</span>
                    <span class="tool-badge">🔒 Secure</span>
                    <span class="tool-badge">⚡ Client-Side</span>
                    <span class="tool-badge">⭐⭐⭐⭐⭐ 4.8</span>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="tool-main">
        <div class="tool-container">
            
            <!-- Tool Form -->
            <div class="tool-form-card">
                <h2>Encode/Decode</h2>
                
                <div class="input-group">
                    <label class="input-label">Input Text</label>
                    <textarea class="textarea-field" id="inputText" placeholder="Enter text to encode or Base64 string to decode"></textarea>
                </div>

                <div style="display: flex; gap: 1rem; margin-bottom: 1rem;">
                    <button class="btn-primary" onclick="encodeBase64()">Encode to Base64</button>
                    <button class="btn-primary" onclick="decodeBase64()">Decode from Base64</button>
                    <button class="btn-secondary" onclick="clearFields()">Clear</button>
                </div>

                <div class="input-group">
                    <label class="input-label">Result</label>
                    <textarea class="textarea-field" id="outputText" readonly placeholder="Result will appear here"></textarea>
                </div>
            </div>

            <!-- Results Card -->
            <div class="results-card" id="resultsCard" style="display: none;">
                <h3>Result</h3>
                <div class="result-output" id="resultOutput"></div>
            </div>

            <!-- How It Works Section (Important for SEO) -->
            <div class="tool-form-card" style="margin-top: 2rem;">
                <h2>How It Works</h2>
                <ol style="line-height: 2; padding-left: 1.5rem;">
                    <li><strong>Enter your data:</strong> Paste text, Base64 string, or upload a file</li>
                    <li><strong>Choose operation:</strong> Click "Encode" to convert to Base64 or "Decode" to convert from Base64</li>
                    <li><strong>Get results:</strong> The converted data appears instantly in the result field</li>
                    <li><strong>Copy and use:</strong> Copy the result to use in your application or code</li>
                </ol>
            </div>

            <!-- FAQ Section (Critical for Rich Snippets) -->
            <div class="tool-form-card" style="margin-top: 2rem;">
                <h2>Base64 Encoder/Decoder - FAQ</h2>
                
                <div style="margin-top: 1.5rem;">
                    <h3 style="font-size: 1.125rem; margin-bottom: 0.5rem;">What is Base64 encoding?</h3>
                    <p style="color: var(--text-secondary, #475569); line-height: 1.7;">Base64 is an encoding scheme that converts binary data into ASCII text format. It's commonly used to encode data for transfer over media that only supports text, such as email or JSON.</p>
                </div>

                <div style="margin-top: 1.5rem;">
                    <h3 style="font-size: 1.125rem; margin-bottom: 0.5rem;">Is Base64 encryption?</h3>
                    <p style="color: var(--text-secondary, #475569); line-height: 1.7;">No, Base64 is encoding, not encryption. It can be decoded by anyone. For security, use encryption tools like AES or RSA.</p>
                </div>

                <div style="margin-top: 1.5rem;">
                    <h3 style="font-size: 1.125rem; margin-bottom: 0.5rem;">What characters does Base64 use?</h3>
                    <p style="color: var(--text-secondary, #475569); line-height: 1.7;">Base64 uses 64 characters: A-Z, a-z, 0-9, plus (+), and slash (/). The equals sign (=) is used for padding.</p>
                </div>

                <div style="margin-top: 1.5rem;">
                    <h3 style="font-size: 1.125rem; margin-bottom: 0.5rem;">Can I encode images to Base64?</h3>
                    <p style="color: var(--text-secondary, #475569); line-height: 1.7;">Yes, this tool supports encoding images and binary files to Base64 format. Use the file upload feature or paste image data.</p>
                </div>

                <div style="margin-top: 1.5rem;">
                    <h3 style="font-size: 1.125rem; margin-bottom: 0.5rem;">Is my data secure?</h3>
                    <p style="color: var(--text-secondary, #475569); line-height: 1.7;">Yes, all processing happens in your browser. Your data never leaves your device, ensuring complete privacy and security.</p>
                </div>
            </div>

            <!-- FAQ JSON-LD (Must match visible FAQ) -->
            <script type="application/ld+json">
            {
              "@context": "https://schema.org",
              "@type": "FAQPage",
              "mainEntity": [
                {
                  "@type": "Question",
                  "name": "What is Base64 encoding?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Base64 is an encoding scheme that converts binary data into ASCII text format. It's commonly used to encode data for transfer over media that only supports text, such as email or JSON."
                  }
                },
                {
                  "@type": "Question",
                  "name": "Is Base64 encryption?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "No, Base64 is encoding, not encryption. It can be decoded by anyone. For security, use encryption tools like AES or RSA."
                  }
                },
                {
                  "@type": "Question",
                  "name": "What characters does Base64 use?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Base64 uses 64 characters: A-Z, a-z, 0-9, plus (+), and slash (/). The equals sign (=) is used for padding."
                  }
                },
                {
                  "@type": "Question",
                  "name": "Can I encode images to Base64?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, this tool supports encoding images and binary files to Base64 format. Use the file upload feature or paste image data."
                  }
                },
                {
                  "@type": "Question",
                  "name": "Is my data secure?",
                  "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, all processing happens in your browser. Your data never leaves your device, ensuring complete privacy and security."
                  }
                }
              ]
            }
            </script>
        </div>
    </main>

    <!-- In-Content Ad -->
    <%@ include file="../ads/ad-in-content-mid.jsp" %>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">© 2024 8gwifi.org - Free Online Tools for Developers</p>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="<%=request.getContextPath()%>/modern/js/search.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
    <script>
        function encodeBase64() {
            const input = document.getElementById('inputText').value;
            if (!input) {
                alert('Please enter text to encode');
                return;
            }
            try {
                const encoded = btoa(unescape(encodeURIComponent(input)));
                document.getElementById('outputText').value = encoded;
                document.getElementById('resultsCard').style.display = 'block';
                document.getElementById('resultOutput').textContent = encoded;
            } catch (e) {
                alert('Error encoding: ' + e.message);
            }
        }

        function decodeBase64() {
            const input = document.getElementById('inputText').value.trim();
            if (!input) {
                alert('Please enter Base64 string to decode');
                return;
            }
            try {
                const decoded = decodeURIComponent(escape(atob(input)));
                document.getElementById('outputText').value = decoded;
                document.getElementById('resultsCard').style.display = 'block';
                document.getElementById('resultOutput').textContent = decoded;
            } catch (e) {
                alert('Error decoding: ' + e.message);
            }
        }

        function clearFields() {
            document.getElementById('inputText').value = '';
            document.getElementById('outputText').value = '';
            document.getElementById('resultsCard').style.display = 'none';
        }
    </script>
</body>
</html>

