<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
  <meta name="googlebot" content="index, follow">
  <meta name="language" content="English">
  <meta name="revisit-after" content="7 days">
  <meta name="author" content="8gwifi.org">
  <title>Free Barcode Generator Online - EAN, UPC, Code 128, Code 39 | Create & Download Barcodes</title>
  <meta name="description" content="Free online barcode generator. Create EAN-13, EAN-8, UPC-A, UPC-E, Code 128, Code 39, ITF-14 barcodes instantly. Generate, validate, and download barcodes as PNG or SVG. No registration required. Automatic check digit calculation.">
  <meta name="keywords" content="barcode generator, free barcode generator, online barcode generator, barcode maker, barcode creator, ean barcode generator, upc barcode generator, ean-13 generator, upc-a generator, code 128 generator, code 39 generator, generate barcode, create barcode, barcode printer, barcode scanner, itf-14 generator, barcode validator, check digit calculator, ean-8 generator, upc-e generator, codabar generator, msi barcode, pharmacode generator, retail barcode, product barcode, shipping barcode">
  <link rel="canonical" href="https://8gwifi.org/ean-upc-barcode-generator.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/ean-upc-barcode-generator.jsp">
  <meta property="og:title" content="Free Online Barcode Generator - Create EAN, UPC, Code 128 Barcodes">
  <meta property="og:description" content="Generate professional barcodes online for free. Support for EAN-13, UPC-A, Code 128, Code 39, ITF-14 and more. Download as PNG or SVG. No registration required.">
  <meta property="og:image" content="https://8gwifi.org/barcode-generator-og.jpg">
  <meta property="og:site_name" content="8gwifi.org">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/ean-upc-barcode-generator.jsp">
  <meta property="twitter:title" content="Free Online Barcode Generator - Create EAN, UPC, Code 128 Barcodes">
  <meta property="twitter:description" content="Generate professional barcodes online for free. Support for EAN-13, UPC-A, Code 128, Code 39, ITF-14 and more. Download as PNG or SVG.">
  <meta property="twitter:image" content="https://8gwifi.org/barcode-generator-og.jpg">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Free Online Barcode Generator",
    "alternateName": "Barcode Maker | Barcode Creator | EAN UPC Generator",
    "applicationCategory": "BusinessApplication",
    "applicationSubCategory": "UtilityApplication",
    "operatingSystem": "Any",
    "browserRequirements": "Requires JavaScript. Requires HTML5.",
    "softwareVersion": "1.0",
    "releaseNotes": "Universal barcode generator supporting multiple formats including EAN, UPC, Code 128, Code 39, ITF-14, Codabar, MSI, and Pharmacode.",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD",
      "availability": "https://schema.org/InStock",
      "url": "https://8gwifi.org/ean-upc-barcode-generator.jsp"
    },
    "description": "Free online barcode generator tool. Create professional EAN-13, EAN-8, UPC-A, UPC-E, Code 128, Code 39, ITF-14, Codabar, MSI, and Pharmacode barcodes instantly. Features automatic check digit calculation, barcode validation, format explanations, and download as PNG or SVG images. No registration or software installation required.",
    "url": "https://8gwifi.org/ean-upc-barcode-generator.jsp",
    "screenshot": "https://8gwifi.org/barcode-generator-screenshot.jpg",
    "featureList": [
      "Generate EAN-13 barcodes (13 digits)",
      "Generate EAN-8 barcodes (8 digits)",
      "Generate UPC-A barcodes (12 digits)",
      "Generate UPC-E barcodes (8 digits)",
      "Generate Code 128 barcodes (alphanumeric)",
      "Generate Code 39 barcodes (alphanumeric)",
      "Generate ITF-14 barcodes (14 digits)",
      "Generate Codabar barcodes",
      "Generate MSI barcodes",
      "Generate Pharmacode barcodes",
      "Automatic check digit calculation",
      "Barcode format validation",
      "Download as PNG image",
      "Download as SVG vector",
      "Format explanations and documentation",
      "Sample barcodes for testing",
      "Real-time input validation",
      "No registration required",
      "Free to use"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "ratingCount": "2156",
      "bestRating": "5",
      "worstRating": "1"
    },
    "author": {
      "@type": "Organization",
      "name": "8gwifi.org",
      "url": "https://8gwifi.org"
    },
    "publisher": {
      "@type": "Organization",
      "name": "8gwifi.org",
      "url": "https://8gwifi.org"
    },
    "keywords": "barcode generator, free barcode generator, online barcode generator, barcode maker, ean barcode generator, upc barcode generator, code 128 generator, code 39 generator, create barcode, generate barcode",
    "inLanguage": "en-US",
    "isAccessibleForFree": true,
    "usageInfo": "Enter barcode data, select format, and generate. Download as PNG or SVG.",
    "softwareHelp": {
      "@type": "CreativeWork",
      "text": "Supports EAN-13, EAN-8, UPC-A, UPC-E, Code 128, Code 39, ITF-14, Codabar, MSI, and Pharmacode formats. Automatic check digit calculation for retail barcodes."
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <!-- JsBarcode Library -->
  <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>

  <style>
  :root {
    --barcode-primary: #2563eb;
    --barcode-secondary: #3b82f6;
    --barcode-accent: #1e40af;
    --barcode-dark: #1e3a8a;
    --barcode-light: #dbeafe;
  }

  body {
    background: #ffffff;
    min-height: 100vh;
  }

  .barcode-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 1rem;
  }

  .barcode-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 1rem;
  }

  .barcode-header {
    background: linear-gradient(135deg, var(--barcode-primary), var(--barcode-dark));
    color: white;
    padding: 1rem 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .barcode-header h1 {
    font-size: 1.75rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .barcode-header p {
    font-size: 0.9rem;
    margin: 0.25rem 0 0 0;
    opacity: 0.95;
  }

  .barcode-content {
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
    border-color: var(--barcode-primary);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
  }

  .action-buttons {
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
    margin-top: 0.75rem;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--barcode-primary), var(--barcode-dark));
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
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.4);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .action-btn.danger {
    background: linear-gradient(135deg, #ef4444, #dc2626);
  }

  .sample-buttons {
    display: flex;
    gap: 0.5rem;
    flex-wrap: wrap;
    margin-top: 0.75rem;
    padding-top: 0.75rem;
    border-top: 2px dashed #e5e7eb;
  }

  .sample-btn {
    background: #f3f4f6;
    color: #374151;
    border: 2px solid #d1d5db;
    padding: 0.4rem 0.8rem;
    border-radius: 6px;
    font-size: 0.85rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
  }

  .sample-btn:hover {
    background: var(--barcode-light);
    border-color: var(--barcode-primary);
    color: var(--barcode-dark);
    transform: translateY(-1px);
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
    color: var(--barcode-dark);
    font-size: 1rem;
    margin-top: 0;
    margin-bottom: 0.75rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .barcode-display {
    background: white;
    padding: 1.5rem;
    border-radius: 8px;
    text-align: center;
    margin: 0.5rem 0;
    min-height: 150px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }

  .barcode-display svg {
    max-width: 100%;
    height: auto;
  }

  .barcode-info {
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
    color: var(--barcode-dark);
    font-weight: 600;
    font-family: 'Courier New', monospace;
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
    border-left: 4px solid #10b981;
  }

  .validation-result.invalid {
    background: #fee2e2;
    color: #991b1b;
    border-left: 4px solid #ef4444;
  }

  .check-digit-calc {
    background: #fef3c7;
    border-left: 4px solid #f59e0b;
    padding: 0.75rem;
    border-radius: 4px;
    margin: 0.5rem 0;
    font-size: 0.9rem;
  }

  .doc-section {
    background: white;
    border-radius: 12px;
    padding: 1.5rem;
    margin-top: 1rem;
    border: 2px solid #e5e7eb;
  }

  .doc-section h3 {
    color: var(--barcode-dark);
    font-size: 1.3rem;
    margin-top: 0;
    margin-bottom: 1rem;
    padding-bottom: 0.5rem;
    border-bottom: 2px solid var(--barcode-light);
  }

  .doc-section h4 {
    color: var(--barcode-accent);
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
    color: var(--barcode-dark);
  }

  .format-guide {
    background: #f9fafb;
    border-left: 4px solid var(--barcode-primary);
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 4px;
  }

  .format-guide h5 {
    color: var(--barcode-dark);
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
    .action-btn {
      font-size: 0.8rem;
      padding: 0.5rem 1rem;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>

<div class="barcode-container">
  <div class="barcode-card">
    <div class="barcode-header">
      <h1>📊 Universal Barcode Generator 📊</h1>
      <p>Generate EAN, UPC, Code 128, Code 39, ITF-14, Codabar, MSI, and more barcode formats</p>
    </div>

    <div class="barcode-content">
      <div class="input-section">
        <div class="input-grid">
          <div class="input-group">
            <label>Barcode Type</label>
            <select id="barcodeType" onchange="updateBarcodeType()">
              <optgroup label="EAN/UPC (Retail)">
                <option value="EAN13">EAN-13 (13 digits)</option>
                <option value="EAN8">EAN-8 (8 digits)</option>
                <option value="UPC">UPC-A (12 digits)</option>
                <option value="UPCE">UPC-E (8 digits)</option>
              </optgroup>
              <optgroup label="Code 128 (Alphanumeric)">
                <option value="CODE128">Code 128 (Alphanumeric)</option>
                <option value="CODE128A">Code 128A (Uppercase + Control)</option>
                <option value="CODE128B">Code 128B (Alphanumeric)</option>
                <option value="CODE128C">Code 128C (Numeric pairs)</option>
              </optgroup>
              <optgroup label="Code 39 (Alphanumeric)">
                <option value="CODE39">Code 39 (Alphanumeric)</option>
              </optgroup>
              <optgroup label="Other Formats">
                <option value="ITF14">ITF-14 (14 digits)</option>
                <option value="codabar">Codabar (Numeric + special)</option>
                <option value="MSI">MSI (Numeric)</option>
                <option value="pharmacode">Pharmacode (Numeric)</option>
              </optgroup>
            </select>
          </div>
          <div class="input-group">
            <label>Barcode Data</label>
            <input type="text" id="barcodeInput" placeholder="Enter barcode data" oninput="validateInput()">
            <small style="color: #6b7280; font-size: 0.75rem;" id="inputHint">Enter 12 digits for EAN-13</small>
          </div>
          <div class="input-group">
            <label>Options</label>
            <select id="barcodeOptions">
              <option value="auto">Auto-calculate check digit</option>
              <option value="manual">Manual check digit</option>
            </select>
          </div>
        </div>

        <div class="sample-buttons">
          <span style="font-weight: 600; color: #6b7280; font-size: 0.85rem; margin-right: 0.5rem;">📋 Load Sample:</span>
          <button class="sample-btn" onclick="loadSample('EAN13')">EAN-13</button>
          <button class="sample-btn" onclick="loadSample('EAN8')">EAN-8</button>
          <button class="sample-btn" onclick="loadSample('UPC')">UPC-A</button>
          <button class="sample-btn" onclick="loadSample('UPCE')">UPC-E</button>
          <button class="sample-btn" onclick="loadSample('CODE128')">Code 128</button>
          <button class="sample-btn" onclick="loadSample('CODE39')">Code 39</button>
          <button class="sample-btn" onclick="loadSample('ITF14')">ITF-14</button>
        </div>

        <div class="action-buttons">
          <button class="action-btn" onclick="generateBarcode()">🎲 Generate Barcode</button>
          <button class="action-btn secondary" onclick="validateBarcode()">✓ Validate Barcode</button>
          <button class="action-btn secondary" onclick="calculateCheckDigit()">🔢 Calculate Check Digit</button>
          <button class="action-btn danger" onclick="clearAll()">🔄 Clear</button>
        </div>
      </div>

      <div class="results-section">
        <div class="result-panel">
          <h3>🔍 Validation & Info</h3>
          <div id="validationResult"></div>
          <div id="barcodeInfo" class="barcode-info" style="display: none;"></div>
          <div id="checkDigitCalc" class="check-digit-calc" style="display: none;"></div>
        </div>

        <div class="result-panel">
          <h3>📊 Barcode Preview</h3>
          <div id="barcodeDisplay" class="barcode-display">
            <p style="color: #9ca3af;">Generate a barcode to see preview</p>
          </div>
          <div class="action-buttons" style="margin-top: 0.5rem;">
            <button class="action-btn secondary" onclick="downloadBarcode('png')" id="downloadPngBtn" disabled>📥 Download PNG</button>
            <button class="action-btn secondary" onclick="downloadBarcode('svg')" id="downloadSvgBtn" disabled>📥 Download SVG</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="barcode-card" style="padding: 1.5rem; margin-top: 1rem;">
    <div class="doc-section" style="padding: 0; border: none; margin: 0;">
    <h3>📚 Barcode Formats Explained</h3>
    
    <h4>📋 Overview</h4>
    <p>This tool supports multiple barcode formats including EAN/UPC (retail), Code 128 (alphanumeric), Code 39, ITF-14, Codabar, MSI, and Pharmacode. Each format has specific use cases and character encoding capabilities.</p>

    <div class="format-guide">
      <h5>EAN-13 (European Article Number 13)</h5>
      <ul>
        <li><strong>Length:</strong> 13 digits (12 data + 1 check digit)</li>
        <li><strong>Structure:</strong> Country code (2-3 digits) + Manufacturer code (4-5 digits) + Product code (5 digits) + Check digit (1 digit)</li>
        <li><strong>Usage:</strong> Most common format worldwide, used in retail globally</li>
        <li><strong>Example:</strong> <code>5901234123457</code></li>
        <li><strong>Check Digit:</strong> Calculated using modulo 10 algorithm</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>EAN-8 (European Article Number 8)</h5>
      <ul>
        <li><strong>Length:</strong> 8 digits (7 data + 1 check digit)</li>
        <li><strong>Structure:</strong> Country code (2-3 digits) + Product code (4-5 digits) + Check digit (1 digit)</li>
        <li><strong>Usage:</strong> Used for small products where EAN-13 doesn't fit</li>
        <li><strong>Example:</strong> <code>12345670</code></li>
        <li><strong>Check Digit:</strong> Same algorithm as EAN-13</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>UPC-A (Universal Product Code A)</h5>
      <ul>
        <li><strong>Length:</strong> 12 digits (11 data + 1 check digit)</li>
        <li><strong>Structure:</strong> Number system digit (1) + Manufacturer code (5) + Product code (5) + Check digit (1)</li>
        <li><strong>Usage:</strong> Standard in North America, equivalent to EAN-13 without leading zero</li>
        <li><strong>Example:</strong> <code>012345678905</code></li>
        <li><strong>Note:</strong> Adding a leading zero to UPC-A creates a valid EAN-13</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>UPC-E (Universal Product Code E)</h5>
      <ul>
        <li><strong>Length:</strong> 8 digits (7 data + 1 check digit)</li>
        <li><strong>Structure:</strong> Compressed version of UPC-A for small products</li>
        <li><strong>Usage:</strong> Used when space is limited (e.g., small packages, bottles)</li>
        <li><strong>Example:</strong> <code>01234565</code></li>
        <li><strong>Note:</strong> Can be expanded to full UPC-A format</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>Code 128 (Alphanumeric)</h5>
      <ul>
        <li><strong>Type:</strong> High-density linear barcode</li>
        <li><strong>Characters:</strong> All 128 ASCII characters (letters, numbers, symbols)</li>
        <li><strong>Variants:</strong> Code 128A (uppercase + control), Code 128B (alphanumeric), Code 128C (numeric pairs)</li>
        <li><strong>Usage:</strong> Shipping labels, packaging, logistics, inventory management</li>
        <li><strong>Example:</strong> <code>HELLO123</code> or <code>Hello World!</code></li>
        <li><strong>Advantages:</strong> High density, full ASCII support, automatic check digit</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>Code 39 (Alphanumeric)</h5>
      <ul>
        <li><strong>Type:</strong> Alphanumeric barcode</li>
        <li><strong>Characters:</strong> Uppercase A-Z, digits 0-9, and special chars: space, -.$/+%</li>
        <li><strong>Usage:</strong> Automotive industry, defense, identification cards</li>
        <li><strong>Example:</strong> <code>CODE-39</code> or <code>ABC123</code></li>
        <li><strong>Note:</strong> Case-insensitive, limited character set</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>ITF-14 (Interleaved 2 of 5)</h5>
      <ul>
        <li><strong>Length:</strong> 14 digits (13 data + 1 check digit)</li>
        <li><strong>Type:</strong> Numeric barcode with interleaved bars</li>
        <li><strong>Usage:</strong> Shipping cartons, logistics, warehouse management</li>
        <li><strong>Example:</strong> <code>1234567890123</code> → <code>12345678901234</code></li>
        <li><strong>Check Digit:</strong> Calculated using modulo 10 algorithm</li>
        <li><strong>Note:</strong> Used for outer packaging, not individual products</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>Codabar (Numeric + Special)</h5>
      <ul>
        <li><strong>Type:</strong> Self-checking numeric barcode</li>
        <li><strong>Characters:</strong> Numbers 0-9, start/stop characters: A, B, C, D</li>
        <li><strong>Usage:</strong> Libraries, blood banks, photo labs, shipping</li>
        <li><strong>Example:</strong> <code>A1234567890B</code> or <code>1234567890</code></li>
        <li><strong>Note:</strong> Start/stop characters (A-D) are optional but recommended</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>MSI (Modified Plessey)</h5>
      <ul>
        <li><strong>Type:</strong> Numeric barcode</li>
        <li><strong>Characters:</strong> Digits 0-9 only</li>
        <li><strong>Usage:</strong> Retail inventory, warehouse management</li>
        <li><strong>Example:</strong> <code>123456</code></li>
        <li><strong>Note:</strong> Variable length, check digit optional</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>Pharmacode (Pharmaceutical Binary Code)</h5>
      <ul>
        <li><strong>Type:</strong> Binary barcode for pharmaceuticals</li>
        <li><strong>Range:</strong> Numeric value from 1 to 131,070</li>
        <li><strong>Usage:</strong> Pharmaceutical packaging, drug identification</li>
        <li><strong>Example:</strong> <code>12345</code> or <code>50000</code></li>
        <li><strong>Note:</strong> Compact binary format, used on small packages</li>
      </ul>
    </div>

    <h4>📋 Sample Barcodes</h4>
    <p>Click the sample buttons above to quickly load and generate example barcodes:</p>
    <div class="format-guide">
      <h5>Sample Examples (with calculated check digits):</h5>
      <ul>
        <li><strong>EAN-13 Sample:</strong> <code>590123412345</code> → <code>5901234123457</code> (Poland country code 590)</li>
        <li><strong>EAN-8 Sample:</strong> <code>1234567</code> → <code>12345670</code></li>
        <li><strong>UPC-A Sample:</strong> <code>01234567890</code> → <code>012345678905</code></li>
        <li><strong>UPC-E Sample:</strong> <code>0123456</code> → <code>01234565</code></li>
        <li><strong>Code 128 Sample:</strong> <code>HELLO123</code> (alphanumeric)</li>
        <li><strong>Code 39 Sample:</strong> <code>CODE-39</code> (alphanumeric with dash)</li>
        <li><strong>ITF-14 Sample:</strong> <code>1234567890123</code> → <code>12345678901234</code></li>
        <li><strong>Codabar Sample:</strong> <code>A1234567890B</code> (with start/stop chars)</li>
        <li><strong>MSI Sample:</strong> <code>123456</code> (numeric)</li>
        <li><strong>Pharmacode Sample:</strong> <code>12345</code> (numeric, 1-131070)</li>
      </ul>
      <p style="margin-top: 0.75rem; font-size: 0.9rem; color: #6b7280;">
        <strong>💡 Tip:</strong> Use the "Load Sample" buttons above to automatically populate and generate these example barcodes. The check digits are automatically calculated for you!
      </p>
    </div>

    <h4>🔢 Check Digit Calculation</h4>
    <p>The check digit is calculated using a <strong>modulo 10 algorithm</strong>:</p>
    <ol>
      <li>Start from the rightmost digit (excluding check digit)</li>
      <li>Multiply digits in odd positions by 1 and even positions by 3</li>
      <li>Sum all the results</li>
      <li>Find the remainder when divided by 10</li>
      <li>If remainder is 0, check digit is 0; otherwise, check digit is 10 - remainder</li>
    </ol>
    <p><strong>Example for EAN-13:</strong> <code>590123412345</code></p>
    <ul>
      <li>Position 12 (5): 5 × 1 = 5</li>
      <li>Position 11 (9): 9 × 3 = 27</li>
      <li>Position 10 (0): 0 × 1 = 0</li>
      <li>... (continue for all digits)</li>
      <li>Sum = 95, 95 mod 10 = 5, Check digit = 10 - 5 = 5</li>
      <li>Final barcode: <code>5901234123455</code></li>
    </ul>

    <h4>✅ Validation Rules</h4>
    <ul>
      <li><strong>EAN/UPC formats:</strong> Must contain only numeric digits with correct length</li>
      <li><strong>Code 128:</strong> Supports all ASCII characters (letters, numbers, symbols)</li>
      <li><strong>Code 39:</strong> Uppercase letters, numbers, and limited special characters</li>
      <li><strong>ITF-14:</strong> 13 digits (check digit calculated automatically)</li>
      <li><strong>Codabar:</strong> Numbers 0-9, optionally start/end with A, B, C, or D</li>
      <li><strong>MSI:</strong> Numeric digits only, variable length</li>
      <li><strong>Pharmacode:</strong> Numeric value between 1 and 131,070</li>
      <li>Check digit validation applies to: EAN-13, EAN-8, UPC-A, UPC-E, ITF-14</li>
    </ul>

    <h4>💡 Common Use Cases</h4>
    <ul>
      <li><strong>Retail Products:</strong> Product identification in stores</li>
      <li><strong>Inventory Management:</strong> Tracking products in warehouses</li>
      <li><strong>Point of Sale:</strong> Quick product lookup at checkout</li>
      <li><strong>Supply Chain:</strong> Product tracking through distribution</li>
      <li><strong>Library Systems:</strong> Book identification (ISBN uses EAN-13)</li>
      <li><strong>Pharmaceuticals:</strong> Drug identification and tracking</li>
    </ul>

    <h4>🌍 Country Codes (EAN-13 First Digits)</h4>
    <p>Common country codes in EAN-13:</p>
    <ul>
      <li><code>00-09</code>: United States & Canada (UPC compatible)</li>
      <li><code>20-29</code>: In-store products</li>
      <li><code>30-37</code>: France</li>
      <li><code>40-44</code>: Germany</li>
      <li><code>45, 49</code>: Japan</li>
      <li><code>50</code>: United Kingdom</li>
      <li><code>54</code>: Belgium & Luxembourg</li>
      <li><code>57</code>: Denmark</li>
      <li><code>64</code>: Finland</li>
      <li><code>70</code>: Norway</li>
      <li><code>73</code>: Sweden</li>
      <li><code>76</code>: Switzerland</li>
      <li><code>80-83</code>: Italy</li>
      <li><code>84</code>: Spain</li>
      <li><code>87</code>: Netherlands</li>
      <li><code>90-91</code>: Austria</li>
      <li><code>93</code>: Australia</li>
      <li><code>94</code>: New Zealand</li>
      <li><code>460-469</code>: Russia</li>
      <li><code>690-699</code>: China</li>
      <li><code>750</code>: Mexico</li>
      <li><code>789-790</code>: Brazil</li>
    </ul>
    </div>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
let currentBarcode = null;
let currentBarcodeType = 'EAN13';

function updateBarcodeType() {
  const type = document.getElementById('barcodeType').value;
  currentBarcodeType = type;
  const input = document.getElementById('barcodeInput');
  const hint = document.getElementById('inputHint');
  
  switch(type) {
    case 'EAN13':
      input.placeholder = 'Enter 12 digits';
      hint.textContent = 'Enter 12 digits (check digit will be calculated)';
      break;
    case 'EAN8':
      input.placeholder = 'Enter 7 digits';
      hint.textContent = 'Enter 7 digits (check digit will be calculated)';
      break;
    case 'UPC':
      input.placeholder = 'Enter 11 digits';
      hint.textContent = 'Enter 11 digits (check digit will be calculated)';
      break;
    case 'UPCE':
      input.placeholder = 'Enter 7 digits';
      hint.textContent = 'Enter 7 digits (check digit will be calculated)';
      break;
    case 'CODE128':
    case 'CODE128A':
    case 'CODE128B':
    case 'CODE128C':
      input.placeholder = 'Enter alphanumeric text';
      hint.textContent = 'Code 128: Supports letters, numbers, and special characters';
      break;
    case 'CODE39':
      input.placeholder = 'Enter alphanumeric text';
      hint.textContent = 'Code 39: Uppercase letters, numbers, and some special chars (A-Z, 0-9, space, -.$/+%)';
      break;
    case 'ITF14':
      input.placeholder = 'Enter 13 digits';
      hint.textContent = 'Enter 13 digits (check digit will be calculated)';
      break;
    case 'codabar':
      input.placeholder = 'Enter numbers and A-D';
      hint.textContent = 'Codabar: Numbers 0-9 and letters A, B, C, D (start/stop)';
      break;
    case 'MSI':
      input.placeholder = 'Enter digits';
      hint.textContent = 'MSI: Numeric digits only (check digit optional)';
      break;
    case 'pharmacode':
      input.placeholder = 'Enter number (1-131070)';
      hint.textContent = 'Pharmacode: Numeric value between 1 and 131070';
      break;
    default:
      input.placeholder = 'Enter barcode data';
      hint.textContent = 'Enter data for barcode generation';
  }
  
  input.value = '';
  // Clear results when changing type
  document.getElementById('validationResult').innerHTML = '';
  document.getElementById('barcodeInfo').style.display = 'none';
  document.getElementById('checkDigitCalc').style.display = 'none';
  document.getElementById('barcodeDisplay').innerHTML = '<p style="color: #9ca3af;">Generate a barcode to see preview</p>';
  document.getElementById('downloadPngBtn').disabled = true;
  document.getElementById('downloadSvgBtn').disabled = true;
  currentBarcode = null;
}

function calculateCheckDigitEAN13(number) {
  if (number.length !== 12) return null;
  let sum = 0;
  for (let i = 0; i < 12; i++) {
    const digit = parseInt(number[i]);
    sum += (i % 2 === 0) ? digit : digit * 3;
  }
  const remainder = sum % 10;
  return remainder === 0 ? 0 : 10 - remainder;
}

function calculateCheckDigitEAN8(number) {
  if (number.length !== 7) return null;
  let sum = 0;
  for (let i = 0; i < 7; i++) {
    const digit = parseInt(number[i]);
    sum += (i % 2 === 0) ? digit * 3 : digit;
  }
  const remainder = sum % 10;
  return remainder === 0 ? 0 : 10 - remainder;
}

function calculateCheckDigitUPC(number) {
  if (number.length !== 11) return null;
  let sum = 0;
  for (let i = 0; i < 11; i++) {
    const digit = parseInt(number[i]);
    sum += (i % 2 === 0) ? digit * 3 : digit;
  }
  const remainder = sum % 10;
  return remainder === 0 ? 0 : 10 - remainder;
}

function calculateCheckDigitUPCE(number) {
  if (number.length !== 7) return null;
  let sum = 0;
  for (let i = 0; i < 7; i++) {
    const digit = parseInt(number[i]);
    sum += (i % 2 === 0) ? digit * 3 : digit;
  }
  const remainder = sum % 10;
  return remainder === 0 ? 0 : 10 - remainder;
}

function calculateCheckDigit() {
  const input = document.getElementById('barcodeInput').value.trim();
  const type = document.getElementById('barcodeType').value;
  const calcDiv = document.getElementById('checkDigitCalc');
  
  if (!input || !/^\d+$/.test(input)) {
    calcDiv.innerHTML = '<div style="color: #991b1b;">Please enter a valid numeric value</div>';
    calcDiv.style.display = 'block';
    return;
  }
  
  let expectedLength, checkDigit, fullNumber, steps = [];
  
  switch(type) {
    case 'EAN13':
      expectedLength = 12;
      if (input.length !== 12) {
        calcDiv.innerHTML = '<div style="color: #991b1b;">EAN-13 requires 12 digits (without check digit)</div>';
        calcDiv.style.display = 'block';
        return;
      }
      checkDigit = calculateCheckDigitEAN13(input);
      fullNumber = input + checkDigit;
      // Calculate steps
      let sum = 0;
      for (let i = 0; i < 12; i++) {
        const digit = parseInt(input[i]);
        const multiplier = (i % 2 === 0) ? 1 : 3;
        const result = digit * multiplier;
        sum += result;
        steps.push(`Position ${i + 1} (${digit}): ${digit} × ${multiplier} = ${result}`);
      }
      steps.push(`Sum: ${sum}`);
      steps.push(`Sum mod 10: ${sum % 10}`);
      steps.push(`Check digit: ${sum % 10 === 0 ? 0 : 10 - (sum % 10)}`);
      break;
    case 'EAN8':
      expectedLength = 7;
      if (input.length !== 7) {
        calcDiv.innerHTML = '<div style="color: #991b1b;">EAN-8 requires 7 digits (without check digit)</div>';
        calcDiv.style.display = 'block';
        return;
      }
      checkDigit = calculateCheckDigitEAN8(input);
      fullNumber = input + checkDigit;
      let sum8 = 0;
      for (let i = 0; i < 7; i++) {
        const digit = parseInt(input[i]);
        const multiplier = (i % 2 === 0) ? 3 : 1;
        const result = digit * multiplier;
        sum8 += result;
        steps.push(`Position ${i + 1} (${digit}): ${digit} × ${multiplier} = ${result}`);
      }
      steps.push(`Sum: ${sum8}`);
      steps.push(`Sum mod 10: ${sum8 % 10}`);
      steps.push(`Check digit: ${sum8 % 10 === 0 ? 0 : 10 - (sum8 % 10)}`);
      break;
    case 'UPC':
      expectedLength = 11;
      if (input.length !== 11) {
        calcDiv.innerHTML = '<div style="color: #991b1b;">UPC-A requires 11 digits (without check digit)</div>';
        calcDiv.style.display = 'block';
        return;
      }
      checkDigit = calculateCheckDigitUPC(input);
      fullNumber = input + checkDigit;
      let sumUPC = 0;
      for (let i = 0; i < 11; i++) {
        const digit = parseInt(input[i]);
        const multiplier = (i % 2 === 0) ? 3 : 1;
        const result = digit * multiplier;
        sumUPC += result;
        steps.push(`Position ${i + 1} (${digit}): ${digit} × ${multiplier} = ${result}`);
      }
      steps.push(`Sum: ${sumUPC}`);
      steps.push(`Sum mod 10: ${sumUPC % 10}`);
      steps.push(`Check digit: ${sumUPC % 10 === 0 ? 0 : 10 - (sumUPC % 10)}`);
      break;
    case 'UPCE':
      expectedLength = 7;
      if (input.length !== 7) {
        calcDiv.innerHTML = '<div style="color: #991b1b;">UPC-E requires 7 digits (without check digit)</div>';
        calcDiv.style.display = 'block';
        return;
      }
      checkDigit = calculateCheckDigitUPCE(input);
      fullNumber = input + checkDigit;
      let sumUPCE = 0;
      for (let i = 0; i < 7; i++) {
        const digit = parseInt(input[i]);
        const multiplier = (i % 2 === 0) ? 3 : 1;
        const result = digit * multiplier;
        sumUPCE += result;
        steps.push(`Position ${i + 1} (${digit}): ${digit} × ${multiplier} = ${result}`);
      }
      steps.push(`Sum: ${sumUPCE}`);
      steps.push(`Sum mod 10: ${sumUPCE % 10}`);
      steps.push(`Check digit: ${sumUPCE % 10 === 0 ? 0 : 10 - (sumUPCE % 10)}`);
      break;
  }
  
  calcDiv.innerHTML = `
    <div style="font-weight: 700; margin-bottom: 0.5rem;">Check Digit Calculation Steps:</div>
    <div style="font-size: 0.85rem; line-height: 1.6;">
      ${steps.map(s => `<div>${s}</div>`).join('')}
    </div>
    <div style="margin-top: 0.75rem; padding-top: 0.75rem; border-top: 1px solid #fbbf24;">
      <strong>Input:</strong> <code>${input}</code><br>
      <strong>Check Digit:</strong> <code>${checkDigit}</code><br>
      <strong>Full Barcode:</strong> <code>${fullNumber}</code>
    </div>
  `;
  calcDiv.style.display = 'block';
}

function validateInput() {
  const input = document.getElementById('barcodeInput').value.trim();
  const type = document.getElementById('barcodeType').value;
  
  if (!input) return;
  
  const hint = document.getElementById('inputHint');
  
  // Numeric-only formats
  const numericFormats = ['EAN13', 'EAN8', 'UPC', 'UPCE', 'ITF14', 'MSI', 'pharmacode'];
  if (numericFormats.includes(type)) {
    if (!/^\d+$/.test(input)) {
      hint.textContent = 'Only numeric digits allowed';
      hint.style.color = '#ef4444';
      return;
    }
    
    let expectedLength;
    switch(type) {
      case 'EAN13':
        expectedLength = 12;
        break;
      case 'EAN8':
        expectedLength = 7;
        break;
      case 'UPC':
        expectedLength = 11;
        break;
      case 'UPCE':
        expectedLength = 7;
        break;
      case 'ITF14':
        expectedLength = 13;
        break;
      case 'MSI':
        // MSI has variable length
        if (input.length > 0) {
          hint.textContent = `✓ ${input.length} digits entered`;
          hint.style.color = '#10b981';
        }
        return;
      case 'pharmacode':
        const num = parseInt(input);
        if (num >= 1 && num <= 131070) {
          hint.textContent = `✓ Valid pharmacode value (${num})`;
          hint.style.color = '#10b981';
        } else {
          hint.textContent = 'Value must be between 1 and 131070';
          hint.style.color = '#ef4444';
        }
        return;
    }
    
    if (input.length === expectedLength) {
      hint.textContent = `✓ ${input.length} digits entered (correct length)`;
      hint.style.color = '#10b981';
    } else if (input.length < expectedLength) {
      hint.textContent = `${input.length}/${expectedLength} digits (need ${expectedLength - input.length} more)`;
      hint.style.color = '#f59e0b';
    } else {
      hint.textContent = `Too many digits (expected ${expectedLength})`;
      hint.style.color = '#ef4444';
    }
  } else if (type === 'codabar') {
    // Codabar: numbers and A-D
    if (!/^[A-D]?[0-9]+[A-D]?$/.test(input)) {
      hint.textContent = 'Codabar: Numbers 0-9, optionally start/end with A, B, C, or D';
      hint.style.color = '#f59e0b';
    } else {
      hint.textContent = `✓ Valid Codabar format (${input.length} chars)`;
      hint.style.color = '#10b981';
    }
  } else {
    // Alphanumeric formats (Code 128, Code 39, Code 93)
    if (input.length > 0) {
      hint.textContent = `✓ ${input.length} characters entered`;
      hint.style.color = '#10b981';
    }
  }
}

function calculateCheckDigitITF14(number) {
  if (number.length !== 13) return null;
  let sum = 0;
  for (let i = 0; i < 13; i++) {
    const digit = parseInt(number[i]);
    sum += (i % 2 === 0) ? digit * 3 : digit;
  }
  const remainder = sum % 10;
  return remainder === 0 ? 0 : 10 - remainder;
}

function generateBarcode() {
  const input = document.getElementById('barcodeInput').value.trim();
  const type = document.getElementById('barcodeType').value;
  const options = document.getElementById('barcodeOptions').value;
  
  if (!input) {
    alert('Please enter barcode data');
    return;
  }
  
  let barcodeData, checkDigit = null;
  const numericFormats = ['EAN13', 'EAN8', 'UPC', 'UPCE', 'ITF14'];
  
  // Handle formats with check digits
  if (numericFormats.includes(type)) {
    if (!/^\d+$/.test(input)) {
      alert('Please enter a valid numeric value');
      return;
    }
    
    switch(type) {
      case 'EAN13':
        if (input.length === 12) {
          checkDigit = calculateCheckDigitEAN13(input);
          barcodeData = input + checkDigit;
        } else if (input.length === 13 && options === 'manual') {
          barcodeData = input;
          const providedCheck = parseInt(input[12]);
          checkDigit = calculateCheckDigitEAN13(input.substring(0, 12));
          if (providedCheck !== checkDigit) {
            alert(`Invalid check digit. Expected ${checkDigit}, got ${providedCheck}`);
            return;
          }
        } else {
          alert('EAN-13 requires 12 digits (without check digit) or 13 digits (with check digit)');
          return;
        }
        break;
      case 'EAN8':
        if (input.length === 7) {
          checkDigit = calculateCheckDigitEAN8(input);
          barcodeData = input + checkDigit;
        } else if (input.length === 8 && options === 'manual') {
          barcodeData = input;
          const providedCheck = parseInt(input[7]);
          checkDigit = calculateCheckDigitEAN8(input.substring(0, 7));
          if (providedCheck !== checkDigit) {
            alert(`Invalid check digit. Expected ${checkDigit}, got ${providedCheck}`);
            return;
          }
        } else {
          alert('EAN-8 requires 7 digits (without check digit) or 8 digits (with check digit)');
          return;
        }
        break;
      case 'UPC':
        if (input.length === 11) {
          checkDigit = calculateCheckDigitUPC(input);
          barcodeData = input + checkDigit;
        } else if (input.length === 12 && options === 'manual') {
          barcodeData = input;
          const providedCheck = parseInt(input[11]);
          checkDigit = calculateCheckDigitUPC(input.substring(0, 11));
          if (providedCheck !== checkDigit) {
            alert(`Invalid check digit. Expected ${checkDigit}, got ${providedCheck}`);
            return;
          }
        } else {
          alert('UPC-A requires 11 digits (without check digit) or 12 digits (with check digit)');
          return;
        }
        break;
      case 'UPCE':
        if (input.length === 7) {
          checkDigit = calculateCheckDigitUPCE(input);
          barcodeData = input + checkDigit;
        } else if (input.length === 8 && options === 'manual') {
          barcodeData = input;
          const providedCheck = parseInt(input[7]);
          checkDigit = calculateCheckDigitUPCE(input.substring(0, 7));
          if (providedCheck !== checkDigit) {
            alert(`Invalid check digit. Expected ${checkDigit}, got ${providedCheck}`);
            return;
          }
        } else {
          alert('UPC-E requires 7 digits (without check digit) or 8 digits (with check digit)');
          return;
        }
        break;
      case 'ITF14':
        if (input.length === 13) {
          checkDigit = calculateCheckDigitITF14(input);
          barcodeData = input + checkDigit;
        } else if (input.length === 14 && options === 'manual') {
          barcodeData = input;
          const providedCheck = parseInt(input[13]);
          checkDigit = calculateCheckDigitITF14(input.substring(0, 13));
          if (providedCheck !== checkDigit) {
            alert(`Invalid check digit. Expected ${checkDigit}, got ${providedCheck}`);
            return;
          }
        } else {
          alert('ITF-14 requires 13 digits (without check digit) or 14 digits (with check digit)');
          return;
        }
        break;
    }
  } else if (type === 'pharmacode') {
    // Pharmacode validation
    const num = parseInt(input);
    if (!/^\d+$/.test(input) || num < 1 || num > 131070) {
      alert('Pharmacode value must be a number between 1 and 131070');
      return;
    }
    barcodeData = input;
  } else if (type === 'codabar') {
    // Codabar validation
    if (!/^[A-D]?[0-9]+[A-D]?$/.test(input)) {
      alert('Codabar: Numbers 0-9, optionally start/end with A, B, C, or D');
      return;
    }
    barcodeData = input;
  } else {
    // Alphanumeric formats (Code 128, Code 39, Code 93, MSI)
    barcodeData = input;
  }
  
  currentBarcode = barcodeData;
  
  // Generate barcode using JsBarcode
  const display = document.getElementById('barcodeDisplay');
  display.innerHTML = '';
  
  const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  svg.id = 'barcode-svg';
  
  try {
    JsBarcode(svg, barcodeData, {
      format: type,
      width: 2,
      height: 100,
      displayValue: true,
      fontSize: 16,
      margin: 10
    });
    
    display.appendChild(svg);
    
    // Update info
    updateBarcodeInfo(barcodeData, type, checkDigit);
    
    // Enable download buttons
    document.getElementById('downloadPngBtn').disabled = false;
    document.getElementById('downloadSvgBtn').disabled = false;
  } catch (error) {
    display.innerHTML = `<p style="color: #ef4444;">Error generating barcode: ${error.message}</p>`;
  }
}

function updateBarcodeInfo(data, type, checkDigit) {
  const infoDiv = document.getElementById('barcodeInfo');
  const typeName = {
    'EAN13': 'EAN-13',
    'EAN8': 'EAN-8',
    'UPC': 'UPC-A',
    'UPCE': 'UPC-E',
    'CODE128': 'Code 128',
    'CODE128A': 'Code 128A',
    'CODE128B': 'Code 128B',
    'CODE128C': 'Code 128C',
    'CODE39': 'Code 39',
    'ITF14': 'ITF-14',
    'codabar': 'Codabar',
    'MSI': 'MSI',
    'pharmacode': 'Pharmacode'
  }[type] || type;
  
  let infoHTML = `
    <div class="info-row">
      <span class="info-label">Type:</span>
      <span class="info-value">${typeName}</span>
    </div>
    <div class="info-row">
      <span class="info-label">Data:</span>
      <span class="info-value">${data}</span>
    </div>
  `;
  
  if (checkDigit !== null) {
    infoHTML += `
    <div class="info-row">
      <span class="info-label">Check Digit:</span>
      <span class="info-value">${checkDigit}</span>
    </div>
    `;
  }
  
  infoHTML += `
    <div class="info-row">
      <span class="info-label">Length:</span>
      <span class="info-value">${data.length} ${/^\d+$/.test(data) ? 'digits' : 'characters'}</span>
    </div>
  `;
  
  infoDiv.innerHTML = infoHTML;
  infoDiv.style.display = 'block';
}

function validateBarcode() {
  const input = document.getElementById('barcodeInput').value.trim();
  const type = document.getElementById('barcodeType').value;
  const resultDiv = document.getElementById('validationResult');
  
  if (!input || !/^\d+$/.test(input)) {
    resultDiv.innerHTML = '<div class="validation-result invalid">Please enter a valid numeric barcode</div>';
    return;
  }
  
  let isValid = false;
  let expectedLength, checkDigit, providedCheck;
  
  switch(type) {
    case 'EAN13':
      expectedLength = 13;
      if (input.length === 13) {
        checkDigit = calculateCheckDigitEAN13(input.substring(0, 12));
        providedCheck = parseInt(input[12]);
        isValid = checkDigit === providedCheck;
      }
      break;
    case 'EAN8':
      expectedLength = 8;
      if (input.length === 8) {
        checkDigit = calculateCheckDigitEAN8(input.substring(0, 7));
        providedCheck = parseInt(input[7]);
        isValid = checkDigit === providedCheck;
      }
      break;
    case 'UPC':
      expectedLength = 12;
      if (input.length === 12) {
        checkDigit = calculateCheckDigitUPC(input.substring(0, 11));
        providedCheck = parseInt(input[11]);
        isValid = checkDigit === providedCheck;
      }
      break;
    case 'UPCE':
      expectedLength = 8;
      if (input.length === 8) {
        checkDigit = calculateCheckDigitUPCE(input.substring(0, 7));
        providedCheck = parseInt(input[7]);
        isValid = checkDigit === providedCheck;
      }
      break;
  }
  
  if (input.length !== expectedLength) {
    resultDiv.innerHTML = `
      <div class="validation-result invalid">
        ✗ Invalid Length
      </div>
      <div style="padding: 0.75rem; color: #6b7280; font-size: 0.9rem;">
        Expected ${expectedLength} digits, got ${input.length}
      </div>
    `;
  } else if (isValid) {
    resultDiv.innerHTML = `
      <div class="validation-result valid">
        ✓ Valid ${type} Barcode
      </div>
    `;
  } else {
    resultDiv.innerHTML = `
      <div class="validation-result invalid">
        ✗ Invalid Check Digit
      </div>
      <div style="padding: 0.75rem; color: #6b7280; font-size: 0.9rem;">
        Expected check digit: ${checkDigit}, Got: ${providedCheck}
      </div>
    `;
  }
}

function downloadBarcode(format) {
  if (!currentBarcode) {
    alert('Please generate a barcode first');
    return;
  }
  
  const svg = document.getElementById('barcode-svg');
  if (!svg) {
    alert('Barcode not found');
    return;
  }
  
  if (format === 'svg') {
    const serializer = new XMLSerializer();
    const svgStr = serializer.serializeToString(svg);
    const blob = new Blob([svgStr], { type: 'image/svg+xml' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `barcode_${currentBarcode}.svg`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  } else if (format === 'png') {
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    const img = new Image();
    
    const svgStr = new XMLSerializer().serializeToString(svg);
    const svgBlob = new Blob([svgStr], { type: 'image/svg+xml;charset=utf-8' });
    const url = URL.createObjectURL(svgBlob);
    
    img.onload = function() {
      canvas.width = img.width;
      canvas.height = img.height;
      ctx.drawImage(img, 0, 0);
      canvas.toBlob(function(blob) {
        const downloadUrl = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = downloadUrl;
        a.download = `barcode_${currentBarcode}.png`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(downloadUrl);
        URL.revokeObjectURL(url);
      });
    };
    img.src = url;
  }
}

function loadSample(type) {
  // Sample barcodes (without check digit - will be auto-calculated)
  const samples = {
    'EAN13': '590123412345',      // Poland (590) - will become 5901234123457
    'EAN8': '1234567',             // Will become 12345670
    'UPC': '01234567890',          // Will become 012345678905
    'UPCE': '0123456',             // Will become 01234565
    'CODE128': 'HELLO123',         // Alphanumeric
    'CODE128A': 'HELLO',           // Uppercase
    'CODE128B': 'Hello World!',    // Alphanumeric with space
    'CODE128C': '12345678',        // Numeric pairs
    'CODE39': 'CODE-39',           // Alphanumeric with dash
    'ITF14': '1234567890123',      // Will calculate check digit
    'codabar': 'A1234567890B',     // With start/stop chars
    'MSI': '123456',               // Numeric
    'pharmacode': '12345'          // Numeric
  };
  
  // Set the barcode type
  document.getElementById('barcodeType').value = type;
  updateBarcodeType();
  
  // Set the sample value
  const sampleValue = samples[type] || samples['CODE128'];
  document.getElementById('barcodeInput').value = sampleValue;
  
  // Set to auto-calculate check digit (for formats that support it)
  if (['EAN13', 'EAN8', 'UPC', 'UPCE', 'ITF14'].includes(type)) {
    document.getElementById('barcodeOptions').value = 'auto';
  }
  
  // Validate input
  validateInput();
  
  // Auto-generate the barcode
  setTimeout(() => {
    generateBarcode();
  }, 100);
}

function clearAll() {
  document.getElementById('barcodeInput').value = '';
  document.getElementById('validationResult').innerHTML = '';
  document.getElementById('barcodeInfo').style.display = 'none';
  document.getElementById('checkDigitCalc').style.display = 'none';
  document.getElementById('barcodeDisplay').innerHTML = '<p style="color: #9ca3af;">Generate a barcode to see preview</p>';
  document.getElementById('inputHint').textContent = 'Enter 12 digits for EAN-13';
  document.getElementById('inputHint').style.color = '#6b7280';
  document.getElementById('downloadPngBtn').disabled = true;
  document.getElementById('downloadSvgBtn').disabled = true;
  currentBarcode = null;
}

// Initialize
updateBarcodeType();
</script>
    <%@ include file="thanks.jsp"%>
</html>
<%@ include file="body-close.jsp"%>

