<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Free Return & Refund Policy Generator & Template (E-commerce) | 8gwifi.org</title>
        <meta name="description"
            content="Generate a free, professional Return & Refund Policy for your e-commerce store or digital product business. Includes clauses for return windows, conditions, and refund methods. No signup required.">
        <meta name="keywords"
            content="return policy generator, refund policy template, e-commerce return policy, free return policy generator, shopify return policy, digital product refund policy, no refund policy generator">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Return & Refund Policy Generator",
      "description": "Generate professional Return & Refund Policies for e-commerce and digital businesses.",
      "url": "https://8gwifi.org/return-refund-policy-generator.jsp",
      "applicationCategory": "BusinessApplication",
      "operatingSystem": "Any",
      "author": {
        "@type": "Person",
        "name": "Anish Nath"
      },
      "datePublished": "2025-12-02",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Free Return Policy Template",
        "Physical & Digital Goods Support",
        "HTML & Markdown Export",
        "Instant Preview"
      ]
    }
    </script>
            <style>
                :root {
                    --theme-primary: #16a34a;
                    --theme-secondary: #4ade80;
                    --theme-gradient: linear-gradient(135deg, #16a34a 0%, #4ade80 100%);
                    --theme-light: #f0fdf4;
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

                .sticky-preview {
                    position: sticky;
                    top: 80px;
                }

                .eeat-badge {
                    background: var(--theme-gradient);
                    color: white;
                    padding: .35rem .75rem;
                    border-radius: 20px;
                    font-size: .75rem;
                    display: inline-flex;
                    align-items: center;
                    gap: .5rem;
                }
            </style>
    </head>
    <%@ include file="body-script.jsp" %>
        <%@ include file="legal-tools-navbar.jsp" %>

            <div class="container-fluid px-lg-5 mt-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-0">Return & Refund Policy Generator</h1>
                        <p class="text-muted mb-0">Create professional return policies for your store</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-undo-alt mr-2"></i> Policy
                                Details</div>
                            <div class="card-body">

                                <!-- General Info -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-store"></i> Store Information</div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Store/Company Name</label>
                                                <input type="text" class="form-control" id="companyName"
                                                    placeholder="My Online Store">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Website URL</label>
                                                <input type="text" class="form-control" id="websiteUrl"
                                                    placeholder="https://example.com">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Contact Email</label>
                                                <input type="email" class="form-control" id="contactEmail"
                                                    placeholder="support@example.com">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Effective Date</label>
                                                <input type="date" class="form-control" id="effectiveDate">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Return Conditions -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-clock"></i> Return Conditions</div>
                                    <div class="form-group">
                                        <label>Return Window (Days)</label>
                                        <select class="form-control" id="returnWindow">
                                            <option value="14">14 Days</option>
                                            <option value="30" selected>30 Days</option>
                                            <option value="60">60 Days</option>
                                            <option value="90">90 Days</option>
                                        </select>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="condUnused" checked>
                                        <label class="custom-control-label" for="condUnused">Item must be unused and in
                                            original condition</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="condPackaging" checked>
                                        <label class="custom-control-label" for="condPackaging">Item must be in original
                                            packaging</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="condReceipt" checked>
                                        <label class="custom-control-label" for="condReceipt">Receipt or proof of
                                            purchase required</label>
                                    </div>
                                </div>

                                <!-- Refund Details -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-money-bill-wave"></i> Refund &
                                        Shipping</div>
                                    <div class="form-group">
                                        <label>Refund Method</label>
                                        <select class="form-control" id="refundMethod">
                                            <option value="original">Original Payment Method</option>
                                            <option value="credit">Store Credit Only</option>
                                            <option value="exchange">Exchange Only</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Return Shipping Costs</label>
                                        <select class="form-control" id="shippingCost">
                                            <option value="customer">Customer pays for return shipping</option>
                                            <option value="store">Store pays for return shipping (Free Returns)</option>
                                        </select>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="digitalGoods">
                                        <label class="custom-control-label" for="digitalGoods">We sell Digital Goods (No
                                            refunds on downloads)</label>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="sticky-preview">
                            <div class="card tool-card mb-3">
                                <div class="card-header bg-white">
                                    <ul class="nav nav-tabs card-header-tabs" id="outputTabs" role="tablist">
                                        <li class="nav-item">
                                            <a class="nav-link active" id="preview-tab" data-toggle="tab"
                                                href="#preview" role="tab" aria-controls="preview"
                                                aria-selected="true"><i class="fas fa-eye"></i> Preview</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" id="html-tab" data-toggle="tab" href="#html" role="tab"
                                                aria-controls="html" aria-selected="false"><i class="fab fa-html5"></i>
                                                HTML</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" id="markdown-tab" data-toggle="tab" href="#markdown"
                                                role="tab" aria-controls="markdown" aria-selected="false"><i
                                                    class="fab fa-markdown"></i> Markdown</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body p-0">
                                    <div class="tab-content" id="outputTabContent">
                                        <div class="tab-pane fade show active" id="preview" role="tabpanel"
                                            aria-labelledby="preview-tab">
                                            <div id="previewOutput" class="preview-box"></div>
                                        </div>
                                        <div class="tab-pane fade" id="html" role="tabpanel" aria-labelledby="html-tab">
                                            <pre id="htmlOutput" class="code-preview mb-0"></pre>
                                        </div>
                                        <div class="tab-pane fade" id="markdown" role="tabpanel"
                                            aria-labelledby="markdown-tab">
                                            <pre id="markdownOutput" class="code-preview mb-0"></pre>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer bg-light d-flex justify-content-end">
                                    <button class="btn btn-sm btn-outline-danger mr-auto" onclick="resetForm()"><i
                                            class="fas fa-undo"></i> Reset</button>
                                    <button class="btn btn-sm btn-outline-dark mr-2" onclick="copyContent()"><i
                                            class="fas fa-copy"></i> Copy</button>
                                    <button class="btn btn-sm btn-primary" onclick="showSupportModal()"><i
                                            class="fas fa-download"></i> Download</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    document.getElementById('effectiveDate').valueAsDate = new Date();
                    generatePolicy();

                    const inputs = document.querySelectorAll('input, select');
                    inputs.forEach(input => {
                        input.addEventListener('input', generatePolicy);
                        input.addEventListener('change', generatePolicy);
                    });
                });

                function generatePolicy() {
                    const companyName = document.getElementById('companyName').value || '[Company Name]';
                    const websiteUrl = document.getElementById('websiteUrl').value || '[Website URL]';
                    const contactEmail = document.getElementById('contactEmail').value || '[Contact Email]';
                    const effectiveDate = document.getElementById('effectiveDate').value;

                    const conditions = {
                        window: document.getElementById('returnWindow').value,
                        unused: document.getElementById('condUnused').checked,
                        packaging: document.getElementById('condPackaging').checked,
                        receipt: document.getElementById('condReceipt').checked
                    };

                    const refund = {
                        method: document.getElementById('refundMethod').value,
                        shipping: document.getElementById('shippingCost').value,
                        digital: document.getElementById('digitalGoods').checked
                    };

                    const html = generateHTML(companyName, websiteUrl, contactEmail, effectiveDate, conditions, refund);
                    const markdown = generateMarkdown(companyName, websiteUrl, contactEmail, effectiveDate, conditions, refund);

                    document.getElementById('previewOutput').innerHTML = html;
                    document.getElementById('htmlOutput').textContent = html;
                    document.getElementById('markdownOutput').textContent = markdown;
                }

                function generateHTML(companyName, websiteUrl, contactEmail, effectiveDate, conditions, refund) {
                    let content = `<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>Return and Refund Policy</title>
    <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
    <h2>Return and Refund Policy</h2>
    <p>Last updated: ${effectiveDate}</p>
    
    <p>Thank you for shopping at ${companyName}.</p>
    <p>If, for any reason, You are not completely satisfied with a purchase We invite You to review our policy on refunds and returns.</p>
    <p>The following terms are applicable for any products that You purchased with Us.</p>
    
    <h3>Interpretation and Definitions</h3>
    <p>The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.</p>
    
    <h3>Your Order Cancellation Rights</h3>
    <p>You are entitled to cancel Your Order within ${conditions.window} days without giving any reason for doing so.</p>
    <p>The deadline for cancelling an Order is ${conditions.window} days from the date on which You received the Goods or on which a third party you have appointed, who is not the carrier, takes possession of the product delivered.</p>
    <p>In order to exercise Your right of cancellation, You must inform Us of your decision by means of a clear statement. You can inform us of your decision by email: ${contactEmail}</p>
    
    <p>We will reimburse You no later than 14 days from the day on which We receive the returned Goods. We will use the same means of payment as You used for the Order, and You will not incur any fees for such reimbursement.</p>
    
    <h3>Conditions for Returns</h3>
    <p>In order for the Goods to be eligible for a return, please make sure that:</p>
    <ul>
        <li>The Goods were purchased in the last ${conditions.window} days</li>
`;
                    if (conditions.unused) content += `        <li>The Goods are in the original packaging</li>\n`;
                    if (conditions.packaging) content += `        <li>The Goods are not used or damaged</li>\n`;
                    if (conditions.receipt) content += `        <li>You have the receipt or proof of purchase</li>\n`;

                    content += `    </ul>
    
    <p>The following Goods cannot be returned:</p>
    <ul>
        <li>The supply of Goods made to Your specifications or clearly personalized.</li>
        <li>The supply of Goods which according to their nature are not suitable to be returned, deteriorate rapidly or where the date of expiry is over.</li>
        <li>The supply of Goods which are not suitable for return due to health protection or hygiene reasons and were unsealed after delivery.</li>
        <li>The supply of Goods which are, after delivery, according to their nature, inseparably mixed with other items.</li>
    </ul>
`;

                    if (refund.digital) {
                        content += `    <h3>Digital Goods</h3>
    <p>We do not issue refunds for digital products once the order is confirmed and the product is sent. We recommend contacting us for assistance if you experience any issues receiving or downloading our products.</p>
`;
                    }

                    content += `    <h3>Returning Goods</h3>
    <p>You are responsible for the cost and risk of returning the Goods to Us. You should send the Goods at the following address:</p>
    <p>[Physical Address Required]</p>
    
    <p>We cannot be held responsible for Goods damaged or lost in return shipment. Therefore, We recommend an insured and trackable mail service. We are unable to issue a refund without actual receipt of the Goods or proof of received return delivery.</p>
`;

                    if (refund.shipping === 'customer') {
                        content += `    <p>Shipping costs are non-refundable. If you receive a refund, the cost of return shipping will be deducted from your refund.</p>\n`;
                    } else {
                        content += `    <p>We will pay for the return shipping costs.</p>\n`;
                    }

                    content += `    <h3>Contact Us</h3>
    <p>If you have any questions about our Returns and Refunds Policy, please contact us at ${contactEmail}.</p>
</body>
</html>`;
                    return content;
                }

                function generateMarkdown(companyName, websiteUrl, contactEmail, effectiveDate, conditions, refund) {
                    let content = `# Return and Refund Policy

Last updated: ${effectiveDate}

Thank you for shopping at ${companyName}.

If, for any reason, You are not completely satisfied with a purchase We invite You to review our policy on refunds and returns.

The following terms are applicable for any products that You purchased with Us.

## Interpretation and Definitions

The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.

## Your Order Cancellation Rights

You are entitled to cancel Your Order within ${conditions.window} days without giving any reason for doing so.

The deadline for cancelling an Order is ${conditions.window} days from the date on which You received the Goods or on which a third party you have appointed, who is not the carrier, takes possession of the product delivered.

In order to exercise Your right of cancellation, You must inform Us of your decision by means of a clear statement. You can inform us of your decision by email: ${contactEmail}

We will reimburse You no later than 14 days from the day on which We receive the returned Goods. We will use the same means of payment as You used for the Order, and You will not incur any fees for such reimbursement.

## Conditions for Returns

In order for the Goods to be eligible for a return, please make sure that:

*   The Goods were purchased in the last ${conditions.window} days
`;
                    if (conditions.unused) content += `*   The Goods are in the original packaging\n`;
                    if (conditions.packaging) content += `*   The Goods are not used or damaged\n`;
                    if (conditions.receipt) content += `*   You have the receipt or proof of purchase\n`;

                    content += `
The following Goods cannot be returned:

*   The supply of Goods made to Your specifications or clearly personalized.
*   The supply of Goods which according to their nature are not suitable to be returned, deteriorate rapidly or where the date of expiry is over.
*   The supply of Goods which are not suitable for return due to health protection or hygiene reasons and were unsealed after delivery.
*   The supply of Goods which are, after delivery, according to their nature, inseparably mixed with other items.
`;

                    if (refund.digital) {
                        content += `
## Digital Goods

We do not issue refunds for digital products once the order is confirmed and the product is sent. We recommend contacting us for assistance if you experience any issues receiving or downloading our products.
`;
                    }

                    content += `
## Returning Goods

You are responsible for the cost and risk of returning the Goods to Us. You should send the Goods at the following address:

[Physical Address Required]

We cannot be held responsible for Goods damaged or lost in return shipment. Therefore, We recommend an insured and trackable mail service. We are unable to issue a refund without actual receipt of the Goods or proof of received return delivery.
`;

                    if (refund.shipping === 'customer') {
                        content += `Shipping costs are non-refundable. If you receive a refund, the cost of return shipping will be deducted from your refund.\n`;
                    } else {
                        content += `We will pay for the return shipping costs.\n`;
                    }

                    content += `
## Contact Us

If you have any questions about our Returns and Refunds Policy, please contact us at ${contactEmail}.
`;
                    return content;
                }

                function showSupportModal() {
                    $('#supportModal').modal('show');
                }

                function proceedDownload() {
                    $('#supportModal').modal('hide');

                    const activeTab = document.querySelector('.tab-pane.active');
                    let content = '';
                    let filename = 'return_policy';

                    if (activeTab.id === 'markdown') {
                        content = document.getElementById('markdownOutput').textContent;
                        filename += '.md';
                    } else {
                        content = document.getElementById('htmlOutput').textContent;
                        filename += '.html';
                    }

                    const blob = new Blob([content], { type: 'text/plain' });
                    const link = document.createElement('a');
                    link.href = URL.createObjectURL(blob);
                    link.download = filename;
                    link.click();
                }

                function copyContent() {
                    const activeTab = document.querySelector('.tab-pane.active');
                    let content = '';
                    if (activeTab.id === 'preview') {
                        content = document.getElementById('htmlOutput').textContent;
                    } else if (activeTab.id === 'html') {
                        content = document.getElementById('htmlOutput').textContent;
                    } else {
                        content = document.getElementById('markdownOutput').textContent;
                    }

                    navigator.clipboard.writeText(content).then(() => {
                        alert('Copied to clipboard!');
                    });
                }

                function resetForm() {
                    if (confirm('Are you sure you want to reset all fields?')) {
                        const inputs = document.querySelectorAll('input');
                        inputs.forEach(input => {
                            if (input.type === 'checkbox') {
                                if (input.id !== 'digitalGoods') input.checked = true;
                                else input.checked = false;
                            }
                            else if (input.type !== 'date') input.value = '';
                        });
                        document.getElementById('returnWindow').value = '30';
                        document.getElementById('refundMethod').value = 'original';
                        document.getElementById('shippingCost').value = 'customer';
                        generatePolicy();
                    }
                }
            </script>

            <!-- Support Modal -->
            <div class="modal fade" id="supportModal" tabindex="-1" role="dialog" aria-labelledby="supportModalLabel"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header border-0 pb-0">
                            <h5 class="modal-title" id="supportModalLabel">❤️ Support This Free Tool</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body text-center pt-4">
                            <p class="lead mb-4">This tool is free forever! Please support us by following
                                <strong>@anish2good</strong> on Twitter.
                            </p>

                            <div class="d-flex justify-content-center gap-3 mb-4">
                                <a href="https://twitter.com/anish2good" target="_blank"
                                    class="btn btn-info text-white mr-2">
                                    <i class="fab fa-twitter"></i> Follow @anish2good
                                </a>
                                <a href="https://twitter.com/intent/tweet?text=Check%20out%20this%20awesome%20Free%20Return%20Policy%20Generator!%20%23devops%20%23ecommerce%20https://8gwifi.org/return-refund-policy-generator.jsp"
                                    target="_blank" class="btn btn-outline-info">
                                    <i class="fab fa-twitter"></i> Tweet
                                </a>
                            </div>

                            <p class="text-muted small">Your download is ready.</p>
                        </div>
                        <div class="modal-footer border-0 justify-content-center pb-4">
                            <button type="button" class="btn btn-primary btn-lg px-5" onclick="proceedDownload()">
                                <i class="fas fa-download"></i> Download Now
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="sharethis-inline-share-buttons"></div>
            <%@ include file="footer_adsense.jsp" %>
                <%@ include file="thanks.jsp" %>
                    <hr>
                    <%@ include file="addcomments.jsp" %>
                        </div>
                        <%@ include file="body-close.jsp" %>

    </html>