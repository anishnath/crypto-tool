<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Acceptable Use Policy Generator - Free for SaaS & Communities | 8gwifi.org</title>
        <meta name="description"
            content="Generate a professional Acceptable Use Policy (AUP) for your website, app, or SaaS. Define prohibited activities, content standards, and enforcement rules.">
        <meta name="keywords"
            content="aup generator, acceptable use policy generator, free aup template, saas policy generator, community guidelines generator">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Acceptable Use Policy Generator",
      "url": "https://8gwifi.org/aup-generator.jsp",
      "description": "Generate a professional Acceptable Use Policy (AUP) for your website, app, or SaaS.",
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
        "Prohibited Activities",
        "Content Standards",
        "System Security",
        "Enforcement Actions",
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
                        <h1 class="h3 mb-0">Acceptable Use Policy Generator</h1>
                        <p class="text-muted mb-0">Define the rules of conduct for your platform to prevent abuse and ensure safety</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-user-shield mr-2"></i>AUP Configuration</div>
                            <div class="card-body">
                                <form id="aupForm">
                                    <!-- General Info -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-building"></i> General Information
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Company/App Name</label>
                                                    <input type="text" class="form-control" id="companyName"
                                                        placeholder="e.g., My SaaS Platform">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Contact Email</label>
                                                    <input type="email" class="form-control" id="contactEmail"
                                                        placeholder="abuse@example.com">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Effective Date</label>
                                                    <input type="date" class="form-control" id="effectiveDate">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Prohibited Activities -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-ban"></i> Prohibited Activities
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="custom-control custom-checkbox mb-2">
                                                    <input type="checkbox" class="custom-control-input" id="illegal" checked>
                                                    <label class="custom-control-label" for="illegal">Illegal Activities (fraud, gambling, etc.)</label>
                                                </div>
                                                <div class="custom-control custom-checkbox mb-2">
                                                    <input type="checkbox" class="custom-control-input" id="spam" checked>
                                                    <label class="custom-control-label" for="spam">Spam & Unsolicited Messages</label>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="custom-control custom-checkbox mb-2">
                                                    <input type="checkbox" class="custom-control-input" id="malware" checked>
                                                    <label class="custom-control-label" for="malware">Malware & Viruses</label>
                                                </div>
                                                <div class="custom-control custom-checkbox mb-2">
                                                    <input type="checkbox" class="custom-control-input" id="security" checked>
                                                    <label class="custom-control-label" for="security">Security Violations (hacking, scanning)</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Content Standards -->
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <i class="fas fa-comments"></i> Content Standards
                                        </div>
                                        <p class="text-muted small">Restrict specific types of user-generated content.</p>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="custom-control custom-checkbox mb-2">
                                                    <input type="checkbox" class="custom-control-input" id="hateSpeech" checked>
                                                    <label class="custom-control-label" for="hateSpeech">Hate Speech & Harassment</label>
                                                </div>
                                                <div class="custom-control custom-checkbox mb-2">
                                                    <input type="checkbox" class="custom-control-input" id="violence" checked>
                                                    <label class="custom-control-label" for="violence">Violence & Graphic Content</label>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="custom-control custom-checkbox mb-2">
                                                    <input type="checkbox" class="custom-control-input" id="adult" checked>
                                                    <label class="custom-control-label" for="adult">Adult/Sexually Explicit Content</label>
                                                </div>
                                                <div class="custom-control custom-checkbox mb-2">
                                                    <input type="checkbox" class="custom-control-input" id="copyright" checked>
                                                    <label class="custom-control-label" for="copyright">Intellectual Property Infringement</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </form>
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
                    // Set default date
                    document.getElementById('effectiveDate').valueAsDate = new Date();

                    // Initial generation
                    generatePolicy();

                    // Add event listeners
                    const inputs = document.querySelectorAll('input, select');
                    inputs.forEach(input => {
                        input.addEventListener('input', generatePolicy);
                        input.addEventListener('change', generatePolicy);
                    });
                });

                function generatePolicy() {
                    const companyName = document.getElementById('companyName').value || '[Company Name]';
                    const contactEmail = document.getElementById('contactEmail').value || '[Email]';
                    const effectiveDate = document.getElementById('effectiveDate').value;

                    const prohibited = {
                        illegal: document.getElementById('illegal').checked,
                        spam: document.getElementById('spam').checked,
                        malware: document.getElementById('malware').checked,
                        security: document.getElementById('security').checked
                    };

                    const content = {
                        hateSpeech: document.getElementById('hateSpeech').checked,
                        violence: document.getElementById('violence').checked,
                        adult: document.getElementById('adult').checked,
                        copyright: document.getElementById('copyright').checked
                    };

                    const html = generateHTML(companyName, contactEmail, effectiveDate, prohibited, content);
                    const markdown = generateMarkdown(companyName, contactEmail, effectiveDate, prohibited, content);

                    document.getElementById('previewOutput').innerHTML = html;
                    document.getElementById('htmlOutput').textContent = html;
                    document.getElementById('markdownOutput').textContent = markdown;
                }

                function generateHTML(companyName, contactEmail, effectiveDate, prohibited, content) {
                    let prohibitedList = '';
                    if (prohibited.illegal) prohibitedList += '<li>Engage in any illegal activities, including but not limited to fraud, gambling, or money laundering.</li>';
                    if (prohibited.spam) prohibitedList += '<li>Send unsolicited messages, promotions, or advertisements (spam).</li>';
                    if (prohibited.malware) prohibitedList += '<li>Distribute malware, viruses, trojan horses, or other harmful software.</li>';
                    if (prohibited.security) prohibitedList += '<li>Attempt to gain unauthorized access to our systems, user accounts, or networks (hacking or scanning).</li>';

                    let contentList = '';
                    if (content.hateSpeech) contentList += '<li>Promotes hate speech, discrimination, or harassment based on race, ethnicity, religion, gender, or sexual orientation.</li>';
                    if (content.violence) contentList += '<li>Depicts excessive violence or incites violence against individuals or groups.</li>';
                    if (content.adult) contentList += '<li>Contains sexually explicit material or pornography.</li>';
                    if (content.copyright) contentList += '<li>Infringes on the intellectual property rights of others (copyright, trademark, patent).</li>';

                    return `<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width'>
    <title>Acceptable Use Policy</title>
    <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
    <h2>Acceptable Use Policy</h2>
    <p><strong>Effective Date:</strong> ${effectiveDate}</p>

    <p>This Acceptable Use Policy ("AUP") governs your use of the services provided by <strong>${companyName}</strong> ("we", "us", or "our"). By accessing or using our services, you agree to comply with this AUP. If you violate this AUP, we may suspend or terminate your access to our services.</p>

    <h3>1. Prohibited Activities</h3>
    <p>You may not use our services for any illegal or unauthorized purpose. Specifically, you agree not to:</p>
    <ul>${prohibitedList}</ul>

    <h3>2. Content Standards</h3>
    <p>You are solely responsible for the content you post or transmit through our services. You agree not to post content that:</p>
    <ul>${contentList}</ul>

    <h3>3. Enforcement</h3>
    <p>We reserve the right to investigate any violation of this AUP. If we determine that you have violated this AUP, we may take action including:</p>
    <ul>
        <li>Removing the offending content.</li>
        <li>Suspending or terminating your account.</li>
        <li>Reporting illegal activities to law enforcement.</li>
    </ul>

    <h3>4. Reporting Violations</h3>
    <p>If you become aware of any violation of this AUP, please report it to us immediately at: <a href="mailto:${contactEmail}">${contactEmail}</a>.</p>
</body>
</html>`;
                }

                function generateMarkdown(companyName, contactEmail, effectiveDate, prohibited, content) {
                    let prohibitedList = '';
                    if (prohibited.illegal) prohibitedList += '*   Engage in any illegal activities, including but not limited to fraud, gambling, or money laundering.\n';
                    if (prohibited.spam) prohibitedList += '*   Send unsolicited messages, promotions, or advertisements (spam).\n';
                    if (prohibited.malware) prohibitedList += '*   Distribute malware, viruses, trojan horses, or other harmful software.\n';
                    if (prohibited.security) prohibitedList += '*   Attempt to gain unauthorized access to our systems, user accounts, or networks (hacking or scanning).\n';

                    let contentList = '';
                    if (content.hateSpeech) contentList += '*   Promotes hate speech, discrimination, or harassment based on race, ethnicity, religion, gender, or sexual orientation.\n';
                    if (content.violence) contentList += '*   Depicts excessive violence or incites violence against individuals or groups.\n';
                    if (content.adult) contentList += '*   Contains sexually explicit material or pornography.\n';
                    if (content.copyright) contentList += '*   Infringes on the intellectual property rights of others (copyright, trademark, patent).\n';

                    return `# Acceptable Use Policy

**Effective Date:** ${effectiveDate}

This Acceptable Use Policy ("AUP") governs your use of the services provided by **${companyName}** ("we", "us", or "our"). By accessing or using our services, you agree to comply with this AUP. If you violate this AUP, we may suspend or terminate your access to our services.

## 1. Prohibited Activities

You may not use our services for any illegal or unauthorized purpose. Specifically, you agree not to:

${prohibitedList}
## 2. Content Standards

You are solely responsible for the content you post or transmit through our services. You agree not to post content that:

${contentList}
## 3. Enforcement

We reserve the right to investigate any violation of this AUP. If we determine that you have violated this AUP, we may take action including:

*   Removing the offending content.
*   Suspending or terminating your account.
*   Reporting illegal activities to law enforcement.

## 4. Reporting Violations

If you become aware of any violation of this AUP, please report it to us immediately at: ${contactEmail}.
`;
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

                function showSupportModal() {
                    $('#supportModal').modal('show');
                }

                function proceedDownload() {
                    $('#supportModal').modal('hide');

                    const activeTab = document.querySelector('.tab-pane.active');
                    let content = '';
                    let filename = 'acceptable_use_policy';

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

                function resetForm() {
                    if (confirm('Are you sure you want to reset all fields?')) {
                        const inputs = document.querySelectorAll('input');
                        inputs.forEach(input => {
                            if (input.type === 'checkbox') input.checked = true;
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
                                <a href="https://twitter.com/intent/tweet?text=Check%20out%20this%20awesome%20Free%20Acceptable%20Use%20Policy%20Generator!%20%23saas%20%23startup%20https://8gwifi.org/aup-generator.jsp"
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
