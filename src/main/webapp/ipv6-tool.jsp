<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>IPv6 Address Compressor & Expander Online – Free | 8gwifi.org</title>
    <meta name="description" content="Free online IPv6 address compressor and expander tool. Convert between compressed and expanded IPv6 formats, validate addresses, and convert to decimal, binary, and hex formats.">
    <meta name="keywords" content="IPv6 compressor, IPv6 expander, IPv6 converter, compress IPv6 address, expand IPv6 address, IPv6 format converter, IPv6 validator, IPv6 shorthand, IPv6 full format, IPv6 to decimal, IPv6 to binary, IPv6 address tool, IPv6 notation, IPv6 address format, shorten IPv6, full IPv6 address, IPv6 address calculator, IPv6 subnet calculator, IPv6 address parser, IPv6 CIDR, IPv6 network calculator, IPv6 address compression, IPv6 zero compression, IPv6 address validation, IPv6 address analyzer">
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/ipv6-tool.jsp" />

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "IPv6 Address Compressor & Expander",
        "description": "Free online tool to compress and expand IPv6 addresses, validate IPv6 format, and convert between different representations including decimal, binary, and hexadecimal formats.",
        "url": "https://8gwifi.org/ipv6-tool.jsp",
        "applicationCategory": "NetworkApplication",
        "operatingSystem": "Any",
        "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
        "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
        "datePublished": "2020-01-15",
        "dateModified": "2025-01-28"
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
                "text": "IPv6 address compression is the process of shortening an IPv6 address by removing leading zeros in each group and replacing the longest sequence of consecutive zero groups with '::'. For example, 2001:0db8:0000:0000:0000:ff00:0042:8329 becomes 2001:db8::ff00:42:8329. This makes IPv6 addresses more readable and easier to work with."
            }
        },{
            "@type": "Question",
            "name": "How do I expand a compressed IPv6 address?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Expanding an IPv6 address means converting it to its full 128-bit representation with all 8 groups of 4 hexadecimal digits. Replace '::' with the appropriate number of zero groups and add leading zeros to each group. For example, 2001:db8::1 expands to 2001:0db8:0000:0000:0000:0000:0000:0001."
            }
        },{
            "@type": "Question",
            "name": "What does :: mean in an IPv6 address?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The double colon (::) in an IPv6 address represents one or more consecutive groups of zeros. It can only appear once in an address. For example, in 2001:db8::1, the :: represents 0000:0000:0000:0000:0000:0000. This is called zero compression and is used to make addresses shorter and more readable."
            }
        },{
            "@type": "Question",
            "name": "How many bits is an IPv6 address?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "An IPv6 address is 128 bits long, represented as eight groups of four hexadecimal digits (16 bits each). This provides approximately 340 undecillion (3.4×10^38) unique addresses, which is vastly more than IPv4's 4.3 billion addresses."
            }
        },{
            "@type": "Question",
            "name": "What are the different types of IPv6 addresses?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "IPv6 addresses include: Global Unicast (2000::/3) - globally routable addresses similar to public IPv4; Link-Local (fe80::/10) - used for communication on a single network link; Unique Local (fc00::/7) - similar to private IPv4 addresses (RFC 4193); Multicast (ff00::/8) - one-to-many communication; Loopback (::1) - equivalent to 127.0.0.1 in IPv4; and Unspecified (::/128) - all zeros, equivalent to 0.0.0.0."
            }
        }]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #059669;
            --theme-secondary: #10b981;
            --theme-gradient: linear-gradient(135deg, #059669 0%, #10b981 100%);
            --theme-light: #ecfdf5;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(5, 150, 105, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(5, 150, 105, 0.25);
        }
        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 0.75rem 1rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
            font-size: 1rem;
        }
        .form-section {
            background: var(--theme-light);
            border-radius: 8px;
            padding: 0.75rem;
            margin-bottom: 0.75rem;
        }
        .form-section-title {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
        }
        .result-card {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            min-height: 200px;
        }
        .result-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            min-height: 150px;
        }
        .result-content {
            display: none;
        }
        .eeat-badge {
            background: var(--theme-gradient);
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .info-badge {
            display: inline-block;
            background: var(--theme-light);
            color: var(--theme-primary);
            padding: 0.2rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            margin-right: 0.25rem;
        }
        .result-box {
            background: #f8f9fa;
            border: 2px solid var(--theme-primary);
            border-radius: 6px;
            padding: 0.75rem;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            word-break: break-all;
            position: relative;
            margin-bottom: 0.75rem;
        }
        .result-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        .copy-btn-inline {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: var(--theme-primary);
            color: white;
            border: none;
            padding: 0.3rem 0.6rem;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.8rem;
        }
        .copy-btn-inline:hover {
            background: var(--theme-secondary);
        }
        .info-item {
            margin-bottom: 0.75rem;
            padding: 0.5rem;
            background: var(--theme-light);
            border-radius: 6px;
        }
        .info-label {
            font-weight: 600;
            color: var(--theme-primary);
            font-size: 0.9rem;
        }
        .info-value {
            color: #212529;
            font-size: 0.9rem;
        }
        .example-links {
            margin-top: 0.5rem;
        }
        .example-links a {
            color: var(--theme-primary);
            cursor: pointer;
            font-size: 0.85rem;
            margin-right: 1rem;
            text-decoration: none;
        }
        .example-links a:hover {
            color: var(--theme-secondary);
            text-decoration: underline;
        }
        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1rem;
        }
        .related-tool-card {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
        }
        .related-tool-card:hover {
            border-color: var(--theme-primary);
            box-shadow: 0 2px 8px rgba(5, 150, 105, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 {
            color: var(--theme-primary);
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
        }
        .related-tool-card p {
            font-size: 0.75rem;
            color: #6c757d;
            margin: 0;
        }
        .hash-output {
            font-family: 'Courier New', monospace;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 0.5rem;
            word-break: break-all;
            position: relative;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
    <%@ include file="network-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">IPv6 Address Compressor & Expander</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-network-wired"></i> 128-bit</span>
            <span class="info-badge"><i class="fas fa-compress-alt"></i> Compression</span>
            <span class="info-badge"><i class="fas fa-expand-alt"></i> Expansion</span>
            <span class="info-badge"><i class="fas fa-shield-alt"></i> Client-Side</span>
        </div>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-user-check"></i>
        <span>Anish Nath</span>
    </div>
</div>

<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-keyboard me-2"></i>IPv6 Address Input</h5>
            </div>
            <div class="card-body">
                <div class="form-section">
                    <div class="form-section-title"><i class="fas fa-network-wired me-1"></i>IPv6 Address</div>
                    <textarea class="form-control" id="ipv6Input" rows="4" placeholder="Enter IPv6 address...
Examples:
2001:0db8:0000:0000:0000:ff00:0042:8329
2001:db8::ff00:42:8329
::1" style="font-family: 'Courier New', monospace;"></textarea>
                </div>

                <div class="example-links">
                    <strong><i class="fas fa-lightbulb me-1"></i>Try examples:</strong>
                    <a onclick="loadExample('full')">Full Format</a>
                    <a onclick="loadExample('compressed')">Compressed</a>
                    <a onclick="loadExample('loopback')">Loopback</a>
                </div>

                <div class="mt-3">
                    <button class="btn w-100 mb-2" onclick="compressIPv6()" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-compress-alt me-2"></i>Compress
                    </button>
                    <button class="btn w-100 mb-2" onclick="expandIPv6()" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-expand-alt me-2"></i>Expand
                    </button>
                    <button class="btn btn-secondary w-100" onclick="clearAll()">
                        <i class="fas fa-eraser me-2"></i>Clear
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-check-circle me-2"></i>Results</h5>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-arrow-left fa-2x text-muted mb-2"></i>
                        <p class="text-muted mb-0">Enter an IPv6 address and click Compress or Expand</p>
                    </div>
                </div>
                <div class="result-content" id="resultContent">
                    <div id="results"></div>
                </div>
            </div>
        </div>

        <div class="card tool-card mt-3" id="addressInfoCard" style="display: none;">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-info-circle me-2"></i>Address Information</h5>
            </div>
            <div class="card-body">
                <div id="addressInfo"></div>
            </div>
        </div>
    </div>
</div>

<!-- Educational Content Section -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding IPv6 Addresses</h5>
    </div>
    <div class="card-body">
        <h6>What is IPv6?</h6>
        <p>IPv6 (Internet Protocol version 6) is the most recent version of the Internet Protocol, designed to replace IPv4. IPv6 addresses are 128-bit identifiers represented as eight groups of four hexadecimal digits, separated by colons. Example: <code>2001:0db8:85a3:0000:0000:8a2e:0370:7334</code></p>

        <h6 class="mt-4">IPv6 Address Compression Rules</h6>
        <p>IPv6 addresses can be compressed using two methods:</p>
        <ul>
            <li><strong>Leading Zero Compression:</strong> Leading zeros in each group can be omitted. <code>0042</code> becomes <code>42</code>, <code>0000</code> becomes <code>0</code>.</li>
            <li><strong>Consecutive Zero Compression:</strong> The longest sequence of consecutive all-zero groups can be replaced with <code>::</code>. This can only be used once per address.</li>
        </ul>
        <p><strong>Example:</strong> <code>2001:0db8:0000:0000:0000:ff00:0042:8329</code> → <code>2001:db8::ff00:42:8329</code></p>

        <h6 class="mt-4">IPv6 Address Types</h6>
        <table class="table table-sm table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Type</th>
                    <th>Prefix</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Global Unicast</strong></td>
                    <td><code>2000::/3</code></td>
                    <td>Globally routable addresses, similar to public IPv4</td>
                </tr>
                <tr>
                    <td><strong>Link-Local</strong></td>
                    <td><code>fe80::/10</code></td>
                    <td>Used for communication on a single network link</td>
                </tr>
                <tr>
                    <td><strong>Unique Local</strong></td>
                    <td><code>fc00::/7</code></td>
                    <td>Similar to private IPv4 addresses (RFC 4193)</td>
                </tr>
                <tr>
                    <td><strong>Multicast</strong></td>
                    <td><code>ff00::/8</code></td>
                    <td>One-to-many communication</td>
                </tr>
                <tr>
                    <td><strong>Loopback</strong></td>
                    <td><code>::1</code></td>
                    <td>Equivalent to 127.0.0.1 in IPv4</td>
                </tr>
                <tr>
                    <td><strong>Unspecified</strong></td>
                    <td><code>::/128</code></td>
                    <td>All zeros, equivalent to 0.0.0.0</td>
                </tr>
            </tbody>
        </table>

        <h6 class="mt-4">IPv6 vs IPv4 Comparison</h6>
        <table class="table table-sm table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Feature</th>
                    <th>IPv4</th>
                    <th>IPv6</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Address Length</strong></td>
                    <td>32 bits</td>
                    <td>128 bits</td>
                </tr>
                <tr>
                    <td><strong>Address Space</strong></td>
                    <td>4.3 billion</td>
                    <td>340 undecillion</td>
                </tr>
                <tr>
                    <td><strong>Address Format</strong></td>
                    <td>Dotted decimal (192.168.1.1)</td>
                    <td>Hexadecimal groups (2001:db8::1)</td>
                </tr>
                <tr>
                    <td><strong>NAT Required</strong></td>
                    <td>Often</td>
                    <td>Not required</td>
                </tr>
                <tr>
                    <td><strong>IPsec Support</strong></td>
                    <td>Optional</td>
                    <td>Built-in</td>
                </tr>
            </tbody>
        </table>

        <h6 class="mt-4">Code Examples</h6>
        <div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>Python</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>import ipaddress

# Expand IPv6
addr = ipaddress.IPv6Address('2001:db8::1')
print(addr.exploded)  # 2001:0db8:0000:0000:0000:0000:0000:0001

# Compress IPv6
addr = ipaddress.IPv6Address('2001:0db8::1')
print(addr.compressed)  # 2001:db8::1</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>JavaScript</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>// Validate IPv6
function isValidIPv6(addr) {
    const pattern = /^([0-9a-f]{1,4}:){7}[0-9a-f]{1,4}$/i;
    return pattern.test(addr.replace('::', ':'));
}

// Expand compressed IPv6
const expanded = addr.replace(/::/, 
    ':'.repeat(8 - addr.split(':').length + 1));</code></pre>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools Section -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="dns.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>DNS Lookup</h6>
                <p>Resolve domain names to IP addresses</p>
            </a>
            <a href="whois.jsp" class="related-tool-card">
                <h6><i class="fas fa-info-circle me-1"></i>WHOIS Lookup</h6>
                <p>Query domain registration information</p>
            </a>
            <a href="SubnetFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-calculator me-1"></i>Subnet Calculator</h6>
                <p>Calculate IPv4 subnet masks and ranges</p>
            </a>
            <a href="pingfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-network-wired me-1"></i>Ping Tool</h6>
                <p>Test network connectivity</p>
            </a>
            <a href="portscan.jsp" class="related-tool-card">
                <h6><i class="fas fa-door-open me-1"></i>Port Scanner</h6>
                <p>Scan for open ports on hosts</p>
            </a>
            <a href="revdns.jsp" class="related-tool-card">
                <h6><i class="fas fa-exchange-alt me-1"></i>Reverse DNS</h6>
                <p>Reverse DNS lookup for IP addresses</p>
            </a>
        </div>
    </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
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

function showToast(message) {
    var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
        '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
        '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
    $('body').append(toast);
    setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
}

function compressIPv6() {
    const input = document.getElementById('ipv6Input').value.trim();

    if (!input) {
        showToast('Please enter an IPv6 address');
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
        showToast('Error: ' + error.message);
    }
}

function expandIPv6() {
    const input = document.getElementById('ipv6Input').value.trim();

    if (!input) {
        showToast('Please enter an IPv6 address');
        return;
    }

    try {
        const expanded = expandIPv6Address(input);
        const compressed = compressIPv6Address(expanded);

        displayResults(input, expanded, compressed, 'expand');

    } catch (error) {
        showToast('Error: ' + error.message);
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
    html += escapeHtml(compressed);
    html += '<button class="copy-btn-inline" onclick="copyText(\'' + escapeForJs(compressed) + '\')"><i class="fas fa-copy"></i></button>';
    html += '</div>';

    // Expanded format
    html += '<div class="result-label">Expanded Format:</div>';
    html += '<div class="result-box">';
    html += escapeHtml(expanded.split('/')[0]);
    html += '<button class="copy-btn-inline" onclick="copyText(\'' + escapeForJs(expanded.split('/')[0]) + '\')"><i class="fas fa-copy"></i></button>';
    html += '</div>';

    // Decimal representation
    const decimal = ipv6ToDecimal(expanded.split('/')[0]);
    html += '<div class="result-label">Decimal:</div>';
    html += '<div class="result-box" style="font-size: 0.85rem;">';
    html += escapeHtml(decimal);
    html += '</div>';

    // Binary representation (first 64 bits)
    const binary = ipv6ToBinary(expanded.split('/')[0]);
    html += '<div class="result-label">Binary (first 64 bits):</div>';
    html += '<div class="result-box" style="font-size: 0.75rem; word-break: break-all;">';
    html += binary.substring(0, 64).match(/.{1,16}/g).join(' ');
    html += '</div>';

    document.getElementById('results').innerHTML = html;
    document.getElementById('resultPlaceholder').style.display = 'none';
    document.getElementById('resultContent').style.display = 'block';

    // Address information
    displayAddressInfo(expanded.split('/')[0]);

    showToast('IPv6 address ' + operation + 'ed successfully!');
}

function displayAddressInfo(address) {
    let html = '';

    const type = getIPv6Type(address);
    const scope = getIPv6Scope(address);

    html += '<div class="info-item">';
    html += '<span class="info-label">Address Type: </span>';
    html += '<span class="info-value">' + escapeHtml(type) + '</span>';
    html += '</div>';

    html += '<div class="info-item">';
    html += '<span class="info-label">Scope: </span>';
    html += '<span class="info-value">' + escapeHtml(scope) + '</span>';
    html += '</div>';

    html += '<div class="info-item">';
    html += '<span class="info-label">Total Bits: </span>';
    html += '<span class="info-value">128 bits</span>';
    html += '</div>';

    html += '<div class="info-item">';
    html += '<span class="info-label">Total Address Space: </span>';
    html += '<span class="info-value">340 undecillion</span>';
    html += '</div>';

    document.getElementById('addressInfo').innerHTML = html;
    document.getElementById('addressInfoCard').style.display = 'block';
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
    return text.replace(/'/g, "\\'").replace(/\\/g, "\\\\").replace(/\n/g, "\\n").replace(/\r/g, "\\r");
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
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

    showToast('Copied to clipboard!');
}

function clearAll() {
    document.getElementById('ipv6Input').value = '';
    document.getElementById('resultsContainer').style.display = 'none';
    document.getElementById('resultPlaceholder').style.display = 'flex';
    document.getElementById('resultContent').style.display = 'none';
    document.getElementById('addressInfoCard').style.display = 'none';
}
</script>
</div>
<%@ include file="body-close.jsp"%>
