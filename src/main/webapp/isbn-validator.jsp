<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
  <meta name="googlebot" content="index, follow">
  <meta name="language" content="English">
  <meta name="revisit-after" content="7 days">
  <meta name="author" content="8gwifi.org">
  <title>Free ISBN Validator Online - Check ISBN-10/ISBN-13 Format | ISBN Converter & Barcode Generator</title>
  <meta name="description" content="Free online ISBN validator and converter. Validate ISBN-10 and ISBN-13 numbers instantly, convert between formats, calculate check digits, generate EAN-13 barcodes. Check ISBN format and verify book identification numbers. No registration required.">
  <meta name="keywords" content="isbn validator, free isbn validator, online isbn validator, isbn checker, isbn converter, isbn-10 validator, isbn-13 validator, isbn format checker, isbn to ean, convert isbn, validate isbn, isbn check digit calculator, book isbn validator, isbn barcode generator, isbn to barcode, isbn-10 to isbn-13, isbn-13 to isbn-10, isbn lookup, verify isbn, check isbn number, isbn validator tool, isbn format validator">
  <link rel="canonical" href="https://8gwifi.org/isbn-validator.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/isbn-validator.jsp">
  <meta property="og:title" content="Free ISBN Validator Online - Check ISBN-10/ISBN-13 Format | ISBN Converter">
  <meta property="og:description" content="Validate and convert ISBN numbers instantly. Check ISBN-10 and ISBN-13 format, convert between formats, calculate check digits, and generate EAN-13 barcodes. Free online tool, no registration required.">
  <meta property="og:image" content="https://8gwifi.org/isbn-validator-og.jpg">
  <meta property="og:site_name" content="8gwifi.org">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/isbn-validator.jsp">
  <meta property="twitter:title" content="Free ISBN Validator Online - Check ISBN Format & Generate Barcodes">
  <meta property="twitter:description" content="Validate and convert ISBN-10 and ISBN-13 numbers instantly! Generate EAN-13 barcodes for books. Free online tool.">
  <meta property="twitter:image" content="https://8gwifi.org/isbn-validator-og.jpg">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Free ISBN Validator & Converter",
    "alternateName": "ISBN Checker | ISBN Format Validator | ISBN Converter | ISBN Barcode Generator | ISBN-10 to ISBN-13 Converter",
    "applicationCategory": "BusinessApplication",
    "applicationSubCategory": "UtilityApplication",
    "operatingSystem": "Any",
    "browserRequirements": "Requires JavaScript. Requires HTML5.",
    "softwareVersion": "1.0",
    "releaseNotes": "ISBN validator with format conversion, check digit calculation, and EAN-13 barcode generation for books.",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD",
      "availability": "https://schema.org/InStock",
      "url": "https://8gwifi.org/isbn-validator.jsp"
    },
    "description": "Free online ISBN (International Standard Book Number) validator and converter tool. Validate ISBN-10 and ISBN-13 format instantly, convert between formats, calculate check digits, generate EAN-13 barcodes for books, and verify book identification numbers. Features comprehensive format validation, automatic check digit calculation, format conversion (ISBN-10 ↔ ISBN-13), barcode generation, and detailed format explanations. Perfect for publishers, libraries, bookstores, and authors. No registration or software installation required.",
    "url": "https://8gwifi.org/isbn-validator.jsp",
    "screenshot": "https://8gwifi.org/isbn-validator-screenshot.jpg",
    "featureList": [
      "Validate ISBN-10 format (10 digits)",
      "Validate ISBN-13 format (13 digits)",
      "Convert ISBN-10 to ISBN-13",
      "Convert ISBN-13 to ISBN-10 (978 prefix only)",
      "Calculate check digits for both formats",
      "Format validation with error messages",
      "Check digit verification",
      "Generate EAN-13 barcodes from ISBN",
      "Download barcode as PNG or SVG",
      "Format ISBN with dashes for readability",
      "Comprehensive format explanations",
      "Sample ISBNs for testing",
      "Real-time validation",
      "No registration required",
      "Free to use",
      "Works on all devices",
      "Instant conversion results"
    ],
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
    "keywords": "isbn validator, free isbn validator, online isbn validator, isbn checker, isbn converter, validate isbn, isbn format, international standard book number, isbn barcode generator, isbn-10 to isbn-13, isbn-13 to isbn-10, book isbn validator",
    "inLanguage": "en-US",
    "isAccessibleForFree": true,
    "usageInfo": "Enter ISBN-10 or ISBN-13 number to validate format and check digit. Convert between formats or generate EAN-13 barcode. Download barcode as PNG or SVG.",
    "softwareHelp": {
      "@type": "CreativeWork",
      "text": "Supports ISBN-10 and ISBN-13 validation with automatic check digit calculation. Converts between formats and generates EAN-13 compatible barcodes for books. Perfect for publishers, libraries, and bookstores."
    },
    "audience": {
      "@type": "Audience",
      "audienceType": "Publishers, Librarians, Booksellers, Authors, Book Retailers, Library Systems"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <!-- JsBarcode Library -->
  <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>

  <style>
  :root {
    --isbn-primary: #8b5cf6;
    --isbn-secondary: #a78bfa;
    --isbn-accent: #7c3aed;
    --isbn-dark: #6d28d9;
    --isbn-light: #ede9fe;
  }

  body {
    background: #ffffff;
    min-height: 100vh;
  }

  .isbn-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 1rem;
  }

  .isbn-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 1rem;
  }

  .isbn-header {
    background: linear-gradient(135deg, var(--isbn-primary), var(--isbn-dark));
    color: white;
    padding: 1rem 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .isbn-header h1 {
    font-size: 1.75rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .isbn-header p {
    font-size: 0.9rem;
    margin: 0.25rem 0 0 0;
    opacity: 0.95;
  }

  .isbn-content {
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
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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
    border-color: var(--isbn-primary);
    box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
  }

  .action-buttons {
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
    margin-top: 0.75rem;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--isbn-primary), var(--isbn-dark));
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

  .action-btn.danger {
    background: linear-gradient(135deg, #ef4444, #dc2626);
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
    color: var(--isbn-dark);
    font-size: 1rem;
    margin-top: 0;
    margin-bottom: 0.75rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .isbn-display {
    font-family: 'Courier New', monospace;
    font-size: 1.3rem;
    font-weight: 700;
    color: var(--isbn-dark);
    background: var(--isbn-light);
    padding: 0.75rem;
    border-radius: 8px;
    text-align: center;
    margin: 0.5rem 0;
    word-break: break-all;
  }

  .isbn-info {
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
    color: var(--isbn-dark);
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
    background: var(--isbn-light);
    border-color: var(--isbn-primary);
    color: var(--isbn-dark);
    transform: translateY(-1px);
  }

  .doc-section {
    background: white;
    border-radius: 12px;
    padding: 1.5rem;
    margin-top: 1rem;
    border: 2px solid #e5e7eb;
  }

  .doc-section h3 {
    color: var(--isbn-dark);
    font-size: 1.3rem;
    margin-top: 0;
    margin-bottom: 1rem;
    padding-bottom: 0.5rem;
    border-bottom: 2px solid var(--isbn-light);
  }

  .doc-section h4 {
    color: var(--isbn-accent);
    font-size: 1.1rem;
    margin-top: 1.5rem;
    margin-bottom: 0.75rem;
  }

  .format-guide {
    background: #f9fafb;
    border-left: 4px solid var(--isbn-primary);
    padding: 1rem;
    margin: 1rem 0;
    border-radius: 4px;
  }

  @media (max-width: 1024px) {
    .results-section {
      grid-template-columns: 1fr;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>

<div class="isbn-container">
  <div class="isbn-card">
    <div class="isbn-header">
      <h1>📚 ISBN Validator & Converter 📚</h1>
      <p>Validate ISBN-10 and ISBN-13 numbers, convert between formats, and calculate check digits</p>
    </div>

    <div class="isbn-content">
      <div class="input-section">
        <div class="input-grid">
          <div class="input-group">
            <label>ISBN Number (to validate or convert)</label>
            <input type="text" id="isbnInput" placeholder="978-0-306-40615-7" oninput="detectISBNType()">
          </div>
          <div class="input-group">
            <label>Action</label>
            <select id="actionSelect">
              <option value="validate">Validate ISBN</option>
              <option value="convert">Convert Format</option>
              <option value="checkdigit">Calculate Check Digit</option>
            </select>
          </div>
        </div>

        <div class="sample-buttons">
          <span style="font-weight: 600; color: #6b7280; font-size: 0.85rem; margin-right: 0.5rem;">📋 Load Sample:</span>
          <button class="sample-btn" onclick="loadSample('9780306406157')">ISBN-13 Sample</button>
          <button class="sample-btn" onclick="loadSample('0306406152')">ISBN-10 Sample</button>
          <button class="sample-btn" onclick="loadSample('9780143007234')">ISBN-13 (with dashes)</button>
          <button class="sample-btn" onclick="loadSample('0-14-300723-4')">ISBN-10 (with dashes)</button>
        </div>

        <div class="action-buttons">
          <button class="action-btn" onclick="processISBN()">🔍 Process ISBN</button>
          <button class="action-btn secondary" onclick="convertISBN()">🔄 Convert Format</button>
          <button class="action-btn danger" onclick="clearAll()">🔄 Clear</button>
        </div>
      </div>

      <div class="results-section">
        <div class="result-panel">
          <h3>🔍 Validation Result</h3>
          <div id="validationResult"></div>
          <div id="isbnInfo" class="isbn-info" style="display: none;"></div>
        </div>

        <div class="result-panel">
          <h3>📋 ISBN Information & Barcode</h3>
          <div id="isbnDisplay" class="isbn-display" style="display: none;"></div>
          <div id="conversionResult" style="margin-top: 0.5rem;"></div>
          <div id="barcodeContainer" style="margin-top: 1rem; text-align: center; padding: 1rem; background: #f9fafb; border-radius: 8px; display: none;">
            <h4 style="font-size: 0.9rem; color: var(--isbn-dark); margin-bottom: 0.5rem;">📊 ISBN Barcode (EAN-13)</h4>
            <div id="isbnBarcode" style="min-height: 100px; display: flex; align-items: center; justify-content: center;"></div>
            <div class="action-buttons" style="margin-top: 0.5rem; justify-content: center;">
              <button class="action-btn secondary" onclick="downloadISBNBarcode('png')" id="downloadBarcodePng" style="padding: 0.5rem 1rem; font-size: 0.85rem;">📥 Download PNG</button>
              <button class="action-btn secondary" onclick="downloadISBNBarcode('svg')" id="downloadBarcodeSvg" style="padding: 0.5rem 1rem; font-size: 0.85rem;">📥 Download SVG</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="isbn-card" style="padding: 1.5rem; margin-top: 1rem;">
    <div class="doc-section" style="padding: 0; border: none; margin: 0;">
    <h3>📚 ISBN Format Explained</h3>
    
    <h4>📋 What is an ISBN?</h4>
    <p><strong>ISBN</strong> (International Standard Book Number) is a unique numeric commercial book identifier. Since 2007, ISBNs have been 13 digits long. Older books may have 10-digit ISBNs, which can be converted to ISBN-13 format.</p>

    <div class="format-guide">
      <h5>ISBN-13 Format</h5>
      <ul>
        <li><strong>Length:</strong> 13 digits</li>
        <li><strong>Structure:</strong> 978/979 (EAN prefix) + Group identifier + Publisher code + Title identifier + Check digit</li>
        <li><strong>Format:</strong> <code>978-0-306-40615-7</code> or <code>9780306406157</code></li>
        <li><strong>Check Digit:</strong> Calculated using modulo 10 algorithm</li>
        <li><strong>Usage:</strong> Standard since 2007, compatible with EAN-13 barcode</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>ISBN-10 Format</h5>
      <ul>
        <li><strong>Length:</strong> 10 digits (or 9 digits + X check digit)</li>
        <li><strong>Structure:</strong> Group identifier + Publisher code + Title identifier + Check digit</li>
        <li><strong>Format:</strong> <code>0-306-40615-2</code> or <code>0306406152</code></li>
        <li><strong>Check Digit:</strong> Calculated using modulo 11 algorithm (can be X for 10)</li>
        <li><strong>Usage:</strong> Legacy format, used before 2007</li>
      </ul>
    </div>

    <h4>🔄 Converting Between Formats</h4>
    <p><strong>ISBN-10 to ISBN-13:</strong></p>
    <ol>
      <li>Add prefix "978" to the beginning</li>
      <li>Remove the old check digit</li>
      <li>Calculate new check digit using ISBN-13 algorithm</li>
      <li>Append new check digit</li>
    </ol>
    <p><strong>ISBN-13 to ISBN-10:</strong></p>
    <ol>
      <li>Remove "978" prefix (if present)</li>
      <li>Remove the old check digit</li>
      <li>Calculate new check digit using ISBN-10 algorithm</li>
      <li>Append new check digit (may be X)</li>
    </ol>
    <p><strong>Note:</strong> Only ISBN-13 numbers starting with "978" can be converted to ISBN-10. ISBN-13 numbers starting with "979" cannot be converted.</p>

    <h4>🔢 Check Digit Calculation</h4>
    <p><strong>ISBN-13 Check Digit:</strong></p>
    <ol>
      <li>Multiply each digit by 1 or 3 (alternating, starting with 1)</li>
      <li>Sum all results</li>
      <li>Find remainder when divided by 10</li>
      <li>Check digit = 10 - remainder (if remainder is 0, check digit is 0)</li>
    </ol>
    <p><strong>ISBN-10 Check Digit:</strong></p>
    <ol>
      <li>Multiply each digit by its position (1-9)</li>
      <li>Sum all results</li>
      <li>Find remainder when divided by 11</li>
      <li>Check digit = 11 - remainder (if remainder is 0, check digit is 0; if remainder is 1, check digit is X)</li>
    </ol>

    <h4>✅ Validation Rules</h4>
    <ul>
      <li>ISBN-13: Must be exactly 13 digits</li>
      <li>ISBN-10: Must be exactly 10 characters (digits or X)</li>
      <li>Check digit must be valid</li>
      <li>ISBN-13 must start with 978 or 979</li>
      <li>Dashes are optional and ignored during validation</li>
    </ul>

    <h4>💡 Common Use Cases</h4>
    <ul>
      <li><strong>Book Identification:</strong> Unique identifier for books</li>
      <li><strong>Library Systems:</strong> Cataloging and inventory management</li>
      <li><strong>Retail:</strong> Product identification in bookstores</li>
      <li><strong>Publishing:</strong> Book registration and tracking</li>
      <li><strong>E-commerce:</strong> Product listings and search</li>
    </ul>
    </div>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
function normalizeISBN(isbn) {
  return isbn.replace(/[-\s]/g, '').toUpperCase();
}

function detectISBNType() {
  const input = document.getElementById('isbnInput').value;
  const normalized = normalizeISBN(input);
  
  if (normalized.length === 13) {
    document.getElementById('actionSelect').value = 'validate';
  } else if (normalized.length === 10) {
    document.getElementById('actionSelect').value = 'convert';
  }
}

function calculateISBN13CheckDigit(isbn) {
  const digits = isbn.substring(0, 12).split('').map(Number);
  let sum = 0;
  for (let i = 0; i < 12; i++) {
    sum += digits[i] * (i % 2 === 0 ? 1 : 3);
  }
  const remainder = sum % 10;
  return remainder === 0 ? 0 : 10 - remainder;
}

function calculateISBN10CheckDigit(isbn) {
  // Ensure we have exactly 9 digits for calculation
  const isbnDigits = normalizeISBN(isbn);
  if (isbnDigits.length < 9) {
    return null;
  }
  
  const digits = isbnDigits.substring(0, 9).split('').map(Number);
  let sum = 0;
  for (let i = 0; i < 9; i++) {
    sum += digits[i] * (i + 1);
  }
  const remainder = sum % 11;
  if (remainder === 0) return '0';
  if (remainder === 1) return 'X';
  return String(11 - remainder);
}

function validateISBN13(isbn) {
  const normalized = normalizeISBN(isbn);
  if (normalized.length !== 13 || !/^\d{13}$/.test(normalized)) {
    return { valid: false, error: 'ISBN-13 must be exactly 13 digits' };
  }
  
  if (!normalized.startsWith('978') && !normalized.startsWith('979')) {
    return { valid: false, error: 'ISBN-13 must start with 978 or 979' };
  }
  
  const checkDigit = calculateISBN13CheckDigit(normalized);
  const providedCheck = parseInt(normalized[12]);
  
  if (checkDigit !== providedCheck) {
    return { valid: false, error: `Invalid check digit. Expected ${checkDigit}, got ${providedCheck}` };
  }
  
  return { valid: true, isbn: normalized, type: 'ISBN-13', checkDigit };
}

function validateISBN10(isbn) {
  const normalized = normalizeISBN(isbn);
  if (normalized.length !== 10 || !/^[\dX]{10}$/.test(normalized)) {
    return { valid: false, error: 'ISBN-10 must be exactly 10 characters (digits or X)' };
  }
  
  const checkDigit = calculateISBN10CheckDigit(normalized);
  if (checkDigit === null) {
    return { valid: false, error: 'Error calculating check digit' };
  }
  
  const providedCheck = normalized[9].toUpperCase();
  
  if (checkDigit !== providedCheck) {
    return { valid: false, error: `Invalid check digit. Expected ${checkDigit}, got ${providedCheck}` };
  }
  
  return { valid: true, isbn: normalized, type: 'ISBN-10', checkDigit };
}

function convertISBN10To13(isbn10) {
  const normalized = normalizeISBN(isbn10);
  if (normalized.length !== 10) {
    return { error: 'Invalid ISBN-10 format' };
  }
  
  const isbn13 = '978' + normalized.substring(0, 9);
  const checkDigit = calculateISBN13CheckDigit(isbn13);
  return { isbn13: isbn13 + checkDigit, isbn10: normalized };
}

function convertISBN13To10(isbn13) {
  const normalized = normalizeISBN(isbn13);
  if (normalized.length !== 13 || !normalized.startsWith('978')) {
    return { error: 'Only ISBN-13 numbers starting with 978 can be converted to ISBN-10' };
  }
  
  const isbn10 = normalized.substring(3, 12);
  const checkDigit = calculateISBN10CheckDigit(isbn10);
  if (checkDigit === null) {
    return { error: 'Error calculating ISBN-10 check digit' };
  }
  return { isbn13: normalized, isbn10: isbn10 + checkDigit };
}

function formatISBN(isbn, type) {
  const normalized = normalizeISBN(isbn);
  if (type === 'ISBN-13') {
    return normalized.substring(0, 3) + '-' + 
           normalized.substring(3, 4) + '-' + 
           normalized.substring(4, 7) + '-' + 
           normalized.substring(7, 12) + '-' + 
           normalized.substring(12);
  } else {
    return normalized.substring(0, 1) + '-' + 
           normalized.substring(1, 4) + '-' + 
           normalized.substring(4, 9) + '-' + 
           normalized.substring(9);
  }
}

function processISBN() {
  const input = document.getElementById('isbnInput').value.trim();
  const action = document.getElementById('actionSelect').value;
  const validationResult = document.getElementById('validationResult');
  const isbnInfo = document.getElementById('isbnInfo');
  const isbnDisplay = document.getElementById('isbnDisplay');
  const conversionResult = document.getElementById('conversionResult');
  
  if (!input) {
    validationResult.innerHTML = '<div class="validation-result" style="background: #fef3c7; color: #92400e;">Enter an ISBN to process</div>';
    return;
  }
  
  const normalized = normalizeISBN(input);
  let result;
  
  if (normalized.length === 13) {
    result = validateISBN13(input);
  } else if (normalized.length === 10) {
    result = validateISBN10(input);
  } else {
    validationResult.innerHTML = `
      <div class="validation-result invalid">
        ✗ Invalid ISBN Length
      </div>
      <div style="padding: 0.75rem; color: #6b7280; font-size: 0.9rem;">
        ISBN must be 10 or 13 characters (excluding dashes)
      </div>
    `;
    return;
  }
  
  if (result.valid) {
    const formatted = formatISBN(result.isbn, result.type);
    
    validationResult.innerHTML = `
      <div class="validation-result valid">
        ✓ Valid ${result.type}
      </div>
    `;
    
    isbnDisplay.textContent = formatted;
    isbnDisplay.style.display = 'block';
    
    isbnInfo.innerHTML = `
      <div class="info-row">
        <span class="info-label">Type:</span>
        <span class="info-value">${result.type}</span>
      </div>
      <div class="info-row">
        <span class="info-label">Check Digit:</span>
        <span class="info-value">${result.checkDigit}</span>
      </div>
      <div class="info-row">
        <span class="info-label">Raw ISBN:</span>
        <span class="info-value">${result.isbn}</span>
      </div>
    `;
    isbnInfo.style.display = 'block';
    
    // Generate barcode for ISBN-13 (EAN-13 compatible)
    let isbnForBarcode = null;
    if (result.type === 'ISBN-13') {
      isbnForBarcode = result.isbn;
    } else if (result.type === 'ISBN-10') {
      // Convert to ISBN-13 for barcode
      const conversion = convertISBN10To13(result.isbn);
      if (!conversion.error) {
        isbnForBarcode = conversion.isbn13;
      }
    }
    
    if (isbnForBarcode) {
      generateISBNBarcode(isbnForBarcode);
    }
    
    // Show conversion if applicable
    if (action === 'convert' || action === 'checkdigit') {
      if (result.type === 'ISBN-10') {
        const conversion = convertISBN10To13(result.isbn);
        if (!conversion.error) {
          conversionResult.innerHTML = `
            <div style="margin-top: 0.5rem; padding: 0.75rem; background: #f0f9ff; border-radius: 6px;">
              <strong>Converted to ISBN-13:</strong><br>
              <code style="font-size: 1.1rem; font-weight: 700;">${formatISBN(conversion.isbn13, 'ISBN-13')}</code>
            </div>
          `;
        }
      } else if (result.type === 'ISBN-13' && result.isbn.startsWith('978')) {
        const conversion = convertISBN13To10(result.isbn);
        if (!conversion.error) {
          conversionResult.innerHTML = `
            <div style="margin-top: 0.5rem; padding: 0.75rem; background: #f0f9ff; border-radius: 6px;">
              <strong>Converted to ISBN-10:</strong><br>
              <code style="font-size: 1.1rem; font-weight: 700;">${formatISBN(conversion.isbn10, 'ISBN-10')}</code>
            </div>
          `;
        }
      }
    }
  } else {
    validationResult.innerHTML = `
      <div class="validation-result invalid">
        ✗ Invalid ${normalized.length === 13 ? 'ISBN-13' : 'ISBN-10'}
      </div>
      <div style="padding: 0.75rem; color: #6b7280; font-size: 0.9rem;">
        ${result.error}
      </div>
    `;
    isbnInfo.style.display = 'none';
    isbnDisplay.style.display = 'none';
    conversionResult.innerHTML = '';
  }
}

function convertISBN() {
  processISBN();
}

function loadSample(isbn) {
  document.getElementById('isbnInput').value = isbn;
  detectISBNType();
  processISBN();
}

function generateISBNBarcode(isbn13) {
  const barcodeContainer = document.getElementById('barcodeContainer');
  const barcodeDiv = document.getElementById('isbnBarcode');
  
  barcodeDiv.innerHTML = '';
  
  const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  svg.id = 'isbn-barcode-svg';
  
  try {
    JsBarcode(svg, isbn13, {
      format: 'EAN13',
      width: 2,
      height: 100,
      displayValue: true,
      fontSize: 16,
      margin: 10
    });
    
    barcodeDiv.appendChild(svg);
    barcodeContainer.style.display = 'block';
    document.getElementById('downloadBarcodePng').disabled = false;
    document.getElementById('downloadBarcodeSvg').disabled = false;
  } catch (error) {
    barcodeDiv.innerHTML = `<p style="color: #ef4444; font-size: 0.9rem;">Error generating barcode: ${error.message}</p>`;
    barcodeContainer.style.display = 'block';
  }
}

function downloadISBNBarcode(format) {
  const svg = document.getElementById('isbn-barcode-svg');
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
    a.download = `isbn-barcode.svg`;
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
        a.download = `isbn-barcode.png`;
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

function clearAll() {
  document.getElementById('isbnInput').value = '';
  document.getElementById('validationResult').innerHTML = '';
  document.getElementById('isbnInfo').style.display = 'none';
  document.getElementById('isbnDisplay').style.display = 'none';
  document.getElementById('conversionResult').innerHTML = '';
  document.getElementById('barcodeContainer').style.display = 'none';
  document.getElementById('downloadBarcodePng').disabled = true;
  document.getElementById('downloadBarcodeSvg').disabled = true;
}

  // Initialize
</script>

  <!-- E-E-A-T: Visible author/methodology/trust section -->
  <div class="isbn-card" style="padding: 1.5rem; margin-top: 1rem;">
    <div class="doc-section" style="padding: 0; border: none; margin: 0;">
      <h3>About This Tool & Methodology</h3>
      <p>This tool validates ISBNs using the official check‑digit rules. ISBN‑10 uses a modulo‑11 checksum (X represents 10). ISBN‑13 uses alternating weights 1 and 3 with a modulo‑10 checksum. Conversion applies the 978 prefix for ISBN‑10 → ISBN‑13 and recalculates the check digit. ISBN‑13 values beginning with 979 cannot be converted to ISBN‑10.</p>

      <div class="format-guide">
        <h5>Authorship & Review</h5>
        <ul>
          <li><strong>Author:</strong> 8gwifi.org engineering team</li>
          <li><strong>Reviewed by:</strong> Anish Nath (tools maintainer)</li>
          <li><strong>Last updated:</strong> 2025-11-19</li>
        </ul>
      </div>

      <div class="format-guide">
        <h5>Sources & References</h5>
        <ul>
          <li><a href="https://www.isbn-international.org/" rel="nofollow noopener" target="_blank">International ISBN Agency</a></li>
          <li><a href="https://www.iso.org/standard/84979.html" rel="nofollow noopener" target="_blank">ISO 2108:2017 — International Standard Book Number (ISBN)</a></li>
          <li><a href="https://en.wikipedia.org/wiki/International_Standard_Book_Number" rel="nofollow noopener" target="_blank">ISBN overview (reference)</a></li>
        </ul>
      </div>

      <div class="format-guide">
        <h5>Trust & Privacy</h5>
        <ul>
          <li>Validation and barcode generation run in your browser; no ISBNs are stored on our servers.</li>
          <li>Barcodes are generated client‑side via SVG/Canvas and can be downloaded as PNG or SVG.</li>
          <li>Questions or feedback? Reach us via <a href="contactus.jsp">Contact</a>.</li>
        </ul>
      </div>
    </div>
  </div>

  <!-- E-E-A-T JSON-LD for WebPage with author/reviewer/publisher -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebPage",
    "name": "ISBN Validator & Converter",
    "url": "https://8gwifi.org/isbn-validator.jsp",
    "dateModified": "2025-11-19",
    "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
    "reviewedBy": {"@type": "Person", "name": "Anish Nath"},
    "publisher": {"@type": "Organization", "name": "8gwifi.org"}
  }
  </script>

  <!-- Breadcrumbs to reinforce page context -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/"},
      {"@type": "ListItem", "position": 2, "name": "ISBN Validator", "item": "https://8gwifi.org/isbn-validator.jsp"}
    ]
  }
  </script>

    <%@ include file="thanks.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
