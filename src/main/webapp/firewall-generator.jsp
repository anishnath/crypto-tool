<!DOCTYPE html>
<html>

<head>
    <title>Firewall Rules Generator – UFW & iptables with Rate Limiting | 8gwifi.org</title>
    <meta name="description"
        content="Generate firewall rules for UFW and iptables with advanced features: rate limiting, DDoS protection, service presets, and IP filtering. Free Linux firewall configuration tool.">
    <meta name="keywords"
        content="ufw firewall, iptables generator, firewall rules, rate limiting, ddos protection, linux firewall, ufw config, iptables config">
    <%@ include file="header-script.jsp" %>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Firewall Rules Generator",
      "description": "Generate UFW and iptables firewall rules with rate limiting and DDoS protection.",
      "url": "https://8gwifi.org/firewall-generator.jsp",
      "applicationCategory": "DevOpsApplication",
      "operatingSystem": "Linux",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
      "author": {"@type": "Person", "name": "Anish Nath", "url": "https://8gwifi.org"},
      "datePublished": "2025-01-15",
      "dateModified": "2025-01-15"
    }
    </script>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "What is the difference between UFW and iptables?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "UFW (Uncomplicated Firewall) is a user-friendly frontend for iptables, designed to make firewall configuration easier. iptables is the underlying powerful firewall framework. UFW provides simple commands like 'ufw allow 22' while iptables requires more complex syntax. Both ultimately configure the same Linux netfilter framework."
          }
        },
        {
          "@type": "Question",
          "name": "How does rate limiting prevent DDoS attacks?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Rate limiting restricts the number of connections from a single IP address within a time window. UFW's limit rule allows 6 connections per 30 seconds by default. In iptables, you can use the limit module to drop excessive packets. While this won't stop bandwidth-based DDoS, it effectively mitigates connection-based attacks like SYN floods and brute-force attempts."
          }
        },
        {
          "@type": "Question",
          "name": "Should I block all traffic by default?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Yes, for security best practices, set default policies to DENY/DROP all incoming traffic, then explicitly allow only required services. This 'whitelist' approach ensures that only intended services are exposed. Outgoing traffic can usually remain allowed unless you need strict egress filtering."
          }
        },
        {
          "@type": "Question",
          "name": "What is CIDR notation in firewall rules?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "CIDR (Classless Inter-Domain Routing) notation specifies IP address ranges. For example, 192.168.1.0/24 represents all IPs from 192.168.1.0 to 192.168.1.255 (256 addresses). The /24 means the first 24 bits are the network portion. Common ranges: /32 = single IP, /24 = 256 IPs, /16 = 65,536 IPs."
          }
        }
      ]
    }
    </script>
        <style>
            :root {
                --theme-primary: #dc2626;
                --theme-secondary: #ea580c;
                --theme-gradient: linear-gradient(135deg, #dc2626 0%, #ea580c 100%);
                --theme-light: #fee2e2;
            }

            .tool-card {
                border: none;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                transition: transform 0.2s;
            }

            .card-header-custom {
                background: var(--theme-gradient);
                color: white;
                font-weight: 600;
            }

            .form-section {
                background-color: var(--theme-light);
                padding: 1rem;
                border-radius: 0.5rem;
                margin-bottom: 1rem;
            }

            .form-section-title {
                color: var(--theme-primary);
                font-weight: 700;
                margin-bottom: 1rem;
                display: flex;
                align-items: center;
            }

            .form-section-title i {
                margin-right: 0.5rem;
            }

            .code-preview {
                background: #1e293b;
                color: #e2e8f0;
                padding: 1rem;
                border-radius: 4px;
                font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
                font-size: 0.85rem;
                white-space: pre-wrap;
                min-height: 500px;
                max-height: 700px;
                overflow-y: auto;
                border: 1px solid #334155;
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
                background-color: var(--theme-light);
                color: var(--theme-primary);
                padding: 0.25rem 0.5rem;
                border-radius: 4px;
                font-size: 0.75rem;
                font-weight: 600;
                margin-right: 0.5rem;
            }

            .sticky-preview {
                position: sticky;
                top: 80px;
            }

            .rule-item {
                background: white;
                border: 1px solid #e5e7eb;
                border-radius: 0.375rem;
                padding: 0.75rem;
                margin-bottom: 0.5rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .rule-item:hover {
                border-color: var(--theme-primary);
            }

            .service-preset {
                display: inline-block;
                padding: 0.5rem 1rem;
                margin: 0.25rem;
                background: var(--theme-gradient);
                color: white;
                border-radius: 0.375rem;
                cursor: pointer;
                font-size: 0.875rem;
                transition: transform 0.2s;
            }

            .service-preset:hover {
                transform: translateY(-2px);
            }
        </style>
</head>

<%@ include file="body-script.jsp" %>
    <%@ include file="devops-tools-navbar.jsp" %>
        <%@ include file="footer_adsense.jsp" %>

            <div class="container-fluid px-lg-5 mt-4">

                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-0">Firewall Rules Generator</h1>
                        <div class="mt-2">
                            <span class="info-badge"><i class="fas fa-shield-alt"></i> UFW & iptables</span>
                            <span class="info-badge"><i class="fas fa-tachometer-alt"></i> Rate Limiting</span>
                            <span class="info-badge"><i class="fas fa-ban"></i> DDoS Protection</span>
                        </div>
                    </div>
                    <div class="eeat-badge">
                        <i class="fas fa-user-check"></i>
                        <span>Anish Nath</span>
                    </div>
                </div>

                <div class="row">
                    <!-- Left Column: Inputs -->
                    <div class="col-lg-5">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom">
                                <i class="fas fa-sliders-h mr-2"></i> Firewall Configuration
                            </div>
                            <div class="card-body">
                                <form id="firewallForm">

                                    <!-- Output Mode -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-code"></i> Output Format
                                        </div>
                                        <div class="custom-control custom-radio">
                                            <input type="radio" id="outputUFW" name="outputMode"
                                                class="custom-control-input" value="ufw" checked>
                                            <label class="custom-control-label" for="outputUFW">
                                                UFW (Uncomplicated Firewall)
                                            </label>
                                        </div>
                                        <div class="custom-control custom-radio">
                                            <input type="radio" id="outputIptables" name="outputMode"
                                                class="custom-control-input" value="iptables">
                                            <label class="custom-control-label" for="outputIptables">
                                                iptables (Advanced)
                                            </label>
                                        </div>
                                    </div>

                                    <!-- Default Policies -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-cog"></i> Default Policies
                                        </div>
                                        <div class="form-row">
                                            <div class="col">
                                                <label>Incoming</label>
                                                <select class="form-control" id="policyIncoming">
                                                    <option value="deny">DENY / DROP</option>
                                                    <option value="allow">ALLOW / ACCEPT</option>
                                                </select>
                                            </div>
                                            <div class="col">
                                                <label>Outgoing</label>
                                                <select class="form-control" id="policyOutgoing">
                                                    <option value="allow">ALLOW / ACCEPT</option>
                                                    <option value="deny">DENY / DROP</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Service Presets -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-server"></i> Quick Service Presets
                                        </div>
                                        <div class="text-center">
                                            <span class="service-preset" onclick="addServicePreset('ssh')">
                                                <i class="fas fa-terminal"></i> SSH (22)
                                            </span>
                                            <span class="service-preset" onclick="addServicePreset('http')">
                                                <i class="fas fa-globe"></i> HTTP (80)
                                            </span>
                                            <span class="service-preset" onclick="addServicePreset('https')">
                                                <i class="fas fa-lock"></i> HTTPS (443)
                                            </span>
                                            <span class="service-preset" onclick="addServicePreset('dns')">
                                                <i class="fas fa-network-wired"></i> DNS (53)
                                            </span>
                                            <span class="service-preset" onclick="addServicePreset('mysql')">
                                                <i class="fas fa-database"></i> MySQL (3306)
                                            </span>
                                            <span class="service-preset" onclick="addServicePreset('postgres')">
                                                <i class="fas fa-database"></i> PostgreSQL (5432)
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Custom Rules -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-plus-circle"></i> Custom Rule
                                        </div>
                                        <div class="form-group">
                                            <label>Action</label>
                                            <select class="form-control" id="ruleAction">
                                                <option value="allow">Allow</option>
                                                <option value="deny">Deny</option>
                                                <option value="limit">Limit (Rate Limiting)</option>
                                            </select>
                                        </div>
                                        <div class="form-row">
                                            <div class="col-md-6">
                                                <label>Port</label>
                                                <input type="text" class="form-control" id="rulePort"
                                                    placeholder="80 or 8000:9000">
                                            </div>
                                            <div class="col-md-6">
                                                <label>Protocol</label>
                                                <select class="form-control" id="ruleProtocol">
                                                    <option value="tcp">TCP</option>
                                                    <option value="udp">UDP</option>
                                                    <option value="any">Any</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mt-2">
                                            <label>Source IP/CIDR (Optional)</label>
                                            <input type="text" class="form-control" id="ruleSource"
                                                placeholder="192.168.1.100 or 10.0.0.0/24">
                                            <small class="text-muted">Leave empty for any source</small>
                                        </div>
                                        <div class="form-group">
                                            <label>Comment</label>
                                            <input type="text" class="form-control" id="ruleComment"
                                                placeholder="Description of this rule">
                                        </div>
                                        <button type="button" class="btn btn-sm" onclick="addCustomRule()"
                                            style="background: var(--theme-gradient); color: white;">
                                            <i class="fas fa-plus"></i> Add Rule
                                        </button>
                                    </div>

                                    <!-- Current Rules -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-list"></i> Current Rules
                                            <button type="button" class="btn btn-sm btn-outline-danger ml-auto"
                                                onclick="clearAllRules()">
                                                <i class="fas fa-trash"></i> Clear All
                                            </button>
                                        </div>
                                        <div id="rulesList"></div>
                                    </div>

                                    <!-- Advanced Options -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-cogs"></i> Advanced Options
                                        </div>
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="enableLogging">
                                            <label class="custom-control-label" for="enableLogging">
                                                Enable Logging
                                            </label>
                                        </div>
                                        <div class="custom-control custom-switch mb-2">
                                            <input type="checkbox" class="custom-control-input" id="showComments"
                                                checked>
                                            <label class="custom-control-label" for="showComments">
                                                Show Rule Comments
                                            </label>
                                        </div>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Preview -->
                    <div class="col-lg-7">
                        <div class="sticky-preview">
                            <div class="card tool-card">
                                <div
                                    class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                                    <span class="mb-0">
                                        <i class="fas fa-terminal mr-2"></i>
                                        <span id="outputTitle">UFW Commands</span>
                                    </span>
                                    <div>
                                        <button class="btn btn-sm btn-outline-light mr-2" onclick="shareUrl()">
                                            <i class="fas fa-share-alt"></i> Share
                                        </button>
                                        <button class="btn btn-sm btn-light text-dark" onclick="copyRules()">
                                            <i class="fas fa-copy"></i> Copy
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body p-0">
                                    <pre id="rulesOutput" class="code-preview mb-0"></pre>
                                </div>
                            </div>

                            <!-- Educational Content -->
                            <div class="card tool-card mt-4">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0"><i class="fas fa-graduation-cap mr-2"></i>Firewall Best Practices
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <h6>Rule Order Matters</h6>
                                    <p>Firewall rules are processed top-to-bottom. Place more specific rules before
                                        general ones. For example, rate-limit SSH before allowing it generally.</p>

                                    <h6 class="mt-4">Rate Limiting for Security</h6>
                                    <p><strong>UFW:</strong> <code>ufw limit ssh</code> allows 6 connections per 30
                                        seconds per IP.</p>
                                    <p><strong>iptables:</strong> Use <code>--limit 10/minute --limit-burst 20</code>
                                        for similar protection.</p>

                                    <h6 class="mt-4">Common Port Numbers</h6>
                                    <ul class="mb-0">
                                        <li><strong>22:</strong> SSH (Secure Shell)</li>
                                        <li><strong>80:</strong> HTTP (Web Traffic)</li>
                                        <li><strong>443:</strong> HTTPS (Secure Web)</li>
                                        <li><strong>53:</strong> DNS (Domain Name System)</li>
                                        <li><strong>3306:</strong> MySQL Database</li>
                                        <li><strong>5432:</strong> PostgreSQL Database</li>
                                        <li><strong>27017:</strong> MongoDB</li>
                                        <li><strong>6379:</strong> Redis</li>
                                    </ul>
                                </div>
                            </div>

                            <div class="mt-3 text-right">
                                <%@ include file="footer_adsense.jsp" %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Share URL Modal -->
            <div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                            <h5 class="modal-title">
                                <i class="fas fa-share-alt"></i> Share Configuration
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="input-group mb-3">
                                <input type="text" class="form-control" id="shareUrlText" readonly>
                                <div class="input-group-append">
                                    <button class="btn btn-success" id="copyShareUrl">
                                        <i class="fas fa-copy"></i> Copy
                                    </button>
                                </div>
                            </div>
                            <p class="text-muted small mb-0">
                                <i class="fas fa-info-circle"></i> Anyone with this link can view this configuration.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                let rules = [];

                const servicePresets = {
                    ssh: { port: '22', protocol: 'tcp', comment: 'SSH Access', limit: true },
                    http: { port: '80', protocol: 'tcp', comment: 'HTTP Web Server', limit: false },
                    https: { port: '443', protocol: 'tcp', comment: 'HTTPS Web Server', limit: false },
                    dns: { port: '53', protocol: 'any', comment: 'DNS Server', limit: false },
                    mysql: { port: '3306', protocol: 'tcp', comment: 'MySQL Database', limit: false },
                    postgres: { port: '5432', protocol: 'tcp', comment: 'PostgreSQL Database', limit: false }
                };

                function addServicePreset(service) {
                    const preset = servicePresets[service];
                    rules.push({
                        action: preset.limit ? 'limit' : 'allow',
                        port: preset.port,
                        protocol: preset.protocol,
                        source: '',
                        comment: preset.comment
                    });
                    updateRulesList();
                    generateOutput();
                }

                function addCustomRule() {
                    const action = document.getElementById('ruleAction').value;
                    const port = document.getElementById('rulePort').value.trim();
                    const protocol = document.getElementById('ruleProtocol').value;
                    const source = document.getElementById('ruleSource').value.trim();
                    const comment = document.getElementById('ruleComment').value.trim();

                    if (!port) {
                        alert('Please specify a port or port range');
                        return;
                    }

                    rules.push({ action, port, protocol, source, comment });

                    // Clear inputs
                    document.getElementById('rulePort').value = '';
                    document.getElementById('ruleSource').value = '';
                    document.getElementById('ruleComment').value = '';

                    updateRulesList();
                    generateOutput();
                }

                function removeRule(index) {
                    rules.splice(index, 1);
                    updateRulesList();
                    generateOutput();
                }

                function clearAllRules() {
                    if (confirm('Clear all rules?')) {
                        rules = [];
                        updateRulesList();
                        generateOutput();
                    }
                }

                function updateRulesList() {
                    const container = document.getElementById('rulesList');

                    if (rules.length === 0) {
                        container.innerHTML = '<p class="text-muted small mb-0">No rules added yet</p>';
                        return;
                    }

                    let html = '';
                    rules.forEach((rule, index) => {
                        const actionColor = rule.action === 'allow' ? 'success' : rule.action === 'deny' ? 'danger' : 'warning';
                        html += `<div class="rule-item">
                            <div>
                                <span class="badge badge-${actionColor}">${rule.action.toUpperCase()}</span>
                                <strong>${rule.port}</strong>/${rule.protocol}
                                ${rule.source ? `from <code>${rule.source}</code>` : ''}
                                ${rule.comment ? `<br><small class="text-muted">${rule.comment}</small>` : ''}
                            </div>
                            <button class="btn btn-sm btn-outline-danger" onclick="removeRule(${index})">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>`;
                    });

                    container.innerHTML = html;
                }

                function generateOutput() {
                    const mode = document.querySelector('input[name="outputMode"]:checked').value;
                    const policyIn = document.getElementById('policyIncoming').value;
                    const policyOut = document.getElementById('policyOutgoing').value;
                    const logging = document.getElementById('enableLogging').checked;
                    const showComments = document.getElementById('showComments').checked;

                    document.getElementById('outputTitle').textContent = mode === 'ufw' ? 'UFW Commands' : 'iptables Commands';

                    let output = `# Generated by 8gwifi.org Firewall Rules Generator\n`;
                    output += `# Date: ${new Date().toISOString()}\n\n`;

                    if (mode === 'ufw') {
                        output += generateUFW(policyIn, policyOut, logging, showComments);
                    } else {
                        output += generateIptables(policyIn, policyOut, logging, showComments);
                    }

                    document.getElementById('rulesOutput').textContent = output;
                }

                function generateUFW(policyIn, policyOut, logging, showComments) {
                    let output = `# Configure UFW\n`;
                    output += `# Make sure UFW is installed: sudo apt install ufw\n\n`;

                    output += `# Reset to defaults (optional)\n`;
                    output += `sudo ufw --force reset\n\n`;

                    output += `# Set default policies\n`;
                    output += `sudo ufw default ${policyIn} incoming\n`;
                    output += `sudo ufw default ${policyOut} outgoing\n\n`;

                    if (logging) {
                        output += `# Enable logging\n`;
                        output += `sudo ufw logging on\n\n`;
                    }

                    if (rules.length > 0) {
                        output += `# Add rules\n`;
                        rules.forEach(rule => {
                            if (showComments && rule.comment) {
                                output += `# ${rule.comment}\n`;
                            }

                            let cmd = `sudo ufw `;

                            if (rule.action === 'limit') {
                                cmd += `limit `;
                            } else {
                                cmd += `${rule.action} `;
                            }

                            if (rule.source) {
                                cmd += `from ${rule.source} to any `;
                            }

                            cmd += `port ${rule.port}`;

                            if (rule.protocol !== 'any') {
                                cmd += ` proto ${rule.protocol}`;
                            }

                            if (rule.comment && !showComments) {
                                cmd += ` comment '${rule.comment}'`;
                            }

                            output += cmd + '\n';
                        });
                        output += '\n';
                    }

                    output += `# Enable firewall\n`;
                    output += `sudo ufw enable\n\n`;
                    output += `# Check status\n`;
                    output += `sudo ufw status verbose`;

                    return output;
                }

                function generateIptables(policyIn, policyOut, logging, showComments) {
                    let output = `# iptables rules\n`;
                    output += `# Save these to /etc/iptables/rules.v4 or use iptables-save\n\n`;

                    output += `# Flush existing rules\n`;
                    output += `iptables -F\n`;
                    output += `iptables -X\n\n`;

                    output += `# Set default policies\n`;
                    const policyInAction = policyIn === 'allow' ? 'ACCEPT' : 'DROP';
                    const policyOutAction = policyOut === 'allow' ? 'ACCEPT' : 'DROP';
                    output += `iptables -P INPUT ${policyInAction}\n`;
                    output += `iptables -P FORWARD DROP\n`;
                    output += `iptables -P OUTPUT ${policyOutAction}\n\n`;

                    output += `# Allow loopback\n`;
                    output += `iptables -A INPUT -i lo -j ACCEPT\n`;
                    output += `iptables -A OUTPUT -o lo -j ACCEPT\n\n`;

                    output += `# Allow established connections\n`;
                    output += `iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT\n\n`;

                    if (rules.length > 0) {
                        output += `# Custom rules\n`;
                        rules.forEach(rule => {
                            if (showComments && rule.comment) {
                                output += `# ${rule.comment}\n`;
                            }

                            const action = rule.action === 'allow' ? 'ACCEPT' : rule.action === 'deny' ? 'DROP' : 'ACCEPT';
                            let cmd = `iptables -A INPUT`;

                            const protoMap = { tcp: 'tcp', udp: 'udp', any: '' };
                            const proto = protoMap[rule.protocol];

                            if (proto) {
                                cmd += ` -p ${proto}`;
                            }

                            if (rule.source) {
                                cmd += ` -s ${rule.source}`;
                            }

                            if (proto && rule.port.includes(':')) {
                                // Port range
                                cmd += ` -m multiport --dports ${rule.port}`;
                            } else if (proto) {
                                cmd += ` --dport ${rule.port}`;
                            }

                            if (rule.action === 'limit') {
                                cmd += ` -m limit --limit 10/minute --limit-burst 20`;
                            }

                            cmd += ` -j ${action}`;

                            if (rule.comment) {
                                cmd += ` -m comment --comment "${rule.comment.replace(/"/g, '\\"')}"`;
                            }

                            output += cmd + '\n';
                        });
                        output += '\n';
                    }

                    if (logging) {
                        output += `# Logging (dropped packets)\n`;
                        output += `iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables-dropped: " --log-level 4\n\n`;
                    }

                    output += `# Save rules\n`;
                    output += `# Debian/Ubuntu: iptables-save > /etc/iptables/rules.v4\n`;
                    output += `# CentOS/RHEL: service iptables save`;

                    return output;
                }

                // Event Listeners
                document.querySelectorAll('input[name="outputMode"]').forEach(radio => {
                    radio.addEventListener('change', generateOutput);
                });

                document.getElementById('policyIncoming').addEventListener('change', generateOutput);
                document.getElementById('policyOutgoing').addEventListener('change', generateOutput);
                document.getElementById('enableLogging').addEventListener('change', generateOutput);
                document.getElementById('showComments').addEventListener('change', generateOutput);

                function copyRules() {
                    const text = document.getElementById('rulesOutput').textContent;
                    navigator.clipboard.writeText(text).then(() => {
                        const btn = document.querySelector('.btn-light');
                        const original = btn.innerHTML;
                        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                        setTimeout(() => btn.innerHTML = original, 2000);
                    });
                }

                function shareUrl() {
                    const formData = {
                        outputMode: document.querySelector('input[name="outputMode"]:checked').value,
                        policyIncoming: document.getElementById('policyIncoming').value,
                        policyOutgoing: document.getElementById('policyOutgoing').value,
                        enableLogging: document.getElementById('enableLogging').checked,
                        showComments: document.getElementById('showComments').checked,
                        rules: rules
                    };

                    try {
                        const jsonData = JSON.stringify(formData);
                        const base64Encoded = btoa(unescape(encodeURIComponent(jsonData)));
                        const urlEncoded = encodeURIComponent(base64Encoded);
                        const shareUrl = window.location.origin + window.location.pathname + '?data=' + urlEncoded;

                        document.getElementById('shareUrlText').value = shareUrl;
                        $('#shareUrlModal').modal('show');
                    } catch (e) {
                        console.error('Error generating share URL:', e);
                    }
                }

                function loadFromUrl() {
                    const urlParams = new URLSearchParams(window.location.search);
                    const dataParam = urlParams.get('data');

                    if (dataParam) {
                        try {
                            const base64Decoded = decodeURIComponent(dataParam);
                            const jsonData = decodeURIComponent(escape(atob(base64Decoded)));
                            const formData = JSON.parse(jsonData);

                            document.querySelector(`input[name="outputMode"][value="${formData.outputMode || 'ufw'}"]`).checked = true;
                            document.getElementById('policyIncoming').value = formData.policyIncoming || 'deny';
                            document.getElementById('policyOutgoing').value = formData.policyOutgoing || 'allow';
                            document.getElementById('enableLogging').checked = formData.enableLogging || false;
                            document.getElementById('showComments').checked = formData.showComments !== false;

                            if (formData.rules && formData.rules.length > 0) {
                                rules = formData.rules;
                                updateRulesList();
                            }

                            generateOutput();
                        } catch (e) {
                            console.error('Error loading from URL:', e);
                            generateOutput();
                        }
                    } else {
                        generateOutput();
                    }
                }

                document.getElementById('copyShareUrl').addEventListener('click', function () {
                    const shareUrl = document.getElementById('shareUrlText').value;
                    navigator.clipboard.writeText(shareUrl).then(() => {
                        const btn = this;
                        const originalText = btn.innerHTML;
                        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                        btn.classList.remove('btn-success');
                        btn.classList.add('btn-dark');
                        setTimeout(function () {
                            btn.innerHTML = originalText;
                            btn.classList.remove('btn-dark');
                            btn.classList.add('btn-success');
                        }, 2000);
                    });
                });

                // Initialize
                loadFromUrl();
            </script>

            <div class="sharethis-inline-share-buttons"></div>
            <%@ include file="footer_adsense.jsp" %>
                <%@ include file="thanks.jsp" %>
                    <hr>
                    <%@ include file="addcomments.jsp" %>
                        </div>
                        <%@ include file="body-close.jsp" %>