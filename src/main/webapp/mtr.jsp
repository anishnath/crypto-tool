<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>MTR Traceroute Tool - Network Path Analysis & Diagnostics | 8gwifi.org</title>
    <meta name="description" content="Free online MTR traceroute tool for network path analysis. Diagnose network issues, measure latency, detect packet loss, and analyze routing between hosts." />
    <meta name="keywords" content="mtr traceroute, network path analysis, packet loss, latency test, network diagnostics, traceroute tool, hop analysis, network troubleshooting" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/mtr.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="MTR Traceroute Tool - Network Path Analysis" />
    <meta property="og:description" content="Analyze network paths with MTR. Measure latency, packet loss, and diagnose routing issues between any two points." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/mtr.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/site/mtr.png" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "MTR Traceroute Tool",
        "alternateName": ["Network Path Analyzer", "Traceroute Tool", "Packet Loss Analyzer", "Latency Tester"],
        "description": "Advanced MTR (My TraceRoute) tool combining traceroute and ping for comprehensive network path analysis. Measure packet loss, latency, and jitter across network hops.",
        "url": "https://8gwifi.org/mtr.jsp",
        "image": "https://8gwifi.org/images/site/mtr.png",
        "applicationCategory": "NetworkApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "softwareVersion": "2.0",
        "featureList": [
            "Network path tracing",
            "Packet loss measurement",
            "Latency statistics (min/max/avg)",
            "Jitter calculation",
            "Hop-by-hop analysis",
            "Configurable parameters"
        ],
        "screenshot": "https://8gwifi.org/images/site/mtr.png",
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
            "audienceType": "Network Administrators, Network Engineers, System Administrators, DevOps Engineers, IT Professionals"
        }
    }
    </script>

    <!-- JSON-LD FAQPage Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "What is MTR and how is it different from traceroute?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "MTR (My TraceRoute) combines the functionality of traceroute and ping into a single tool. While traceroute shows the path packets take once, MTR continuously sends packets and provides real-time statistics on packet loss, latency, and jitter for each hop, making it more useful for diagnosing intermittent network issues."
                }
            },
            {
                "@type": "Question",
                "name": "What does packet loss percentage mean in MTR results?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Packet loss percentage indicates how many packets sent to a hop did not receive a response. 0% means all packets were received. High packet loss (>5%) at intermediate hops may not indicate a problem if the final destination has low loss. Many routers deprioritize ICMP responses, causing apparent loss."
                }
            },
            {
                "@type": "Question",
                "name": "How do I interpret latency values in MTR?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Latency (in milliseconds) measures round-trip time to each hop. Key metrics: Last (most recent), Avg (average), Best (minimum), Worst (maximum). Look for sudden increases between hops to identify bottlenecks. Consistent latency increases are normal as distance grows."
                }
            },
            {
                "@type": "Question",
                "name": "What is jitter and why does it matter?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Jitter measures the variation in latency over time (standard deviation). Low jitter (<5ms) indicates stable network performance. High jitter causes problems for real-time applications like VoIP and video conferencing. Consistent high jitter may indicate network congestion or routing issues."
                }
            },
            {
                "@type": "Question",
                "name": "Why do some hops show asterisks or no response?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Asterisks (*) or 'no response' typically means: 1) The router is configured to not respond to ICMP/UDP probes, 2) A firewall is blocking responses, 3) The router deprioritizes diagnostic traffic. This is often normal and doesn't indicate a problem if subsequent hops respond."
                }
            },
            {
                "@type": "Question",
                "name": "How many packets should I send for accurate MTR results?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "For quick diagnostics, 10-20 packets are sufficient. For analyzing intermittent issues, use 50-100 packets over a longer period. More packets provide more accurate statistics but take longer. The default of 5-10 packets is good for initial troubleshooting."
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
        "name": "How to Perform Network Path Analysis with MTR",
        "description": "Step-by-step guide to diagnose network issues using MTR traceroute",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter Target Host",
                "text": "Enter the hostname or IP address you want to trace (e.g., google.com, 8.8.8.8)"
            },
            {
                "@type": "HowToStep",
                "name": "Configure Parameters",
                "text": "Optionally adjust packets per hop, interval, timeout, and maximum hops for your needs"
            },
            {
                "@type": "HowToStep",
                "name": "Start MTR Trace",
                "text": "Click Start MTR Trace to begin the network path analysis"
            },
            {
                "@type": "HowToStep",
                "name": "Analyze Results",
                "text": "Review hop details, packet loss percentages, and latency statistics to identify network issues"
            }
        ]
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
            box-shadow: 0 2px 8px rgba(5, 150, 105, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 { color: var(--theme-primary); margin-bottom: 0.25rem; font-size: 0.9rem; }
        .related-tool-card p { font-size: 0.75rem; color: #6c757d; margin: 0; }
        .terminal-block { background: #1e1e1e; border-radius: 8px; overflow: hidden; }
        .terminal-header { background: #323232; color: #d4d4d4; padding: 0.5rem 1rem; font-size: 0.75rem; display: flex; justify-content: space-between; align-items: center; }
        .terminal-body { padding: 1rem; color: #4ec9b0; font-family: monospace; font-size: 0.8rem; }
        .terminal-body code { color: #ce9178; }
        .stat-card {
            background: var(--theme-light);
            border-radius: 8px;
            padding: 0.75rem;
            text-align: center;
        }
        .stat-card .stat-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--theme-primary);
        }
        .stat-card .stat-label {
            font-size: 0.7rem;
            color: #6c757d;
            text-transform: uppercase;
        }
        .hop-table {
            font-size: 0.8rem;
        }
        .hop-table th {
            background: var(--theme-light);
            color: var(--theme-primary);
            font-size: 0.75rem;
            white-space: nowrap;
        }
        .hop-table td {
            vertical-align: middle;
        }
        .loss-badge {
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-weight: 600;
            font-size: 0.75rem;
        }
        .loss-good { background: #d1fae5; color: #059669; }
        .loss-warning { background: #fef3c7; color: #d97706; }
        .loss-bad { background: #fee2e2; color: #dc2626; }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="network-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">MTR Traceroute Tool</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-route"></i> Path Analysis</span>
            <span class="info-badge"><i class="fas fa-clock"></i> Latency</span>
            <span class="info-badge"><i class="fas fa-chart-line"></i> Packet Loss</span>
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
                <h5><i class="fas fa-route me-2"></i>MTR Configuration</h5>
            </div>
            <div class="card-body">
                <form id="mtrForm">
                    <!-- Target Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-server me-1"></i>Target Host</div>
                        <input type="text" class="form-control" id="target" name="target" value="google.com" placeholder="e.g., google.com, 8.8.8.8">
                        <small class="text-muted">Enter hostname or public IP address</small>
                    </div>

                    <!-- Quick Presets -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-bookmark me-1"></i>Quick Presets</div>
                        <div class="d-flex gap-2 flex-wrap mb-2">
                            <button type="button" class="preset-btn" onclick="applyPreset('google.com')">google.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('8.8.8.8')">Google DNS</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('1.1.1.1')">Cloudflare</button>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="preset-btn" onclick="applyPreset('github.com')">github.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('amazon.com')">amazon.com</button>
                        </div>
                    </div>

                    <!-- Advanced Options -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-sliders-h me-1"></i>Advanced Options</div>
                        <div class="row g-2">
                            <div class="col-6">
                                <label class="small text-muted">Packets/Hop</label>
                                <input type="number" class="form-control form-control-sm" id="packets" name="packets" value="5" min="1" max="100">
                            </div>
                            <div class="col-6">
                                <label class="small text-muted">Max Hops</label>
                                <input type="number" class="form-control form-control-sm" id="maxHops" name="maxHops" value="30" min="1" max="64">
                            </div>
                            <div class="col-6">
                                <label class="small text-muted">Interval (sec)</label>
                                <input type="number" class="form-control form-control-sm" id="interval" name="interval" value="1.0" min="0.1" max="10.0" step="0.1">
                            </div>
                            <div class="col-6">
                                <label class="small text-muted">Timeout (sec)</label>
                                <input type="number" class="form-control form-control-sm" id="timeout" name="timeout" value="2.0" min="0.5" max="10.0" step="0.1">
                            </div>
                        </div>
                        <input type="hidden" id="mode" name="mode" value="report">
                    </div>

                    <button type="submit" class="btn w-100" id="mtrBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-play me-2"></i>Start MTR Trace
                    </button>
                </form>
            </div>
        </div>

        <!-- Metrics Guide -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Metrics Guide</h6>
            </div>
            <div class="card-body small p-2">
                <div class="d-flex justify-content-between mb-1">
                    <span><i class="fas fa-percentage text-success"></i> Loss %</span>
                    <span class="text-muted">Packet loss rate</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><i class="fas fa-stopwatch text-info"></i> Last</span>
                    <span class="text-muted">Most recent RTT</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><i class="fas fa-chart-bar text-primary"></i> Avg</span>
                    <span class="text-muted">Average latency</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><i class="fas fa-arrow-down text-success"></i> Best</span>
                    <span class="text-muted">Minimum latency</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><i class="fas fa-arrow-up text-danger"></i> Worst</span>
                    <span class="text-muted">Maximum latency</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span><i class="fas fa-wave-square text-warning"></i> StDev</span>
                    <span class="text-muted">Jitter/variation</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-chart-line me-2"></i>MTR Results</h5>
                <div id="resultActions" style="display: none;">
                    <button class="btn btn-sm btn-light me-1" onclick="shareResults()"><i class="fas fa-share-alt"></i></button>
                    <button class="btn btn-sm btn-light" onclick="copyResults()"><i class="fas fa-copy"></i></button>
                </div>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-route fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">MTR results will appear here</p>
                        <small class="text-muted">Enter a target and click Start MTR Trace</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent">
                    <!-- Summary Stats -->
                    <div class="row g-2 mb-3" id="summaryStats">
                        <div class="col-3">
                            <div class="stat-card">
                                <div class="stat-value" id="totalHops">-</div>
                                <div class="stat-label">Hops</div>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="stat-card">
                                <div class="stat-value" id="avgLatency">-</div>
                                <div class="stat-label">Avg ms</div>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="stat-card">
                                <div class="stat-value" id="overallLoss">-</div>
                                <div class="stat-label">Loss %</div>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="stat-card">
                                <div class="stat-value" id="jitter">-</div>
                                <div class="stat-label">Jitter</div>
                            </div>
                        </div>
                    </div>

                    <!-- Trace Info -->
                    <div class="small text-muted mb-2" id="traceInfo"></div>

                    <!-- Hops Table -->
                    <div class="table-responsive">
                        <table class="table table-sm table-bordered hop-table mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>IP Address</th>
                                    <th>Loss</th>
                                    <th>Last</th>
                                    <th>Avg</th>
                                    <th>Best</th>
                                    <th>Worst</th>
                                    <th>StDev</th>
                                </tr>
                            </thead>
                            <tbody id="hopsTableBody"></tbody>
                        </table>
                    </div>
                </div>

                <div id="errorMsg" class="alert alert-danger" style="display: none;"></div>
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
                        <span>Basic MTR (Linux)</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('mtr -r -c 10 google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ mtr <code>-r -c 10 google.com</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>MTR with TCP mode</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('mtr -r -T -P 443 google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ mtr <code>-r -T -P 443 google.com</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Windows tracert</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('tracert google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">C:\> tracert <code>google.com</code></div>
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
            <a href="pingfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-satellite-dish me-1"></i>Ping Tool</h6>
                <p>Test ICMP connectivity</p>
            </a>
            <a href="curlfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-globe me-1"></i>Curl Tool</h6>
                <p>HTTP/HTTPS connectivity</p>
            </a>
            <a href="portscan.jsp" class="related-tool-card">
                <h6><i class="fas fa-shield-alt me-1"></i>Port Scanner</h6>
                <p>Scan open ports</p>
            </a>
            <a href="dns.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>DNS Lookup</h6>
                <p>Query DNS records</p>
            </a>
            <a href="whois.jsp" class="related-tool-card">
                <h6><i class="fas fa-user me-1"></i>WHOIS Lookup</h6>
                <p>Domain registration info</p>
            </a>
            <a href="SubnetFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-calculator me-1"></i>Subnet Calculator</h6>
                <p>Calculate IP subnets</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding MTR & Network Diagnostics</h5>
    </div>
    <div class="card-body">
        <h6>What is MTR?</h6>
        <p>MTR (My TraceRoute) is a powerful network diagnostic tool that combines the functionality of traceroute and ping. It continuously probes each hop along the network path, providing real-time statistics on packet loss, latency, and jitter - making it invaluable for diagnosing intermittent network issues.</p>

        <h6 class="mt-4">How MTR Works</h6>
        <div class="table-responsive">
            <table class="table table-bordered table-sm">
                <thead class="table-light">
                <tr><th>Step</th><th>Process</th><th>Result</th></tr>
                </thead>
                <tbody class="small">
                <tr><td>1</td><td>Send packets with TTL=1</td><td>First router responds</td></tr>
                <tr><td>2</td><td>Increment TTL for each hop</td><td>Discover next router</td></tr>
                <tr><td>3</td><td>Send multiple packets per hop</td><td>Calculate statistics</td></tr>
                <tr><td>4</td><td>Continue until destination</td><td>Complete path map</td></tr>
                </tbody>
            </table>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="alert alert-success">
                    <h6><i class="fas fa-check-circle me-1"></i>Good Results</h6>
                    <ul class="small mb-0">
                        <li>0% packet loss throughout</li>
                        <li>Consistent latency increases</li>
                        <li>Low jitter (&lt;5ms)</li>
                        <li>All hops responding</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-danger">
                    <h6><i class="fas fa-exclamation-circle me-1"></i>Problem Indicators</h6>
                    <ul class="small mb-0">
                        <li>&gt;5% loss at final destination</li>
                        <li>Sudden latency spikes</li>
                        <li>High jitter (&gt;20ms)</li>
                        <li>Loss increases toward destination</li>
                    </ul>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Interpreting Results</h6>
        <div class="alert alert-info">
            <p class="small mb-0"><strong>Note:</strong> Packet loss at intermediate hops doesn't always indicate a problem. Many routers rate-limit ICMP responses. Focus on the final destination's statistics and look for patterns where loss begins and continues to the destination.</p>
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
                <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share MTR Trace</h5>
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
    var lastTarget = null;
    var lastResult = null;

    $(document).ready(function() {
        loadFromUrl();

        $('#mtrForm').submit(function(e) {
            e.preventDefault();
            performMtr();
        });

        $('#copyShareUrl').click(function() {
            navigator.clipboard.writeText($('#shareUrlText').val()).then(function() {
                $('#copyShareUrl').html('<i class="fas fa-check"></i> Copied!');
                setTimeout(function() { $('#copyShareUrl').html('<i class="fas fa-copy"></i> Copy'); }, 1500);
            });
        });
    });

    function applyPreset(target) {
        $('#target').val(target);
        showToast('Applied: ' + target);
    }

    function performMtr() {
        var target = $('#target').val().trim();
        if (!target) { showToast('Please enter a target host'); return; }

        lastTarget = target;
        $('#mtrBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Tracing...');
        $('#errorMsg').hide();

        var url = 'MTRFunctionality/' + encodeURIComponent(target);
        var params = [];
        params.push('target=' + encodeURIComponent(target));
        params.push('mode=' + $('#mode').val());
        params.push('packets=' + $('#packets').val());
        params.push('interval=' + $('#interval').val());
        params.push('timeout=' + $('#timeout').val());
        params.push('maxHops=' + $('#maxHops').val());
        url += '?' + params.join('&');

        $.ajax({
            type: 'GET',
            url: url,
            dataType: 'json',
            success: function(data) {
                $('#mtrBtn').prop('disabled', false).html('<i class="fas fa-play me-2"></i>Start MTR Trace');
                lastResult = data;
                displayResults(data);
                $('#resultPlaceholder').hide();
                $('#resultContent').show();
                $('#resultActions').show();
            },
            error: function(xhr, status, error) {
                $('#mtrBtn').prop('disabled', false).html('<i class="fas fa-play me-2"></i>Start MTR Trace');
                var errorMsg = 'An error occurred while performing MTR trace.';
                if (xhr.responseJSON && xhr.responseJSON.error) {
                    errorMsg = xhr.responseJSON.error;
                } else if (xhr.status === 400) {
                    errorMsg = 'Invalid target format. Please check your input.';
                } else if (xhr.status === 403) {
                    errorMsg = 'Target not allowed. Private networks and localhost cannot be traced.';
                }
                $('#errorMsg').text(errorMsg).show();
                $('#resultPlaceholder').hide();
                $('#resultContent').hide();
            }
        });
    }

    function displayResults(data) {
        // Summary stats
        $('#totalHops').text(data.total_hops || '-');
        $('#avgLatency').text(data.summary ? data.summary.avg_latency_ms.toFixed(1) : '-');
        $('#overallLoss').text(data.summary ? data.summary.overall_loss_percent.toFixed(1) : '-');
        $('#jitter').text(data.summary ? data.summary.jitter_ms.toFixed(1) : '-');

        // Trace info
        var info = '<strong>Target:</strong> ' + (data.target || '-');
        info += ' | <strong>Duration:</strong> ' + (data.duration_seconds ? data.duration_seconds.toFixed(2) + 's' : '-');
        $('#traceInfo').html(info);

        // Hops table
        var hopsHtml = '';
        if (data.hops && data.hops.length > 0) {
            for (var i = 0; i < data.hops.length; i++) {
                var hop = data.hops[i];
                var lossClass = hop.loss_percent === 0 ? 'loss-good' :
                              hop.loss_percent <= 10 ? 'loss-warning' : 'loss-bad';

                hopsHtml += '<tr>';
                hopsHtml += '<td>' + hop.hop_number + '</td>';
                hopsHtml += '<td><code>' + (hop.ip || '* * *') + '</code></td>';
                hopsHtml += '<td><span class="loss-badge ' + lossClass + '">' + hop.loss_percent.toFixed(1) + '%</span></td>';
                hopsHtml += '<td>' + (hop.last_latency_ms > 0 ? hop.last_latency_ms.toFixed(1) : '-') + '</td>';
                hopsHtml += '<td>' + (hop.avg_latency_ms > 0 ? hop.avg_latency_ms.toFixed(1) : '-') + '</td>';
                hopsHtml += '<td>' + (hop.best_latency_ms > 0 ? hop.best_latency_ms.toFixed(1) : '-') + '</td>';
                hopsHtml += '<td>' + (hop.worst_latency_ms > 0 ? hop.worst_latency_ms.toFixed(1) : '-') + '</td>';
                hopsHtml += '<td>' + (hop.std_dev_ms > 0 ? hop.std_dev_ms.toFixed(1) : '-') + '</td>';
                hopsHtml += '</tr>';
            }
        } else {
            hopsHtml = '<tr><td colspan="8" class="text-center text-muted">No hop data available</td></tr>';
        }
        $('#hopsTableBody').html(hopsHtml);
    }

    function shareResults() {
        if (!lastTarget) return;
        var url = window.location.origin + window.location.pathname + '?target=' + encodeURIComponent(lastTarget);
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    function copyResults() {
        if (!lastResult) return;
        var text = 'MTR Trace to ' + lastResult.target + '\n';
        text += '========================\n';
        text += 'Total Hops: ' + lastResult.total_hops + '\n';
        if (lastResult.summary) {
            text += 'Avg Latency: ' + lastResult.summary.avg_latency_ms.toFixed(2) + ' ms\n';
            text += 'Overall Loss: ' + lastResult.summary.overall_loss_percent.toFixed(2) + '%\n';
            text += 'Jitter: ' + lastResult.summary.jitter_ms.toFixed(2) + ' ms\n\n';
        }
        text += 'Hop\tIP Address\tLoss%\tAvg(ms)\n';
        if (lastResult.hops) {
            lastResult.hops.forEach(function(hop) {
                text += hop.hop_number + '\t' + (hop.ip || '* * *') + '\t' + hop.loss_percent.toFixed(1) + '%\t' + hop.avg_latency_ms.toFixed(1) + '\n';
            });
        }
        navigator.clipboard.writeText(text).then(function() { showToast('Results copied!'); });
    }

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var target = params.get('target');
        if (target) {
            $('#target').val(target);
            setTimeout(function() { performMtr(); }, 500);
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
