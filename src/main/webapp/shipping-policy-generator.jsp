<!DOCTYPE html>
<html lang="en">

<head>
    <title>Shipping Policy Generator - Free for E-commerce | 8gwifi.org</title>
    <meta name="description"
        content="Generate a professional Shipping Policy for your e-commerce store. Clear shipping rates, processing times, and international shipping rules. Free and easy to use.">
    <meta name="keywords"
        content="shipping policy generator, ecommerce shipping policy, free shipping policy template, shipping terms generator, online store policy">
    <%@ include file="header-script.jsp" %>

        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Shipping Policy Generator",
      "url": "https://8gwifi.org/shipping-policy-generator.jsp",
      "description": "Generate a professional Shipping Policy for your e-commerce store.",
      "applicationCategory": "BusinessApplication",
      "operatingSystem": "Any",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Processing Time",
        "Shipping Rates",
        "International Shipping",
        "Tracking Info",
        "HTML & Markdown Export"
      ]
    }
    </script>

        <style>
            :root {
                --theme-primary: #4f46e5;
                --theme-secondary: #818cf8;
                --theme-gradient: linear-gradient(135deg, #4f46e5 0%, #818cf8 100%);
                --theme-light: #eef2ff;
            }

            .tool-card {
                border: none;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, .1);
                transition: transform 0.2s;
            }

            .card-header-custom {
                background: var(--theme-gradient);
                color: white;
                font-weight: 600;
            }

            .form-section {
                background-color: var(--theme-light);
                padding: 1.5rem;
                border-radius: .5rem;
                margin-bottom: 1.5rem;
                border-left: 4px solid var(--theme-primary);
            }

            .form-section-title {
                color: var(--theme-primary);
                font-weight: 700;
                margin-bottom: 1rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                font-size: 1.1rem;
            }

            .preview-box {
                background: white;
                border: 1px solid #e2e8f0;
                padding: 2rem;
                border-radius: 4px;
                min-height: 500px;
                max-height: 800px;
                overflow-y: auto;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
            }

            .code-preview {
                background: #1e293b;
                color: #e2e8f0;
                padding: 1rem;
                border-radius: 4px;
                font-family: 'Courier New', monospace;
                font-size: .85rem;
                white-space: pre-wrap;
                min-height: 500px;
                max-height: 800px;
                overflow-y: auto;
            }

            .nav-tabs .nav-link.active {
                font-weight: bold;
                color: var(--theme-primary);
                border-bottom: 3px solid var(--theme-primary);
            }
        </style>
</head>

