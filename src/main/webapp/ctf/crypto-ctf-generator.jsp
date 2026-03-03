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
        <jsp:param name="toolName" value="Free Cryptography CTF Generator - 39 Ciphers, 6 Challenge Types" />
        <jsp:param name="toolDescription" value="Generate crypto CTF challenges: 39 ciphers and encodings across 4 difficulty levels with 6 challenge types. Dynamic pipeline composition with hundreds of unique combos. Free JSON export." />
        <jsp:param name="toolCategory" value="CTF & Challenges" />
        <jsp:param name="toolUrl" value="ctf/crypto-ctf-generator.jsp" />
        <jsp:param name="toolKeywords" value="cryptography CTF generator, cipher challenge maker, CTF crypto puzzle, crypto CTF online free, cipher CTF generator tool, capture the flag cryptography, CTF challenge creator, cryptanalysis practice tool, CTF training crypto, crypto pipeline builder, create cipher challenge, classical cipher CTF, RSA CTF challenge, AES CTF challenge, Vigenere CTF, Caesar cipher CTF, XOR CTF, crib dragging CTF, frequency analysis CTF" />
        <jsp:param name="toolImage" value="images/crypto-ctf-icon.svg" />
        <jsp:param name="toolFeatures" value="39 cipher and encoding steps,4 difficulty levels with dynamic pipeline composition,6 challenge types: standard multi-part crib-drag hash-crack cipher-identify key-reuse,Classical ciphers: Caesar Vigenere Playfair Beaufort Autokey Hill Bifid ADFGVX,Modern crypto: AES RC4 RSA XOR OTP,Encodings: Base64 Base32 Hex Morse Binary ASCII85 NATO Tap-code,Dynamic composer: hundreds of unique pipeline combinations,JSON challenge export with full solution,Progressive solver hints with reveal gates,SHA-256 flag verification,100% client-side - no upload to server" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter your flag|Type the flag message that solvers must recover,Choose difficulty and type|Select from 4 difficulty levels and 6 challenge types: Standard Multi-Part Crib-Drag Hash-Crack Cipher-Identify Key-Reuse,Generate the challenge|Click Generate - the engine applies a random pipeline of cipher and encoding steps to produce ciphertext,Download and share|Download the challenge text and JSON bundle containing the full solution keys and progressive hints for solvers" />
        <jsp:param name="breadcrumbCategoryUrl" value="ctf/index.jsp" />
        <jsp:param name="faq1q" value="How do I create a cryptography CTF challenge?" />
        <jsp:param name="faq1a" value="Enter your flag, choose a difficulty level and challenge type, then click Generate. The engine selects a random pipeline of encoding and cipher steps, applies them to your flag, and produces a ciphertext. You get a downloadable challenge text plus a JSON bundle with the complete solution, decryption keys, and progressive hints." />
        <jsp:param name="faq2q" value="What are the 6 challenge types?" />
        <jsp:param name="faq2a" value="Standard (single cipher pipeline), Multi-Part (flag split into N parts each encoded differently), Crib Drag (two XOR ciphertexts with same key), Hash Crack (SHA-256 hash plus wordlist), Cipher Identify (multiple-choice recognition), and Key Reuse (same Vigenere or XOR key on two messages)." />
        <jsp:param name="faq3q" value="Is this crypto CTF tool free and private?" />
        <jsp:param name="faq3a" value="Yes, 100% free with no signup required. All encoding, encryption, and challenge generation runs entirely in your browser using JavaScript and the Web Crypto API. No data is ever uploaded to a server." />
        <jsp:param name="faq4q" value="What ciphers and encodings are supported?" />
        <jsp:param name="faq4a" value="39 steps including: Base64, Base32, Hex, ASCII85, Morse, Binary, Octal, Decimal, A1Z26, NATO, Phone Keypad, Tap Code, URL Encode, ROT13, ROT47, Atbash, Caesar, Vigenere, Beaufort, Autokey, Affine, Rail Fence, Bacon, Polybius, Columnar Transposition, Substitution, Playfair, Bifid, Hill Cipher, ADFGVX, Nihilist, XOR, OTP, RC4, AES Encrypt, RSA Textbook, Compress, Decoy, and Reverse." />
        <jsp:param name="faq5q" value="What is dynamic pipeline composition?" />
        <jsp:param name="faq5a" value="Instead of fixed templates, the dynamic composer randomly combines compatible cipher and encoding steps at generation time. It categorizes steps into groups (classical, modern, grid ciphers, encodings) and builds valid chains, giving hundreds of unique combinations per difficulty level." />
        <jsp:param name="faq6q" value="How do the progressive hints work?" />
        <jsp:param name="faq6a" value="The engine generates 3-7 hints based on the pipeline. Each hint reveals progressively more about the encoding chain. Hints are included in the JSON bundle and can be shared with solvers one at a time." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <style>
        :root{
            --ctf-green:#00cc33;--ctf-green-dim:#059669;--ctf-cyan:#0ea5e9;--ctf-purple:#a855f7;
            --ctf-red:#ef4444;--ctf-bg:var(--bg-primary,#fff);--ctf-surface:var(--bg-secondary,#f8fafc);--ctf-surface-2:var(--bg-tertiary,#f1f5f9);
            --ctf-border:var(--border,#e2e8f0);--ctf-text:var(--text-primary,#0f172a);--ctf-text-dim:var(--text-secondary,#475569);
            --ctf-glow:0 0 20px rgba(0,204,51,0.1);--ctf-font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
            --tool-primary:#6366f1;--tool-primary-dark:#4f46e5;
            --tool-gradient:linear-gradient(135deg,#6366f1 0%,#818cf8 100%);
            --tool-light:rgba(99,102,241,0.08);
        }
        [data-theme="dark"]{
            --ctf-green:#00ff41;--ctf-green-dim:#00cc33;--ctf-cyan:#00d4ff;
            --ctf-glow:0 0 20px rgba(0,255,65,0.15);
            --tool-light:rgba(99,102,241,0.12);
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
        .sg-input,.sg-select,.sg-textarea{width:100%;padding:0.625rem 0.875rem;background:var(--ctf-surface-2);border:1px solid var(--ctf-border);border-radius:0.5rem;color:var(--ctf-text);font-size:0.875rem;font-family:inherit;transition:border-color 0.2s}
        .sg-input:focus,.sg-select:focus,.sg-textarea:focus{outline:none;border-color:var(--ctf-green);box-shadow:0 0 0 2px rgba(0,255,65,0.1)}
        .sg-textarea{font-family:var(--ctf-font-mono);resize:vertical;min-height:80px}
        .sg-select{cursor:pointer;appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 0.75rem center}

        .sg-btn{display:inline-flex;align-items:center;justify-content:center;gap:0.5rem;padding:0.75rem 1.5rem;border:none;border-radius:0.5rem;font-size:0.875rem;font-weight:600;cursor:pointer;transition:all 0.2s;font-family:inherit;width:100%}
        .sg-btn-primary{background:linear-gradient(135deg,#059669,#10b981);color:#fff}
        .sg-btn-primary:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(16,185,129,0.3)}
        .sg-btn-primary:disabled{opacity:0.5;cursor:not-allowed;transform:none;box-shadow:none}
        .sg-btn-secondary{background:var(--ctf-surface-2);color:var(--ctf-text);border:1px solid var(--ctf-border)}
        .sg-btn-secondary:hover{border-color:var(--ctf-green);color:var(--ctf-green)}
        .sg-btn-sm{padding:0.5rem 1rem;font-size:0.8125rem;width:auto}

        .sg-actions{display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.75rem}

        .sg-output{position:relative}
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

        .sg-pipeline-viz{display:flex;flex-wrap:wrap;gap:0.5rem;align-items:center}
        .sg-pipe-step{padding:0.375rem 0.75rem;background:var(--ctf-surface-2);border:1px solid var(--ctf-border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--ctf-font-mono);color:var(--ctf-cyan)}
        .sg-pipe-step.terminal{border-color:var(--ctf-green);color:var(--ctf-green)}
        .sg-pipe-arrow{color:var(--ctf-text-dim);font-size:0.75rem}

        .sg-ciphertext-box{background:var(--ctf-bg);border:1px solid var(--ctf-border);border-radius:0.5rem;padding:1rem;font-family:var(--ctf-font-mono);font-size:0.8125rem;color:var(--ctf-cyan);overflow:auto;max-height:300px;white-space:pre-wrap;word-break:break-all;line-height:1.6;user-select:all}

        .sg-toggle-row{display:flex;align-items:center;gap:0.75rem;margin-bottom:0.25rem}
        .sg-toggle{position:relative;width:36px;height:20px;flex-shrink:0}
        .sg-toggle input{opacity:0;width:0;height:0}
        .sg-toggle .sg-toggle-slider{position:absolute;cursor:pointer;inset:0;background:var(--ctf-surface-2);border:1px solid var(--ctf-border);border-radius:10px;transition:0.2s}
        .sg-toggle .sg-toggle-slider::before{content:'';position:absolute;height:14px;width:14px;left:2px;bottom:2px;background:var(--ctf-text-dim);border-radius:50%;transition:0.2s}
        .sg-toggle input:checked+.sg-toggle-slider{background:var(--ctf-green-dim);border-color:var(--ctf-green)}
        .sg-toggle input:checked+.sg-toggle-slider::before{transform:translateX(16px);background:#fff}
        .sg-toggle-label{font-size:0.8125rem;color:var(--ctf-text)}

        .sg-mc-choices{display:grid;gap:0.5rem;margin-top:0.75rem}
        .sg-mc-choice{padding:0.625rem 0.875rem;background:var(--ctf-surface-2);border:1px solid var(--ctf-border);border-radius:0.5rem;font-size:0.8125rem;font-family:var(--ctf-font-mono);color:var(--ctf-text);cursor:default}

        @media(max-width:640px){.sg-actions{flex-direction:column}.sg-btn-sm{width:100%}}

        .sg-spinner{display:inline-block;width:16px;height:16px;border:2px solid rgba(255,255,255,0.2);border-top-color:var(--ctf-green);border-radius:50%;animation:sg-spin 0.6s linear infinite;vertical-align:middle}
        @keyframes sg-spin{to{transform:rotate(360deg)}}
        .sg-cooldown-bar{height:3px;background:var(--ctf-green);border-radius:2px;margin-top:0.5rem;transition:width linear;width:0}
        .sg-cooldown-bar.active{width:100%}

        .sg-gate{text-align:center;padding:2.5rem 1.5rem}
        .sg-gate-icon{margin-bottom:0.75rem;opacity:0.5}
        .sg-gate h3{font-size:0.9375rem;color:var(--ctf-text);margin-bottom:0.25rem}
        .sg-gate p{font-size:0.8125rem;color:var(--ctf-text-dim);margin-bottom:1rem}
        .sg-gate .sg-btn{width:auto;display:inline-flex}
        .sg-gate-spinner{display:none;flex-direction:column;align-items:center;gap:0.75rem;padding:2.5rem 1.5rem}
        .sg-gate-spinner.active{display:flex}
        .sg-gate-spinner .sg-spinner{width:28px;height:28px;border-width:3px}
        .sg-gate-spinner p{font-size:0.8125rem;color:var(--ctf-text-dim);font-family:var(--ctf-font-mono)}

        .sg-hint-toggle .sg-hint-loading{display:none;margin-top:0.5rem;color:var(--ctf-cyan);font-size:0.75rem}
        .sg-hint-toggle.loading .sg-hint-loading{display:flex;align-items:center;gap:0.5rem}

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
                <h1 class="tool-page-title">Cryptography <span style="color:var(--ctf-green)">CTF</span> Generator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/ctf/index.jsp">CTF Generators</a> /
                    Cryptography CTF
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">39 Ciphers</span>
                <span class="tool-badge">6 Types</span>
                <span class="tool-badge">Client-Side</span>
            </div>
        </div>
    </header>

    <div class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Enter a flag, pick a difficulty and challenge type, then hit Generate. The engine builds a random cipher pipeline, encodes your flag, and outputs ciphertext with a full solution bundle including decryption keys and progressive hints.</p>
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
                    Configure Challenge
                </div>
                <div class="sg-card-body">
                    <div class="sg-form-group">
                        <label class="sg-label">Flag Message</label>
                        <input type="text" class="sg-input" id="flagInput" value="flag{crypto_master}" placeholder="flag{your_secret_here}">
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Challenge Type</label>
                        <select class="sg-select" id="challengeTypeSelect">
                            <option value="standard" selected>Standard &mdash; single cipher pipeline</option>
                            <option value="multiPart">Multi-Part &mdash; flag split into N pieces</option>
                            <option value="cribDrag">Crib Drag &mdash; XOR with same key</option>
                            <option value="hashCrack">Hash Crack &mdash; find the preimage</option>
                            <option value="cipherIdentify">Cipher Identify &mdash; name the cipher</option>
                            <option value="keyReuse">Key Reuse &mdash; known-plaintext attack</option>
                        </select>
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Difficulty</label>
                        <select class="sg-select" id="difficultySelect">
                            <option value="easy">Easy &mdash; single encoding</option>
                            <option value="medium" selected>Medium &mdash; cipher + encoding</option>
                            <option value="hard">Hard &mdash; multi-layer ciphers</option>
                            <option value="pro">Pro &mdash; modern crypto + chains</option>
                        </select>
                    </div>

                    <div class="sg-form-group">
                        <div class="sg-toggle-row">
                            <label class="sg-toggle">
                                <input type="checkbox" id="composeToggle" checked>
                                <span class="sg-toggle-slider"></span>
                            </label>
                            <span class="sg-toggle-label">Dynamic Composition <span class="sg-label-hint">(more variety)</span></span>
                        </div>
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Password <span class="sg-label-hint">(for encrypted pipelines)</span></label>
                        <input type="text" class="sg-input" id="passwordInput" placeholder="Optional &mdash; used by AES/XOR/RC4 steps">
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
                            <option value="7">7 hints</option>
                        </select>
                    </div>

                    <button class="sg-btn sg-btn-primary" id="generateBtn" onclick="doGenerate()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10"/></svg>
                        Generate Challenge
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
                        <p>Configure your settings and click Generate.</p>
                    </div>
                    <div id="challengeResult" style="display:none">
                        <div style="margin-bottom:1rem" id="pipelineRow">
                            <span class="sg-label">Pipeline</span>
                            <div class="sg-pipeline-viz" id="pipelineViz"></div>
                        </div>
                        <div id="challengePreview" style="margin-bottom:1rem"></div>
                        <div class="sg-actions">
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="downloadChallenge(event)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                Download Text
                            </button>
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="downloadJSON(event)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                Download JSON
                            </button>
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="copyCiphertext(event)">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                                Copy Ciphertext
                            </button>
                        </div>
                    </div>
                </div>

                <div class="sg-tab-content" id="tab-solution">
                    <div class="sg-empty" id="solutionEmpty"><h3>Solution will appear here</h3><p>Generate a challenge first.</p></div>
                    <div class="sg-gate" id="solutionGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
                        <h3>Solution is ready</h3>
                        <p>Reveal the complete flag, pipeline, and decryption keys.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('solution',3000)">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            Reveal Solution
                        </button>
                    </div>
                    <div class="sg-gate-spinner" id="solutionSpinner"><span class="sg-spinner"></span><p>Decrypting solution...</p></div>
                    <div id="solutionResult" style="display:none"></div>
                </div>

                <div class="sg-tab-content" id="tab-hints">
                    <div class="sg-empty" id="hintsEmpty"><h3>Hints will appear here</h3><p>Generate a challenge to see progressive hints.</p></div>
                    <div class="sg-gate" id="hintsGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></div>
                        <h3>Hints are ready</h3><p>Progressive hints to guide solvers toward the flag.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('hints',2000)">Reveal Hints</button>
                    </div>
                    <div class="sg-gate-spinner" id="hintsSpinner"><span class="sg-spinner"></span><p>Loading hints...</p></div>
                    <ul class="sg-hints-list" id="hintsList" style="display:none"></ul>
                </div>

                <div class="sg-tab-content" id="tab-json">
                    <div class="sg-empty" id="jsonEmpty"><h3>Raw JSON will appear here</h3><p>Complete challenge bundle in JSON format.</p></div>
                    <div class="sg-gate" id="jsonGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
                        <h3>Full JSON bundle is ready</h3><p>Complete challenge bundle with solution, hints, and data.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('json',2500)">Reveal Full JSON</button>
                    </div>
                    <div class="sg-gate-spinner" id="jsonSpinner"><span class="sg-spinner"></span><p>Serializing challenge data...</p></div>
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
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">How do I create a cryptography CTF challenge?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">Enter your flag, choose a difficulty level and challenge type, then click Generate. The engine picks a random pipeline of encoding and cipher steps, applies them to your flag, and produces ciphertext. You get a downloadable challenge plus a JSON bundle with the complete solution, decryption keys, and progressive hints.</div></div>
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">What are the 6 challenge types?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">Standard (single cipher pipeline producing ciphertext), Multi-Part (flag split into N parts each encoded differently), Crib Drag (two messages XOR'd with the same key), Hash Crack (SHA-256 hash plus wordlist), Cipher Identify (multiple-choice: name the cipher from its output), and Key Reuse (same Vigenere/XOR key on two messages for known-plaintext attack).</div></div>
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">Is this crypto CTF tool free and private?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">Yes, 100% free with no signup required. All encoding, encryption, and challenge generation runs entirely in your browser using JavaScript and the Web Crypto API. No data is ever uploaded to a server. You can use it offline once the page loads.</div></div>
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">What ciphers and encodings are supported?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">39 steps including: Base64, Base32, Hex, ASCII85, Morse, Binary, Octal, Decimal, A1Z26, NATO, Phone Keypad, Tap Code, URL Encode, ROT13, ROT47, Atbash, Caesar, Vigenere, Beaufort, Autokey, Affine, Rail Fence, Bacon, Polybius, Columnar Transposition, Substitution, Playfair, Bifid, Hill Cipher, ADFGVX, Nihilist, XOR, OTP, RC4, AES Encrypt, RSA Textbook, Compress, Decoy, and Reverse.</div></div>
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">What is dynamic pipeline composition?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">Instead of fixed templates, the dynamic composer randomly combines compatible cipher and encoding steps at generation time. It categorizes steps into groups (classical, modern, grid ciphers, encodings) and builds valid chains, giving hundreds of unique combinations per difficulty level.</div></div>
                <div class="sg-faq-item"><button class="sg-faq-q" onclick="this.parentElement.classList.toggle('open')">How do the progressive hints work?<svg class="sg-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg></button><div class="sg-faq-a">The engine generates 3-7 hints based on the pipeline. Each hint reveals progressively more about the encoding chain. Hints are included in the JSON bundle and can be shared with solvers one at a time.</div></div>
            </div>
        </div>
    </section>

    <jsp:include page="../modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="ctf/crypto-ctf-generator.jsp"/>
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

    <script src="<%=request.getContextPath()%>/js/stego-engine.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/stego-rs.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/stego-imagegen.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/ctf/js/ctf-steps.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/ctf/js/ctf-engine.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/ctf/js/ctf-crypto-engine.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <script>
    var currentBundle = null;
    var generateCooldownUntil = 0;
    var GENERATE_DELAY_MS = 3000;
    var COOLDOWN_MS = 8000;
    var revealedSections = {};

    var GENERATE_PHASES = [
        'Selecting cipher pipeline...',
        'Applying transforms...',
        'Encoding payload...',
        'Generating ciphertext...',
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
        el.style.color = color || 'var(--ctf-green)';
    }

    function startCooldown() {
        generateCooldownUntil = Date.now() + COOLDOWN_MS;
        var bar = document.getElementById('cooldownBar');
        bar.style.width = '100%';
        bar.style.transitionDuration = '0s';
        bar.offsetHeight;
        bar.style.transitionDuration = (COOLDOWN_MS / 1000) + 's';
        bar.style.width = '0';
    }

    function doGenerate() {
        var now = Date.now();
        var remaining = generateCooldownUntil - now;
        if (remaining > 0) {
            setStatus('Please wait ' + Math.ceil(remaining / 1000) + 's before generating again.', 'var(--ctf-purple)');
            return;
        }

        var flag = document.getElementById('flagInput').value.trim();
        if (!flag) { setStatus('Enter a flag message.', 'var(--ctf-red)'); return; }
        var challengeType = document.getElementById('challengeTypeSelect').value;
        var difficulty = document.getElementById('difficultySelect').value;
        var compose = document.getElementById('composeToggle').checked;
        var password = document.getElementById('passwordInput').value.trim() || undefined;
        var seedStr = document.getElementById('seedInput').value.trim();
        var seed = seedStr ? parseInt(seedStr, 10) : undefined;
        var hintCount = parseInt(document.getElementById('hintCountSelect').value, 10);

        var btn = document.getElementById('generateBtn');
        btn.disabled = true;
        revealedSections = {};

        var phaseIdx = 0;
        setStatus(GENERATE_PHASES[0], 'var(--ctf-cyan)', true);
        var phaseInterval = setInterval(function() {
            phaseIdx++;
            if (phaseIdx < GENERATE_PHASES.length) setStatus(GENERATE_PHASES[phaseIdx], 'var(--ctf-cyan)', true);
        }, GENERATE_DELAY_MS / GENERATE_PHASES.length);

        var opts = { hintCount: hintCount, compose: compose };
        if (password) opts.password = password;
        if (seed != null && !isNaN(seed)) opts.seed = seed;

        var CE = CTFCryptoEngine;
        var promise;

        if (challengeType === 'standard') {
            promise = CE.generateCryptoChallenge(flag, difficulty, opts);
        } else if (challengeType === 'multiPart') {
            promise = CE.generateMultiPartChallenge(flag, difficulty, opts);
        } else if (challengeType === 'cribDrag') {
            promise = CE.generateCribDragChallenge(flag, opts);
        } else if (challengeType === 'hashCrack') {
            promise = CE.generateHashCrackChallenge(flag, opts);
        } else if (challengeType === 'cipherIdentify') {
            promise = CE.generateCipherIdentifyChallenge(flag, opts);
        } else if (challengeType === 'keyReuse') {
            promise = CE.generateKeyReuseChallenge(flag, opts);
        } else {
            promise = CE.generateCryptoChallenge(flag, difficulty, opts);
        }

        var startTime = Date.now();

        promise.then(function(bundle) {
            var elapsed = Date.now() - startTime;
            return new Promise(function(resolve) {
                setTimeout(function() { resolve(bundle); }, Math.max(0, GENERATE_DELAY_MS - elapsed));
            });
        }).then(function(bundle) {
            clearInterval(phaseInterval);
            bundle.note = 'Generated by 8gwifi.org Cryptography CTF Generator \u2014 https://8gwifi.org/ctf/crypto-ctf-generator.jsp';
            currentBundle = bundle;
            renderChallenge(bundle);
            setStatus('Challenge generated successfully.', 'var(--ctf-green)');
            btn.disabled = false;
            startCooldown();
        }).catch(function(e) {
            clearInterval(phaseInterval);
            setStatus('Error: ' + e.message, 'var(--ctf-red)');
            btn.disabled = false;
        });
    }

    function revealSection(section, delayMs) {
        if (revealedSections[section]) return;
        var gate = document.getElementById(section + 'Gate');
        var spinner = document.getElementById(section + 'Spinner');
        var result = document.getElementById(section === 'json' ? 'jsonPre' : (section + (section === 'hints' ? 'List' : 'Result')));
        if (!gate || !spinner || !result) return;
        gate.style.display = 'none';
        spinner.classList.add('active');
        setTimeout(function() {
            spinner.classList.remove('active');
            result.style.display = 'block';
            revealedSections[section] = true;
        }, delayMs);
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

        var type = bundle.meta.type;
        var vizEl = document.getElementById('pipelineViz');
        var pipeRow = document.getElementById('pipelineRow');
        vizEl.innerHTML = '';

        if (bundle.solution && bundle.solution.pipeline) {
            pipeRow.style.display = 'block';
            var pipeline = bundle.solution.pipeline;
            for (var i = 0; i < pipeline.length; i++) {
                if (i > 0) { var arrow = document.createElement('span'); arrow.className = 'sg-pipe-arrow'; arrow.textContent = '\u2192'; vizEl.appendChild(arrow); }
                var step = document.createElement('span');
                step.className = 'sg-pipe-step';
                if (pipeline[i].id === 'output') step.className += ' terminal';
                step.textContent = pipeline[i].id;
                vizEl.appendChild(step);
            }
        } else {
            pipeRow.style.display = 'none';
        }

        var previewEl = document.getElementById('challengePreview');
        previewEl.innerHTML = '';

        if (type === 'crypto') {
            var ct = bundle.challenge.ciphertext || '';
            var div = document.createElement('div');
            div.innerHTML = '<span class="sg-label">Ciphertext</span>';
            var pre = document.createElement('div');
            pre.className = 'sg-ciphertext-box';
            pre.textContent = ct;
            div.appendChild(pre);
            previewEl.appendChild(div);
        } else if (type === 'multiPart') {
            bundle.challenge.parts.forEach(function(part, idx) {
                var div = document.createElement('div');
                div.style.marginBottom = '0.75rem';
                div.innerHTML = '<span class="sg-label">Part ' + part.partIndex + ' of ' + part.totalParts + '</span>';
                var pre = document.createElement('div');
                pre.className = 'sg-ciphertext-box';
                pre.textContent = part.ciphertext;
                div.appendChild(pre);
                previewEl.appendChild(div);
            });
        } else if (type === 'cribDrag') {
            ['ciphertext1', 'ciphertext2'].forEach(function(key, idx) {
                var div = document.createElement('div');
                div.style.marginBottom = '0.75rem';
                div.innerHTML = '<span class="sg-label">Ciphertext ' + (idx + 1) + '</span>';
                var pre = document.createElement('div');
                pre.className = 'sg-ciphertext-box';
                pre.textContent = bundle.challenge[key];
                div.appendChild(pre);
                previewEl.appendChild(div);
            });
            var hint = document.createElement('p');
            hint.style.cssText = 'color:var(--ctf-purple);font-size:0.8125rem;font-style:italic';
            hint.textContent = bundle.challenge.knownPlaintextHint;
            previewEl.appendChild(hint);
        } else if (type === 'hashCrack') {
            var hashDiv = document.createElement('div');
            hashDiv.innerHTML = '<span class="sg-label">SHA-256 Hash</span>';
            var hashPre = document.createElement('div');
            hashPre.className = 'sg-ciphertext-box';
            hashPre.textContent = bundle.challenge.hash;
            hashDiv.appendChild(hashPre);
            previewEl.appendChild(hashDiv);
            if (bundle.challenge.wordlist) {
                var wlDiv = document.createElement('div');
                wlDiv.style.marginTop = '0.75rem';
                wlDiv.innerHTML = '<span class="sg-label">Wordlist (' + bundle.challenge.wordlist.length + ' words)</span>';
                var wlPre = document.createElement('div');
                wlPre.className = 'sg-ciphertext-box';
                wlPre.style.maxHeight = '150px';
                wlPre.textContent = bundle.challenge.wordlist.join('\n');
                wlDiv.appendChild(wlPre);
                previewEl.appendChild(wlDiv);
            }
        } else if (type === 'cipherIdentify') {
            var ctDiv = document.createElement('div');
            ctDiv.innerHTML = '<span class="sg-label">Ciphertext</span>';
            var ctPre = document.createElement('div');
            ctPre.className = 'sg-ciphertext-box';
            ctPre.textContent = bundle.challenge.ciphertext;
            ctDiv.appendChild(ctPre);
            previewEl.appendChild(ctDiv);
            var qDiv = document.createElement('div');
            qDiv.style.marginTop = '0.75rem';
            qDiv.innerHTML = '<span class="sg-label">' + escHtml(bundle.challenge.question) + '</span>';
            var mcDiv = document.createElement('div');
            mcDiv.className = 'sg-mc-choices';
            bundle.challenge.choices.forEach(function(c) {
                var choice = document.createElement('div');
                choice.className = 'sg-mc-choice';
                choice.textContent = c.label;
                mcDiv.appendChild(choice);
            });
            qDiv.appendChild(mcDiv);
            previewEl.appendChild(qDiv);
        } else if (type === 'keyReuse') {
            ['ciphertext1', 'ciphertext2'].forEach(function(key, idx) {
                var div = document.createElement('div');
                div.style.marginBottom = '0.75rem';
                div.innerHTML = '<span class="sg-label">' + (idx === 0 ? 'Unknown Message (ciphertext)' : 'Known Message (ciphertext)') + '</span>';
                var pre = document.createElement('div');
                pre.className = 'sg-ciphertext-box';
                pre.textContent = bundle.challenge[key];
                div.appendChild(pre);
                previewEl.appendChild(div);
            });
            var kpDiv = document.createElement('div');
            kpDiv.innerHTML = '<span class="sg-label">Known Plaintext</span>';
            var kpPre = document.createElement('div');
            kpPre.className = 'sg-ciphertext-box';
            kpPre.style.color = 'var(--ctf-purple)';
            kpPre.textContent = bundle.challenge.knownPlaintext;
            kpDiv.appendChild(kpPre);
            previewEl.appendChild(kpDiv);
        }

        if (bundle.challenge.note) {
            var noteEl = document.createElement('p');
            noteEl.style.cssText = 'color:var(--ctf-cyan);font-size:0.8125rem;margin-top:0.75rem;font-style:italic;font-family:var(--ctf-font-mono)';
            noteEl.textContent = bundle.challenge.note;
            previewEl.appendChild(noteEl);
        }

        var solEl = document.getElementById('solutionResult');
        var sol = bundle.solution;
        var solHtml = '<div class="sg-form-group"><span class="sg-label">Flag</span><pre class="sg-json-pre" style="max-height:none;color:var(--ctf-cyan)">' + escHtml(sol.flag) + '</pre></div>';
        solHtml += '<div class="sg-form-group"><span class="sg-label">SHA-256 Hash</span><pre class="sg-json-pre" style="max-height:none;font-size:0.6875rem;word-break:break-all">' + escHtml(sol.hash) + '</pre></div>';
        if (sol.keys) solHtml += '<div class="sg-form-group"><span class="sg-label">Keys</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(JSON.stringify(sol.keys, null, 2)) + '</pre></div>';
        if (sol.pipeline) solHtml += '<div class="sg-form-group"><span class="sg-label">Pipeline</span><pre class="sg-json-pre">' + escHtml(JSON.stringify(sol.pipeline, null, 2)) + '</pre></div>';
        if (sol.parts) solHtml += '<div class="sg-form-group"><span class="sg-label">Parts (' + sol.parts.length + ')</span><pre class="sg-json-pre">' + escHtml(JSON.stringify(sol.parts, null, 2)) + '</pre></div>';
        if (sol.key) solHtml += '<div class="sg-form-group"><span class="sg-label">Key</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(sol.key) + '</pre></div>';
        if (sol.cipherId) solHtml += '<div class="sg-form-group"><span class="sg-label">Cipher</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(sol.cipherLabel + ' (' + sol.cipherId + ')') + '</pre></div>';
        if (sol.knownText) solHtml += '<div class="sg-form-group"><span class="sg-label">Known Plaintext</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(sol.knownText) + '</pre></div>';
        solEl.innerHTML = solHtml;

        var hintsEl = document.getElementById('hintsList');
        hintsEl.innerHTML = '';
        var hints = bundle.hints || [];
        for (var h = 0; h < hints.length; h++) {
            var li = document.createElement('li');
            li.className = 'sg-hint-toggle';
            li.innerHTML = '<span class="sg-hint-label">Hint ' + (h + 1) + '</span> <span style="color:var(--ctf-text-dim);font-size:0.75rem">(click to reveal)</span>' +
                '<div class="sg-hint-loading"><span class="sg-spinner"></span> Decoding hint...</div>' +
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

        var jsonSafe = JSON.parse(JSON.stringify(bundle));
        if (jsonSafe.challenge && jsonSafe.challenge.data && jsonSafe.challenge.data.length > 200) {
            jsonSafe.challenge.data = jsonSafe.challenge.data.substring(0, 200) + '... [truncated]';
        }
        document.getElementById('jsonPre').textContent = JSON.stringify(jsonSafe, null, 2);
    }

    function escHtml(s) { return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

    function getChallengeText() {
        if (!currentBundle) return '';
        var c = currentBundle.challenge;
        if (c.ciphertext) return c.ciphertext;
        if (c.ciphertext1) return 'Ciphertext 1:\n' + c.ciphertext1 + '\n\nCiphertext 2:\n' + c.ciphertext2;
        if (c.hash) return 'SHA-256: ' + c.hash + (c.wordlist ? '\n\nWordlist:\n' + c.wordlist.join('\n') : '');
        if (c.parts) return c.parts.map(function(p) { return 'Part ' + p.partIndex + ':\n' + p.ciphertext; }).join('\n\n');
        return JSON.stringify(c, null, 2);
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
            a.download = 'challenge.txt';
            a.click();
            URL.revokeObjectURL(a.href);
            setStatus('Download started.', 'var(--ctf-green)');
            if (window.ToolUtils) ToolUtils.showToast('Downloaded challenge.txt', 2000, 'success');
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
                ToolUtils.downloadAsFile(JSON.stringify(currentBundle, null, 2), 'crypto-challenge-bundle.json', {
                    mimeType: 'application/json', toolName: 'Cryptography CTF Generator'
                });
            } else {
                var blob = new Blob([JSON.stringify(currentBundle, null, 2)], { type: 'application/json' });
                var a = document.createElement('a');
                a.href = URL.createObjectURL(blob);
                a.download = 'crypto-challenge-bundle.json';
                a.click();
                URL.revokeObjectURL(a.href);
            }
            setStatus('JSON download started.', 'var(--ctf-green)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1500);
    }

    function copyCiphertext(ev) {
        if (!currentBundle) return;
        var btn = ev && ev.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        setStatus('Copying...', 'var(--ctf-cyan)', true);
        setTimeout(function() {
            var text = getChallengeText();
            if (window.ToolUtils) {
                ToolUtils.copyToClipboard(text, { toastMessage: 'Ciphertext copied!', toolName: 'Cryptography CTF Generator' });
            } else if (navigator.clipboard) {
                navigator.clipboard.writeText(text);
            }
            setStatus('Ciphertext copied to clipboard!', 'var(--ctf-green)');
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
