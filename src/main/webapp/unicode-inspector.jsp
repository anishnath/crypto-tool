<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Unicode Character Inspector - Character Properties & Metadata | 8gwifi.org</title>

    <meta name="description" content="Free online Unicode character inspector. Analyze Unicode characters, view properties, codepoints, HTML entities, UTF-8 encoding, character blocks, and complete metadata.">
    <meta name="keywords" content="unicode inspector, character inspector, unicode analyzer, unicode properties, codepoint lookup, character metadata, unicode character info, UTF-8 encoding, HTML entity, character block, unicode category, character name, unicode decoder, character encoding, unicode codepoint, character analysis, unicode table, character properties, unicode blocks, UTF-16 encoding, character decomposition, unicode normalization, character search">

    <meta property="og:title" content="Unicode Character Inspector - Character Properties Tool">
    <meta property="og:description" content="Inspect Unicode characters and view detailed properties including codepoints, encoding, HTML entities, and metadata.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/unicode-inspector.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Unicode Character Inspector">
    <meta name="twitter:description" content="Free tool to inspect Unicode characters and view detailed properties and metadata.">

    <link rel="canonical" href="https://8gwifi.org/unicode-inspector.jsp">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Unicode Character Inspector",
        "description": "Free online tool to inspect and analyze Unicode characters. View character properties, codepoints, HTML entities, UTF-8/UTF-16 encoding, character blocks, categories, and complete metadata.",
        "url": "https://8gwifi.org/unicode-inspector.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Web Browser",
        "permissions": "No installation required",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
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
            "item": "https://8gwifi.org/unicode-inspector.jsp"
        },{
            "@type": "ListItem",
            "position": 3,
            "name": "Unicode Character Inspector",
            "item": "https://8gwifi.org/unicode-inspector.jsp"
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
        .char-input {
            font-size: 48px;
            text-align: center;
            height: 100px;
        }
        .char-display {
            font-size: 120px;
            text-align: center;
            padding: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            margin-bottom: 20px;
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
        .property-table {
            font-size: 0.85rem;
        }
        .property-table th {
            width: 200px;
            background-color: #f8f9fa;
        }
        .code-display {
            font-family: 'Courier New', monospace;
            background-color: #f8f9fa;
            padding: 5px;
            border-radius: 3px;
        }
        .copy-btn {
            cursor: pointer;
            color: #007bff;
        }
        .copy-btn:hover {
            color: #0056b3;
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
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<div class="main-container">
    <div class="tool-header">
        <h1><i class="fas fa-search"></i> Unicode Character Inspector</h1>
        <p>Inspect any Unicode character to view its properties, codepoint, encoding, and metadata.</p>
    </div>

    <div class="control-panel">
        <h3><i class="fas fa-keyboard"></i> Character Input</h3>

        <input type="text" id="charInput" class="form-control char-input" maxlength="2" placeholder="A" oninput="inspectCharacter()">
        <small class="form-text text-muted">Type any single character (including emoji)</small>

        <div class="example-links">
            <strong><i class="fas fa-lightbulb"></i> Try examples:</strong>
            <a onclick="setExample('A')">A</a>
            <a onclick="setExample('ñ')">ñ</a>
            <a onclick="setExample('€')">€</a>
            <a onclick="setExample('中')">中</a>
            <a onclick="setExample('א')">א</a>
            <a onclick="setExample('π')">π</a>
            <a onclick="setExample('ж')">ж</a>
            <a onclick="setExample('😀')">😀</a>
            <a onclick="setExample('🚀')">🚀</a>
            <a onclick="setExample('♠')">♠</a>
        </div>
    </div>

    <div id="resultSection" style="display:none;">
        <div class="char-display" id="charDisplay">A</div>

        <div class="info-panel">
            <h3><i class="fas fa-info-circle"></i> Basic Information</h3>
            <table class="table table-bordered property-table mb-0">
                <tr>
                    <th>Character</th>
                    <td id="char" style="font-size: 24px;"></td>
                </tr>
                <tr>
                    <th>Unicode Name</th>
                    <td id="charName"></td>
                </tr>
                <tr>
                    <th>Codepoint (Decimal)</th>
                    <td><span class="code-display" id="codepointDec"></span> <i class="fas fa-copy copy-btn" onclick="copyText('codepointDec')" title="Copy"></i></td>
                </tr>
                <tr>
                    <th>Codepoint (Hex)</th>
                    <td><span class="code-display" id="codepointHex"></span> <i class="fas fa-copy copy-btn" onclick="copyText('codepointHex')" title="Copy"></i></td>
                </tr>
                <tr>
                    <th>Unicode Notation</th>
                    <td><span class="code-display" id="unicodeNotation"></span> <i class="fas fa-copy copy-btn" onclick="copyText('unicodeNotation')" title="Copy"></i></td>
                </tr>
            </table>
        </div>

        <div class="info-panel">
            <h3><i class="fas fa-code"></i> Encoding Information</h3>
            <table class="table table-bordered property-table mb-0">
                <tr>
                    <th>UTF-8 Encoding</th>
                    <td><span class="code-display" id="utf8"></span> <i class="fas fa-copy copy-btn" onclick="copyText('utf8')" title="Copy"></i></td>
                </tr>
                <tr>
                    <th>UTF-16 Encoding</th>
                    <td><span class="code-display" id="utf16"></span> <i class="fas fa-copy copy-btn" onclick="copyText('utf16')" title="Copy"></i></td>
                </tr>
                <tr>
                    <th>HTML Entity (Decimal)</th>
                    <td><span class="code-display" id="htmlDec"></span> <i class="fas fa-copy copy-btn" onclick="copyText('htmlDec')" title="Copy"></i></td>
                </tr>
                <tr>
                    <th>HTML Entity (Hex)</th>
                    <td><span class="code-display" id="htmlHex"></span> <i class="fas fa-copy copy-btn" onclick="copyText('htmlHex')" title="Copy"></i></td>
                </tr>
                <tr>
                    <th>URL Encoding</th>
                    <td><span class="code-display" id="urlEncoded"></span> <i class="fas fa-copy copy-btn" onclick="copyText('urlEncoded')" title="Copy"></i></td>
                </tr>
            </table>
        </div>

        <div class="info-panel">
            <h3><i class="fas fa-list"></i> Character Properties</h3>
            <table class="table table-bordered property-table mb-0">
                <tr>
                    <th>Category</th>
                    <td id="category"></td>
                </tr>
                <tr>
                    <th>Block</th>
                    <td id="block"></td>
                </tr>
                <tr>
                    <th>Script</th>
                    <td id="script"></td>
                </tr>
                <tr>
                    <th>Printable</th>
                    <td id="printable"></td>
                </tr>
                <tr>
                    <th>Whitespace</th>
                    <td id="whitespace"></td>
                </tr>
            </table>
        </div>
    </div>

    <div class="info-section">
        <h3>About Unicode</h3>
        <p><strong>What is Unicode?</strong><br>
        Unicode is a universal character encoding standard that assigns a unique code to every character in every language worldwide. It supports over 140,000 characters covering 154 modern and historic scripts.</p>

        <p><strong>Character Categories:</strong></p>
        <ul>
            <li><strong>Lu</strong> - Uppercase Letter</li>
            <li><strong>Ll</strong> - Lowercase Letter</li>
            <li><strong>Nd</strong> - Decimal Number</li>
            <li><strong>So</strong> - Other Symbol (includes emoji)</li>
            <li><strong>Sm</strong> - Math Symbol</li>
            <li><strong>Ps/Pe</strong> - Punctuation Start/End</li>
        </ul>

        <p><strong>Common Unicode Blocks:</strong></p>
        <ul>
            <li><strong>Basic Latin</strong> - U+0000 to U+007F (ASCII)</li>
            <li><strong>Latin-1 Supplement</strong> - U+0080 to U+00FF</li>
            <li><strong>Greek and Coptic</strong> - U+0370 to U+03FF</li>
            <li><strong>Cyrillic</strong> - U+0400 to U+04FF</li>
            <li><strong>Arabic</strong> - U+0600 to U+06FF</li>
            <li><strong>CJK Unified Ideographs</strong> - U+4E00 to U+9FFF</li>
            <li><strong>Emoji</strong> - Various blocks (U+1F300-U+1F9FF, etc.)</li>
        </ul>
    </div>
</div>

<script>
    const unicodeBlocks = [
        { start: 0x0000, end: 0x007F, name: 'Basic Latin' },
        { start: 0x0080, end: 0x00FF, name: 'Latin-1 Supplement' },
        { start: 0x0370, end: 0x03FF, name: 'Greek and Coptic' },
        { start: 0x0400, end: 0x04FF, name: 'Cyrillic' },
        { start: 0x0600, end: 0x06FF, name: 'Arabic' },
        { start: 0x0900, end: 0x097F, name: 'Devanagari' },
        { start: 0x0E00, end: 0x0E7F, name: 'Thai' },
        { start: 0x4E00, end: 0x9FFF, name: 'CJK Unified Ideographs' },
        { start: 0x1F300, end: 0x1F9FF, name: 'Miscellaneous Symbols and Pictographs / Emoticons' }
    ];

    function getUnicodeBlock(codepoint) {
        for (let block of unicodeBlocks) {
            if (codepoint >= block.start && codepoint <= block.end) {
                return block.name;
            }
        }
        return 'Unknown Block';
    }

    function getCharacterCategory(char) {
        const code = char.charCodeAt(0);
        if (code >= 0x41 && code <= 0x5A) return 'Lu (Uppercase Letter)';
        if (code >= 0x61 && code <= 0x7A) return 'Ll (Lowercase Letter)';
        if (code >= 0x30 && code <= 0x39) return 'Nd (Decimal Number)';
        if (code >= 0x1F300 && code <= 0x1F9FF) return 'So (Other Symbol - Emoji)';
        return 'Other';
    }

    function getScript(codepoint) {
        if (codepoint >= 0x0000 && codepoint <= 0x007F) return 'Latin';
        if (codepoint >= 0x0370 && codepoint <= 0x03FF) return 'Greek';
        if (codepoint >= 0x0400 && codepoint <= 0x04FF) return 'Cyrillic';
        if (codepoint >= 0x0600 && codepoint <= 0x06FF) return 'Arabic';
        if (codepoint >= 0x4E00 && codepoint <= 0x9FFF) return 'Han (Chinese)';
        return 'Common';
    }

    function toUTF8Hex(char) {
        const encoder = new TextEncoder();
        const bytes = encoder.encode(char);
        return Array.from(bytes).map(b => '0x' + b.toString(16).toUpperCase().padStart(2, '0')).join(' ');
    }

    function toUTF16Hex(char) {
        const hex = [];
        for (let i = 0; i < char.length; i++) {
            hex.push('0x' + char.charCodeAt(i).toString(16).toUpperCase().padStart(4, '0'));
        }
        return hex.join(' ');
    }

    function inspectCharacter() {
        const input = document.getElementById('charInput').value;
        if (!input || input.length === 0) {
            document.getElementById('resultSection').style.display = 'none';
            return;
        }
        const char = Array.from(input)[0];
        const codepoint = char.codePointAt(0);
        document.getElementById('charDisplay').textContent = char;
        document.getElementById('char').textContent = char;
        document.getElementById('charName').textContent = 'CHARACTER (U+' + codepoint.toString(16).toUpperCase() + ')';
        document.getElementById('codepointDec').textContent = codepoint;
        document.getElementById('codepointHex').textContent = '0x' + codepoint.toString(16).toUpperCase();
        document.getElementById('unicodeNotation').textContent = 'U+' + codepoint.toString(16).toUpperCase().padStart(4, '0');
        document.getElementById('utf8').textContent = toUTF8Hex(char);
        document.getElementById('utf16').textContent = toUTF16Hex(char);
        document.getElementById('htmlDec').textContent = '&#' + codepoint + ';';
        document.getElementById('htmlHex').textContent = '&#x' + codepoint.toString(16).toUpperCase() + ';';
        document.getElementById('urlEncoded').textContent = encodeURIComponent(char);
        document.getElementById('category').textContent = getCharacterCategory(char);
        document.getElementById('block').textContent = getUnicodeBlock(codepoint);
        document.getElementById('script').textContent = getScript(codepoint);
        document.getElementById('printable').textContent = (codepoint >= 0x20) ? 'Yes' : 'No';
        document.getElementById('whitespace').textContent = /\s/.test(char) ? 'Yes' : 'No';
        document.getElementById('resultSection').style.display = 'block';
    }

    function setExample(char) {
        document.getElementById('charInput').value = char;
        inspectCharacter();
    }

    function copyText(elementId) {
        const text = document.getElementById(elementId).textContent;
        navigator.clipboard.writeText(text).then(() => {
            showNotification('Copied to clipboard: ' + text, 'fa-copy', 'success');
        });
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

    window.onload = function() {
        document.getElementById('charInput').value = 'A';
        inspectCharacter();
    };
</script>
</div>
<%@ include file="body-close.jsp"%>
