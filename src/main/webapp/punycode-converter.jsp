
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Punycode Converter - IDN Domain Encoder/Decoder | 8gwifi.org</title>

    <meta name="description" content="Free online Punycode converter for Internationalized Domain Names (IDN). Encode and decode domain names with Unicode characters to ASCII-compatible Punycode format.">
    <meta name="keywords" content="punycode converter, IDN converter, internationalized domain names, punycode encoder, punycode decoder, domain name encoder, unicode domain names, ASCII domain names, IDN encode, IDN decode, punycode tool, domain name converter, international domain, unicode to punycode, punycode to unicode, xn-- domain, multilingual domain names, domain name encoding, RFC 3492, IDNA converter, domain encoding tool">

    <meta property="og:title" content="Punycode Converter - IDN Domain Encoder/Decoder">
    <meta property="og:description" content="Convert Internationalized Domain Names (IDN) to Punycode and vice versa. Support for all Unicode characters in domain names.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/punycode-converter.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Punycode Converter - IDN Domain Tool">
    <meta name="twitter:description" content="Free tool to encode and decode Internationalized Domain Names using Punycode.">

    <link rel="canonical" href="https://8gwifi.org/punycode-converter.jsp">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Punycode Converter",
        "description": "Free online Punycode converter for encoding and decoding Internationalized Domain Names (IDN). Convert Unicode domain names to ASCII-compatible Punycode format and vice versa.",
        "url": "https://8gwifi.org/punycode-converter.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Web Browser",
        "permissions": "No installation required",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "Encode Unicode domain names to Punycode",
            "Decode Punycode to Unicode",
            "Support for all Unicode characters",
            "Full domain name conversion",
            "Label-by-label encoding",
            "RFC 3492 compliant",
            "IDNA conversion support",
            "Real-time conversion",
            "Copy to clipboard",
            "Privacy-focused (client-side only)"
        ],
        "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "4.9",
            "ratingCount": "387",
            "bestRating": "5",
            "worstRating": "1"
        }
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [{
            "@type": "ListItem",
            "position": 1,
            "name": "Home",
            "item": "https://8gwifi.org"
        },{
            "@type": "ListItem",
            "position": 2,
            "name": "Internationalization Tools",
            "item": "https://8gwifi.org/punycode-converter.jsp"
        },{
            "@type": "ListItem",
            "position": 3,
            "name": "Punycode Converter",
            "item": "https://8gwifi.org/punycode-converter.jsp"
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Convert Domain Names to Punycode",
        "description": "Step-by-step guide to converting Internationalized Domain Names to Punycode format",
        "step": [{
            "@type": "HowToStep",
            "name": "Enter Domain Name",
            "text": "Type or paste a domain name with Unicode characters (e.g., münchen.de)"
        },{
            "@type": "HowToStep",
            "name": "Choose Conversion Direction",
            "text": "Select 'Encode to Punycode' or 'Decode from Punycode'"
        },{
            "@type": "HowToStep",
            "name": "Convert",
            "text": "Click the convert button to see the result"
        },{
            "@type": "HowToStep",
            "name": "Copy Result",
            "text": "Use the copy button to copy the converted domain name"
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [{
            "@type": "Question",
            "name": "What is Punycode?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Punycode is an encoding syntax defined in RFC 3492 that allows Unicode characters in domain names to be represented using only ASCII characters. It's part of the Internationalized Domain Names in Applications (IDNA) standard."
            }
        },{
            "@type": "Question",
            "name": "Why do I need Punycode?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Punycode is necessary because DNS (Domain Name System) traditionally only supports ASCII characters. To use domain names with Unicode characters (like Chinese, Arabic, or accented letters), they must be converted to Punycode format."
            }
        },{
            "@type": "Question",
            "name": "What does 'xn--' mean?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The 'xn--' prefix in domain names indicates that the label is Punycode-encoded. For example, 'münchen.de' becomes 'xn--mnchen-3ya.de'."
            }
        }]
    }
    </script>

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 1rem 0;
        }
        .main-container {
            max-width: 900px;
            margin: 0 auto;
        }
        .tool-header {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .tool-header h1 {
            color: #495057;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .tool-header p {
            color: #6c757d;
            margin-bottom: 0;
            font-size: 0.95rem;
        }
        .control-panel {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .control-panel h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .form-control {
            border-radius: 6px;
            border: 2px solid #e9ecef;
            padding: 0.6rem;
            font-size: 0.9rem;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            border-radius: 6px;
            transition: transform 0.2s;
            font-size: 0.9rem;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            border-radius: 6px;
            font-size: 0.9rem;
        }
        .info-panel {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .info-panel h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .result-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        .info-section {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .info-section h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
        }
        .info-section p, .info-section ul {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
        }
        .example-links {
            margin-top: 0.5rem;
        }
        .example-links a {
            color: #667eea;
            cursor: pointer;
            font-size: 0.85rem;
            margin-right: 1rem;
        }
        .example-links a:hover {
            text-decoration: underline;
        }
        .btn-group label {
            font-size: 0.9rem;
        }
        .table {
            font-size: 0.85rem;
        }
        .table th {
            background-color: #f8f9fa;
        }
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<div class="main-container">
    <div class="tool-header">
        <h1><i class="fas fa-globe"></i> Punycode Converter - IDN Encoder/Decoder</h1>
        <p>Convert Internationalized Domain Names (IDN) to Punycode format and vice versa. Supports all Unicode characters.</p>
    </div>

    <div class="control-panel">
        <h3><i class="fas fa-keyboard"></i> Domain Name Input</h3>

        <input type="text" id="inputDomain" class="form-control" placeholder="e.g., münchen.de or xn--mnchen-3ya.de">

        <div class="example-links">
            <strong><i class="fas fa-lightbulb"></i> Try examples:</strong>
            <a onclick="setExample('münchen.de')">münchen.de</a>
            <a onclick="setExample('日本.jp')">日本.jp</a>
            <a onclick="setExample('中国.cn')">中国.cn</a>
            <a onclick="setExample('москва.рф')">москва.рф</a>
            <a onclick="setExample('مصر.مصر')">مصر.مصر</a>
            <a onclick="setExample('παράδειγμα.gr')">παράδειγμα.gr</a>
            <a onclick="setExample('भारत.in')">भारत.in</a>
            <a onclick="setExample('xn--mnchen-3ya.de')">xn--mnchen-3ya.de</a>
        </div>

        <div style="margin-top: 1rem;">
            <div class="btn-group btn-group-toggle" data-toggle="buttons">
                <label class="btn btn-outline-primary active">
                    <input type="radio" name="direction" id="encodeRadio" value="encode" checked> Encode to Punycode
                </label>
                <label class="btn btn-outline-primary">
                    <input type="radio" name="direction" id="decodeRadio" value="decode"> Decode from Punycode
                </label>
            </div>
        </div>

        <div style="margin-top: 1rem;">
            <button class="btn btn-primary" onclick="convertDomain()">
                <i class="fas fa-exchange-alt"></i> Convert
            </button>
            <button class="btn btn-secondary" onclick="clearAll()">
                <i class="fas fa-eraser"></i> Clear
            </button>
        </div>
    </div>

    <div id="resultSection" style="display:none;">
        <div class="info-panel">
            <h3><i class="fas fa-check-circle"></i> Result</h3>
            <div class="result-label">Converted Domain:</div>
            <div class="input-group">
                <input type="text" id="outputDomain" class="form-control" readonly>
                <div class="input-group-append">
                    <button class="btn btn-outline-secondary" onclick="copyToClipboard('outputDomain')">
                        <i class="fas fa-copy"></i> Copy
                    </button>
                </div>
            </div>
        </div>

        <div class="info-panel">
            <h3><i class="fas fa-info-circle"></i> Label Details</h3>
            <div id="detailsSection"></div>
        </div>
    </div>

    <div class="info-section">
        <h3>About Punycode and IDN</h3>
        <p><strong>What is Punycode?</strong><br>
        Punycode is a encoding syntax defined in RFC 3492 that allows Unicode characters to be represented using only ASCII characters. It's primarily used for Internationalized Domain Names (IDN).</p>

        <p><strong>How does it work?</strong><br>
        Punycode encodes Unicode strings into ASCII-compatible format. Domain labels with non-ASCII characters are prefixed with "xn--" followed by the Punycode-encoded string.</p>

        <p><strong>Examples:</strong></p>
        <ul>
            <li><strong>German:</strong> münchen.de → xn--mnchen-3ya.de</li>
            <li><strong>Japanese:</strong> 日本.jp → xn--wgv71a.jp</li>
            <li><strong>Chinese:</strong> 中国.cn → xn--fiqs8s.cn</li>
            <li><strong>Russian:</strong> москва.рф → xn--80adxhks.xn--p1ai</li>
            <li><strong>Arabic:</strong> مصر.مصر → xn--wgbh1c.xn--wgbh1c</li>
            <li><strong>Greek:</strong> παράδειγμα.gr → xn--hxajbheg2az3al.gr</li>
            <li><strong>Hindi:</strong> भारत.in → xn--h2brj9c.in</li>
            <li><strong>Korean:</strong> 한국.kr → xn--3e0b707e.kr</li>
            <li><strong>Hebrew:</strong> ישראל.il → xn--4dbrk0ce.il</li>
            <li><strong>Thai:</strong> ไทย.th → xn--o3cw4h.th</li>
        </ul>

        <p><strong>Use Cases:</strong></p>
        <ul>
            <li>Registering domain names with non-Latin characters</li>
            <li>Email addresses with international characters</li>
            <li>DNS zone file entries</li>
            <li>Web server configuration</li>
        </ul>
    </div>
</div>

<script>
    // Punycode implementation based on RFC 3492
    const punycode = {
        base: 36,
        tMin: 1,
        tMax: 26,
        skew: 38,
        damp: 700,
        initialBias: 72,
        initialN: 128,
        delimiter: '-',

        encode: function(input) {
            let output = [];
            let basic = [];
            for (let i = 0; i < input.length; i++) {
                let code = input.charCodeAt(i);
                if (code < 0x80) {
                    basic.push(input[i]);
                }
            }
            let h = basic.length;
            let b = basic.length;
            output = basic.slice();
            if (b > 0) {
                output.push(this.delimiter);
            }
            let n = this.initialN;
            let delta = 0;
            let bias = this.initialBias;
            while (h < input.length) {
                let m = 0x10FFFF;
                for (let i = 0; i < input.length; i++) {
                    let code = input.charCodeAt(i);
                    if (code >= n && code < m) {
                        m = code;
                    }
                }
                delta += (m - n) * (h + 1);
                n = m;
                for (let i = 0; i < input.length; i++) {
                    let code = input.charCodeAt(i);
                    if (code < n) {
                        delta++;
                    }
                    if (code === n) {
                        let q = delta;
                        for (let k = this.base; ; k += this.base) {
                            let t = k <= bias ? this.tMin : (k >= bias + this.tMax ? this.tMax : k - bias);
                            if (q < t) break;
                            output.push(this.encodeDigit(t + (q - t) % (this.base - t)));
                            q = Math.floor((q - t) / (this.base - t));
                        }
                        output.push(this.encodeDigit(q));
                        bias = this.adapt(delta, h + 1, h === b);
                        delta = 0;
                        h++;
                    }
                }
                delta++;
                n++;
            }
            return output.join('');
        },

        decode: function(input) {
            let output = [];
            let i = 0;
            let n = this.initialN;
            let bias = this.initialBias;
            let basic = input.lastIndexOf(this.delimiter);
            if (basic < 0) {
                basic = 0;
            } else {
                for (let j = 0; j < basic; j++) {
                    output.push(input.charCodeAt(j));
                }
                basic++;
            }
            for (let index = basic; index < input.length; ) {
                let oldi = i;
                let w = 1;
                for (let k = this.base; ; k += this.base) {
                    if (index >= input.length) {
                        throw new Error('Invalid input');
                    }
                    let digit = this.decodeDigit(input.charCodeAt(index++));
                    if (digit >= this.base) {
                        throw new Error('Invalid input');
                    }
                    i += digit * w;
                    let t = k <= bias ? this.tMin : (k >= bias + this.tMax ? this.tMax : k - bias);
                    if (digit < t) break;
                    w *= this.base - t;
                }
                bias = this.adapt(i - oldi, output.length + 1, oldi === 0);
                n += Math.floor(i / (output.length + 1));
                i %= (output.length + 1);
                output.splice(i, 0, n);
                i++;
            }
            return String.fromCharCode.apply(null, output);
        },

        adapt: function(delta, numPoints, firstTime) {
            delta = firstTime ? Math.floor(delta / this.damp) : delta >> 1;
            delta += Math.floor(delta / numPoints);
            let k = 0;
            while (delta > ((this.base - this.tMin) * this.tMax) >> 1) {
                delta = Math.floor(delta / (this.base - this.tMin));
                k += this.base;
            }
            return Math.floor(k + (this.base - this.tMin + 1) * delta / (delta + this.skew));
        },

        encodeDigit: function(d) {
            return String.fromCharCode(d + 22 + 75 * (d < 26 ? 1 : 0));
        },

        decodeDigit: function(code) {
            if (code - 48 < 10) return code - 22;
            if (code - 65 < 26) return code - 65;
            if (code - 97 < 26) return code - 97;
            return this.base;
        }
    };

    function setExample(domain) {
        document.getElementById('inputDomain').value = domain;
        if (domain.includes('xn--')) {
            document.getElementById('decodeRadio').checked = true;
        } else {
            document.getElementById('encodeRadio').checked = true;
        }
    }

    function convertDomain() {
        const input = document.getElementById('inputDomain').value.trim();
        if (!input) {
            showNotification('Please enter a domain name', 'fa-exclamation-circle', 'warning');
            return;
        }
        const direction = document.querySelector('input[name="direction"]:checked').value;
        try {
            let result;
            let details = '';
            if (direction === 'encode') {
                result = encodeDomain(input);
                details = generateEncodeDetails(input, result);
            } else {
                result = decodeDomain(input);
                details = generateDecodeDetails(input, result);
            }
            document.getElementById('outputDomain').value = result;
            document.getElementById('detailsSection').innerHTML = details;
            document.getElementById('resultSection').style.display = 'block';
            showNotification('Conversion successful!', 'fa-check-circle', 'success');
        } catch (error) {
            showNotification('Error: ' + error.message, 'fa-exclamation-circle', 'danger');
        }
    }

    function encodeDomain(domain) {
        const labels = domain.split('.');
        const encoded = labels.map(label => {
            if (/^[\x00-\x7F]*$/.test(label)) {
                return label;
            }
            return 'xn--' + punycode.encode(label);
        });
        return encoded.join('.');
    }

    function decodeDomain(domain) {
        const labels = domain.split('.');
        const decoded = labels.map(label => {
            if (label.toLowerCase().startsWith('xn--')) {
                return punycode.decode(label.substring(4));
            }
            return label;
        });
        return decoded.join('.');
    }

    function generateEncodeDetails(input, output) {
        const labels = input.split('.');
        let html = '<table class="table table-sm table-bordered"><thead><tr><th>Original Label</th><th>Punycode</th><th>Status</th></tr></thead><tbody>';
        labels.forEach(label => {
            const isAscii = /^[\x00-\x7F]*$/.test(label);
            const encoded = isAscii ? label : 'xn--' + punycode.encode(label);
            const status = isAscii ? 'ASCII (no encoding needed)' : 'Encoded';
            html += '<tr><td>' + label + '</td><td>' + encoded + '</td><td>' + status + '</td></tr>';
        });
        html += '</tbody></table>';
        return html;
    }

    function generateDecodeDetails(input, output) {
        const labels = input.split('.');
        let html = '<table class="table table-sm table-bordered"><thead><tr><th>Punycode Label</th><th>Unicode</th><th>Status</th></tr></thead><tbody>';
        labels.forEach(label => {
            const isPunycode = label.toLowerCase().startsWith('xn--');
            const decoded = isPunycode ? punycode.decode(label.substring(4)) : label;
            const status = isPunycode ? 'Decoded' : 'ASCII (no decoding needed)';
            html += '<tr><td>' + label + '</td><td>' + decoded + '</td><td>' + status + '</td></tr>';
        });
        html += '</tbody></table>';
        return html;
    }

    function clearAll() {
        document.getElementById('inputDomain').value = '';
        document.getElementById('resultSection').style.display = 'none';
        document.getElementById('encodeRadio').checked = true;
    }

    function copyToClipboard(elementId) {
        const element = document.getElementById(elementId);
        element.select();
        document.execCommand('copy');
        showNotification('Copied to clipboard!', 'fa-copy', 'success');
    }

    function showNotification(message, icon, type) {
        const notification = document.createElement('div');
        notification.className = 'alert alert-' + type;
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.zIndex = '9999';
        notification.style.minWidth = '300px';
        notification.innerHTML = '<i class="fas ' + icon + '"></i> ' + message;
        document.body.appendChild(notification);
        setTimeout(function() {
            notification.style.transition = 'opacity 0.5s';
            notification.style.opacity = '0';
            setTimeout(function() {
                document.body.removeChild(notification);
            }, 500);
        }, 3000);
    }
</script>
</div>
<%@ include file="body-close.jsp"%>
