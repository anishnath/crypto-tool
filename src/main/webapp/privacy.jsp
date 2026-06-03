<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String effectiveDate = "2026-06-03";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="googlebot" content="index,follow">
    <title>Privacy Policy — 8gwifi.org</title>
    <meta name="description" content="Privacy policy for 8gwifi.org. What we collect, what we don't (no private keys, no plaintext stored), third parties (analytics, ads), cookies, and your rights.">
    <link rel="canonical" href="https://8gwifi.org/privacy.jsp">

    <!-- OpenGraph -->
    <meta property="og:type" content="article">
    <meta property="og:title" content="Privacy Policy — 8gwifi.org">
    <meta property="og:description" content="What 8gwifi.org collects, what it doesn't, and how user data is handled across the tool catalog.">
    <meta property="og:url" content="https://8gwifi.org/privacy.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/logo.png">

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" media="print" onload="this.media='all'">

    <!-- Modern design system -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        :root { --tool-primary: #0ea5e9; --tool-primary-dark: #0284c7; --tool-light: #e0f2fe; }
        [data-theme="dark"] { --tool-light: rgba(14,165,233,0.15); }

        .legal-header {
            padding: 1.5rem 1rem 1rem;
            border-bottom: 1px solid var(--border);
            background: linear-gradient(180deg, var(--tool-light) 0%, var(--bg-primary) 100%);
        }
        .legal-header-inner {
            max-width: 900px;
            margin: 0 auto;
        }
        .legal-page-title {
            font-size: 1.75rem;
            font-weight: 800;
            margin: 0 0 0.35rem;
            letter-spacing: -0.02em;
            color: var(--text-primary);
        }
        .legal-subtitle {
            font-size: 0.8125rem;
            color: var(--text-secondary);
            margin: 0;
        }
        .legal-breadcrumbs {
            font-size: 0.75rem;
            color: var(--text-secondary);
            margin-bottom: 0.5rem;
        }
        .legal-breadcrumbs a {
            color: var(--tool-primary);
            text-decoration: none;
        }
        .legal-breadcrumbs a:hover { text-decoration: underline; }

        .legal-layout {
            max-width: 1100px;
            margin: 1.5rem auto;
            padding: 0 1rem;
            display: grid;
            grid-template-columns: 220px 1fr;
            gap: 2rem;
        }
        @media (max-width: 768px) {
            .legal-layout { grid-template-columns: 1fr; }
            .legal-toc { position: static !important; max-height: none !important; }
        }

        .legal-toc {
            position: sticky;
            top: 1rem;
            align-self: start;
            font-size: 0.8125rem;
            max-height: calc(100vh - 2rem);
            overflow-y: auto;
            padding: 0.75rem 0.5rem;
            border: 1px solid var(--border);
            border-radius: 0.5rem;
            background: var(--bg-secondary);
        }
        .legal-toc-title {
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-secondary);
            padding: 0 0.5rem;
            margin-bottom: 0.5rem;
        }
        .legal-toc ol {
            list-style: none;
            counter-reset: toc;
            padding: 0;
            margin: 0;
        }
        .legal-toc li { counter-increment: toc; margin: 0.1rem 0; }
        .legal-toc a {
            display: block;
            padding: 0.3rem 0.5rem;
            color: var(--text-primary);
            text-decoration: none;
            border-radius: 0.25rem;
            line-height: 1.3;
        }
        .legal-toc a::before {
            content: counter(toc) ".";
            display: inline-block;
            width: 1.5rem;
            color: var(--text-secondary);
            font-variant-numeric: tabular-nums;
        }
        .legal-toc a:hover { background: var(--tool-light); color: var(--tool-primary); }

        .legal-content { font-size: 0.9375rem; line-height: 1.7; color: var(--text-primary); }
        .legal-content section { scroll-margin-top: 1rem; margin-bottom: 2rem; }
        .legal-content h2 {
            font-size: 1.25rem;
            font-weight: 700;
            margin: 0 0 0.6rem;
            padding-bottom: 0.4rem;
            border-bottom: 1px solid var(--border);
            color: var(--text-primary);
            scroll-margin-top: 1rem;
        }
        .legal-content h3 {
            font-size: 1rem;
            font-weight: 600;
            margin: 1.25rem 0 0.4rem;
            color: var(--text-primary);
        }
        .legal-content p { margin: 0 0 0.75rem; color: var(--text-secondary); }
        .legal-content ul { padding-left: 1.25rem; margin: 0 0 0.75rem; }
        .legal-content li { margin: 0.2rem 0; color: var(--text-secondary); }
        .legal-content strong { color: var(--text-primary); font-weight: 600; }
        .legal-content code {
            background: var(--bg-secondary);
            padding: 0.1rem 0.35rem;
            border-radius: 0.25rem;
            font-family: 'JetBrains Mono', 'Fira Code', monospace;
            font-size: 0.85em;
        }
        .legal-content a { color: var(--tool-primary); }

        .legal-tldr {
            margin: 1rem 0 1.5rem;
            padding: 0.85rem 1rem;
            background: var(--tool-light);
            border-left: 4px solid var(--tool-primary);
            border-radius: 0.25rem;
            font-size: 0.875rem;
        }
        .legal-tldr strong { color: var(--tool-primary); }

        .legal-contact-card {
            margin-top: 2rem;
            padding: 1rem 1.25rem;
            border: 1px solid var(--border);
            border-radius: 0.5rem;
            background: var(--bg-secondary);
        }
        .legal-contact-card a { font-weight: 600; }
    </style>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="legal-header">
        <div class="legal-header-inner">
            <nav class="legal-breadcrumbs" aria-label="Breadcrumb">
                <a href="<%=request.getContextPath()%>/">Home</a> / <span>Privacy Policy</span>
            </nav>
            <h1 class="legal-page-title">Privacy Policy</h1>
            <p class="legal-subtitle">Effective: <%=effectiveDate%> · 8gwifi.org</p>
        </div>
    </header>

    <main class="legal-layout">
        <aside class="legal-toc" aria-label="On this page">
            <div class="legal-toc-title">On this page</div>
            <ol>
                <li><a href="#summary">Summary</a></li>
                <li><a href="#what-we-collect">What we collect</a></li>
                <li><a href="#what-we-dont">What we don't collect</a></li>
                <li><a href="#cookies">Cookies &amp; tracking</a></li>
                <li><a href="#third-parties">Third-party services</a></li>
                <li><a href="#server-logs">Server logs &amp; retention</a></li>
                <li><a href="#email">Email features</a></li>
                <li><a href="#google-signin">Sign in with Google &amp; Google user data</a></li>
                <li><a href="#your-rights">Your rights</a></li>
                <li><a href="#children">Children's privacy</a></li>
                <li><a href="#changes">Changes to this policy</a></li>
                <li><a href="#contact">Contact</a></li>
            </ol>
        </aside>

        <div class="legal-content">
            <div class="legal-tldr">
                <strong>TL;DR:</strong> We don't store the private keys, passphrases, plaintext messages, or files you process with our tools. Most tools run entirely in your browser. For tools that round-trip through our server (e.g. <code>ssh-keygen</code>, <code>puttygen</code>), the inputs and outputs are kept only in memory or short-lived temporary files that are deleted after the response is returned. Standard web analytics and ads do apply.
            </div>

            <section id="summary">
                <h2>1. Summary</h2>
                <p>8gwifi.org is a free collection of online cryptography, security, and developer tools. We're built around a strict principle: <strong>process now, store nothing</strong>. The one deliberate exception is the <strong>optional</strong> "Sign in with Google" feature — when (and only when) you choose to sign in, we keep a small account record so features and entitlements follow you between visits. That is documented in full in <a href="#google-signin">§8</a>. This page explains exactly what data is and isn't collected when you use the site, who we share information with, and how to exercise your rights.</p>
            </section>

            <section id="what-we-collect">
                <h2>2. What we collect</h2>

                <h3>Standard web-server data</h3>
                <p>When you visit any page, our hosting provider's logs capture the same information every web server captures:</p>
                <ul>
                    <li>Your IP address (truncated where allowed by analytics settings)</li>
                    <li>User-Agent string (browser and OS)</li>
                    <li>Page URL accessed and timestamp</li>
                    <li>Referrer URL, if your browser sends one</li>
                </ul>

                <h3>Session cookies</h3>
                <p>A short-lived session cookie (<code>JSESSIONID</code>) is created when you load a tool page. It carries a CSRF token (<code>j_csrf</code>) so that operations like "email me my generated key" can't be triggered cross-site. It is destroyed when you close the browser or after a period of inactivity.</p>

                <h3>Form input you submit to a tool</h3>
                <p>When a tool performs server-side computation (e.g. generating an RSA key pair, decoding a PGP packet, running <code>puttygen</code> for format conversion), the input you submit travels over HTTPS to our backend, is processed in memory or a short-lived temporary file, and the result is returned to your browser. The temporary files are deleted before the response is sent. We do not log the content of these inputs or outputs.</p>
            </section>

            <section id="what-we-dont">
                <h2>3. What we don't collect</h2>
                <ul>
                    <li><strong>Private keys</strong> — neither the OpenSSH/PEM private key nor the PuTTY <code>.ppk</code> is persisted on our servers after the response is returned.</li>
                    <li><strong>Passphrases</strong> — used during the request only; not stored, not logged.</li>
                    <li><strong>Plaintext messages</strong> sent through encrypt/decrypt tools.</li>
                    <li><strong>Uploaded files</strong> are processed in memory or in tempfiles deleted in a <code>finally</code> block immediately after use.</li>
                    <li><strong>Account information</strong> — the core tool catalog needs no account, sign-up, or profile. The only exception is the optional "Sign in with Google" feature, which creates a minimal account record (Google account ID, email, name). What that accesses, how it's used, and how to delete it is documented in full in <a href="#google-signin">§8</a>.</li>
                    <li><strong>Browser fingerprints</strong> beyond the User-Agent string in standard server logs.</li>
                </ul>
            </section>

            <section id="cookies">
                <h2>4. Cookies and tracking</h2>
                <p>We use three categories of cookies:</p>
                <ul>
                    <li><strong>Strictly necessary</strong> — <code>JSESSIONID</code> for CSRF protection on tools that round-trip to the server. Cannot be disabled without breaking those tools.</li>
                    <li><strong>Analytics</strong> — Google Analytics (cookies <code>_ga</code>, <code>_gid</code> and similar) to measure aggregate traffic. Configured with IP anonymization where supported. <a href="https://tools.google.com/dlpage/gaoptout" target="_blank" rel="noopener noreferrer">Opt out of Google Analytics</a>.</li>
                    <li><strong>Advertising</strong> — Google AdSense and its partners (cookies like <code>__gads</code>, <code>NID</code>) to serve and measure ads. <a href="https://adssettings.google.com/" target="_blank" rel="noopener noreferrer">Manage ad personalization</a> and review the <a href="https://policies.google.com/technologies/partner-sites" target="_blank" rel="noopener noreferrer">Google partner cookies</a>.</li>
                </ul>
                <p>Your browser's privacy settings (block third-party cookies, use of an ad blocker, "Do Not Track") are respected to the extent supported by the relevant third party.</p>
            </section>

            <section id="third-parties">
                <h2>5. Third-party services we rely on</h2>
                <ul>
                    <li><strong>Cloudflare</strong> — CDN and DDoS protection. Sees request metadata (IP, URL).</li>
                    <li><strong>Google Analytics</strong> — aggregate visitor metrics.</li>
                    <li><strong>Google AdSense</strong> — advertising; cookie-based personalization unless you opt out.</li>
                    <li><strong>Sign in with Google (Google Identity / OAuth 2.0)</strong> — optional authentication. Only invoked if you click "Sign in with Google". See <a href="#google-signin">§8</a> for the exact scopes, data, and retention.</li>
                    <li><strong>Mail relay</strong> — the optional "email my key" feature delivers via a standard SMTP relay. The recipient address you type is processed only to send that one email. We don't add it to any list.</li>
                </ul>
                <p>Each third party has its own privacy policy, and we don't control what they collect once a request reaches them.</p>
            </section>

            <section id="server-logs">
                <h2>6. Server logs and data retention</h2>
                <p>Standard request logs (IP, URL, status code, timestamp, User-Agent) are retained for up to <strong>90 days</strong> for security incident investigation, abuse detection, and operational debugging. After that they are rotated out and overwritten. We do not back up logs off-site.</p>
                <p>Temporary files used during tool computation (e.g. the <code>ssh-keygen</code> output written to <code>java.io.tmpdir</code>) are deleted at the end of the request that created them.</p>
            </section>

            <section id="email">
                <h2>7. Email features</h2>
                <p>A small number of tools offer to email the result to you (e.g. "Email my SSH key pair"). When you opt in, the recipient address and the result content are transmitted to our SMTP relay for delivery and are not stored on our side after dispatch. We never add your address to any newsletter or marketing list.</p>
                <p>If you receive an unexpected email from us, please contact us at the address in §12 — we treat that as an abuse report.</p>
            </section>

            <section id="google-signin">
                <h2>8. Sign in with Google &amp; Google user data</h2>
                <p>8gwifi.org offers an <strong>optional</strong> "Sign in with Google" button so that account-based features (saved preferences, AI tool usage and quota, and billing/entitlements) can follow you between visits. The vast majority of the site works with no sign-in at all. This section documents exactly how the application accesses, uses, stores, and shares Google user data, consistent with the <a href="https://developers.google.com/terms/api-services-user-data-policy" target="_blank" rel="noopener noreferrer">Google API Services User Data Policy</a> (including the Limited Use requirements) and the <a href="https://developers.google.com/terms" target="_blank" rel="noopener noreferrer">Google APIs Terms of Service</a>.</p>

                <h3>Scopes we request</h3>
                <p>When you choose to sign in, we request only these standard OAuth scopes. We do <strong>not</strong> request access to Gmail, Drive, Calendar, Contacts, or any other sensitive or restricted scope:</p>
                <ul>
                    <li><code>openid</code> — to authenticate you and obtain a stable Google account identifier.</li>
                    <li><code>https://www.googleapis.com/auth/userinfo.email</code> — your Google account email address.</li>
                    <li><code>https://www.googleapis.com/auth/userinfo.profile</code> — your basic profile (name, and profile picture/locale where Google provides them).</li>
                </ul>

                <h3>Google user data we access</h3>
                <p>From Google's userinfo endpoint we receive, and may retain, only the following:</p>
                <ul>
                    <li>Your <strong>Google account ID</strong> (the <code>sub</code>/<code>id</code> value — a stable, opaque identifier).</li>
                    <li>Your <strong>email address</strong>.</li>
                    <li>Your <strong>name</strong> (and, transiently, profile picture and locale where Google returns them).</li>
                </ul>

                <h3>How we use, process, and handle it</h3>
                <p>We use Google user data for a single purpose: <strong>to authenticate you and operate your 8gwifi.org account</strong> (saved preferences, AI tool usage and quota, and billing/entitlements). The table below states, for each item of Google user data, exactly how it is used, processed, and handled, and the purpose for that use:</p>
                <table style="width:100%;border-collapse:collapse;margin:0 0 0.75rem;font-size:0.875rem;">
                    <thead>
                        <tr style="text-align:left;border-bottom:2px solid var(--border);">
                            <th style="padding:0.4rem 0.5rem;">Google user data</th>
                            <th style="padding:0.4rem 0.5rem;">How it is used, processed &amp; handled</th>
                            <th style="padding:0.4rem 0.5rem;">Purpose</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr style="border-bottom:1px solid var(--border);">
                            <td style="padding:0.4rem 0.5rem;"><strong>Google account ID</strong> (<code>sub</code>/<code>id</code>)</td>
                            <td style="padding:0.4rem 0.5rem;">Received over HTTPS from Google's userinfo endpoint, held in your server-side session, and written to your account record as the primary key that identifies you.</td>
                            <td style="padding:0.4rem 0.5rem;">To recognise you as a returning user and link your preferences, usage quota, and entitlements to a stable identifier (rather than your email, which can change).</td>
                        </tr>
                        <tr style="border-bottom:1px solid var(--border);">
                            <td style="padding:0.4rem 0.5rem;"><strong>Email address</strong></td>
                            <td style="padding:0.4rem 0.5rem;">Received over HTTPS, held in your server-side session, and stored on your account record.</td>
                            <td style="padding:0.4rem 0.5rem;">To display which account you are signed in to and to contact you about your account and billing/entitlements.</td>
                        </tr>
                        <tr style="border-bottom:1px solid var(--border);">
                            <td style="padding:0.4rem 0.5rem;"><strong>Name</strong> (and, transiently, profile picture/locale)</td>
                            <td style="padding:0.4rem 0.5rem;">Received over HTTPS, held in your server-side session, and stored on your account record. Profile picture/locale are used only in-session and not persisted.</td>
                            <td style="padding:0.4rem 0.5rem;">To personalise the signed-in experience (e.g. greeting you by name in the interface).</td>
                        </tr>
                    </tbody>
                </table>
                <p>Google user data is processed only on our own servers and within our own billing/account infrastructure. We do <strong>not</strong> use it for any purpose other than the ones stated above. In particular, we do <strong>not</strong> use Google user data to serve advertising, we do <strong>not</strong> sell, rent, or trade it, and we do <strong>not</strong> use it to develop, train, or improve generalized artificial-intelligence or machine-learning models.</p>

                <h3>How we store and retain it</h3>
                <ul>
                    <li><strong>Tokens.</strong> Your OAuth access token and refresh token are held in your server-side session only. They are never written to our logs and are discarded when you log out or your session expires.</li>
                    <li><strong>Account record.</strong> Your Google account ID, email, and name are stored in our account database (written through our billing service) so your account persists between visits. This is the one place we deliberately retain data tied to you; everything else on the site follows the "process now, store nothing" principle described above.</li>
                </ul>

                <h3>Sharing</h3>
                <p>We do not share Google user data with third parties except as strictly necessary to operate the service — our own hosting/CDN and billing infrastructure acting as processors on our behalf — or where required by law. Google user data is never transferred for advertising purposes and is never sold.</p>

                <h3>Revoking access and deleting your data</h3>
                <ul>
                    <li>You can revoke 8gwifi.org's access to your Google account at any time from your <a href="https://myaccount.google.com/permissions" target="_blank" rel="noopener noreferrer">Google Account permissions page</a>.</li>
                    <li>To delete your account record and the associated Google user data from our systems, email us at the address in <a href="#contact">§12</a> and we will remove it.</li>
                </ul>

                <h3>Limited Use</h3>
                <p>8gwifi.org's use of information received from Google APIs adheres to the <a href="https://developers.google.com/terms/api-services-user-data-policy" target="_blank" rel="noopener noreferrer">Google API Services User Data Policy</a>, including the <strong>Limited Use</strong> requirements. We request only the scopes listed above, use the data solely for the user-facing features described in this section, and do not transfer it to others for serving ads, training generalized/AI models, or any purpose unrelated to providing or improving these features.</p>
            </section>

            <section id="your-rights">
                <h2>9. Your rights</h2>
                <p>Because the site doesn't maintain user profiles or persist tool inputs, there is typically nothing on file to request, correct, or delete. That said, you have the right to:</p>
                <ul>
                    <li><strong>Access</strong> — ask whether we hold any personal data tied to you. (For 99% of visitors the answer is "only the rolling 90-day request logs, by IP".)</li>
                    <li><strong>Erasure</strong> — request deletion of any data we do hold.</li>
                    <li><strong>Object</strong> — withdraw from analytics/ads via the opt-out links in §4.</li>
                    <li><strong>Lodge a complaint</strong> with the data protection authority in your jurisdiction (GDPR, CCPA, etc.).</li>
                </ul>
                <p>Send any rights-related request to the email address in §12. We aim to respond within 30 days.</p>
            </section>

            <section id="children">
                <h2>10. Children's privacy</h2>
                <p>The site is not directed at children under 13 (or 16 in some jurisdictions). We do not knowingly collect personal information from children. If you believe a child has provided personal information through the site, contact us and we will delete it.</p>
            </section>

            <section id="changes">
                <h2>11. Changes to this policy</h2>
                <p>We may update this policy from time to time — typically when we add a new feature that handles user data differently. The "Effective" date at the top reflects the most recent update. Material changes will be announced on the site for at least 14 days before they take effect.</p>
            </section>

            <section id="contact">
                <h2>12. Contact</h2>
                <div class="legal-contact-card">
                    <p style="margin-bottom:0.4rem;">For privacy questions, data requests, or anything related to this policy:</p>
                    <ul style="margin-bottom:0;">
                        <li>Email: <a href="mailto:zarigatongy@gmail.com">zarigatongy@gmail.com</a></li>
                        <li>X (Twitter): <a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer">@anish2good</a></li>
                    </ul>
                </div>
                <p style="margin-top:1.5rem;font-size:0.8125rem;color:var(--text-secondary);">See also: <a href="<%=request.getContextPath()%>/terms.jsp">Terms of Use</a></p>
            </section>
        </div>
    </main>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>
</body>
</html>
