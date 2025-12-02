<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Free Disclaimer Generator & Template (Website & Blog) | 8gwifi.org</title>
        <meta name="description"
            content="Generate a free, professional Disclaimer for your website, blog, or app. Includes clauses for external links, professional advice (medical/legal/financial), affiliates, and testimonials. No signup required.">
        <meta name="keywords"
            content="disclaimer generator, free disclaimer template, website disclaimer generator, blog disclaimer, affiliate disclaimer, medical disclaimer, legal disclaimer, financial disclaimer, disclaimer sample">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Disclaimer Generator",
      "description": "Generate professional legal disclaimers for websites, blogs, and applications.",
      "url": "https://8gwifi.org/disclaimer-generator.jsp",
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
        "Free Disclaimer Template",
        "Affiliate & Testimonial Clauses",
        "Medical/Legal/Financial Advice Disclaimers",
        "HTML & Markdown Export",
        "Instant Preview"
      ]
    }
    </script>
            <style>
                :root {
                    --theme-primary: #dc2626;
                    --theme-secondary: #ef4444;
                    --theme-gradient: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
                    --theme-light: #fef2f2;
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
                        <h1 class="h3 mb-0">Disclaimer Generator</h1>
                        <p class="text-muted mb-0">Create professional legal disclaimers for your website or blog</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-exclamation-triangle mr-2"></i>
                                Disclaimer Details</div>
                            <div class="card-body">

                                <!-- General Info -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-globe"></i> Website Information
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Website Name</label>
                                                <input type="text" class="form-control" id="websiteName"
                                                    placeholder="My Awesome Blog">
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

                                <!-- Specific Disclaimers -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-list-ul"></i> Specific Disclaimers
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="discExternalLinks"
                                            checked>
                                        <label class="custom-control-label" for="discExternalLinks">External Links
                                            Disclaimer</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="discAffiliate">
                                        <label class="custom-control-label" for="discAffiliate">Affiliate Disclaimer
                                            (Amazon, etc.)</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="discTestimonials">
                                        <label class="custom-control-label" for="discTestimonials">Testimonials
                                            Disclaimer</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="discErrors" checked>
                                        <label class="custom-control-label" for="discErrors">Errors and Omissions
                                            Disclaimer</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="discFairUse">
                                        <label class="custom-control-label" for="discFairUse">Fair Use
                                            Disclaimer</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="discViews" checked>
                                        <label class="custom-control-label" for="discViews">Views Expressed
                                            Disclaimer</label>
                                    </div>
                                </div>

                                <!-- Professional Advice -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-user-md"></i> Professional Advice
                                    </div>
                                    <p class="small text-muted mb-2">Select if your site provides information in these
                                        areas:</p>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="adviceMedical">
                                        <label class="custom-control-label" for="adviceMedical">Medical/Health
                                            Advice</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="adviceLegal">
                                        <label class="custom-control-label" for="adviceLegal">Legal Advice</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="adviceFinancial">
                                        <label class="custom-control-label" for="adviceFinancial">Financial/Investment
                                            Advice</label>
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
                    generateDisclaimer();

                    const inputs = document.querySelectorAll('input, select');
                    inputs.forEach(input => {
                        input.addEventListener('input', generateDisclaimer);
                        input.addEventListener('change', generateDisclaimer);
                    });
                });

                function generateDisclaimer() {
                    const websiteName = document.getElementById('websiteName').value || '[Website Name]';
                    const websiteUrl = document.getElementById('websiteUrl').value || '[Website URL]';
                    const contactEmail = document.getElementById('contactEmail').value || '[Contact Email]';
                    const effectiveDate = document.getElementById('effectiveDate').value;

                    const clauses = {
                        externalLinks: document.getElementById('discExternalLinks').checked,
                        affiliate: document.getElementById('discAffiliate').checked,
                        testimonials: document.getElementById('discTestimonials').checked,
                        errors: document.getElementById('discErrors').checked,
                        fairUse: document.getElementById('discFairUse').checked,
                        views: document.getElementById('discViews').checked,
                        medical: document.getElementById('adviceMedical').checked,
                        legal: document.getElementById('adviceLegal').checked,
                        financial: document.getElementById('adviceFinancial').checked
                    };

                    const html = generateHTML(websiteName, websiteUrl, contactEmail, effectiveDate, clauses);
                    const markdown = generateMarkdown(websiteName, websiteUrl, contactEmail, effectiveDate, clauses);

                    document.getElementById('previewOutput').innerHTML = html;
                    document.getElementById('htmlOutput').textContent = html;
                    document.getElementById('markdownOutput').textContent = markdown;
                }

                function generateHTML(websiteName, websiteUrl, contactEmail, effectiveDate, clauses) {
                    let content = `<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>Disclaimer</title>
    <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
    <h2>Disclaimer</h2>
    <p>Last updated: ${effectiveDate}</p>
    
    <h3>Interpretation and Definitions</h3>
    <p>The information contained on the ${websiteUrl} website (the "Service") is for general information purposes only.</p>
    <p>${websiteName} assumes no responsibility for errors or omissions in the contents of the Service.</p>
    <p>In no event shall ${websiteName} be liable for any special, direct, indirect, consequential, or incidental damages or any damages whatsoever, whether in an action of contract, negligence or other tort, arising out of or in connection with the use of the Service or the contents of the Service. ${websiteName} reserves the right to make additions, deletions, or modifications to the contents on the Service at any time without prior notice.</p>
    <p>${websiteName} does not warrant that the Service is free of viruses or other harmful components.</p>
`;

                    if (clauses.externalLinks) {
                        content += `    <h3>External Links Disclaimer</h3>
    <p>The Service may contain links to external websites that are not provided or maintained by or in any way affiliated with ${websiteName}.</p>
    <p>Please note that the ${websiteName} does not guarantee the accuracy, relevance, timeliness, or completeness of any information on these external websites.</p>
`;
                    }

                    if (clauses.errors) {
                        content += `    <h3>Errors and Omissions Disclaimer</h3>
    <p>The information given by the Service is for general guidance on matters of interest only. Even if ${websiteName} takes every precaution to insure that the content of the Service is both current and accurate, errors can occur. Plus, given the changing nature of laws, rules and regulations, there may be delays, omissions or inaccuracies in the information contained on the Service.</p>
    <p>${websiteName} is not responsible for any errors or omissions, or for the results obtained from the use of this information.</p>
`;
                    }

                    if (clauses.fairUse) {
                        content += `    <h3>Fair Use Disclaimer</h3>
    <p>${websiteName} may use copyrighted material which has not always been specifically authorized by the copyright owner. ${websiteName} is making such material available for criticism, comment, news reporting, teaching, scholarship, or research.</p>
    <p>${websiteName} believes this constitutes a "fair use" of any such copyrighted material as provided for in section 107 of the United States Copyright law.</p>
`;
                    }

                    if (clauses.views) {
                        content += `    <h3>Views Expressed Disclaimer</h3>
    <p>The Service may contain views and opinions which are those of the authors and do not necessarily reflect the official policy or position of any other author, agency, organization, employer or company, including ${websiteName}.</p>
    <p>Comments published by users are their sole responsibility and the users will take full responsibility, liability and blame for any libel or litigation that results from something written in or as a direct result of something written in a comment. ${websiteName} is not liable for any comment published by users and reserves the right to delete any comment for any reason whatsoever.</p>
`;
                    }

                    if (clauses.affiliate) {
                        content += `    <h3>Affiliate Disclaimer</h3>
    <p>This disclosure details the affiliate relationships of ${websiteName} with other companies and products.</p>
    <p>Some of the links are "affiliate links", a link with a special tracking code. This means if you click on an affiliate link and purchase the item, we will receive an affiliate commission.</p>
    <p>The price of the item is the same whether it is an affiliate link or not. Regardless, we only recommend products or services we believe will add value to our readers.</p>
    <p>By using the affiliate links, you are helping support the Service, and we genuinely appreciate your support.</p>
`;
                    }

                    if (clauses.testimonials) {
                        content += `    <h3>Testimonials Disclaimer</h3>
    <p>The Service may contain testimonials by users of our products and/or services. These testimonials reflect the real-life experiences and opinions of such users. However, the experiences are personal to those particular users, and may not necessarily be representative of all users of our products and/or services. We do not claim, and you should not assume, that all users will have the same experiences. Your individual results may vary.</p>
`;
                    }

                    if (clauses.medical) {
                        content += `    <h3>Medical Information Disclaimer</h3>
    <p>The information about health provided by the Service is not intended to diagnose, treat, cure or prevent any disease. Products, services, information and other content provided on the Service, including information that may be provided on the Service directly or by linking to third-party websites are provided for informational purposes only.</p>
    <p>Information offered by the Service is not comprehensive and does not cover all diseases, ailments, physical conditions or their treatment.</p>
    <p>Individuals are different and may react differently to different products. Comments made on the Service by employees or other users are strictly their own personal views made in their own personal capacity and are not claims made by ${websiteName} nor do they represent the position or view of ${websiteName}.</p>
    <p>${websiteName} is not liable for any information provided on the Service with regard to recommendations regarding supplements for any health purposes.</p>
`;
                    }

                    if (clauses.legal) {
                        content += `    <h3>Legal Advice Disclaimer</h3>
    <p>The information contained on the Service is not legal advice and is not guaranteed to be correct, complete or up-to-date. Therefore, if you need legal advice for your specific problem, or if your specific problem is too complex to be addressed by our tools, you should consult a licensed attorney in your area.</p>
`;
                    }

                    if (clauses.financial) {
                        content += `    <h3>Financial Advice Disclaimer</h3>
    <p>The Service does not provide financial advice. The information is provided for educational and informational purposes only and should not be construed as professional financial advice. You should consult with a professional financial advisor before making any investment decisions.</p>
`;
                    }

                    content += `    <h3>Contact Us</h3>
    <p>If you have any questions about this Disclaimer, You can contact us at ${contactEmail}.</p>
</body>
</html>`;
                    return content;
                }

                function generateMarkdown(websiteName, websiteUrl, contactEmail, effectiveDate, clauses) {
                    let content = `# Disclaimer

Last updated: ${effectiveDate}

## Interpretation and Definitions

The information contained on the ${websiteUrl} website (the "Service") is for general information purposes only.

${websiteName} assumes no responsibility for errors or omissions in the contents of the Service.

In no event shall ${websiteName} be liable for any special, direct, indirect, consequential, or incidental damages or any damages whatsoever, whether in an action of contract, negligence or other tort, arising out of or in connection with the use of the Service or the contents of the Service. ${websiteName} reserves the right to make additions, deletions, or modifications to the contents on the Service at any time without prior notice.

${websiteName} does not warrant that the Service is free of viruses or other harmful components.
`;

                    if (clauses.externalLinks) {
                        content += `
## External Links Disclaimer

The Service may contain links to external websites that are not provided or maintained by or in any way affiliated with ${websiteName}.

Please note that the ${websiteName} does not guarantee the accuracy, relevance, timeliness, or completeness of any information on these external websites.
`;
                    }

                    if (clauses.errors) {
                        content += `
## Errors and Omissions Disclaimer

The information given by the Service is for general guidance on matters of interest only. Even if ${websiteName} takes every precaution to insure that the content of the Service is both current and accurate, errors can occur. Plus, given the changing nature of laws, rules and regulations, there may be delays, omissions or inaccuracies in the information contained on the Service.

${websiteName} is not responsible for any errors or omissions, or for the results obtained from the use of this information.
`;
                    }

                    if (clauses.fairUse) {
                        content += `
## Fair Use Disclaimer

${websiteName} may use copyrighted material which has not always been specifically authorized by the copyright owner. ${websiteName} is making such material available for criticism, comment, news reporting, teaching, scholarship, or research.

${websiteName} believes this constitutes a "fair use" of any such copyrighted material as provided for in section 107 of the United States Copyright law.
`;
                    }

                    if (clauses.views) {
                        content += `
## Views Expressed Disclaimer

The Service may contain views and opinions which are those of the authors and do not necessarily reflect the official policy or position of any other author, agency, organization, employer or company, including ${websiteName}.

Comments published by users are their sole responsibility and the users will take full responsibility, liability and blame for any libel or litigation that results from something written in or as a direct result of something written in a comment. ${websiteName} is not liable for any comment published by users and reserves the right to delete any comment for any reason whatsoever.
`;
                    }

                    if (clauses.affiliate) {
                        content += `
## Affiliate Disclaimer

This disclosure details the affiliate relationships of ${websiteName} with other companies and products.

Some of the links are "affiliate links", a link with a special tracking code. This means if you click on an affiliate link and purchase the item, we will receive an affiliate commission.

The price of the item is the same whether it is an affiliate link or not. Regardless, we only recommend products or services we believe will add value to our readers.

By using the affiliate links, you are helping support the Service, and we genuinely appreciate your support.
`;
                    }

                    if (clauses.testimonials) {
                        content += `
## Testimonials Disclaimer

The Service may contain testimonials by users of our products and/or services. These testimonials reflect the real-life experiences and opinions of such users. However, the experiences are personal to those particular users, and may not necessarily be representative of all users of our products and/or services. We do not claim, and you should not assume, that all users will have the same experiences. Your individual results may vary.
`;
                    }

                    if (clauses.medical) {
                        content += `
## Medical Information Disclaimer

The information about health provided by the Service is not intended to diagnose, treat, cure or prevent any disease. Products, services, information and other content provided on the Service, including information that may be provided on the Service directly or by linking to third-party websites are provided for informational purposes only.

Information offered by the Service is not comprehensive and does not cover all diseases, ailments, physical conditions or their treatment.

Individuals are different and may react differently to different products. Comments made on the Service by employees or other users are strictly their own personal views made in their own personal capacity and are not claims made by ${websiteName} nor do they represent the position or view of ${websiteName}.

${websiteName} is not liable for any information provided on the Service with regard to recommendations regarding supplements for any health purposes.
`;
                    }

                    if (clauses.legal) {
                        content += `
## Legal Advice Disclaimer

The information contained on the Service is not legal advice and is not guaranteed to be correct, complete or up-to-date. Therefore, if you need legal advice for your specific problem, or if your specific problem is too complex to be addressed by our tools, you should consult a licensed attorney in your area.
`;
                    }

                    if (clauses.financial) {
                        content += `
## Financial Advice Disclaimer

The Service does not provide financial advice. The information is provided for educational and informational purposes only and should not be construed as professional financial advice. You should consult with a professional financial advisor before making any investment decisions.
`;
                    }

                    content += `
## Contact Us

If you have any questions about this Disclaimer, You can contact us at ${contactEmail}.
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
                    let filename = 'disclaimer';

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
                                // Reset defaults
                                if (['discExternalLinks', 'discErrors', 'discViews'].includes(input.id)) input.checked = true;
                                else input.checked = false;
                            }
                            else if (input.type !== 'date') input.value = '';
                        });
                        generateDisclaimer();
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
                                <a href="https://twitter.com/intent/tweet?text=Check%20out%20this%20awesome%20Free%20Disclaimer%20Generator!%20%23devops%20%23legal%20https://8gwifi.org/disclaimer-generator.jsp"
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