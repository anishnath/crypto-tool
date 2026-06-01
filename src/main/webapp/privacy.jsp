<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String effectiveDate = "2026-06-01";
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
                <p>8gwifi.org is a free collection of online cryptography, security, and developer tools. We're built around a strict principle: <strong>process now, store nothing</strong>. This page explains exactly what data is and isn't collected when you use the site, who we share information with, and how to exercise your rights.</p>
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
                    <li><strong>Account information</strong> — we don't have user accounts, sign-ups, or profiles for the core tool catalog. (Some optional features may require sign-in via a third-party identity provider; if so, those are described in-context on that page.)</li>
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
                <p>If you receive an unexpected email from us, please contact us at the address in §11 — we treat that as an abuse report.</p>
            </section>

            <section id="your-rights">
                <h2>8. Your rights</h2>
                <p>Because the site doesn't maintain user profiles or persist tool inputs, there is typically nothing on file to request, correct, or delete. That said, you have the right to:</p>
                <ul>
                    <li><strong>Access</strong> — ask whether we hold any personal data tied to you. (For 99% of visitors the answer is "only the rolling 90-day request logs, by IP".)</li>
                    <li><strong>Erasure</strong> — request deletion of any data we do hold.</li>
                    <li><strong>Object</strong> — withdraw from analytics/ads via the opt-out links in §4.</li>
                    <li><strong>Lodge a complaint</strong> with the data protection authority in your jurisdiction (GDPR, CCPA, etc.).</li>
                </ul>
                <p>Send any rights-related request to the email address in §11. We aim to respond within 30 days.</p>
            </section>

            <section id="children">
                <h2>9. Children's privacy</h2>
                <p>The site is not directed at children under 13 (or 16 in some jurisdictions). We do not knowingly collect personal information from children. If you believe a child has provided personal information through the site, contact us and we will delete it.</p>
            </section>

            <section id="changes">
                <h2>10. Changes to this policy</h2>
                <p>We may update this policy from time to time — typically when we add a new feature that handles user data differently. The "Effective" date at the top reflects the most recent update. Material changes will be announced on the site for at least 14 days before they take effect.</p>
            </section>

            <section id="contact">
                <h2>11. Contact</h2>
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
