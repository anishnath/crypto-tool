<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String qShortcode = request.getParameter("q");
    if (qShortcode == null) qShortcode = "";
    // Allow-list characters from S3UrlShortner.generateShortCode (Base64 URL alphabet, no padding).
    qShortcode = qShortcode.replaceAll("[^A-Za-z0-9_-]", "");
    boolean isViewMode = qShortcode.length() > 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <% if (isViewMode) { %>
    <meta name="robots" content="noindex, nofollow">
    <% } else { %>
    <meta name="robots" content="index,follow">
    <% } %>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <%--
      SEO targets (per session 2026-05-26):
        Title  : head query "one time secret" + "send password securely". 55 char visual.
        Desc   : action-led, 149 char visual.
        Keywords: head terms + intent variants + competitor steal (onetimesecret/privatebin alternative).
        Features: benefit-led for WebApplication rich snippet.
        HowTo   : verb-first steps for HowTo rich result.
        FAQ x8 : verbatim Google PAA queries, answers 150-280 chars (rich-result band).
      Note: JSP forbids comments inside <jsp:include> body — keep all commentary out here.
    --%>
    <% if (!isViewMode) { %>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free One-Time Secret - Send Passwords &amp; API Keys Safely" />
        <jsp:param name="toolDescription" value="Send passwords, API keys &amp; secrets via a one-time encrypted link. AES-256-GCM in your browser, burn-after-read, configurable expiry. Free, no signup." />
        <jsp:param name="toolCategory" value="Security" />
        <jsp:param name="toolUrl" value="securebin.jsp" />
        <jsp:param name="toolKeywords" value="one time secret, send password securely, share password online, encrypted pastebin, burn after read, self destructing note, send api key, share api key securely, secure note sharing, one time link, temporary secret, private paste, encrypted note, share credentials securely, anonymous paste, e2ee, end-to-end encryption, zero knowledge, aes-256-gcm, web crypto, onetimesecret alternative, privatebin alternative, share secret link" />
        <jsp:param name="toolImage" value="securebin.png" />
        <jsp:param name="toolFeatures" value="One-time encrypted link for passwords and API keys,Burn-after-read by default (single view destroys the secret),AES-256-GCM client-side encryption in the browser,Zero-knowledge: server never sees plaintext or password,Configurable expiry from 5 minutes to 7 days,Configurable view cap (1 / 3 / 5 / unlimited),Separate URL and password for defense in depth,Free OneTimeSecret and PrivateBin alternative,No signup, no tracking, no email required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Paste your secret|Type or paste the password API key or sensitive text into the editor,Set expiry and views|Pick how long the link stays alive (5 min to 7 days) and how many times it can be opened (1 to unlimited),Create the encrypted link|Click Create Encrypted Secret &mdash; your text is encrypted in the browser with AES-256-GCM and you get a one-time URL plus a random password,Share via separate channels|Send the URL by email and the password by Slack or SMS &mdash; splitting them means a single intercepted channel does not leak the secret,Recipient decrypts in browser|The recipient opens the link confirms the Reveal gate enters the password and reads the plaintext once &mdash; then the link is burned" />
        <jsp:param name="faq1q" value="How do I send a password securely over email?" />
        <jsp:param name="faq1a" value="Don't put the password in the email itself. Use a one-time encrypted link: paste the password here, get a short URL and a separate random password, then email the URL and send the password through a different channel (Slack, SMS, phone). The link self-destructs after the first view." />
        <jsp:param name="faq2q" value="What is a one-time secret?" />
        <jsp:param name="faq2a" value="A one-time secret is an encrypted message stored at a short URL that can be opened only once. After the first read the server deletes the record and any later visit returns 410 Gone. It's the standard way to share passwords, API keys, and credentials without leaving them in chat history or inboxes." />
        <jsp:param name="faq3q" value="How does burn-after-read work?" />
        <jsp:param name="faq3a" value="When the recipient clicks Reveal, the server atomically increments a view counter and &mdash; if the configured cap (default 1) is reached &mdash; deletes the database record before serving the ciphertext. Any subsequent visit returns a generic 410 Gone, so the secret cannot be replayed." />
        <jsp:param name="faq4q" value="What's the safest way to share API keys with a teammate?" />
        <jsp:param name="faq4a" value="Generate a one-time encrypted link, set view cap to 1 (burn after read), email the URL, and send the random password through Slack or SMS. Rotate the key after they confirm receipt. Never paste API keys into a chat message, ticket, or git commit &mdash; those persist forever." />
        <jsp:param name="faq5q" value="How long does the secret link last?" />
        <jsp:param name="faq5a" value="You choose: 5 minutes, 1 hour, 24 hours (default), or 7 days. Whichever happens first &mdash; expiry timeout or view cap &mdash; destroys the secret. Recipients see a generic 'no longer available' message after that; expired, burned, and invalid all return the same 410 response to avoid a shortcode-guessing oracle." />
        <jsp:param name="faq6q" value="Is this a free OneTimeSecret or PrivateBin alternative?" />
        <jsp:param name="faq6a" value="Yes. Same core model as OneTimeSecret and PrivateBin &mdash; encrypted one-time links &mdash; but free, with no signup, no email required, no rate limits, and AES-256-GCM via the browser's native Web Crypto API. The server only ever sees ciphertext." />
        <jsp:param name="faq7q" value="Is it actually end-to-end encrypted?" />
        <jsp:param name="faq7a" value="Yes. Encryption runs in your browser with AES-256-GCM before any network call. A 16-character random password is hashed with SHA-256 to derive the AES key, a fresh 96-bit IV is generated per encryption, and only the ciphertext + IV are uploaded. The server never sees plaintext or password." />
        <jsp:param name="faq8q" value="Do I need an account to use it?" />
        <jsp:param name="faq8a" value="No. No account, no email required (optional notification only), no tracking on the secret view page, and no limit on the number of secrets you can create. Just paste, share, done." />
    </jsp:include>
    <% } else { %>
    <title>View Secret | One-Time Encrypted Link | 8gwifi.org</title>
    <meta name="description" content="View a one-time encrypted secret. End-to-end encrypted in the browser.">
    <% } %>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- Critical CSS -->
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#111827;background:#f9fafb;margin:0}
    </style>

    <!-- Modern layout -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    </noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/securebin.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        /* Cicada tool theme — consumed by tool-page.css for header/breadcrumb tints. */
        :root {
            --tool-primary: oklch(0.601 0.078 133.2);
            --tool-primary-dark: oklch(0.551 0.080 133.2);
            --tool-gradient: linear-gradient(135deg, oklch(0.601 0.078 133.2) 0%, oklch(0.551 0.080 133.2) 100%);
            --tool-light: oklch(0.601 0.078 133.2 / 0.12);
        }
        [data-theme="dark"] {
            --tool-gradient: linear-gradient(135deg, oklch(0.651 0.080 133.2) 0%, oklch(0.601 0.078 133.2) 100%);
            --tool-light: oklch(0.601 0.078 133.2 / 0.18);
        }
        /* three-column-tool.css isn't loaded here, so apply the nav offset locally. */
        .tool-page-header {
            margin-top: var(--header-height-desktop, 72px);
            background: var(--bg-primary, #ffffff);
            border-bottom: 1px solid var(--border, #e2e8f0);
            padding: 0.7rem 1.25rem 0.55rem;
        }
        .tool-page-header-inner {
            max-width: 1500px; margin: 0 auto;
            display: flex; align-items: center; justify-content: space-between;
            flex-wrap: wrap; gap: 0.75rem;
        }
        .tool-page-title { font-size: 1.2rem; font-weight: 700; letter-spacing: -0.02em; margin: 0; }
        .tool-breadcrumbs { margin-top: 0.2rem; font-size: 0.78rem; }
        .tool-page-badges { display: flex; gap: 0.35rem; flex-wrap: wrap; }
        .tool-badge {
            padding: 0.15rem 0.5rem; font-size: 0.68rem; font-weight: 600;
            border-radius: 999px; background: var(--tool-light); color: var(--tool-primary);
        }
        .tool-description-section {
            padding: 0.5rem 1.25rem 0.625rem;
            max-width: 1500px; margin: 0 auto;
        }
        .tool-description-inner {
            display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 1rem; align-items: center;
        }
        @media (max-width: 900px) { .tool-description-inner { grid-template-columns: 1fr; } }
        .tool-description-content p {
            margin: 0;
            font-size: 0.875rem;
            line-height: 1.45;
            color: var(--text-secondary, #4b5563);
        }
        /* Create mode: no description copy, so the ad uses the whole row. */
        .tool-description-ad-full {
            width: 100%;
            display: flex;
            justify-content: center;
            min-height: 90px;
        }
        .tool-description-ad-full > * { width: 100%; max-width: 970px; }
        @media (max-width: 768px) {
            .tool-page-header { margin-top: var(--header-height-mobile, 64px); padding: 0.6rem 0.875rem 0.5rem; }
            .tool-description-section { padding: 0.5rem 0.875rem 0.625rem; }
        }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title"><% if (isViewMode) { %>View Encrypted Secret<% } else { %>Encrypted Pastebin – One-Time Secret Sharing<% } %></h1>
            <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                <a href="<%=request.getContextPath()%>/">Home</a> /
                <a href="<%=request.getContextPath()%>/index.jsp#sharing">Sharing Tools</a> /
                <span><% if (isViewMode) { %>View Secret<% } else { %>Secure Secret Sharing<% } %></span>
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">E2EE</span>
            <span class="tool-badge">Burn-After-Read</span>
            <span class="tool-badge">Zero-Knowledge</span>
        </div>
    </div>
</header>

<section class="tool-description-section">
<% if (isViewMode) { %>
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>One-time encrypted secret. Opening may consume the only view — don't open from a link preview.</p>
        </div>
        <div class="tool-description-ad">
            <%@ include file="modern/ads/ad-in-content-top.jsp" %>
        </div>
    </div>
<% } else { %>
    <div class="tool-description-ad tool-description-ad-full">
        <%@ include file="modern/ads/ad-in-content-top.jsp" %>
    </div>
<% } %>
</section>

<main class="sb-layout">
    <div>
<% if (isViewMode) { %>
    <!-- ──────────────── VIEW MODE ──────────────── -->
    <div class="sb-reveal-gate" id="sb-reveal-gate">
        <div class="sb-reveal-gate-icon" aria-hidden="true">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2C8 7 7 11 9 14a3 3 0 0 0 6 0c2-3 1-7-3-12z"/></svg>
        </div>
        <div style="flex:1">
            <div class="sb-reveal-gate-title">This may be a one-time secret</div>
            <p>Opening it can consume the only available view. Confirm you're ready to read it now — don't open from a link preview, a mail-scanner sandbox, or a shared screen.</p>
            <button id="sb-reveal-btn" type="button" class="sb-btn">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 9.9-1"/></svg>
                Click to reveal secret
            </button>
        </div>
    </div>

    <div class="sb-grid-2" id="sb-secret-wrap" style="display:none">
        <div class="sb-card">
            <div class="sb-card-header sb-header-neutral">
                <span>Shared Content</span>
                <span class="sb-muted sb-mono" style="margin-left:auto;font-size:0.75rem">ID: <%= qShortcode %></span>
            </div>
            <div class="sb-card-body">
                <div id="sb-loading" class="sb-loading">
                    <div class="sb-spinner" aria-hidden="true"></div>
                    <div id="sb-loading-msg">Fetching encrypted secret from secure storage...</div>
                </div>

                <textarea id="sb-decrypted" class="sb-decrypted" readonly style="display:none" aria-label="Decrypted secret"></textarea>

                <div id="sb-success-banner" class="sb-banner sb-banner-success" style="display:none;margin-top:0.875rem;margin-bottom:0">
                    <strong>Secret decrypted.</strong> Copy or download it now — this view may have been the only one.
                </div>

                <div class="sb-btn-row" style="margin-top:0.875rem">
                    <button id="sb-decrypt-copy" type="button" class="sb-btn sb-btn-secondary">Copy</button>
                    <button id="sb-decrypt-wrap" type="button" class="sb-btn sb-btn-ghost">Wrap</button>
                    <button id="sb-decrypt-download" type="button" class="sb-btn sb-btn-ghost">Download</button>
                    <span class="sb-muted" style="margin-left:auto;font-size:0.8125rem"><span id="sb-char-view">0</span> characters</span>
                </div>
            </div>
        </div>

        <aside class="sb-sidekick">
            <div class="sb-card">
                <div class="sb-card-header sb-header-neutral">Security Tips</div>
                <div class="sb-card-body">
                    <ul>
                        <li><strong>Single-use by default.</strong> The link may stop working immediately after this view.</li>
                        <li><strong>Use Copy.</strong> Avoid screenshots — they can leak sensitive data.</li>
                        <li><strong>Verify the sender.</strong> Make sure you trust whoever sent the link.</li>
                        <li><strong>Trusted device.</strong> Decrypt only on a private device.</li>
                        <li><strong>Close the tab.</strong> Clear history if viewing on a shared machine.</li>
                        <li><strong>Rotate.</strong> Change shared credentials after use.</li>
                    </ul>
                </div>
            </div>
            <div class="sb-card">
                <div class="sb-card-header sb-header-neutral">How It Works</div>
                <div class="sb-card-body">
                    <ol>
                        <li>Enter the password the sender shared separately.</li>
                        <li>Content decrypts <strong>in your browser</strong> using AES-256-GCM.</li>
                        <li>The server never sees plaintext or password.</li>
                        <li>Secret expires after the configured window or view cap.</li>
                    </ol>
                </div>
            </div>
        </aside>
    </div>

    <dialog id="sb-password-dialog" class="sb-dialog" aria-labelledby="sb-dialog-title">
        <div class="sb-dialog-header" id="sb-dialog-title">Password Required to Decrypt</div>
        <div class="sb-dialog-body">
            <div class="sb-banner sb-banner-info" style="margin-bottom:0.875rem">
                The password was sent separately by the sender. Check your other channels (Slack, SMS, email).
            </div>
            <label class="sb-label" for="sb-password-input">Decryption password</label>
            <div class="sb-input-group">
                <input id="sb-password-input" class="sb-input sb-mono" type="password" placeholder="Paste password here..." autocomplete="off">
                <button id="sb-password-show" type="button" class="sb-input-group-btn">Show</button>
            </div>
            <div id="sb-password-error" class="sb-error-text">Password required.</div>
        </div>
        <div class="sb-dialog-footer">
            <button id="sb-password-cancel" type="button" class="sb-btn sb-btn-secondary">Cancel</button>
            <button id="sb-password-submit" type="button" class="sb-btn">Decrypt Secret</button>
        </div>
    </dialog>

<% } else { %>
    <!-- ──────────────── CREATE MODE ──────────────── -->
    <div class="sb-grid-2">
        <div class="sb-card">
            <div class="sb-card-header">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                Create Encrypted Secret
            </div>
            <div class="sb-card-body">
                <div class="sb-banner sb-banner-info">
                    Your secret is encrypted in your browser before upload. You get a URL and password — share them via different channels.
                </div>

                <div class="sb-field">
                    <label class="sb-label" for="sb-email">Recipient Email <span class="sb-label-hint">(optional)</span></label>
                    <input id="sb-email" class="sb-input" type="email" placeholder="name@example.com" autocomplete="email">
                    <div class="sb-meta-row"><span>We email <strong>only the URL</strong> — share the password separately.</span></div>
                </div>

                <div class="sb-field">
                    <label class="sb-label" for="sb-text">Secret Content <span style="color:var(--sb-destructive)">*</span></label>
                    <textarea id="sb-text" class="sb-textarea" rows="8" placeholder="Paste or type your sensitive text here..."></textarea>
                    <div class="sb-meta-row">
                        <span>Encrypted with AES-256-GCM before upload.</span>
                        <span><strong id="sb-char-count">0</strong> characters</span>
                    </div>
                    <div id="sb-validation-error" class="sb-error-text">Please enter secret content before creating.</div>
                </div>

                <div class="sb-row">
                    <div class="sb-field">
                        <label class="sb-label" for="sb-expiry">Expires in</label>
                        <select id="sb-expiry" class="sb-select">
                            <option value="300">5 minutes</option>
                            <option value="3600">1 hour</option>
                            <option value="86400" selected>24 hours</option>
                            <option value="604800">7 days</option>
                        </select>
                    </div>
                    <div class="sb-field">
                        <label class="sb-label" for="sb-max-views">Allowed views</label>
                        <select id="sb-max-views" class="sb-select">
                            <option value="1" selected>1 view (burn after read)</option>
                            <option value="3">3 views</option>
                            <option value="5">5 views</option>
                            <option value="0">Unlimited until expiry</option>
                        </select>
                    </div>
                </div>

                <div class="sb-banner sb-banner-warn">
                    <strong>Reminder:</strong> only share secrets you're authorized to transmit. Never share your master passwords or 2FA recovery codes.
                </div>

                <div class="sb-btn-row">
                    <button id="sb-create-btn" type="button" class="sb-btn">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                        Create Encrypted Secret
                    </button>
                    <button id="sb-reset-btn" type="button" class="sb-btn sb-btn-secondary">Clear</button>
                </div>

                <div id="sb-progress" class="sb-progress" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                    <div id="sb-progress-bar" class="sb-progress-bar"></div>
                </div>
            </div>
        </div>

        <div class="sb-card">
            <div class="sb-card-header sb-header-neutral">Result</div>
            <div class="sb-card-body" id="sb-result-container">
                <div class="sb-result-empty">
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 12h18M3 6h18M3 18h18"/></svg>
                    <div>Enter your secret and click <strong>Create Encrypted Secret</strong> to generate a secure link.</div>
                </div>
            </div>
        </div>
    </div>
<% } %>
    </div>

    <aside>
        <%@ include file="modern/ads/ad-right-sidebar.jsp" %>
    </aside>
</main>

<% if (!isViewMode) { %>
<!-- Educational content (only on create page; view page stays minimal for fast secret access) -->
<section class="sb-content-section">
    <div class="sb-content-container">
        <h2 class="sb-section-title">How It Works</h2>
        <div class="sb-grid-2">
            <div>
                <h3 class="sb-section-subtitle">Process</h3>
                <ol style="padding-left:1.25rem">
                    <li><strong>Encrypt locally.</strong> Your browser runs AES-256-GCM on the secret before any network call.</li>
                    <li><strong>Upload ciphertext.</strong> Only encrypted bytes leave your machine.</li>
                    <li><strong>Receive URL + password.</strong> A short link and a 16-character random password.</li>
                    <li><strong>Share separately.</strong> Send the URL by email and the password by Slack/SMS.</li>
                    <li><strong>Recipient views.</strong> They open the link, click reveal, paste the password, the browser decrypts.</li>
                    <li><strong>Burns.</strong> By default the link is single-use and is deleted from the database on first reveal.</li>
                </ol>
            </div>
            <div>
                <h3 class="sb-section-subtitle">Security Properties</h3>
                <ul style="padding-left:1.25rem">
                    <li><strong>AES-256-GCM:</strong> authenticated encryption with 256-bit keys.</li>
                    <li><strong>Client-side only:</strong> Web Crypto API; no plaintext or password ever leaves your browser.</li>
                    <li><strong>Random IV:</strong> fresh 96-bit IV per encryption, prepended to ciphertext.</li>
                    <li><strong>CSPRNG password:</strong> <code>crypto.getRandomValues</code>.</li>
                    <li><strong>Atomic burn:</strong> single conditional SQL UPDATE enforces the view cap race-free.</li>
                    <li><strong>Generic 410 on miss:</strong> expired vs. burned vs. invalid all return the same response — no shortcode-guessing oracle.</li>
                </ul>
            </div>
        </div>

        <h2 class="sb-section-title" style="margin-top:2rem">Real-World Use Cases</h2>
        <div class="sb-use-cases">
            <div class="sb-card"><div class="sb-card-body">
                <h4>DevOps &amp; IT</h4>
                <ul><li>SSH private keys</li><li>API keys for cloud services</li><li>DB credentials for contractors</li><li>Kubernetes secrets</li></ul>
            </div></div>
            <div class="sb-card"><div class="sb-card-body">
                <h4>Remote Work</h4>
                <ul><li>VPN credentials</li><li>Temporary passwords for new hires</li><li>Wi-Fi passwords</li><li>2FA backup codes</li></ul>
            </div></div>
            <div class="sb-card"><div class="sb-card-body">
                <h4>Client Communications</h4>
                <ul><li>FTP/SFTP credentials</li><li>CMS admin passwords</li><li>License/activation keys</li><li>Client portal accounts</li></ul>
            </div></div>
            <div class="sb-card"><div class="sb-card-body">
                <h4>Security &amp; Compliance</h4>
                <ul><li>Incident-response credentials</li><li>Encryption keys</li><li>Audit reports w/ sensitive findings</li><li>Compliance doc passwords</li></ul>
            </div></div>
        </div>

        <h2 class="sb-section-title" style="margin-top:2rem">Best Practices</h2>
        <div class="sb-do-dont">
            <div class="sb-do">
                <h4>Do</h4>
                <ul style="padding-left:1.25rem">
                    <li>Use separate channels for URL and password.</li>
                    <li>Verify recipient identity before sharing.</li>
                    <li>Send when the recipient is ready to act.</li>
                    <li>Test once with a non-sensitive value if unsure.</li>
                    <li>Clear original plaintext from your clipboard after sharing.</li>
                </ul>
            </div>
            <div class="sb-dont">
                <h4>Don't</h4>
                <ul style="padding-left:1.25rem">
                    <li>Share your password-manager master password here.</li>
                    <li>Send URL + password in the same message.</li>
                    <li>Use this for long-lived credentials.</li>
                    <li>Share 2FA recovery codes — store them, don't transmit.</li>
                </ul>
            </div>
        </div>

        <h2 class="sb-section-title" style="margin-top:2rem">FAQ</h2>
        <div class="sb-faq">
            <details><summary>How do I send a password securely over email?</summary>
                <p>Don't put the password in the email itself. Use a one-time encrypted link: paste the password here, get a short URL and a separate random password, then email the URL and send the password through a different channel (Slack, SMS, phone). The link self-destructs after the first view.</p></details>
            <details><summary>What is a one-time secret?</summary>
                <p>A one-time secret is an encrypted message stored at a short URL that can be opened only once. After the first read the server deletes the record and any later visit returns 410 Gone. It's the standard way to share passwords, API keys, and credentials without leaving them in chat history or inboxes.</p></details>
            <details><summary>How does burn-after-read work?</summary>
                <p>When the recipient clicks Reveal, the server atomically increments a view counter and &mdash; if the configured cap (default 1) is reached &mdash; deletes the database record before serving the ciphertext. Any subsequent visit returns a generic 410 Gone, so the secret cannot be replayed.</p></details>
            <details><summary>What's the safest way to share API keys with a teammate?</summary>
                <p>Generate a one-time encrypted link, set view cap to 1 (burn after read), email the URL, and send the random password through Slack or SMS. Rotate the key after they confirm receipt. Never paste API keys into a chat message, ticket, or git commit &mdash; those persist forever.</p></details>
            <details><summary>How long does the secret link last?</summary>
                <p>You choose: 5 minutes, 1 hour, 24 hours (default), or 7 days. Whichever happens first &mdash; expiry timeout or view cap &mdash; destroys the secret. Recipients see a generic 'no longer available' message after that; expired, burned, and invalid all return the same 410 response to avoid a shortcode-guessing oracle.</p></details>
            <details><summary>Is this a free OneTimeSecret or PrivateBin alternative?</summary>
                <p>Yes. Same core model as OneTimeSecret and PrivateBin &mdash; encrypted one-time links &mdash; but free, with no signup, no email required, no rate limits, and AES-256-GCM via the browser's native Web Crypto API. The server only ever sees ciphertext.</p></details>
            <details><summary>Is it actually end-to-end encrypted?</summary>
                <p>Yes. Encryption runs in your browser with AES-256-GCM before any network call. A 16-character random password is hashed with SHA-256 to derive the AES key, a fresh 96-bit IV is generated per encryption, and only the ciphertext + IV are uploaded. The server never sees plaintext or password.</p></details>
            <details><summary>Do I need an account to use it?</summary>
                <p>No. No account, no email required (optional notification only), no tracking on the secret view page, and no limit on the number of secrets you can create. Just paste, share, done.</p></details>
        </div>
    </div>
</section>
<% } %>

<%@ include file="modern/components/support-section.jsp" %>
<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<script>
window.SECUREBIN_CONFIG = {
    apiBase:   '<%=request.getContextPath()%>/pastebin',
    ctxPath:   '<%=request.getContextPath()%>',
    shortcode: '<%= qShortcode %>'
};
</script>
<script defer src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script defer src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
<script defer src="<%=request.getContextPath()%>/modern/js/search.js"></script>
<script defer src="<%=request.getContextPath()%>/js/securebin.js?v=<%=cacheVersion%>"></script>
</body>
</html>
