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
        <jsp:param name="toolName" value="Steganography CTF Generator - Create Stego Challenges Online Free" />
        <jsp:param name="toolDescription" value="Free steganography CTF challenge generator. Hide flags in images and audio with 34 encoding steps, 7 difficulty levels, classical ciphers, zip/tar wrapping, scatter keys, and spectrogram encoding. Exports JSON with full solution and hints." />
        <jsp:param name="toolCategory" value="CTF & Challenges" />
        <jsp:param name="toolUrl" value="ctf/stego-ctf-generator.jsp" />
        <jsp:param name="toolKeywords" value="steganography CTF generator, stego challenge maker, CTF image steganography, hide flag in image, LSB steganography CTF, audio steganography challenge, CTF puzzle generator free, capture the flag steganography, stego CTF online, image CTF generator, forensic CTF stego, CTF challenge creator, steganography practice, CTF training steganography, stego pipeline generator, base64 hex cipher CTF, caesar vigenere CTF" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="34 encoding and cipher steps,7 difficulty levels with 50+ pipeline combos,LSB image steganography with variable bit depth,Audio WAV steganography embedding,Classical ciphers: caesar vigenere atbash morse bacon,Container wrapping: tar zip,Key-based scatter LSB placement,Spectrogram frequency encoding,JSON challenge export with full solution,Progressive solver hints,SHA-256 flag verification,100% client-side processing" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="How does the steganography CTF generator work?" />
        <jsp:param name="faq1a" value="You enter a flag message and choose a difficulty. The engine selects a random pipeline of encoding steps (like base64, caesar cipher, tar wrapping) then embeds the transformed payload into an image or audio file using LSB steganography. You get a downloadable challenge file plus a JSON bundle with the full solution and progressive hints." />
        <jsp:param name="faq2q" value="What difficulty levels are available?" />
        <jsp:param name="faq2a" value="Seven levels: Easy (plain LSB embed), Medium (single encoding + embed), Hard (multi-step ciphers and containers), Pro (encryption + compression + multiple layers), Forensic (file-format tricks like EOF append and PNG metadata), plus audio variants. Each level has multiple random pipeline variations." />
        <jsp:param name="faq3q" value="What encoding and cipher steps are supported?" />
        <jsp:param name="faq3a" value="34 steps including: base64, base32, hex, octal, decimal, binary, morse, rot13, rot47, atbash, caesar, vigenere, rail fence, bacon, polybius, columnar transposition, substitution, XOR, reverse, compress, AES encrypt, Reed-Solomon, tar wrap, zip wrap, strings hide, decoy, inner embed (image-in-image), and scatter embed (key-based random pixel placement)." />
    </jsp:include>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Steganography CTF Challenge Generator",
      "description": "Generate steganography CTF challenges with 34 encoding steps, 7 difficulty levels, classical ciphers, container wrapping, scatter keys, and auto-generated solutions with progressive hints.",
      "url": "https://8gwifi.org/ctf/stego-ctf-generator.jsp",
      "applicationCategory": "SecurityApplication",
      "operatingSystem": "Web Browser",
      "offers": { "@type": "Offer", "price": "0", "priceCurrency": "USD" },
      "featureList": [
        "34 encoding and cipher steps",
        "7 difficulty levels",
        "LSB image and audio steganography",
        "Classical ciphers: Caesar, Vigenere, Atbash, Morse, Bacon, Rail Fence",
        "Container wrapping: TAR, ZIP",
        "Key-based scatter LSB embedding",
        "Spectrogram frequency encoding",
        "JSON challenge export with solution and hints",
        "SHA-256 flag verification"
      ],
      "author": { "@type": "Person", "name": "Anish Nath", "url": "https://8gwifi.org" },
      "publisher": { "@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org" }
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;background:#0a0a0f;color:#e2e8f0;margin:0;min-height:100vh}
        :root{
            --ctf-green:#00ff41;--ctf-green-dim:#00cc33;--ctf-cyan:#00d4ff;--ctf-purple:#a855f7;
            --ctf-red:#ef4444;--ctf-bg:#0a0a0f;--ctf-surface:#111827;--ctf-surface-2:#1f2937;
            --ctf-border:#1e293b;--ctf-text:#e2e8f0;--ctf-text-dim:#94a3b8;
            --ctf-glow:0 0 20px rgba(0,255,65,0.15);--ctf-font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
        }
    </style>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;700&display=swap" media="print" onload="this.media='all'">

    <%@ include file="../modern/ads/ad-init.jsp" %>

    <style>
        .sg-header{padding:2.5rem 1.5rem 1.5rem;max-width:1200px;margin:0 auto}
        .sg-breadcrumbs{font-size:0.8125rem;color:var(--ctf-text-dim);margin-bottom:1rem;font-family:var(--ctf-font-mono)}
        .sg-breadcrumbs a{color:var(--ctf-green-dim);text-decoration:none}
        .sg-breadcrumbs a:hover{text-decoration:underline}
        .sg-header h1{font-size:clamp(1.75rem,4vw,2.5rem);font-weight:800;color:#fff;margin-bottom:0.5rem}
        .sg-header h1 span{color:var(--ctf-green)}
        .sg-header p{color:var(--ctf-text-dim);font-size:0.9375rem;line-height:1.6;max-width:700px}

        .sg-desc-ad{display:flex;gap:1.5rem;flex-wrap:wrap;max-width:1200px;margin:0 auto 1.5rem;padding:0 1.5rem}
        .sg-desc-ad>div:first-child{flex:1;min-width:300px}
        .sg-desc-ad>div:last-child{flex-shrink:0;min-width:300px}

        .sg-main{max-width:1200px;margin:0 auto;padding:0 1.5rem 3rem;display:grid;grid-template-columns:380px 1fr 300px;gap:1.5rem}
        @media(max-width:1200px){.sg-main{grid-template-columns:1fr;}.sg-ads-col{display:none}}

        .sg-card{background:var(--ctf-surface);border:1px solid var(--ctf-border);border-radius:0.75rem;overflow:hidden}
        .sg-card-header{padding:1rem 1.25rem;border-bottom:1px solid var(--ctf-border);display:flex;align-items:center;gap:0.5rem;font-weight:600;color:#fff;font-size:0.9375rem}
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

        .sg-preview-img{max-width:100%;border-radius:0.5rem;border:1px solid var(--ctf-border);background:var(--ctf-bg)}

        .sg-mobile-ad{display:none;margin:1.5rem 0}
        @media(max-width:1200px){.sg-mobile-ad{display:block}}
        @media(max-width:640px){.sg-actions{flex-direction:column}.sg-btn-sm{width:100%}}

        .sg-upload-zone{border:2px dashed var(--ctf-border);border-radius:0.5rem;padding:1rem;text-align:center;cursor:pointer;transition:border-color 0.2s,background 0.2s;display:flex;flex-direction:column;align-items:center;gap:0.25rem}
        .sg-upload-zone:hover,.sg-upload-zone.dragover{border-color:var(--ctf-green);background:rgba(0,255,65,0.03)}
        .sg-upload-label{font-size:0.8125rem;color:var(--ctf-text);font-weight:500}
        .sg-upload-hint-text{font-size:0.6875rem;color:var(--ctf-text-dim)}
        .sg-cover-preview{background:var(--ctf-surface-2);border:1px solid var(--ctf-border);border-radius:0.5rem;padding:0.75rem}
        .sg-cover-preview-inner{display:flex;align-items:center;gap:0.75rem}
        .sg-cover-preview img{width:64px;height:48px;object-fit:cover;border-radius:0.375rem;border:1px solid var(--ctf-border);background:var(--ctf-bg)}
        .sg-cover-info{font-size:0.75rem;color:var(--ctf-text-dim);font-family:var(--ctf-font-mono);line-height:1.5}

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

        .sg-mid-ad{max-width:1200px;margin:1.5rem auto;padding:0 1.5rem}
        .sg-leaderboard-ad{max-width:1200px;margin:0 auto 1rem;padding:0 1.5rem;text-align:center}
    </style>
</head>
<body data-theme="dark">
    <%@ include file="../modern/components/nav-header.jsp" %>

    <%@ include file="../modern/ads/ad-side-rails.jsp" %>

    <header class="sg-header">
        <nav class="sg-breadcrumbs">
            <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
            <a href="<%=request.getContextPath()%>/ctf/index.jsp">CTF Generators</a> /
            Steganography CTF
        </nav>
        <h1>Steganography <span>CTF</span> Generator</h1>
        <p>Generate steganography challenges with 34 encoding steps across 7 difficulty levels. Outputs a downloadable file, full JSON solution, and progressive hints for solvers.</p>
    </header>

    <div class="sg-leaderboard-ad"><%@ include file="../modern/ads/ad-leaderboard.jsp" %></div>

    <div class="sg-desc-ad">
        <div><p style="color:var(--ctf-text-dim);font-size:0.875rem;line-height:1.7">Enter a flag, pick a difficulty, and hit Generate. The engine selects a random pipeline of transforms (ciphers, encodings, container wrapping) and embeds the result into an image or audio file. The solution tab shows the full pipeline so you can verify or share it.</p></div>
        <div><%@ include file="../modern/ads/ad-in-content-top.jsp" %></div>
    </div>

    <main class="sg-main">
        <!-- INPUT COLUMN -->
        <div>
            <div class="sg-card">
                <div class="sg-card-header">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
                    Configure Challenge
                </div>
                <div class="sg-card-body">
                    <div class="sg-form-group">
                        <label class="sg-label">Flag Message</label>
                        <input type="text" class="sg-input" id="flagInput" value="flag{hidden_in_plain_sight}" placeholder="flag{your_secret_here}">
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Difficulty</label>
                        <select class="sg-select" id="difficultySelect">
                            <option value="easy">Easy &mdash; plain LSB embed</option>
                            <option value="medium" selected>Medium &mdash; single encoding + embed</option>
                            <option value="hard">Hard &mdash; multi-step ciphers + containers</option>
                            <option value="pro">Pro &mdash; encryption + compression + layers</option>
                            <option value="forensic">Forensic &mdash; file-format tricks</option>
                            <option value="easy_audio">Easy Audio &mdash; WAV LSB embed</option>
                            <option value="medium_audio">Medium Audio &mdash; encoding + audio embed</option>
                            <option value="spectrogram">Spectrogram &mdash; frequency encoding</option>
                        </select>
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Cover Image <span class="sg-label-hint">(optional — auto-generated if empty)</span></label>
                        <input type="file" id="coverFileInput" accept="image/png,image/jpeg,image/bmp,image/webp,audio/wav,audio/wave,.wav" style="display:none">
                        <div class="sg-upload-zone" id="coverUploadZone">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="opacity:0.5"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                            <span class="sg-upload-label">Upload image or WAV</span>
                            <span class="sg-upload-hint-text">Or drag and drop here</span>
                        </div>
                        <div class="sg-cover-preview" id="coverPreview" style="display:none">
                            <div class="sg-cover-preview-inner">
                                <img id="coverPreviewImg" alt="Cover preview">
                                <div class="sg-cover-info" id="coverInfo"></div>
                            </div>
                            <button type="button" class="sg-btn sg-btn-secondary sg-btn-sm" onclick="clearCover()" style="margin-top:0.5rem">
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                Remove
                            </button>
                        </div>
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Password <span class="sg-label-hint">(for encrypted pipelines)</span></label>
                        <input type="text" class="sg-input" id="passwordInput" placeholder="Optional — used by encrypt/xor steps">
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Seed <span class="sg-label-hint">(for reproducible output)</span></label>
                        <input type="number" class="sg-input" id="seedInput" placeholder="Optional — leave blank for random">
                    </div>

                    <div class="sg-form-group">
                        <label class="sg-label">Hint Count</label>
                        <select class="sg-select" id="hintCountSelect">
                            <option value="3">3 hints</option>
                            <option value="5" selected>5 hints</option>
                            <option value="7">7 hints</option>
                        </select>
                    </div>

                    <button class="sg-btn sg-btn-primary" id="generateBtn" onclick="generateChallenge()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10"/></svg>
                        Generate Challenge
                    </button>
                    <div class="sg-cooldown-bar" id="cooldownBar"></div>
                    <div id="statusMsg" style="margin-top:0.75rem;font-size:0.8125rem;font-family:var(--ctf-font-mono);min-height:1.25rem"></div>
                </div>
            </div>
        </div>

        <!-- OUTPUT COLUMN -->
        <div>
            <div class="sg-card sg-output">
                <div class="sg-output-tabs">
                    <button class="sg-output-tab active" onclick="switchTab('challenge',this)">Challenge</button>
                    <button class="sg-output-tab" onclick="switchTab('solution',this)">Solution</button>
                    <button class="sg-output-tab" onclick="switchTab('hints',this)">Hints</button>
                    <button class="sg-output-tab" onclick="switchTab('json',this)">Full JSON</button>
                </div>

                <div class="sg-tab-content active" id="tab-challenge">
                    <div class="sg-empty" id="challengeEmpty">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg>
                        <h3>No challenge yet</h3>
                        <p>Configure your settings and click Generate.</p>
                    </div>
                    <div id="challengeResult" style="display:none">
                        <div style="margin-bottom:1rem">
                            <span class="sg-label">Pipeline</span>
                            <div class="sg-pipeline-viz" id="pipelineViz"></div>
                        </div>
                        <div id="challengePreview" style="margin-bottom:1rem"></div>
                        <div class="sg-actions">
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="downloadChallenge()">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                Download File
                            </button>
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="downloadJSON()">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                Download JSON
                            </button>
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="copyJSON()">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                                Copy JSON
                            </button>
                        </div>
                    </div>
                </div>

                <div class="sg-tab-content" id="tab-solution">
                    <div class="sg-empty" id="solutionEmpty">
                        <h3>Solution will appear here</h3>
                        <p>Generate a challenge first.</p>
                    </div>
                    <div class="sg-gate" id="solutionGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
                        <h3>Solution is ready</h3>
                        <p>Reveal the complete flag, pipeline, and decryption keys.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('solution',3000)">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            Reveal Solution
                        </button>
                    </div>
                    <div class="sg-gate-spinner" id="solutionSpinner">
                        <span class="sg-spinner"></span>
                        <p>Decrypting solution...</p>
                    </div>
                    <div id="solutionResult" style="display:none"></div>
                </div>

                <div class="sg-tab-content" id="tab-hints">
                    <div class="sg-empty" id="hintsEmpty">
                        <h3>Hints will appear here</h3>
                        <p>Generate a challenge to see progressive hints.</p>
                    </div>
                    <div class="sg-gate" id="hintsGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></div>
                        <h3>Hints are ready</h3>
                        <p>Progressive hints to guide solvers toward the flag.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('hints',2000)">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/></svg>
                            Reveal Hints
                        </button>
                    </div>
                    <div class="sg-gate-spinner" id="hintsSpinner">
                        <span class="sg-spinner"></span>
                        <p>Loading hints...</p>
                    </div>
                    <ul class="sg-hints-list" id="hintsList" style="display:none"></ul>
                </div>

                <div class="sg-tab-content" id="tab-json">
                    <div class="sg-empty" id="jsonEmpty">
                        <h3>Raw JSON will appear here</h3>
                        <p>Complete challenge bundle in JSON format.</p>
                    </div>
                    <div class="sg-gate" id="jsonGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
                        <h3>Full JSON bundle is ready</h3>
                        <p>Complete challenge bundle with solution, hints, and file data.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('json',2500)">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                            Reveal Full JSON
                        </button>
                    </div>
                    <div class="sg-gate-spinner" id="jsonSpinner">
                        <span class="sg-spinner"></span>
                        <p>Serializing challenge data...</p>
                    </div>
                    <pre class="sg-json-pre" id="jsonPre" style="display:none"></pre>
                </div>
            </div>
        </div>

        <!-- ADS COLUMN -->
        <div class="sg-ads-col">
            <%@ include file="../modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <div class="sg-mobile-ad" style="max-width:1200px;margin:0 auto;padding:0 1.5rem">
        <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <div class="sg-mid-ad"><%@ include file="../modern/ads/ad-hero-banner.jsp" %></div>

    <jsp:include page="../modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="ctf/stego-ctf-generator.jsp"/>
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

    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>

    <script src="<%=request.getContextPath()%>/js/stego-engine.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/stego-rs.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/stego-imagegen.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/stego-audiogen.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/stego-audio.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/ctf/js/ctf-steps.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/ctf/js/ctf-engine.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <script>
    var currentBundle = null;
    var generateCooldownUntil = 0;
    var GENERATE_DELAY_MS = 4000;
    var COOLDOWN_MS = 10000;
    var revealedSections = {};
    var userCover = null;
    var userCoverType = null;

    (function initCoverUpload() {
        var zone = document.getElementById('coverUploadZone');
        var fileInput = document.getElementById('coverFileInput');
        if (!zone || !fileInput) return;

        zone.addEventListener('click', function() { fileInput.click(); });
        fileInput.addEventListener('change', function() { if (fileInput.files.length) handleCoverFile(fileInput.files[0]); });

        zone.addEventListener('dragover', function(e) { e.preventDefault(); zone.classList.add('dragover'); });
        zone.addEventListener('dragleave', function() { zone.classList.remove('dragover'); });
        zone.addEventListener('drop', function(e) {
            e.preventDefault();
            zone.classList.remove('dragover');
            if (e.dataTransfer.files.length) handleCoverFile(e.dataTransfer.files[0]);
        });
    })();

    function handleCoverFile(file) {
        if (!file) return;
        var isAudio = /^audio\/|\.wav$/i.test(file.type || file.name);
        var isImage = /^image\//i.test(file.type);
        if (!isImage && !isAudio) {
            setStatus('Cover must be an image (PNG/JPEG/BMP/WebP) or WAV audio.', 'var(--ctf-red)');
            return;
        }

        var reader = new FileReader();
        if (isAudio) {
            reader.onload = function() {
                userCover = reader.result;
                userCoverType = 'audio';
                showCoverPreview(file.name, file.size, 'audio');
            };
            reader.readAsArrayBuffer(file);
        } else {
            reader.onload = function() {
                var img = new Image();
                img.onload = function() {
                    var canvas = document.createElement('canvas');
                    canvas.width = img.naturalWidth;
                    canvas.height = img.naturalHeight;
                    var ctx = canvas.getContext('2d');
                    ctx.drawImage(img, 0, 0);
                    userCover = ctx.getImageData(0, 0, canvas.width, canvas.height);
                    userCoverType = 'image';
                    showCoverPreview(file.name, file.size, 'image', img.src, img.naturalWidth + 'x' + img.naturalHeight);
                };
                img.src = reader.result;
            };
            reader.readAsDataURL(file);
        }
    }

    function showCoverPreview(name, size, type, thumbSrc, dims) {
        var zone = document.getElementById('coverUploadZone');
        var preview = document.getElementById('coverPreview');
        var previewImg = document.getElementById('coverPreviewImg');
        var infoEl = document.getElementById('coverInfo');
        zone.style.display = 'none';
        preview.style.display = 'block';
        if (type === 'image' && thumbSrc) {
            previewImg.src = thumbSrc;
            previewImg.style.display = 'block';
        } else {
            previewImg.style.display = 'none';
        }
        var sizeStr = size > 1024 * 1024 ? (size / 1024 / 1024).toFixed(1) + ' MB' : (size / 1024).toFixed(1) + ' KB';
        infoEl.innerHTML = escHtml(name) + '<br>' + sizeStr + (dims ? ' &middot; ' + dims : '') + '<br>' + (type === 'audio' ? 'WAV audio cover' : 'Image cover');
    }

    function clearCover() {
        userCover = null;
        userCoverType = null;
        document.getElementById('coverUploadZone').style.display = 'flex';
        document.getElementById('coverPreview').style.display = 'none';
        document.getElementById('coverFileInput').value = '';
    }

    var GENERATE_PHASES = [
        'Selecting pipeline...',
        'Applying transforms...',
        'Encoding payload...',
        'Embedding into cover...',
        'Generating hints...',
        'Computing flag hash...',
        'Packaging challenge...'
    ];

    function switchTab(id, btn) {
        var tabs = document.querySelectorAll('.sg-output-tab');
        var panes = document.querySelectorAll('.sg-tab-content');
        for (var i = 0; i < tabs.length; i++) tabs[i].classList.remove('active');
        for (var i = 0; i < panes.length; i++) panes[i].classList.remove('active');
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

    function generateChallenge() {
        var now = Date.now();
        var remaining = generateCooldownUntil - now;
        if (remaining > 0) {
            setStatus('Please wait ' + Math.ceil(remaining / 1000) + 's before generating again.', 'var(--ctf-purple)');
            return;
        }

        var flag = document.getElementById('flagInput').value.trim();
        if (!flag) { setStatus('Enter a flag message.', 'var(--ctf-red)'); return; }
        var difficulty = document.getElementById('difficultySelect').value;
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
            if (phaseIdx < GENERATE_PHASES.length) {
                setStatus(GENERATE_PHASES[phaseIdx], 'var(--ctf-cyan)', true);
            }
        }, GENERATE_DELAY_MS / GENERATE_PHASES.length);

        var opts = { hintCount: hintCount };
        if (password) opts.password = password;
        if (seed != null && !isNaN(seed)) opts.seed = seed;

        var cover = userCover || null;

        var startTime = Date.now();

        CTFEngine.generateChallenge(flag, difficulty, cover, opts).then(function(bundle) {
            var elapsed = Date.now() - startTime;
            var waitMore = Math.max(0, GENERATE_DELAY_MS - elapsed);

            return new Promise(function(resolve) {
                setTimeout(function() { resolve(bundle); }, waitMore);
            });
        }).then(function(bundle) {
            clearInterval(phaseInterval);
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
            result.style.display = section === 'hints' ? 'block' : 'block';
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

        var vizEl = document.getElementById('pipelineViz');
        vizEl.innerHTML = '';
        var pipeline = bundle.solution.pipeline;
        var TERMINALS = ['embed','appendEof','embedSpectrogram','embedOverlay','embedPngText','snow','scatterEmbed'];
        for (var i = 0; i < pipeline.length; i++) {
            if (i > 0) { var arrow = document.createElement('span'); arrow.className = 'sg-pipe-arrow'; arrow.textContent = '\u2192'; vizEl.appendChild(arrow); }
            var step = document.createElement('span');
            step.className = 'sg-pipe-step';
            if (TERMINALS.indexOf(pipeline[i].id) >= 0) step.className += ' terminal';
            step.textContent = pipeline[i].id;
            vizEl.appendChild(step);
        }

        var previewEl = document.getElementById('challengePreview');
        previewEl.innerHTML = '';
        if (bundle.challenge.format === 'image' && bundle.challenge.data) {
            var img = document.createElement('img');
            img.src = 'data:' + (bundle.challenge.mimeType || 'image/png') + ';base64,' + bundle.challenge.data;
            img.className = 'sg-preview-img';
            img.alt = 'Stego challenge image';
            previewEl.appendChild(img);
        } else if (bundle.challenge.format === 'audio' && bundle.challenge.data) {
            var audio = document.createElement('audio');
            audio.controls = true;
            audio.style.width = '100%';
            audio.src = 'data:' + (bundle.challenge.mimeType || 'audio/wav') + ';base64,' + bundle.challenge.data;
            previewEl.appendChild(audio);
        } else {
            var note = document.createElement('p');
            note.style.cssText = 'color:var(--ctf-text-dim);font-size:0.875rem';
            note.textContent = 'Challenge file ready (' + (bundle.challenge.format || 'file') + '). Click Download.';
            previewEl.appendChild(note);
        }

        var solEl = document.getElementById('solutionResult');
        solEl.innerHTML = '<div class="sg-form-group"><span class="sg-label">Flag</span><pre class="sg-json-pre" style="max-height:none;color:var(--ctf-cyan)">' + escHtml(bundle.solution.flag) + '</pre></div>' +
            '<div class="sg-form-group"><span class="sg-label">SHA-256 Hash</span><pre class="sg-json-pre" style="max-height:none;font-size:0.6875rem;word-break:break-all">' + escHtml(bundle.solution.hash) + '</pre></div>' +
            (bundle.solution.keys ? '<div class="sg-form-group"><span class="sg-label">Keys</span><pre class="sg-json-pre" style="max-height:none">' + escHtml(JSON.stringify(bundle.solution.keys, null, 2)) + '</pre></div>' : '') +
            '<div class="sg-form-group"><span class="sg-label">Pipeline</span><pre class="sg-json-pre">' + escHtml(JSON.stringify(bundle.solution.pipeline, null, 2)) + '</pre></div>';

        var hintsEl = document.getElementById('hintsList');
        hintsEl.innerHTML = '';
        for (var i = 0; i < bundle.hints.length; i++) {
            var li = document.createElement('li');
            li.className = 'sg-hint-toggle';
            li.setAttribute('data-hint-idx', i);
            li.innerHTML = '<span class="sg-hint-label">Hint ' + (i + 1) + '</span> <span style="color:var(--ctf-text-dim);font-size:0.75rem">(click to reveal)</span>' +
                '<div class="sg-hint-loading"><span class="sg-spinner"></span> Decoding hint...</div>' +
                '<div class="sg-hint-text">' + escHtml(bundle.hints[i]) + '</div>';
            li.onclick = (function(el) {
                return function() {
                    if (el.classList.contains('open') || el.classList.contains('loading')) return;
                    el.classList.add('loading');
                    setTimeout(function() {
                        el.classList.remove('loading');
                        el.classList.add('open');
                    }, 1200);
                };
            })(li);
            hintsEl.appendChild(li);
        }

        var jsonSafe = JSON.parse(JSON.stringify(bundle));
        if (jsonSafe.challenge && jsonSafe.challenge.data && jsonSafe.challenge.data.length > 200) {
            jsonSafe.challenge.data = jsonSafe.challenge.data.substring(0, 200) + '... [truncated, ' + bundle.challenge.data.length + ' chars]';
        }
        document.getElementById('jsonPre').textContent = JSON.stringify(jsonSafe, null, 2);
    }

    function escHtml(s) { return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

    function downloadChallenge() {
        if (!currentBundle || !currentBundle.challenge.data) return;
        var btn = this || event.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        setStatus('Preparing download...', 'var(--ctf-cyan)', true);
        setTimeout(function() {
            var bytes = atob(currentBundle.challenge.data);
            var arr = new Uint8Array(bytes.length);
            for (var i = 0; i < bytes.length; i++) arr[i] = bytes.charCodeAt(i);
            var blob = new Blob([arr], { type: currentBundle.challenge.mimeType || 'application/octet-stream' });
            var a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = currentBundle.challenge.filename || 'challenge.bin';
            a.click();
            URL.revokeObjectURL(a.href);
            setStatus('Download started.', 'var(--ctf-green)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1500);
    }

    function downloadJSON() {
        if (!currentBundle) return;
        var btn = this || event.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        setStatus('Preparing JSON...', 'var(--ctf-cyan)', true);
        setTimeout(function() {
            var blob = new Blob([JSON.stringify(currentBundle, null, 2)], { type: 'application/json' });
            var a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = 'challenge-bundle.json';
            a.click();
            URL.revokeObjectURL(a.href);
            setStatus('JSON download started.', 'var(--ctf-green)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1500);
    }

    function copyJSON() {
        if (!currentBundle) return;
        setStatus('Copying...', 'var(--ctf-cyan)', true);
        setTimeout(function() {
            var text = JSON.stringify(currentBundle, null, 2);
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(text).then(function() { setStatus('JSON copied to clipboard!', 'var(--ctf-green)'); });
            } else {
                var ta = document.createElement('textarea');
                ta.value = text;
                document.body.appendChild(ta);
                ta.select();
                document.execCommand('copy');
                document.body.removeChild(ta);
                setStatus('JSON copied to clipboard!', 'var(--ctf-green)');
            }
        }, 1000);
    }
    </script>
</body>
</html>
