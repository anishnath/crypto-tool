<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>DMCA Policy Generator - Free & Professional | 8gwifi.org</title>
        <meta name="description"
            content="Generate a professional DMCA Policy for your website or app. Protect yourself from copyright liability with our free DMCA generator. Includes Safe Harbor provisions.">
        <meta name="keywords"
            content="dmca generator, dmca policy generator, copyright policy generator, free dmca policy, website copyright policy, safe harbor policy">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "DMCA Policy Generator",
      "url": "https://8gwifi.org/dmca-policy-generator.jsp",
      "description": "Generate a professional DMCA Policy for your website or app.",
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
        "Designated Copyright Agent",
        "Takedown Notice Procedures",
        "Counter-Notice Procedures",
        "Repeat Infringer Policy",
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
                        <h1 class="h3 mb-0">DMCA Policy Generator</h1>
                        <p class="text-muted mb-0">Create a DMCA Copyright Policy to protect your user-generated content platform</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-copyright mr-2"></i>DMCA Configuration</div>
                            <div class="card-body">

                                <!-- General Info -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-building"></i> General Information</div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Website/App Name</label>
                                                <input type="text" class="form-control" id="websiteName"
                                                    placeholder="e.g., My Awesome Blog">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Website URL</label>
                                                <input type="url" class="form-control" id="websiteUrl"
                                                    placeholder="https://www.example.com">
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

                                <!-- Copyright Agent -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-user-tie"></i> Copyright Agent</div>
                                    <p class="text-muted small">The person designated to receive DMCA takedown notices.</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Agent Name / Title</label>
                                                <input type="text" class="form-control" id="agentName"
                                                    placeholder="e.g., Copyright Manager">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Email Address</label>
                                                <input type="email" class="form-control" id="agentEmail"
                                                    placeholder="copyright@example.com">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Mailing Address</label>
                                                <textarea class="form-control" id="agentAddress" rows="2"
                                                    placeholder="123 Main St, City, State, Zip"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Phone Number (Optional)</label>
                                                <input type="tel" class="form-control" id="agentPhone"
                                                    placeholder="+1 (555) 123-4567">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Policy Options -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-cogs"></i> Policy Options</div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input" id="repeatInfringer" checked>
                                                <label class="custom-control-label" for="repeatInfringer">Repeat Infringer Policy</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input" id="counterNotice" checked>
                                                <label class="custom-control-label" for="counterNotice">Counter-Notice Procedure</label>
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
                    // Set default date
                    document.getElementById('effectiveDate').valueAsDate = new Date();

                    // Initial generation
                    generatePolicy();

                    // Add event listeners
                    const inputs = document.querySelectorAll('input, textarea, select');
                    inputs.forEach(input => {
                        input.addEventListener('input', generatePolicy);
                        input.addEventListener('change', generatePolicy);
                    });
                });

                function generatePolicy() {
                    const websiteName = document.getElementById('websiteName').value || '[Website Name]';
                    const websiteUrl = document.getElementById('websiteUrl').value || '[Website URL]';
                    const effectiveDate = document.getElementById('effectiveDate').value;

                    const agentName = document.getElementById('agentName').value || '[Agent Name]';
                    const agentAddress = document.getElementById('agentAddress').value || '[Agent Address]';
                    const agentEmail = document.getElementById('agentEmail').value || '[Agent Email]';
                    const agentPhone = document.getElementById('agentPhone').value || '[Agent Phone]';

                    const options = {
                        repeatInfringer: document.getElementById('repeatInfringer').checked,
                        counterNotice: document.getElementById('counterNotice').checked
                    };

                    const html = generateHTML(websiteName, websiteUrl, effectiveDate, agentName, agentAddress, agentEmail, agentPhone, options);
                    const markdown = generateMarkdown(websiteName, websiteUrl, effectiveDate, agentName, agentAddress, agentEmail, agentPhone, options);

                    document.getElementById('previewOutput').innerHTML = html;
                    document.getElementById('htmlOutput').textContent = html;
                    document.getElementById('markdownOutput').textContent = markdown;
                }

                function generateHTML(websiteName, websiteUrl, effectiveDate, agentName, agentAddress, agentEmail, agentPhone, options) {
                    let optionalSections = '';

                    if (options.counterNotice) {
                        optionalSections += `
    <h3>2. Counter-Notice Procedures</h3>
    <p>If you believe that your content that was removed (or to which access was disabled) is not infringing, or that you have the authorization from the copyright owner, the copyright owner's agent, or pursuant to the law, to post and use the material in your content, you may send a Counter-Notice containing the following information to the Copyright Agent:</p>
    <ol>
        <li>Your physical or electronic signature;</li>
        <li>Identification of the content that has been removed or to which access has been disabled and the location at which the content appeared before it was removed or disabled;</li>
        <li>A statement that you have a good faith belief that the content was removed or disabled as a result of mistake or a misidentification of the content; and</li>
        <li>Your name, address, telephone number, and email address, a statement that you consent to the jurisdiction of the federal court in [Your Jurisdiction], and a statement that you will accept service of process from the person who provided notification of the alleged infringement.</li>
    </ol>
    <p>If a Counter-Notice is received by the Copyright Agent, we may send a copy of the Counter-Notice to the original complaining party informing that person that it may replace the removed content or cease disabling it in 10 business days. Unless the copyright owner files an action seeking a court order against the content provider, member or user, the removed content may be replaced, or access to it restored, in 10 to 14 business days or more after receipt of the Counter-Notice, at our sole discretion.</p>`;
                    }

                    if (options.repeatInfringer) {
                        optionalSections += `
    <h3>3. Repeat Infringers</h3>
    <p>It is our policy in appropriate circumstances to disable and/or terminate the accounts of users who are repeat infringers.</p>`;
                    }

                    return `<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width'>
    <title>DMCA Policy</title>
    <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } .contact-info { background: #f4f4f4; padding: 15px; border-radius: 5px; } </style>
</head>
<body>
    <h2>DMCA Copyright Policy</h2>
    <p><strong>Effective Date:</strong> ${effectiveDate}</p>

    <p><strong>${websiteName}</strong> ("we", "our", or "us") respects the intellectual property rights of others and expects its users to do the same. In accordance with the Digital Millennium Copyright Act of 1998 ("DMCA"), the text of which may be found on the U.S. Copyright Office website at <a href="http://www.copyright.gov/legislation/dmca.pdf">http://www.copyright.gov/legislation/dmca.pdf</a>, we will respond expeditiously to claims of copyright infringement committed using the ${websiteName} service and/or the ${websiteUrl} website (the "Site") if such claims are reported to our Designated Copyright Agent identified below.</p>

    <h3>1. Takedown Notice Procedures</h3>
    <p>If you are a copyright owner, authorized to act on behalf of one, or authorized to act under any exclusive right under copyright, please report alleged copyright infringements taking place on or through the Site by completing the following DMCA Notice of Alleged Infringement and delivering it to our Designated Copyright Agent.</p>
    <p>Upon receipt of Notice as described below, we will take whatever action, in our sole discretion, we deem appropriate, including removal of the challenged content from the Site.</p>

    <h4>DMCA Notice of Alleged Infringement ("Notice")</h4>
    <ol>
        <li>Identify the copyrighted work that you claim has been infringed, or - if multiple copyrighted works are covered by this Notice - you may provide a representative list of the copyrighted works that you claim have been infringed.</li>
        <li>Identify the material or link you claim is infringing (or the subject of infringing activity) and that access to which is to be disabled, including at a minimum, if applicable, the URL of the link shown on the Site where such material may be found.</li>
        <li>Provide your mailing address, telephone number, and, if available, email address.</li>
        <li>Include both of the following statements in the body of the Notice:
            <ul>
                <li>"I hereby state that I have a good faith belief that the disputed use of the copyrighted material is not authorized by the copyright owner, its agent, or the law (e.g., as a fair use)."</li>
                <li>"I hereby state that the information in this Notice is accurate and, under penalty of perjury, that I am the owner, or authorized to act on behalf of the owner, of the copyright or of an exclusive right under the copyright that is allegedly infringed."</li>
            </ul>
        </li>
        <li>Provide your full legal name and your electronic or physical signature.</li>
    </ol>

    <div class="contact-info">
        <h4>Designated Copyright Agent</h4>
        <p>All DMCA Notices should be delivered to our Designated Copyright Agent:</p>
        <p>
            <strong>Name:</strong> ${agentName}<br>
            <strong>Address:</strong> ${agentAddress}<br>
            <strong>Email:</strong> <a href="mailto:${agentEmail}">${agentEmail}</a><br>
            <strong>Phone:</strong> ${agentPhone}
        </p>
    </div>
${optionalSections}
</body>
</html>`;
                }

                function generateMarkdown(websiteName, websiteUrl, effectiveDate, agentName, agentAddress, agentEmail, agentPhone, options) {
                    let optionalSections = '';

                    if (options.counterNotice) {
                        optionalSections += `
## 2. Counter-Notice Procedures

If you believe that your content that was removed (or to which access was disabled) is not infringing, or that you have the authorization from the copyright owner, the copyright owner's agent, or pursuant to the law, to post and use the material in your content, you may send a Counter-Notice containing the following information to the Copyright Agent:

1. Your physical or electronic signature;
2. Identification of the content that has been removed or to which access has been disabled and the location at which the content appeared before it was removed or disabled;
3. A statement that you have a good faith belief that the content was removed or disabled as a result of mistake or a misidentification of the content; and
4. Your name, address, telephone number, and email address, a statement that you consent to the jurisdiction of the federal court in [Your Jurisdiction], and a statement that you will accept service of process from the person who provided notification of the alleged infringement.

If a Counter-Notice is received by the Copyright Agent, we may send a copy of the Counter-Notice to the original complaining party informing that person that it may replace the removed content or cease disabling it in 10 business days. Unless the copyright owner files an action seeking a court order against the content provider, member or user, the removed content may be replaced, or access to it restored, in 10 to 14 business days or more after receipt of the Counter-Notice, at our sole discretion.
`;
                    }

                    if (options.repeatInfringer) {
                        optionalSections += `
## 3. Repeat Infringers

It is our policy in appropriate circumstances to disable and/or terminate the accounts of users who are repeat infringers.
`;
                    }

                    return `# DMCA Copyright Policy

**Effective Date:** ${effectiveDate}

**${websiteName}** ("we", "our", or "us") respects the intellectual property rights of others and expects its users to do the same. In accordance with the Digital Millennium Copyright Act of 1998 ("DMCA"), the text of which may be found on the U.S. Copyright Office website at [http://www.copyright.gov/legislation/dmca.pdf](http://www.copyright.gov/legislation/dmca.pdf), we will respond expeditiously to claims of copyright infringement committed using the ${websiteName} service and/or the ${websiteUrl} website (the "Site") if such claims are reported to our Designated Copyright Agent identified below.

## 1. Takedown Notice Procedures

If you are a copyright owner, authorized to act on behalf of one, or authorized to act under any exclusive right under copyright, please report alleged copyright infringements taking place on or through the Site by completing the following DMCA Notice of Alleged Infringement and delivering it to our Designated Copyright Agent.

Upon receipt of Notice as described below, we will take whatever action, in our sole discretion, we deem appropriate, including removal of the challenged content from the Site.

### DMCA Notice of Alleged Infringement ("Notice")

1. Identify the copyrighted work that you claim has been infringed, or - if multiple copyrighted works are covered by this Notice - you may provide a representative list of the copyrighted works that you claim have been infringed.
2. Identify the material or link you claim is infringing (or the subject of infringing activity) and that access to which is to be disabled, including at a minimum, if applicable, the URL of the link shown on the Site where such material may be found.
3. Provide your mailing address, telephone number, and, if available, email address.
4. Include both of the following statements in the body of the Notice:
    * "I hereby state that I have a good faith belief that the disputed use of the copyrighted material is not authorized by the copyright owner, its agent, or the law (e.g., as a fair use)."
    * "I hereby state that the information in this Notice is accurate and, under penalty of perjury, that I am the owner, or authorized to act on behalf of the owner, of the copyright or of an exclusive right under the copyright that is allegedly infringed."
5. Provide your full legal name and your electronic or physical signature.

### Designated Copyright Agent

All DMCA Notices should be delivered to our Designated Copyright Agent:

**Name:** ${agentName}
**Address:** ${agentAddress}
**Email:** ${agentEmail}
**Phone:** ${agentPhone}
${optionalSections}`;
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
                    let filename = 'dmca_policy';

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
                        const inputs = document.querySelectorAll('input, textarea');
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
                                <a href="https://twitter.com/intent/tweet?text=Check%20out%20this%20awesome%20Free%20DMCA%20Policy%20Generator!%20%23legaltech%20%23webdev%20https://8gwifi.org/dmca-policy-generator.jsp"
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
