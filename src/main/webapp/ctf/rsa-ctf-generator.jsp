<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free RSA CTF Generator - 20 Attack Types, Wiener, Hastad, Fermat, Pollard, Padding Oracle" />
        <jsp:param name="toolDescription" value="Generate RSA CTF challenges with 20 real-world vulnerability types: Wiener attack, Hastad broadcast, Fermat factorization, Pollard p-1, common factor, cube root, common modulus, twin primes, dp leak, Rabin, padding oracle, and more. Free JSON export." />
        <jsp:param name="toolCategory" value="CTF & Challenges" />
        <jsp:param name="toolUrl" value="ctf/rsa-ctf-generator.jsp" />
        <jsp:param name="toolKeywords" value="RSA CTF generator, RSA challenge maker, Wiener attack CTF, Hastad broadcast attack, Pollard p-1 CTF, RSA padding oracle, common factor attack, batch GCD CTF, RSA vulnerabilities practice, CTF RSA training, capture the flag RSA, crypto CTF tool, RSA key weakness, small exponent attack, Franklin-Reiter, partial key leak CTF, Fermat factorization CTF, common modulus attack, twin primes RSA, dp leak CRT, Rabin cryptosystem, cube root attack RSA" />
        <jsp:param name="toolImage" value="images/crypto-ctf-icon.svg" />
        <jsp:param name="toolFeatures" value="20 RSA vulnerability types,Wiener and Boneh-Durfee attacks,Hastad broadcast with CRT (e=3/5/7),Pollard p-1 smooth prime,Common factor batch GCD,Franklin-Reiter related messages,Fermat factorization (close primes),Low exponent cube root attack,Common modulus (same n two e),Twin primes factorization,dp CRT exponent leak,Rabin cryptosystem (e=2),Partial key and PEM leaks with MSB/LSB/d variants,ROCA weak prime generation,Padding oracle via server,Multi-prime RSA,Side-channel bit leak,JSON export with full solution,Progressive solver hints" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter your flag|Type the flag message that solvers must recover,Choose attack type|Select from 14 RSA vulnerability types grouped by difficulty,Generate the challenge|Click Generate and the engine creates a vulnerable RSA key pair and encrypts your flag,Download and share|Download the challenge parameters and JSON bundle with the full solution and hints" />
        <jsp:param name="breadcrumbCategoryUrl" value="ctf/index.jsp" />
        <jsp:param name="faq1q" value="What RSA attack types are supported?" />
        <jsp:param name="faq1a" value="20 types across 4 difficulty levels. Easy: Even Modulus, Small Factor, Known phi Leak, Common Factor, Cube Root, Common Modulus, Twin Primes. Medium: Pollard p-1, Wiener Attack, Multi-Prime, Side-Channel, Hastad Broadcast, Fermat Factorization, dp Leak, Rabin. Hard: Partial Key Leak (MSB/LSB/d), Partial PEM, ROCA Weak Primes, Franklin-Reiter. Pro: Padding Oracle." />
        <jsp:param name="faq2q" value="How do the RSA challenges work?" />
        <jsp:param name="faq2a" value="The engine generates a deliberately vulnerable RSA key pair, encrypts your flag with it, and provides the public parameters (n, e, c). Each challenge type has a specific weakness that allows factoring n or recovering d without brute force." />
        <jsp:param name="faq3q" value="Is this RSA CTF tool free?" />
        <jsp:param name="faq3a" value="Yes, 100% free with no signup. Key generation and encryption run client-side using native BigInt. Only the Padding Oracle type uses a server endpoint for the decryption oracle." />
        <jsp:param name="faq4q" value="What key sizes are used?" />
        <jsp:param name="faq4a" value="128-512 bit keys for client-side challenges, intentionally small so solvers can factor them with standard tools (Python, SageMath, RsaCtfTool). The Padding Oracle type uses larger keys via the server." />
        <jsp:param name="faq5q" value="Can I use these challenges in my own CTF event?" />
        <jsp:param name="faq5a" value="Absolutely. Download the JSON bundle, which contains the challenge parameters, complete solution, and progressive hints. Use the seed option for reproducible output across your team." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <style>
        :root{
            --ctf-green:#00cc33;--ctf-green-dim:#059669;--ctf-cyan:#0ea5e9;--ctf-purple:#a855f7;
            --ctf-red:#ef4444;--ctf-bg:var(--bg-primary,#fff);--ctf-surface:var(--bg-secondary,#f8fafc);--ctf-surface-2:var(--bg-tertiary,#f1f5f9);
            --ctf-border:var(--border,#e2e8f0);--ctf-text:var(--text-primary,#0f172a);--ctf-text-dim:var(--text-secondary,#475569);
            --ctf-glow:0 0 20px rgba(0,204,51,0.1);--ctf-font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
            --tool-primary:#dc2626;--tool-primary-dark:#b91c1c;
            --tool-gradient:linear-gradient(135deg,#dc2626 0%,#ef4444 100%);
            --tool-light:rgba(220,38,38,0.08);
        }
        [data-theme="dark"]{
            --ctf-green:#00ff41;--ctf-green-dim:#00cc33;--ctf-cyan:#00d4ff;
            --ctf-glow:0 0 20px rgba(0,255,65,0.15);
            --tool-light:rgba(220,38,38,0.12);
        }
    </style>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;700&display=swap" media="print" onload="this.media='all'">

    <%@ include file="../modern/ads/ad-init.jsp" %>

    <style>
        .sg-card{background:var(--ctf-surface);border:1px solid var(--ctf-border);border-radius:0.75rem;overflow:hidden}
        .sg-card-header{padding:1rem 1.25rem;border-bottom:1px solid var(--ctf-border);display:flex;align-items:center;gap:0.5rem;font-weight:600;color:var(--ctf-text);font-size:0.9375rem}
        .sg-card-header svg{color:var(--ctf-green);flex-shrink:0}
        .sg-card-body{padding:1.25rem}
        .sg-form-group{margin-bottom:1.25rem}
        .sg-label{display:block;font-size:0.8125rem;font-weight:600;color:var(--ctf-text);margin-bottom:0.375rem}
        .sg-label-hint{font-weight:400;color:var(--ctf-text-dim);font-size:0.75rem}
        .sg-input,.sg-select{width:100%;padding:0.625rem 0.875rem;background:var(--ctf-surface-2);border:1px solid var(--ctf-border);border-radius:0.5rem;color:var(--ctf-text);font-size:0.875rem;font-family:inherit;transition:border-color 0.2s}
        .sg-input:focus,.sg-select:focus{outline:none;border-color:var(--ctf-green);box-shadow:0 0 0 2px rgba(0,255,65,0.1)}
        .sg-select{cursor:pointer;appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 0.75rem center}
        .sg-btn{display:inline-flex;align-items:center;justify-content:center;gap:0.5rem;padding:0.75rem 1.5rem;border:none;border-radius:0.5rem;font-size:0.875rem;font-weight:600;cursor:pointer;transition:all 0.2s;font-family:inherit;width:100%}
        .sg-btn-primary{background:linear-gradient(135deg,#dc2626,#ef4444);color:#fff}
        .sg-btn-primary:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(220,38,38,0.3)}
        .sg-btn-primary:disabled{opacity:0.5;cursor:not-allowed;transform:none;box-shadow:none}
        .sg-btn-secondary{background:var(--ctf-surface-2);color:var(--ctf-text);border:1px solid var(--ctf-border)}
        .sg-btn-secondary:hover{border-color:var(--ctf-green);color:var(--ctf-green)}
        .sg-btn-sm{padding:0.5rem 1rem;font-size:0.8125rem;width:auto}
        .sg-actions{display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.75rem}
        .sg-output-tabs{display:flex;border-bottom:1px solid var(--ctf-border);overflow-x:auto}
        .sg-output-tab{padding:0.75rem 1rem;font-size:0.8125rem;font-weight:500;color:var(--ctf-text-dim);background:none;border:none;cursor:pointer;border-bottom:2px solid transparent;white-space:nowrap;font-family:inherit;transition:all 0.2s}
        .sg-output-tab.active{color:var(--ctf-green);border-bottom-color:var(--ctf-green)}
        .sg-output-tab:hover{color:var(--ctf-text)}
        .sg-tab-content{display:none;padding:1.25rem}
        .sg-tab-content.active{display:block}
        .sg-empty{text-align:center;padding:3rem 1rem;color:var(--ctf-text-dim)}
        .sg-empty svg{margin-bottom:1rem;opacity:0.4}
        .sg-empty h3{font-size:1rem;color:var(--ctf-text);margin-bottom:0.5rem}
        .sg-empty p{font-size:0.8125rem}
        .sg-json-pre{background:var(--ctf-bg);border:1px solid var(--ctf-border);border-radius:0.5rem;padding:1rem;font-family:var(--ctf-font-mono);font-size:0.75rem;color:var(--ctf-green);overflow:auto;max-height:500px;white-space:pre-wrap;word-break:break-all;line-height:1.6}
        .sg-hints-list{list-style:none;padding:0}
        .sg-hints-list li{padding:0.75rem;margin-bottom:0.5rem;background:var(--ctf-surface-2);border:1px solid var(--ctf-border);border-radius:0.5rem;font-size:0.8125rem;color:var(--ctf-text);line-height:1.5;font-family:var(--ctf-font-mono)}
        .sg-hint-toggle{cursor:pointer;user-select:none}
        .sg-hint-toggle .sg-hint-text{display:none;margin-top:0.5rem;color:var(--ctf-text-dim)}
        .sg-hint-toggle.open .sg-hint-text{display:block}
        .sg-hint-toggle .sg-hint-label{color:var(--ctf-cyan);font-weight:500}
        .sg-hint-toggle .sg-hint-loading{display:none;margin-top:0.5rem;color:var(--ctf-cyan);font-size:0.75rem}
        .sg-hint-toggle.loading .sg-hint-loading{display:flex;align-items:center;gap:0.5rem}
        .sg-gate{text-align:center;padding:2.5rem 1.5rem}
        .sg-gate-icon{margin-bottom:0.75rem;opacity:0.5}
        .sg-gate h3{font-size:0.9375rem;color:var(--ctf-text);margin-bottom:0.25rem}
        .sg-gate p{font-size:0.8125rem;color:var(--ctf-text-dim);margin-bottom:1rem}
        .sg-gate .sg-btn{width:auto;display:inline-flex}
        .sg-gate-spinner{display:none;flex-direction:column;align-items:center;gap:0.75rem;padding:2.5rem 1.5rem}
        .sg-gate-spinner.active{display:flex}
        .sg-gate-spinner .sg-spinner{width:28px;height:28px;border-width:3px}
        .sg-gate-spinner p{font-size:0.8125rem;color:var(--ctf-text-dim);font-family:var(--ctf-font-mono)}
        .sg-spinner{display:inline-block;width:16px;height:16px;border:2px solid rgba(255,255,255,0.2);border-top-color:var(--ctf-green);border-radius:50%;animation:sg-spin 0.6s linear infinite;vertical-align:middle}
        @keyframes sg-spin{to{transform:rotate(360deg)}}
        .sg-cooldown-bar{height:3px;background:var(--ctf-green);border-radius:2px;margin-top:0.5rem;transition:width linear;width:0}
        .sg-cooldown-bar.active{width:100%}
        .sg-param-box{background:var(--ctf-surface-2);border:1px solid var(--ctf-border);border-radius:0.5rem;padding:0.75rem 1rem;font-family:var(--ctf-font-mono);font-size:0.8125rem;color:var(--ctf-text);word-break:break-all;line-height:1.6;margin-bottom:0.5rem}
        .sg-param-label{font-size:0.6875rem;font-weight:700;text-transform:uppercase;letter-spacing:0.05em;color:var(--ctf-text-dim);margin-bottom:0.25rem}
        @media(max-width:640px){.sg-actions{flex-direction:column}.sg-btn-sm{width:100%}}
        .sg-faq{max-width:1200px;margin:2rem auto;padding:0 1.5rem}
        .sg-faq-card{background:var(--ctf-surface);border:1px solid var(--ctf-border);border-radius:0.75rem;padding:1.5rem 2rem}
        .sg-faq-title{font-size:1.125rem;font-weight:700;color:var(--ctf-text);margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem}
        .sg-faq-title svg{color:var(--ctf-green)}
        .sg-faq-list{display:grid;gap:0.5rem}
        .sg-faq-item{border:1px solid var(--ctf-border);border-radius:0.5rem;overflow:hidden}
        .sg-faq-q{width:100%;display:flex;align-items:center;justify-content:space-between;padding:0.875rem 1rem;border:none;background:var(--ctf-surface-2);color:var(--ctf-text);font-size:0.875rem;font-weight:500;cursor:pointer;text-align:left;font-family:inherit;transition:color 0.2s}
        .sg-faq-q:hover{color:var(--ctf-green)}
        .sg-faq-chevron{transition:transform 0.2s;flex-shrink:0;margin-left:0.5rem;color:var(--ctf-text-dim)}
        .sg-faq-item.open .sg-faq-chevron{transform:rotate(180deg);color:var(--ctf-green)}
        .sg-faq-a{display:none;padding:0 1rem 0.875rem;font-size:0.8125rem;line-height:1.7;color:var(--ctf-text-dim)}
        .sg-faq-item.open .sg-faq-a{display:block}
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">RSA <span style="color:var(--ctf-green)">CTF</span> Generator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/ctf/index.jsp">CTF Generators</a> /
                    RSA CTF
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">20 Attack Types</span>
                <span class="tool-badge">Native BigInt</span>
                <span class="tool-badge">Client-Side</span>
            </div>
        </div>
    </header>

    <div class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Generate RSA CTF challenges exploiting <strong>20 real-world vulnerabilities</strong>: Wiener attack, Hastad broadcast, Fermat factorization, Pollard p-1, cube root, common modulus, twin primes, dp leak, Rabin, common factor, padding oracle, and more. Each challenge provides public parameters, a full JSON solution bundle, and progressive hints.</p>
            </div>
            <div class="tool-description-ad">
                <%@ include file="../modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </div>

    <main class="tool-page-container">
        <div class="tool-input-column">
            <div class="sg-card">
                <div class="sg-card-header">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    Configure RSA Challenge
                </div>
                <div class="sg-card-body">
                    <div class="sg-form-group">
                        <label class="sg-label">Flag Message</label>
                        <input type="text" class="sg-input" id="flagInput" value="flag{rsa_master}" placeholder="flag{your_secret_here}">
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Attack Type <span class="sg-label-hint">(20 types)</span></label>
                        <select class="sg-select" id="attackTypeSelect">
                            <optgroup label="Easy (7)">
                                <option value="evenModulus">Even Modulus N &mdash; p = 2</option>
                                <option value="smallFactor">Small Factor q &mdash; trial division</option>
                                <option value="knownPhiLeak">Known phi(n) / p+q Leak</option>
                                <option value="commonFactor">Common Factor &mdash; batch GCD</option>
                                <option value="cubeRoot">Low Exponent &mdash; cube root (e=3)</option>
                                <option value="commonModulus">Common Modulus &mdash; same n, two e's</option>
                                <option value="twinPrimes">Twin Primes &mdash; q = p + 2</option>
                            </optgroup>
                            <optgroup label="Medium (8)">
                                <option value="smoothPrime" selected>Pollard p-1 &mdash; smooth prime</option>
                                <option value="wienerAttack">Wiener's Attack &mdash; small d</option>
                                <option value="multiPrime">Multi-Prime RSA &mdash; n=pqr</option>
                                <option value="sideChannel">Side-Channel &mdash; d bit leak</option>
                                <option value="hastadBroadcast">Hastad Broadcast &mdash; e=3/5/7, CRT</option>
                                <option value="fermat">Fermat Factorization &mdash; close primes</option>
                                <option value="dpLeak">dp Leak &mdash; CRT exponent</option>
                                <option value="rabin">Rabin Cryptosystem &mdash; e=2</option>
                            </optgroup>
                            <optgroup label="Hard (4)">
                                <option value="partialKeyLeak">Partial Key Leak &mdash; MSBs/LSBs of p or d</option>
                                <option value="partialPEM">Partial PEM Leak &mdash; corrupted key</option>
                                <option value="rocaWeak">ROCA Weak Primes &mdash; CVE-2017-15361</option>
                                <option value="franklinReiter">Franklin-Reiter &mdash; related messages</option>
                            </optgroup>
                            <optgroup label="Pro (1)">
                                <option value="paddingOracle">Padding Oracle &mdash; Bleichenbacher</option>
                            </optgroup>
                        </select>
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Key Size <span class="sg-label-hint">(bits)</span></label>
                        <select class="sg-select" id="keySizeSelect">
                            <option value="256" selected>256-bit (fast, educational)</option>
                            <option value="512">512-bit (moderate)</option>
                        </select>
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Seed <span class="sg-label-hint">(for reproducible output)</span></label>
                        <input type="number" class="sg-input" id="seedInput" placeholder="Optional &mdash; leave blank for random">
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Hint Count</label>
                        <select class="sg-select" id="hintCountSelect">
                            <option value="3">3 hints</option>
                            <option value="5" selected>5 hints</option>
                        </select>
                    </div>

                    <button class="sg-btn sg-btn-primary" id="generateBtn" onclick="doGenerate()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10"/></svg>
                        Generate RSA Challenge
                    </button>
                    <div class="sg-cooldown-bar" id="cooldownBar"></div>
                    <div id="statusMsg" style="margin-top:0.75rem;font-size:0.8125rem;font-family:var(--ctf-font-mono);min-height:1.25rem"></div>
                </div>
            </div>
        </div>

        <div class="tool-output-column">
            <div class="sg-card sg-output">
                <div class="sg-output-tabs">
                    <button class="sg-output-tab active" onclick="switchTab('challenge',this)">Challenge</button>
                    <button class="sg-output-tab" onclick="switchTab('solution',this)">Solution</button>
                    <button class="sg-output-tab" onclick="switchTab('hints',this)">Hints</button>
                    <button class="sg-output-tab" onclick="switchTab('json',this)">Full JSON</button>
                </div>

                <div class="sg-tab-content active" id="tab-challenge">
                    <div class="sg-empty" id="challengeEmpty">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                        <h3>No challenge yet</h3>
                        <p>Pick an attack type and click Generate.</p>
                    </div>
                    <div id="challengeResult" style="display:none">
                        <div id="challengePreview"></div>
                        <div class="sg-actions">
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="downloadChallenge(event)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                Download Challenge
                            </button>
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="downloadJSON(event)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                Download JSON
                            </button>
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="copyParams(event)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                                Copy Parameters
                            </button>
                        </div>
                    </div>
                </div>

                <div class="sg-tab-content" id="tab-solution">
                    <div class="sg-empty" id="solutionEmpty"><h3>Solution will appear here</h3><p>Generate a challenge first.</p></div>
                    <div class="sg-gate" id="solutionGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
                        <h3>Solution is ready</h3><p>Reveal the private key, factorization, and attack method.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('solution',3000)">Reveal Solution</button>
                    </div>
                    <div class="sg-gate-spinner" id="solutionSpinner"><span class="sg-spinner"></span><p>Computing private key...</p></div>
                    <div id="solutionResult" style="display:none"></div>
                </div>

                <div class="sg-tab-content" id="tab-hints">
                    <div class="sg-empty" id="hintsEmpty"><h3>Hints will appear here</h3><p>Generate a challenge to see progressive hints.</p></div>
                    <div class="sg-gate" id="hintsGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></div>
                        <h3>Hints are ready</h3><p>Progressive hints to guide solvers.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('hints',2000)">Reveal Hints</button>
                    </div>
                    <div class="sg-gate-spinner" id="hintsSpinner"><span class="sg-spinner"></span><p>Loading hints...</p></div>
                    <ul class="sg-hints-list" id="hintsList" style="display:none"></ul>
                </div>

                <div class="sg-tab-content" id="tab-json">
                    <div class="sg-empty" id="jsonEmpty"><h3>Raw JSON will appear here</h3><p>Complete challenge bundle in JSON format.</p></div>
                    <div class="sg-gate" id="jsonGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
                        <h3>Full JSON bundle is ready</h3><p>Complete challenge with solution, hints, and parameters.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('json',2500)">Reveal Full JSON</button>
                    </div>
                    <div class="sg-gate-spinner" id="jsonSpinner"><span class="sg-spinner"></span><p>Serializing...</p></div>
                    <pre class="sg-json-pre" id="jsonPre" style="display:none"></pre>
                </div>
            </div>
        </div>

        <div class="tool-ads-column">
            <%@ include file="../modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <div class="tool-mobile-ad-container">
        <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <section class="sg-faq">
        <div class="sg-faq-card">
            <h2 class="sg-faq-title">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                Frequently Asked Questions
            </h2>
            <div class="sg-faq-list">
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">What RSA attack types are supported?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">20 types across 4 difficulty levels. Easy: Even Modulus (p=2), Small Factor, Known phi/p+q Leak, Common Factor (batch GCD), Low Exponent (cube root), Common Modulus (same n, two e's), Twin Primes. Medium: Pollard p-1, Wiener's Attack, Multi-Prime RSA, Side-Channel, Hastad Broadcast (e=3/5/7), Fermat Factorization (close primes), dp Leak (CRT exponent), Rabin (e=2). Hard: Partial Key Leak (MSBs/LSBs of p, or MSBs of d), Partial PEM, ROCA Weak Primes, Franklin-Reiter. Pro: Padding Oracle (Bleichenbacher).</div></div>
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">How do I solve these challenges?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">Each challenge type exploits a specific RSA vulnerability. Tools like Python (pycryptodome, sympy), SageMath, or RsaCtfTool can solve most of them. The progressive hints guide you toward the right approach. For example, Wiener's attack requires computing continued fractions of e/n.</div></div>
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">What key sizes are used?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">256-512 bit keys for most client-side challenges &mdash; intentionally small so the intended vulnerability is exploitable with standard tools. The Padding Oracle type can use larger keys since it relies on a server-side decryption oracle.</div></div>
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">Is this tool free and private?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">100% free, no signup. Key generation and encryption run client-side using native JavaScript BigInt and the Web Crypto API for hashing. Only the Padding Oracle challenge type uses a server endpoint for the decryption oracle.</div></div>
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">Can I use these for my CTF event?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">Absolutely. Download the JSON bundle which contains challenge parameters, the complete solution (private key, factorization, method), and progressive hints. Use the seed option to generate the same challenge reproducibly.</div></div>
            </div>
        </div>
    </section>

    <jsp:include page="../modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="ctf/rsa-ctf-generator.jsp"/>
        <jsp:param name="category" value="CTF & Challenges"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <%@ include file="../modern/components/support-section.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/ctf/index.jsp" class="footer-link">CTF Hub</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <script src="<%=request.getContextPath()%>/ctf/js/ctf-rsa-math.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/ctf/js/ctf-rsa-engine.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>

    <script>
    var currentBundle = null;
    var generateCooldownUntil = 0;
    var GENERATE_DELAY_MS = 2000;
    var COOLDOWN_MS = 6000;
    var revealedSections = {};

    var GENERATE_PHASES = [
        'Generating RSA key pair...',
        'Injecting vulnerability...',
        'Encrypting flag...',
        'Computing hints...',
        'Hashing flag...',
        'Packaging challenge...'
    ];

    function switchTab(id, btn) {
        var tabs = document.querySelectorAll('.sg-output-tab');
        var panes = document.querySelectorAll('.sg-tab-content');
        for (var i = 0; i < tabs.length; i++) tabs[i].classList.remove('active');
        for (var j = 0; j < panes.length; j++) panes[j].classList.remove('active');
        btn.classList.add('active');
        document.getElementById('tab-' + id).classList.add('active');
    }

    function setStatus(msg, color, showSpinner) {
        var el = document.getElementById('statusMsg');
        if (showSpinner) {
            el.innerHTML = '<span class="sg-spinner" style="margin-right:0.5rem"></span>' + escHtml(msg);
        } else {
            el.textContent = msg;
        }
        el.style.color = color || 'var(--ctf-text-dim)';
    }

    function startCooldown() {
        generateCooldownUntil = Date.now() + COOLDOWN_MS;
        var bar = document.getElementById('cooldownBar');
        bar.style.width = '100%';
        bar.classList.add('active');
        bar.style.transitionDuration = COOLDOWN_MS + 'ms';
        requestAnimationFrame(function() {
            requestAnimationFrame(function() { bar.style.width = '0'; });
        });
        setTimeout(function() { bar.classList.remove('active'); bar.style.width = '0'; }, COOLDOWN_MS);
    }

    function revealSection(name, delay) {
        if (revealedSections[name]) return;
        revealedSections[name] = true;
        document.getElementById(name + 'Gate').style.display = 'none';
        var spinner = document.getElementById(name + 'Spinner');
        spinner.classList.add('active');
        setTimeout(function() {
            spinner.classList.remove('active');
            var target = (name === 'json') ? document.getElementById('jsonPre')
                       : (name === 'hints') ? document.getElementById('hintsList')
                       : document.getElementById(name + 'Result');
            if (target) target.style.display = '';
        }, delay || 2000);
    }

    function doGenerate() {
        if (Date.now() < generateCooldownUntil) {
            setStatus('Cooldown active...', 'var(--ctf-red)');
            return;
        }

        var flag = document.getElementById('flagInput').value.trim();
        if (!flag) { setStatus('Please enter a flag.', 'var(--ctf-red)'); return; }

        var attackType = document.getElementById('attackTypeSelect').value;
        var bits = parseInt(document.getElementById('keySizeSelect').value);
        var hintCount = parseInt(document.getElementById('hintCountSelect').value);
        var seedVal = document.getElementById('seedInput').value.trim();
        var seed = seedVal ? parseInt(seedVal) : null;

        var btn = document.getElementById('generateBtn');
        btn.disabled = true;
        revealedSections = {};

        var phaseIdx = 0;
        setStatus(GENERATE_PHASES[0], 'var(--ctf-cyan)', true);
        var phaseInterval = setInterval(function() {
            phaseIdx++;
            if (phaseIdx < GENERATE_PHASES.length) setStatus(GENERATE_PHASES[phaseIdx], 'var(--ctf-cyan)', true);
        }, GENERATE_DELAY_MS / GENERATE_PHASES.length);

        var opts = { bits: bits, hintCount: hintCount };
        if (seed != null && !isNaN(seed)) opts.seed = seed;
        if (attackType === 'smallFactor') { opts.largeBits = bits; opts.smallBits = Math.min(32, Math.floor(bits / 8)); }
        if (attackType === 'paddingOracle') { opts.bits = Math.max(bits, 512); }
        if (attackType === 'partialPEM') { opts.bits = Math.max(bits, 512); }
        if (attackType === 'cubeRoot') { opts.bits = Math.max(bits, 512); }

        var startTime = Date.now();

        CTFRSAEngine.generate(attackType, flag, opts).then(function(bundle) {
            var elapsed = Date.now() - startTime;
            return new Promise(function(resolve) {
                setTimeout(function() { resolve(bundle); }, Math.max(0, GENERATE_DELAY_MS - elapsed));
            });
        }).then(function(bundle) {
            clearInterval(phaseInterval);
            bundle.note = 'Generated by 8gwifi.org RSA CTF Generator \u2014 https://8gwifi.org/ctf/rsa-ctf-generator.jsp';
            currentBundle = bundle;
            renderChallenge(bundle);
            setStatus('RSA challenge generated.', 'var(--ctf-green)');
            btn.disabled = false;
            startCooldown();
        }).catch(function(e) {
            clearInterval(phaseInterval);
            setStatus('Error: ' + e.message, 'var(--ctf-red)');
            btn.disabled = false;
        });
    }

    function renderChallenge(bundle) {
        document.getElementById('challengeEmpty').style.display = 'none';
        document.getElementById('challengeResult').style.display = 'block';
        document.getElementById('solutionEmpty').style.display = 'none';
        document.getElementById('solutionGate').style.display = 'block';
        document.getElementById('solutionResult').style.display = 'none';
        document.getElementById('hintsEmpty').style.display = 'none';
        document.getElementById('hintsGate').style.display = 'block';
        document.getElementById('hintsList').style.display = 'none';
        document.getElementById('jsonEmpty').style.display = 'none';
        document.getElementById('jsonGate').style.display = 'block';
        document.getElementById('jsonPre').style.display = 'none';

        var ch = bundle.challenge;
        var previewEl = document.getElementById('challengePreview');
        previewEl.innerHTML = '';

        var type = bundle.meta.type;

        if (type === 'rsa_hastadBroadcast') {
            addParam(previewEl, 'e (public exponent)', ch.e);
            ch.recipients.forEach(function(r, i) {
                addParam(previewEl, 'Recipient ' + r.id + ' — n', r.n);
                addParam(previewEl, 'Recipient ' + r.id + ' — c', r.c);
            });
        } else if (type === 'rsa_commonFactor') {
            addParam(previewEl, 'Target Key', '#' + ch.target_key);
            addParam(previewEl, 'Ciphertext c', ch.c);
            ch.public_keys.forEach(function(k) {
                addParam(previewEl, 'Key #' + k.id + ' — n', k.n);
                addParam(previewEl, 'Key #' + k.id + ' — e', k.e);
            });
        } else if (type === 'rsa_franklinReiter') {
            addParam(previewEl, 'n', ch.n);
            addParam(previewEl, 'e', ch.e);
            addParam(previewEl, 'c1 (encrypts m)', ch.c1);
            addParam(previewEl, 'c2 (encrypts m + delta)', ch.c2);
            addParam(previewEl, 'delta', ch.delta);
        } else if (type === 'rsa_commonModulus') {
            addParam(previewEl, 'n (shared modulus)', ch.n);
            addParam(previewEl, 'e1', ch.e1);
            addParam(previewEl, 'c1', ch.c1);
            addParam(previewEl, 'e2', ch.e2);
            addParam(previewEl, 'c2', ch.c2);
        } else {
            if (ch.n) addParam(previewEl, 'n (modulus)', ch.n);
            if (ch.e) addParam(previewEl, 'e (public exponent)', ch.e);
            if (ch.c) addParam(previewEl, 'c (ciphertext)', ch.c);
            if (ch.dp) addParam(previewEl, 'dp = d mod (p-1)', ch.dp);
            if (ch.partial_p) addParam(previewEl, 'partial_p (' + ch.leaked_bits + '/' + ch.total_bits + ' bits' + (ch.leak_type ? ', ' + ch.leak_type : '') + ')', ch.partial_p);
            if (ch.partial_d) addParam(previewEl, 'partial_d (' + ch.leaked_bits + '/' + ch.total_bits + ' bits)', ch.partial_d);
            if (ch.partial_pem) addParam(previewEl, 'Partial PEM', ch.partial_pem);
            if (ch.phi) addParam(previewEl, 'phi(n)', ch.phi);
            if (ch.sum_pq) addParam(previewEl, 'p + q', ch.sum_pq);
            if (ch.d_bits) addParam(previewEl, 'd bits (' + ch.unknown_bits + ' unknown)', ch.d_bits);
            if (ch.padding) addParam(previewEl, 'Padding', ch.padding);
            if (ch.oracle_endpoint) addParam(previewEl, 'Oracle Endpoint', ch.oracle_endpoint);
            if (ch.num_factors_hint) addParam(previewEl, 'Number of prime factors', String(ch.num_factors_hint));
            if (ch.primorial_hint) addParam(previewEl, 'Primorial Hint', ch.primorial_hint);
        }

        if (ch.note) {
            var noteEl = document.createElement('p');
            noteEl.style.cssText = 'color:var(--ctf-cyan);font-size:0.8125rem;margin-top:0.75rem;font-style:italic;font-family:var(--ctf-font-mono)';
            noteEl.textContent = ch.note;
            previewEl.appendChild(noteEl);
        }

        // Solution tab
        var solEl = document.getElementById('solutionResult');
        var sol = bundle.solution;
        var solHtml = '<div class="sg-form-group"><span class="sg-label">Flag</span><pre class="sg-json-pre" style="max-height:none;color:var(--ctf-cyan)">' + escHtml(sol.flag) + '</pre></div>';
        solHtml += '<div class="sg-form-group"><span class="sg-label">SHA-256 Hash</span><pre class="sg-json-pre" style="max-height:none;font-size:0.6875rem">' + escHtml(sol.hash) + '</pre></div>';
        solHtml += '<div class="sg-form-group"><span class="sg-label">Method</span><pre class="sg-json-pre" style="max-height:none;color:var(--ctf-purple)">' + escHtml(sol.method) + '</pre></div>';
        if (sol.p) solHtml += '<div class="sg-form-group"><span class="sg-label">p</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(sol.p) + '</pre></div>';
        if (sol.q) solHtml += '<div class="sg-form-group"><span class="sg-label">q</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(sol.q) + '</pre></div>';
        if (sol.primes) solHtml += '<div class="sg-form-group"><span class="sg-label">Primes</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(JSON.stringify(sol.primes, null, 2)) + '</pre></div>';
        if (sol.d) solHtml += '<div class="sg-form-group"><span class="sg-label">d (private exponent)</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(sol.d) + '</pre></div>';
        if (sol.phi) solHtml += '<div class="sg-form-group"><span class="sg-label">phi(n)</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(sol.phi) + '</pre></div>';
        if (sol.shared_prime) solHtml += '<div class="sg-form-group"><span class="sg-label">Shared Prime</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(sol.shared_prime) + '</pre></div>';
        if (sol.keys) solHtml += '<div class="sg-form-group"><span class="sg-label">All Keys</span><pre class="sg-json-pre">' + escHtml(JSON.stringify(sol.keys, null, 2)) + '</pre></div>';
        if (sol.full_pem) solHtml += '<div class="sg-form-group"><span class="sg-label">Full PEM</span><pre class="sg-json-pre">' + escHtml(sol.full_pem) + '</pre></div>';
        solEl.innerHTML = solHtml;

        // Hints tab
        var hintsEl = document.getElementById('hintsList');
        hintsEl.innerHTML = '';
        var hints = bundle.hints || [];
        for (var h = 0; h < hints.length; h++) {
            var li = document.createElement('li');
            li.className = 'sg-hint-toggle';
            li.innerHTML = '<span class="sg-hint-label">Hint ' + (h + 1) + '</span> <span style="color:var(--ctf-text-dim);font-size:0.75rem">(click to reveal)</span>' +
                '<div class="sg-hint-loading"><span class="sg-spinner"></span> Decoding...</div>' +
                '<div class="sg-hint-text">' + escHtml(hints[h]) + '</div>';
            li.onclick = (function(el) {
                return function() {
                    if (el.classList.contains('open') || el.classList.contains('loading')) return;
                    el.classList.add('loading');
                    setTimeout(function() { el.classList.remove('loading'); el.classList.add('open'); }, 1200);
                };
            })(li);
            hintsEl.appendChild(li);
        }

        // JSON tab
        document.getElementById('jsonPre').textContent = JSON.stringify(bundle, null, 2);
    }

    function addParam(container, label, value) {
        var div = document.createElement('div');
        div.style.marginBottom = '0.75rem';
        div.innerHTML = '<div class="sg-param-label">' + escHtml(label) + '</div>';
        var box = document.createElement('div');
        box.className = 'sg-param-box';
        box.textContent = value;
        div.appendChild(box);
        container.appendChild(div);
    }

    function escHtml(s) { return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

    function getChallengeText() {
        if (!currentBundle) return '';
        var ch = currentBundle.challenge;
        var lines = ['RSA CTF Challenge', 'Type: ' + currentBundle.meta.type, ''];
        if (ch.n) lines.push('n = ' + ch.n);
        if (ch.e) lines.push('e = ' + ch.e);
        if (ch.c) lines.push('c = ' + ch.c);
        if (ch.c1) lines.push('c1 = ' + ch.c1);
        if (ch.c2) lines.push('c2 = ' + ch.c2);
        if (ch.e1) lines.push('e1 = ' + ch.e1);
        if (ch.e2) lines.push('e2 = ' + ch.e2);
        if (ch.delta) lines.push('delta = ' + ch.delta);
        if (ch.dp) lines.push('dp = ' + ch.dp);
        if (ch.partial_p) lines.push('partial_p = ' + ch.partial_p);
        if (ch.partial_d) lines.push('partial_d = ' + ch.partial_d);
        if (ch.partial_pem) lines.push('', 'Partial PEM:', ch.partial_pem);
        if (ch.phi) lines.push('phi = ' + ch.phi);
        if (ch.sum_pq) lines.push('p+q = ' + ch.sum_pq);
        if (ch.d_bits) lines.push('d_bits = ' + ch.d_bits);
        if (ch.recipients) {
            lines.push('e = ' + ch.e);
            ch.recipients.forEach(function(r) {
                lines.push('', 'Recipient ' + r.id + ':', '  n = ' + r.n, '  c = ' + r.c);
            });
        }
        if (ch.public_keys) {
            lines.push('target_key = ' + ch.target_key, 'c = ' + ch.c);
            ch.public_keys.forEach(function(k) {
                lines.push('', 'Key #' + k.id + ':', '  n = ' + k.n, '  e = ' + k.e);
            });
        }
        if (ch.note) lines.push('', 'Note: ' + ch.note);
        return lines.join('\n');
    }

    function downloadChallenge(ev) {
        if (!currentBundle) return;
        var btn = ev && ev.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        setStatus('Preparing download...', 'var(--ctf-cyan)', true);
        setTimeout(function() {
            var text = getChallengeText();
            var blob = new Blob([text], { type: 'text/plain' });
            var a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = 'rsa-challenge.txt';
            a.click();
            URL.revokeObjectURL(a.href);
            setStatus('Challenge downloaded.', 'var(--ctf-green)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1500);
    }

    function downloadJSON(ev) {
        if (!currentBundle) return;
        var btn = ev && ev.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        setStatus('Preparing JSON...', 'var(--ctf-cyan)', true);
        setTimeout(function() {
            if (window.ToolUtils) {
                ToolUtils.downloadAsFile(JSON.stringify(currentBundle, null, 2), 'rsa-challenge-bundle.json', {
                    mimeType: 'application/json', toolName: 'RSA CTF Generator'
                });
            } else {
                var blob = new Blob([JSON.stringify(currentBundle, null, 2)], { type: 'application/json' });
                var a = document.createElement('a');
                a.href = URL.createObjectURL(blob);
                a.download = 'rsa-challenge-bundle.json';
                a.click();
                URL.revokeObjectURL(a.href);
            }
            setStatus('JSON bundle downloaded.', 'var(--ctf-green)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1500);
    }

    function copyParams(ev) {
        if (!currentBundle) return;
        var btn = ev && ev.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        setStatus('Copying...', 'var(--ctf-cyan)', true);
        setTimeout(function() {
            var text = getChallengeText();
            if (window.ToolUtils) {
                ToolUtils.copyToClipboard(text, { toastMessage: 'Parameters copied!', toolName: 'RSA CTF Generator' });
            } else if (navigator.clipboard) {
                navigator.clipboard.writeText(text);
            }
            setStatus('Parameters copied to clipboard.', 'var(--ctf-green)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1000);
    }
    </script>
    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
    <%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
