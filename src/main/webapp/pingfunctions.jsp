<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Online Ping Tool – IPv4/IPv6 Connectivity Test – Free | 8gwifi.org</title>
    <meta name="description" content="Free online ping tool to test IPv4 and IPv6 connectivity. Check host reachability, response time, packet loss, and geolocation from our servers." />
    <meta name="keywords" content="ping online, ping tool, ping test, ipv4 ping, ipv6 ping, icmp test, network connectivity, response time, packet loss, host reachability" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/pingfunctions.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="Online Ping Tool - Test IPv4/IPv6 Connectivity" />
    <meta property="og:description" content="Test network connectivity with our free online ping tool. Check host reachability and response times for IPv4 and IPv6 addresses." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/pingfunctions.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/site/logo.png" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Online Ping Tool – IPv4/IPv6 Connectivity Test" />
    <meta name="twitter:description" content="Test host reachability, response time, and packet loss for IPv4/IPv6. Free online ping tool." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/logo.png" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Online Ping Tool",
        "alternateName": ["Ping Test", "ICMP Echo Tool", "Network Connectivity Checker", "IPv6 Ping"],
        "description": "Free online ping tool to test IPv4 and IPv6 connectivity. Check host reachability, measure response times, and analyze network latency from our global servers.",
        "url": "https://8gwifi.org/pingfunctions.jsp",
        "image": "https://8gwifi.org/images/site/ping.png",
        "applicationCategory": "NetworkApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "softwareVersion": "2.0",
        "featureList": [
            "IPv4 ping testing",
            "IPv6 ping testing",
            "Response time measurement",
            "Packet loss detection",
            "TTL analysis",
            "Host reachability check",
            "Geolocation lookup"
        ],
        "screenshot": "https://8gwifi.org/images/site/ping.png",
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
        "datePublished": "2021-02-08",
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
                "name": "What is ping and how does it work?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Ping is a network utility that tests connectivity between two hosts by sending ICMP (Internet Control Message Protocol) echo request packets and measuring the time for echo reply packets to return. It measures round-trip time (RTT), packet loss, and helps diagnose network issues."
                }
            },
            {
                "@type": "Question",
                "name": "What is a good ping response time?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A good ping time depends on the use case. For general browsing, under 100ms is acceptable. For online gaming, under 50ms is preferred, and under 20ms is excellent. For video calls, under 150ms works well. Local network pings should be under 1ms."
                }
            },
            {
                "@type": "Question",
                "name": "What does TTL mean in ping results?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "TTL (Time To Live) is a counter that decrements by one at each network hop. It prevents packets from circulating indefinitely. The initial TTL value varies by operating system: Windows uses 128, Linux uses 64, and some systems use 255. The received TTL helps estimate how many hops the packet traversed."
                }
            },
            {
                "@type": "Question",
                "name": "Why would ping fail or timeout?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Ping can fail due to: 1) Host is offline or unreachable, 2) Firewall blocking ICMP packets, 3) Network congestion or routing issues, 4) Incorrect IP address or hostname, 5) ISP or server blocking ping requests for security. Many cloud providers and websites disable ICMP responses."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between ping and traceroute?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Ping tests if a host is reachable and measures round-trip time to that specific host. Traceroute shows the complete path packets take to reach the destination, listing every router (hop) along the way with timing for each hop. Traceroute helps identify where network problems occur."
                }
            },
            {
                "@type": "Question",
                "name": "Can I ping IPv6 addresses?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, IPv6 addresses can be pinged using ICMPv6 (ping6 command on some systems). IPv6 ping works similarly to IPv4 but uses 128-bit addresses. Examples: ping 2001:4860:4860::8888 (Google DNS) or ping ipv6.google.com. Note that not all hosts have IPv6 connectivity."
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
        "name": "How to Test Network Connectivity with Ping",
        "description": "Step-by-step guide to test host reachability using ping",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter Host Address",
                "text": "Enter an IPv4 address (e.g., 8.8.8.8), IPv6 address (e.g., 2001:4860:4860::8888), or hostname (e.g., google.com)"
            },
            {
                "@type": "HowToStep",
                "name": "Click Ping",
                "text": "Click the Ping button to send ICMP echo requests to the target host"
            },
            {
                "@type": "HowToStep",
                "name": "Analyze Results",
                "text": "Review the response times, packet loss, TTL values, and geolocation information"
            }
        ]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #e11d48;
            --theme-secondary: #f43f5e;
            --theme-gradient: linear-gradient(135deg, #e11d48 0%, #f43f5e 100%);
            --theme-light: #fff1f2;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(225, 29, 72, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(225, 29, 72, 0.25);
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
            min-height: 400px;
        }
        .result-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            min-height: 350px;
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
            box-shadow: 0 2px 8px rgba(225, 29, 72, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 { color: var(--theme-primary); margin-bottom: 0.25rem; font-size: 0.9rem; }
        .related-tool-card p { font-size: 0.75rem; color: #6c757d; margin: 0; }
        .terminal-block { background: #1e1e1e; border-radius: 8px; overflow: hidden; }
        .terminal-header { background: #323232; color: #d4d4d4; padding: 0.5rem 1rem; font-size: 0.75rem; display: flex; justify-content: space-between; align-items: center; }
        .terminal-body { padding: 1rem; color: #4ec9b0; font-family: monospace; font-size: 0.8rem; }
        .terminal-body code { color: #ce9178; }
        .ping-output {
            background: #1e1e1e;
            color: #4ec9b0;
            font-family: monospace;
            font-size: 0.85rem;
            padding: 1rem;
            border-radius: 8px;
            white-space: pre-wrap;
            max-height: 400px;
            overflow-y: auto;
        }
        .icmp-table {
            font-size: 0.8rem;
        }
        .icmp-table th {
            background: var(--theme-light);
            color: var(--theme-primary);
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="network-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">Online Ping Tool</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-satellite-dish"></i> ICMP</span>
            <span class="info-badge"><i class="fas fa-network-wired"></i> IPv4/IPv6</span>
            <span class="info-badge"><i class="fas fa-clock"></i> Latency</span>
</div>
</div>
    <div class="eeat-badge">
        <i class="fas fa-user-check"></i>
        <span>Anish Nath</span>
</div>
</div>

<!-- Visible FAQs -->
<h2 class="mt-4" id="faqs">FAQs</h2>
<div class="accordion" id="pingFaqs">
  <div class="card"><div class="card-header"><h6 class="mb-0">Why does ping timeout?</h6></div><div class="card-body small text-muted">Host down, ICMP blocked by firewall, routing issues, or target disables ping replies.</div></div>
  <div class="card"><div class="card-header"><h6 class="mb-0">What is a good ping time?</h6></div><div class="card-body small text-muted">Browsing <100ms; gaming <50ms (excellent <20ms); local network often <1ms.</div></div>
  <div class="card"><div class="card-header"><h6 class="mb-0">What does TTL indicate?</h6></div><div class="card-body small text-muted">TTL decrements each hop; received value helps estimate hop count and OS defaults.</div></div>
</div>

<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-satellite-dish me-2"></i>Ping Test</h5>
            </div>
            <div class="card-body">
                <form id="pingForm">
                    <input type="hidden" name="methodName" value="NETWORKPINGCOMMAND">
                    <input type="hidden" name="getClientIpAddr" value="true">

                    <!-- Host Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-server me-1"></i>Host / IP Address</div>
                        <input type="text" class="form-control" id="ipaddress" name="ipaddress" value="google.com" placeholder="e.g., google.com, 8.8.8.8, 2001:4860:4860::8888">
                        <small class="text-muted">Enter hostname, IPv4, or IPv6 address</small>
                    </div>

                    <!-- Quick Presets -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-bookmark me-1"></i>Quick Presets</div>
                        <div class="d-flex gap-2 flex-wrap mb-2">
                            <button type="button" class="preset-btn" onclick="applyPreset('google.com')">google.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('8.8.8.8')">Google DNS</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('1.1.1.1')">Cloudflare</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('github.com')">github.com</button>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="preset-btn" onclick="applyPreset('ipv6.google.com')">IPv6 Google</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('2001:4860:4860::8888')">IPv6 DNS</button>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100" id="pingBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-satellite-dish me-2"></i>Ping
                    </button>
                </form>
            </div>
        </div>

        <!-- Ping Info -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Response Time Guide</h6>
            </div>
            <div class="card-body small">
                <div class="d-flex justify-content-between mb-2">
                    <span><i class="fas fa-circle text-success"></i> Excellent</span>
                    <span class="text-muted">&lt; 20ms</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span><i class="fas fa-circle text-info"></i> Good</span>
                    <span class="text-muted">20-50ms</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span><i class="fas fa-circle text-warning"></i> Average</span>
                    <span class="text-muted">50-100ms</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span><i class="fas fa-circle text-danger"></i> Poor</span>
                    <span class="text-muted">&gt; 100ms</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-terminal me-2"></i>Ping Results</h5>
                <div id="resultActions" style="display: none;">
                    <button class="btn btn-sm btn-light me-1" onclick="shareResults()"><i class="fas fa-share-alt"></i></button>
                    <button class="btn btn-sm btn-light" onclick="copyResults()"><i class="fas fa-copy"></i></button>
                </div>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-satellite-dish fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Ping results will appear here</p>
                        <small class="text-muted">Enter a host and click Ping</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent">
                    <div class="ping-output" id="pingOutput"></div>
                </div>
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
                        <span>Linux/Mac: Ping with count</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('ping -c 4 google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ ping <code>-c 4 google.com</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Windows: Ping with count</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('ping -n 4 google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">C:\> ping <code>-n 4 google.com</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>IPv6 Ping</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('ping6 ipv6.google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ ping6 <code>ipv6.google.com</code></div>
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
            <a href="mtr.jsp" class="related-tool-card">
                <h6><i class="fas fa-route me-1"></i>MTR Traceroute</h6>
                <p>Network path analysis</p>
            </a>
            <a href="curlfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-globe me-1"></i>Curl Tool</h6>
                <p>HTTP/HTTPS connectivity test</p>
            </a>
            <a href="portscan.jsp" class="related-tool-card">
                <h6><i class="fas fa-shield-alt me-1"></i>Port Scanner</h6>
                <p>Scan open ports on host</p>
            </a>
            <a href="dns.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>DNS Lookup</h6>
                <p>Query DNS records</p>
            </a>
            <a href="SubnetFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-calculator me-1"></i>Subnet Calculator</h6>
                <p>Calculate IP subnets</p>
            </a>
            <a href="whois.jsp" class="related-tool-card">
                <h6><i class="fas fa-user me-1"></i>Whois Lookup</h6>
                <p>Domain registration info</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Ping & ICMP</h5>
    </div>
    <div class="card-body">
        <h6>What is Ping?</h6>
        <p>Ping is a network diagnostic tool that tests connectivity between your computer and a remote host. It sends ICMP (Internet Control Message Protocol) echo request packets and measures the time for echo replies to return. This round-trip time (RTT) helps diagnose network latency and connectivity issues.</p>

        <h6 class="mt-4">Common ICMP Message Types</h6>
        <div class="table-responsive">
            <table class="table table-bordered table-sm icmp-table">
                <thead>
                <tr><th>Type</th><th>Name</th><th>Description</th></tr>
                </thead>
                <tbody class="small">
                <tr><td>0</td><td>Echo Reply</td><td>Response to ping request</td></tr>
                <tr><td>3</td><td>Destination Unreachable</td><td>Host/network/port unreachable</td></tr>
                <tr><td>8</td><td>Echo Request</td><td>Ping request packet</td></tr>
                <tr><td>11</td><td>Time Exceeded</td><td>TTL expired (used by traceroute)</td></tr>
                </tbody>
            </table>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="alert alert-info">
                    <h6><i class="fas fa-clock me-1"></i>TTL (Time To Live)</h6>
                    <p class="small mb-0">TTL starts at 64 (Linux), 128 (Windows), or 255 and decrements at each hop. When it reaches 0, the packet is discarded. The received TTL helps estimate network hops.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning">
                    <h6><i class="fas fa-ban me-1"></i>ICMP Blocked?</h6>
                    <p class="small mb-0">Many firewalls and cloud providers block ICMP. A failed ping doesn't always mean the host is down - the server might just be blocking ping requests.</p>
                </div>
            </div>
        </div>

        <h6 class="mt-4">IPv6 Address Examples</h6>
        <ul class="small">
            <li><code>::1</code> - IPv6 loopback (localhost)</li>
            <li><code>2001:4860:4860::8888</code> - Google Public DNS IPv6</li>
            <li><code>::ffff:192.168.0.1</code> - IPv4-mapped IPv6 address</li>
        </ul>
    </div>
</div>

<%@ include file="addcomments.jsp"%>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share Ping Test</h5>
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
    var lastHost = null;
    var lastResult = null;

    $(document).ready(function() {
        loadFromUrl();

        $('#pingForm').submit(function(e) {
            e.preventDefault();
            performPing();
        });

        $('#copyShareUrl').click(function() {
            navigator.clipboard.writeText($('#shareUrlText').val()).then(function() {
                $('#copyShareUrl').html('<i class="fas fa-check"></i> Copied!');
                setTimeout(function() { $('#copyShareUrl').html('<i class="fas fa-copy"></i> Copy'); }, 1500);
            });
        });
    });

    function applyPreset(host) {
        $('#ipaddress').val(host);
        showToast('Applied: ' + host);
    }

    function performPing() {
        var host = $('#ipaddress').val().trim();
        if (!host) { showToast('Please enter a host or IP address'); return; }

        lastHost = host;
        $('#pingBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Pinging...');

        $.ajax({
            type: 'POST',
            url: 'NetworkFunctionality',
            data: $('#pingForm').serialize(),
            dataType: 'json',
            success: function(response) {
                $('#pingBtn').prop('disabled', false).html('<i class="fas fa-satellite-dish me-2"></i>Ping');
                lastResult = response;
                renderPingResult(response);
                $('#resultPlaceholder').hide();
                $('#resultContent').show();
                $('#resultActions').show();
            },
            error: function(xhr, status, error) {
                $('#pingBtn').prop('disabled', false).html('<i class="fas fa-satellite-dish me-2"></i>Ping');
                showError('Ping failed: ' + error);
            }
        });
    }

    function renderPingResult(data) {
        var html = '';

        if (!data.success) {
            html = '<div class="text-danger"><i class="fas fa-exclamation-triangle me-2"></i>' + escapeHtml(data.error || 'Unknown error') + '</div>';
            $('#pingOutput').html(html);
            return;
        }

        // Header info
        html += '<div class="mb-3">';
        html += '<div class="d-flex flex-wrap gap-2 mb-2">';
        html += '<span class="badge bg-success"><i class="fas fa-check me-1"></i>' + (data.reachable ? 'Reachable' : 'Unreachable') + '</span>';
        html += '<span class="badge bg-info">' + escapeHtml(data.ipVersion) + '</span>';
        html += '</div>';
        html += '<div class="small" style="color: #9cdcfe;">';
        html += '<strong>Host:</strong> ' + escapeHtml(data.host) + '<br>';
        html += '<strong>Resolved IP:</strong> ' + escapeHtml(data.resolvedIp) + '<br>';
        html += '<strong>Command:</strong> <code style="color: #ce9178;">' + escapeHtml(data.command) + '</code>';
        html += '</div></div>';

        // ICMP Output
        html += '<div class="mb-3">';
        html += '<div style="color: #dcdcaa; font-weight: 600; margin-bottom: 0.5rem;"><i class="fas fa-terminal me-1"></i>ICMP Echo Reply</div>';
        html += '<pre style="color: #4ec9b0; margin: 0; white-space: pre-wrap; font-size: 0.8rem;">' + escapeHtml(data.output) + '</pre>';
        html += '</div>';

        // Location info
        if (data.location) {
            html += '<div class="mt-3 pt-3" style="border-top: 1px solid #3c3c3c;">';
            html += '<div style="color: #dcdcaa; font-weight: 600; margin-bottom: 0.5rem;"><i class="fas fa-map-marker-alt me-1"></i>IP Geolocation</div>';
            html += '<div class="row small">';
            if (data.location.country) html += '<div class="col-6 mb-1"><span style="color: #808080;">Country:</span> <span style="color: #9cdcfe;">' + escapeHtml(data.location.country) + '</span></div>';
            if (data.location.city) html += '<div class="col-6 mb-1"><span style="color: #808080;">City:</span> <span style="color: #9cdcfe;">' + escapeHtml(data.location.city) + '</span></div>';
            if (data.location.region) html += '<div class="col-6 mb-1"><span style="color: #808080;">Region:</span> <span style="color: #9cdcfe;">' + escapeHtml(data.location.region) + '</span></div>';
            if (data.location.org) html += '<div class="col-6 mb-1"><span style="color: #808080;">Org:</span> <span style="color: #9cdcfe;">' + escapeHtml(data.location.org) + '</span></div>';
            if (data.location.loc) html += '<div class="col-12"><span style="color: #808080;">Coordinates:</span> <span style="color: #9cdcfe;">' + escapeHtml(data.location.loc) + '</span></div>';
            html += '</div></div>';
        }

        $('#pingOutput').html(html);
    }

    function escapeHtml(text) {
        if (!text) return '';
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function showError(message) {
        $('#pingOutput').html('<span class="text-danger">' + message + '</span>');
        $('#resultPlaceholder').hide();
        $('#resultContent').show();
    }

    function shareResults() {
        if (!lastHost) return;
        var url = window.location.origin + window.location.pathname + '?host=' + encodeURIComponent(lastHost);
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    function copyResults() {
        if (lastResult && lastResult.success) {
            var text = 'Ping Results for ' + lastResult.host + '\n';
            text += '====================\n';
            text += 'Resolved IP: ' + lastResult.resolvedIp + '\n';
            text += 'IP Version: ' + lastResult.ipVersion + '\n';
            text += 'Reachable: ' + (lastResult.reachable ? 'Yes' : 'No') + '\n';
            text += 'Command: ' + lastResult.command + '\n\n';
            text += 'Output:\n' + lastResult.output + '\n';
            if (lastResult.location) {
                text += '\nGeolocation:\n';
                if (lastResult.location.country) text += 'Country: ' + lastResult.location.country + '\n';
                if (lastResult.location.city) text += 'City: ' + lastResult.location.city + '\n';
                if (lastResult.location.region) text += 'Region: ' + lastResult.location.region + '\n';
                if (lastResult.location.org) text += 'Organization: ' + lastResult.location.org + '\n';
            }
            navigator.clipboard.writeText(text).then(function() { showToast('Results copied!'); });
        } else {
            var text = $('#pingOutput').text();
            navigator.clipboard.writeText(text).then(function() { showToast('Results copied!'); });
        }
    }

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var host = params.get('host');
        if (host) {
            $('#ipaddress').val(host);
            setTimeout(function() { performPing(); }, 500);
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
