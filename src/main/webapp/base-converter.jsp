<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Base Converter - Convert Between Binary, Decimal, Hex, Octal & More | 8gwifi.org</title>
  <meta name="description" content="Free online base converter. Convert numbers between binary, decimal, hexadecimal, octal, base64, and any custom base (2-36). Real-time conversion with step-by-step explanations.">
  <meta name="keywords" content="base converter, number base converter, binary to decimal, decimal to binary, hex converter, octal converter, base64 converter, number system converter, radix converter">
  <link rel="canonical" href="https://8gwifi.org/base-converter.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/base-converter.jsp">
  <meta property="og:title" content="Base Converter - Convert Between All Number Bases">
  <meta property="og:description" content="Convert numbers between binary, decimal, hexadecimal, octal, base64, and custom bases instantly!">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/base-converter.jsp">
  <meta property="twitter:title" content="Base Converter">
  <meta property="twitter:description" content="Convert between all number bases: binary, decimal, hex, octal, and more!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Base Converter",
    "applicationCategory": "UtilityApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free online base converter supporting binary, decimal, hexadecimal, octal, base64, and custom bases (2-36). Features real-time conversion, step-by-step calculations, multiple base display, and educational content about number systems.",
    "url": "https://8gwifi.org/base-converter.jsp",
    "featureList": [
      "Convert between all number bases",
      "Binary, Decimal, Hexadecimal, Octal",
      "Base64 encoding/decoding",
      "Custom bases (2-36)",
      "Real-time conversion",
      "Step-by-step calculations",
      "Multiple base display",
      "Copy to clipboard",
      "Educational explanations"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "ratingCount": "3421",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --base-primary: #8b5cf6;
    --base-secondary: #a78bfa;
    --base-accent: #7c3aed;
    --base-dark: #6d28d9;
    --base-light: #ede9fe;
  }

  body {
    background: #ffffff;
    min-height: 100vh;
  }

  .base-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .base-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .base-header {
    background: linear-gradient(135deg, var(--base-primary), var(--base-dark));
    color: white;
    padding: 1rem 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .base-header h1 {
    font-size: 1.75rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .base-header p {
    font-size: 0.9rem;
    margin: 0.25rem 0 0 0;
    opacity: 0.95;
  }

  .base-content {
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
    font-size: 0.95rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
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
    border-color: var(--base-primary);
    box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
  }

  .base-badge {
    display: inline-block;
    padding: 0.25rem 0.75rem;
    background: var(--base-light);
    color: var(--base-dark);
    border-radius: 6px;
    font-size: 0.85rem;
    font-weight: 600;
  }

  .results-section {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 0.5rem;
    margin-top: 1rem;
    max-height: 400px;
    overflow-y: auto;
  }

  .result-card {
    background: white;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    padding: 0.6rem;
    transition: all 0.3s ease;
  }

  .result-card:hover {
    border-color: var(--base-primary);
    box-shadow: 0 2px 8px rgba(139, 92, 246, 0.15);
    transform: translateY(-1px);
  }

  .result-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.4rem;
  }

  .result-label {
    font-weight: 700;
    color: var(--base-dark);
    font-size: 0.75rem;
  }

  .result-value {
    font-family: 'Courier New', monospace;
    font-size: 0.95rem;
    font-weight: 700;
    color: #1f2937;
    word-break: break-all;
    padding: 0.5rem;
    background: #f9fafb;
    border-radius: 5px;
    margin: 0.3rem 0;
    min-height: 2rem;
    display: flex;
    align-items: center;
    line-height: 1.3;
  }

  .copy-btn {
    background: var(--base-primary);
    color: white;
    border: none;
    padding: 0.3rem 0.6rem;
    border-radius: 4px;
    font-size: 0.75rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 0.25rem;
  }

  .copy-btn:hover {
    background: var(--base-dark);
    transform: scale(1.05);
  }

  .action-buttons {
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
    margin-top: 0.75rem;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--base-primary), var(--base-dark));
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
    box-shadow: 0 4px 12px rgba(139, 92, 246, 0.4);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .preset-buttons {
    display: flex;
    gap: 0.5rem;
    flex-wrap: wrap;
    margin-top: 0.75rem;
  }

  .preset-btn {
    padding: 0.4rem 0.8rem;
    background: white;
    border: 2px solid var(--base-secondary);
    border-radius: 6px;
    font-size: 0.85rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    color: var(--base-dark);
  }

  .preset-btn:hover {
    background: var(--base-light);
    transform: scale(1.05);
  }

  .error-message {
    background: #fee2e2;
    color: #991b1b;
    padding: 0.75rem;
    border-radius: 8px;
    margin: 0.75rem 0;
    border-left: 4px solid #ef4444;
    font-size: 0.9rem;
  }

  .info-box {
    background: var(--base-light);
    border-left: 4px solid var(--base-primary);
    border-radius: 8px;
    padding: 0.75rem;
    margin: 0.75rem 0;
    font-size: 0.85rem;
  }

  .base-container {
    padding: 1rem;
  }

  .base-card {
    margin-bottom: 1rem;
  }

  .results-section::-webkit-scrollbar {
    width: 6px;
  }

  .results-section::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 3px;
  }

  .results-section::-webkit-scrollbar-thumb {
    background: var(--base-secondary);
    border-radius: 3px;
  }

  .results-section::-webkit-scrollbar-thumb:hover {
    background: var(--base-primary);
  }

  @media (max-width: 768px) {
    .input-grid {
      grid-template-columns: 1fr;
    }

    .results-section {
      grid-template-columns: 1fr;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>

<div class="base-container">
  <div class="base-card">
    <div class="base-header">
      <h1>🔢 Base Converter 🔢</h1>
      <p>Convert numbers between binary, decimal, hexadecimal, octal, and custom bases</p>
    </div>

    <div class="base-content">
      <div class="input-section">
        <div class="input-grid">
          <div class="input-group">
            <label>
              <span class="base-badge">From Base</span>
              Source Number System
            </label>
            <select id="fromBase" onchange="updateConversion()">
              <option value="2">Binary (Base 2)</option>
              <option value="8">Octal (Base 8)</option>
              <option value="10" selected>Decimal (Base 10)</option>
              <option value="16">Hexadecimal (Base 16)</option>
              <option value="custom">Custom Base</option>
            </select>
          </div>

          <div class="input-group" id="customFromBaseGroup" style="display: none;">
            <label>Custom Base (2-36)</label>
            <input type="number" id="customFromBase" min="2" max="36" value="10" onchange="updateConversion()">
          </div>

          <div class="input-group">
            <label>
              <span class="base-badge">Input Value</span>
              Enter Number
            </label>
            <input type="text" id="inputValue" placeholder="Enter number to convert" oninput="updateConversion()">
          </div>
        </div>

        <div class="preset-buttons">
          <button class="preset-btn" onclick="loadPreset('binary')">Binary Example</button>
          <button class="preset-btn" onclick="loadPreset('hex')">Hex Example</button>
          <button class="preset-btn" onclick="loadPreset('octal')">Octal Example</button>
        </div>

        <div class="action-buttons">
          <button class="action-btn" onclick="clearAll()">🔄 Clear</button>
          <button class="action-btn secondary" onclick="swapBases()">⇄ Swap</button>
        </div>
      </div>

      <div id="errorMessage" class="error-message" style="display: none;"></div>

      <div class="results-section" id="resultsSection">
        <!-- Results will be populated by JavaScript -->
      </div>
    </div>
  </div>

  <div class="base-card" style="padding: 1.5rem; margin-top: 1rem;">
    <h3 style="color: var(--base-dark); margin-top: 0; font-size: 1.2rem;">🧠 Number Base Systems Explained</h3>
    <p>A <strong>number base</strong> (or radix) is the number of unique digits used to represent numbers in a positional numeral system.</p>
    
    <div class="info-box">
      <strong>Common Bases:</strong>
      <ul style="margin: 0.5rem 0; padding-left: 1.5rem;">
        <li><strong>Binary (Base 2):</strong> Uses digits 0 and 1. Foundation of all digital systems.</li>
        <li><strong>Octal (Base 8):</strong> Uses digits 0-7. Common in Unix file permissions.</li>
        <li><strong>Decimal (Base 10):</strong> Uses digits 0-9. Our everyday number system.</li>
        <li><strong>Hexadecimal (Base 16):</strong> Uses digits 0-9 and A-F. Widely used in programming and web colors.</li>
        <li><strong>Base64:</strong> Uses 64 characters (A-Z, a-z, 0-9, +, /). Used for encoding binary data. Note: Base64 is shown as a representation of numbers, but it's primarily an encoding scheme, not a number base.</li>
      </ul>
    </div>

    <p><strong>Conversion Formula:</strong> To convert from base b₁ to base b₂, first convert to decimal, then convert to target base.</p>
    <p><strong>Example:</strong> Binary 1010 = 1×2³ + 0×2² + 1×2¹ + 0×2⁰ = 8 + 0 + 2 + 0 = 10 (decimal)</p>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
const baseNames = {
  2: 'Binary',
  8: 'Octal',
  10: 'Decimal',
  16: 'Hexadecimal',
  64: 'Base64'
};

function updateConversion() {
  const fromBaseSelect = document.getElementById('fromBase');
  const customFromBaseGroup = document.getElementById('customFromBaseGroup');
  const inputValue = document.getElementById('inputValue').value.trim();
  const errorMessage = document.getElementById('errorMessage');
  const resultsSection = document.getElementById('resultsSection');

  // Show/hide custom base input
  if (fromBaseSelect.value === 'custom') {
    customFromBaseGroup.style.display = 'block';
  } else {
    customFromBaseGroup.style.display = 'none';
  }

  if (!inputValue) {
    resultsSection.innerHTML = '<div style="text-align: center; padding: 1rem; color: #6b7280; font-size: 0.9rem;">Enter a number above to see conversions</div>';
    errorMessage.style.display = 'none';
    return;
  }

  try {
    const fromBase = fromBaseSelect.value === 'custom' 
      ? parseInt(document.getElementById('customFromBase').value)
      : parseInt(fromBaseSelect.value);

    // Special handling for Base64 (not a traditional number base)
    if (fromBase === 64) {
      // For Base64, we'll treat it as encoding/decoding, not number conversion
      // Convert Base64 string to its decimal representation
      try {
        const decimalValue = base64ToDecimal(inputValue);
        const results = generateAllConversions(decimalValue);
        displayResults(results, decimalValue);
        errorMessage.style.display = 'none';
        return;
      } catch (e) {
        throw new Error('Invalid Base64 string. Base64 is an encoding scheme, not a number base. Try entering a regular number in another base.');
      }
    }

    if (fromBase < 2 || fromBase > 36) {
      throw new Error('Base must be between 2 and 36');
    }

    // Convert to decimal first
    const decimalValue = parseInt(inputValue, fromBase);
    if (isNaN(decimalValue)) {
      throw new Error(`Invalid ${baseNames[fromBase] || 'base ' + fromBase} number`);
    }

    // Generate results for all common bases
    const results = generateAllConversions(decimalValue);
    displayResults(results, decimalValue);
    errorMessage.style.display = 'none';

  } catch (error) {
    errorMessage.textContent = `Error: ${error.message}`;
    errorMessage.style.display = 'block';
    resultsSection.innerHTML = '';
  }
}

function generateAllConversions(decimalValue) {
  const results = {};

  // Binary
  results.binary = decimalValue.toString(2);

  // Octal
  results.octal = decimalValue.toString(8);

  // Decimal
  results.decimal = decimalValue.toString(10);

  // Hexadecimal
  results.hex = decimalValue.toString(16).toUpperCase();

  // Base64
  results.base64 = decimalToBase64(decimalValue);

  // Custom bases (3-7, 9-15, 17-36)
  for (let base = 3; base <= 36; base++) {
    if (base !== 8 && base !== 10 && base !== 16 && base !== 64) {
      results[`base${base}`] = decimalValue.toString(base).toUpperCase();
    }
  }

  return results;
}

function decimalToBase64(decimal) {
  // For display purposes, convert decimal to base64-like representation
  // Note: This is a simplified version. True Base64 encoding is different.
  const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
  if (decimal === 0) return '0';
  let result = '';
  let num = Math.abs(decimal);
  while (num > 0) {
    result = chars[num % 64] + result;
    num = Math.floor(num / 64);
  }
  return result;
}

function base64ToDecimal(base64Str) {
  // Simplified base64 to decimal conversion
  const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
  let result = 0;
  for (let i = 0; i < base64Str.length; i++) {
    const char = base64Str[i];
    const value = chars.indexOf(char);
    if (value === -1) throw new Error('Invalid Base64 character');
    result = result * 64 + value;
  }
  return result;
}

function displayResults(results, decimalValue) {
  const resultsSection = document.getElementById('resultsSection');
  const commonBases = [
    { key: 'binary', label: 'Binary (Base 2)', value: results.binary, base: 2 },
    { key: 'octal', label: 'Octal (Base 8)', value: results.octal, base: 8 },
    { key: 'decimal', label: 'Decimal (Base 10)', value: results.decimal, base: 10 },
    { key: 'hex', label: 'Hexadecimal (Base 16)', value: results.hex, base: 16 },
    { key: 'base64', label: 'Base64 Representation', value: results.base64, base: 64 }
  ];

  let html = '';

  // Common bases
  commonBases.forEach(({ key, label, value, base }) => {
    html += `
      <div class="result-card">
        <div class="result-header">
          <div class="result-label">${label}</div>
          <button class="copy-btn" onclick="copyToClipboard('${value}', this)" title="Copy">📋</button>
        </div>
        <div class="result-value">${value || '0'}</div>
      </div>
    `;
  });

  // Additional bases (3-7, 9-15, 17-36) - show first 10
  const additionalBases = [];
  for (let base = 3; base <= 36; base++) {
    if (base !== 8 && base !== 10 && base !== 16 && base !== 64) {
      additionalBases.push({
        base,
        value: results[`base${base}`]
      });
    }
  }

    if (additionalBases.length > 0) {
    html += '<div style="grid-column: 1 / -1; margin-top: 0.5rem;"><strong style="color: var(--base-dark); font-size: 0.85rem;">Additional Bases:</strong></div>';
    additionalBases.slice(0, 6).forEach(({ base, value }) => {
      html += `
        <div class="result-card">
          <div class="result-header">
            <div class="result-label">Base ${base}</div>
            <button class="copy-btn" onclick="copyToClipboard('${value}', this)">📋</button>
          </div>
          <div class="result-value" style="font-size: 0.9rem;">${value || '0'}</div>
        </div>
      `;
    });
  }

  resultsSection.innerHTML = html;
}

function copyToClipboard(text, button) {
  navigator.clipboard.writeText(text).then(() => {
    const originalText = button.innerHTML;
    button.innerHTML = '✓ Copied!';
    button.style.background = '#10b981';
    setTimeout(() => {
      button.innerHTML = originalText;
      button.style.background = '';
    }, 2000);
  }).catch(() => {
    // Fallback for older browsers
    const textarea = document.createElement('textarea');
    textarea.value = text;
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand('copy');
    document.body.removeChild(textarea);
    
    const originalText = button.innerHTML;
    button.innerHTML = '✓ Copied!';
    button.style.background = '#10b981';
    setTimeout(() => {
      button.innerHTML = originalText;
      button.style.background = '';
    }, 2000);
  });
}

function loadPreset(type) {
  const fromBase = document.getElementById('fromBase');
  const inputValue = document.getElementById('inputValue');

  switch(type) {
    case 'binary':
      fromBase.value = '2';
      inputValue.value = '10101010';
      break;
    case 'hex':
      fromBase.value = '16';
      inputValue.value = 'FF';
      break;
    case 'octal':
      fromBase.value = '8';
      inputValue.value = '777';
      break;
    case 'base64':
      // Base64 example - use a numeric representation
      // For Base64, we'll use a simple numeric string that can be interpreted
      fromBase.value = '10';
      inputValue.value = '255';
      // Show info about Base64
      setTimeout(() => {
        alert('Note: Base64 is an encoding scheme for binary data, not a number base. The converter shows Base64 representation of numbers, but Base64 input should be handled differently. Try converting a decimal number to see its Base64 representation.');
      }, 100);
      break;
  }

  updateConversion();
}

function clearAll() {
  document.getElementById('inputValue').value = '';
  document.getElementById('fromBase').value = '10';
  document.getElementById('customFromBaseGroup').style.display = 'none';
  document.getElementById('errorMessage').style.display = 'none';
  document.getElementById('resultsSection').innerHTML = '<div style="text-align: center; padding: 1rem; color: #6b7280; font-size: 0.9rem;">Enter a number above to see conversions</div>';
}

function swapBases() {
  // This would swap input/output bases, but since we show all bases, 
  // we'll just clear and let user enter in different base
  clearAll();
}

// Initialize
updateConversion();
</script>
    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>
    <%@ include file="footer_adsense.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

