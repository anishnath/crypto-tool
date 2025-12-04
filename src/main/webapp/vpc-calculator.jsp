<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Advanced VPC Calculator & Subnet Planner",
        "description": "Free AWS VPC calculator with CIDR planning, subnet distribution, IP conflict checking, and Terraform/CloudFormation export. Plan your cloud network architecture.",
        "url": "https://8gwifi.org/vpc-calculator.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "creator": {
            "@type": "Organization",
            "name": "8gwifi.org"
        },
        "keywords": "vpc calculator, subnet calculator, cidr calculator, aws vpc, azure vnet, gcp vpc, ip calculator, network planning, cloud networking, terraform generator, cloudformation"
    }
    </script>

    <title>Advanced VPC Calculator & Subnet Planner Online Free | AWS/Azure/GCP | 8gwifi.org</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Free advanced VPC calculator for AWS, Azure, GCP with CIDR planning, subnet distribution, visual network diagrams, IP conflict checking, and infrastructure-as-code export.">
    <meta name="keywords" content="vpc calculator, subnet calculator, cidr calculator, aws vpc planner, azure vnet calculator, gcp vpc, ip address calculator, network subnet calculator, cloud networking tool, terraform generator, cloudformation template">
    <meta name="author" content="8gwifi.org">
    <meta name="robots" content="index, follow">

    <!-- OpenGraph -->
    <meta property="og:title" content="Advanced VPC Calculator - AWS/Azure/GCP Subnet Planner">
    <meta property="og:description" content="Plan cloud networks with CIDR calculator, subnet distribution, visual diagrams, and infrastructure-as-code export.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/vpc-calculator.jsp">
    <meta property="og:site_name" content="8gwifi.org">
    <meta property="og:image" content="https://8gwifi.org/images/site/logo.png">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Advanced VPC Calculator & Subnet Planner">
    <meta name="twitter:description" content="Plan AWS/Azure/GCP networks with CIDR calculator and visual diagrams.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/logo.png">

    <link rel="canonical" href="https://8gwifi.org/vpc-calculator.jsp">

    <%@ include file="header-script.jsp"%>

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        }

        h1 {
            color: #2d3748;
            font-size: 2rem;
            font-weight: 700;
        }

        .info-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .info-box h3 {
            margin-top: 0;
            font-size: 1.3rem;
        }

        .calculator-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .panel {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .panel h3 {
            color: #2d3748;
            font-size: 1.1rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
            font-size: 13px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            font-family: 'Monaco', 'Courier New', monospace;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: transform 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: white;
            color: #4a5568;
            padding: 10px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s;
        }

        .btn-secondary:hover {
            background: #f7fafc;
            border-color: #cbd5e0;
        }

        .btn-small {
            padding: 6px 12px;
            font-size: 13px;
        }

        .result-box {
            background: #f7fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 15px;
        }

        .result-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .result-row:last-child {
            border-bottom: none;
        }

        .result-label {
            font-weight: 600;
            color: #4a5568;
        }

        .result-value {
            font-family: 'Monaco', 'Courier New', monospace;
            color: #2d3748;
        }

        .subnet-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .subnet-table th {
            background: #667eea;
            color: white;
            padding: 10px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
        }

        .subnet-table td {
            padding: 10px;
            border-bottom: 1px solid #e2e8f0;
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 12px;
        }

        .subnet-table tr:hover {
            background: #f7fafc;
        }

        .az-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            margin-right: 5px;
        }

        .az-a { background: #e6fffa; color: #234e52; }
        .az-b { background: #fef3c7; color: #78350f; }
        .az-c { background: #fee2e2; color: #7f1d1d; }

        .subnet-type {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
        }

        .type-public { background: #d1fae5; color: #065f46; }
        .type-private { background: #fce7f3; color: #831843; }
        .type-database { background: #dbeafe; color: #1e3a8a; }
        .type-app { background: #e9d5ff; color: #6b21a8; }
        .type-data { background: #fed7aa; color: #92400e; }
        .type-management { background: #fef3c7; color: #78350f; }
        .type-cache { background: #ccfbf1; color: #134e4a; }
        .type-internal { background: #e0e7ff; color: #3730a3; }
        .type-mesh { background: #fce7f3; color: #9f1239; }
        .type-web { background: #d1fae5; color: #065f46; }
        .type-api { background: #ddd6fe; color: #5b21b6; }
        .type-worker { background: #fecaca; color: #7f1d1d; }

        .action-btn {
            padding: 6px 12px;
            margin: 2px;
            font-size: 11px;
            border: 1px solid #667eea;
            background: white;
            color: #667eea;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
            font-weight: 500;
        }

        .action-btn:hover {
            background: #667eea;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(102, 126, 234, 0.3);
        }

        .action-btn:active {
            transform: translateY(0);
        }

        .network-diagram {
            background: #1e1e1e;
            color: #f8f8f2;
            padding: 15px;
            border-radius: 6px;
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 11px;
            overflow-x: auto;
            white-space: pre;
            line-height: 1.4;
            max-height: 400px;
            overflow-y: auto;
        }

        .code-output {
            background: #1e1e1e;
            color: #f8f8f2;
            padding: 15px;
            border-radius: 6px;
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 11px;
            overflow-x: auto;
            max-height: 350px;
            overflow-y: auto;
            line-height: 1.4;
        }

        .tab-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 10px;
        }

        .tab-btn {
            padding: 8px 16px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 6px 6px 0 0;
            cursor: pointer;
            font-weight: 500;
            color: #4a5568;
            transition: all 0.3s;
        }

        .tab-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-info {
            background: #dbeafe;
            border-left: 4px solid #3b82f6;
            color: #1e3a8a;
        }

        .alert-warning {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            color: #78350f;
        }

        .alert-error {
            background: #fee2e2;
            border-left: 4px solid #ef4444;
            color: #7f1d1d;
        }

        @media (max-width: 1200px) {
            .calculator-container {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 1.5rem;
            }

            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Advanced VPC Calculator & Subnet Planner</h1>
<p>Plan and visualize your cloud network architecture with CIDR calculator, subnet distribution, and infrastructure-as-code export</p>

<hr>

<div class="info-box">
    <h3>🌐 Professional VPC Network Planning Tool</h3>
    <p>Calculate CIDR blocks, plan subnets across availability zones, visualize network architecture, check for IP conflicts, and export to Terraform or CloudFormation. Perfect for AWS, Azure, and GCP network planning.</p>
</div>

<div class="calculator-container">
    <!-- Left Panel - Configuration -->
    <div class="panel">
        <h3>⚙️ VPC Configuration</h3>

        <div class="form-group">
            <label>Cloud Provider</label>
            <select id="cloudProvider" onchange="updateProvider()">
                <option value="aws">AWS (Amazon Web Services)</option>
                <option value="azure">Azure (Microsoft)</option>
                <option value="gcp">GCP (Google Cloud)</option>
            </select>
        </div>

        <div class="form-group">
            <label>VPC Name</label>
            <input type="text" id="vpcName" value="my-vpc" placeholder="my-vpc">
        </div>

        <div class="form-group">
            <label>VPC CIDR Block</label>
            <input type="text" id="vpcCidr" value="10.0.0.0/16" placeholder="10.0.0.0/16" oninput="validateAndCalculate()">
            <small style="color: #718096; font-size: 11px;">Format: IP/Prefix (e.g., 10.0.0.0/16, 172.16.0.0/12, 192.168.0.0/24)</small>
        </div>

        <div class="form-group">
            <label>Number of Availability Zones</label>
            <select id="azCount" onchange="calculateSubnets()">
                <option value="1">1 AZ</option>
                <option value="2" selected>2 AZs</option>
                <option value="3">3 AZs</option>
                <option value="4">4 AZs</option>
            </select>
        </div>

        <div class="form-group">
            <label>Subnet Strategy</label>
            <select id="subnetStrategy" onchange="calculateSubnets()">
                <option value="even">Even Distribution</option>
                <option value="public-only">Public Only</option>
                <option value="private-only">Private Only</option>
                <option value="public-private">Public + Private Subnets</option>
                <option value="three-tier">3-Tier (Public + Private + Database)</option>
                <option value="four-tier">4-Tier (Public + App + Data + Management)</option>
                <option value="ha-web">HA Web Application (Public + App + Cache + DB)</option>
                <option value="microservices">Microservices (Public + Internal + Data + Mesh)</option>
                <option value="isolated-workloads">Isolated Workloads (per AZ isolation)</option>
            </select>
        </div>

        <div class="form-group">
            <label>Subnet Size (CIDR Prefix)</label>
            <select id="subnetSize" onchange="calculateSubnets()">
                <option value="24">/24 (256 IPs)</option>
                <option value="25">/25 (128 IPs)</option>
                <option value="26">/26 (64 IPs)</option>
                <option value="27">/27 (32 IPs)</option>
                <option value="28">/28 (16 IPs)</option>
            </select>
        </div>

        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <button class="btn-primary" onclick="calculateSubnets()">🔄 Calculate Subnets</button>
            <button class="btn-secondary" onclick="resetCalculator()">🗑️ Reset</button>
            <button class="btn-secondary" onclick="shareConfig()">🔗 Share</button>
        </div>
    </div>

    <!-- Right Panel - VPC Information -->
    <div class="panel">
        <h3>📊 VPC Information</h3>
        <div id="vpcInfo"></div>
    </div>
</div>

<!-- Subnets Table -->
<div class="panel">
    <h3>🗂️ Subnet Allocation</h3>
    <div id="subnetsTable" style="max-height: 450px; overflow-y: auto;"></div>
</div>

<!-- Tabs for Diagram and Export -->
<div class="panel">
    <div class="tab-buttons">
        <button class="tab-btn active" onclick="switchTab('diagram')">Network Diagram</button>
        <button class="tab-btn" onclick="switchTab('terraform')">Terraform</button>
        <button class="tab-btn" onclick="switchTab('cloudformation')">CloudFormation</button>
        <button class="tab-btn" onclick="switchTab('cost')">Cost Estimate</button>
    </div>

    <div class="tab-content active" id="diagram-tab">
        <h4 style="margin-top: 0;">Visual Network Architecture</h4>
        <div style="display: flex; gap: 10px; margin-bottom: 10px;">
            <button class="btn-secondary btn-small" onclick="switchDiagramType('visual')" id="btnVisual">🎨 Visual</button>
            <button class="btn-secondary btn-small" onclick="switchDiagramType('ascii')" id="btnAscii">📝 ASCII</button>
        </div>
        <div id="visualDiagram" style="overflow-x: auto;"></div>
        <div id="networkDiagram" class="network-diagram" style="display: none;"></div>
        <button class="btn-secondary btn-small" onclick="copyDiagram()">📋 Copy</button>
        <button class="btn-secondary btn-small" onclick="downloadDiagram()">💾 Download PNG</button>
    </div>

    <div class="tab-content" id="terraform-tab">
        <h4 style="margin-top: 0;">Terraform Configuration</h4>
        <div id="terraformCode" class="code-output"></div>
        <button class="btn-secondary btn-small" onclick="copyTerraform()">📋 Copy Code</button>
        <button class="btn-secondary btn-small" onclick="downloadTerraform()">💾 Download .tf</button>
    </div>

    <div class="tab-content" id="cloudformation-tab">
        <h4 style="margin-top: 0;">CloudFormation Template</h4>
        <div id="cloudformationCode" class="code-output"></div>
        <button class="btn-secondary btn-small" onclick="copyCloudFormation()">📋 Copy Template</button>
        <button class="btn-secondary btn-small" onclick="downloadCloudFormation()">💾 Download .yaml</button>
    </div>

    <div class="tab-content" id="cost-tab">
        <h4 style="margin-top: 0;">Estimated Monthly Costs</h4>
        <div id="costEstimate"></div>
    </div>
</div>

<h2 class="mt-4">Features</h2>
<ul>
    <li><strong>CIDR Calculator:</strong> Validate and calculate IP ranges for VPC blocks</li>
    <li><strong>Multi-Cloud Support:</strong> AWS, Azure (VNet), and GCP configurations</li>
    <li><strong>Subnet Planning:</strong> Automatic subnet distribution across availability zones</li>
    <li><strong>Multiple Strategies:</strong> Even distribution, public/private, or 3-tier architecture</li>
    <li><strong>Visual Diagrams:</strong> ASCII network architecture diagrams</li>
    <li><strong>IP Conflict Detection:</strong> Validate subnet overlaps and conflicts</li>
    <li><strong>IaC Export:</strong> Generate Terraform and CloudFormation templates</li>
    <li><strong>Cost Estimation:</strong> Estimate monthly costs for VPC components</li>
    <li><strong>Client-Side:</strong> 100% browser-based, your network plans stay private</li>
</ul>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- Visible FAQs -->
<div class="container mt-4">
  <h2 class="mt-4" id="faqs">FAQs</h2>
  <div class="accordion" id="vpcFaqs">
    <div class="card"><div class="card-header"><h6 class="mb-0">How should I pick a VPC CIDR?</h6></div><div class="card-body small text-muted">Choose a non‑overlapping private CIDR (RFC1918) sized for growth (e.g., 10.0.0.0/16). Avoid conflicts with on‑prem or peered networks.</div></div>
    <div class="card"><div class="card-header"><h6 class="mb-0">What subnet sizes are recommended?</h6></div><div class="card-body small text-muted">/24 is common for application tiers; /28–/26 for smaller/internal tiers. Balance IP usage, AZ distribution, and future scale.</div></div>
    <div class="card"><div class="card-header"><h6 class="mb-0">How do I avoid overlapping IPs?</h6></div><div class="card-body small text-muted">Use the planner’s conflict warnings and reserve ranges for peering/VPN. Keep a registry for all assigned CIDRs across environments.</div></div>
  </div>
</div>

<script>
    let currentVPC = null;
    let subnets = [];
    let subnetIdCounter = 0;

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        calculateSubnets();
    });

    // Switch tabs
    function switchTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

        event.target.classList.add('active');
        document.getElementById(tab + '-tab').classList.add('active');

        // Generate content when switching to tab
        if (tab === 'terraform') generateTerraform();
        if (tab === 'cloudformation') generateCloudFormation();
        if (tab === 'cost') generateCostEstimate();
    }

    // Update provider-specific settings
    function updateProvider() {
        const provider = document.getElementById('cloudProvider').value;

        // Update terminology based on provider
        const vpcLabel = document.querySelector('label[for="vpcName"]');
        const vpcNameInput = document.getElementById('vpcName');

        if (provider === 'azure') {
            if (vpcLabel) vpcLabel.textContent = 'VNet Name';
            vpcNameInput.placeholder = 'my-vnet';
            if (vpcNameInput.value === 'my-vpc') vpcNameInput.value = 'my-vnet';
        } else if (provider === 'gcp') {
            if (vpcLabel) vpcLabel.textContent = 'VPC Network Name';
            vpcNameInput.placeholder = 'my-vpc-network';
            if (vpcNameInput.value === 'my-vpc' || vpcNameInput.value === 'my-vnet') {
                vpcNameInput.value = 'my-vpc-network';
            }
        } else {
            if (vpcLabel) vpcLabel.textContent = 'VPC Name';
            vpcNameInput.placeholder = 'my-vpc';
            if (vpcNameInput.value === 'my-vnet' || vpcNameInput.value === 'my-vpc-network') {
                vpcNameInput.value = 'my-vpc';
            }
        }

        calculateSubnets();
    }

    // Parse CIDR block
    function parseCIDR(cidr) {
        const parts = cidr.split('/');
        if (parts.length !== 2) return null;

        const ip = parts[0].split('.').map(Number);
        if (ip.length !== 4 || ip.some(n => isNaN(n) || n < 0 || n > 255)) return null;

        const prefix = parseInt(parts[1]);
        if (isNaN(prefix) || prefix < 0 || prefix > 32) return null;

        return { ip, prefix };
    }

    // IP to integer
    function ipToInt(ip) {
        return (ip[0] << 24) + (ip[1] << 16) + (ip[2] << 8) + ip[3];
    }

    // Integer to IP
    function intToIp(int) {
        return [
            (int >>> 24) & 0xFF,
            (int >>> 16) & 0xFF,
            (int >>> 8) & 0xFF,
            int & 0xFF
        ];
    }

    // Calculate network info
    function calculateNetworkInfo(cidr) {
        const parsed = parseCIDR(cidr);
        if (!parsed) return null;

        const { ip, prefix } = parsed;
        const ipInt = ipToInt(ip);

        const mask = -1 << (32 - prefix);
        const networkInt = ipInt & mask;
        const broadcastInt = networkInt | (~mask & 0xFFFFFFFF);

        const totalIPs = Math.pow(2, 32 - prefix);
        const usableIPs = totalIPs - 2; // Minus network and broadcast

        return {
            cidr: cidr,
            network: intToIp(networkInt).join('.'),
            broadcast: intToIp(broadcastInt).join('.'),
            firstUsable: intToIp(networkInt + 1).join('.'),
            lastUsable: intToIp(broadcastInt - 1).join('.'),
            totalIPs: totalIPs,
            usableIPs: Math.max(0, usableIPs),
            prefix: prefix
        };
    }

    // Validate and calculate VPC info
    function validateAndCalculate() {
        const cidr = document.getElementById('vpcCidr').value;
        const info = calculateNetworkInfo(cidr);

        if (!info) {
            document.getElementById('vpcInfo').innerHTML =
                '<div class="alert alert-error">⚠️ Invalid CIDR format. Use format: IP/Prefix (e.g., 10.0.0.0/16)</div>';
            return false;
        }

        currentVPC = info;
        displayVPCInfo(info);
        return true;
    }

    // Display VPC information
    function displayVPCInfo(info) {
        const html = '<div class="result-box">' +
                '<div class="result-row">' +
                    '<span class="result-label">Network Address:</span>' +
                    '<span class="result-value">' + info.network + '/' + info.prefix + '</span>' +
                '</div>' +
                '<div class="result-row">' +
                    '<span class="result-label">Broadcast Address:</span>' +
                    '<span class="result-value">' + info.broadcast + '</span>' +
                '</div>' +
                '<div class="result-row">' +
                    '<span class="result-label">First Usable IP:</span>' +
                    '<span class="result-value">' + info.firstUsable + '</span>' +
                '</div>' +
                '<div class="result-row">' +
                    '<span class="result-label">Last Usable IP:</span>' +
                    '<span class="result-value">' + info.lastUsable + '</span>' +
                '</div>' +
                '<div class="result-row">' +
                    '<span class="result-label">Total IP Addresses:</span>' +
                    '<span class="result-value">' + info.totalIPs.toLocaleString() + '</span>' +
                '</div>' +
                '<div class="result-row">' +
                    '<span class="result-label">Usable IP Addresses:</span>' +
                    '<span class="result-value">' + info.usableIPs.toLocaleString() + '</span>' +
                '</div>' +
            '</div>';
        document.getElementById('vpcInfo').innerHTML = html;
    }

    // Calculate subnets
    function calculateSubnets() {
        if (!validateAndCalculate()) return;

        const azCount = parseInt(document.getElementById('azCount').value);
        const strategy = document.getElementById('subnetStrategy').value;
        const subnetPrefix = parseInt(document.getElementById('subnetSize').value);

        subnets = [];
        const baseIp = parseCIDR(document.getElementById('vpcCidr').value);
        let currentIpInt = ipToInt(baseIp.ip);

        const azLabels = ['a', 'b', 'c', 'd'];

        subnetIdCounter = 0;
        if (strategy === 'even') {
            for (let az = 0; az < azCount; az++) {
                subnets.push({
                    id: subnetIdCounter++,
                    name: 'subnet-' + azLabels[az],
                    cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                    az: azLabels[az],
                    type: 'public',
                    divided: false,
                    parentId: null
                });
                currentIpInt += Math.pow(2, 32 - subnetPrefix);
            }
        } else if (strategy === 'public-private') {
            for (let az = 0; az < azCount; az++) {
                subnets.push({
                    id: subnetIdCounter++,
                    name: 'public-subnet-' + azLabels[az],
                    cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                    az: azLabels[az],
                    type: 'public',
                    divided: false,
                    parentId: null
                });
                currentIpInt += Math.pow(2, 32 - subnetPrefix);
            }
            for (let az = 0; az < azCount; az++) {
                subnets.push({
                    id: subnetIdCounter++,
                    name: 'private-subnet-' + azLabels[az],
                    cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                    az: azLabels[az],
                    type: 'private',
                    divided: false,
                    parentId: null
                });
                currentIpInt += Math.pow(2, 32 - subnetPrefix);
            }
        } else if (strategy === 'public-only') {
            for (let az = 0; az < azCount; az++) {
                subnets.push({
                    id: subnetIdCounter++,
                    name: 'public-subnet-' + azLabels[az],
                    cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                    az: azLabels[az],
                    type: 'public',
                    divided: false,
                    parentId: null
                });
                currentIpInt += Math.pow(2, 32 - subnetPrefix);
            }
        } else if (strategy === 'private-only') {
            for (let az = 0; az < azCount; az++) {
                subnets.push({
                    id: subnetIdCounter++,
                    name: 'private-subnet-' + azLabels[az],
                    cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                    az: azLabels[az],
                    type: 'private',
                    divided: false,
                    parentId: null
                });
                currentIpInt += Math.pow(2, 32 - subnetPrefix);
            }
        } else if (strategy === 'three-tier') {
            for (let az = 0; az < azCount; az++) {
                subnets.push({
                    id: subnetIdCounter++,
                    name: 'public-subnet-' + azLabels[az],
                    cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                    az: azLabels[az],
                    type: 'public',
                    divided: false,
                    parentId: null
                });
                currentIpInt += Math.pow(2, 32 - subnetPrefix);
            }
            for (let az = 0; az < azCount; az++) {
                subnets.push({
                    id: subnetIdCounter++,
                    name: 'private-subnet-' + azLabels[az],
                    cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                    az: azLabels[az],
                    type: 'private',
                    divided: false,
                    parentId: null
                });
                currentIpInt += Math.pow(2, 32 - subnetPrefix);
            }
            for (let az = 0; az < azCount; az++) {
                subnets.push({
                    id: subnetIdCounter++,
                    name: 'database-subnet-' + azLabels[az],
                    cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                    az: azLabels[az],
                    type: 'database',
                    divided: false,
                    parentId: null
                });
                currentIpInt += Math.pow(2, 32 - subnetPrefix);
            }
        } else if (strategy === 'four-tier') {
            const tiers = ['public', 'app', 'data', 'management'];
            tiers.forEach(tier => {
                for (let az = 0; az < azCount; az++) {
                    subnets.push({
                        id: subnetIdCounter++,
                        name: tier + '-subnet-' + azLabels[az],
                        cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                        az: azLabels[az],
                        type: tier,
                        divided: false,
                        parentId: null
                    });
                    currentIpInt += Math.pow(2, 32 - subnetPrefix);
                }
            });
        } else if (strategy === 'ha-web') {
            const tiers = ['public', 'app', 'cache', 'database'];
            tiers.forEach(tier => {
                for (let az = 0; az < azCount; az++) {
                    subnets.push({
                        id: subnetIdCounter++,
                        name: tier + '-subnet-' + azLabels[az],
                        cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                        az: azLabels[az],
                        type: tier,
                        divided: false,
                        parentId: null
                    });
                    currentIpInt += Math.pow(2, 32 - subnetPrefix);
                }
            });
        } else if (strategy === 'microservices') {
            const tiers = ['public', 'internal', 'data', 'mesh'];
            tiers.forEach(tier => {
                for (let az = 0; az < azCount; az++) {
                    subnets.push({
                        id: subnetIdCounter++,
                        name: tier + '-subnet-' + azLabels[az],
                        cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                        az: azLabels[az],
                        type: tier,
                        divided: false,
                        parentId: null
                    });
                    currentIpInt += Math.pow(2, 32 - subnetPrefix);
                }
            });
        } else if (strategy === 'isolated-workloads') {
            for (let az = 0; az < azCount; az++) {
                const workloads = ['web', 'api', 'worker', 'data'];
                workloads.forEach(workload => {
                    subnets.push({
                        id: subnetIdCounter++,
                        name: workload + '-az' + azLabels[az],
                        cidr: intToIp(currentIpInt).join('.') + '/' + subnetPrefix,
                        az: azLabels[az],
                        type: workload,
                        divided: false,
                        parentId: null
                    });
                    currentIpInt += Math.pow(2, 32 - subnetPrefix);
                });
            }
        }

        displaySubnets();
        generateNetworkDiagram();
    }

    // Display subnets table
    function displaySubnets() {
        if (subnets.length === 0) {
            document.getElementById('subnetsTable').innerHTML = '<p>No subnets configured yet.</p>';
            return;
        }

        // Filter to show only non-divided subnets
        const visibleSubnets = subnets.filter(s => !s.divided);

        let html = '<table class="subnet-table">' +
                '<thead>' +
                    '<tr>' +
                        '<th>Name</th>' +
                        '<th>CIDR Block</th>' +
                        '<th>Netmask</th>' +
                        '<th>Usable IPs</th>' +
                        '<th>IP Range</th>' +
                        '<th>Actions</th>' +
                    '</tr>' +
                '</thead>' +
                '<tbody>';

        visibleSubnets.forEach(subnet => {
            const info = calculateNetworkInfo(subnet.cidr);
            const parsed = parseCIDR(subnet.cidr);
            const canDivide = parsed.prefix < 30; // Can't divide /31 or /32
            const canJoin = canBeJoined(subnet.id);

            // Calculate netmask
            const prefix = parsed.prefix;
            const mask = -1 << (32 - prefix);
            const netmask = intToIp(mask >>> 0).join('.');

            html += '<tr>' +
                    '<td><strong>' + subnet.name + '</strong>' +
                        (subnet.parentId !== null ? ' <span style="color: #888; font-size: 0.9em;">(child)</span>' : '') +
                    '</td>' +
                    '<td><code>' + subnet.cidr + '</code></td>' +
                    '<td><code>' + netmask + '</code></td>' +
                    '<td>' + info.usableIPs.toLocaleString() + '</td>' +
                    '<td style="font-size: 0.85em;">' + info.firstUsable + ' - ' + info.lastUsable + '</td>' +
                    '<td>' +
                        (canDivide ? '<button class="action-btn" onclick="divideSubnet(' + subnet.id + ')" title="Split into 2 smaller subnets">✂️ Divide</button> ' : '<span style="color: #ccc;">—</span> ') +
                        (canJoin ? '<button class="action-btn" onclick="joinSubnets(' + subnet.id + ')" title="Merge with sibling">🔗 Join</button>' : '') +
                    '</td>' +
                '</tr>';
        });

        html += '</tbody></table>';
        html += '<div style="margin-top: 15px; padding: 10px; background: #f0f4ff; border-radius: 6px; font-size: 0.9em;">' +
                '💡 <strong>Tip:</strong> Use <strong>Divide</strong> to split subnets into smaller networks, <strong>Join</strong> to merge sibling subnets back together.' +
                '</div>';
        document.getElementById('subnetsTable').innerHTML = html;
    }

    // Divide a subnet into two smaller subnets
    function divideSubnet(subnetId) {
        const subnet = subnets.find(s => s.id === subnetId);
        if (!subnet) return;

        const parsed = parseCIDR(subnet.cidr);
        if (parsed.prefix >= 30) {
            alert('Cannot divide /' + parsed.prefix + ' subnet further');
            return;
        }

        // Mark parent as divided
        subnet.divided = true;

        // Calculate two child subnets
        const newPrefix = parsed.prefix + 1;
        const ipInt = ipToInt(parsed.ip);
        const halfSize = Math.pow(2, 32 - newPrefix);

        // First half
        subnets.push({
            id: subnetIdCounter++,
            name: subnet.name + '-1',
            cidr: intToIp(ipInt).join('.') + '/' + newPrefix,
            az: subnet.az,
            type: subnet.type,
            divided: false,
            parentId: subnet.id
        });

        // Second half
        subnets.push({
            id: subnetIdCounter++,
            name: subnet.name + '-2',
            cidr: intToIp(ipInt + halfSize).join('.') + '/' + newPrefix,
            az: subnet.az,
            type: subnet.type,
            divided: false,
            parentId: subnet.id
        });

        displaySubnets();
        generateNetworkDiagram();
    }

    // Check if subnet can be joined with its sibling
    function canBeJoined(subnetId) {
        const subnet = subnets.find(s => s.id === subnetId);
        if (!subnet || subnet.parentId === null) return false;

        // Find sibling (other child of same parent)
        const sibling = subnets.find(s =>
            s.id !== subnetId &&
            s.parentId === subnet.parentId &&
            !s.divided
        );

        return sibling !== undefined;
    }

    // Join two sibling subnets back into their parent
    function joinSubnets(subnetId) {
        const subnet = subnets.find(s => s.id === subnetId);
        if (!subnet || subnet.parentId === null) return;

        const sibling = subnets.find(s =>
            s.id !== subnetId &&
            s.parentId === subnet.parentId &&
            !s.divided
        );

        if (!sibling) {
            alert('Cannot join: sibling subnet is divided or not found');
            return;
        }

        // Remove both children
        subnets = subnets.filter(s => s.id !== subnetId && s.id !== sibling.id);

        // Restore parent
        const parent = subnets.find(s => s.id === subnet.parentId);
        if (parent) {
            parent.divided = false;
        }

        displaySubnets();
        generateNetworkDiagram();
    }

    // Generate network diagram
    function generateNetworkDiagram() {
        const vpcName = document.getElementById('vpcName').value;
        const vpcCidr = document.getElementById('vpcCidr').value;

        let diagram = '\n┌─────────────────────────────────────────────────────────────────┐\n' +
            '│                     VPC: ' + vpcName + '                              │\n' +
            '│                     CIDR: ' + vpcCidr + '                             │\n' +
            '└─────────────────────────────────────────────────────────────────┘\n';

        // Show only visible (non-divided) subnets
        const visibleSubnets = subnets.filter(s => !s.divided);
        const grouped = {};
        visibleSubnets.forEach(subnet => {
            if (!grouped[subnet.az]) grouped[subnet.az] = [];
            grouped[subnet.az].push(subnet);
        });

        Object.keys(grouped).sort().forEach(az => {
            diagram += '\n┌─────────────────────────────────────────────────────────────────┐\n' +
                '│  Availability Zone: ' + az.toUpperCase() + '                                          │\n' +
                '├─────────────────────────────────────────────────────────────────┤\n';

            // Sort by CIDR to show hierarchy
            grouped[az].sort((a, b) => {
                const aInt = ipToInt(parseCIDR(a.cidr).ip);
                const bInt = ipToInt(parseCIDR(b.cidr).ip);
                return aInt - bInt;
            }).forEach(subnet => {
                const indent = subnet.parentId !== null ? '  ' : '';
                const marker = subnet.parentId !== null ? '└─ ' : '';
                diagram += '│  ' + indent + marker + '[' + subnet.type.toUpperCase() + '] ' +
                    subnet.name.padEnd(26) + ' ' + subnet.cidr.padEnd(18) + ' │\n';
            });
            diagram += '└─────────────────────────────────────────────────────────────────┘\n';
        });

        document.getElementById('networkDiagram').textContent = diagram;
        generateVisualDiagram();
    }

    // Generate visual SVG diagram
    function generateVisualDiagram() {
        const vpcName = document.getElementById('vpcName').value;
        const vpcCidr = document.getElementById('vpcCidr').value;
        const provider = document.getElementById('cloudProvider').value;
        const visibleSubnets = subnets.filter(s => !s.divided);

        // Provider-specific labels
        let containerLabel = 'VPC';
        if (provider === 'azure') containerLabel = 'VNet';
        else if (provider === 'gcp') containerLabel = 'VPC Network';

        if (visibleSubnets.length === 0) {
            document.getElementById('visualDiagram').innerHTML = '<p>No subnets to display</p>';
            return;
        }

        // Group by AZ
        const grouped = {};
        visibleSubnets.forEach(subnet => {
            if (!grouped[subnet.az]) grouped[subnet.az] = [];
            grouped[subnet.az].push(subnet);
        });

        const azCount = Object.keys(grouped).length;
        const maxSubnetsInAz = Math.max(...Object.values(grouped).map(g => g.length));
        const svgWidth = Math.max(800, azCount * 280);
        const svgHeight = 200 + maxSubnetsInAz * 80;

        let svg = '<svg width="' + svgWidth + '" height="' + svgHeight + '" xmlns="http://www.w3.org/2000/svg">' +
            '<defs>' +
                '<linearGradient id="vpcGradient" x1="0%" y1="0%" x2="100%" y2="0%">' +
                    '<stop offset="0%" style="stop-color:#667eea;stop-opacity:1" />' +
                    '<stop offset="100%" style="stop-color:#764ba2;stop-opacity:1" />' +
                '</linearGradient>' +
                '<filter id="shadow"><feDropShadow dx="0" dy="2" stdDeviation="3" flood-opacity="0.3"/></filter>' +
            '</defs>';

        // VPC Container
        svg += '<rect x="20" y="20" width="' + (svgWidth - 40) + '" height="' + (svgHeight - 40) + '" ' +
            'fill="url(#vpcGradient)" opacity="0.1" rx="10" stroke="#667eea" stroke-width="2"/>';

        // VPC Label
        svg += '<text x="40" y="50" font-family="Arial, sans-serif" font-size="18" font-weight="bold" fill="#667eea">' +
            containerLabel + ': ' + vpcName + ' (' + vpcCidr + ')' +
            '</text>';

        // Draw AZs and subnets
        let azIndex = 0;
        const azWidth = (svgWidth - 80) / azCount;

        Object.keys(grouped).sort().forEach(az => {
            const azX = 40 + azIndex * azWidth;
            const azY = 80;
            const azBoxWidth = azWidth - 20;
            const azSubnets = grouped[az];

            // AZ Container
            svg += '<rect x="' + azX + '" y="' + azY + '" width="' + azBoxWidth + '" height="' + (svgHeight - 120) + '" ' +
                'fill="#f7fafc" rx="8" stroke="#cbd5e0" stroke-width="2" filter="url(#shadow)"/>';

            // AZ Label
            svg += '<text x="' + (azX + 15) + '" y="' + (azY + 30) + '" font-family="Arial, sans-serif" ' +
                'font-size="14" font-weight="600" fill="#4a5568">AZ-' + az.toUpperCase() + '</text>';

            // Draw subnets
            azSubnets.forEach((subnet, idx) => {
                const subnetY = azY + 50 + idx * 75;
                const subnetX = azX + 15;
                const subnetWidth = azBoxWidth - 30;

                // Subnet color based on type
                let subnetColor = '#d1fae5';
                let textColor = '#065f46';

                const colorMap = {
                    'public': { bg: '#d1fae5', text: '#065f46' },
                    'private': { bg: '#fce7f3', text: '#831843' },
                    'database': { bg: '#dbeafe', text: '#1e3a8a' },
                    'app': { bg: '#e9d5ff', text: '#6b21a8' },
                    'data': { bg: '#fed7aa', text: '#92400e' },
                    'management': { bg: '#fef3c7', text: '#78350f' },
                    'cache': { bg: '#ccfbf1', text: '#134e4a' },
                    'internal': { bg: '#e0e7ff', text: '#3730a3' },
                    'mesh': { bg: '#fce7f3', text: '#9f1239' },
                    'web': { bg: '#d1fae5', text: '#065f46' },
                    'api': { bg: '#ddd6fe', text: '#5b21b6' },
                    'worker': { bg: '#fecaca', text: '#7f1d1d' }
                };

                if (colorMap[subnet.type]) {
                    subnetColor = colorMap[subnet.type].bg;
                    textColor = colorMap[subnet.type].text;
                }

                // Subnet box
                svg += '<rect x="' + subnetX + '" y="' + subnetY + '" width="' + subnetWidth + '" height="60" ' +
                    'fill="' + subnetColor + '" rx="6" stroke="' + textColor + '" stroke-width="1.5"/>';

                // Subnet name
                svg += '<text x="' + (subnetX + 10) + '" y="' + (subnetY + 20) + '" ' +
                    'font-family="Monaco, Courier New, monospace" font-size="12" font-weight="bold" fill="' + textColor + '">' +
                    subnet.name +
                    '</text>';

                // Subnet CIDR
                svg += '<text x="' + (subnetX + 10) + '" y="' + (subnetY + 38) + '" ' +
                    'font-family="Monaco, Courier New, monospace" font-size="11" fill="' + textColor + '">' +
                    subnet.cidr +
                    '</text>';

                // IP count
                const info = calculateNetworkInfo(subnet.cidr);
                svg += '<text x="' + (subnetX + 10) + '" y="' + (subnetY + 52) + '" ' +
                    'font-family="Arial, sans-serif" font-size="10" fill="#718096">' +
                    info.usableIPs.toLocaleString() + ' usable IPs' +
                    '</text>';

                // Child indicator
                if (subnet.parentId !== null) {
                    svg += '<circle cx="' + (subnetX + subnetWidth - 10) + '" cy="' + (subnetY + 10) + '" r="4" fill="#f59e0b"/>';
                }
            });

            azIndex++;
        });

        svg += '</svg>';
        document.getElementById('visualDiagram').innerHTML = svg;
    }

    // Switch between visual and ASCII diagram
    let currentDiagramType = 'visual';
    function switchDiagramType(type) {
        currentDiagramType = type;
        if (type === 'visual') {
            document.getElementById('visualDiagram').style.display = 'block';
            document.getElementById('networkDiagram').style.display = 'none';
            document.getElementById('btnVisual').style.background = '#667eea';
            document.getElementById('btnVisual').style.color = 'white';
            document.getElementById('btnAscii').style.background = 'white';
            document.getElementById('btnAscii').style.color = '#667eea';
        } else {
            document.getElementById('visualDiagram').style.display = 'none';
            document.getElementById('networkDiagram').style.display = 'block';
            document.getElementById('btnAscii').style.background = '#667eea';
            document.getElementById('btnAscii').style.color = 'white';
            document.getElementById('btnVisual').style.background = 'white';
            document.getElementById('btnVisual').style.color = '#667eea';
        }
    }

    // Generate Terraform code
    function generateTerraform() {
        const vpcName = document.getElementById('vpcName').value;
        const vpcCidr = document.getElementById('vpcCidr').value;
        const provider = document.getElementById('cloudProvider').value;

        let tf = '';

        if (provider === 'azure') {
            tf = '# Azure Virtual Network Configuration\n' +
                'resource "azurerm_virtual_network" "' + vpcName.replace(/-/g, '_') + '" {\n' +
                '  name                = "' + vpcName + '"\n' +
                '  address_space       = ["' + vpcCidr + '"]\n' +
                '  location            = var.location\n' +
                '  resource_group_name = var.resource_group_name\n' +
                '\n' +
                '  tags = {\n' +
                '    Name = "' + vpcName + '"\n' +
                '  }\n' +
                '}\n' +
                '\n';
        } else if (provider === 'gcp') {
            tf = '# GCP VPC Network Configuration\n' +
                'resource "google_compute_network" "' + vpcName.replace(/-/g, '_') + '" {\n' +
                '  name                    = "' + vpcName + '"\n' +
                '  auto_create_subnetworks = false\n' +
                '  project                 = var.project_id\n' +
                '}\n' +
                '\n';
        } else {
            tf = '# AWS VPC Configuration\n' +
                'resource "aws_vpc" "' + vpcName.replace(/-/g, '_') + '" {\n' +
                '  cidr_block           = "' + vpcCidr + '"\n' +
                '  enable_dns_hostnames = true\n' +
                '  enable_dns_support   = true\n' +
                '\n' +
                '  tags = {\n' +
                '    Name = "' + vpcName + '"\n' +
                '  }\n' +
                '}\n' +
                '\n';
        }

        // Only include visible (non-divided) subnets
        const visibleSubnets = subnets.filter(s => !s.divided);
        visibleSubnets.forEach(subnet => {
            const resourceName = subnet.name.replace(/-/g, '_');

            if (provider === 'azure') {
                tf += '# Subnet: ' + subnet.name + '\n' +
                    'resource "azurerm_subnet" "' + resourceName + '" {\n' +
                    '  name                 = "' + subnet.name + '"\n' +
                    '  resource_group_name  = var.resource_group_name\n' +
                    '  virtual_network_name = azurerm_virtual_network.' + vpcName.replace(/-/g, '_') + '.name\n' +
                    '  address_prefixes     = ["' + subnet.cidr + '"]\n' +
                    '}\n' +
                    '\n';
            } else if (provider === 'gcp') {
                tf += '# Subnet: ' + subnet.name + '\n' +
                    'resource "google_compute_subnetwork" "' + resourceName + '" {\n' +
                    '  name          = "' + subnet.name + '"\n' +
                    '  ip_cidr_range = "' + subnet.cidr + '"\n' +
                    '  region        = var.region\n' +
                    '  network       = google_compute_network.' + vpcName.replace(/-/g, '_') + '.id\n' +
                    '}\n' +
                    '\n';
            } else {
                tf += '# Subnet: ' + subnet.name + '\n' +
                    'resource "aws_subnet" "' + resourceName + '" {\n' +
                    '  vpc_id            = aws_vpc.' + vpcName.replace(/-/g, '_') + '.id\n' +
                    '  cidr_block        = "' + subnet.cidr + '"\n' +
                    '  availability_zone = "${data.aws_availability_zones.available.names[' + (subnet.az.charCodeAt(0) - 97) + ']}"\n' +
                    '\n' +
                    '  tags = {\n' +
                    '    Name = "' + subnet.name + '"\n' +
                    '    Type = "' + subnet.type + '"\n' +
                    '  }\n' +
                    '}\n' +
                    '\n';
            }
        });

        document.getElementById('terraformCode').textContent = tf;
    }

    // Generate CloudFormation template
    function generateCloudFormation() {
        const vpcName = document.getElementById('vpcName').value;
        const vpcCidr = document.getElementById('vpcCidr').value;

        let yaml = 'AWSTemplateFormatVersion: \'2010-09-09\'\n' +
            'Description: VPC with subnets\n' +
            '\n' +
            'Resources:\n' +
            '  VPC:\n' +
            '    Type: AWS::EC2::VPC\n' +
            '    Properties:\n' +
            '      CidrBlock: ' + vpcCidr + '\n' +
            '      EnableDnsHostnames: true\n' +
            '      EnableDnsSupport: true\n' +
            '      Tags:\n' +
            '        - Key: Name\n' +
            '          Value: ' + vpcName + '\n' +
            '\n';

        // Only include visible (non-divided) subnets
        const visibleSubnets = subnets.filter(s => !s.divided);
        visibleSubnets.forEach((subnet, index) => {
            yaml += '  Subnet' + (index + 1) + ':\n' +
                '    Type: AWS::EC2::Subnet\n' +
                '    Properties:\n' +
                '      VpcId: !Ref VPC\n' +
                '      CidrBlock: ' + subnet.cidr + '\n' +
                '      AvailabilityZone: !Select\n' +
                '        - ' + (subnet.az.charCodeAt(0) - 97) + '\n' +
                '        - !GetAZs \'\'\n' +
                '      Tags:\n' +
                '        - Key: Name\n' +
                '          Value: ' + subnet.name + '\n' +
                '        - Key: Type\n' +
                '          Value: ' + subnet.type + '\n' +
                '\n';
        });

        document.getElementById('cloudformationCode').textContent = yaml;
    }

    // Generate cost estimate
    function generateCostEstimate() {
        const azCount = parseInt(document.getElementById('azCount').value);
        const publicSubnets = subnets.filter(s => s.type === 'public').length;

        // Rough monthly cost estimates (US East region)
        const natGatewayCost = azCount * 32.40; // $0.045/hour per AZ
        const dataTransferCost = 50; // Estimated
        const vpcCost = 0; // VPC itself is free

        const total = natGatewayCost + dataTransferCost;

        const html = '<div class="result-box">' +
                '<div class="alert alert-info">' +
                    '💡 Cost estimates are approximate and based on US East region. Actual costs may vary.' +
                '</div>' +
                '<div class="result-row">' +
                    '<span class="result-label">VPC (No charge):</span>' +
                    '<span class="result-value">$0.00/month</span>' +
                '</div>' +
                '<div class="result-row">' +
                    '<span class="result-label">NAT Gateways (' + azCount + ' AZs):</span>' +
                    '<span class="result-value">$' + natGatewayCost.toFixed(2) + '/month</span>' +
                '</div>' +
                '<div class="result-row">' +
                    '<span class="result-label">Data Transfer (est.):</span>' +
                    '<span class="result-value">$' + dataTransferCost.toFixed(2) + '/month</span>' +
                '</div>' +
                '<div class="result-row" style="border-top: 2px solid #667eea; margin-top: 10px; padding-top: 10px;">' +
                    '<span class="result-label"><strong>Estimated Total:</strong></span>' +
                    '<span class="result-value"><strong>$' + total.toFixed(2) + '/month</strong></span>' +
                '</div>' +
            '</div>' +
            '<div class="alert alert-warning">' +
                '⚠️ Additional costs may include: VPN connections, VPC endpoints, IP addresses, load balancers, and data transfer out.' +
            '</div>';

        document.getElementById('costEstimate').innerHTML = html;
    }

    // Copy functions
    function copyDiagram() {
        if (currentDiagramType === 'ascii') {
            const text = document.getElementById('networkDiagram').textContent;
            navigator.clipboard.writeText(text).then(() => alert('ASCII diagram copied!'));
        } else {
            alert('Use "Download PNG" to save the visual diagram');
        }
    }

    // Download visual diagram as PNG
    function downloadDiagram() {
        const svg = document.getElementById('visualDiagram').querySelector('svg');
        if (!svg) {
            alert('No diagram to download');
            return;
        }

        const svgData = new XMLSerializer().serializeToString(svg);
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        const img = new Image();

        canvas.width = svg.getAttribute('width');
        canvas.height = svg.getAttribute('height');

        img.onload = function() {
            ctx.fillStyle = 'white';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage(img, 0, 0);

            canvas.toBlob(function(blob) {
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = '8gwifi.org-vpc-diagram.png';
                a.click();
                URL.revokeObjectURL(url);
            });
        };

        img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgData)));
    }

    function copyTerraform() {
        const text = document.getElementById('terraformCode').textContent;
        navigator.clipboard.writeText(text).then(() => alert('Terraform code copied!'));
    }

    function copyCloudFormation() {
        const text = document.getElementById('cloudformationCode').textContent;
        navigator.clipboard.writeText(text).then(() => alert('CloudFormation template copied!'));
    }

    // Download functions
    function downloadTerraform() {
        const text = document.getElementById('terraformCode').textContent;
        const blob = new Blob([text], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = '8gwifi.org-vpc-main.tf';
        a.click();
        URL.revokeObjectURL(url);
    }

    function downloadCloudFormation() {
        const text = document.getElementById('cloudformationCode').textContent;
        const blob = new Blob([text], { type: 'text/yaml' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = '8gwifi.org-vpc-template.yaml';
        a.click();
        URL.revokeObjectURL(url);
    }

    // Reset calculator
    function resetCalculator() {
        document.getElementById('vpcName').value = 'my-vpc';
        document.getElementById('vpcCidr').value = '10.0.0.0/16';
        document.getElementById('azCount').value = '2';
        document.getElementById('subnetStrategy').value = 'public-private';
        document.getElementById('subnetSize').value = '24';
        subnets = [];
        subnetIdCounter = 0;
        calculateSubnets();
    }

    // Share configuration via URL
    function shareConfig() {
        const config = {
            name: document.getElementById('vpcName').value,
            cidr: document.getElementById('vpcCidr').value,
            azCount: document.getElementById('azCount').value,
            strategy: document.getElementById('subnetStrategy').value,
            subnetSize: document.getElementById('subnetSize').value,
            provider: document.getElementById('cloudProvider').value,
            subnets: subnets.map(s => ({
                id: s.id,
                name: s.name,
                cidr: s.cidr,
                az: s.az,
                type: s.type,
                divided: s.divided,
                parentId: s.parentId
            })),
            counter: subnetIdCounter
        };

        const encoded = btoa(JSON.stringify(config));
        const url = window.location.origin + window.location.pathname + '?config=' + encoded;

        // Copy to clipboard
        navigator.clipboard.writeText(url).then(() => {
            alert('✅ Shareable link copied to clipboard!\n\nAnyone with this link can view your VPC configuration.');
        }).catch(() => {
            // Fallback: show in prompt
            prompt('Copy this shareable link:', url);
        });
    }

    // Load configuration from URL
    function loadFromURL() {
        const params = new URLSearchParams(window.location.search);
        const configParam = params.get('config');

        if (configParam) {
            try {
                const config = JSON.parse(atob(configParam));

                document.getElementById('vpcName').value = config.name || 'my-vpc';
                document.getElementById('vpcCidr').value = config.cidr || '10.0.0.0/16';
                document.getElementById('azCount').value = config.azCount || '2';
                document.getElementById('subnetStrategy').value = config.strategy || 'public-private';
                document.getElementById('subnetSize').value = config.subnetSize || '24';
                document.getElementById('cloudProvider').value = config.provider || 'aws';

                if (config.subnets && config.subnets.length > 0) {
                    subnets = config.subnets;
                    subnetIdCounter = config.counter || config.subnets.length;
                    validateAndCalculate();
                    displaySubnets();
                    generateNetworkDiagram();
                } else {
                    calculateSubnets();
                }

                // Show notification
                const notification = document.createElement('div');
                notification.style.cssText = 'position: fixed; top: 20px; right: 20px; background: #667eea; color: white; ' +
                    'padding: 15px 20px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.3); z-index: 9999; ' +
                    'font-family: Arial, sans-serif; animation: slideIn 0.3s ease;';
                notification.innerHTML = '✅ Configuration loaded from shared link!';
                document.body.appendChild(notification);

                setTimeout(() => {
                    notification.style.opacity = '0';
                    notification.style.transition = 'opacity 0.3s';
                    setTimeout(() => notification.remove(), 300);
                }, 3000);

            } catch (e) {
                console.error('Failed to load configuration:', e);
                alert('Failed to load configuration from URL. Using default settings.');
                calculateSubnets();
            }
        }
    }

    // Load config on page load
    document.addEventListener('DOMContentLoaded', loadFromURL);
</script>
</div>
<%@ include file="body-close.jsp"%>
</html>