<body>
    <%@ include file="legal-tools-navbar.jsp" %>

        <div class="container-fluid px-lg-5 mt-4">
            <div class="row mb-4">
                <div class="col-12">
                    <h1 class="h3 mb-2 text-gray-800">
                        <i class="fas fa-shipping-fast text-info mr-2"></i>Shipping Policy Generator
                    </h1>
                    <p class="text-muted">Create a clear Shipping Policy to set customer expectations for your online
                        store.</p>
                </div>
            </div>

            <div class="row">
                <!-- Input Form -->
                <div class="col-lg-5">
                    <form id="shippingForm">
                        <!-- Store Info -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <i class="fas fa-store"></i> Store Information
                            </div>
                            <div class="form-group">
                                <label for="storeName">Store Name</label>
                                <input type="text" class="form-control" id="storeName"
                                    placeholder="e.g., My Awesome Shop">
                            </div>
                            <div class="form-group">
                                <label for="contactEmail">Support Email</label>
                                <input type="email" class="form-control" id="contactEmail"
                                    placeholder="support@example.com">
                            </div>
                            <div class="form-group">
                                <label for="effectiveDate">Effective Date</label>
                                <input type="date" class="form-control" id="effectiveDate">
                            </div>
                        </div>

                        <!-- Processing & Rates -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <i class="fas fa-clock"></i> Processing & Rates
                            </div>
                            <div class="form-group">
                                <label for="processingTime">Order Processing Time</label>
                                <select class="form-control" id="processingTime">
                                    <option value="1-2 business days">1-2 business days</option>
                                    <option value="2-3 business days">2-3 business days</option>
                                    <option value="3-5 business days">3-5 business days</option>
                                    <option value="5-7 business days">5-7 business days</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="shippingRates">Shipping Rates Calculation</label>
                                <select class="form-control" id="shippingRates">
                                    <option value="calculated">Calculated at checkout (based on weight/location)
                                    </option>
                                    <option value="flat">Flat rate shipping</option>
                                    <option value="free">Free shipping on all orders</option>
                                    <option value="threshold">Free shipping over a certain amount</option>
                                </select>
                            </div>
                        </div>

                        <!-- Delivery Options -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <i class="fas fa-globe"></i> Delivery Options
                            </div>

                            <div class="custom-control custom-switch mb-3">
                                <input type="checkbox" class="custom-control-input" id="internationalShipping" checked>
                                <label class="custom-control-label" for="internationalShipping">We ship
                                    internationally</label>
                            </div>

                            <div class="custom-control custom-switch mb-3">
                                <input type="checkbox" class="custom-control-input" id="poBoxes" checked>
                                <label class="custom-control-label" for="poBoxes">We ship to P.O. Boxes</label>
                            </div>

                            <div class="custom-control custom-switch mb-3">
                                <input type="checkbox" class="custom-control-input" id="localPickup">
                                <label class="custom-control-label" for="localPickup">Offer Local Pickup</label>
                            </div>
                        </div>

                        <div class="text-center mb-5">
                            <button type="button" class="btn btn-secondary mr-2" onclick="resetForm()">Reset</button>
                            <button type="button" class="btn btn-primary btn-lg" onclick="generatePolicy()">
                                <i class="fas fa-magic mr-2"></i>Generate Policy
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Preview Section -->
                <div class="col-lg-7">
                    <div class="card tool-card mb-4">
                        <div
                            class="card-header card-header-custom py-3 d-flex flex-row align-items-center justify-content-between">
                            <ul class="nav nav-tabs card-header-tabs" id="previewTabs" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active text-white" id="html-tab" data-toggle="tab"
                                        href="#htmlPreview" role="tab">HTML</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link text-white" id="markdown-tab" data-toggle="tab"
                                        href="#markdownPreview" role="tab">Markdown</a>
                                </li>
                            </ul>
                            <div>
                                <button class="btn btn-sm btn-light mr-1" onclick="copyContent()">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                                <button class="btn btn-sm btn-light" onclick="downloadContent()">
                                    <i class="fas fa-download"></i> Download
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="tab-content" id="previewTabContent">
                                <div class="tab-pane fade show active" id="htmlPreview" role="tabpanel">
                                    <div id="htmlContent" class="preview-box"></div>
                                </div>
                                <div class="tab-pane fade" id="markdownPreview" role="tabpanel">
                                    <pre id="markdownContent" class="code-preview"></pre>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- SEO Content -->
                    <div class="card tool-card mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Why a Shipping Policy Matters?</h6>
                        </div>
                        <div class="card-body">
                            <p>A clear Shipping Policy is crucial for e-commerce success. It manages customer
                                expectations regarding delivery times and costs, reducing support inquiries and
                                disputes.</p>
                            <ul>
                                <li><strong>Transparency:</strong> Customers know exactly when to expect their orders.
                                </li>
                                <li><strong>Trust:</strong> Clear policies on lost packages and customs duties build
                                    confidence.</li>
                                <li><strong>Protection:</strong> Defines your liability for shipping delays outside your
                                    control.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Support Modal -->
        <div class="modal fade" id="supportModal" tabindex="-1" role="dialog" aria-labelledby="supportModalLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="supportModalLabel"><i class="fas fa-heart mr-2"></i>Support Free
                            Tools</h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body text-center">
                        <p class="lead">Your file is ready to download!</p>
                        <p>We provide these tools for free. Please help us reach more developers by following us or
                            tweeting about it.</p>
                        <div class="my-4">
                            <a href="https://twitter.com/anish_nath?ref_src=twsrc%5Etfw" class="twitter-follow-button"
                                data-size="large" data-show-count="true">Follow @anish_nath</a>
                            <div class="mt-3">
                                <a href="https://twitter.com/share?ref_src=twsrc%5Etfw" class="twitter-share-button"
                                    data-size="large"
                                    data-text="Check out this free Shipping Policy Generator! #ecommerce #shopify"
                                    data-url="https://8gwifi.org/shipping-policy-generator.jsp" data-via="anish_nath"
                                    data-hashtags="onlinestore,business">Tweet</a>
                            </div>
                        </div>
                        <p class="small text-muted">The download will start automatically...</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Set default date to today
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('effectiveDate').value = today;

                // Generate initial preview
                generatePolicy();

                // Add event listeners for real-time updates
                const inputs = document.querySelectorAll('input, textarea, select');
                inputs.forEach(input => {
                    input.addEventListener('input', generatePolicy);
                });
            });

            function generatePolicy() {
                const storeName = document.getElementById('storeName').value || '[Store Name]';
                const contactEmail = document.getElementById('contactEmail').value || '[Email]';
                const effectiveDate = document.getElementById('effectiveDate').value || '[Date]';

                const processingTime = document.getElementById('processingTime').value;
                const shippingRates = document.getElementById('shippingRates').value;

                const options = {
                    international: document.getElementById('internationalShipping').checked,
                    poBoxes: document.getElementById('poBoxes').checked,
                    localPickup: document.getElementById('localPickup').checked
                };

                const html = generateHTML(storeName, contactEmail, effectiveDate, processingTime, shippingRates, options);
                const markdown = generateMarkdown(storeName, contactEmail, effectiveDate, processingTime, shippingRates, options);

                document.getElementById('htmlContent').innerHTML = html;
                document.getElementById('markdownContent').textContent = markdown;
            }

            function generateHTML(storeName, contactEmail, effectiveDate, processingTime, shippingRates, options) {
                let ratesText = "";
                switch (shippingRates) {
                    case 'calculated': ratesText = "Shipping charges for your order will be calculated and displayed at checkout."; break;
                    case 'flat': ratesText = "We offer flat rate shipping for all orders."; break;
                    case 'free': ratesText = "We offer free shipping on all orders."; break;
                    case 'threshold': ratesText = "Shipping is free for orders over a certain amount. For orders under that amount, shipping charges will be calculated at checkout."; break;
                }

                let content = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Shipping Policy - ${storeName}</title>
    <style>
        body { font-family: sans-serif; line-height: 1.6; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1, h2 { color: #333; }
    </style>
</head>
<body>
    <h1>Shipping Policy</h1>
    <p><strong>Effective Date:</strong> ${effectiveDate}</p>
    
    <p>Thank you for visiting and shopping at ${storeName}. Following are the terms and conditions that constitute our Shipping Policy.</p>

    <h2>1. Shipment Processing Time</h2>
    <p>All orders are processed within <strong>${processingTime}</strong>. Orders are not shipped or delivered on weekends or holidays.</p>
    <p>If we are experiencing a high volume of orders, shipments may be delayed by a few days. Please allow additional days in transit for delivery. If there will be a significant delay in shipment of your order, we will contact you via email or telephone.</p>

    <h2>2. Shipping Rates & Delivery Estimates</h2>
    <p>${ratesText}</p>
    <p>Delivery delays can occasionally occur.</p>`;

                if (options.poBoxes) {
                    content += `
    <h2>3. Shipment to P.O. boxes or APO/FPO addresses</h2>
    <p>${storeName} ships to addresses within the U.S., U.S. Territories, and APO/FPO/DPO addresses.</p>`;
                }

                if (options.international) {
                    content += `
    <h2>4. International Shipping Policy</h2>
    <p>We currently ship outside the U.S.</p>
    <p><strong>Customs, Duties and Taxes:</strong> ${storeName} is not responsible for any customs and taxes applied to your order. All fees imposed during or after shipping are the responsibility of the customer (tariffs, taxes, etc.).</p>`;
                }

                if (options.localPickup) {
                    content += `
    <h2>5. Local Pickup</h2>
    <p>You can skip the shipping fees with free local pickup. After placing your order and selecting local pickup at checkout, your order will be prepared and ready for pick up within ${processingTime}. We will send you an email when your order is ready along with instructions.</p>`;
                }

                content += `
    <h2>6. Shipment Confirmation & Order Tracking</h2>
    <p>You will receive a Shipment Confirmation email once your order has shipped containing your tracking number(s). The tracking number will be active within 24 hours.</p>

    <h2>7. Damages</h2>
    <p>${storeName} is not liable for any products damaged or lost during shipping. If you received your order damaged, please contact the shipment carrier to file a claim.</p>
    <p>Please save all packaging materials and damaged goods before filing a claim.</p>

    <h2>Contact Us</h2>
    <p>If you have any questions about this Shipping Policy, please contact us:</p>
    <ul>
        <li>By email: ${contactEmail}</li>
    </ul>
</body>
</html>`;
                return content;
            }

            function generateMarkdown(storeName, contactEmail, effectiveDate, processingTime, shippingRates, options) {
                let ratesText = "";
                switch (shippingRates) {
                    case 'calculated': ratesText = "Shipping charges for your order will be calculated and displayed at checkout."; break;
                    case 'flat': ratesText = "We offer flat rate shipping for all orders."; break;
                    case 'free': ratesText = "We offer free shipping on all orders."; break;
                    case 'threshold': ratesText = "Shipping is free for orders over a certain amount. For orders under that amount, shipping charges will be calculated at checkout."; break;
                }

                let content = `# Shipping Policy
**Effective Date:** ${effectiveDate}

Thank you for visiting and shopping at ${storeName}. Following are the terms and conditions that constitute our Shipping Policy.

## 1. Shipment Processing Time
All orders are processed within **${processingTime}**. Orders are not shipped or delivered on weekends or holidays.

If we are experiencing a high volume of orders, shipments may be delayed by a few days. Please allow additional days in transit for delivery. If there will be a significant delay in shipment of your order, we will contact you via email or telephone.

## 2. Shipping Rates & Delivery Estimates
${ratesText}

Delivery delays can occasionally occur.
`;

                if (options.poBoxes) {
                    content += `
## 3. Shipment to P.O. boxes or APO/FPO addresses
${storeName} ships to addresses within the U.S., U.S. Territories, and APO/FPO/DPO addresses.
`;
                }

                if (options.international) {
                    content += `
## 4. International Shipping Policy
We currently ship outside the U.S.

**Customs, Duties and Taxes:** ${storeName} is not responsible for any customs and taxes applied to your order. All fees imposed during or after shipping are the responsibility of the customer (tariffs, taxes, etc.).
`;
                }

                if (options.localPickup) {
                    content += `
## 5. Local Pickup
You can skip the shipping fees with free local pickup. After placing your order and selecting local pickup at checkout, your order will be prepared and ready for pick up within ${processingTime}. We will send you an email when your order is ready along with instructions.
`;
                }

                content += `
## 6. Shipment Confirmation & Order Tracking
You will receive a Shipment Confirmation email once your order has shipped containing your tracking number(s). The tracking number will be active within 24 hours.

## 7. Damages
${storeName} is not liable for any products damaged or lost during shipping. If you received your order damaged, please contact the shipment carrier to file a claim.

Please save all packaging materials and damaged goods before filing a claim.

## Contact Us
If you have any questions about this Shipping Policy, please contact us:
* By email: ${contactEmail}
`;
                return content;
            }

            function showSupportModal() {
                $('#supportModal').modal('show');
            }

            function downloadContent() {
                showSupportModal();
                setTimeout(proceedDownload, 2000);
            }

            function proceedDownload() {
                const activeTab = document.querySelector('.nav-link.active').id;
                let content = '';
                let filename = '';
                let mimeType = '';

                if (activeTab === 'html-tab') {
                    const storeName = document.getElementById('storeName').value || '[Store Name]';
                    const contactEmail = document.getElementById('contactEmail').value || '[Email]';
                    const effectiveDate = document.getElementById('effectiveDate').value || '[Date]';
                    const processingTime = document.getElementById('processingTime').value;
                    const shippingRates = document.getElementById('shippingRates').value;
                    const options = {
                        international: document.getElementById('internationalShipping').checked,
                        poBoxes: document.getElementById('poBoxes').checked,
                        localPickup: document.getElementById('localPickup').checked
                    };
                    content = generateHTML(storeName, contactEmail, effectiveDate, processingTime, shippingRates, options);
                    filename = 'shipping-policy.html';
                    mimeType = 'text/html';
                } else {
                    content = document.getElementById('markdownContent').textContent;
                    filename = 'shipping-policy.md';
                    mimeType = 'text/markdown';
                }

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

            function copyContent() {
                const activeTab = document.querySelector('.nav-link.active').id;
                let content = '';

                if (activeTab === 'html-tab') {
                    const storeName = document.getElementById('storeName').value || '[Store Name]';
                    const contactEmail = document.getElementById('contactEmail').value || '[Email]';
                    const effectiveDate = document.getElementById('effectiveDate').value || '[Date]';
                    const processingTime = document.getElementById('processingTime').value;
                    const shippingRates = document.getElementById('shippingRates').value;
                    const options = {
                        international: document.getElementById('internationalShipping').checked,
                        poBoxes: document.getElementById('poBoxes').checked,
                        localPickup: document.getElementById('localPickup').checked
                    };
                    content = generateHTML(storeName, contactEmail, effectiveDate, processingTime, shippingRates, options);
                } else {
                    content = document.getElementById('markdownContent').textContent;
                }

                navigator.clipboard.writeText(content).then(() => {
                    const btn = document.querySelector('.btn-light');
                    const originalText = btn.innerHTML;
                    btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                    setTimeout(() => {
                        btn.innerHTML = originalText;
                    }, 2000);
                });
            }

            function resetForm() {
                document.getElementById('shippingForm').reset();
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('effectiveDate').value = today;
                generatePolicy();
            }
        </script>
</body>

</html>