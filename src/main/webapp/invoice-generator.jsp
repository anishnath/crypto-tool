<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Professional Invoice Generator",
        "description": "Free online invoice generator with multiple templates, PDF export, logo upload, and automatic calculations. Create professional invoices instantly.",
        "url": "https://8gwifi.org/invoice-generator.jsp",
        "applicationCategory": "BusinessApplication",
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
        "keywords": "invoice generator, create invoice, invoice maker, PDF invoice, invoice template, business invoice, free invoice generator, invoice creator, online invoice, professional invoice"
    }
    </script>

    <title>Professional Invoice Generator Online Free | Create PDF Invoices | 8gwifi.org</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Free online professional invoice generator with multiple templates, PDF export, logo upload, automatic calculations, and tax support. Create invoices instantly.">
    <meta name="keywords" content="invoice generator, invoice maker, PDF invoice, invoice template, create invoice, business invoice, free invoice, invoice creator, online invoice, professional invoice, billing software">
    <meta name="author" content="8gwifi.org">
    <meta name="robots" content="index, follow">

    <!-- OpenGraph -->
    <meta property="og:title" content="Professional Invoice Generator - Free Online Tool">
    <meta property="og:description" content="Create professional invoices with multiple templates, PDF export, and automatic calculations.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/invoice-generator.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Professional Invoice Generator">
    <meta name="twitter:description" content="Create professional invoices with templates and PDF export.">

    <link rel="canonical" href="https://8gwifi.org/invoice-generator.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- jsPDF for PDF generation -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

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

        .invoice-container {
            display: grid;
            grid-template-columns: 1fr 600px;
            gap: 25px;
            margin-bottom: 25px;
        }

        .invoice-editor {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .invoice-preview {
            background: white;
            padding: 0;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            position: sticky;
            top: 20px;
            max-height: calc(100vh - 40px);
            overflow-y: auto;
        }

        .form-section {
            margin-bottom: 25px;
            padding-bottom: 25px;
            border-bottom: 2px solid #e2e8f0;
        }

        .form-section:last-child {
            border-bottom: none;
        }

        .form-section h3 {
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
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
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

        .btn-danger {
            background: #f56565;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }

        .line-items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }

        .line-items-table th {
            background: #f7fafc;
            padding: 10px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            color: #2d3748;
            border-bottom: 2px solid #e2e8f0;
        }

        .line-items-table td {
            padding: 8px 10px;
            border-bottom: 1px solid #e2e8f0;
        }

        .line-items-table input {
            width: 100%;
            padding: 6px 8px;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            font-size: 13px;
        }

        .logo-upload {
            border: 2px dashed #cbd5e0;
            border-radius: 6px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .logo-upload:hover {
            border-color: #667eea;
            background: #f7fafc;
        }

        .logo-preview {
            max-width: 150px;
            max-height: 80px;
            margin: 10px auto;
            display: block;
        }

        .template-selector {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 15px;
        }

        .template-option {
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .template-option:hover {
            border-color: #667eea;
            background: #f7fafc;
        }

        .template-option.active {
            border-color: #667eea;
            background: #edf2f7;
        }

        .template-option .template-name {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
        }

        .template-option .template-desc {
            font-size: 11px;
            color: #718096;
        }

        /* Invoice Preview Styles */
        #invoicePreview {
            min-height: 800px;
            padding: 40px;
            background: white;
        }

        .preview-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e2e8f0;
        }

        .preview-logo img {
            max-width: 150px;
            max-height: 80px;
        }

        .preview-title {
            text-align: right;
        }

        .preview-title h2 {
            font-size: 2rem;
            color: #667eea;
            margin: 0;
        }

        .preview-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .preview-section h4 {
            font-size: 0.9rem;
            color: #718096;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 10px;
        }

        .preview-section p {
            margin: 5px 0;
            color: #2d3748;
            line-height: 1.6;
        }

        .preview-details {
            background: #f7fafc;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 30px;
        }

        .preview-details-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }

        .preview-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        .preview-table th {
            background: #667eea;
            color: white;
            padding: 12px;
            text-align: left;
            font-size: 13px;
        }

        .preview-table td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
        }

        .preview-totals {
            margin-left: auto;
            width: 300px;
        }

        .preview-total-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .preview-total-row.grand-total {
            font-size: 1.2rem;
            font-weight: 700;
            color: #667eea;
            border-top: 2px solid #667eea;
            border-bottom: 2px solid #667eea;
            margin-top: 10px;
        }

        .preview-notes {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }

        .preview-notes h4 {
            font-size: 0.9rem;
            color: #718096;
            margin-bottom: 10px;
        }

        .preview-notes p {
            color: #4a5568;
            line-height: 1.6;
        }

        @media (max-width: 1200px) {
            .invoice-container {
                grid-template-columns: 1fr;
            }

            .invoice-preview {
                position: relative;
                top: 0;
                max-height: none;
            }
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 1.5rem;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .template-selector {
                grid-template-columns: 1fr;
            }
        }

        /* Modern Template */
        .template-modern .preview-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            margin: 0 0 30px 0;
            border-radius: 6px;
        }

        .template-modern .preview-title h2 {
            color: white;
        }

        .template-modern .preview-logo img {
            filter: brightness(0) invert(1);
        }

        /* Classic Template */
        .template-classic .preview-header {
            border-bottom: 3px solid #2d3748;
        }

        .template-classic .preview-title h2 {
            color: #2d3748;
        }

        .template-classic .preview-table th {
            background: #2d3748;
        }

        /* Minimal Template */
        .template-minimal .preview-header {
            border-bottom: 1px solid #cbd5e0;
        }

        .template-minimal .preview-title h2 {
            color: #4a5568;
            font-weight: 300;
        }

        .template-minimal .preview-table th {
            background: #f7fafc;
            color: #2d3748;
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Professional Invoice Generator</h1>
<p>Create beautiful, professional invoices with multiple templates and PDF export</p>

<hr>

<div class="info-box">
    <h3>📄 Professional Invoice Builder</h3>
    <p>Generate customizable invoices with your company logo, multiple professional templates, automatic calculations, and one-click PDF export. Perfect for freelancers, small businesses, and contractors.</p>
</div>

<div class="invoice-container">
    <!-- Left Side - Invoice Editor -->
    <div class="invoice-editor">
        <!-- Template Selection -->
        <div class="form-section">
            <h3>🎨 Choose Template</h3>
            <div class="template-selector">
                <div class="template-option active" onclick="selectTemplate('modern')">
                    <div class="template-name">Modern</div>
                    <div class="template-desc">Gradient header, bold colors</div>
                </div>
                <div class="template-option" onclick="selectTemplate('classic')">
                    <div class="template-name">Classic</div>
                    <div class="template-desc">Traditional, professional</div>
                </div>
                <div class="template-option" onclick="selectTemplate('minimal')">
                    <div class="template-name">Minimal</div>
                    <div class="template-desc">Clean, simple design</div>
                </div>
            </div>
        </div>

        <!-- Company Information -->
        <div class="form-section">
            <h3>🏢 Your Company</h3>

            <div class="form-group">
                <label>Company Logo</label>
                <div class="logo-upload" onclick="document.getElementById('logoInput').click()">
                    <input type="file" id="logoInput" accept="image/*" style="display: none;" onchange="handleLogoUpload(event)">
                    <div id="logoPreview">
                        <div style="color: #718096;">📷 Click to upload logo</div>
                        <div style="font-size: 11px; color: #a0aec0; margin-top: 5px;">PNG, JPG (max 2MB)</div>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Company Name</label>
                <input type="text" id="companyName" placeholder="Your Company Name" oninput="updatePreview()">
            </div>

            <div class="form-group">
                <label>Address</label>
                <textarea id="companyAddress" rows="3" placeholder="Street Address&#10;City, State ZIP&#10;Country" oninput="updatePreview()"></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" id="companyEmail" placeholder="email@company.com" oninput="updatePreview()">
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="tel" id="companyPhone" placeholder="+1 234 567 8900" oninput="updatePreview()">
                </div>
            </div>
        </div>

        <!-- Client Information -->
        <div class="form-section">
            <h3>👤 Bill To</h3>

            <div class="form-group">
                <label>Client Name</label>
                <input type="text" id="clientName" placeholder="Client or Company Name" oninput="updatePreview()">
            </div>

            <div class="form-group">
                <label>Client Address</label>
                <textarea id="clientAddress" rows="3" placeholder="Street Address&#10;City, State ZIP&#10;Country" oninput="updatePreview()"></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Client Email</label>
                    <input type="email" id="clientEmail" placeholder="client@email.com" oninput="updatePreview()">
                </div>
                <div class="form-group">
                    <label>Client Phone</label>
                    <input type="tel" id="clientPhone" placeholder="+1 234 567 8900" oninput="updatePreview()">
                </div>
            </div>
        </div>

        <!-- Invoice Details -->
        <div class="form-section">
            <h3>📋 Invoice Details</h3>

            <div class="form-row">
                <div class="form-group">
                    <label>Invoice Number</label>
                    <input type="text" id="invoiceNumber" value="INV-001" oninput="updatePreview()">
                </div>
                <div class="form-group">
                    <label>Currency</label>
                    <select id="currency" onchange="updatePreview()">
                        <option value="USD">USD ($) - US Dollar</option>
                        <option value="EUR">EUR (€) - Euro</option>
                        <option value="GBP">GBP (£) - British Pound</option>
                        <option value="JPY">JPY (¥) - Japanese Yen</option>
                        <option value="INR">INR (₹) - Indian Rupee</option>
                        <option value="CAD">CAD ($) - Canadian Dollar</option>
                        <option value="AUD">AUD ($) - Australian Dollar</option>
                        <option value="CNY">CNY (¥) - Chinese Yuan</option>
                        <option value="CHF">CHF (Fr) - Swiss Franc</option>
                        <option value="SEK">SEK (kr) - Swedish Krona</option>
                        <option value="NZD">NZD ($) - New Zealand Dollar</option>
                        <option value="MXN">MXN ($) - Mexican Peso</option>
                        <option value="SGD">SGD ($) - Singapore Dollar</option>
                        <option value="HKD">HKD ($) - Hong Kong Dollar</option>
                        <option value="NOK">NOK (kr) - Norwegian Krone</option>
                        <option value="KRW">KRW (₩) - South Korean Won</option>
                        <option value="TRY">TRY (₺) - Turkish Lira</option>
                        <option value="RUB">RUB (₽) - Russian Ruble</option>
                        <option value="BRL">BRL (R$) - Brazilian Real</option>
                        <option value="ZAR">ZAR (R) - South African Rand</option>
                        <option value="DKK">DKK (kr) - Danish Krone</option>
                        <option value="PLN">PLN (zł) - Polish Zloty</option>
                        <option value="THB">THB (฿) - Thai Baht</option>
                        <option value="IDR">IDR (Rp) - Indonesian Rupiah</option>
                        <option value="MYR">MYR (RM) - Malaysian Ringgit</option>
                        <option value="PHP">PHP (₱) - Philippine Peso</option>
                        <option value="CZK">CZK (Kč) - Czech Koruna</option>
                        <option value="ILS">ILS (₪) - Israeli Shekel</option>
                        <option value="CLP">CLP ($) - Chilean Peso</option>
                        <option value="PKR">PKR (₨) - Pakistani Rupee</option>
                        <option value="AED">AED (د.إ) - UAE Dirham</option>
                        <option value="SAR">SAR (﷼) - Saudi Riyal</option>
                        <option value="QAR">QAR (ر.ق) - Qatari Riyal</option>
                        <option value="KWD">KWD (د.ك) - Kuwaiti Dinar</option>
                        <option value="EGP">EGP (£) - Egyptian Pound</option>
                        <option value="NGN">NGN (₦) - Nigerian Naira</option>
                        <option value="KES">KES (KSh) - Kenyan Shilling</option>
                        <option value="GHS">GHS (₵) - Ghanaian Cedi</option>
                        <option value="BDT">BDT (৳) - Bangladeshi Taka</option>
                        <option value="VND">VND (₫) - Vietnamese Dong</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Issue Date</label>
                    <input type="date" id="issueDate" oninput="updatePreview()">
                </div>
                <div class="form-group">
                    <label>Due Date</label>
                    <input type="date" id="dueDate" oninput="updatePreview()">
                </div>
            </div>
        </div>

        <!-- Line Items -->
        <div class="form-section">
            <h3>📦 Items / Services</h3>

            <table class="line-items-table">
                <thead>
                    <tr>
                        <th style="width: 40%;">Description</th>
                        <th style="width: 15%;">Quantity</th>
                        <th style="width: 20%;">Rate</th>
                        <th style="width: 20%;">Amount</th>
                        <th style="width: 5%;"></th>
                    </tr>
                </thead>
                <tbody id="lineItemsBody">
                </tbody>
            </table>

            <button class="btn-secondary btn-small" onclick="addLineItem()">+ Add Item</button>
        </div>

        <!-- Totals & Tax -->
        <div class="form-section">
            <h3>💰 Totals</h3>

            <div class="form-row">
                <div class="form-group">
                    <label>Tax (%)</label>
                    <input type="number" id="taxRate" value="0" min="0" max="100" step="0.1" oninput="calculateTotals()">
                </div>
                <div class="form-group">
                    <label>Discount</label>
                    <input type="number" id="discount" value="0" min="0" step="0.01" oninput="calculateTotals()">
                </div>
            </div>
        </div>

        <!-- Notes -->
        <div class="form-section">
            <h3>📝 Notes / Terms</h3>
            <div class="form-group">
                <textarea id="notes" rows="4" placeholder="Payment terms, thank you message, or any additional information..." oninput="updatePreview()"></textarea>
            </div>
        </div>

        <!-- Actions -->
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <button class="btn-primary" onclick="downloadPDF()">📥 Download PDF</button>
            <button class="btn-secondary" onclick="saveInvoice()">💾 Save Invoice</button>
            <button class="btn-secondary" onclick="loadInvoice()">📂 Load Invoice</button>
            <button class="btn-secondary" onclick="clearAll()">🔄 Clear All</button>
        </div>
    </div>

    <!-- Right Side - Invoice Preview -->
    <div class="invoice-preview">
        <div id="invoicePreview" class="template-modern">
            <div class="preview-header">
                <div class="preview-logo">
                    <img id="previewLogo" src="" style="display: none;" alt="Company Logo">
                </div>
                <div class="preview-title">
                    <h2>INVOICE</h2>
                </div>
            </div>

            <div class="preview-info">
                <div class="preview-section">
                    <h4>From</h4>
                    <p id="previewCompanyName" style="font-weight: 600;">Your Company</p>
                    <p id="previewCompanyAddress" style="white-space: pre-line;">123 Business Street<br>City, State 12345<br>Country</p>
                    <p id="previewCompanyEmail">email@company.com</p>
                    <p id="previewCompanyPhone">+1 234 567 8900</p>
                </div>

                <div class="preview-section">
                    <h4>Bill To</h4>
                    <p id="previewClientName" style="font-weight: 600;">Client Name</p>
                    <p id="previewClientAddress" style="white-space: pre-line;">456 Client Avenue<br>City, State 67890<br>Country</p>
                    <p id="previewClientEmail">client@email.com</p>
                    <p id="previewClientPhone">+1 234 567 8900</p>
                </div>
            </div>

            <div class="preview-details">
                <div class="preview-details-row">
                    <strong>Invoice Number:</strong>
                    <span id="previewInvoiceNumber">INV-001</span>
                </div>
                <div class="preview-details-row">
                    <strong>Issue Date:</strong>
                    <span id="previewIssueDate">-</span>
                </div>
                <div class="preview-details-row">
                    <strong>Due Date:</strong>
                    <span id="previewDueDate">-</span>
                </div>
            </div>

            <table class="preview-table">
                <thead>
                    <tr>
                        <th>Description</th>
                        <th style="text-align: center;">Qty</th>
                        <th style="text-align: right;">Rate</th>
                        <th style="text-align: right;">Amount</th>
                    </tr>
                </thead>
                <tbody id="previewLineItems">
                    <tr>
                        <td colspan="4" style="text-align: center; color: #a0aec0;">No items added yet</td>
                    </tr>
                </tbody>
            </table>

            <div class="preview-totals">
                <div class="preview-total-row">
                    <span>Subtotal:</span>
                    <span id="previewSubtotal">$0.00</span>
                </div>
                <div class="preview-total-row">
                    <span>Tax (<span id="previewTaxRate">0</span>%):</span>
                    <span id="previewTax">$0.00</span>
                </div>
                <div class="preview-total-row">
                    <span>Discount:</span>
                    <span id="previewDiscount">$0.00</span>
                </div>
                <div class="preview-total-row grand-total">
                    <span>Total:</span>
                    <span id="previewTotal">$0.00</span>
                </div>
            </div>

            <div class="preview-notes" id="previewNotesSection" style="display: none;">
                <h4>Notes / Terms</h4>
                <p id="previewNotes"></p>
            </div>
        </div>
    </div>
</div>

<h2 class="mt-4">Features</h2>
<ul>
    <li><strong>Multiple Templates:</strong> Choose from Modern, Classic, and Minimal designs</li>
    <li><strong>Logo Upload:</strong> Add your company logo for branding</li>
    <li><strong>Auto Calculations:</strong> Automatic subtotal, tax, discount, and total</li>
    <li><strong>PDF Export:</strong> Download professional PDF invoices instantly</li>
    <li><strong>Multi-Currency:</strong> Support for 40+ currencies worldwide including USD, EUR, GBP, JPY, INR, CAD, AUD, CNY, CHF, and more</li>
    <li><strong>Line Items:</strong> Add unlimited items/services with quantities and rates</li>
    <li><strong>Save/Load:</strong> Save invoices locally and load them later</li>
    <li><strong>Live Preview:</strong> See changes in real-time</li>
    <li><strong>Client-Side:</strong> 100% browser-based, your data stays private</li>
</ul>

<h2 class="mt-4">Try Other Business Tools</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="cron-generator.jsp">Cron Expression Generator</a></li>
            <li><a href="curl-builder.jsp">cURL Builder & HTTP Client</a></li>
            <li><a href="prometheus-query-builder.jsp">Prometheus Query Builder</a></li>
            <li><a href="json-2-csv.jsp">JSON to CSV Converter</a></li>
        </ul>
    </div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<script>
    let currentTemplate = 'modern';
    let logoDataUrl = null;
    let lineItemCount = 0;

    // Currency symbols
    const currencySymbols = {
        'USD': '$', 'EUR': '€', 'GBP': '£', 'JPY': '¥', 'INR': '₹',
        'CAD': '$', 'AUD': '$', 'CNY': '¥', 'CHF': 'Fr', 'SEK': 'kr',
        'NZD': '$', 'MXN': '$', 'SGD': '$', 'HKD': '$', 'NOK': 'kr',
        'KRW': '₩', 'TRY': '₺', 'RUB': '₽', 'BRL': 'R$', 'ZAR': 'R',
        'DKK': 'kr', 'PLN': 'zł', 'THB': '฿', 'IDR': 'Rp', 'MYR': 'RM',
        'PHP': '₱', 'CZK': 'Kč', 'ILS': '₪', 'CLP': '$', 'PKR': '₨',
        'AED': 'د.إ', 'SAR': '﷼', 'QAR': 'ر.ق', 'KWD': 'د.ك', 'EGP': '£',
        'NGN': '₦', 'KES': 'KSh', 'GHS': '₵', 'BDT': '৳', 'VND': '₫'
    };

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Set today's date
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('issueDate').value = today;

        // Set due date to 30 days from today
        const dueDate = new Date();
        dueDate.setDate(dueDate.getDate() + 30);
        document.getElementById('dueDate').value = dueDate.toISOString().split('T')[0];

        // Add initial line items
        addLineItem();
        addLineItem();

        updatePreview();
    });

    // Template selection
    function selectTemplate(template) {
        currentTemplate = template;

        // Update UI
        document.querySelectorAll('.template-option').forEach(opt => opt.classList.remove('active'));
        event.target.closest('.template-option').classList.add('active');

        // Update preview
        const preview = document.getElementById('invoicePreview');
        preview.className = 'template-' + template;
    }

    // Logo upload
    function handleLogoUpload(event) {
        const file = event.target.files[0];
        if (!file) return;

        // Check file size (max 2MB)
        if (file.size > 2 * 1024 * 1024) {
            alert('File size must be less than 2MB');
            return;
        }

        const reader = new FileReader();
        reader.onload = function(e) {
            logoDataUrl = e.target.result;

            // Update upload preview
            document.getElementById('logoPreview').innerHTML =
                '<img src="' + logoDataUrl + '" class="logo-preview" alt="Logo">';

            // Update invoice preview
            const previewLogo = document.getElementById('previewLogo');
            previewLogo.src = logoDataUrl;
            previewLogo.style.display = 'block';
        };
        reader.readAsDataURL(file);
    }

    // Add line item
    function addLineItem() {
        lineItemCount++;
        const tbody = document.getElementById('lineItemsBody');
        const row = document.createElement('tr');
        row.id = 'lineItem' + lineItemCount;
        const id = lineItemCount;
        row.innerHTML =
            '<td><input type="text" placeholder="Item description" oninput="updatePreview()" id="desc' + id + '"></td>' +
            '<td><input type="number" value="1" min="0" step="1" oninput="calculateLineItem(' + id + ')" id="qty' + id + '"></td>' +
            '<td><input type="number" value="0" min="0" step="0.01" oninput="calculateLineItem(' + id + ')" id="rate' + id + '"></td>' +
            '<td><input type="number" value="0" readonly id="amount' + id + '" style="background: #f7fafc;"></td>' +
            '<td><button class="btn-danger" onclick="removeLineItem(' + id + ')">✕</button></td>';
        tbody.appendChild(row);

        // Force immediate update
        setTimeout(function() {
            updatePreview();
        }, 10);
    }

    // Remove line item
    function removeLineItem(id) {
        const row = document.getElementById('lineItem' + id);
        if (row) {
            row.remove();
            calculateTotals();
        }
    }

    // Calculate individual line item
    function calculateLineItem(id) {
        const qty = parseFloat(document.getElementById('qty' + id).value) || 0;
        const rate = parseFloat(document.getElementById('rate' + id).value) || 0;
        const amount = qty * rate;
        document.getElementById('amount' + id).value = amount.toFixed(2);
        calculateTotals();
    }

    // Calculate totals
    function calculateTotals() {
        let subtotal = 0;

        // Sum all line items
        document.querySelectorAll('[id^="amount"]').forEach(input => {
            subtotal += parseFloat(input.value) || 0;
        });

        const taxRate = parseFloat(document.getElementById('taxRate').value) || 0;
        const discount = parseFloat(document.getElementById('discount').value) || 0;

        const tax = subtotal * (taxRate / 100);
        const total = subtotal + tax - discount;

        updatePreview();
    }

    // Update preview
    function updatePreview() {
        try {
            const currencyElem = document.getElementById('currency');
            if (!currencyElem) {
                console.error('Currency element not found');
                return;
            }
            const currency = currencyElem.value;
            const symbol = currencySymbols[currency] || '$';

        // Company info
        document.getElementById('previewCompanyName').textContent =
            document.getElementById('companyName').value || 'Your Company';
        document.getElementById('previewCompanyAddress').innerHTML =
            (document.getElementById('companyAddress').value || '123 Business Street<br>City, State 12345<br>Country').replace(/\n/g, '<br>');
        document.getElementById('previewCompanyEmail').textContent =
            document.getElementById('companyEmail').value || 'email@company.com';
        document.getElementById('previewCompanyPhone').textContent =
            document.getElementById('companyPhone').value || '+1 234 567 8900';

        // Client info
        document.getElementById('previewClientName').textContent =
            document.getElementById('clientName').value || 'Client Name';
        document.getElementById('previewClientAddress').innerHTML =
            (document.getElementById('clientAddress').value || '456 Client Avenue<br>City, State 67890<br>Country').replace(/\n/g, '<br>');
        document.getElementById('previewClientEmail').textContent =
            document.getElementById('clientEmail').value || 'client@email.com';
        document.getElementById('previewClientPhone').textContent =
            document.getElementById('clientPhone').value || '+1 234 567 8900';

        // Invoice details
        document.getElementById('previewInvoiceNumber').textContent =
            document.getElementById('invoiceNumber').value || 'INV-001';
        document.getElementById('previewIssueDate').textContent =
            document.getElementById('issueDate').value || '-';
        document.getElementById('previewDueDate').textContent =
            document.getElementById('dueDate').value || '-';

        // Line items
        const previewItems = document.getElementById('previewLineItems');
        previewItems.innerHTML = '';
        let hasItems = false;

        document.querySelectorAll('[id^="lineItem"]').forEach(row => {
            const id = row.id.replace('lineItem', '');
            const descElem = document.getElementById('desc' + id);
            const qtyElem = document.getElementById('qty' + id);
            const rateElem = document.getElementById('rate' + id);
            const amountElem = document.getElementById('amount' + id);

            if (!descElem || !qtyElem || !rateElem || !amountElem) {
                return; // Skip if elements not found
            }

            const desc = descElem.value.trim();
            const qty = parseFloat(qtyElem.value) || 0;
            const rate = parseFloat(rateElem.value) || 0;
            const amount = parseFloat(amountElem.value) || 0;

            // Show items that have description (even if values are zero for initial display)
            if (desc) {
                hasItems = true;
                const tr = document.createElement('tr');
                tr.innerHTML =
                    '<td>' + desc + '</td>' +
                    '<td style="text-align: center;">' + qty + '</td>' +
                    '<td style="text-align: right;">' + symbol + rate.toFixed(2) + '</td>' +
                    '<td style="text-align: right;">' + symbol + amount.toFixed(2) + '</td>';
                previewItems.appendChild(tr);
            }
        });

        if (!hasItems) {
            previewItems.innerHTML = '<tr><td colspan="4" style="text-align: center; color: #a0aec0;">No items added yet</td></tr>';
        }

        // Totals
        let subtotal = 0;
        document.querySelectorAll('[id^="amount"]').forEach(input => {
            subtotal += parseFloat(input.value) || 0;
        });

        const taxRate = parseFloat(document.getElementById('taxRate').value) || 0;
        const discount = parseFloat(document.getElementById('discount').value) || 0;
        const tax = subtotal * (taxRate / 100);
        const total = subtotal + tax - discount;

        document.getElementById('previewSubtotal').textContent = symbol + subtotal.toFixed(2);
        document.getElementById('previewTaxRate').textContent = taxRate.toFixed(1);
        document.getElementById('previewTax').textContent = symbol + tax.toFixed(2);
        document.getElementById('previewDiscount').textContent = symbol + discount.toFixed(2);
        document.getElementById('previewTotal').textContent = symbol + total.toFixed(2);

        // Notes
        const notes = document.getElementById('notes').value;
        if (notes) {
            document.getElementById('previewNotesSection').style.display = 'block';
            document.getElementById('previewNotes').textContent = notes;
        } else {
            document.getElementById('previewNotesSection').style.display = 'none';
        }
        } catch (error) {
            console.error('Error updating preview:', error);
        }
    }

    // Download PDF
    function downloadPDF() {
        const { jsPDF } = window.jspdf;

        // Use html2canvas to capture the preview
        const element = document.getElementById('invoicePreview');

        html2canvas(element, {
            scale: 2,
            useCORS: true,
            logging: false,
            windowWidth: element.scrollWidth,
            windowHeight: element.scrollHeight
        }).then(canvas => {
            const imgData = canvas.toDataURL('image/png');

            const pdf = new jsPDF('p', 'mm', 'a4');
            const pdfWidth = pdf.internal.pageSize.getWidth();
            const pdfHeight = pdf.internal.pageSize.getHeight();

            // Calculate proper dimensions
            const imgWidth = canvas.width;
            const imgHeight = canvas.height;

            // Scale to fit PDF width with margins
            const margin = 10;
            const availableWidth = pdfWidth - (2 * margin);
            const ratio = availableWidth / imgWidth;

            const scaledWidth = imgWidth * ratio;
            const scaledHeight = imgHeight * ratio;

            // Check if we need multiple pages
            if (scaledHeight <= pdfHeight - (2 * margin)) {
                // Fits on one page
                pdf.addImage(imgData, 'PNG', margin, margin, scaledWidth, scaledHeight);
            } else {
                // Multiple pages needed
                let heightLeft = scaledHeight;
                let position = margin;
                let page = 0;

                while (heightLeft > 0) {
                    if (page > 0) {
                        pdf.addPage();
                    }

                    const pageHeight = pdfHeight - (2 * margin);
                    const sourceY = page * pageHeight / ratio;
                    const sourceHeight = Math.min(pageHeight / ratio, (imgHeight - sourceY));

                    // Create a temporary canvas for this page
                    const pageCanvas = document.createElement('canvas');
                    pageCanvas.width = imgWidth;
                    pageCanvas.height = sourceHeight;
                    const pageCtx = pageCanvas.getContext('2d');

                    pageCtx.drawImage(
                        canvas,
                        0, sourceY,           // Source x, y
                        imgWidth, sourceHeight, // Source width, height
                        0, 0,                 // Dest x, y
                        imgWidth, sourceHeight  // Dest width, height
                    );

                    const pageImgData = pageCanvas.toDataURL('image/png');
                    pdf.addImage(pageImgData, 'PNG', margin, margin, scaledWidth, sourceHeight * ratio);

                    heightLeft -= pageHeight;
                    page++;
                }
            }

            const invoiceNumber = document.getElementById('invoiceNumber').value || 'INV-001';
            pdf.save('8gwifi.org-invoice-' + invoiceNumber + '.pdf');
        }).catch(function(error) {
            console.error('PDF generation error:', error);
            alert('Error generating PDF. Please try again.');
        });
    }

    // Save invoice
    function saveInvoice() {
        const invoiceData = {
            template: currentTemplate,
            logo: logoDataUrl,
            company: {
                name: document.getElementById('companyName').value,
                address: document.getElementById('companyAddress').value,
                email: document.getElementById('companyEmail').value,
                phone: document.getElementById('companyPhone').value
            },
            client: {
                name: document.getElementById('clientName').value,
                address: document.getElementById('clientAddress').value,
                email: document.getElementById('clientEmail').value,
                phone: document.getElementById('clientPhone').value
            },
            details: {
                number: document.getElementById('invoiceNumber').value,
                currency: document.getElementById('currency').value,
                issueDate: document.getElementById('issueDate').value,
                dueDate: document.getElementById('dueDate').value
            },
            lineItems: [],
            taxRate: document.getElementById('taxRate').value,
            discount: document.getElementById('discount').value,
            notes: document.getElementById('notes').value
        };

        // Collect line items
        document.querySelectorAll('[id^="lineItem"]').forEach(row => {
            const id = row.id.replace('lineItem', '');
            invoiceData.lineItems.push({
                description: document.getElementById('desc' + id).value,
                quantity: document.getElementById('qty' + id).value,
                rate: document.getElementById('rate' + id).value,
                amount: document.getElementById('amount' + id).value
            });
        });

        const json = JSON.stringify(invoiceData);
        const blob = new Blob([json], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = '8gwifi.org-invoice-' + invoiceData.details.number + '.json';
        a.click();
        URL.revokeObjectURL(url);

        alert('Invoice saved successfully!');
    }

    // Load invoice
    function loadInvoice() {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = '.json';
        input.onchange = function(e) {
            const file = e.target.files[0];
            const reader = new FileReader();
            reader.onload = function(event) {
                try {
                    const data = JSON.parse(event.target.result);

                    // Load template
                    selectTemplate(data.template);

                    // Load logo
                    if (data.logo) {
                        logoDataUrl = data.logo;
                        document.getElementById('logoPreview').innerHTML =
                            '<img src="' + data.logo + '" class="logo-preview" alt="Logo">';
                        document.getElementById('previewLogo').src = data.logo;
                        document.getElementById('previewLogo').style.display = 'block';
                    }

                    // Load company
                    document.getElementById('companyName').value = data.company.name;
                    document.getElementById('companyAddress').value = data.company.address;
                    document.getElementById('companyEmail').value = data.company.email;
                    document.getElementById('companyPhone').value = data.company.phone;

                    // Load client
                    document.getElementById('clientName').value = data.client.name;
                    document.getElementById('clientAddress').value = data.client.address;
                    document.getElementById('clientEmail').value = data.client.email;
                    document.getElementById('clientPhone').value = data.client.phone;

                    // Load details
                    document.getElementById('invoiceNumber').value = data.details.number;
                    document.getElementById('currency').value = data.details.currency;
                    document.getElementById('issueDate').value = data.details.issueDate;
                    document.getElementById('dueDate').value = data.details.dueDate;

                    // Load line items
                    document.getElementById('lineItemsBody').innerHTML = '';
                    lineItemCount = 0;
                    data.lineItems.forEach(item => {
                        addLineItem();
                        const id = lineItemCount;
                        document.getElementById('desc' + id).value = item.description;
                        document.getElementById('qty' + id).value = item.quantity;
                        document.getElementById('rate' + id).value = item.rate;
                        document.getElementById('amount' + id).value = item.amount;
                    });

                    // Load totals
                    document.getElementById('taxRate').value = data.taxRate;
                    document.getElementById('discount').value = data.discount;
                    document.getElementById('notes').value = data.notes;

                    updatePreview();
                    alert('Invoice loaded successfully!');
                } catch (err) {
                    alert('Error loading invoice: ' + err.message);
                }
            };
            reader.readAsText(file);
        };
        input.click();
    }

    // Clear all
    function clearAll() {
        if (confirm('Are you sure you want to clear all data?')) {
            location.reload();
        }
    }
</script>
</div>
<%@ include file="body-close.jsp"%>
</html>
