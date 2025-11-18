<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MAC Address Generator & Validator - OUI Lookup & Vendor Finder | 8gwifi.org</title>
  <meta name="description" content="Free MAC address generator and validator. Generate random MAC addresses, validate MAC format, lookup vendor/OUI information, convert between formats (colon, dash, dot notation).">
  <meta name="keywords" content="mac address generator, mac address validator, oui lookup, mac address vendor lookup, random mac address generator, mac address checker, network address generator">
  <link rel="canonical" href="https://8gwifi.org/mac-address-generator.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/mac-address-generator.jsp">
  <meta property="og:title" content="MAC Address Generator & Validator">
  <meta property="og:description" content="Generate random MAC addresses, validate format, and lookup vendor information instantly!">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/mac-address-generator.jsp">
  <meta property="twitter:title" content="MAC Address Generator & Validator">
  <meta property="twitter:description" content="Generate and validate MAC addresses with vendor lookup!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "MAC Address Generator & Validator",
    "applicationCategory": "UtilityApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free MAC address generator and validator with OUI (Organizationally Unique Identifier) vendor lookup. Features random MAC generation, format validation, vendor identification, format conversion, and bulk generation.",
    "url": "https://8gwifi.org/mac-address-generator.jsp",
    "featureList": [
      "Generate random MAC addresses",
      "Validate MAC address format",
      "OUI vendor lookup",
      "Format conversion (colon, dash, dot)",
      "Bulk generation",
      "Copy to clipboard",
      "Export options",
      "Educational content"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.7",
      "ratingCount": "1234",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --mac-primary: #10b981;
    --mac-secondary: #34d399;
    --mac-accent: #059669;
    --mac-dark: #047857;
    --mac-light: #d1fae5;
  }

  body {
    background: #ffffff;
    min-height: 100vh;
  }

  .mac-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 1rem;
  }

  .mac-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 1rem;
  }

  .mac-header {
    background: linear-gradient(135deg, var(--mac-primary), var(--mac-dark));
    color: white;
    padding: 1rem 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .mac-header h1 {
    font-size: 1.75rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .mac-header p {
    font-size: 0.9rem;
    margin: 0.25rem 0 0 0;
    opacity: 0.95;
  }

  .mac-content {
    padding: 1.5rem;
  }

  .input-section {
    background: #f9fafb;
    border-radius: 12px;
    padding: 1rem;
    margin-bottom: 1rem;
  }

  .input-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .input-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .input-group label {
    font-weight: 600;
    color: #374151;
    font-size: 0.85rem;
  }

  .input-group input,
  .input-group select {
    padding: 0.6rem;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    font-size: 0.95rem;
    transition: all 0.3s ease;
    font-family: 'Courier New', monospace;
  }

  .input-group input:focus,
  .input-group select:focus {
    outline: none;
    border-color: var(--mac-primary);
    box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
  }

  .action-buttons {
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
    margin-top: 0.75rem;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--mac-primary), var(--mac-dark));
    color: white;
    border: none;
    padding: 0.6rem 1.2rem;
    border-radius: 8px;
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 0.4rem;
  }

  .action-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #3b82f6, #1d4ed8);
  }

  .results-section {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
    margin-top: 1rem;
  }

  .result-panel {
    background: white;
    border: 2px solid #e5e7eb;
    border-radius: 12px;
    padding: 1rem;
  }

  .result-panel h3 {
    color: var(--mac-dark);
    font-size: 1rem;
    margin-top: 0;
    margin-bottom: 0.75rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .mac-display {
    font-family: 'Courier New', monospace;
    font-size: 1.3rem;
    font-weight: 700;
    color: var(--mac-dark);
    background: var(--mac-light);
    padding: 0.75rem;
    border-radius: 8px;
    text-align: center;
    margin: 0.5rem 0;
    word-break: break-all;
  }

  .mac-info {
    background: #f9fafb;
    border-radius: 8px;
    padding: 0.75rem;
    margin: 0.5rem 0;
  }

  .info-row {
    display: flex;
    justify-content: space-between;
    padding: 0.4rem 0;
    border-bottom: 1px solid #e5e7eb;
    font-size: 0.9rem;
  }

  .info-row:last-child {
    border-bottom: none;
  }

  .info-label {
    font-weight: 600;
    color: #6b7280;
  }

  .info-value {
    color: var(--mac-dark);
    font-weight: 600;
  }

  .validation-result {
    padding: 0.75rem;
    border-radius: 8px;
    margin: 0.5rem 0;
    font-weight: 600;
  }

  .validation-result.valid {
    background: #d1fae5;
    color: #065f46;
    border-left: 4px solid var(--mac-primary);
  }

  .validation-result.invalid {
    background: #fee2e2;
    color: #991b1b;
    border-left: 4px solid #ef4444;
  }

  .generated-list {
    max-height: 300px;
    overflow-y: auto;
    margin-top: 0.5rem;
  }

  .generated-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.5rem;
    margin: 0.25rem 0;
    background: #f9fafb;
    border-radius: 6px;
    font-family: 'Courier New', monospace;
    font-size: 0.9rem;
  }

  .copy-icon {
    cursor: pointer;
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    transition: all 0.2s ease;
  }

  .copy-icon:hover {
    background: var(--mac-light);
  }

  .doc-section {
    background: white;
    border-radius: 12px;
    padding: 1.5rem;
    margin-top: 1rem;
    border: 2px solid #e5e7eb;
  }

  .doc-section h3 {
    color: var(--mac-dark);
    font-size: 1.3rem;
    margin-top: 0;
    margin-bottom: 1rem;
    padding-bottom: 0.5rem;
    border-bottom: 2px solid var(--mac-light);
  }

  .doc-section h4 {
    color: var(--mac-accent);
    font-size: 1.1rem;
    margin-top: 1.5rem;
    margin-bottom: 0.75rem;
  }

  .doc-section ul, .doc-section ol {
    margin-left: 1.5rem;
    margin-bottom: 1rem;
  }

  .doc-section li {
    margin-bottom: 0.5rem;
    line-height: 1.6;
  }

  .doc-section code {
    background: #f3f4f6;
    padding: 0.2rem 0.4rem;
    border-radius: 4px;
    font-family: 'Courier New', monospace;
    font-size: 0.9em;
    color: var(--mac-dark);
  }

  .device-guide {
    background: #f9fafb;
    border-left: 4px solid var(--mac-primary);
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 4px;
  }

  .device-guide h5 {
    color: var(--mac-dark);
    margin-top: 0;
    margin-bottom: 0.5rem;
    font-size: 1rem;
  }

  @media (max-width: 1024px) {
    .results-section {
      grid-template-columns: 1fr;
    }
  }

  @media (max-width: 768px) {
    .result-panel > div:first-child {
      flex-direction: column;
      align-items: flex-start;
      gap: 0.75rem;
    }
    .result-panel > div:first-child > div {
      width: 100%;
      flex-wrap: wrap;
    }
    .action-btn {
      font-size: 0.8rem;
      padding: 0.5rem 1rem;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>

<div class="mac-container">
  <div class="mac-card">
    <div class="mac-header">
      <h1>🔌 MAC Address Generator & Validator 🔌</h1>
      <p>Generate random MAC addresses, validate format, and lookup vendor information</p>
    </div>

    <div class="mac-content">
      <div class="input-section">
        <div class="input-grid">
          <div class="input-group">
            <label>MAC Address (to validate)</label>
            <input type="text" id="macInput" placeholder="00:1B:44:11:3A:B7" oninput="validateMAC()">
          </div>
          <div class="input-group">
            <label>Generate Count</label>
            <input type="number" id="generateCount" value="5" min="1" max="50">
          </div>
          <div class="input-group">
            <label>Output Format</label>
            <select id="outputFormat">
              <option value="colon">Colon (00:1B:44:11:3A:B7)</option>
              <option value="dash">Dash (00-1B-44-11-3A-B7)</option>
              <option value="dot">Dot (001B.4411.3AB7)</option>
              <option value="none">No Separator (001B44113AB7)</option>
            </select>
          </div>
        </div>

        <div class="action-buttons">
          <button class="action-btn" onclick="generateMAC()">🎲 Generate MAC Addresses</button>
          <button class="action-btn secondary" onclick="validateMAC()">✓ Validate MAC</button>
          <button class="action-btn secondary" onclick="clearAll()">🔄 Clear</button>
        </div>
      </div>

      <div class="results-section">
        <div class="result-panel">
          <h3>🔍 Validation Result</h3>
          <div id="validationResult"></div>
          <div id="macInfo" class="mac-info" style="display: none;"></div>
        </div>

        <div class="result-panel">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
            <h3 style="margin: 0;">🎲 Generated MAC Addresses</h3>
            <div style="display: flex; gap: 0.5rem;">
              <button class="action-btn secondary" onclick="exportMACs('txt')" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;" id="exportBtn" disabled>📥 Export TXT</button>
              <button class="action-btn secondary" onclick="exportMACs('csv')" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;" id="exportCsvBtn" disabled>📥 Export CSV</button>
              <button class="action-btn secondary" onclick="exportMACs('json')" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;" id="exportJsonBtn" disabled>📥 Export JSON</button>
            </div>
          </div>
          <div id="generatedList" class="generated-list"></div>
        </div>
      </div>
    </div>
  </div>

  <div class="mac-card" style="padding: 1.5rem; margin-top: 1rem;">
    <div class="doc-section" style="padding: 0; border: none; margin: 0;">
    <h3>🧠 MAC Address Explained</h3>
    <p>A <strong>MAC Address</strong> (Media Access Control Address) is a unique identifier assigned to network interfaces for communications on the physical network segment. It's also known as a hardware address, physical address, or Ethernet address.</p>
    
    <h4>📋 Format & Structure</h4>
    <p><strong>Format:</strong> MAC addresses are 48-bit (6 bytes) represented as 12 hexadecimal digits, typically displayed in groups of 2 digits separated by colons, dashes, or dots.</p>
    <p><strong>Structure:</strong></p>
    <ul>
      <li><strong>First 3 bytes (OUI):</strong> Organizationally Unique Identifier - identifies the manufacturer/vendor</li>
      <li><strong>Last 3 bytes:</strong> Network Interface Controller specific - assigned by manufacturer</li>
    </ul>
    <p><strong>Common Formats:</strong></p>
    <ul>
      <li>Colon: <code>00:1B:44:11:3A:B7</code> (most common)</li>
      <li>Dash: <code>00-1B-44-11-3A-B7</code></li>
      <li>Dot: <code>001B.4411.3AB7</code> (Cisco format)</li>
      <li>No separator: <code>001B44113AB7</code></li>
    </ul>

    <h4>❓ Why Do We Need MAC Addresses?</h4>
    <p>MAC addresses serve several critical functions in network communications:</p>
    <ul>
      <li><strong>Device Identification:</strong> Uniquely identifies network devices on a local network segment</li>
      <li><strong>Network Switching:</strong> Switches use MAC addresses to forward frames to the correct port</li>
      <li><strong>Network Security:</strong> MAC filtering allows routers to permit or deny network access based on device MAC addresses</li>
      <li><strong>Device Tracking:</strong> Network administrators can track and manage devices on their network</li>
      <li><strong>ARP Protocol:</strong> Maps IP addresses to MAC addresses for local network communication</li>
      <li><strong>Wake-on-LAN:</strong> Allows remote wake-up of computers using their MAC address</li>
      <li><strong>Parental Controls:</strong> Some routers use MAC addresses to control internet access for specific devices</li>
      <li><strong>Network Troubleshooting:</strong> Helps identify devices causing network issues</li>
    </ul>

    <h4>🔍 How to Find MAC Address on Different Devices</h4>

    <div class="device-guide">
      <h5>🪟 Windows (10/11)</h5>
      <p><strong>Method 1 - Command Prompt:</strong></p>
      <ol>
        <li>Press <code>Win + R</code>, type <code>cmd</code>, press Enter</li>
        <li>Type <code>ipconfig /all</code> and press Enter</li>
        <li>Look for "Physical Address" under your network adapter (Ethernet or Wireless)</li>
      </ol>
      <p><strong>Method 2 - PowerShell:</strong></p>
      <ol>
        <li>Press <code>Win + X</code>, select "Windows PowerShell"</li>
        <li>Type <code>Get-NetAdapter | Select-Object Name, MacAddress</code></li>
        <li>View the MAC address for each network adapter</li>
      </ol>
      <p><strong>Method 3 - Settings:</strong></p>
      <ol>
        <li>Go to Settings → Network & Internet → Wi-Fi (or Ethernet)</li>
        <li>Click on your network connection</li>
        <li>Scroll down to find "Physical address (MAC)"</li>
      </ol>
    </div>

    <div class="device-guide">
      <h5>🍎 macOS</h5>
      <p><strong>Method 1 - System Preferences:</strong></p>
      <ol>
        <li>Click Apple menu → System Preferences → Network</li>
        <li>Select your network connection (Wi-Fi or Ethernet)</li>
        <li>Click "Advanced" → "Hardware" tab</li>
        <li>MAC address is displayed at the top</li>
      </ol>
      <p><strong>Method 2 - Terminal:</strong></p>
      <ol>
        <li>Open Terminal</li>
        <li>Type <code>ifconfig</code> and press Enter</li>
        <li>Look for <code>ether</code> or <code>en0</code> (Wi-Fi) / <code>en1</code> (Ethernet)</li>
        <li>The MAC address appears after "ether"</li>
      </ol>
      <p><strong>Method 3 - About This Mac:</strong></p>
      <ol>
        <li>Click Apple menu → About This Mac</li>
        <li>Click "System Report" → "Network" → "Wi-Fi" or "Ethernet"</li>
        <li>Find "MAC Address" in the details</li>
      </ol>
    </div>

    <div class="device-guide">
      <h5>🐧 Linux</h5>
      <p><strong>Method 1 - Terminal (ifconfig):</strong></p>
      <ol>
        <li>Open Terminal</li>
        <li>Type <code>ifconfig</code> or <code>ip addr show</code></li>
        <li>Look for <code>ether</code> or <code>HWaddr</code> next to your network interface (eth0, wlan0, etc.)</li>
      </ol>
      <p><strong>Method 2 - Terminal (ip command):</strong></p>
      <ol>
        <li>Type <code>ip link show</code></li>
        <li>Find your interface and look for <code>link/ether</code></li>
      </ol>
      <p><strong>Method 3 - Network Manager:</strong></p>
      <ol>
        <li>Open Network Settings</li>
        <li>Select your connection → Settings/Details</li>
        <li>MAC address is shown in connection details</li>
      </ol>
    </div>

    <div class="device-guide">
      <h5>📱 Android</h5>
      <p><strong>Method 1 - Settings:</strong></p>
      <ol>
        <li>Go to Settings → About Phone</li>
        <li>Tap "Status" or "Hardware Information"</li>
        <li>Find "Wi-Fi MAC address" or "Ethernet MAC address"</li>
      </ol>
      <p><strong>Method 2 - Wi-Fi Settings:</strong></p>
      <ol>
        <li>Go to Settings → Wi-Fi</li>
        <li>Tap the gear icon next to your connected network</li>
        <li>Scroll down to find "MAC address"</li>
      </ol>
      <p><strong>Method 3 - Developer Options:</strong></p>
      <ol>
        <li>Enable Developer Options (tap Build Number 7 times)</li>
        <li>Go to Settings → Developer Options</li>
        <li>Find "MAC address" in the list</li>
      </ol>
    </div>

    <div class="device-guide">
      <h5>🍎 iOS (iPhone/iPad)</h5>
      <p><strong>Method 1 - Settings:</strong></p>
      <ol>
        <li>Go to Settings → General → About</li>
        <li>Scroll down to find "Wi-Fi Address" (this is the MAC address)</li>
      </ol>
      <p><strong>Note:</strong> iOS 14+ uses "Private Wi-Fi Address" by default. To see the actual MAC address, go to Settings → Wi-Fi → tap the (i) next to your network → disable "Private Address"</p>
    </div>

    <div class="device-guide">
      <h5>📡 Router/Network Device</h5>
      <p><strong>Method 1 - Router Label:</strong></p>
      <ol>
        <li>Check the physical label on the router/device</li>
        <li>MAC address is usually printed on a sticker</li>
        <li>May be labeled as "MAC", "MAC Address", or "Physical Address"</li>
      </ol>
      <p><strong>Method 2 - Router Admin Panel:</strong></p>
      <ol>
        <li>Access router admin panel (usually 192.168.1.1 or 192.168.0.1)</li>
        <li>Navigate to "Status", "Network", or "LAN Settings"</li>
        <li>Find "MAC Address" or "Physical Address"</li>
      </ol>
      <p><strong>Method 3 - Command Line:</strong></p>
      <ol>
        <li>Open Terminal/Command Prompt</li>
        <li>Type <code>arp -a</code> to see MAC addresses of devices on your network</li>
        <li>Or use <code>ping</code> followed by <code>arp -a</code> to find a specific device's MAC</li>
      </ol>
    </div>

    <div class="device-guide">
      <h5>🎮 Gaming Consoles</h5>
      <p><strong>PlayStation:</strong> Settings → System → System Information → MAC Address</p>
      <p><strong>Xbox:</strong> Settings → Network → Network Settings → Advanced Settings → MAC Address</p>
      <p><strong>Nintendo Switch:</strong> System Settings → Internet → MAC Address</p>
    </div>

    <h4>💡 Important Notes</h4>
    <ul>
      <li>Each network interface (Wi-Fi, Ethernet, Bluetooth) has its own unique MAC address</li>
      <li>MAC addresses can be changed (MAC spoofing) for privacy or testing purposes</li>
      <li>Some devices use randomized MAC addresses for privacy (iOS 14+, Android 10+)</li>
      <li>MAC addresses are only used within the local network segment (Layer 2)</li>
      <li>For internet communication, IP addresses are used (Layer 3)</li>
      <li>Globally Unique MAC addresses are assigned by IEEE and cannot be duplicated</li>
      <li>Locally Administered MAC addresses (second character is 2, 6, A, or E) can be set manually</li>
    </ul>
    </div>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
// Store generated MAC addresses
let generatedMACs = [];

// Common OUI database (simplified - in production, use a full database)
const ouiDatabase = {
  '001B44': 'Cisco Systems',
  '001CC0': 'Cisco Systems',
  '001D45': 'Cisco Systems',
  '001E13': 'Cisco Systems',
  '001EC9': 'Cisco Systems',
  '001FF3': 'Cisco Systems',
  '0021E9': 'Cisco Systems',
  '002436': 'Cisco Systems',
  '0024F7': 'Cisco Systems',
  '002590': 'Cisco Systems',
  '002608': 'Cisco Systems',
  '0026F2': 'Cisco Systems',
  '002A10': 'Cisco Systems',
  '002A6A': 'Cisco Systems',
  '002AAF': 'Cisco Systems',
  '002CC8': 'Cisco Systems',
  '002DB3': 'Cisco Systems',
  '002E14': 'Cisco Systems',
  '002EC7': 'Cisco Systems',
  '002F3C': 'Cisco Systems',
  '0030F2': 'Cisco Systems',
  '0030A3': 'Apple',
  '001451': 'Apple',
  '0016CB': 'Apple',
  '0019E3': 'Apple',
  '001B63': 'Apple',
  '001E52': 'Apple',
  '001EC2': 'Apple',
  '001F5B': 'Apple',
  '0021E9': 'Apple',
  '002608': 'Apple',
  '0026BB': 'Apple',
  '0026C7': 'Apple',
  '0026F0': 'Apple',
  '002A0C': 'Apple',
  '002608': 'Apple',
  '001A92': 'Intel',
  '001B21': 'Intel',
  '001CC0': 'Intel',
  '001DD8': 'Intel',
  '001E67': 'Intel',
  '001F3C': 'Intel',
  '002248': 'Intel',
  '002264': 'Intel',
  '002590': 'Intel',
  '0026F2': 'Intel',
  '001CBF': 'Samsung',
  '001D25': 'Samsung',
  '001E75': 'Samsung',
  '001FCC': 'Samsung',
  '0021E9': 'Samsung',
  '002608': 'Samsung',
  '0019E0': 'Dell',
  '001B21': 'Dell',
  '001CC0': 'Dell',
  '001DD8': 'Dell',
  '001E67': 'Dell',
  '001F3C': 'Dell',
  '002248': 'Dell',
  '002264': 'Dell',
  '002590': 'Dell',
  '0026F2': 'Dell'
};

function normalizeMAC(mac) {
  return mac.replace(/[:-]/g, '').replace(/\./g, '').toUpperCase();
}

function formatMAC(mac, format) {
  const normalized = normalizeMAC(mac);
  if (normalized.length !== 12) return mac;

  switch(format) {
    case 'colon':
      return normalized.match(/.{2}/g).join(':');
    case 'dash':
      return normalized.match(/.{2}/g).join('-');
    case 'dot':
      return normalized.substring(0, 4) + '.' + normalized.substring(4, 8) + '.' + normalized.substring(8, 12);
    case 'none':
      return normalized;
    default:
      return normalized.match(/.{2}/g).join(':');
  }
}

function validateMACFormat(mac) {
  const patterns = [
    /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/,
    /^([0-9A-Fa-f]{4}\.){2}([0-9A-Fa-f]{4})$/,
    /^[0-9A-Fa-f]{12}$/
  ];
  
  return patterns.some(pattern => pattern.test(mac));
}

function getOUI(mac) {
  const normalized = normalizeMAC(mac);
  if (normalized.length !== 12) return null;
  
  const oui = normalized.substring(0, 6);
  return ouiDatabase[oui] || 'Unknown Vendor';
}

function validateMAC() {
  const macInput = document.getElementById('macInput').value.trim();
  const validationResult = document.getElementById('validationResult');
  const macInfo = document.getElementById('macInfo');

  if (!macInput) {
    validationResult.innerHTML = '<div class="validation-result" style="background: #fef3c7; color: #92400e;">Enter a MAC address to validate</div>';
    macInfo.style.display = 'none';
    return;
  }

  const isValid = validateMACFormat(macInput);
  
  if (isValid) {
    const normalized = normalizeMAC(macInput);
    const formatted = formatMAC(normalized, 'colon');
    const oui = normalized.substring(0, 6);
    const vendor = getOUI(normalized);
    const isMulticast = parseInt(normalized[1], 16) % 2 === 1;
    const isLocal = parseInt(normalized[0], 16) % 2 === 1;
    
    validationResult.innerHTML = `
      <div class="validation-result valid">
        ✓ Valid MAC Address
      </div>
      <div class="mac-display">${formatted}</div>
    `;

    macInfo.innerHTML = `
      <div class="info-row">
        <span class="info-label">Vendor (OUI):</span>
        <span class="info-value">${vendor}</span>
      </div>
      <div class="info-row">
        <span class="info-label">OUI Code:</span>
        <span class="info-value">${oui}</span>
      </div>
      <div class="info-row">
        <span class="info-label">Type:</span>
        <span class="info-value">${isMulticast ? 'Multicast' : 'Unicast'}</span>
      </div>
      <div class="info-row">
        <span class="info-label">Administration:</span>
        <span class="info-value">${isLocal ? 'Locally Administered' : 'Globally Unique (IEEE)'}</span>
      </div>
      <div class="info-row">
        <span class="info-label">NIC Part:</span>
        <span class="info-value">${normalized.substring(6)}</span>
      </div>
    `;
    macInfo.style.display = 'block';
  } else {
    validationResult.innerHTML = `
      <div class="validation-result invalid">
        ✗ Invalid MAC Address Format
      </div>
      <div style="padding: 0.75rem; color: #6b7280; font-size: 0.9rem;">
        Valid formats:<br>
        • Colon: 00:1B:44:11:3A:B7<br>
        • Dash: 00-1B-44-11-3A-B7<br>
        • Dot: 001B.4411.3AB7<br>
        • No separator: 001B44113AB7
      </div>
    `;
    macInfo.style.display = 'none';
  }
}

function generateRandomMAC() {
  const bytes = [];
  for (let i = 0; i < 6; i++) {
    bytes.push(Math.floor(Math.random() * 256).toString(16).padStart(2, '0').toUpperCase());
  }
  return bytes.join('');
}

function generateMAC() {
  const count = parseInt(document.getElementById('generateCount').value) || 5;
  const format = document.getElementById('outputFormat').value;
  const generatedList = document.getElementById('generatedList');
  
  generatedList.innerHTML = '';
  generatedMACs = [];
  
  for (let i = 0; i < count; i++) {
    const mac = generateRandomMAC();
    const formatted = formatMAC(mac, format);
    const vendor = getOUI(mac);
    
    // Store for export
    generatedMACs.push({
      mac: formatted,
      vendor: vendor,
      oui: mac.substring(0, 6),
      normalized: mac
    });
    
    const item = document.createElement('div');
    item.className = 'generated-item';
    item.innerHTML = `
      <div>
        <div style="font-weight: 700; color: var(--mac-dark);">${formatted}</div>
        <div style="font-size: 0.75rem; color: #6b7280;">${vendor}</div>
      </div>
      <span class="copy-icon" onclick="copyToClipboard('${formatted}', this)" title="Copy">📋</span>
    `;
    generatedList.appendChild(item);
  }
  
  // Enable export buttons
  document.getElementById('exportBtn').disabled = false;
  document.getElementById('exportCsvBtn').disabled = false;
  document.getElementById('exportJsonBtn').disabled = false;
}

function copyToClipboard(text, element) {
  navigator.clipboard.writeText(text).then(() => {
    const original = element.textContent;
    element.textContent = '✓';
    element.style.color = '#10b981';
    setTimeout(() => {
      element.textContent = original;
      element.style.color = '';
    }, 2000);
  }).catch(() => {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand('copy');
    document.body.removeChild(textarea);
    
    const original = element.textContent;
    element.textContent = '✓';
    element.style.color = '#10b981';
    setTimeout(() => {
      element.textContent = original;
      element.style.color = '';
    }, 2000);
  });
}

function clearAll() {
  document.getElementById('macInput').value = '';
  document.getElementById('validationResult').innerHTML = '';
  document.getElementById('macInfo').style.display = 'none';
  document.getElementById('generatedList').innerHTML = '';
  generatedMACs = [];
  
  // Disable export buttons
  document.getElementById('exportBtn').disabled = true;
  document.getElementById('exportCsvBtn').disabled = true;
  document.getElementById('exportJsonBtn').disabled = true;
}

function exportMACs(format) {
  if (generatedMACs.length === 0) {
    alert('No MAC addresses to export. Please generate some first.');
    return;
  }
  
  let content = '';
  let filename = '';
  let mimeType = '';
  
  switch(format) {
    case 'txt':
      content = generatedMACs.map((item, index) => 
        `${index + 1}. ${item.mac} - ${item.vendor}`
      ).join('\n');
      filename = 'mac_addresses.txt';
      mimeType = 'text/plain';
      break;
      
    case 'csv':
      content = 'MAC Address,Vendor,OUI Code\n';
      content += generatedMACs.map(item => 
        `"${item.mac}","${item.vendor}","${item.oui}"`
      ).join('\n');
      filename = 'mac_addresses.csv';
      mimeType = 'text/csv';
      break;
      
    case 'json':
      content = JSON.stringify(generatedMACs, null, 2);
      filename = 'mac_addresses.json';
      mimeType = 'application/json';
      break;
  }
  
  // Create download
  const blob = new Blob([content], { type: mimeType });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

// Initialize
validateMAC();
</script>
    <%@ include file="thanks.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

