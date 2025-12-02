<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Free EULA Generator & Template (Software & App) | 8gwifi.org</title>
        <meta name="description"
            content="Generate a free, professional End User License Agreement (EULA) for your software or mobile app. Includes standard clauses for license grants, restrictions, and warranty disclaimers. No signup required.">
        <meta name="keywords"
            content="eula generator, end user license agreement template, software license agreement, free eula generator, app eula template, software license generator, eula sample">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "EULA Generator",
      "description": "Generate professional End User License Agreements for software and applications.",
      "url": "https://8gwifi.org/eula-generator.jsp",
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
        "Free EULA Template",
        "Software & App Compatible",
        "HTML & Markdown Export",
        "Instant Preview"
      ]
    }
    </script>
            <style>
                :root {
                    --theme-primary: #8b5cf6;
                    --theme-secondary: #a78bfa;
                    --theme-gradient: linear-gradient(135deg, #8b5cf6 0%, #a78bfa 100%);
                    --theme-light: #f5f3ff;
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
                        <h1 class="h3 mb-0">EULA Generator</h1>
                        <p class="text-muted mb-0">Create professional End User License Agreements for your software</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-scroll mr-2"></i> License
                                Details</div>
                            <div class="card-body">

                                <!-- General Info -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-cube"></i> Software Information
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Software/App Name</label>
                                                <input type="text" class="form-control" id="softwareName"
                                                    placeholder="My Awesome App">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Company/Developer Name</label>
                                                <input type="text" class="form-control" id="companyName"
                                                    placeholder="Company Inc.">
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

                                <!-- Clauses -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-shield-alt"></i> License Terms
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="clauseGrant" checked>
                                        <label class="custom-control-label" for="clauseGrant">License Grant (Revocable,
                                            Non-exclusive)</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="clauseRestrictions"
                                            checked>
                                        <label class="custom-control-label" for="clauseRestrictions">Restrictions
                                            (Reverse Engineering, etc.)</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="clauseUpdates" checked>
                                        <label class="custom-control-label" for="clauseUpdates">Updates &
                                            Maintenance</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="clauseTermination"
                                            checked>
                                        <label class="custom-control-label" for="clauseTermination">Termination
                                            Clause</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="clauseWarranty" checked>
                                        <label class="custom-control-label" for="clauseWarranty">Disclaimer of
                                            Warranties</label>
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
                    generateEULA();

                    const inputs = document.querySelectorAll('input, select');
                    inputs.forEach(input => {
                        input.addEventListener('input', generateEULA);
                        input.addEventListener('change', generateEULA);
                    });
                });

                function generateEULA() {
                    const softwareName = document.getElementById('softwareName').value || '[Software Name]';
                    const companyName = document.getElementById('companyName').value || '[Company Name]';
                    const contactEmail = document.getElementById('contactEmail').value || '[Contact Email]';
                    const effectiveDate = document.getElementById('effectiveDate').value;

                    const clauses = {
                        grant: document.getElementById('clauseGrant').checked,
                        restrictions: document.getElementById('clauseRestrictions').checked,
                        updates: document.getElementById('clauseUpdates').checked,
                        termination: document.getElementById('clauseTermination').checked,
                        warranty: document.getElementById('clauseWarranty').checked
                    };

                    const html = generateHTML(softwareName, companyName, contactEmail, effectiveDate, clauses);
                    const markdown = generateMarkdown(softwareName, companyName, contactEmail, effectiveDate, clauses);

                    document.getElementById('previewOutput').innerHTML = html;
                    document.getElementById('htmlOutput').textContent = html;
                    document.getElementById('markdownOutput').textContent = markdown;
                }

                function generateHTML(softwareName, companyName, contactEmail, effectiveDate, clauses) {
                    let content = `<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>End User License Agreement</title>
    <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
    <h2>End User License Agreement (EULA)</h2>
    <p>Last updated: ${effectiveDate}</p>
    
    <p>Please read this End User License Agreement ("Agreement") carefully before clicking the "I Agree" button, downloading or using ${softwareName} ("Application").</p>
    
    <p>By clicking the "I Agree" button, downloading or using the Application, you are agreeing to be bound by the terms and conditions of this Agreement.</p>
    
    <p>If you do not agree to the terms of this Agreement, do not click on the "I Agree" button and do not download or use the Application.</p>
`;

                    if (clauses.grant) {
                        content += `    <h3>License</h3>
    <p>${companyName} grants you a revocable, non-exclusive, non-transferable, limited license to download, install and use the Application solely for your personal, non-commercial purposes strictly in accordance with the terms of this Agreement.</p>
`;
                    }

                    if (clauses.restrictions) {
                        content += `    <h3>Restrictions</h3>
    <p>You agree not to, and you will not permit others to:</p>
    <ul>
        <li>License, sell, rent, lease, assign, distribute, transmit, host, outsource, disclose or otherwise commercially exploit the Application or make the Application available to any third party.</li>
        <li>Modify, make derivative works of, disassemble, decrypt, reverse compile or reverse engineer any part of the Application.</li>
        <li>Remove, alter or obscure any proprietary notice (including any notice of copyright or trademark) of ${companyName} or its affiliates, partners, suppliers or the licensors of the Application.</li>
    </ul>
`;
                    }

                    if (clauses.updates) {
                        content += `    <h3>Modifications to Application</h3>
    <p>${companyName} reserves the right to modify, suspend or discontinue, temporarily or permanently, the Application or any service to which it connects, with or without notice and without liability to you.</p>
    
    <h3>Updates to Application</h3>
    <p>${companyName} may from time to time provide enhancements or improvements to the features/functionality of the Application, which may include patches, bug fixes, updates, upgrades and other modifications ("Updates").</p>
    <p>Updates may modify or delete certain features and/or functionalities of the Application. You agree that ${companyName} has no obligation to (i) provide any Updates, or (ii) continue to provide or enable any particular features and/or functionalities of the Application to you.</p>
`;
                    }

                    if (clauses.termination) {
                        content += `    <h3>Term and Termination</h3>
    <p>This Agreement shall remain in effect until terminated by you or ${companyName}.</p>
    <p>${companyName} may, in its sole discretion, at any time and for any or no reason, suspend or terminate this Agreement with or without prior notice.</p>
    <p>This Agreement will terminate immediately, without prior notice from ${companyName}, in the event that you fail to comply with any provision of this Agreement. You may also terminate this Agreement by deleting the Application and all copies thereof from your mobile device or from your computer.</p>
`;
                    }

                    if (clauses.warranty) {
                        content += `    <h3>No Warranties</h3>
    <p>The Application is provided to you "AS IS" and "AS AVAILABLE" and with all faults and defects without warranty of any kind. To the maximum extent permitted under applicable law, ${companyName}, on its own behalf and on behalf of its affiliates and its and their respective licensors and service providers, expressly disclaims all warranties, whether express, implied, statutory or otherwise, with respect to the Application.</p>
`;
                    }

                    content += `    <h3>Severability</h3>
    <p>If any provision of this Agreement is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.</p>
    
    <h3>Contact Information</h3>
    <p>If you have any questions about this Agreement, please contact us at ${contactEmail}.</p>
</body>
</html>`;
                    return content;
                }

                function generateMarkdown(softwareName, companyName, contactEmail, effectiveDate, clauses) {
                    let content = `# End User License Agreement (EULA)

Last updated: ${effectiveDate}

Please read this End User License Agreement ("Agreement") carefully before clicking the "I Agree" button, downloading or using ${softwareName} ("Application").

By clicking the "I Agree" button, downloading or using the Application, you are agreeing to be bound by the terms and conditions of this Agreement.

If you do not agree to the terms of this Agreement, do not click on the "I Agree" button and do not download or use the Application.
`;

                    if (clauses.grant) {
                        content += `
## License

${companyName} grants you a revocable, non-exclusive, non-transferable, limited license to download, install and use the Application solely for your personal, non-commercial purposes strictly in accordance with the terms of this Agreement.
`;
                    }

                    if (clauses.restrictions) {
                        content += `
## Restrictions

You agree not to, and you will not permit others to:

*   License, sell, rent, lease, assign, distribute, transmit, host, outsource, disclose or otherwise commercially exploit the Application or make the Application available to any third party.
*   Modify, make derivative works of, disassemble, decrypt, reverse compile or reverse engineer any part of the Application.
*   Remove, alter or obscure any proprietary notice (including any notice of copyright or trademark) of ${companyName} or its affiliates, partners, suppliers or the licensors of the Application.
`;
                    }

                    if (clauses.updates) {
                        content += `
## Modifications to Application

${companyName} reserves the right to modify, suspend or discontinue, temporarily or permanently, the Application or any service to which it connects, with or without notice and without liability to you.

## Updates to Application

${companyName} may from time to time provide enhancements or improvements to the features/functionality of the Application, which may include patches, bug fixes, updates, upgrades and other modifications ("Updates").

Updates may modify or delete certain features and/or functionalities of the Application. You agree that ${companyName} has no obligation to (i) provide any Updates, or (ii) continue to provide or enable any particular features and/or functionalities of the Application to you.
`;
                    }

                    if (clauses.termination) {
                        content += `
## Term and Termination

This Agreement shall remain in effect until terminated by you or ${companyName}.

${companyName} may, in its sole discretion, at any time and for any or no reason, suspend or terminate this Agreement with or without prior notice.

This Agreement will terminate immediately, without prior notice from ${companyName}, in the event that you fail to comply with any provision of this Agreement. You may also terminate this Agreement by deleting the Application and all copies thereof from your mobile device or from your computer.
`;
                    }

                    if (clauses.warranty) {
                        content += `
## No Warranties

The Application is provided to you "AS IS" and "AS AVAILABLE" and with all faults and defects without warranty of any kind. To the maximum extent permitted under applicable law, ${companyName}, on its own behalf and on behalf of its affiliates and its and their respective licensors and service providers, expressly disclaims all warranties, whether express, implied, statutory or otherwise, with respect to the Application.
`;
                    }

                    content += `
## Severability

If any provision of this Agreement is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.

## Contact Information

If you have any questions about this Agreement, please contact us at ${contactEmail}.
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
                    let filename = 'eula';

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
                            if (input.type === 'checkbox') input.checked = true;
                            else if (input.type !== 'date') input.value = '';
                        });
                        generateEULA();
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
                                <a href="https://twitter.com/intent/tweet?text=Check%20out%20this%20awesome%20Free%20EULA%20Generator!%20%23devops%20%23software%20https://8gwifi.org/eula-generator.jsp"
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
