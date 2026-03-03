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
        <jsp:param name="toolName" value="Free Forensic CTF Generator - File Carving, PCAP, Metadata, Static Assets" />
        <jsp:param name="toolDescription" value="Generate forensic CTF challenges: polyglot files, PCAP, EXIF, memory dumps, NTFS, firmware. 25 types including client-side generators and pre-built static assets. Free JSON export." />
        <jsp:param name="toolCategory" value="CTF & Challenges" />
        <jsp:param name="toolUrl" value="ctf/forensic-ctf-generator.jsp" />
        <jsp:param name="toolKeywords" value="forensic CTF generator, file carving CTF, PCAP CTF challenge, metadata CTF, memory dump forensic, NTFS forensic CTF, polyglot file CTF, EXIF CTF, binwalk forensic, Volatility CTF, capture the flag forensics" />
        <jsp:param name="toolImage" value="images/forensic-ctf-icon.svg" />
        <jsp:param name="toolFeatures" value="25 forensic challenge types,Client-side: polyglot PNG+ZIP PCAP HTTP EXIF multi-header blob,Static assets: Volatility NTFS firmware Recycle Bin WPA handshake,File carving: magic bytes wrong extension corrupted PNG,Metadata: PNG tEXt base64 JPEG EXIF,Container tricks: nested TAR/ZIP append EOF,Progressive hints and SHA-256 flag verification,100% client-side for dynamic types - static assets served pre-built" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter your flag|Type the flag solvers must find (ignored for static asset types),Choose type|Select a specific forensic type or Random for variety,Generate|Click Generate - dynamic types create files client-side; static types link to pre-built assets,Download and share|Download the challenge file or follow the link for static assets plus JSON bundle" />
        <jsp:param name="breadcrumbCategoryUrl" value="ctf/index.jsp" />
        <jsp:param name="faq1q" value="What forensic CTF types are available?" />
        <jsp:param name="faq1a" value="25 types: magic byte carve, wrong extension, corrupted PNG magic, PNG/JPEG metadata, strings extract, base64 in metadata, reversed binary, polyglot PNG+ZIP, multi-header blob, PCAP HTTP, PCAP DNS exfil, append EOF ZIP, nested containers, decoy blocks, XOR masked region, hex dump hunt, multi-file carve, hidden dot file, base64-hex chain, ROT13 in binary, plus static assets: Volatility memory dump, NTFS artifacts, firmware, Recycle Bin, WPA handshake." />
        <jsp:param name="faq2q" value="What is the difference between dynamic and static forensic challenges?" />
        <jsp:param name="faq2a" value="Dynamic types (e.g. polyglot, PCAP HTTP, EXIF) are generated 100% client-side in your browser with your custom flag. Static types (memory dump, NTFS, firmware, etc.) use pre-built binary assets served from the server; they have a fixed documented flag for practice. Use static types to learn tools like Volatility, sleuthkit, binwalk, and aircrack-ng." />
        <jsp:param name="faq3q" value="Is this forensic CTF tool free?" />
        <jsp:param name="faq3a" value="Yes, 100% free. Dynamic challenge generation runs entirely in your browser. Static assets are pre-generated and served as downloadable binaries. No signup required." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <style>
        :root{
            --ctf-green:#00cc33;--ctf-green-dim:#059669;--ctf-cyan:#0ea5e9;--ctf-amber:#f59e0b;
            --ctf-bg:var(--bg-primary,#fff);--ctf-surface:var(--bg-secondary,#f8fafc);--ctf-surface-2:var(--bg-tertiary,#f1f5f9);
            --ctf-border:var(--border,#e2e8f0);--ctf-text:var(--text-primary,#0f172a);--ctf-text-dim:var(--text-secondary,#475569);
            --ctf-font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
            --tool-primary:#f59e0b;--tool-light:rgba(245,158,11,0.08);
        }
        [data-theme="dark"]{--ctf-green:#00ff41;--ctf-amber:#fbbf24;--tool-light:rgba(251,191,36,0.12)}
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
        .sg-form-group{margin-bottom:1.25rem}
        .sg-label{display:block;font-size:0.8125rem;font-weight:600;color:var(--ctf-text);margin-bottom:0.375rem}
        .sg-label-hint{font-weight:400;color:var(--ctf-text-dim);font-size:0.75rem}
        .sg-input,.sg-select{width:100%;padding:0.625rem 0.875rem;background:var(--ctf-surface-2);border:1px solid var(--ctf-border);border-radius:0.5rem;color:var(--ctf-text);font-size:0.875rem;font-family:inherit}
        .sg-select{cursor:pointer;appearance:none}
        .sg-btn{display:inline-flex;align-items:center;justify-content:center;gap:0.5rem;padding:0.75rem 1.5rem;border:none;border-radius:0.5rem;font-size:0.875rem;font-weight:600;cursor:pointer;font-family:inherit;width:100%}
        .sg-btn-primary{background:linear-gradient(135deg,#d97706,#f59e0b);color:#fff}
        .sg-btn-primary:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(245,158,11,0.3)}
        .sg-btn-primary:disabled{opacity:0.5;cursor:not-allowed;transform:none}
        .sg-btn-secondary{background:var(--ctf-surface-2);color:var(--ctf-text);border:1px solid var(--ctf-border);width:auto}
        .sg-btn-secondary:hover{border-color:var(--ctf-amber);color:var(--ctf-amber)}
        .sg-btn-sm{padding:0.5rem 1rem;font-size:0.8125rem}
        .sg-actions{display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.75rem}
        .sg-output-tabs{display:flex;border-bottom:1px solid var(--ctf-border);overflow-x:auto}
        .sg-output-tab{padding:0.75rem 1rem;font-size:0.8125rem;font-weight:500;color:var(--ctf-text-dim);background:none;border:none;cursor:pointer;border-bottom:2px solid transparent;white-space:nowrap}
        .sg-output-tab.active{color:var(--ctf-green);border-bottom-color:var(--ctf-green)}
        .sg-tab-content{display:none;padding:1.25rem}.sg-tab-content.active{display:block}
        .sg-empty{text-align:center;padding:3rem 1rem;color:var(--ctf-text-dim)}
        .sg-empty h3{font-size:1rem;color:var(--ctf-text);margin-bottom:0.5rem}
        .sg-json-pre{background:var(--ctf-bg);border:1px solid var(--ctf-border);border-radius:0.5rem;padding:1rem;font-family:var(--ctf-font-mono);font-size:0.75rem;color:var(--ctf-green);overflow:auto;max-height:500px;white-space:pre-wrap;word-break:break-all}
        .sg-hints-list{list-style:none;padding:0}
        .sg-hints-list li{padding:0.75rem;margin-bottom:0.5rem;background:var(--ctf-surface-2);border:1px solid var(--ctf-border);border-radius:0.5rem;font-size:0.8125rem;line-height:1.5}
        .sg-static-badge{background:var(--ctf-amber);color:#1c1917;font-size:0.65rem;padding:0.15rem 0.4rem;border-radius:4px;font-weight:600;margin-left:0.25rem}
        .sg-preview-img{max-width:100%;border-radius:0.5rem;border:1px solid var(--ctf-border)}
        .sg-spinner{display:inline-block;width:16px;height:16px;border:2px solid rgba(255,255,255,0.2);border-top-color:var(--ctf-amber);border-radius:50%;animation:sg-spin 0.6s linear infinite}
        @keyframes sg-spin{to{transform:rotate(360deg)}}
        .sg-gate{text-align:center;padding:2.5rem 1.5rem}
        .sg-gate .sg-btn{width:auto;display:inline-flex}
        .sg-gate-icon{margin-bottom:0.75rem;opacity:0.5}
        .sg-gate h3{font-size:0.9375rem;color:var(--ctf-text);margin-bottom:0.25rem}
        .sg-gate p{font-size:0.8125rem;color:var(--ctf-text-dim);margin-bottom:1rem}
        .sg-cooldown-bar{height:3px;background:var(--ctf-amber);border-radius:2px;margin-top:0.5rem;transition:width linear;width:0}
        .sg-cooldown-bar.active{width:100%}
        .sg-gate-spinner{display:none;flex-direction:column;align-items:center;gap:0.75rem;padding:2.5rem 1.5rem}
        .sg-gate-spinner.active{display:flex}
        .sg-gate-spinner .sg-spinner{width:28px;height:28px;border-width:3px}
        .sg-gate-spinner p{font-size:0.8125rem;color:var(--ctf-text-dim);font-family:var(--ctf-font-mono)}
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Forensic <span style="color:var(--ctf-amber)">CTF</span> Generator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/ctf/index.jsp">CTF Generators</a> /
                    Forensic CTF
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">25 Types</span>
                <span class="tool-badge">Static Assets</span>
                <span class="tool-badge">Client-Side</span>
            </div>
        </div>
    </header>
    <div class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Generate forensic CTF challenges: file carving, polyglot files, PCAP, metadata, and pre-built static assets (memory dumps, NTFS, firmware). Dynamic types embed your flag client-side; static types link to pre-configured binaries for tool practice.</p>
            </div>
            <div class="tool-description-ad">
                <%@ include file="../modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </div>
    <main class="tool-page-container">
        <div class="tool-input-column">
            <div class="sg-card">
                <div class="sg-card-header">Configure Challenge</div>
                <div class="sg-card-body">
                    <div class="sg-form-group">
                        <label class="sg-label">Flag Message <span class="sg-label-hint">(ignored for static asset types)</span></label>
                        <input type="text" class="sg-input" id="flagInput" value="flag{forensic_master}" placeholder="flag{your_secret_here}">
                    </div>
                    <div class="sg-form-group">
                        <label class="sg-label">Challenge Type</label>
                        <select class="sg-select" id="typeSelect">
                            <option value="_random" selected>Random &mdash; pick any type</option>
                            <optgroup label="Beginner (dynamic)">
                                <option value="magicByteCarve">magicByteCarve</option>
                                <option value="wrongExtension">wrongExtension</option>
                                <option value="corruptedPngMagic">corruptedPngMagic</option>
                                <option value="pngMetadataFlag">pngMetadataFlag</option>
                                <option value="stringsExtract">stringsExtract</option>
                                <option value="base64InMetadata">base64InMetadata</option>
                                <option value="reversedBinary">reversedBinary</option>
                                <option value="jpegExif">jpegExif</option>
                                <option value="magicByteCarvePng">magicByteCarvePng</option>
                            </optgroup>
                            <optgroup label="Medium (dynamic)">
                                <option value="truncatedPngHeight">truncatedPngHeight</option>
                                <option value="appendEofZip">appendEofZip</option>
                                <option value="nestedContainers">nestedContainers</option>
                                <option value="decoyBlocks">decoyBlocks</option>
                                <option value="xorMaskedRegion">xorMaskedRegion</option>
                                <option value="hexDumpHunt">hexDumpHunt</option>
                                <option value="multiFileCarve">multiFileCarve</option>
                                <option value="hiddenDotFile">hiddenDotFile</option>
                                <option value="base64HexChain">base64HexChain</option>
                                <option value="rot13InBinary">rot13InBinary</option>
                                <option value="polyglotPngZip">polyglotPngZip</option>
                                <option value="multiHeaderBlob">multiHeaderBlob</option>
                                <option value="pcapHttp">pcapHttp</option>
                            </optgroup>
                            <optgroup label="Hard (dynamic)">
                                <option value="pcapDnsExfil">pcapDnsExfil</option>
                            </optgroup>
                            <optgroup label="Static Assets (pre-built)">
                                <option value="volatilityMemDump">volatilityMemDump</option>
                                <option value="ntfsArtifacts">ntfsArtifacts</option>
                                <option value="firmwareHidden">firmwareHidden</option>
                                <option value="recycleBin">recycleBin</option>
                                <option value="wpaHandshake">wpaHandshake</option>
                            </optgroup>
                        </select>
                    </div>
                    <div class="sg-form-group">
                        <label class="sg-label">Seed <span class="sg-label-hint">(for reproducible random)</span></label>
                        <input type="number" class="sg-input" id="seedInput" placeholder="Optional">
                    </div>
                    <div class="sg-form-group">
                        <label class="sg-label">Hint Count</label>
                        <select class="sg-select" id="hintCountSelect">
                            <option value="3">3</option>
                            <option value="5" selected>5</option>
                            <option value="7">7</option>
                        </select>
                    </div>
                    <button class="sg-btn sg-btn-primary" id="generateBtn" onclick="doGenerate()">Generate Challenge</button>
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
                        <h3>No challenge yet</h3>
                        <p>Choose a type and click Generate.</p>
                    </div>
                    <div id="challengeResult" style="display:none">
                        <div id="challengePreview" style="margin-bottom:1rem"></div>
                        <div class="sg-actions">
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="downloadChallenge(event)">Download File</button>
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="downloadJSON(event)">Download JSON</button>
                            <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="copyJSON(event)">Copy JSON</button>
                        </div>
                    </div>
                </div>
                <div class="sg-tab-content" id="tab-solution">
                    <div class="sg-empty" id="solutionEmpty"><h3>Solution will appear here</h3><p>Generate first.</p></div>
                    <div class="sg-gate" id="solutionGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
                        <h3>Solution is ready</h3>
                        <p>Reveal the complete flag and hash.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('solution',3000)">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            Reveal Solution
                        </button>
                    </div>
                    <div class="sg-gate-spinner" id="solutionSpinner"><span class="sg-spinner"></span><p>Loading solution...</p></div>
                    <div id="solutionResult" style="display:none"></div>
                </div>
                <div class="sg-tab-content" id="tab-hints">
                    <div class="sg-empty" id="hintsEmpty"><h3>Hints will appear here</h3><p>Generate a challenge to see progressive hints.</p></div>
                    <div class="sg-gate" id="hintsGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></div>
                        <h3>Hints are ready</h3>
                        <p>Progressive hints to guide solvers toward the flag.</p>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('hints',2000)">Reveal Hints</button>
                    </div>
                    <div class="sg-gate-spinner" id="hintsSpinner"><span class="sg-spinner"></span><p>Loading hints...</p></div>
                    <ul class="sg-hints-list" id="hintsList" style="display:none"></ul>
                </div>
                <div class="sg-tab-content" id="tab-json">
                    <div class="sg-empty" id="jsonEmpty"><h3>Raw JSON will appear here</h3><p>Complete challenge bundle in JSON format.</p></div>
                    <div class="sg-gate" id="jsonGate" style="display:none">
                        <div class="sg-gate-icon"><svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
                        <h3>Full JSON bundle is ready</h3>
                        <p>Complete challenge bundle with solution, hints, and data.</p>
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
    <%@ include file="../modern/components/support-section.jsp" %>
    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2025 8gwifi.org</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/ctf/index.jsp" class="footer-link">CTF Hub</a>
            </div>
        </div>
    </footer>

    <script src="<%=request.getContextPath()%>/ctf/js/ctf-steps.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/ctf/js/ctf-forensic-engine.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script>
    var currentBundle = null;
    var ctxPath = document.querySelector('meta[name="context-path"]') && document.querySelector('meta[name="context-path"]').content || '';
    var generateCooldownUntil = 0;
    var GENERATE_DELAY_MS = 3500;
    var COOLDOWN_MS = 8000;
    var revealedSections = {};

    var GENERATE_PHASES = [
        'Selecting forensic type...',
        'Building challenge structure...',
        'Encoding payload...',
        'Generating hints...',
        'Computing flag hash...',
        'Packaging challenge...'
    ];

    function setStatus(msg, color, showSpinner) {
        var el = document.getElementById('statusMsg');
        if (!el) return;
        if (showSpinner) {
            el.innerHTML = '<span class="sg-spinner" style="margin-right:0.5rem"></span>' + escHtml(msg);
        } else {
            el.textContent = msg;
        }
        el.style.color = color || 'var(--ctf-green)';
    }
    function escHtml(s) { return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

    function switchTab(id, btn) {
        document.querySelectorAll('.sg-output-tab').forEach(function(t){ t.classList.remove('active'); });
        document.querySelectorAll('.sg-tab-content').forEach(function(t){ t.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var pane = document.getElementById('tab-' + id);
        if (pane) pane.classList.add('active');
    }

    function startCooldown() {
        generateCooldownUntil = Date.now() + COOLDOWN_MS;
        var bar = document.getElementById('cooldownBar');
        if (bar) {
            bar.style.width = '100%';
            bar.style.transitionDuration = '0s';
            bar.offsetHeight;
            bar.style.transitionDuration = (COOLDOWN_MS / 1000) + 's';
            bar.style.width = '0';
        }
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

    function doGenerate() {
        var now = Date.now();
        var remaining = generateCooldownUntil - now;
        if (remaining > 0) {
            setStatus('Please wait ' + Math.ceil(remaining / 1000) + 's before generating again.', 'var(--ctf-purple)');
            return;
        }

        var flag = document.getElementById('flagInput').value.trim();
        var typeVal = document.getElementById('typeSelect').value;
        var seedStr = document.getElementById('seedInput').value.trim();
        var seed = seedStr ? parseInt(seedStr, 10) : undefined;
        var hintCount = parseInt(document.getElementById('hintCountSelect').value, 10);
        var type = typeVal === '_random' ? undefined : typeVal;

        var Engine = window.CTFForensicEngine;
        if (!Engine || !Engine.generate) { setStatus('Forensic engine not loaded.', 'var(--ctf-red)'); return; }

        var btn = document.getElementById('generateBtn');
        btn.disabled = true;
        revealedSections = {};

        var phaseIdx = 0;
        setStatus(GENERATE_PHASES[0], 'var(--ctf-amber)', true);
        var phaseInterval = setInterval(function() {
            phaseIdx++;
            if (phaseIdx < GENERATE_PHASES.length) setStatus(GENERATE_PHASES[phaseIdx], 'var(--ctf-amber)', true);
        }, GENERATE_DELAY_MS / GENERATE_PHASES.length);

        var prom = type ? Engine.generate(type, flag, { seed: seed, hintCount: hintCount }) : Engine.generateRandom(flag, { seed: seed, hintCount: hintCount });
        var startTime = Date.now();

        prom.then(function(bundle) {
            var elapsed = Date.now() - startTime;
            return new Promise(function(resolve) {
                setTimeout(function() { resolve(bundle); }, Math.max(0, GENERATE_DELAY_MS - elapsed));
            });
        }).then(function(bundle) {
            clearInterval(phaseInterval);
            bundle.note = 'Generated by 8gwifi.org Forensic CTF Generator';
            currentBundle = bundle;
            renderChallenge(bundle);
            setStatus('Challenge generated successfully.', 'var(--ctf-green)');
            btn.disabled = false;
            startCooldown();
        }).catch(function(e) {
            clearInterval(phaseInterval);
            setStatus('Error: ' + (e && e.message) || e, 'var(--ctf-red)');
            btn.disabled = false;
        });
    }

    function renderChallenge(bundle) {
        document.getElementById('challengeEmpty').style.display = 'none';
        document.getElementById('challengeResult').style.display = 'block';
        document.getElementById('solutionEmpty').style.display = 'none';
        document.getElementById('solutionGate').style.display = 'block';
        document.getElementById('solutionSpinner').classList.remove('active');
        document.getElementById('solutionResult').style.display = 'none';
        document.getElementById('hintsEmpty').style.display = 'none';
        document.getElementById('hintsGate').style.display = 'block';
        document.getElementById('hintsSpinner').classList.remove('active');
        document.getElementById('hintsList').style.display = 'none';
        document.getElementById('hintsList').innerHTML = '';
        document.getElementById('jsonEmpty').style.display = 'none';
        document.getElementById('jsonGate').style.display = 'block';
        document.getElementById('jsonSpinner').classList.remove('active');
        document.getElementById('jsonPre').style.display = 'none';

        var c = bundle.challenge;
        var prev = document.getElementById('challengePreview');
        prev.innerHTML = '';

        if (c.staticAsset && c.assetUrl) {
            var url = ctxPath + c.assetUrl;
            var a = document.createElement('a');
            a.href = url;
            a.target = '_blank';
            a.download = c.filename || 'challenge.bin';
            a.className = 'sg-btn sg-btn-secondary sg-btn-sm';
            a.style.marginBottom = '0.75rem';
            a.textContent = 'Download static asset: ' + (c.filename || 'challenge.bin');
            prev.appendChild(a);
            prev.appendChild(document.createElement('br'));
        } else if (c.format === 'image' && c.data) {
            var img = document.createElement('img');
            img.src = 'data:' + (c.mimeType || 'image/png') + ';base64,' + c.data;
            img.className = 'sg-preview-img';
            img.alt = 'Challenge preview';
            prev.appendChild(img);
        }
        var note = document.createElement('p');
        note.style.cssText = 'color:var(--ctf-amber);font-size:0.8125rem;margin-top:0.5rem;font-style:italic';
        note.textContent = c.note || '';
        prev.appendChild(note);

        var typeSpan = document.createElement('p');
        typeSpan.style.cssText = 'font-size:0.75rem;color:var(--ctf-text-dim);margin-top:0.25rem';
        typeSpan.textContent = 'Type: ' + bundle.meta.type + (c.staticAsset ? ' (static asset)' : '');
        prev.appendChild(typeSpan);

        var sol = document.getElementById('solutionResult');
        sol.innerHTML = '<div style="margin-bottom:0.75rem"><strong>Flag</strong><pre class="sg-json-pre" style="max-height:none;margin-top:0.25rem">' + escHtml(bundle.solution.flag) + '</pre></div>' +
            '<div style="margin-bottom:0.75rem"><strong>SHA-256</strong><pre class="sg-json-pre" style="max-height:none;font-size:0.6875rem;word-break:break-all">' + escHtml(bundle.solution.hash || '-') + '</pre></div>' +
            (bundle.solution.method ? '<div><strong>Method</strong><p style="font-size:0.8125rem;margin-top:0.25rem">' + escHtml(bundle.solution.method) + '</p></div>' : '');

        for (var i = 0; i < bundle.hints.length; i++) {
            var li = document.createElement('li');
            li.textContent = bundle.hints[i];
            document.getElementById('hintsList').appendChild(li);
        }

        var jsonSafe = JSON.parse(JSON.stringify(bundle));
        if (jsonSafe.challenge && jsonSafe.challenge.data && jsonSafe.challenge.data.length > 300) {
            jsonSafe.challenge.data = jsonSafe.challenge.data.substring(0, 300) + '... [truncated]';
        }
        document.getElementById('jsonPre').textContent = JSON.stringify(jsonSafe, null, 2);
    }

    function downloadChallenge(ev) {
        if (!currentBundle) return;
        var btn = ev && ev.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        var c = currentBundle.challenge;
        setStatus('Preparing download...', 'var(--ctf-amber)', true);
        setTimeout(function() {
            if (c.staticAsset && c.assetUrl) {
                var a = document.createElement('a');
                a.href = ctxPath + c.assetUrl;
                a.download = c.filename || 'challenge.bin';
                a.click();
                setStatus('Download started.', 'var(--ctf-green)');
                if (window.ToolUtils) ToolUtils.showToast('Downloading ' + (c.filename || 'challenge.bin'), 2000, 'success');
            } else if (c.data) {
                var bytes = atob(c.data);
                var arr = new Uint8Array(bytes.length);
                for (var i = 0; i < bytes.length; i++) arr[i] = bytes.charCodeAt(i);
                var blob = new Blob([arr], { type: c.mimeType || 'application/octet-stream' });
                var a = document.createElement('a');
                a.href = URL.createObjectURL(blob);
                a.download = c.filename || 'challenge.bin';
                a.click();
                URL.revokeObjectURL(a.href);
                setStatus('Download started.', 'var(--ctf-green)');
                if (window.ToolUtils) ToolUtils.showToast('Downloaded ' + (c.filename || 'challenge.bin'), 2000, 'success');
            } else {
                setStatus('No file data to download.', 'var(--ctf-red)');
            }
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1500);
    }

    function downloadJSON(ev) {
        if (!currentBundle) return;
        var btn = ev && ev.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        setStatus('Preparing JSON...', 'var(--ctf-amber)', true);
        setTimeout(function() {
            var json = JSON.stringify(currentBundle, null, 2);
            if (window.ToolUtils) {
                ToolUtils.downloadAsFile(json, 'forensic-challenge-bundle.json', { mimeType: 'application/json', toolName: 'Forensic CTF Generator' });
            } else {
                var a = document.createElement('a');
                a.href = 'data:application/json;charset=utf-8,' + encodeURIComponent(json);
                a.download = 'forensic-challenge-bundle.json';
                a.click();
            }
            setStatus('JSON download started.', 'var(--ctf-green)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1500);
    }

    function copyJSON(ev) {
        if (!currentBundle) return;
        var btn = ev && ev.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        setStatus('Copying...', 'var(--ctf-amber)', true);
        setTimeout(function() {
            var text = JSON.stringify(currentBundle, null, 2);
            if (window.ToolUtils) {
                ToolUtils.copyToClipboard(text, { toastMessage: 'JSON copied!', toolName: 'Forensic CTF Generator' });
            } else if (navigator.clipboard) {
                navigator.clipboard.writeText(text);
            }
            setStatus('JSON copied to clipboard!', 'var(--ctf-green)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1000);
    }
    </script>
    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
