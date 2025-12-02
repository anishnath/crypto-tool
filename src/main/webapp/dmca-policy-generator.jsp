<!DOCTYPE html>
<html lang="en">

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
                        <i class="fas fa-copyright text-danger mr-2"></i>DMCA Policy Generator
                    </h1>
                    <p class="text-muted">Create a DMCA Copyright Policy to protect your user-generated content
                        platform.</p>
                </div>
            </div>

            <div class="row">
                <!-- Input Form -->
                <div class="col-lg-5">
                    <form id="dmcaForm">
                        <!-- General Info -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <i class="fas fa-building"></i> General Information
                            </div>
                            <div class="form-group">
                                <label for="websiteName">Website/App Name</label>
                                <input type="text" class="form-control" id="websiteName"
                                    placeholder="e.g., My Awesome Blog">
                            </div>
                            <div class="form-group">
                                <label for="websiteUrl">Website URL</label>
                                <input type="url" class="form-control" id="websiteUrl"
                                    placeholder="https://www.example.com">
                            </div>
                            <div class="form-group">
                                <label for="effectiveDate">Effective Date</label>
                                <input type="date" class="form-control" id="effectiveDate">
                            </div>
                        </div>

                        <!-- Copyright Agent -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <i class="fas fa-user-tie"></i> Copyright Agent
                            </div>
                            <p class="small text-muted">The person designated to receive DMCA takedown notices.</p>
                            <div class="form-group">
                                <label for="agentName">Agent Name / Title</label>
                                <input type="text" class="form-control" id="agentName"
                                    placeholder="e.g., Copyright Manager">
                            </div>
                            <div class="form-group">
                                <label for="agentAddress">Mailing Address</label>
                                <textarea class="form-control" id="agentAddress" rows="2"
                                    placeholder="123 Main St, City, State, Zip"></textarea>
                            </div>
                            <div class="form-group">
                                <label for="agentEmail">Email Address</label>
                                <input type="email" class="form-control" id="agentEmail"
                                    placeholder="copyright@example.com">
                            </div>
                            <div class="form-group">
                                <label for="agentPhone">Phone Number (Optional)</label>
                                <input type="tel" class="form-control" id="agentPhone" placeholder="+1 (555) 123-4567">
                            </div>
                        </div>

                        <!-- Policy Options -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <i class="fas fa-cogs"></i> Policy Options
                            </div>

                            <div class="custom-control custom-switch mb-3">
                                <input type="checkbox" class="custom-control-input" id="repeatInfringer" checked>
                                <label class="custom-control-label" for="repeatInfringer">Include "Repeat Infringer"
                                    Termination Policy</label>
                                <small class="form-text text-muted">States that you will terminate accounts of users who
                                    repeatedly violate copyright.</small>
                            </div>

                            <div class="custom-control custom-switch mb-3">
                                <input type="checkbox" class="custom-control-input" id="counterNotice" checked>
                                <label class="custom-control-label" for="counterNotice">Include Counter-Notice
                                    Procedure</label>
                                <small class="form-text text-muted">Explains how users can dispute a takedown if they
                                    believe it was a mistake.</small>
                            </div>
                        </div>

                        <div class="text-center mb-5">
                            <button type="button" class="btn btn-secondary mr-2" onclick="resetForm()">Reset</button>
                            <button type="button" class="btn btn-primary btn-lg" onclick="generatePolicy()">
                                <i class="fas fa-magic mr-2"></i>Generate DMCA Policy
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
                            <h6 class="m-0 font-weight-bold text-primary">Why do you need a DMCA Policy?</h6>
                        </div>
                        <div class="card-body">
                            <p>If your website allows users to upload content (comments, posts, images, videos), you are
                                potentially liable for copyright infringement if they upload protected material. The
                                <strong>Digital Millennium Copyright Act (DMCA)</strong> provides a "Safe Harbor" that
                                protects you from liability, but ONLY if you have a designated agent and a proper
                                procedure for handling takedown notices.</p>
                            <ul>
                                <li><strong>Safe Harbor Protection:</strong> Shield your business from costly copyright
                                    lawsuits.</li>
                                <li><strong>Clear Procedures:</strong> Tell copyright holders exactly how to contact
                                    you.</li>
                                <li><strong>User Trust:</strong> Show that you respect intellectual property rights.
                                </li>
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
                                    data-text="Check out this free DMCA Policy Generator! #devops #legaltech"
                                    data-url="https://8gwifi.org/dmca-policy-generator.jsp" data-via="anish_nath"
                                    data-hashtags="webdev,opensource">Tweet</a>
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
                const websiteName = document.getElementById('websiteName').value || '[Website Name]';
                const websiteUrl = document.getElementById('websiteUrl').value || '[Website URL]';
                const effectiveDate = document.getElementById('effectiveDate').value || '[Date]';

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

                document.getElementById('htmlContent').innerHTML = html;
                document.getElementById('markdownContent').textContent = markdown;
            }

            function generateHTML(websiteName, websiteUrl, effectiveDate, agentName, agentAddress, agentEmail, agentPhone, options) {
                let content = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DMCA Policy - ${websiteName}</title>
    <style>
        body { font-family: sans-serif; line-height: 1.6; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1, h2 { color: #333; }
        .contact-info { background: #f4f4f4; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>DMCA Copyright Policy</h1>
    <p><strong>Effective Date:</strong> ${effectiveDate}</p>
    
    <p>${websiteName} ("we", "our", or "us") respects the intellectual property rights of others and expects its users to do the same. In accordance with the Digital Millennium Copyright Act of 1998 ("DMCA"), the text of which may be found on the U.S. Copyright Office website at <a href="http://www.copyright.gov/legislation/dmca.pdf">http://www.copyright.gov/legislation/dmca.pdf</a>, we will respond expeditiously to claims of copyright infringement committed using the ${websiteName} service and/or the ${websiteUrl} website (the "Site") if such claims are reported to our Designated Copyright Agent identified below.</p>

    <h2>1. Takedown Notice Procedures</h2>
    <p>If you are a copyright owner, authorized to act on behalf of one, or authorized to act under any exclusive right under copyright, please report alleged copyright infringements taking place on or through the Site by completing the following DMCA Notice of Alleged Infringement and delivering it to our Designated Copyright Agent.</p>
    
    <p>Upon receipt of Notice as described below, we will take whatever action, in our sole discretion, we deem appropriate, including removal of the challenged content from the Site.</p>

    <h3>DMCA Notice of Alleged Infringement ("Notice")</h3>
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
        <h3>Designated Copyright Agent</h3>
        <p>All DMCA Notices should be delivered to our Designated Copyright Agent:</p>
        <p>
            <strong>Name:</strong> ${agentName}<br>
            <strong>Address:</strong> ${agentAddress}<br>
            <strong>Email:</strong> <a href="mailto:${agentEmail}">${agentEmail}</a><br>
            <strong>Phone:</strong> ${agentPhone}
        </p>
    </div>`;

                if (options.counterNotice) {
                    content += `
    <h2>2. Counter-Notice Procedures</h2>
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
                    content += `
    <h2>3. Repeat Infringers</h2>
    <p>It is our policy in appropriate circumstances to disable and/or terminate the accounts of users who are repeat infringers.</p>`;
                }

                content += `
</body>
</html>`;
                return content;
            }

            function generateMarkdown(websiteName, websiteUrl, effectiveDate, agentName, agentAddress, agentEmail, agentPhone, options) {
                let content = `# DMCA Copyright Policy
**Effective Date:** ${effectiveDate}

${websiteName} ("we", "our", or "us") respects the intellectual property rights of others and expects its users to do the same. In accordance with the Digital Millennium Copyright Act of 1998 ("DMCA"), the text of which may be found on the U.S. Copyright Office website at [http://www.copyright.gov/legislation/dmca.pdf](http://www.copyright.gov/legislation/dmca.pdf), we will respond expeditiously to claims of copyright infringement committed using the ${websiteName} service and/or the ${websiteUrl} website (the "Site") if such claims are reported to our Designated Copyright Agent identified below.

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
`;

                if (options.counterNotice) {
                    content += `
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
                    content += `
## 3. Repeat Infringers
It is our policy in appropriate circumstances to disable and/or terminate the accounts of users who are repeat infringers.
`;
                }

                return content;
            }

            function showSupportModal() {
                $('#supportModal').modal('show');
            }

            function downloadContent() {
                showSupportModal();
                setTimeout(proceedDownload, 2000); // Wait 2s for modal to be seen
            }

            function proceedDownload() {
                const activeTab = document.querySelector('.nav-link.active').id;
                let content = '';
                let filename = '';
                let mimeType = '';

                if (activeTab === 'html-tab') {
                    content = document.getElementById('htmlContent').innerText; // Use innerText to get the raw HTML code if it was displayed as text, but here we are rendering it. 
                    // Actually we want the generated HTML string, not the rendered DOM.
                    // Re-generate to be safe and simple
                    const websiteName = document.getElementById('websiteName').value || '[Website Name]';
                    const websiteUrl = document.getElementById('websiteUrl').value || '[Website URL]';
                    const effectiveDate = document.getElementById('effectiveDate').value || '[Date]';
                    const agentName = document.getElementById('agentName').value || '[Agent Name]';
                    const agentAddress = document.getElementById('agentAddress').value || '[Agent Address]';
                    const agentEmail = document.getElementById('agentEmail').value || '[Agent Email]';
                    const agentPhone = document.getElementById('agentPhone').value || '[Agent Phone]';
                    const options = {
                        repeatInfringer: document.getElementById('repeatInfringer').checked,
                        counterNotice: document.getElementById('counterNotice').checked
                    };
                    content = generateHTML(websiteName, websiteUrl, effectiveDate, agentName, agentAddress, agentEmail, agentPhone, options);
                    filename = 'dmca-policy.html';
                    mimeType = 'text/html';
                } else {
                    content = document.getElementById('markdownContent').textContent;
                    filename = 'dmca-policy.md';
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
                    // Re-generate to get the code string
                    const websiteName = document.getElementById('websiteName').value || '[Website Name]';
                    const websiteUrl = document.getElementById('websiteUrl').value || '[Website URL]';
                    const effectiveDate = document.getElementById('effectiveDate').value || '[Date]';
                    const agentName = document.getElementById('agentName').value || '[Agent Name]';
                    const agentAddress = document.getElementById('agentAddress').value || '[Agent Address]';
                    const agentEmail = document.getElementById('agentEmail').value || '[Agent Email]';
                    const agentPhone = document.getElementById('agentPhone').value || '[Agent Phone]';
                    const options = {
                        repeatInfringer: document.getElementById('repeatInfringer').checked,
                        counterNotice: document.getElementById('counterNotice').checked
                    };
                    content = generateHTML(websiteName, websiteUrl, effectiveDate, agentName, agentAddress, agentEmail, agentPhone, options);
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
                document.getElementById('dmcaForm').reset();
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('effectiveDate').value = today;
                generatePolicy();
            }
        </script>
</body>

</html>