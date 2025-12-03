<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Free App Privacy Policy Generator & Template (GDPR/CCPA) | 8gwifi.org</title>
        <meta name="description"
            content="Generate a free, GDPR & CCPA compliant privacy policy for your mobile app (iOS & Android). Perfect for Google Play Store & Apple App Store. Includes templates for AdMob, Firebase, Facebook, and more. No signup required.">
        <meta name="keywords"
            content="privacy policy generator, app privacy policy template, mobile app privacy policy sample, free privacy policy generator, gdpr privacy policy, ccpa privacy policy, play store privacy policy url, app store privacy policy generator, admob privacy policy, firebase privacy policy, privacy policy for android app, privacy policy for ios app">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "App Privacy Policy Generator",
      "description": "Generate professional privacy policies for mobile applications. Compliant with Play Store and App Store requirements.",
      "url": "https://8gwifi.org/app-privacy-policy-generator.jsp",
      "applicationCategory": "DeveloperApplication",
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
        "Free Privacy Policy Template",
        "GDPR & CCPA Compliant",
        "Google Play & App Store Ready",
        "Support for AdMob, Firebase, Facebook",
        "HTML & Markdown Export",
        "Instant Preview"
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

                .service-checkbox {
                    display: flex;
                    align-items: center;
                    padding: 0.5rem;
                    border-radius: 4px;
                    transition: background 0.2s;
                }

                .service-checkbox:hover {
                    background: rgba(79, 70, 229, 0.05);
                }

                .service-checkbox label {
                    margin-bottom: 0;
                    margin-left: 0.5rem;
                    cursor: pointer;
                    width: 100%;
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
                        <h1 class="h3 mb-0">App Privacy Policy Generator</h1>
                        <p class="text-muted mb-0">Create GDPR/CCPA compliant privacy policies for iOS & Android apps
                        </p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-edit mr-2"></i> App Details
                            </div>
                            <div class="card-body">

                                <!-- General Info -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-info-circle"></i> General
                                        Information</div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>App Name</label>
                                                <input type="text" class="form-control" id="appName"
                                                    placeholder="e.g. My Awesome App">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Contact Email</label>
                                                <input type="email" class="form-control" id="contactEmail"
                                                    placeholder="support@example.com">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Developer Name/Company</label>
                                                <input type="text" class="form-control" id="devName"
                                                    placeholder="John Doe or Company Inc.">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>App Type</label>
                                                <select class="form-control" id="appType">
                                                    <option value="Free">Free</option>
                                                    <option value="Freemium">Freemium</option>
                                                    <option value="Commercial">Commercial</option>
                                                    <option value="Ad Supported">Ad Supported</option>
                                                    <option value="Open Source">Open Source</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Mobile OS</label>
                                                <select class="form-control" id="osType">
                                                    <option value="Android & iOS">Android & iOS</option>
                                                    <option value="Android">Android</option>
                                                    <option value="iOS">iOS</option>
                                                </select>
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

                                <!-- Data Collection -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-database"></i> Data Collection
                                    </div>
                                    <p class="text-muted small">Select the types of data your app collects:</p>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input data-check"
                                                    id="dataName" value="Name">
                                                <label class="custom-control-label" for="dataName">Name /
                                                    Username</label>
                                            </div>
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input data-check"
                                                    id="dataEmail" value="Email Address">
                                                <label class="custom-control-label" for="dataEmail">Email
                                                    Address</label>
                                            </div>
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input data-check"
                                                    id="dataPhone" value="Phone Number">
                                                <label class="custom-control-label" for="dataPhone">Phone Number</label>
                                            </div>
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input data-check"
                                                    id="dataLocation" value="Location Data">
                                                <label class="custom-control-label" for="dataLocation">Location
                                                    (GPS/Network)</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input data-check"
                                                    id="dataDevice" value="Device ID" checked>
                                                <label class="custom-control-label" for="dataDevice">Device ID /
                                                    Advertising ID</label>
                                            </div>
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input data-check"
                                                    id="dataCookies" value="Cookies" checked>
                                                <label class="custom-control-label" for="dataCookies">Cookies</label>
                                            </div>
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input data-check"
                                                    id="dataUsage" value="Usage Data" checked>
                                                <label class="custom-control-label" for="dataUsage">Usage Data /
                                                    Analytics</label>
                                            </div>
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input data-check"
                                                    id="dataCrash" value="Crash Logs" checked>
                                                <label class="custom-control-label" for="dataCrash">Crash Logs</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row mt-2">
                                        <div class="col-12">
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input data-check"
                                                    id="dataPayment" value="Payment Information">
                                                <label class="custom-control-label" for="dataPayment">Payment
                                                    Information (Transactions, Purchase History)</label>
                                            </div>
                                            <div class="custom-control custom-checkbox mb-2">
                                                <input type="checkbox" class="custom-control-input data-check"
                                                    id="dataPhotos" value="Photos and Videos">
                                                <label class="custom-control-label" for="dataPhotos">Photos / Media /
                                                    Files</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Third Party Services -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-plug"></i> Third Party Services
                                    </div>
                                    <p class="text-muted small">Select the third-party services integrated into your
                                        app:</p>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="service-checkbox">
                                                <input type="checkbox" class="service-check" id="svcGms" value="gms"
                                                    checked>
                                                <label for="svcGms">Google Play Services</label>
                                            </div>
                                            <div class="service-checkbox">
                                                <input type="checkbox" class="service-check" id="svcAdmob"
                                                    value="admob">
                                                <label for="svcAdmob">AdMob</label>
                                            </div>
                                            <div class="service-checkbox">
                                                <input type="checkbox" class="service-check" id="svcFirebaseAnalytics"
                                                    value="firebase_analytics">
                                                <label for="svcFirebaseAnalytics">Google Analytics for Firebase</label>
                                            </div>
                                            <div class="service-checkbox">
                                                <input type="checkbox" class="service-check" id="svcFirebaseCrash"
                                                    value="firebase_crashlytics">
                                                <label for="svcFirebaseCrash">Firebase Crashlytics</label>
                                            </div>
                                            <div class="service-checkbox">
                                                <input type="checkbox" class="service-check" id="svcFacebook"
                                                    value="facebook">
                                                <label for="svcFacebook">Facebook SDK / Audience Network</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="service-checkbox">
                                                <input type="checkbox" class="service-check" id="svcUnity"
                                                    value="unity">
                                                <label for="svcUnity">Unity Ads</label>
                                            </div>
                                            <div class="service-checkbox">
                                                <input type="checkbox" class="service-check" id="svcAppLovin"
                                                    value="applovin">
                                                <label for="svcAppLovin">AppLovin</label>
                                            </div>
                                            <div class="service-checkbox">
                                                <input type="checkbox" class="service-check" id="svcOneSignal"
                                                    value="onesignal">
                                                <label for="svcOneSignal">OneSignal</label>
                                            </div>
                                            <div class="service-checkbox">
                                                <input type="checkbox" class="service-check" id="svcSentry"
                                                    value="sentry">
                                                <label for="svcSentry">Sentry</label>
                                            </div>
                                            <div class="service-checkbox">
                                                <input type="checkbox" class="service-check" id="svcAmplitude"
                                                    value="amplitude">
                                                <label for="svcAmplitude">Amplitude</label>
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
                // Third Party Service Links
                const services = {
                    'gms': { name: 'Google Play Services', url: 'https://policies.google.com/privacy' },
                    'admob': { name: 'AdMob', url: 'https://support.google.com/admob/answer/6128543?hl=en' },
                    'firebase_analytics': { name: 'Google Analytics for Firebase', url: 'https://firebase.google.com/policies/analytics' },
                    'firebase_crashlytics': { name: 'Firebase Crashlytics', url: 'https://firebase.google.com/support/privacy/' },
                    'facebook': { name: 'Facebook', url: 'https://www.facebook.com/about/privacy/update/printable' },
                    'unity': { name: 'Unity Ads', url: 'https://unity3d.com/legal/privacy-policy' },
                    'applovin': { name: 'AppLovin', url: 'https://www.applovin.com/privacy/' },
                    'onesignal': { name: 'OneSignal', url: 'https://onesignal.com/privacy_policy' },
                    'sentry': { name: 'Sentry', url: 'https://sentry.io/privacy/' },
                    'amplitude': { name: 'Amplitude', url: 'https://amplitude.com/privacy' }
                };

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
                    const appName = document.getElementById('appName').value || '[App Name]';
                    const devName = document.getElementById('devName').value || '[Developer Name]';
                    const contactEmail = document.getElementById('contactEmail').value || '[Contact Email]';
                    const appType = document.getElementById('appType').value;
                    const osType = document.getElementById('osType').value;
                    const effectiveDate = document.getElementById('effectiveDate').value;

                    // Collect Data Types
                    const dataTypes = [];
                    document.querySelectorAll('.data-check:checked').forEach(cb => {
                        dataTypes.push(cb.value);
                    });

                    // Collect Services
                    const selectedServices = [];
                    document.querySelectorAll('.service-check:checked').forEach(cb => {
                        if (services[cb.value]) {
                            selectedServices.push(services[cb.value]);
                        }
                    });

                    // Generate HTML
                    const html = generateHTML(appName, devName, contactEmail, appType, osType, effectiveDate, dataTypes, selectedServices);

                    // Generate Markdown
                    const markdown = generateMarkdown(appName, devName, contactEmail, appType, osType, effectiveDate, dataTypes, selectedServices);

                    // Update Outputs
                    document.getElementById('previewOutput').innerHTML = html;
                    document.getElementById('htmlOutput').textContent = html;
                    document.getElementById('markdownOutput').textContent = markdown;
                }

                function generateHTML(appName, devName, contactEmail, appType, osType, effectiveDate, dataTypes, selectedServices) {
                    let serviceLinks = '';
                    if (selectedServices.length > 0) {
                        serviceLinks = '<p>The app does use third-party services that may collect information used to identify you.</p>' +
                            '<p>Link to privacy policy of third-party service providers used by the app:</p><ul>';
                        selectedServices.forEach(svc => {
                            serviceLinks += `<li><a href="${svc.url}" target="_blank" rel="noopener noreferrer">${svc.name}</a></li>`;
                        });
                        serviceLinks += '</ul>';
                    }

                    let dataList = '';
                    if (dataTypes.length > 0) {
                        dataList = '<p>The app may collect the following information:</p><ul>';
                        dataTypes.forEach(data => {
                            dataList += `<li>${data}</li>`;
                        });
                        dataList += '</ul>';
                    }

                    return `<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width'>
    <title>Privacy Policy</title>
    <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
    <h2>Privacy Policy</h2>
    <p><strong>${devName}</strong> built the <strong>${appName}</strong> app as a <strong>${appType}</strong> app. This SERVICE is provided by ${devName} at no cost and is intended for use as is.</p>
    
    <p>This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.</p>
    
    <p>If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.</p>
    
    <h3>Information Collection and Use</h3>
    <p>For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way.</p>
    ${dataList}
    ${serviceLinks}

    <h3>Log Data</h3>
    <p>I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol ("IP") address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.</p>

    <h3>Cookies</h3>
    <p>Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.</p>
    <p>This Service does not use these "cookies" explicitly. However, the app may use third-party code and libraries that use "cookies" to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.</p>

    <h3>Service Providers</h3>
    <p>I may employ third-party companies and individuals due to the following reasons:</p>
    <ul>
        <li>To facilitate our Service;</li>
        <li>To provide the Service on our behalf;</li>
        <li>To perform Service-related services; or</li>
        <li>To assist us in analyzing how our Service is used.</li>
    </ul>
    <p>I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.</p>

    <h3>Security</h3>
    <p>I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.</p>

    <h3>Links to Other Sites</h3>
    <p>This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.</p>

    <h3>Data Retention Policy</h3>
    <p>I will retain your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. I will retain and use your Personal Data to the extent necessary to comply with my legal obligations (for example, if I am required to retain your data to comply with applicable laws), resolve disputes, and enforce my legal agreements and policies.</p>

    <h3>Opt-Out Rights</h3>
    <p>You can stop all collection of information by the App easily by uninstalling the App. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.</p>

    <h3>Children's Privacy</h3>
    <p>These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions.</p>

    <h3>Changes to This Privacy Policy</h3>
    <p>I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.</p>
    <p>This policy is effective as of ${effectiveDate}</p>

    <h3>Contact Us</h3>
    <p>If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at ${contactEmail}.</p>
</body>
</html>`;
                }

                function generateMarkdown(appName, devName, contactEmail, appType, osType, effectiveDate, dataTypes, selectedServices) {
                    let serviceLinks = '';
                    if (selectedServices.length > 0) {
                        serviceLinks = 'The app does use third-party services that may collect information used to identify you.\n\n' +
                            'Link to privacy policy of third-party service providers used by the app:\n';
                        selectedServices.forEach(svc => {
                            serviceLinks += `*   [${svc.name}](${svc.url})\n`;
                        });
                        serviceLinks += '\n';
                    }

                    let dataList = '';
                    if (dataTypes.length > 0) {
                        dataList = 'The app may collect the following information:\n';
                        dataTypes.forEach(data => {
                            dataList += `*   ${data}\n`;
                        });
                        dataList += '\n';
                    }

                    return `# Privacy Policy

**${devName}** built the **${appName}** app as a **${appType}** app. This SERVICE is provided by ${devName} at no cost and is intended for use as is.

This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.

If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.

## Information Collection and Use

For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way.

${dataList}
${serviceLinks}

## Log Data

I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol ("IP") address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.

## Cookies

Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.

This Service does not use these "cookies" explicitly. However, the app may use third-party code and libraries that use "cookies" to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.

## Service Providers

I may employ third-party companies and individuals due to the following reasons:

*   To facilitate our Service;
*   To provide the Service on our behalf;
*   To perform Service-related services; or
*   To assist us in analyzing how our Service is used.

I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.

## Security

I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.

## Links to Other Sites

This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.

## Data Retention Policy

I will retain your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. I will retain and use your Personal Data to the extent necessary to comply with my legal obligations (for example, if I am required to retain your data to comply with applicable laws), resolve disputes, and enforce my legal agreements and policies.

## Opt-Out Rights

You can stop all collection of information by the App easily by uninstalling the App. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.

## Children's Privacy

These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions.

## Changes to This Privacy Policy

I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.

This policy is effective as of ${effectiveDate}

## Contact Us

If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at ${contactEmail}.
`;
                }

                function copyContent() {
                    const activeTab = document.querySelector('.tab-pane.active');
                    let content = '';
                    if (activeTab.id === 'preview') {
                        content = document.getElementById('htmlOutput').textContent; // Copy HTML even from preview
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
                    let filename = 'privacy_policy';

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

                function downloadContent() {
                    showSupportModal();
                }

                function resetForm() {
                    if (confirm('Are you sure you want to reset all fields?')) {
                        const inputs = document.querySelectorAll('input');
                        inputs.forEach(input => {
                            if (input.type === 'checkbox') input.checked = false;
                            else if (input.type !== 'date') input.value = '';
                        });
                        document.getElementById('appType').selectedIndex = 0;
                        document.getElementById('osType').selectedIndex = 0;

                        // Re-check defaults
                        document.getElementById('dataDevice').checked = true;
                        document.getElementById('dataCookies').checked = true;
                        document.getElementById('dataUsage').checked = true;
                        document.getElementById('dataCrash').checked = true;
                        document.getElementById('svcGms').checked = true;

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
                                <a href="https://twitter.com/intent/tweet?text=Check%20out%20this%20awesome%20Free%20App%20Privacy%20Policy%20Generator!%20%23devops%20%23mobiledev%20https://8gwifi.org/app-privacy-policy-generator.jsp"
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