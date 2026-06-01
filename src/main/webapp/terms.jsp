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
    <title>Terms of Use — 8gwifi.org</title>
    <meta name="description" content="Terms of use for 8gwifi.org. Use at your own risk for cryptography tools, acceptable use, no warranty, limitation of liability, governing law.">
    <link rel="canonical" href="https://8gwifi.org/terms.jsp">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Terms of Use — 8gwifi.org">
    <meta property="og:description" content="Acceptable use, no-warranty stance, and limitation of liability for the 8gwifi.org tool catalog.">
    <meta property="og:url" content="https://8gwifi.org/terms.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/logo.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" media="print" onload="this.media='all'">

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
        :root { --tool-primary: #7c3aed; --tool-primary-dark: #6d28d9; --tool-light: #f3e8ff; }
        [data-theme="dark"] { --tool-light: rgba(124,58,237,0.15); }

        .legal-header {
            padding: 1.5rem 1rem 1rem;
            border-bottom: 1px solid var(--border);
            background: linear-gradient(180deg, var(--tool-light) 0%, var(--bg-primary) 100%);
        }
        .legal-header-inner { max-width: 900px; margin: 0 auto; }
        .legal-page-title {
            font-size: 1.75rem;
            font-weight: 800;
            margin: 0 0 0.35rem;
            letter-spacing: -0.02em;
            color: var(--text-primary);
        }
        .legal-subtitle { font-size: 0.8125rem; color: var(--text-secondary); margin: 0; }
        .legal-breadcrumbs { font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.5rem; }
        .legal-breadcrumbs a { color: var(--tool-primary); text-decoration: none; }
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
        .legal-toc ol { list-style: none; counter-reset: toc; padding: 0; margin: 0; }
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

        .legal-warn {
            margin: 1rem 0;
            padding: 0.85rem 1rem;
            background: rgba(245,158,11,0.10);
            border-left: 4px solid #f59e0b;
            border-radius: 0.25rem;
            font-size: 0.875rem;
        }
        .legal-warn strong { color: #b45309; }
        [data-theme="dark"] .legal-warn strong { color: #fbbf24; }

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
                <a href="<%=request.getContextPath()%>/">Home</a> / <span>Terms of Use</span>
            </nav>
            <h1 class="legal-page-title">Terms of Use</h1>
            <p class="legal-subtitle">Effective: <%=effectiveDate%> · 8gwifi.org</p>
        </div>
    </header>

    <main class="legal-layout">
        <aside class="legal-toc" aria-label="On this page">
            <div class="legal-toc-title">On this page</div>
            <ol>
                <li><a href="#acceptance">Acceptance</a></li>
                <li><a href="#service">The service</a></li>
                <li><a href="#use-at-own-risk">Use at your own risk</a></li>
                <li><a href="#no-warranty">No warranty</a></li>
                <li><a href="#acceptable-use">Acceptable use</a></li>
                <li><a href="#ip">Intellectual property</a></li>
                <li><a href="#third-party">Third-party services</a></li>
                <li><a href="#liability">Limitation of liability</a></li>
                <li><a href="#indemnification">Indemnification</a></li>
                <li><a href="#availability">Availability &amp; termination</a></li>
                <li><a href="#changes">Changes</a></li>
                <li><a href="#law">Governing law</a></li>
                <li><a href="#contact">Contact</a></li>
            </ol>
        </aside>

        <div class="legal-content">
            <div class="legal-tldr">
                <strong>TL;DR:</strong> 8gwifi.org is provided free, as-is. Use it however you like for personal or commercial work, but verify critical output (keys, signatures, certificates) before relying on it in production. We're not liable for losses caused by using or misusing the tools. Don't abuse the site (no automated scraping at unreasonable rates, no using it to commit crimes).
            </div>

            <section id="acceptance">
                <h2>1. Acceptance of these terms</h2>
                <p>By accessing or using any tool at 8gwifi.org ("the Site"), you agree to be bound by these Terms of Use. If you don't agree, please don't use the Site. These terms govern your relationship with the operator of 8gwifi.org ("we", "us"). For privacy practices, see the <a href="<%=request.getContextPath()%>/privacy.jsp">Privacy Policy</a>.</p>
            </section>

            <section id="service">
                <h2>2. What the service is</h2>
                <p>The Site is a free, ad-supported catalog of online cryptography, security, networking, math, and developer tools. Most tools run entirely in your browser; some round-trip through our server for computation that isn't practical client-side (e.g. RSA key generation, packet decoding, format conversion). The Site is not a vault, a credential manager, a key escrow, or a backup service.</p>
            </section>

            <section id="use-at-own-risk">
                <h2>3. Use at your own risk</h2>
                <div class="legal-warn">
                    <strong>Important:</strong> These tools touch cryptography, key material, and security-sensitive operations. You are responsible for verifying that the output is correct, fit for purpose, and used appropriately in your environment.
                </div>
                <p>Concrete examples of what "your own risk" means:</p>
                <ul>
                    <li>If you generate a key here and then lose the only copy, the data it protects is unrecoverable. We have no backup.</li>
                    <li>If an output looks correct but a future cryptographic finding invalidates the algorithm or library it was built on, we are not responsible for retroactive consequences.</li>
                    <li>Tools are provided for legitimate uses (education, development, sysadmin work, hobby projects). The Site is not certified for, and you should not rely on it for, high-stakes production cryptography without an independent review by a qualified cryptographer.</li>
                </ul>
            </section>

            <section id="no-warranty">
                <h2>4. No warranty</h2>
                <p>THE SITE AND ALL TOOLS ARE PROVIDED "AS IS" AND "AS AVAILABLE", WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT, OR THAT THE SITE WILL BE UNINTERRUPTED, ERROR-FREE, SECURE, OR FREE OF VIRUSES.</p>
                <p>We make no representation that any output is suitable for any specific use, complies with any regulatory requirement, or will produce the same result if executed elsewhere. You assume all responsibility for verifying suitability and correctness.</p>
            </section>

            <section id="acceptable-use">
                <h2>5. Acceptable use</h2>
                <p>You agree NOT to:</p>
                <ul>
                    <li>Use the Site to break the law or facilitate unlawful acts (unauthorized access to systems, fraud, intellectual-property infringement, harassment, etc.).</li>
                    <li>Use the Site to attack other systems (e.g. generate credentials for accounts you don't own, decrypt material you didn't lawfully obtain).</li>
                    <li>Submit content that infringes someone else's rights or contains malware.</li>
                    <li>Reverse-engineer, disassemble, or interfere with the integrity of the Site beyond normal browser/devtools use of the served code.</li>
                    <li>Conduct automated scraping or load testing against the Site at rates that meaningfully degrade the service for other users. Reasonable, well-paced API/UI use is fine.</li>
                    <li>Resell or repackage the Site as your own service without permission.</li>
                </ul>
                <p>We may rate-limit, block, or report any traffic that appears to violate these rules.</p>
            </section>

            <section id="ip">
                <h2>6. Intellectual property</h2>
                <p>The Site's design, branding, original copy, and selection/arrangement of tools are protected by copyright and other applicable laws. Portions of the underlying code are open-sourced separately on GitHub under their respective licenses — please consult those repositories for the specific terms applicable to that code.</p>
                <p>Third-party libraries used on the Site (e.g. OpenSSL, BouncyCastle, jQuery, CodeMirror, openpgp.js, TikZJax, BoringSSL, libsodium, etc.) remain the property of their respective owners and are governed by their own licenses.</p>
                <p>You retain all rights in any content you submit to a tool (keys, plaintext, files, etc.) — using a tool does not grant us a license to that content. Because we don't retain the content beyond the request, there is also nothing for you to revoke.</p>
            </section>

            <section id="third-party">
                <h2>7. Third-party services and links</h2>
                <p>The Site embeds third-party services (Google Analytics, Google AdSense, Cloudflare, mail relays) and may link to external sites or repositories for documentation, source code, or related tools. We don't control those third parties; their content, services, and privacy practices are governed by their own terms.</p>
            </section>

            <section id="liability">
                <h2>8. Limitation of liability</h2>
                <p>TO THE MAXIMUM EXTENT PERMITTED BY LAW, NEITHER THE OPERATOR OF 8GWIFI.ORG NOR ANYONE CONTRIBUTING TO THE SITE WILL BE LIABLE FOR ANY INDIRECT, INCIDENTAL, CONSEQUENTIAL, SPECIAL, OR PUNITIVE DAMAGES, OR ANY LOSS OF PROFITS, REVENUE, DATA, OR KEY MATERIAL, ARISING OUT OF OR IN CONNECTION WITH YOUR USE OR INABILITY TO USE THE SITE — EVEN IF WE HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.</p>
                <p>Our total aggregate liability for any claim arising out of these terms or your use of the Site is limited to the greater of (a) the amount you paid us in the twelve months preceding the claim (which for a free service is zero), or (b) USD 50.</p>
            </section>

            <section id="indemnification">
                <h2>9. Indemnification</h2>
                <p>You agree to indemnify and hold harmless the Site operator from any claim, damage, or expense (including reasonable legal fees) arising out of your misuse of the Site, your violation of these terms, or your violation of any third-party rights or applicable law.</p>
            </section>

            <section id="availability">
                <h2>10. Availability and termination</h2>
                <p>The Site is hosted on a best-effort basis. We may modify, suspend, or discontinue any tool or the entire Site at any time without notice or liability. Specific tools may be removed if upstream dependencies change, if the tool becomes a security or legal liability, or simply if it's no longer being maintained.</p>
                <p>We may also terminate your access (e.g. by IP block) if you violate the acceptable-use rules in §5.</p>
            </section>

            <section id="changes">
                <h2>11. Changes to these terms</h2>
                <p>We may update these terms occasionally. The "Effective" date at the top reflects the most recent revision. Continuing to use the Site after a material change indicates acceptance of the updated terms.</p>
            </section>

            <section id="law">
                <h2>12. Governing law and disputes</h2>
                <p>These terms are governed by the laws of the operator's place of residence, without regard to conflict-of-laws principles. Any dispute that can't be resolved informally will be brought in the courts having jurisdiction over the operator's place of residence. Where local consumer-protection law gives you stronger rights, those rights are not waived by anything in these terms.</p>
            </section>

            <section id="contact">
                <h2>13. Contact</h2>
                <div class="legal-contact-card">
                    <p style="margin-bottom:0.4rem;">For questions, bug reports, takedown requests, or DMCA notices:</p>
                    <ul style="margin-bottom:0;">
                        <li>Email: <a href="mailto:zarigatongy@gmail.com">zarigatongy@gmail.com</a></li>
                        <li>X (Twitter): <a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer">@anish2good</a></li>
                    </ul>
                </div>
                <p style="margin-top:1.5rem;font-size:0.8125rem;color:var(--text-secondary);">See also: <a href="<%=request.getContextPath()%>/privacy.jsp">Privacy Policy</a></p>
            </section>
        </div>
    </main>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>
</body>
</html>
