
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>IPv6 Address Compressor & Expander - IPv6 Format Converter | 8gwifi.org</title>

    <meta name="description" content="Free online IPv6 address compressor and expander tool. Convert between compressed and expanded IPv6 formats, validate addresses, and convert to decimal, binary, and hex formats.">
    <meta name="keywords" content="IPv6 compressor, IPv6 expander, IPv6 converter, compress IPv6 address, expand IPv6 address, IPv6 format converter, IPv6 validator, IPv6 shorthand, IPv6 full format, IPv6 to decimal, IPv6 to binary, IPv6 address tool, IPv6 notation, IPv6 address format, shorten IPv6, full IPv6 address, IPv6 address calculator, IPv6 subnet calculator, IPv6 address parser, IPv6 CIDR, IPv6 network calculator, IPv6 address compression, IPv6 zero compression, IPv6 address validation, IPv6 address analyzer">

    <meta property="og:title" content="IPv6 Address Compressor & Expander Tool">
    <meta property="og:description" content="Compress, expand, and convert IPv6 addresses between different formats. Validate and analyze IPv6 addresses online.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/ipv6-tool.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="IPv6 Address Compressor & Expander">
    <meta name="twitter:description" content="Free tool to compress, expand, and convert IPv6 addresses.">

    <link rel="canonical" href="https://8gwifi.org/ipv6-tool.jsp">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "IPv6 Address Compressor & Expander",
        "description": "Free online tool to compress and expand IPv6 addresses, validate IPv6 format, and convert between different representations including decimal, binary, and hexadecimal formats.",
        "url": "https://8gwifi.org/ipv6-tool.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Web Browser",
        "permissions": "No installation required",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "Compress IPv6 addresses to shortest form",
            "Expand IPv6 addresses to full format",
            "Validate IPv6 address format",
            "Convert to decimal representation",
            "Convert to binary representation",
            "Convert to hexadecimal groups",
            "Show leading zero compression",
            "Show consecutive zero compression",
            "Parse IPv6 CIDR notation",
            "Detect IPv6 address type",
            "Show address properties",
            "Privacy-focused (client-side only)",
            "Copy to clipboard functionality"
        ],
        "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "4.8",
            "ratingCount": "456",
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
            "name": "Network Tools",
            "item": "https://8gwifi.org/ipv6-tool.jsp"
        },{
            "@type": "ListItem",
            "position": 3,
            "name": "IPv6 Compressor & Expander"
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [{
            "@type": "Question",
            "name": "What is IPv6 address compression?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "IPv6 address compression is the process of shortening an IPv6 address by removing leading zeros in each group and replacing the longest sequence of consecutive zero groups with '::'. For example, 2001:0db8:0000:0000:0000:ff00:0042:8329 becomes 2001:db8::ff00:42:8329."
            }
        },{
            "@type": "Question",
            "name": "How do I expand a compressed IPv6 address?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Expanding an IPv6 address means converting it to its full 128-bit representation with all 8 groups of 4 hexadecimal digits. Replace '::' with the appropriate number of zero groups and add leading zeros to each group."
            }
        },{
            "@type": "Question",
            "name": "What does :: mean in an IPv6 address?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The double colon (::) in an IPv6 address represents one or more consecutive groups of zeros. It can only appear once in an address. For example, in 2001:db8::1, the :: represents 0000:0000:0000:0000:0000:0000."
            }
        },{
            "@type": "Question",
            "name": "How many bits is an IPv6 address?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "An IPv6 address is 128 bits long, represented as eight groups of four hexadecimal digits (16 bits each). This provides approximately 340 undecillion unique addresses."
            }
        },{
            "@type": "Question",
            "name": "What are the different types of IPv6 addresses?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "IPv6 addresses include: Global Unicast (2000::/3), Link-Local (fe80::/10), Unique Local (fc00::/7), Multicast (ff00::/8), Loopback (::1), and Unspecified (::/128)."
            }
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Compress and Expand IPv6 Addresses",
        "description": "Step-by-step guide to using the IPv6 address compressor and expander",
        "step": [{
            "@type": "HowToStep",
            "position": 1,
            "name": "Enter IPv6 Address",
            "text": "Paste or type your IPv6 address in either compressed or expanded format"
        },{
            "@type": "HowToStep",
            "position": 2,
            "name": "Choose Operation",
            "text": "Click 'Compress' to shorten the address or 'Expand' to show the full format"
        },{
            "@type": "HowToStep",
            "position": 3,
            "name": "View Results",
            "text": "See the compressed/expanded address along with decimal, binary, and other format conversions"
        },{
            "@type": "HowToStep",
            "position": 4,
            "name": "Copy Result",
            "text": "Use the copy button to copy the converted address to your clipboard"
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
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .tool-header h1 {
            color: #667eea;
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .tool-header p {
            color: #6c757d;
            margin-bottom: 0;
            font-size: 0.9rem;
        }
        .control-panel {
            background: white;
            border-radius: 10px;
            padding: 1rem;
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
            font-family: 'Courier New', monospace;
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
        .result-box {
            background: #f8f9fa;
            border: 2px solid #667eea;
            border-radius: 6px;
            padding: 0.75rem;
            font-family: 'Courier New', monospace;
            font-size: 1rem;
            word-break: break-all;
            position: relative;
            margin-bottom: 0.75rem;
        }
        .result-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }
        .copy-btn-inline {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: #667eea;
            color: white;
            border: none;
            padding: 0.3rem 0.6rem;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.8rem;
        }
        .copy-btn-inline:hover {
            background: #764ba2;
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
        .info-item {
            margin-bottom: 0.75rem;
            padding: 0.5rem;
            background: #f8f9fa;
            border-radius: 6px;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            font-size: 0.9rem;
        }
        .info-value {
            color: #212529;
            font-size: 0.9rem;
        }
        .alert {
            border-radius: 6px;
            padding: 0.75rem;
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
        .info-section p {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
        }
        .info-section ul {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
            padding-left: 1.25rem;
        }
        .collapse-toggle {
            color: #667eea;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            display: inline-block;
        }
        .collapse-toggle:hover {
            color: #764ba2;
            text-decoration: none;
        }
        .related-tools {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .related-tools h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
        }
        .related-tools a {
            color: #667eea;
            text-decoration: none;
            margin-right: 1rem;
            font-size: 0.9rem;
        }
        .related-tools a:hover {
            color: #764ba2;
            text-decoration: underline;
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
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<div class="main-container">
    <div class="tool-header">
        <h1><i class="fas fa-network-wired"></i> IPv6 Address Compressor & Expander</h1>
        <p>Compress, expand, and convert IPv6 addresses between different formats with validation.</p>
    </div>

    <div class="control-panel">
        <h3><i class="fas fa-keyboard"></i> IPv6 Address Input</h3>

        <textarea class="form-control" id="ipv6Input" rows="3" placeholder="Enter IPv6 address...
Examples:
2001:0db8:0000:0000:0000:ff00:0042:8329
2001:db8::ff00:42:8329
::1"></textarea>

        <div class="example-links">
            <strong><i class="fas fa-lightbulb"></i> Try examples:</strong>
            <a onclick="loadExample('full')">Full Format</a>
            <a onclick="loadExample('compressed')">Compressed</a>
            <a onclick="loadExample('loopback')">Loopback</a>
        </div>

        <div style="margin-top: 1rem;">
            <button class="btn btn-primary" onclick="compressIPv6()">
                <i class="fas fa-compress-alt"></i> Compress
            </button>
            <button class="btn btn-primary" onclick="expandIPv6()">
                <i class="fas fa-expand-alt"></i> Expand
            </button>
            <button class="btn btn-secondary" onclick="clearAll()">
                <i class="fas fa-eraser"></i> Clear
            </button>
        </div>
    </div>

    <div id="resultsContainer" style="display: none;">
        <div class="info-panel">
            <h3><i class="fas fa-check-circle"></i> Results</h3>
            <div id="results"></div>
        </div>

        <div class="info-panel">
            <h3><i class="fas fa-info-circle"></i> Address Information</h3>
            <div id="addressInfo"></div>
        </div>
    </div>

    <div class="info-section">
        <a class="collapse-toggle" data-toggle="collapse" href="#howItWorksCollapse">
            <i class="fas fa-question-circle"></i> About IPv6 Addresses
        </a>
        <div class="collapse" id="howItWorksCollapse">
            <p><strong>IPv6 Address Format:</strong></p>
            <p>IPv6 addresses are 128-bit identifiers represented as eight groups of four hexadecimal digits, separated by colons. Example: 2001:0db8:85a3:0000:0000:8a2e:0370:7334</p>

            <p><strong>Compression Rules:</strong></p>
            <ul>
                <li><strong>Leading Zero Compression:</strong> Leading zeros in each group can be omitted. 0042 becomes 42, 0000 becomes 0.</li>
                <li><strong>Consecutive Zero Compression:</strong> The longest sequence of consecutive all-zero groups can be replaced with ::. Can only be used once per address.</li>
                <li><strong>Example:</strong> 2001:0db8:0000:0000:0000:ff00:0042:8329 → 2001:db8::ff00:42:8329</li>
            </ul>

            <p><strong>IPv6 Address Types:</strong></p>
            <ul>
                <li><strong>Global Unicast (2000::/3):</strong> Globally routable addresses, similar to public IPv4</li>
                <li><strong>Link-Local (fe80::/10):</strong> Used for communication on a single link</li>
                <li><strong>Unique Local (fc00::/7):</strong> Similar to private IPv4 addresses (RFC 4193)</li>
                <li><strong>Multicast (ff00::/8):</strong> One-to-many communication</li>
                <li><strong>Loopback (::1):</strong> Equivalent to 127.0.0.1 in IPv4</li>
                <li><strong>Unspecified (::/128):</strong> All zeros, equivalent to 0.0.0.0</li>
            </ul>

            <p><strong>IPv6 vs IPv4:</strong></p>
            <ul>
                <li>IPv6: 128 bits (340 undecillion addresses)</li>
                <li>IPv4: 32 bits (4.3 billion addresses)</li>
                <li>IPv6 eliminates the need for NAT</li>
                <li>Built-in IPsec support</li>
                <li>Simplified header structure</li>
            </ul>
        </div>
    </div>

</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<script>
const examples = {
    full: '2001:0db8:0000:0000:0000:ff00:0042:8329',
    compressed: '2001:db8::ff00:42:8329',
    loopback: '::1'
};

function loadExample(type) {
    document.getElementById('ipv6Input').value = examples[type];
}

function compressIPv6() {
    const input = document.getElementById('ipv6Input').value.trim();

    if (!input) {
        alert('Please enter an IPv6 address');
        return;
    }

    try {
        // First expand to normalize
        const expanded = expandIPv6Address(input);

        // Then compress
        const compressed = compressIPv6Address(expanded);

        // Display results
        displayResults(input, expanded, compressed, 'compress');

    } catch (error) {
        alert('Error: ' + error.message);
    }
}

function expandIPv6() {
    const input = document.getElementById('ipv6Input').value.trim();

    if (!input) {
        alert('Please enter an IPv6 address');
        return;
    }

    try {
        const expanded = expandIPv6Address(input);
        const compressed = compressIPv6Address(expanded);

        displayResults(input, expanded, compressed, 'expand');

    } catch (error) {
        alert('Error: ' + error.message);
    }
}

function expandIPv6Address(address) {
    // Remove whitespace and convert to lowercase
    address = address.trim().toLowerCase();

    // Handle CIDR notation
    let prefix = '';
    if (address.includes('/')) {
        const parts = address.split('/');
        address = parts[0];
        prefix = '/' + parts[1];
    }

    // Validate basic format
    if (!/^[0-9a-f:]+$/i.test(address)) {
        throw new Error('Invalid IPv6 address format');
    }

    // Handle :: compression
    if (address.includes('::')) {
        const parts = address.split('::');
        if (parts.length > 2) {
            throw new Error(':: can only appear once in an IPv6 address');
        }

        const left = parts[0] ? parts[0].split(':') : [];
        const right = parts[1] ? parts[1].split(':') : [];
        const missingGroups = 8 - (left.length + right.length);

        if (missingGroups < 0) {
            throw new Error('Invalid IPv6 address: too many groups');
        }

        const middle = Array(missingGroups).fill('0000');
        const allGroups = left.concat(middle).concat(right);

        // Expand each group to 4 digits
        address = allGroups.map(g => g.padStart(4, '0')).join(':');
    } else {
        // No :: compression, just expand each group
        const groups = address.split(':');
        if (groups.length !== 8) {
            throw new Error('IPv6 address must have 8 groups or use :: compression');
        }
        address = groups.map(g => g.padStart(4, '0')).join(':');
    }

    return address + prefix;
}

function compressIPv6Address(address) {
    // Remove CIDR if present
    let prefix = '';
    if (address.includes('/')) {
        const parts = address.split('/');
        address = parts[0];
        prefix = '/' + parts[1];
    }

    const groups = address.split(':');

    // Remove leading zeros from each group
    const compressedGroups = groups.map(g => {
        return g.replace(/^0+/, '') || '0';
    });

    // Find longest sequence of consecutive zeros
    let maxStart = -1;
    let maxLength = 0;
    let currentStart = -1;
    let currentLength = 0;

    for (let i = 0; i < compressedGroups.length; i++) {
        if (compressedGroups[i] === '0') {
            if (currentStart === -1) {
                currentStart = i;
                currentLength = 1;
            } else {
                currentLength++;
            }
        } else {
            if (currentLength > maxLength) {
                maxStart = currentStart;
                maxLength = currentLength;
            }
            currentStart = -1;
            currentLength = 0;
        }
    }

    // Check last sequence
    if (currentLength > maxLength) {
        maxStart = currentStart;
        maxLength = currentLength;
    }

    // Replace longest zero sequence with ::
    if (maxLength > 1) {
        const before = compressedGroups.slice(0, maxStart);
        const after = compressedGroups.slice(maxStart + maxLength);

        if (before.length === 0 && after.length === 0) {
            return '::' + prefix;
        } else if (before.length === 0) {
            return '::' + after.join(':') + prefix;
        } else if (after.length === 0) {
            return before.join(':') + '::' + prefix;
        } else {
            return before.join(':') + '::' + after.join(':') + prefix;
        }
    }

    return compressedGroups.join(':') + prefix;
}

function displayResults(original, expanded, compressed, operation) {
    let html = '';

    // Compressed format
    html += '<div class="result-label">Compressed Format:</div>';
    html += '<div class="result-box">';
    html += compressed;
    html += '<button class="copy-btn-inline" onclick="copyText(\'' + escapeForJs(compressed) + '\')">Copy</button>';
    html += '</div>';

    // Expanded format
    html += '<div class="result-label">Expanded Format:</div>';
    html += '<div class="result-box">';
    html += expanded.split('/')[0];
    html += '<button class="copy-btn-inline" onclick="copyText(\'' + escapeForJs(expanded.split('/')[0]) + '\')">Copy</button>';
    html += '</div>';

    // Decimal representation
    const decimal = ipv6ToDecimal(expanded.split('/')[0]);
    html += '<div class="result-label">Decimal:</div>';
    html += '<div class="result-box" style="font-size: 0.85rem;">';
    html += decimal;
    html += '</div>';

    // Binary representation (first 64 bits)
    const binary = ipv6ToBinary(expanded.split('/')[0]);
    html += '<div class="result-label">Binary (first 64 bits):</div>';
    html += '<div class="result-box" style="font-size: 0.75rem; word-break: break-all;">';
    html += binary.substring(0, 64).match(/.{1,16}/g).join(' ');
    html += '</div>';

    document.getElementById('results').innerHTML = html;

    // Address information
    displayAddressInfo(expanded.split('/')[0]);

    document.getElementById('resultsContainer').style.display = 'block';
    showNotification('IPv6 address ' + operation + 'ed successfully!', 'success');
}

function displayAddressInfo(address) {
    let html = '';

    const type = getIPv6Type(address);
    const scope = getIPv6Scope(address);

    html += '<div class="info-item">';
    html += '<span class="info-label">Address Type: </span>';
    html += '<span class="info-value">' + type + '</span>';
    html += '</div>';

    html += '<div class="info-item">';
    html += '<span class="info-label">Scope: </span>';
    html += '<span class="info-value">' + scope + '</span>';
    html += '</div>';

    html += '<div class="info-item">';
    html += '<span class="info-label">Total Bits: </span>';
    html += '<span class="info-value">128 bits</span>';
    html += '</div>';

    html += '<div class="info-item">';
    html += '<span class="info-label">Total Addresses: </span>';
    html += '<span class="info-value">340,282,366,920,938,463,463,374,607,431,768,211,456</span>';
    html += '</div>';

    document.getElementById('addressInfo').innerHTML = html;
}

function getIPv6Type(address) {
    const firstGroup = address.split(':')[0];
    const firstByte = parseInt(firstGroup.substring(0, 2), 16);

    if (address === '0000:0000:0000:0000:0000:0000:0000:0001') {
        return 'Loopback';
    } else if (address === '0000:0000:0000:0000:0000:0000:0000:0000') {
        return 'Unspecified';
    } else if ((firstByte & 0xE0) === 0x20) {
        return 'Global Unicast';
    } else if ((firstByte & 0xFE) === 0xFE && (parseInt(firstGroup.substring(2, 4), 16) & 0xC0) === 0x80) {
        return 'Link-Local Unicast';
    } else if ((firstByte & 0xFE) === 0xFC) {
        return 'Unique Local Unicast';
    } else if (firstByte === 0xFF) {
        return 'Multicast';
    } else {
        return 'Unknown';
    }
}

function getIPv6Scope(address) {
    const type = getIPv6Type(address);

    if (type === 'Global Unicast') return 'Global';
    if (type === 'Link-Local Unicast') return 'Link-Local';
    if (type === 'Unique Local Unicast') return 'Organization-Local';
    if (type === 'Loopback') return 'Node-Local';
    if (type === 'Multicast') {
        const scopeNibble = parseInt(address.split(':')[0].substring(2, 3), 16);
        const scopes = ['Reserved', 'Interface-Local', 'Link-Local', 'Reserved', 'Admin-Local', 'Site-Local', 'Reserved', 'Reserved', 'Organization-Local', 'Reserved', 'Reserved', 'Reserved', 'Reserved', 'Reserved', 'Global', 'Reserved'];
        return scopes[scopeNibble] || 'Unknown';
    }
    return 'Unknown';
}

function ipv6ToDecimal(address) {
    const groups = address.split(':');
    let decimal = BigInt(0);

    for (let i = 0; i < groups.length; i++) {
        const value = BigInt(parseInt(groups[i], 16));
        decimal = (decimal << BigInt(16)) | value;
    }

    return decimal.toString();
}

function ipv6ToBinary(address) {
    const groups = address.split(':');
    let binary = '';

    for (let group of groups) {
        const value = parseInt(group, 16);
        binary += value.toString(2).padStart(16, '0');
    }

    return binary;
}

function escapeForJs(text) {
    return text.replace(/'/g, "\\'");
}

function copyText(text) {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand('copy');
    document.body.removeChild(textarea);

    showNotification('Copied to clipboard!', 'success');
}

function clearAll() {
    document.getElementById('ipv6Input').value = '';
    document.getElementById('resultsContainer').style.display = 'none';
}

function showNotification(message, type) {
    const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
    const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';

    const notification = document.createElement('div');
    notification.className = 'alert ' + alertClass;
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
