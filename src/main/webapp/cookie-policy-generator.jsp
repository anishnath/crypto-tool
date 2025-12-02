<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Free Cookie Policy Generator & Template (GDPR/ePrivacy) | 8gwifi.org</title>
        <meta name="description"
            content="Generate a free, GDPR & ePrivacy compliant Cookie Policy for your website. Includes standard clauses for essential, analytics, and advertising cookies. No signup required.">
        <meta name="keywords"
            content="cookie policy generator, free cookie policy template, gdpr cookie policy, eu cookie law generator, cookie consent policy, website cookie policy, cookie policy sample">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Cookie Policy Generator",
      "description": "Generate professional Cookie Policies for websites compliant with GDPR and ePrivacy Directive.",
      "url": "https://8gwifi.org/cookie-policy-generator.jsp",
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
        "Free Cookie Policy Template",
        "GDPR & ePrivacy Compliant",
        "HTML & Markdown Export",
        "Instant Preview"
      ]
    }
    </script>
            <style>
                :root {
                    --theme-primary: #ea580c;
                    --theme-secondary: #fb923c;
                    --theme-gradient: linear-gradient(135deg, #ea580c 0%, #fb923c 100%);
                    --theme-light: #fff7ed;
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
                        <h1 class="h3 mb-0">Cookie Policy Generator</h1>
                        <p class="text-muted mb-0">Create GDPR & ePrivacy compliant Cookie Policies for your website</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-cookie-bite mr-2"></i> Policy
                                Details</div>
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
                                                    placeholder="My Awesome Site">
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

                                <!-- Cookie Types -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-list"></i> Cookie Types Used</div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="cookieEssential" checked
                                            disabled>
                                        <label class="custom-control-label" for="cookieEssential">Essential/Strictly
                                            Necessary Cookies (Required)</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="cookieAnalytics"
                                            checked>
                                        <label class="custom-control-label" for="cookieAnalytics">Analytics/Performance
                                            Cookies (Google Analytics, etc.)</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="cookieFunctionality"
                                            checked>
                                        <label class="custom-control-label" for="cookieFunctionality">Functionality
                                            Cookies (Preferences, Settings)</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="cookieAdvertising"
                                            checked>
                                        <label class="custom-control-label"
                                            for="cookieAdvertising">Advertising/Targeting Cookies (AdSense, Facebook
                                            Pixel)</label>
                                    </div>
                                </div>

                                <!-- Third Party Services -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-share-alt"></i> Third Party
                                        Services</div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input" id="svcGoogle"
                                                    checked>
                                                <label class="custom-control-label" for="svcGoogle">Google (Analytics,
                                                    Ads)</label>
                                            </div>
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input" id="svcFacebook">
                                                <label class="custom-control-label" for="svcFacebook">Facebook /
                                                    Meta</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input" id="svcTwitter">
                                                <label class="custom-control-label" for="svcTwitter">Twitter / X</label>
                                            </div>
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input" id="svcLinkedin">
                                                <label class="custom-control-label" for="svcLinkedin">LinkedIn</label>
                                            </div>
                                        </div>
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
                    const websiteName = document.getElementById('websiteName').value || '[Website Name]';
                    const websiteUrl = document.getElementById('websiteUrl').value || '[Website URL]';
                    const contactEmail = document.getElementById('contactEmail').value || '[Contact Email]';
                    const effectiveDate = document.getElementById('effectiveDate').value;

                    const cookies = {
                        analytics: document.getElementById('cookieAnalytics').checked,
                        functionality: document.getElementById('cookieFunctionality').checked,
                        advertising: document.getElementById('cookieAdvertising').checked
                    };

                    const services = {
                        google: document.getElementById('svcGoogle').checked,
                        facebook: document.getElementById('svcFacebook').checked,
                        twitter: document.getElementById('svcTwitter').checked,
                        linkedin: document.getElementById('svcLinkedin').checked
                    };

                    const html = generateHTML(websiteName, websiteUrl, contactEmail, effectiveDate, cookies, services);
                    const markdown = generateMarkdown(websiteName, websiteUrl, contactEmail, effectiveDate, cookies, services);

                    document.getElementById('previewOutput').innerHTML = html;
                    document.getElementById('htmlOutput').textContent = html;
                    document.getElementById('markdownOutput').textContent = markdown;
                }

                function generateHTML(websiteName, websiteUrl, contactEmail, effectiveDate, cookies, services) {
                    let content = `<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>Cookie Policy</title>
    <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
    <h2>Cookie Policy</h2>
    <p>Last updated: ${effectiveDate}</p>
    
    <p>This Cookie Policy explains what Cookies are and how We use them. You should read this policy so You can understand what type of cookies We use, or the information We collect using Cookies and how that information is used.</p>
    
    <h3>What are Cookies?</h3>
    <p>Cookies are small text files that are placed on your computer, mobile device or any other device by a website, containing the details of your browsing history on that website among its many uses.</p>
    
    <h3>Type of Cookies We Use</h3>
    <p>Cookies can be "Persistent" or "Session" Cookies. Persistent Cookies remain on your personal computer or mobile device when You go offline, while Session Cookies are deleted as soon as You close your web browser.</p>
    
    <p>We use both session and persistent Cookies for the purposes set out below:</p>
    
    <ul>
        <li>
            <strong>Necessary / Essential Cookies</strong>
            <p>These Cookies are essential to provide You with services available through the Website and to enable You to use some of its features. They help to authenticate users and prevent fraudulent use of user accounts. Without these Cookies, the services that You have asked for cannot be provided, and We only use these Cookies to provide You with those services.</p>
        </li>
`;

                    if (cookies.functionality) {
                        content += `        <li>
            <strong>Functionality Cookies</strong>
            <p>These Cookies allow us to remember choices You make when You use the Website, such as remembering your login details or language preference. The purpose of these Cookies is to provide You with a more personal experience and to avoid You having to re-enter your preferences every time You use the Website.</p>
        </li>
`;
                    }

                    if (cookies.analytics) {
                        content += `        <li>
            <strong>Analytics Cookies</strong>
            <p>These Cookies are used to track information about traffic to the Website and how users use the Website. The information gathered via these Cookies may directly or indirectly identify you as an individual visitor. This is because the information collected is typically linked to a pseudonymous identifier associated with the device you use to access the Website.</p>
        </li>
`;
                    }

                    if (cookies.advertising) {
                        content += `        <li>
            <strong>Advertising Cookies</strong>
            <p>These Cookies are used to deliver advertisements that are relevant to you and your interests. They are also used to limit the number of times you see an advertisement and to measure the effectiveness of advertising campaigns.</p>
        </li>
`;
                    }

                    content += `    </ul>
    
    <h3>Your Choices Regarding Cookies</h3>
    <p>If You prefer to avoid the use of Cookies on the Website, first You must disable the use of Cookies in your browser and then delete the Cookies saved in your browser associated with this website. You may use this option for preventing the use of Cookies at any time.</p>
    <p>If You do not accept Our Cookies, You may experience some inconvenience in your use of the Website and some features may not function properly.</p>
`;

                    if (Object.values(services).some(v => v)) {
                        content += `    <h3>Third Party Cookies</h3>
    <p>In addition to our own cookies, we may also use various third-parties cookies to report usage statistics of the Service, deliver advertisements on and through the Service, and so on.</p>
    <ul>
`;
                        if (services.google) content += `        <li>Google Analytics / Ads</li>\n`;
                        if (services.facebook) content += `        <li>Facebook / Meta</li>\n`;
                        if (services.twitter) content += `        <li>Twitter / X</li>\n`;
                        if (services.linkedin) content += `        <li>LinkedIn</li>\n`;
                        content += `    </ul>\n`;
                    }

                    content += `    <h3>Contact Us</h3>
    <p>If you have any questions about this Cookie Policy, You can contact us at ${contactEmail}.</p>
</body>
</html>`;
                    return content;
                }

                function generateMarkdown(websiteName, websiteUrl, contactEmail, effectiveDate, cookies, services) {
                    let content = `# Cookie Policy

Last updated: ${effectiveDate}

This Cookie Policy explains what Cookies are and how We use them. You should read this policy so You can understand what type of cookies We use, or the information We collect using Cookies and how that information is used.

## What are Cookies?

Cookies are small text files that are placed on your computer, mobile device or any other device by a website, containing the details of your browsing history on that website among its many uses.

## Type of Cookies We Use

Cookies can be "Persistent" or "Session" Cookies. Persistent Cookies remain on your personal computer or mobile device when You go offline, while Session Cookies are deleted as soon as You close your web browser.

We use both session and persistent Cookies for the purposes set out below:

*   **Necessary / Essential Cookies**
    
    These Cookies are essential to provide You with services available through the Website and to enable You to use some of its features. They help to authenticate users and prevent fraudulent use of user accounts. Without these Cookies, the services that You have asked for cannot be provided, and We only use these Cookies to provide You with those services.
`;

                    if (cookies.functionality) {
                        content += `
*   **Functionality Cookies**
    
    These Cookies allow us to remember choices You make when You use the Website, such as remembering your login details or language preference. The purpose of these Cookies is to provide You with a more personal experience and to avoid You having to re-enter your preferences every time You use the Website.
`;
                    }

                    if (cookies.analytics) {
                        content += `
*   **Analytics Cookies**
    
    These Cookies are used to track information about traffic to the Website and how users use the Website. The information gathered via these Cookies may directly or indirectly identify you as an individual visitor. This is because the information collected is typically linked to a pseudonymous identifier associated with the device you use to access the Website.
`;
                    }

                    if (cookies.advertising) {
                        content += `
*   **Advertising Cookies**
    
    These Cookies are used to deliver advertisements that are relevant to you and your interests. They are also used to limit the number of times you see an advertisement and to measure the effectiveness of advertising campaigns.
`;
                    }

                    content += `
## Your Choices Regarding Cookies

If You prefer to avoid the use of Cookies on the Website, first You must disable the use of Cookies in your browser and then delete the Cookies saved in your browser associated with this website. You may use this option for preventing the use of Cookies at any time.

If You do not accept Our Cookies, You may experience some inconvenience in your use of the Website and some features may not function properly.
`;

                    if (Object.values(services).some(v => v)) {
                        content += `
## Third Party Cookies

In addition to our own cookies, we may also use various third-parties cookies to report usage statistics of the Service, deliver advertisements on and through the Service, and so on.

`;
                        if (services.google) content += `*   Google Analytics / Ads\n`;
                        if (services.facebook) content += `*   Facebook / Meta\n`;
                        if (services.twitter) content += `*   Twitter / X\n`;
                        if (services.linkedin) content += `*   LinkedIn\n`;
                    }

                    content += `
## Contact Us

If you have any questions about this Cookie Policy, You can contact us at ${contactEmail}.
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
                    let filename = 'cookie_policy';

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
                                if (input.id !== 'cookieEssential') input.checked = true;
                            }
                            else if (input.type !== 'date') input.value = '';
                        });
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
                                <a href="https://twitter.com/intent/tweet?text=Check%20out%20this%20awesome%20Free%20Cookie%20Policy%20Generator!%20%23devops%20%23gdpr%20https://8gwifi.org/cookie-policy-generator.jsp"
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