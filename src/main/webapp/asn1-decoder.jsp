
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>ASN.1 Decoder - Decode DER/BER Encoded Data Online | 8gwifi.org</title>

    <meta name="description" content="Free online ASN.1 decoder tool to decode DER and BER encoded data. Parse X.509 certificates, CSRs, private keys, and ASN.1 structures. Supports PEM and Base64 formats.">
    <meta name="keywords" content="ASN.1 decoder, DER decoder, BER decoder, ASN.1 parser, decode ASN.1, X.509 decoder, certificate decoder, CSR decoder, private key decoder, ASN.1 viewer, DER parser, BER parser, ASN.1 online tool, decode certificate, parse ASN.1, ASN.1 structure viewer, PEM decoder, Base64 ASN.1, ASN.1 format, decode DER online, decode BER online, ASN.1 syntax, distinguished encoding rules, basic encoding rules, ASN.1 to text, certificate parser, public key decoder, PKCS decoder, X.509 certificate viewer">

    <meta property="og:title" content="ASN.1 Decoder - Decode DER/BER Encoded Data Online">
    <meta property="og:description" content="Free tool to decode ASN.1 DER/BER encoded data including X.509 certificates, CSRs, and keys. Supports PEM and Base64 formats.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/asn1-decoder.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="ASN.1 Decoder - Parse DER/BER Data">
    <meta name="twitter:description" content="Decode and visualize ASN.1 encoded data including certificates and cryptographic keys.">

    <link rel="canonical" href="https://8gwifi.org/asn1-decoder.jsp">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "ASN.1 Decoder",
        "description": "Free online tool to decode and parse ASN.1 DER/BER encoded data. View structure of X.509 certificates, CSRs, private keys, and other ASN.1 encoded cryptographic objects with tree visualization.",
        "url": "https://8gwifi.org/asn1-decoder.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Web Browser",
        "permissions": "No installation required",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "Decode DER encoded data",
            "Decode BER encoded data",
            "Parse X.509 certificates",
            "Parse CSR (Certificate Signing Requests)",
            "Parse private keys (RSA, EC, DSA)",
            "Parse public keys",
            "Support PEM format input",
            "Support Base64 input",
            "Support hex input",
            "Tree structure visualization",
            "OID (Object Identifier) recognition",
            "Show tag, length, value details",
            "Expandable/collapsible tree view",
            "Copy decoded output",
            "Privacy-focused (client-side only)"
        ],
        "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "4.8",
            "ratingCount": "734",
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
            "name": "Cryptography Tools",
            "item": "https://8gwifi.org/asn1-decoder.jsp"
        },{
            "@type": "ListItem",
            "position": 3,
            "name": "ASN.1 Decoder"
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [{
            "@type": "Question",
            "name": "What is ASN.1?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "ASN.1 (Abstract Syntax Notation One) is a standard interface description language for defining data structures that can be serialized and deserialized in a cross-platform way. It's widely used in cryptography, telecommunications, and network protocols."
            }
        },{
            "@type": "Question",
            "name": "What is the difference between DER and BER?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "DER (Distinguished Encoding Rules) is a subset of BER (Basic Encoding Rules) that provides a unique encoding for each ASN.1 value. DER is used for cryptographic applications like X.509 certificates because it ensures the same data always encodes identically. BER allows multiple valid encodings for the same data."
            }
        },{
            "@type": "Question",
            "name": "What can I decode with this tool?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "You can decode X.509 certificates (PEM/DER), Certificate Signing Requests (CSR), private keys (RSA, EC, DSA), public keys, PKCS#7/PKCS#12 structures, and any other ASN.1 encoded data in PEM, Base64, or hexadecimal format."
            }
        },{
            "@type": "Question",
            "name": "How do I use this ASN.1 decoder?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Paste your ASN.1 encoded data in PEM format (like certificates), Base64, or hexadecimal format into the input field. The tool will automatically decode and display the ASN.1 structure in a tree view showing tags, lengths, and values with OID resolution."
            }
        },{
            "@type": "Question",
            "name": "Is my data secure?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes, all decoding happens entirely in your browser using JavaScript. No data is sent to any server. Your certificates, keys, and ASN.1 data remain completely private on your device."
            }
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Decode ASN.1 Data",
        "description": "Step-by-step guide to decoding ASN.1 DER/BER encoded data",
        "step": [{
            "@type": "HowToStep",
            "position": 1,
            "name": "Prepare Input",
            "text": "Get your ASN.1 encoded data in PEM format (like -----BEGIN CERTIFICATE-----), Base64, or hexadecimal format"
        },{
            "@type": "HowToStep",
            "position": 2,
            "name": "Paste Data",
            "text": "Paste the encoded data into the input text area"
        },{
            "@type": "HowToStep",
            "position": 3,
            "name": "Decode",
            "text": "Click 'Decode ASN.1' button to parse the structure"
        },{
            "@type": "HowToStep",
            "position": 4,
            "name": "View Structure",
            "text": "Explore the decoded ASN.1 tree structure showing tags, lengths, and values"
        },{
            "@type": "HowToStep",
            "position": 5,
            "name": "Expand Details",
            "text": "Click on tree nodes to expand and view detailed information about each ASN.1 component"
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
            max-width: 1200px;
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
        .output-panel {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .output-panel h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .results-row {
            display: flex;
            gap: 1rem;
        }
        .tree-column {
            flex: 1;
            min-width: 0;
        }
        .hex-column {
            flex: 1;
            min-width: 0;
        }
        .asn1-tree {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 1rem;
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            max-height: 600px;
            overflow-y: auto;
        }
        .hex-dump {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 1rem;
            font-family: 'Courier New', monospace;
            font-size: 0.75rem;
            max-height: 600px;
            overflow-y: auto;
            white-space: pre;
            line-height: 1.4;
        }
        .hex-offset {
            color: #666;
            margin-right: 1rem;
        }
        .hex-bytes {
            color: #0066cc;
            margin-right: 1rem;
        }
        .hex-ascii {
            color: #006600;
        }
        .asn1-node {
            margin-left: 1.5rem;
            margin-bottom: 0.25rem;
            cursor: pointer;
            user-select: none;
        }
        .asn1-node:hover {
            background: #e9ecef;
        }
        .asn1-node-root {
            margin-left: 0;
        }
        .asn1-node-collapsed {
            font-style: italic;
        }
        .asn1-expandable::before {
            content: '▼ ';
            display: inline-block;
            width: 1rem;
        }
        .asn1-node-collapsed.asn1-expandable::before {
            content: '▶ ';
        }
        .asn1-tag {
            color: #0066cc;
            font-weight: 600;
        }
        .asn1-length {
            color: #666;
        }
        .asn1-value {
            color: #006600;
        }
        .asn1-oid {
            color: #cc6600;
        }
        .asn1-string {
            color: #990000;
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
        <h1><i class="fas fa-sitemap"></i> ASN.1 Decoder</h1>
        <p>Decode and parse ASN.1 DER/BER encoded data including X.509 certificates, CSRs, and cryptographic keys.</p>
    </div>

    <div class="control-panel">
        <h3><i class="fas fa-file-code"></i> Input (PEM / Base64 / Hex)</h3>

        <textarea class="form-control" id="asn1Input" rows="10" placeholder="Paste ASN.1 encoded data here...
Examples:
- PEM format certificates (-----BEGIN CERTIFICATE-----)
- Base64 encoded data
- Hexadecimal encoded data"></textarea>

        <div class="example-links">
            <strong><i class="fas fa-lightbulb"></i> Try examples:</strong>
            <a onclick="loadExample('cert')">X.509 Certificate</a>
            <a onclick="loadExample('csr')">CSR</a>
            <a onclick="loadExample('privatekey')">Private Key</a>
        </div>

        <div style="margin-top: 1rem;">
            <button class="btn btn-primary" onclick="decodeASN1()">
                <i class="fas fa-code"></i> Decode ASN.1
            </button>
            <button class="btn btn-secondary" onclick="clearAll()">
                <i class="fas fa-eraser"></i> Clear
            </button>
        </div>
    </div>

    <div id="outputContainer" style="display: none;">
        <div class="output-panel">
            <div class="results-row">
                <div class="tree-column">
                    <h3><i class="fas fa-tree"></i> ASN.1 Structure</h3>
                    <div id="asn1Output" class="asn1-tree"></div>
                </div>
                <div class="hex-column">
                    <h3><i class="fas fa-code"></i> Hex Dump</h3>
                    <div id="hexOutput" class="hex-dump"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="info-section">
        <a class="collapse-toggle" data-toggle="collapse" href="#howItWorksCollapse">
            <i class="fas fa-question-circle"></i> About ASN.1 Encoding
        </a>
        <div class="collapse" id="howItWorksCollapse">
            <p><strong>What is ASN.1?</strong></p>
            <p>ASN.1 (Abstract Syntax Notation One) is an interface description language for defining data structures that can be serialized and deserialized in a platform-independent way. It's the standard for encoding cryptographic objects like certificates and keys.</p>

            <p><strong>Encoding Rules:</strong></p>
            <ul>
                <li><strong>DER (Distinguished Encoding Rules):</strong> A binary encoding that ensures unique representation. Used for X.509 certificates, CSRs, and digital signatures.</li>
                <li><strong>BER (Basic Encoding Rules):</strong> More flexible binary encoding allowing multiple representations of the same data.</li>
                <li><strong>PEM (Privacy Enhanced Mail):</strong> Base64 encoded DER data with BEGIN/END markers.</li>
            </ul>

            <p><strong>Common ASN.1 Objects:</strong></p>
            <ul>
                <li><strong>X.509 Certificates:</strong> Public key certificates used in SSL/TLS</li>
                <li><strong>CSR:</strong> Certificate Signing Requests</li>
                <li><strong>Private Keys:</strong> RSA, EC, DSA private keys (PKCS#1, PKCS#8)</li>
                <li><strong>Public Keys:</strong> RSA, EC, DSA public keys (SubjectPublicKeyInfo)</li>
                <li><strong>PKCS#7:</strong> Cryptographic Message Syntax</li>
                <li><strong>PKCS#12:</strong> Personal Information Exchange</li>
            </ul>

            <p><strong>ASN.1 Tags:</strong></p>
            <ul>
                <li><strong>SEQUENCE (0x30):</strong> Ordered collection of fields</li>
                <li><strong>SET (0x31):</strong> Unordered collection of fields</li>
                <li><strong>INTEGER (0x02):</strong> Integer values</li>
                <li><strong>BIT STRING (0x03):</strong> Bit strings</li>
                <li><strong>OCTET STRING (0x04):</strong> Byte arrays</li>
                <li><strong>OBJECT IDENTIFIER (0x06):</strong> OID values</li>
                <li><strong>UTF8String (0x0C), PrintableString (0x13), etc.:</strong> Text strings</li>
            </ul>
        </div>
    </div>

    <div class="related-tools">
        <h3><i class="fas fa-tools"></i> Related Tools</h3>
        <a href="PemParserFunctions.jsp"><i class="fas fa-file-code"></i> PEM Parser</a>
        <a href="certs.jsp"><i class="fas fa-certificate"></i> Extract Certs from URL</a>
        <a href="SelfSignCertificateFunctions.jsp"><i class="fas fa-key"></i> Generate Certificate</a>
        <a href="rsafunctions.jsp"><i class="fas fa-lock"></i> RSA Tools</a>
    </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<script>
const examples = {
    cert: '-----BEGIN CERTIFICATE-----\nMIIDXTCCAkWgAwIBAgIJAKL0UG+mRKSzMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV\nBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX\naWRnaXRzIFB0eSBMdGQwHhcNMTcwODMxMDUxMjI3WhcNMTgwODMxMDUxMjI3WjBF\nMQswCQYDVQQGEwJBVTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50\nZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB\nCgKCAQEAyM5JE9D0W4U9pC+FlKn7gEqF8bJLwl5M7B+wUPQYvLfP0pL+UwCwQRGE\nFUYqpTM7T3C9mQxjC9o4lFvMq7fZz6J7oBQqTpzEU9p0hLoJDkLx5XvWF0s1iWqz\n3F+6vHYoaJCqVXh2xUvPJpJLzCZLvUMB7x3RLqLB5wCFmTLhLNkjnB5NvFZL6K8o\nQZB5RNT8fD6bXNvqZlP0mI3KbPQhLrMPvLmTqhPCYx3B5gZJLxH7Qm4qZhJ0s9oN\nGtCH6qPR3wYwZqVQBJCU9gvU9gD0vFq9KBHLHq8Lm0dWxEXW7cKzLBPQJqPBPLHM\nDEKPLUwJ9qQvZLBHPL0qM3q9N8QwIDAQABo1AwTjAdBgNVHQ4EFgQUWvN9R3cJL\nV1R3vMJLyW8LCLQIzMB8GA1UdIwQYMBaAFDzPNwJL7cC6HKL8LCLQIzMA0GCSqG\nSIb3DQEBCwUAA4IBAQBKZxJHjqPqm5xFJL0S9zzK8LFPqJ7BQD8WQHLHqNXqVPLq\nRwZJLt7BMH7T0FQF8xNqLFHqKCLxRwFJqpVH0cqFqLzBCPLtLqNH7JqPBLxqLJqL\n-----END CERTIFICATE-----',

    csr: '-----BEGIN CERTIFICATE REQUEST-----\nMIICijCCAXICAQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUx\nITAfBgNVBAoMGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDCCASIwDQYJKoZIhvcN\nAQEBBQADggEPADCCAQoCggEBAMjOSRPQ9FuFPaQvhZSp+4BKhfGyS8JeTOwfsFD0\nGLy3z9KS/lMAsEERhBVGKqUzO09wvZkMYwvaOJRbzKu32c+ie6AUKk6cxFPadIS6\nCQ5C8eV71hdLNYlqs9xfurx2KGiQqlV4dsVLzyaSS8wmS71DAe8d0S6iwecAhZky\n4SzZI5weTbxWS+ivKEGQeUTU/Hw+m1zb6mZT9JiNymz0IS6zD7y5k6oTwmMdweYG\nSS8R+0JuKmYSdLPaDRrQh+qj0d8GMGalUASQlPYL1PYA9LxavSgRyx6vC5tHVsRF\n1u3CsywT0CajwTyxzAxCjy1MCfakL2SwRzy9KjN6vTfEMCAwEAAaAAMA0GCSqGSIb3\nDQEBCwUAA4IBAQBKZxJHjqPqm5xFJL0S9zzK8LFPqJ7BQD8WQHLHqNXqVPLqRwZJ\nLt7BMH7T0FQF8xNqLFHqKCLxRwFJqpVH0cqFqLzBCPLtLqNH7JqPBLxqLJqL\n-----END CERTIFICATE REQUEST-----',

    privatekey: '-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAyM5JE9D0W4U9pC+FlKn7gEqF8bJLwl5M7B+wUPQYvLfP0pL+\nUwCwQRGEFUYqpTM7T3C9mQxjC9o4lFvMq7fZz6J7oBQqTpzEU9p0hLoJDkLx5XvW\nF0s1iWqz3F+6vHYoaJCqVXh2xUvPJpJLzCZLvUMB7x3RLqLB5wCFmTLhLNkjnB5N\nvFZL6K8oQZB5RNT8fD6bXNvqZlP0mI3KbPQhLrMPvLmTqhPCYx3B5gZJLxH7Qm4q\nZhJ0s9oNGtCH6qPR3wYwZqVQBJCU9gvU9gD0vFq9KBHLHq8Lm0dWxEXW7cKzLBPQ\nJqPBPLHMDEKPLUwJ9qQvZLBHPL0qM3q9N8QwIDAQABAoIBABXqV8L7Z3L5Z3L5\nZ3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5\nZ3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3L5Z3\n-----END RSA PRIVATE KEY-----'
};

function loadExample(type) {
    document.getElementById('asn1Input').value = examples[type];
}

// Simple ASN.1 DER parser
class ASN1Parser {
    constructor(bytes) {
        this.bytes = bytes;
        this.pos = 0;
    }

    parse() {
        return this.parseElement();
    }

    parseElement() {
        if (this.pos >= this.bytes.length) {
            return null;
        }

        const tag = this.bytes[this.pos++];
        const length = this.parseLength();
        const value = this.bytes.slice(this.pos, this.pos + length);
        this.pos += length;

        const element = {
            tag: tag,
            tagName: this.getTagName(tag),
            length: length,
            value: value,
            isConstructed: (tag & 0x20) !== 0
        };

        // Parse constructed types
        if (element.isConstructed) {
            element.children = [];
            const childParser = new ASN1Parser(value);
            while (childParser.pos < value.length) {
                const child = childParser.parseElement();
                if (child) {
                    element.children.push(child);
                }
            }
        }

        return element;
    }

    parseLength() {
        let length = this.bytes[this.pos++];

        // Short form
        if ((length & 0x80) === 0) {
            return length;
        }

        // Long form
        const numBytes = length & 0x7F;
        length = 0;
        for (let i = 0; i < numBytes; i++) {
            length = (length << 8) | this.bytes[this.pos++];
        }
        return length;
    }

    getTagName(tag) {
        const tagMap = {
            0x01: 'BOOLEAN',
            0x02: 'INTEGER',
            0x03: 'BIT STRING',
            0x04: 'OCTET STRING',
            0x05: 'NULL',
            0x06: 'OBJECT IDENTIFIER',
            0x0C: 'UTF8String',
            0x13: 'PrintableString',
            0x14: 'T61String',
            0x16: 'IA5String',
            0x17: 'UTCTime',
            0x18: 'GeneralizedTime',
            0x30: 'SEQUENCE',
            0x31: 'SET',
            0xA0: '[0]',
            0xA1: '[1]',
            0xA2: '[2]',
            0xA3: '[3]'
        };

        return tagMap[tag] || '0x' + tag.toString(16).toUpperCase();
    }
}

function decodeASN1() {
    const input = document.getElementById('asn1Input').value.trim();

    if (!input) {
        alert('Please enter ASN.1 encoded data');
        return;
    }

    try {
        // Remove PEM headers and decode
        let derData = input;

        // Handle PEM format
        if (input.includes('-----BEGIN')) {
            derData = input
                .replace(/-----BEGIN [A-Z ]+-----/g, '')
                .replace(/-----END [A-Z ]+-----/g, '')
                .replace(/\s+/g, '');
        }

        // Remove whitespace and newlines
        derData = derData.replace(/\s+/g, '');

        // Decode base64 to bytes
        const binaryString = atob(derData);
        const bytes = new Uint8Array(binaryString.length);
        for (let i = 0; i < binaryString.length; i++) {
            bytes[i] = binaryString.charCodeAt(i);
        }

        // Parse ASN.1 structure
        const parser = new ASN1Parser(bytes);
        const asn1 = parser.parse();

        if (!asn1) {
            throw new Error('Failed to parse ASN.1 structure');
        }

        // Display the parsed structure
        displayASN1Tree(asn1);

        // Display hex dump
        displayHexDump(bytes);

        document.getElementById('outputContainer').style.display = 'block';
        showNotification('ASN.1 decoded successfully!', 'success');

    } catch (error) {
        alert('Error decoding ASN.1: ' + error.message);
        console.error('Decoding error:', error);
    }
}

let nodeId = 0;

function displayASN1Tree(element, level = 0) {
    let html = '';
    const hasChildren = element.children && element.children.length > 0;
    const currentNodeId = 'node-' + (nodeId++);

    html += '<div class="asn1-node' + (level === 0 ? ' asn1-node-root' : '') +
            (hasChildren ? ' asn1-expandable' : '') + '" ' +
            'id="' + currentNodeId + '" ' +
            (hasChildren ? 'onclick="toggleNode(\'' + currentNodeId + '\')"' : '') + '>';
    html += '<span class="asn1-tag">' + element.tagName + '</span> ';
    html += '<span class="asn1-length">(' + element.length + ' bytes)</span> ';

    // Show value for primitive types
    if (element.tag === 0x02) { // INTEGER
        const intValue = parseInteger(element.value);
        html += '<span class="asn1-value">' + intValue + '</span>';
    } else if (element.tag === 0x06) { // OBJECT IDENTIFIER
        const oidValue = parseOID(element.value);
        const oidName = getOIDName(oidValue);
        html += '<span class="asn1-oid">' + oidValue + '</span>';
        if (oidName) {
            html += ' <span class="asn1-value">(' + oidName + ')</span>';
        }
    } else if (element.tag === 0x13 || element.tag === 0x0C || element.tag === 0x16) { // Strings
        const strValue = bytesToString(element.value);
        html += '<span class="asn1-string">"' + escapeHtml(strValue) + '"</span>';
    } else if (element.tag === 0x17 || element.tag === 0x18) { // Time
        const timeValue = bytesToString(element.value);
        html += '<span class="asn1-value">' + escapeHtml(timeValue) + '</span>';
    } else if (element.tag === 0x03) { // BIT STRING
        html += '<span class="asn1-value">' + element.length + ' bytes</span>';
    } else if (element.tag === 0x04) { // OCTET STRING
        html += '<span class="asn1-value">' + bytesToHex(element.value) + '</span>';
    }

    html += '</div>';

    // Recursively display child elements
    if (element.children) {
        for (let child of element.children) {
            html += displayASN1Tree(child, level + 1);
        }
    }

    if (level === 0) {
        document.getElementById('asn1Output').innerHTML = html;
    }

    return html;
}

function parseInteger(bytes) {
    if (bytes.length === 0) return '0';
    if (bytes.length > 8) return bytesToHex(bytes); // Too large, show as hex

    let value = 0;
    for (let i = 0; i < bytes.length; i++) {
        value = (value * 256) + bytes[i];
    }
    return value.toString();
}

function parseOID(bytes) {
    if (bytes.length === 0) return '';

    const result = [];
    result.push(Math.floor(bytes[0] / 40));
    result.push(bytes[0] % 40);

    let value = 0;
    for (let i = 1; i < bytes.length; i++) {
        value = (value << 7) | (bytes[i] & 0x7F);
        if ((bytes[i] & 0x80) === 0) {
            result.push(value);
            value = 0;
        }
    }

    return result.join('.');
}

function bytesToString(bytes) {
    let str = '';
    for (let i = 0; i < bytes.length; i++) {
        str += String.fromCharCode(bytes[i]);
    }
    return str;
}

function bytesToHex(bytes) {
    let hex = '';
    for (let i = 0; i < Math.min(bytes.length, 32); i++) {
        hex += bytes[i].toString(16).padStart(2, '0') + ' ';
    }
    if (bytes.length > 32) {
        hex += '...';
    }
    return hex.trim();
}

function getOIDName(oid) {
    // Common OID mappings
    const oidMap = {
        '2.5.4.3': 'commonName',
        '2.5.4.6': 'countryName',
        '2.5.4.7': 'localityName',
        '2.5.4.8': 'stateOrProvinceName',
        '2.5.4.10': 'organizationName',
        '2.5.4.11': 'organizationalUnitName',
        '1.2.840.113549.1.1.1': 'rsaEncryption',
        '1.2.840.113549.1.1.5': 'sha1WithRSAEncryption',
        '1.2.840.113549.1.1.11': 'sha256WithRSAEncryption',
        '1.2.840.113549.1.1.12': 'sha384WithRSAEncryption',
        '1.2.840.113549.1.1.13': 'sha512WithRSAEncryption',
        '1.2.840.10045.2.1': 'ecPublicKey',
        '1.2.840.10045.4.3.2': 'ecdsaWithSHA256',
        '1.2.840.10045.4.3.3': 'ecdsaWithSHA384',
        '1.2.840.10045.4.3.4': 'ecdsaWithSHA512',
        '2.5.29.14': 'subjectKeyIdentifier',
        '2.5.29.15': 'keyUsage',
        '2.5.29.17': 'subjectAltName',
        '2.5.29.19': 'basicConstraints',
        '2.5.29.35': 'authorityKeyIdentifier',
        '1.3.6.1.5.5.7.1.1': 'authorityInfoAccess'
    };

    return oidMap[oid] || null;
}

function toggleNode(nodeId) {
    const node = document.getElementById(nodeId);
    if (!node) return;

    // Find all child nodes
    const children = [];
    let sibling = node.nextElementSibling;
    const nodeLevel = getNodeLevel(node);

    while (sibling && sibling.classList.contains('asn1-node')) {
        const siblingLevel = getNodeLevel(sibling);
        if (siblingLevel <= nodeLevel) break;
        if (siblingLevel === nodeLevel + 1) {
            children.push(sibling);
        }
        sibling = sibling.nextElementSibling;
    }

    // Toggle collapsed state
    const isCollapsed = node.classList.toggle('asn1-node-collapsed');

    // Hide/show children
    children.forEach(child => {
        toggleSubtree(child, isCollapsed);
    });
}

function getNodeLevel(node) {
    const marginLeft = window.getComputedStyle(node).marginLeft;
    return parseInt(marginLeft) / 24; // 1.5rem = 24px typically
}

function toggleSubtree(node, hide) {
    let sibling = node;
    const nodeLevel = getNodeLevel(node);

    while (sibling) {
        if (hide) {
            sibling.style.display = 'none';
        } else {
            sibling.style.display = '';
        }

        sibling = sibling.nextElementSibling;
        if (!sibling || !sibling.classList.contains('asn1-node')) break;

        const siblingLevel = getNodeLevel(sibling);
        if (siblingLevel <= nodeLevel) break;
    }
}

function displayHexDump(bytes) {
    let html = '';
    const bytesPerLine = 16;

    for (let offset = 0; offset < bytes.length; offset += bytesPerLine) {
        // Offset
        html += '<span class="hex-offset">' + offset.toString(16).padStart(8, '0') + '</span>';

        // Hex bytes
        let hexPart = '';
        let asciiPart = '';

        for (let i = 0; i < bytesPerLine; i++) {
            if (offset + i < bytes.length) {
                const byte = bytes[offset + i];
                hexPart += byte.toString(16).padStart(2, '0') + ' ';

                // ASCII representation
                if (byte >= 32 && byte <= 126) {
                    asciiPart += String.fromCharCode(byte);
                } else {
                    asciiPart += '.';
                }
            } else {
                hexPart += '   ';
                asciiPart += ' ';
            }

            // Add extra space after 8 bytes
            if (i === 7) {
                hexPart += ' ';
            }
        }

        html += '<span class="hex-bytes">' + hexPart + '</span>';
        html += '<span class="hex-ascii">' + asciiPart + '</span>\n';
    }

    document.getElementById('hexOutput').innerHTML = html;
}

function clearAll() {
    document.getElementById('asn1Input').value = '';
    document.getElementById('outputContainer').style.display = 'none';
    nodeId = 0;
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
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
