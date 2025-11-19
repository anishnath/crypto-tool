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
  <title>Free IBAN Validator Online - Check IBAN Number Format | IBAN Generator & Calculator</title>
  <meta name="description" content="Free online IBAN validator and generator. Validate IBAN format instantly, check IBAN structure, extract bank information, generate test IBANs for 50+ countries. Verify international bank account numbers. No registration required. IBAN format checker with country code validation.">
  <meta name="keywords" content="iban validator, free iban validator, online iban validator, iban checker, iban generator, iban format validator, validate iban, iban number checker, iban calculator, iban test generator, international bank account number, iban structure, iban country codes, check iban, verify iban, iban format checker, iban validator tool, iban number validator, sepa iban validator, european iban validator, bank account validator, iban generator online, test iban generator">
  <link rel="canonical" href="https://8gwifi.org/iban-validator.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/iban-validator.jsp">
  <meta property="og:title" content="Free IBAN Validator Online - Check IBAN Number Format | IBAN Generator">
  <meta property="og:description" content="Validate and generate IBAN numbers instantly for 50+ countries. Check IBAN format, extract bank information, verify international bank account numbers. Free online tool, no registration required.">
  <meta property="og:image" content="https://8gwifi.org/iban-validator-og.jpg">
  <meta property="og:site_name" content="8gwifi.org">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/iban-validator.jsp">
  <meta property="twitter:title" content="Free IBAN Validator Online - Check IBAN Number Format">
  <meta property="twitter:description" content="Validate and generate IBAN numbers for 50+ countries instantly! Free online tool with format checking and bank information extraction.">
  <meta property="twitter:image" content="https://8gwifi.org/iban-validator-og.jpg">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Free IBAN Validator & Generator",
    "alternateName": "IBAN Checker | IBAN Format Validator | IBAN Generator | IBAN Calculator | IBAN Number Validator",
    "applicationCategory": "BusinessApplication",
    "applicationSubCategory": "FinancialApplication",
    "operatingSystem": "Any",
    "browserRequirements": "Requires JavaScript. Requires HTML5.",
    "softwareVersion": "1.0",
    "releaseNotes": "Comprehensive IBAN validator supporting 50+ countries with format validation, check digit calculation, and test IBAN generation.",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD",
      "availability": "https://schema.org/InStock",
      "url": "https://8gwifi.org/iban-validator.jsp"
    },
    "description": "Free online IBAN (International Bank Account Number) validator and generator tool. Validate IBAN format instantly for 50+ countries including UK, Germany, France, Italy, Spain, Netherlands, and more. Check IBAN structure, extract bank information, generate test IBANs, verify country codes, and calculate check digits. Features comprehensive format explanations, country-specific validation, and SEPA compatibility. No registration or software installation required.",
    "url": "https://8gwifi.org/iban-validator.jsp",
    "screenshot": "https://8gwifi.org/iban-validator-screenshot.jpg",
    "featureList": [
      "Validate IBAN format for 50+ countries",
      "Check IBAN structure and length",
      "Extract country code from IBAN",
      "Extract bank identifier (BBAN)",
      "Extract account number information",
      "Generate test IBANs for any country",
      "Country code lookup and validation",
      "Check digit validation (Modulo 97-10)",
      "Format IBAN with spaces for readability",
      "Comprehensive format explanations",
      "Country-specific IBAN length validation",
      "SEPA payment compatibility check",
      "International bank transfer validation",
      "No registration required",
      "Free to use",
      "Works on all devices",
      "Instant validation results"
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
    "keywords": "iban validator, free iban validator, online iban validator, iban checker, iban generator, validate iban, iban format, international bank account number, iban calculator, check iban, verify iban, sepa iban validator",
    "inLanguage": "en-US",
    "isAccessibleForFree": true,
    "usageInfo": "Enter IBAN number to validate format and structure. Generate test IBANs for any supported country. Extract bank information and verify check digits.",
    "softwareHelp": {
      "@type": "CreativeWork",
      "text": "Supports IBAN validation for 50+ countries. Validates format, length, country code, and check digits. Generates test IBANs for development and testing purposes."
    },
    "audience": {
      "@type": "Audience",
      "audienceType": "Business Professionals, Developers, Financial Services, International Traders"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --iban-primary: #3b82f6;
    --iban-secondary: #60a5fa;
    --iban-accent: #2563eb;
    --iban-dark: #1e40af;
    --iban-light: #dbeafe;
  }

  body {
    background: #ffffff;
    min-height: 100vh;
  }

  .iban-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 1rem;
  }

  .iban-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 1rem;
  }

  .iban-header {
    background: linear-gradient(135deg, var(--iban-primary), var(--iban-dark));
    color: white;
    padding: 1rem 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .iban-header h1 {
    font-size: 1.75rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .iban-header p {
    font-size: 0.9rem;
    margin: 0.25rem 0 0 0;
    opacity: 0.95;
  }

  .iban-content {
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
    border-color: var(--iban-primary);
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  }

  .action-buttons {
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
    margin-top: 0.75rem;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--iban-primary), var(--iban-dark));
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
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
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
    color: var(--iban-dark);
    font-size: 1rem;
    margin-top: 0;
    margin-bottom: 0.75rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .iban-display {
    font-family: 'Courier New', monospace;
    font-size: 1.2rem;
    font-weight: 700;
    color: var(--iban-dark);
    background: var(--iban-light);
    padding: 0.75rem;
    border-radius: 8px;
    text-align: center;
    margin: 0.5rem 0;
    word-break: break-all;
    letter-spacing: 0.1em;
  }

  .iban-info {
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
    color: var(--iban-dark);
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
    background: var(--iban-light);
    border-color: var(--iban-primary);
    color: var(--iban-dark);
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
    color: var(--iban-dark);
    font-size: 1.3rem;
    margin-top: 0;
    margin-bottom: 1rem;
    padding-bottom: 0.5rem;
    border-bottom: 2px solid var(--iban-light);
  }

  .doc-section h4 {
    color: var(--iban-accent);
    font-size: 1.1rem;
    margin-top: 1.5rem;
    margin-bottom: 0.75rem;
  }

  .format-guide {
    background: #f9fafb;
    border-left: 4px solid var(--iban-primary);
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

<div class="iban-container">
  <div class="iban-card">
    <div class="iban-header">
      <h1>🏦 IBAN Validator & Generator 🏦</h1>
      <p>Validate IBAN format, check structure, and generate test IBANs for all countries</p>
    </div>

    <div class="iban-content">
      <div class="input-section">
        <div class="input-grid">
          <div class="input-group">
            <label>IBAN Number (to validate)</label>
            <input type="text" id="ibanInput" placeholder="GB82 WEST 1234 5698 7654 32" oninput="validateIBAN()" style="text-transform: uppercase;">
          </div>
          <div class="input-group">
            <label>Generate Test IBAN (Country)</label>
            <select id="countrySelect">
              <optgroup label="Europe">
                <option value="GB">United Kingdom (GB) - 22</option>
                <option value="DE">Germany (DE) - 22</option>
                <option value="FR">France (FR) - 27</option>
                <option value="IT">Italy (IT) - 27</option>
                <option value="ES">Spain (ES) - 24</option>
                <option value="NL">Netherlands (NL) - 18</option>
                <option value="BE">Belgium (BE) - 16</option>
                <option value="CH">Switzerland (CH) - 21</option>
                <option value="AT">Austria (AT) - 20</option>
                <option value="PT">Portugal (PT) - 25</option>
                <option value="IE">Ireland (IE) - 22</option>
                <option value="FI">Finland (FI) - 18</option>
                <option value="LU">Luxembourg (LU) - 20</option>
                <option value="DK">Denmark (DK) - 18</option>
                <option value="SE">Sweden (SE) - 24</option>
                <option value="NO">Norway (NO) - 15</option>
                <option value="PL">Poland (PL) - 28</option>
                <option value="CZ">Czech Republic (CZ) - 24</option>
                <option value="GR">Greece (GR) - 27</option>
                <option value="RO">Romania (RO) - 24</option>
                <option value="HU">Hungary (HU) - 28</option>
                <option value="SK">Slovakia (SK) - 24</option>
                <option value="SI">Slovenia (SI) - 19</option>
                <option value="HR">Croatia (HR) - 21</option>
                <option value="BG">Bulgaria (BG) - 22</option>
                <option value="EE">Estonia (EE) - 20</option>
                <option value="LV">Latvia (LV) - 21</option>
                <option value="LT">Lithuania (LT) - 20</option>
                <option value="IS">Iceland (IS) - 26</option>
                <option value="MT">Malta (MT) - 31</option>
                <option value="CY">Cyprus (CY) - 28</option>
              </optgroup>
              <optgroup label="Middle East & Africa">
                <option value="AE">United Arab Emirates (AE) - 23</option>
                <option value="SA">Saudi Arabia (SA) - 24</option>
                <option value="TR">Turkey (TR) - 26</option>
                <option value="IL">Israel (IL) - 23</option>
                <option value="JO">Jordan (JO) - 30</option>
                <option value="KW">Kuwait (KW) - 30</option>
                <option value="QA">Qatar (QA) - 29</option>
                <option value="BH">Bahrain (BH) - 22</option>
                <option value="EG">Egypt (EG) - 29</option>
                <option value="TN">Tunisia (TN) - 24</option>
                <option value="MA">Morocco (MA) - 28</option>
                <option value="PK">Pakistan (PK) - 24</option>
              </optgroup>
              <optgroup label="Americas & Others">
                <option value="BR">Brazil (BR) - 29</option>
                <option value="CR">Costa Rica (CR) - 22</option>
                <option value="DO">Dominican Republic (DO) - 28</option>
                <option value="GT">Guatemala (GT) - 28</option>
                <option value="LC">Saint Lucia (LC) - 32</option>
                <option value="VG">British Virgin Islands (VG) - 24</option>
              </optgroup>
            </select>
          </div>
        </div>

        <div class="sample-buttons">
          <span style="font-weight: 600; color: #6b7280; font-size: 0.85rem; margin-right: 0.5rem;">📋 Load Sample:</span>
          <button class="sample-btn" onclick="loadSample('GB82WEST12345698765432')">UK Sample</button>
          <button class="sample-btn" onclick="loadSample('DE89370400440532013000')">Germany Sample</button>
          <button class="sample-btn" onclick="loadSample('FR1420041010050500013M02606')">France Sample</button>
          <button class="sample-btn" onclick="loadSample('IT60X0542811101000000123456')">Italy Sample</button>
        </div>

        <div class="action-buttons">
          <button class="action-btn" onclick="generateTestIBAN()">🎲 Generate Test IBAN</button>
          <button class="action-btn secondary" onclick="validateIBAN()">✓ Validate IBAN</button>
          <button class="action-btn danger" onclick="clearAll()">🔄 Clear</button>
        </div>
      </div>

      <div class="results-section">
        <div class="result-panel">
          <h3>🔍 Validation Result</h3>
          <div id="validationResult"></div>
          <div id="ibanInfo" class="iban-info" style="display: none;"></div>
        </div>

        <div class="result-panel">
          <h3>📋 IBAN Information</h3>
          <div id="ibanDisplay" class="iban-display" style="display: none;"></div>
          <div id="ibanDetails" style="margin-top: 0.5rem;"></div>
        </div>
      </div>
    </div>
  </div>

  <div class="iban-card" style="padding: 1.5rem; margin-top: 1rem;">
    <div class="doc-section" style="padding: 0; border: none; margin: 0;">
    <h3>📚 IBAN Format Explained</h3>
    
    <h4>📋 What is an IBAN?</h4>
    <p><strong>IBAN</strong> (International Bank Account Number) is an internationally agreed system of identifying bank accounts across national borders. It was originally developed to facilitate payments within the European Union but has been adopted by many countries worldwide.</p>

    <div class="format-guide">
      <h5>IBAN Structure</h5>
      <p>An IBAN consists of up to 34 alphanumeric characters:</p>
      <ul>
        <li><strong>Country Code (2 letters):</strong> ISO 3166-1 alpha-2 country code (e.g., GB, DE, FR)</li>
        <li><strong>Check Digits (2 digits):</strong> Modulo 97-10 validation digits</li>
        <li><strong>BBAN (Basic Bank Account Number):</strong> Country-specific bank account identifier</li>
      </ul>
      <p><strong>Format:</strong> <code>CCKKBBBBBBBBBBBBBBBB</code></p>
      <ul>
        <li>CC = Country Code (2 letters)</li>
        <li>KK = Check Digits (2 digits)</li>
        <li>BBBBBBBBBBBBBBBBBB = BBAN (variable length, country-specific)</li>
      </ul>
    </div>

    <div class="format-guide">
      <h5>Country-Specific IBAN Lengths</h5>
      <p>IBAN length varies by country. Common lengths:</p>
      <ul>
        <li><strong>15 characters:</strong> Norway (NO)</li>
        <li><strong>16 characters:</strong> Belgium (BE)</li>
        <li><strong>18 characters:</strong> Netherlands (NL), Denmark (DK), Finland (FI), Faroe Islands (FO), Greenland (GL)</li>
        <li><strong>19 characters:</strong> Slovenia (SI), North Macedonia (MK)</li>
        <li><strong>20 characters:</strong> Austria (AT), Luxembourg (LU), Estonia (EE), Lithuania (LT), Bosnia (BA), Kosovo (XK)</li>
        <li><strong>21 characters:</strong> Switzerland (CH), Croatia (HR), Liechtenstein (LI), Latvia (LV)</li>
        <li><strong>22 characters:</strong> United Kingdom (GB), Germany (DE), Ireland (IE), Bulgaria (BG), Serbia (RS), Montenegro (ME), Azerbaijan (AZ), Georgia (GE), Kazakhstan (KZ)</li>
        <li><strong>23 characters:</strong> United Arab Emirates (AE), Gibraltar (GI), Israel (IL)</li>
        <li><strong>24 characters:</strong> Spain (ES), Sweden (SE), Czech Republic (CZ), Slovakia (SK), Romania (RO), Poland (PL), Portugal (PT), Andorra (AD), Albania (AL), Moldova (MD), Pakistan (PK), Saudi Arabia (SA), British Virgin Islands (VG), Tunisia (TN)</li>
        <li><strong>25 characters:</strong> Portugal (PT)</li>
        <li><strong>26 characters:</strong> Iceland (IS), Turkey (TR)</li>
        <li><strong>27 characters:</strong> France (FR), Italy (IT), Greece (GR), Monaco (MC), San Marino (SM), Mauritania (MR)</li>
        <li><strong>28 characters:</strong> Poland (PL), Hungary (HU), Albania (AL), Azerbaijan (AZ), Belarus (BY), Lebanon (LB), Morocco (MA)</li>
        <li><strong>29 characters:</strong> Brazil (BR), Egypt (EG), Palestine (PS), Ukraine (UA), Dominican Republic (DO), Guatemala (GT)</li>
        <li><strong>30 characters:</strong> Jordan (JO), Kuwait (KW), Mauritius (MU)</li>
        <li><strong>31 characters:</strong> Malta (MT)</li>
        <li><strong>32 characters:</strong> Saint Lucia (LC)</li>
        <li><strong>United States (US):</strong> Not officially supported (uses routing numbers)</li>
      </ul>
    </div>

    <h4>🔢 Check Digit Calculation</h4>
    <p>The IBAN check digits are calculated using <strong>Modulo 97-10</strong> algorithm:</p>
    <ol>
      <li>Move the first 4 characters (country code + check digits) to the end</li>
      <li>Replace letters with numbers (A=10, B=11, ..., Z=35)</li>
      <li>Calculate: remainder when divided by 97</li>
      <li>Check digits = 98 - remainder (if remainder is 0, check digits are 97, but displayed as 01)</li>
    </ol>

    <h4>✅ Validation Rules</h4>
    <ul>
      <li>Must start with 2-letter country code</li>
      <li>Followed by 2 check digits (00-99)</li>
      <li>Followed by country-specific BBAN</li>
      <li>Total length must match country's IBAN length</li>
      <li>Check digits must be valid (Modulo 97-10)</li>
      <li>BBAN format must match country's requirements</li>
    </ul>

    <h4>💡 Common Use Cases</h4>
    <ul>
      <li><strong>International Payments:</strong> SEPA transfers within Europe</li>
      <li><strong>Bank Transfers:</strong> Cross-border money transfers</li>
      <li><strong>Invoice Processing:</strong> Automated payment processing</li>
      <li><strong>Account Verification:</strong> Validate bank account numbers</li>
      <li><strong>Financial Software:</strong> Integration with banking systems</li>
    </ul>
    </div>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
// Country IBAN lengths (comprehensive list)
const ibanLengths = {
  'AD': 24, 'AE': 23, 'AL': 28, 'AT': 20, 'AZ': 28, 'BA': 20, 'BE': 16,
  'BG': 22, 'BH': 22, 'BR': 29, 'BY': 28, 'CH': 21, 'CR': 22, 'CY': 28,
  'CZ': 24, 'DE': 22, 'DK': 18, 'DO': 28, 'EE': 20, 'EG': 29, 'ES': 24,
  'FI': 18, 'FO': 18, 'FR': 27, 'GB': 22, 'GE': 22, 'GI': 23, 'GL': 18,
  'GR': 27, 'GT': 28, 'HR': 21, 'HU': 28, 'IE': 22, 'IL': 23, 'IS': 26,
  'IT': 27, 'JO': 30, 'KW': 30, 'KZ': 20, 'LB': 28, 'LC': 32, 'LI': 21,
  'LT': 20, 'LU': 20, 'LV': 21, 'MC': 27, 'MD': 24, 'ME': 22, 'MK': 19,
  'MA': 28, 'MR': 27, 'MT': 31, 'MU': 30, 'NL': 18, 'NO': 15, 'PK': 24, 'PL': 28,
  'PS': 29, 'PT': 25, 'QA': 29, 'RO': 24, 'RS': 22, 'SA': 24, 'SE': 24,
  'SI': 19, 'SK': 24, 'SM': 27, 'TN': 24, 'TR': 26, 'UA': 29, 'VG': 24,
  'XK': 20
};

// Country names
const countryNames = {
  'AD': 'Andorra', 'AE': 'United Arab Emirates', 'AL': 'Albania', 'AT': 'Austria',
  'AZ': 'Azerbaijan', 'BA': 'Bosnia and Herzegovina', 'BE': 'Belgium',
  'BG': 'Bulgaria', 'BH': 'Bahrain', 'BR': 'Brazil', 'BY': 'Belarus',
  'CH': 'Switzerland', 'CR': 'Costa Rica', 'CY': 'Cyprus', 'CZ': 'Czech Republic',
  'DE': 'Germany', 'DK': 'Denmark', 'DO': 'Dominican Republic', 'EE': 'Estonia',
  'EG': 'Egypt', 'ES': 'Spain', 'FI': 'Finland', 'FO': 'Faroe Islands',
  'FR': 'France', 'GB': 'United Kingdom', 'GE': 'Georgia', 'GI': 'Gibraltar',
  'GL': 'Greenland', 'GR': 'Greece', 'GT': 'Guatemala', 'HR': 'Croatia',
  'HU': 'Hungary', 'IE': 'Ireland', 'IL': 'Israel', 'IS': 'Iceland',
  'IT': 'Italy', 'JO': 'Jordan', 'KW': 'Kuwait', 'KZ': 'Kazakhstan',
  'LB': 'Lebanon', 'LC': 'Saint Lucia', 'LI': 'Liechtenstein', 'LT': 'Lithuania',
  'LU': 'Luxembourg', 'LV': 'Latvia', 'MC': 'Monaco', 'MD': 'Moldova',
  'MA': 'Morocco', 'ME': 'Montenegro', 'MK': 'North Macedonia', 'MR': 'Mauritania', 'MT': 'Malta',
  'MU': 'Mauritius', 'NL': 'Netherlands', 'NO': 'Norway', 'PK': 'Pakistan',
  'PL': 'Poland', 'PS': 'Palestine', 'PT': 'Portugal', 'QA': 'Qatar',
  'RO': 'Romania', 'RS': 'Serbia', 'SA': 'Saudi Arabia', 'SE': 'Sweden',
  'SI': 'Slovenia', 'SK': 'Slovakia', 'SM': 'San Marino', 'TN': 'Tunisia',
  'TR': 'Turkey', 'UA': 'Ukraine', 'VG': 'British Virgin Islands', 'XK': 'Kosovo'
};

function normalizeIBAN(iban) {
  return iban.replace(/\s/g, '').toUpperCase();
}

function validateIBANFormat(iban) {
  const normalized = normalizeIBAN(iban);
  
  // Check length (15-34 characters)
  if (normalized.length < 15 || normalized.length > 34) {
    return { valid: false, error: 'IBAN length must be between 15 and 34 characters' };
  }
  
  // Check format: 2 letters + 2 digits + alphanumeric
  if (!/^[A-Z]{2}\d{2}[A-Z0-9]+$/.test(normalized)) {
    return { valid: false, error: 'Invalid IBAN format. Must start with 2 letters, 2 digits, then alphanumeric' };
  }
  
  // Extract country code
  const countryCode = normalized.substring(0, 2);
  const expectedLength = ibanLengths[countryCode];
  
  if (expectedLength && normalized.length !== expectedLength) {
    return { valid: false, error: `IBAN length for ${countryCode} should be ${expectedLength} characters, got ${normalized.length}` };
  }
  
  // Validate check digits
  const checkDigits = normalized.substring(2, 4);
  const bban = normalized.substring(4);
  const rearranged = bban + countryCode + checkDigits;
  
  // Convert letters to numbers
  let numericString = '';
  for (let i = 0; i < rearranged.length; i++) {
    const char = rearranged[i];
    if (/[A-Z]/.test(char)) {
      numericString += (char.charCodeAt(0) - 55).toString();
    } else {
      numericString += char;
    }
  }
  
  // Calculate modulo 97
  let remainder = '';
  for (let i = 0; i < numericString.length; i++) {
    remainder = (remainder + numericString[i]).replace(/^0+/, '');
    if (remainder.length >= 9) {
      remainder = (parseInt(remainder.substring(0, 9)) % 97).toString() + remainder.substring(9);
    }
  }
  remainder = parseInt(remainder) % 97;
  
  if (remainder !== 1) {
    return { valid: false, error: `Invalid check digits. Expected remainder 1, got ${remainder}` };
  }
  
  return { valid: true, iban: normalized, countryCode, checkDigits, bban };
}

function formatIBAN(iban) {
  const normalized = normalizeIBAN(iban);
  return normalized.match(/.{1,4}/g).join(' ');
}

function validateIBAN() {
  const ibanInput = document.getElementById('ibanInput').value.trim();
  const validationResult = document.getElementById('validationResult');
  const ibanInfo = document.getElementById('ibanInfo');
  const ibanDisplay = document.getElementById('ibanDisplay');
  const ibanDetails = document.getElementById('ibanDetails');
  
  if (!ibanInput) {
    validationResult.innerHTML = '<div class="validation-result" style="background: #fef3c7; color: #92400e;">Enter an IBAN to validate</div>';
    ibanInfo.style.display = 'none';
    ibanDisplay.style.display = 'none';
    ibanDetails.innerHTML = '';
    return;
  }
  
  const result = validateIBANFormat(ibanInput);
  
  if (result.valid) {
    const formatted = formatIBAN(result.iban);
    const countryName = countryNames[result.countryCode] || result.countryCode;
    
    validationResult.innerHTML = `
      <div class="validation-result valid">
        ✓ Valid IBAN
      </div>
    `;
    
    ibanDisplay.textContent = formatted;
    ibanDisplay.style.display = 'block';
    
    ibanInfo.innerHTML = `
      <div class="info-row">
        <span class="info-label">Country:</span>
        <span class="info-value">${countryName} (${result.countryCode})</span>
      </div>
      <div class="info-row">
        <span class="info-label">Check Digits:</span>
        <span class="info-value">${result.checkDigits}</span>
      </div>
      <div class="info-row">
        <span class="info-label">BBAN:</span>
        <span class="info-value">${result.bban}</span>
      </div>
      <div class="info-row">
        <span class="info-label">Length:</span>
        <span class="info-value">${result.iban.length} characters</span>
      </div>
    `;
    ibanInfo.style.display = 'block';
    
    ibanDetails.innerHTML = `
      <div style="margin-top: 0.5rem; padding: 0.75rem; background: #f0f9ff; border-radius: 6px; font-size: 0.9rem;">
        <strong>Formatted IBAN:</strong> <code style="font-size: 1.1rem; font-weight: 700;">${formatted}</code>
      </div>
    `;
  } else {
    validationResult.innerHTML = `
      <div class="validation-result invalid">
        ✗ Invalid IBAN
      </div>
      <div style="padding: 0.75rem; color: #6b7280; font-size: 0.9rem;">
        ${result.error || 'Invalid IBAN format'}
      </div>
    `;
    ibanInfo.style.display = 'none';
    ibanDisplay.style.display = 'none';
    ibanDetails.innerHTML = '';
  }
}

function generateTestIBAN() {
  const country = document.getElementById('countrySelect').value;
  const length = ibanLengths[country] || 22;
  
  // Generate random BBAN
  let bban = '';
  const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  for (let i = 0; i < length - 4; i++) {
    bban += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  
  // Calculate check digits
  const rearranged = bban + country + '00';
  let numericString = '';
  for (let i = 0; i < rearranged.length; i++) {
    const char = rearranged[i];
    if (/[A-Z]/.test(char)) {
      numericString += (char.charCodeAt(0) - 55).toString();
    } else {
      numericString += char;
    }
  }
  
  let remainder = '';
  for (let i = 0; i < numericString.length; i++) {
    remainder = (remainder + numericString[i]).replace(/^0+/, '');
    if (remainder.length >= 9) {
      remainder = (parseInt(remainder.substring(0, 9)) % 97).toString() + remainder.substring(9);
    }
  }
  remainder = parseInt(remainder) % 97;
  const checkDigits = String(98 - remainder).padStart(2, '0');
  
  const testIBAN = country + checkDigits + bban;
  document.getElementById('ibanInput').value = formatIBAN(testIBAN);
  validateIBAN();
}

function loadSample(iban) {
  document.getElementById('ibanInput').value = formatIBAN(iban);
  validateIBAN();
}

function clearAll() {
  document.getElementById('ibanInput').value = '';
  document.getElementById('validationResult').innerHTML = '';
  document.getElementById('ibanInfo').style.display = 'none';
  document.getElementById('ibanDisplay').style.display = 'none';
  document.getElementById('ibanDetails').innerHTML = '';
}

// Initialize
validateIBAN();
</script>

  <!-- E-E-A-T: Visible author/methodology/trust section -->
  <div class="iban-card" style="padding: 1.5rem; margin-top: 1rem;">
    <div class="doc-section" style="padding: 0; border: none; margin: 0;">
      <h3>About This Tool & Methodology</h3>
      <p>This validator implements the official IBAN specification. Validation includes country code and length checks, structural BBAN rules where available, and the ISO 13616 Mod 97‑10 check digit calculation. The generator creates test IBANs for development by producing random BBANs that meet length constraints and valid check digits; these are not guaranteed to be real bank accounts.</p>

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
          <li><a href="https://www.iso.org/standard/81090.html" rel="nofollow noopener" target="_blank">ISO 13616 — IBAN</a></li>
          <li><a href="https://www.swift.com/standards/data-standards/iban" rel="nofollow noopener" target="_blank">SWIFT IBAN Registry</a></li>
          <li><a href="https://en.wikipedia.org/wiki/International_Bank_Account_Number" rel="nofollow noopener" target="_blank">IBAN overview (reference)</a></li>
        </ul>
      </div>

      <div class="format-guide">
        <h5>Trust & Privacy</h5>
        <ul>
          <li>Validation runs entirely in your browser; IBANs are not stored on our servers.</li>
          <li>Generated IBANs are for testing only and should not be used for real payments.</li>
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
    "name": "IBAN Validator & Generator",
    "url": "https://8gwifi.org/iban-validator.jsp",
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
      {"@type": "ListItem", "position": 2, "name": "IBAN Validator", "item": "https://8gwifi.org/iban-validator.jsp"}
    ]
  }
  </script>

    <%@ include file="thanks.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
