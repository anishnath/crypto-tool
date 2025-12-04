<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>IP Subnet Calculator Online – CIDR, Network Range, Hosts – Free | 8gwifi.org</title>
    <meta name="description" content="Free online IP subnet calculator. Calculate subnet mask, network address, broadcast address, wildcard mask, and usable host range from CIDR notation. Supports IPv4 subnetting." />
    <meta name="keywords" content="subnet calculator, CIDR calculator, IP subnet calculator, network calculator, subnet mask calculator, IP address calculator, subnetting, network planning, IPv4 calculator" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/SubnetFunctions.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="IP Subnet Calculator - CIDR Network Calculator" />
    <meta property="og:description" content="Calculate subnet ranges, network addresses, broadcast addresses from CIDR notation. Free online tool for network administrators." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/SubnetFunctions.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/site/subnet.png" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="IP Subnet Calculator – CIDR, Network Range, Hosts" />
    <meta name="twitter:description" content="Calculate subnet mask, network, broadcast, wildcard mask, usable host range from CIDR. Free online IPv4 subnet tool." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/subnet.png" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "IP Subnet Calculator",
        "alternateName": ["CIDR Calculator", "Network Subnet Calculator", "IPv4 Subnet Calculator"],
        "description": "Online IP subnet calculator to calculate subnet ranges, network addresses, broadcast addresses, wildcard masks, and available host addresses using CIDR notation. Essential tool for network planning and administration.",
        "url": "https://8gwifi.org/SubnetFunctions.jsp",
        "image": "https://8gwifi.org/images/site/subnet.png",
        "applicationCategory": "NetworkApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "softwareVersion": "2.0",
        "featureList": [
            "CIDR to subnet mask conversion",
            "Network address calculation",
            "Broadcast address calculation",
            "Wildcard mask calculation",
            "Usable host range calculation",
            "Binary IP representation",
            "Network class identification",
            "Private network detection",
            "IP address list generation"
        ],
        "screenshot": "https://8gwifi.org/images/site/subnet.png",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://x.com/anish2good"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "datePublished": "2017-11-03",
        "dateModified": "2025-01-28",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "audience": {
            "@type": "Audience",
            "audienceType": "Network Administrators, System Administrators, IT Professionals, DevOps Engineers, Network Engineers"
        }
    }
    </script>

    <!-- JSON-LD FAQPage Schema for Rich Snippets -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "What is CIDR notation?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "CIDR (Classless Inter-Domain Routing) notation is a compact representation of an IP address and its associated network mask. It's written as IP/prefix, like 192.168.1.0/24, where /24 indicates that the first 24 bits are the network portion. This replaced the older classful addressing system and allows for more flexible allocation of IP addresses."
                }
            },
            {
                "@type": "Question",
                "name": "How do I calculate subnet mask from CIDR?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "To convert CIDR to subnet mask: The CIDR prefix (e.g., /24) indicates how many bits are set to 1 in the subnet mask. For /24, the first 24 bits are 1s: 11111111.11111111.11111111.00000000, which equals 255.255.255.0. Common conversions: /8=255.0.0.0, /16=255.255.0.0, /24=255.255.255.0, /28=255.255.255.240, /30=255.255.255.252."
                }
            },
            {
                "@type": "Question",
                "name": "What is a broadcast address?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A broadcast address is the last IP address in a subnet, used to send data to all hosts on that network simultaneously. It's calculated by setting all host bits to 1. For example, in 192.168.1.0/24, the broadcast address is 192.168.1.255. Packets sent to this address are received by all devices on the subnet."
                }
            },
            {
                "@type": "Question",
                "name": "How many usable hosts are in a subnet?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "The number of usable hosts = 2^(host bits) - 2. We subtract 2 because the network address (all host bits 0) and broadcast address (all host bits 1) cannot be assigned to hosts. For /24: 2^8 - 2 = 254 hosts. For /28: 2^4 - 2 = 14 hosts. For /30: 2^2 - 2 = 2 hosts (point-to-point links)."
                }
            },
            {
                "@type": "Question",
                "name": "What is a wildcard mask?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A wildcard mask is the inverse of a subnet mask, used primarily in access control lists (ACLs) and routing protocols like OSPF. It's calculated by subtracting each subnet mask octet from 255. For subnet mask 255.255.255.0, the wildcard mask is 0.0.0.255. Wildcard masks use 0s to indicate bits that must match and 1s for bits that can vary."
                }
            },
            {
                "@type": "Question",
                "name": "What are RFC 1918 private IP addresses?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "RFC 1918 defines three private IP address ranges not routed on the public internet: 10.0.0.0/8 (10.0.0.0-10.255.255.255), 172.16.0.0/12 (172.16.0.0-172.31.255.255), and 192.168.0.0/16 (192.168.0.0-192.168.255.255). These are used for internal networks and require NAT (Network Address Translation) to access the internet."
                }
            }
        ]
    }
    </script>

    <!-- JSON-LD HowTo Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Calculate IP Subnet",
        "description": "Step-by-step guide to calculate subnet information from CIDR notation",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter CIDR Notation",
                "text": "Enter your IP address with CIDR prefix (e.g., 192.168.1.0/24) in the input field"
            },
            {
                "@type": "HowToStep",
                "name": "Select Options",
                "text": "Choose whether to include the full IP address list in the results"
            },
            {
                "@type": "HowToStep",
                "name": "Calculate",
                "text": "Click Calculate to get network address, broadcast address, subnet mask, and host range"
            },
            {
                "@type": "HowToStep",
                "name": "Review Results",
                "text": "Review the calculated subnet information including usable hosts, wildcard mask, and binary representations"
            }
        ]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #0891b2;
            --theme-secondary: #06b6d4;
            --theme-gradient: linear-gradient(135deg, #0891b2 0%, #06b6d4 100%);
            --theme-light: #ecfeff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(8, 145, 178, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(8, 145, 178, 0.25);
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
            min-height: 300px;
        }
        .result-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            min-height: 250px;
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
        .cidr-slider {
            width: 100%;
            height: 8px;
            border-radius: 4px;
            background: #e9ecef;
            outline: none;
            -webkit-appearance: none;
        }
        .cidr-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: var(--theme-gradient);
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        .preset-btn {
            padding: 0.4rem 0.75rem;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            background: white;
            cursor: pointer;
            font-size: 0.75rem;
            transition: all 0.2s;
        }
        .preset-btn:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .result-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
        }
        .result-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 0.75rem;
        }
        .result-item label {
            font-size: 0.7rem;
            color: #6c757d;
            margin-bottom: 0.25rem;
            display: block;
        }
        .result-item .value {
            font-family: monospace;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--theme-primary);
            word-break: break-all;
        }
        .binary-display {
            font-family: monospace;
            font-size: 0.75rem;
            background: #1e1e1e;
            color: #4ec9b0;
            padding: 0.5rem;
            border-radius: 4px;
            overflow-x: auto;
        }
        .binary-display .network-bits { color: #ce9178; }
        .binary-display .host-bits { color: #9cdcfe; }
        .ip-list {
            max-height: 200px;
            overflow-y: auto;
            font-family: monospace;
            font-size: 0.75rem;
            background: #f8f9fa;
            padding: 0.5rem;
            border-radius: 4px;
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
            box-shadow: 0 2px 8px rgba(8, 145, 178, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 { color: var(--theme-primary); margin-bottom: 0.25rem; font-size: 0.9rem; }
        .related-tool-card p { font-size: 0.75rem; color: #6c757d; margin: 0; }
        .terminal-block { background: #1e1e1e; border-radius: 8px; overflow: hidden; }
        .terminal-header { background: #323232; color: #d4d4d4; padding: 0.5rem 1rem; font-size: 0.75rem; display: flex; justify-content: space-between; align-items: center; }
        .terminal-body { padding: 1rem; color: #4ec9b0; font-family: monospace; font-size: 0.8rem; }
        .terminal-body code { color: #ce9178; }
        .badge-private { background: #22c55e; color: white; font-size: 0.65rem; padding: 0.15rem 0.4rem; border-radius: 4px; }
        .badge-public { background: #ef4444; color: white; font-size: 0.65rem; padding: 0.15rem 0.4rem; border-radius: 4px; }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="network-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">IP Subnet Calculator</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-network-wired"></i> IPv4</span>
            <span class="info-badge"><i class="fas fa-sitemap"></i> CIDR</span>
            <span class="info-badge"><i class="fas fa-calculator"></i> Subnetting</span>
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
                <h5><i class="fas fa-calculator me-2"></i>Calculate Subnet</h5>
            </div>
            <div class="card-body">
                <form id="subnetForm">
                    <input type="hidden" name="methodName" value="SUBNETCOMMAND">

                    <!-- Subnet Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-network-wired me-1"></i>IP Address / CIDR</div>
                        <input type="text" class="form-control" id="subnet" name="subnet" value="192.168.1.0/24" placeholder="e.g., 192.168.1.0/24">
                        <small class="text-muted">Enter IP with CIDR prefix (e.g., 10.0.0.0/8, 172.16.0.0/16)</small>
                    </div>

                    <!-- CIDR Slider -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-sliders-h me-1"></i>CIDR Prefix: /<span id="cidrValue">24</span></div>
                        <input type="range" class="cidr-slider" id="cidrSlider" min="8" max="30" value="24" oninput="updateCidr()">
                        <div class="d-flex justify-content-between small text-muted mt-1">
                            <span>/8 (16M hosts)</span>
                            <span>/16 (65K)</span>
                            <span>/24 (254)</span>
                            <span>/30 (2)</span>
                        </div>
                    </div>

                    <!-- Common Presets -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-bookmark me-1"></i>Common Subnets</div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="preset-btn" onclick="applyPreset('10.0.0.0/8')">Class A Private</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('172.16.0.0/12')">Class B Private</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('192.168.1.0/24')">Class C Private</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('192.168.1.0/28')">/28 (16 IPs)</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('10.0.0.0/30')">Point-to-Point</button>
                        </div>
                    </div>

                    <!-- Options -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-cog me-1"></i>Options</div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="includeAddresses" name="encoding" value="Y">
                            <label class="form-check-label small" for="includeAddresses">
                                Include IP address list (for small subnets)
                            </label>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100" id="calculateBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-calculator me-2"></i>Calculate Subnet
                    </button>
                </form>
            </div>
        </div>

        <!-- Quick Reference -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-table me-2"></i>CIDR Quick Reference</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-sm table-striped mb-0 small">
                        <thead class="table-light">
                        <tr><th>CIDR</th><th>Subnet Mask</th><th>Hosts</th></tr>
                        </thead>
                        <tbody>
                        <tr><td>/8</td><td>255.0.0.0</td><td>16,777,214</td></tr>
                        <tr><td>/16</td><td>255.255.0.0</td><td>65,534</td></tr>
                        <tr><td>/24</td><td>255.255.255.0</td><td>254</td></tr>
                        <tr><td>/25</td><td>255.255.255.128</td><td>126</td></tr>
                        <tr><td>/26</td><td>255.255.255.192</td><td>62</td></tr>
                        <tr><td>/27</td><td>255.255.255.224</td><td>30</td></tr>
                        <tr><td>/28</td><td>255.255.255.240</td><td>14</td></tr>
                        <tr><td>/29</td><td>255.255.255.248</td><td>6</td></tr>
                        <tr><td>/30</td><td>255.255.255.252</td><td>2</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Subnet Information</h5>
                <button class="btn btn-sm btn-light" onclick="copyResults()" id="copyBtn" style="display: none;"><i class="fas fa-copy"></i></button>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-network-wired fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Subnet information will appear here</p>
                        <small class="text-muted">Enter a CIDR address and click Calculate</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent"></div>
            </div>
        </div>

        <!-- CLI Commands -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-terminal me-2"></i>CLI Commands</h6>
            </div>
            <div class="card-body p-0">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Linux: Calculate subnet with ipcalc</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('ipcalc 192.168.1.0/24')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ ipcalc <code>192.168.1.0/24</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Windows: Show IP configuration</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('ipconfig /all')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">C:\> ipconfig <code>/all</code></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Network Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="dns.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>DNS Lookup</h6>
                <p>Query DNS records for any domain</p>
            </a>
            <a href="revdns.jsp" class="related-tool-card">
                <h6><i class="fas fa-undo me-1"></i>Reverse DNS</h6>
                <p>IP to hostname lookup</p>
            </a>
            <a href="portscan.jsp" class="related-tool-card">
                <h6><i class="fas fa-shield-alt me-1"></i>Port Scanner</h6>
                <p>Scan open ports on host</p>
            </a>
            <a href="whois.jsp" class="related-tool-card">
                <h6><i class="fas fa-user me-1"></i>Whois Lookup</h6>
                <p>Domain registration info</p>
            </a>
            <a href="pingfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-satellite-dish me-1"></i>Ping Tool</h6>
                <p>Test host reachability</p>
            </a>
            <a href="mtr.jsp" class="related-tool-card">
                <h6><i class="fas fa-route me-1"></i>MTR Traceroute</h6>
                <p>Network path analysis</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Visible FAQs -->
<h2 class="mt-4" id="faqs">FAQs</h2>
<div class="accordion" id="subnetFaqs">
  <div class="card"><div class="card-header"><h6 class="mb-0">How many usable hosts are in a subnet?</h6></div><div class="card-body small text-muted">Usable hosts = total IPs minus network and broadcast. /24 → 254 usable; /28 → 14 usable.</div></div>
  <div class="card"><div class="card-header"><h6 class="mb-0">Which private ranges should I use?</h6></div><div class="card-body small text-muted">RFC1918: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16. Avoid overlaps across environments.</div></div>
  <div class="card"><div class="card-header"><h6 class="mb-0">What is a wildcard mask?</h6></div><div class="card-body small text-muted">Wildcard is inverse of subnet mask; used in ACLs. For 255.255.255.0, wildcard is 0.0.0.255.</div></div>
</div>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding IP Subnetting</h5>
    </div>
    <div class="card-body">
        <h6>What is Subnetting?</h6>
        <p>Subnetting is the practice of dividing a network into smaller, more manageable sub-networks (subnets). This improves network performance, security, and simplifies administration. Each subnet has its own network address, broadcast address, and range of usable host addresses.</p>

        <h6 class="mt-4">CIDR Notation Explained</h6>
        <p>CIDR (Classless Inter-Domain Routing) notation combines an IP address with its subnet mask in a compact format: <code>192.168.1.0/24</code>. The number after the slash indicates how many bits are used for the network portion (prefix length).</p>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="alert alert-info">
                    <h6><i class="fas fa-lightbulb me-1"></i>Network Address</h6>
                    <p class="small mb-0">The first address in a subnet, where all host bits are 0. It identifies the network itself and cannot be assigned to a host.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning">
                    <h6><i class="fas fa-broadcast-tower me-1"></i>Broadcast Address</h6>
                    <p class="small mb-0">The last address in a subnet, where all host bits are 1. Packets sent here reach all hosts on the subnet.</p>
                </div>
            </div>
        </div>

        <h6 class="mt-4">RFC 1918 Private Address Ranges</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr><th>Range</th><th>CIDR</th><th>Addresses</th><th>Typical Use</th></tr>
                </thead>
                <tbody class="small">
                <tr><td>10.0.0.0 - 10.255.255.255</td><td>10.0.0.0/8</td><td>16,777,216</td><td>Large enterprises, data centers</td></tr>
                <tr><td>172.16.0.0 - 172.31.255.255</td><td>172.16.0.0/12</td><td>1,048,576</td><td>Medium organizations</td></tr>
                <tr><td>192.168.0.0 - 192.168.255.255</td><td>192.168.0.0/16</td><td>65,536</td><td>Home networks, small offices</td></tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Subnet Calculation Formula</h6>
        <div class="alert alert-secondary">
            <ul class="mb-0 small">
                <li><strong>Number of subnets:</strong> 2<sup>(borrowed bits)</sup></li>
                <li><strong>Hosts per subnet:</strong> 2<sup>(host bits)</sup> - 2</li>
                <li><strong>Host bits:</strong> 32 - prefix length</li>
                <li><strong>Wildcard mask:</strong> 255.255.255.255 - subnet mask</li>
            </ul>
        </div>
    </div>
</div>

<%@ include file="addcomments.jsp"%>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share Subnet</h5>
                <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <div class="input-group">
                    <input type="text" class="form-control" id="shareUrlText" readonly>
                    <button class="btn btn-success" type="button" id="copyShareUrl"><i class="fas fa-copy"></i> Copy</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var lastResult = null;

    $(document).ready(function() {
        loadFromUrl();

        $('#subnetForm').submit(function(e) {
            e.preventDefault();
            calculateSubnet();
        });

        $('#copyShareUrl').click(function() {
            navigator.clipboard.writeText($('#shareUrlText').val()).then(function() {
                $('#copyShareUrl').html('<i class="fas fa-check"></i> Copied!');
                setTimeout(function() { $('#copyShareUrl').html('<i class="fas fa-copy"></i> Copy'); }, 1500);
            });
        });
    });

    function updateCidr() {
        var cidr = $('#cidrSlider').val();
        $('#cidrValue').text(cidr);
        var subnet = $('#subnet').val();
        if (subnet.includes('/')) {
            subnet = subnet.split('/')[0] + '/' + cidr;
            $('#subnet').val(subnet);
        }
    }

    function applyPreset(preset) {
        $('#subnet').val(preset);
        var cidr = preset.split('/')[1];
        $('#cidrSlider').val(cidr);
        $('#cidrValue').text(cidr);
        showToast('Applied preset: ' + preset);
    }

    function calculateSubnet() {
        var subnet = $('#subnet').val().trim();
        if (!subnet) { showToast('Please enter a subnet'); return; }

        $('#calculateBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Calculating...');

        $.ajax({
            type: "POST",
            url: "SubnetFunctionality",
            data: $('#subnetForm').serialize(),
            dataType: "json",
            success: function(response) {
                $('#calculateBtn').prop('disabled', false).html('<i class="fas fa-calculator me-2"></i>Calculate Subnet');
                if (response.success) {
                    lastResult = response;
                    var html = renderResults(response);
                    $('#resultPlaceholder').hide();
                    $('#resultContent').html(html).show();
                    $('#copyBtn').show();
                } else {
                    showError(response.errorMessage || 'Calculation failed');
                }
            },
            error: function(xhr, status, error) {
                $('#calculateBtn').prop('disabled', false).html('<i class="fas fa-calculator me-2"></i>Calculate Subnet');
                showError('Request failed: ' + error);
            }
        });
    }

    function renderResults(data) {
        var net = data.network;
        var html = '';

        // Network type badge
        html += '<div class="mb-3">';
        html += '<span class="badge ' + (net.isPrivate ? 'badge-private' : 'badge-public') + '">';
        html += net.isPrivate ? '<i class="fas fa-lock me-1"></i>Private Network' : '<i class="fas fa-globe me-1"></i>Public Network';
        html += '</span> <span class="badge bg-secondary">Class ' + net.networkClass + '</span>';
        html += '</div>';

        // Main results grid
        html += '<div class="result-grid">';
        html += '<div class="result-item"><label>Network Address</label><div class="value">' + net.networkAddress + '</div></div>';
        html += '<div class="result-item"><label>Broadcast Address</label><div class="value">' + net.broadcastAddress + '</div></div>';
        html += '<div class="result-item"><label>Subnet Mask</label><div class="value">' + net.subnetMask + '</div></div>';
        html += '<div class="result-item"><label>Wildcard Mask</label><div class="value">' + net.wildcardMask + '</div></div>';
        html += '<div class="result-item"><label>First Usable IP</label><div class="value">' + net.lowAddress + '</div></div>';
        html += '<div class="result-item"><label>Last Usable IP</label><div class="value">' + net.highAddress + '</div></div>';
        html += '<div class="result-item"><label>Total Addresses</label><div class="value">' + parseInt(net.addressCount).toLocaleString() + '</div></div>';
        html += '<div class="result-item"><label>Usable Hosts</label><div class="value">' + parseInt(net.usableHosts).toLocaleString() + '</div></div>';
        html += '<div class="result-item"><label>CIDR Notation</label><div class="value">' + net.cidrNotation + '</div></div>';
        html += '<div class="result-item"><label>Prefix / Host Bits</label><div class="value">/' + net.prefixLength + ' (' + net.hostBits + ' host bits)</div></div>';
        html += '</div>';

        // Binary representation
        if (net.binary) {
            html += '<div class="mt-3"><label class="small text-muted">Binary Representation</label>';
            html += '<div class="binary-display">';
            html += '<div><span class="text-muted">Network:  </span>' + formatBinary(net.binary.networkAddress, net.prefixLength) + '</div>';
            html += '<div><span class="text-muted">Mask:     </span>' + net.binary.subnetMask + '</div>';
            html += '<div><span class="text-muted">Broadcast:</span>' + formatBinary(net.binary.broadcastAddress, net.prefixLength) + '</div>';
            html += '</div></div>';
        }

        // IP address list
        if (data.addresses && data.addresses.length > 0) {
            html += '<div class="mt-3"><label class="small text-muted">IP Addresses (' + data.addresses.length;
            if (data.addressListTruncated) html += ' of ' + data.totalAddresses + ' - truncated';
            html += ')</label><div class="ip-list">' + data.addresses.join('<br>') + '</div></div>';
        } else if (data.addressListError) {
            html += '<div class="alert alert-warning mt-3 small"><i class="fas fa-exclamation-triangle me-1"></i>' + data.addressListError + '</div>';
        }

        // Action buttons
        html += '<div class="d-flex gap-2 mt-3">';
        html += '<button class="btn btn-sm btn-outline-info" onclick="shareSubnet()"><i class="fas fa-share-alt me-1"></i>Share</button>';
        html += '<button class="btn btn-sm btn-outline-secondary" onclick="downloadResults()"><i class="fas fa-download me-1"></i>Download</button>';
        html += '</div>';

        return html;
    }

    function formatBinary(binary, prefixLength) {
        var flat = binary.replace(/\./g, '');
        var result = '';
        for (var i = 0; i < 32; i++) {
            if (i > 0 && i % 8 === 0) result += '.';
            if (i < prefixLength) result += '<span class="network-bits">' + flat[i] + '</span>';
            else result += '<span class="host-bits">' + flat[i] + '</span>';
        }
        return result;
    }

    function showError(message) {
        var html = '<div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>' + message + '</div>';
        $('#resultPlaceholder').hide();
        $('#resultContent').html(html).show();
    }

    function shareSubnet() {
        if (!lastResult) return;
        var url = window.location.origin + window.location.pathname + '?subnet=' + encodeURIComponent(lastResult.input);
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    function copyResults() {
        if (!lastResult) return;
        var net = lastResult.network;
        var text = 'Subnet: ' + lastResult.input + '\nNetwork: ' + net.networkAddress + '\nBroadcast: ' + net.broadcastAddress + '\nMask: ' + net.subnetMask + '\nRange: ' + net.lowAddress + ' - ' + net.highAddress + '\nUsable Hosts: ' + net.usableHosts;
        navigator.clipboard.writeText(text).then(function() { showToast('Results copied!'); });
    }

    function downloadResults() {
        if (!lastResult) return;
        var blob = new Blob([JSON.stringify(lastResult, null, 2)], { type: 'application/json' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'subnet-' + lastResult.input.replace('/', '-') + '.json';
        a.click();
        URL.revokeObjectURL(url);
        showToast('Downloaded!');
    }

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var subnet = params.get('subnet');
        if (subnet) {
            $('#subnet').val(subnet);
            var cidr = subnet.split('/')[1];
            if (cidr) { $('#cidrSlider').val(cidr); $('#cidrValue').text(cidr); }
            setTimeout(function() { calculateSubnet(); }, 500);
        }
    }

    function copyCommand(cmd) {
        navigator.clipboard.writeText(cmd).then(function() { showToast('Command copied!'); });
    }

    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;"><div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);"><i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
    }
</script>

<%@ include file="body-close.jsp"%>
