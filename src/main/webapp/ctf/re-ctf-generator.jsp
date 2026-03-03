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
        <jsp:param name="toolName" value="Free Reverse Engineering CTF Generator - Obfuscated Code, Logic Gates, Binary Puzzles" />
        <jsp:param name="toolDescription" value="Generate RE CTF challenges: obfuscated JS, logic gates, state machines, XOR chains, hex dumps, struct parsing. 11 types. Native ELF binaries via Docker. 100% client-side." />
        <jsp:param name="toolCategory" value="CTF & Challenges" />
        <jsp:param name="toolUrl" value="ctf/re-ctf-generator.jsp" />
        <jsp:param name="toolKeywords" value="reverse engineering CTF, obfuscated code CTF, logic gate puzzle, binary puzzle CTF, XOR cipher CTF, hex dump CTF, struct parsing, state machine CTF, ELF strings, capture the flag reverse engineering" />
        <jsp:param name="toolImage" value="images/crypto-ctf-icon.svg" />
        <jsp:param name="toolFeatures" value="11 RE challenge types,Obfuscated JS: string encoding control flow,Logic gates: truth table output bits,State machine FSM,XOR bitwise chain,Hex dump carve struct parse endian swap,Native ELF static assets from Docker,100% client-side for dynamic types,SHA-256 flag verification" />
        <jsp:param name="breadcrumbCategoryUrl" value="ctf/index.jsp" />
    </jsp:include>

    <style>:root{--ctf-purple:#8b5cf6;--ctf-purple-dim:#7c3aed;--ctf-bg:var(--bg-primary,#fff);--ctf-surface:var(--bg-secondary,#f8fafc);--ctf-border:var(--border,#e2e8f0);--ctf-text:var(--text-primary,#0f172a);--ctf-text-dim:var(--text-secondary,#475569);--ctf-font-mono:'JetBrains Mono',monospace;--tool-primary:#8b5cf6}[data-theme="dark"]{--ctf-purple:#a78bfa}</style>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <%@ include file="../modern/ads/ad-init.jsp" %>
    <style>
        .sg-card{background:var(--ctf-surface);border:1px solid var(--ctf-border);border-radius:0.75rem;overflow:hidden}
        .sg-form-group{margin-bottom:1.25rem}
        .sg-label{display:block;font-size:0.8125rem;font-weight:600;color:var(--ctf-text);margin-bottom:0.375rem}
        .sg-input,.sg-select{width:100%;padding:0.625rem 0.875rem;background:var(--bg-tertiary,#f1f5f9);border:1px solid var(--ctf-border);border-radius:0.5rem;font-size:0.875rem;font-family:inherit}
        .sg-btn{display:inline-flex;align-items:center;justify-content:center;gap:0.5rem;padding:0.75rem 1.5rem;border:none;border-radius:0.5rem;font-size:0.875rem;font-weight:600;cursor:pointer;font-family:inherit;width:100%}
        .sg-btn-primary{background:linear-gradient(135deg,#7c3aed,#8b5cf6);color:#fff}
        .sg-btn-primary:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(139,92,246,0.3)}
        .sg-btn-primary:disabled{opacity:0.5;cursor:not-allowed;transform:none}
        .sg-btn-secondary{background:var(--ctf-surface);color:var(--ctf-text);border:1px solid var(--ctf-border);width:auto}
        .sg-btn-secondary:hover{border-color:var(--ctf-purple);color:var(--ctf-purple)}
        .sg-btn-sm{padding:0.5rem 1rem;font-size:0.8125rem}
        .sg-actions{display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.75rem}
        .sg-output-tabs{display:flex;border-bottom:1px solid var(--ctf-border);overflow-x:auto}
        .sg-output-tab{padding:0.75rem 1rem;font-size:0.8125rem;font-weight:500;color:var(--ctf-text-dim);background:none;border:none;cursor:pointer;border-bottom:2px solid transparent}
        .sg-output-tab.active{color:var(--ctf-purple);border-bottom-color:var(--ctf-purple)}
        .sg-tab-content{display:none;padding:1.25rem}.sg-tab-content.active{display:block}
        .sg-empty{text-align:center;padding:3rem 1rem;color:var(--ctf-text-dim)}
        .sg-json-pre,.sg-code-block{background:var(--ctf-bg);border:1px solid var(--ctf-border);border-radius:0.5rem;padding:1rem;font-family:var(--ctf-font-mono);font-size:0.75rem;overflow:auto;max-height:400px;white-space:pre-wrap;word-break:break-all;color:var(--ctf-purple)}
        .sg-hints-list{list-style:none;padding:0}
        .sg-hints-list li{padding:0.75rem;margin-bottom:0.5rem;background:var(--ctf-surface);border:1px solid var(--ctf-border);border-radius:0.5rem;font-size:0.8125rem}
        .sg-cooldown-bar{height:3px;background:var(--ctf-purple);border-radius:2px;margin-top:0.5rem;transition:width linear;width:0}
        .sg-gate,.sg-gate-spinner{text-align:center;padding:2.5rem 1.5rem}
        .sg-gate-spinner{display:none;flex-direction:column;align-items:center;gap:0.75rem}
        .sg-gate-spinner.active{display:flex}
        .sg-spinner{display:inline-block;width:16px;height:16px;border:2px solid rgba(255,255,255,0.2);border-top-color:var(--ctf-purple);border-radius:50%;animation:sg-spin 0.6s linear infinite}
        @keyframes sg-spin{to{transform:rotate(360deg)}}
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Reverse Engineering <span style="color:var(--ctf-purple)">CTF</span> Generator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/ctf/index.jsp">CTF Generators</a> /
                    Reverse Engineering CTF
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">11 Types</span>
                <span class="tool-badge">Client-Side</span>
                <span class="tool-badge">ELF Assets</span>
            </div>
        </div>
    </header>
    <div class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Generate RE CTF challenges: obfuscated code, logic gates, state machines, XOR chains, hex dumps, struct parsing. Native ELF binaries are built via Docker as static assets.</p>
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
                        <label class="sg-label">Flag Message</label>
                        <input type="text" class="sg-input" id="flagInput" value="flag{re_master}" placeholder="flag{your_secret}">
                    </div>
                    <div class="sg-form-group">
                        <label class="sg-label">Challenge Type</label>
                        <select class="sg-select" id="typeSelect">
                            <option value="_random" selected>Random (dynamic only)</option>
                            <optgroup label="Obfuscated Code">
                                <option value="obfuscatedString">obfuscatedString</option>
                                <option value="obfuscatedControlFlow">obfuscatedControlFlow</option>
                            </optgroup>
                            <optgroup label="Logic Gates">
                                <option value="logicGateOutput">logicGateOutput</option>
                                <option value="logicGateTruthTable">logicGateTruthTable</option>
                            </optgroup>
                            <optgroup label="Encoded Algorithms">
                                <option value="stateMachineFlag">stateMachineFlag</option>
                                <option value="bitwiseXorChain">bitwiseXorChain</option>
                            </optgroup>
                            <optgroup label="Binary Puzzles">
                                <option value="hexDumpCarve">hexDumpCarve</option>
                                <option value="structLayoutParse">structLayoutParse</option>
                                <option value="endianSwap">endianSwap</option>
                            </optgroup>
                            <optgroup label="Native ELF (static)">
                                <option value="nativeElfStrings">nativeElfStrings</option>
                                <option value="nativeElfSymbols">nativeElfSymbols</option>
                            </optgroup>
                        </select>
                    </div>
                    <div class="sg-form-group">
                        <label class="sg-label">Seed</label>
                        <input type="number" class="sg-input" id="seedInput" placeholder="Optional">
                    </div>
                    <div class="sg-form-group">
                        <label class="sg-label">Hint Count</label>
                        <select class="sg-select" id="hintCountSelect">
                            <option value="3">3</option>
                            <option value="5" selected>5</option>
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
                    <div class="sg-empty" id="challengeEmpty"><h3>No challenge yet</h3><p>Choose a type and click Generate.</p></div>
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
                    <div class="sg-empty" id="solutionEmpty"><h3>Solution will appear here</h3></div>
                    <div class="sg-gate" id="solutionGate" style="display:none">
                        <h3>Solution is ready</h3>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('solution',2500)">Reveal Solution</button>
                    </div>
                    <div class="sg-gate-spinner" id="solutionSpinner"><span class="sg-spinner"></span><p>Loading...</p></div>
                    <div id="solutionResult" style="display:none"></div>
                </div>
                <div class="sg-tab-content" id="tab-hints">
                    <div class="sg-empty" id="hintsEmpty"><h3>Hints</h3></div>
                    <ul class="sg-hints-list" id="hintsList" style="display:none"></ul>
                </div>
                <div class="sg-tab-content" id="tab-json">
                    <div class="sg-empty" id="jsonEmpty"><h3>Raw JSON</h3></div>
                    <div class="sg-gate" id="jsonGate" style="display:none">
                        <h3>Full JSON ready</h3>
                        <button class="sg-btn sg-btn-secondary sg-btn-sm" onclick="revealSection('json',2000)">Reveal</button>
                    </div>
                    <div class="sg-gate-spinner" id="jsonSpinner"><span class="sg-spinner"></span></div>
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
    <script src="<%=request.getContextPath()%>/ctf/js/ctf-re-engine.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script>
    var currentBundle = null;
    var ctxPath = document.querySelector('meta[name="context-path"]') && document.querySelector('meta[name="context-path"]').content || '';
    var generateCooldownUntil = 0;
    var GENERATE_DELAY_MS = 3500;
    var COOLDOWN_MS = 8000;
    var revealedSections = {};

    var GENERATE_PHASES = ['Selecting type...', 'Building challenge...', 'Encoding...', 'Generating hints...', 'Hashing flag...', 'Packaging...'];

    function setStatus(msg, color, showSpinner) {
        var el = document.getElementById('statusMsg');
        if (!el) return;
        if (showSpinner) el.innerHTML = '<span class="sg-spinner" style="margin-right:0.5rem"></span>' + escHtml(msg);
        else el.textContent = msg;
        el.style.color = color || 'var(--ctf-purple)';
    }
    function escHtml(s) { return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

    function switchTab(id, btn) {
        document.querySelectorAll('.sg-output-tab').forEach(function(t){ t.classList.remove('active'); });
        document.querySelectorAll('.sg-tab-content').forEach(function(t){ t.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        var p = document.getElementById('tab-' + id);
        if (p) p.classList.add('active');
    }

    function startCooldown() {
        generateCooldownUntil = Date.now() + COOLDOWN_MS;
        var bar = document.getElementById('cooldownBar');
        if (bar) { bar.style.width = '100%'; bar.style.transitionDuration = '0s'; bar.offsetHeight; bar.style.transitionDuration = (COOLDOWN_MS/1000) + 's'; bar.style.width = '0'; }
    }

    function revealSection(section, delayMs) {
        if (revealedSections[section]) return;
        var gate = document.getElementById(section + 'Gate');
        var spinner = document.getElementById(section + 'Spinner');
        var result = document.getElementById(section === 'json' ? 'jsonPre' : (section + (section === 'hints' ? 'List' : 'Result')));
        if (!gate || !result) return;
        if (spinner) { gate.style.display = 'none'; spinner.classList.add('active'); }
        setTimeout(function() {
            if (spinner) spinner.classList.remove('active');
            result.style.display = 'block';
            revealedSections[section] = true;
        }, delayMs);
    }

    function doGenerate() {
        var remaining = generateCooldownUntil - Date.now();
        if (remaining > 0) { setStatus('Wait ' + Math.ceil(remaining/1000) + 's', 'var(--ctf-text-dim)'); return; }
        var flag = document.getElementById('flagInput').value.trim();
        var typeVal = document.getElementById('typeSelect').value;
        var seed = document.getElementById('seedInput').value.trim();
        var seedNum = seed ? parseInt(seed, 10) : undefined;
        var hintCount = parseInt(document.getElementById('hintCountSelect').value, 10);
        var type = typeVal === '_random' ? undefined : typeVal;
        var Engine = window.CTFREEngine;
        if (!Engine || !Engine.generate) { setStatus('Engine not loaded.', 'red'); return; }
        var btn = document.getElementById('generateBtn');
        btn.disabled = true;
        revealedSections = {};
        var phaseIdx = 0;
        setStatus(GENERATE_PHASES[0], 'var(--ctf-purple)', true);
        var phaseInterval = setInterval(function() {
            phaseIdx++;
            if (phaseIdx < GENERATE_PHASES.length) setStatus(GENERATE_PHASES[phaseIdx], 'var(--ctf-purple)', true);
        }, GENERATE_DELAY_MS / GENERATE_PHASES.length);
        var prom = type ? Engine.generate(type, flag, { seed: seedNum, hintCount: hintCount }) : Engine.generateRandom(flag, { seed: seedNum, hintCount: hintCount });
        var start = Date.now();
        prom.then(function(b) {
            return new Promise(function(r) { setTimeout(function() { r(b); }, Math.max(0, GENERATE_DELAY_MS - (Date.now() - start))); });
        }).then(function(bundle) {
            clearInterval(phaseInterval);
            bundle.note = 'Generated by 8gwifi.org RE CTF Generator';
            currentBundle = bundle;
            renderChallenge(bundle);
            setStatus('Challenge generated.', 'var(--ctf-purple)');
            btn.disabled = false;
            startCooldown();
        }).catch(function(e) {
            clearInterval(phaseInterval);
            setStatus('Error: ' + (e && e.message), 'red');
            btn.disabled = false;
        });
    }

    function renderChallenge(bundle) {
        document.getElementById('challengeEmpty').style.display = 'none';
        document.getElementById('challengeResult').style.display = 'block';
        document.getElementById('solutionEmpty').style.display = 'none';
        document.getElementById('solutionGate').style.display = 'block';
        var solSp = document.getElementById('solutionSpinner');
        if (solSp) solSp.classList.remove('active');
        document.getElementById('solutionResult').style.display = 'none';
        document.getElementById('hintsEmpty').style.display = 'none';
        document.getElementById('hintsList').style.display = 'none';
        document.getElementById('hintsList').innerHTML = '';
        document.getElementById('jsonEmpty').style.display = 'none';
        document.getElementById('jsonGate').style.display = 'block';
        document.getElementById('jsonPre').style.display = 'none';

        var c = bundle.challenge;
        var prev = document.getElementById('challengePreview');
        prev.innerHTML = '';

        if (c.staticAsset && c.assetUrl) {
            var a = document.createElement('a');
            a.href = ctxPath + c.assetUrl;
            a.className = 'sg-btn sg-btn-secondary sg-btn-sm';
            a.download = c.filename || 'challenge.bin';
            a.textContent = 'Download: ' + (c.filename || 'binary');
            a.style.marginBottom = '0.75rem';
            prev.appendChild(a);
            prev.appendChild(document.createElement('br'));
        } else if (c.code) {
            var pre = document.createElement('pre');
            pre.className = 'sg-code-block';
            pre.textContent = c.code;
            prev.appendChild(pre);
        } else if (c.outputBits) {
            var p = document.createElement('p');
            p.style.marginBottom = '0.5rem';
            p.textContent = 'Output bits:';
            prev.appendChild(p);
            var pre = document.createElement('pre');
            pre.className = 'sg-code-block';
            pre.textContent = c.outputBits;
            prev.appendChild(pre);
        } else if (c.encodedHex) {
            var p = document.createElement('p');
            p.textContent = 'Encoded (hex): ' + c.encodedHex;
            p.className = 'sg-code-block';
            prev.appendChild(p);
        } else if (c.table) {
            var p = document.createElement('p');
            p.textContent = 'Truth table (formula: ' + (c.formula || '') + '):';
            prev.appendChild(p);
            var pre = document.createElement('pre');
            pre.className = 'sg-code-block';
            pre.textContent = JSON.stringify(c.table, null, 2);
            prev.appendChild(pre);
        } else if (c.transitions) {
            var p = document.createElement('p');
            p.textContent = 'FSM: start=' + (c.start || 'q0') + ', accept=' + (c.accept || '') + '. Transitions:';
            prev.appendChild(p);
            var pre = document.createElement('pre');
            pre.className = 'sg-code-block';
            pre.textContent = JSON.stringify(c.transitions, null, 2);
            prev.appendChild(pre);
        } else if (c.hexDump) {
            var pre = document.createElement('pre');
            pre.className = 'sg-code-block';
            pre.textContent = c.hexDump;
            pre.style.fontSize = '0.7rem';
            prev.appendChild(pre);
        } else if (c.hex) {
            var p = document.createElement('p');
            p.className = 'sg-code-block';
            p.textContent = 'Hex: ' + c.hex;
            prev.appendChild(p);
        } else if (c.spec) {
            var p = document.createElement('p');
            p.textContent = c.spec;
            p.style.marginBottom = '0.5rem';
            prev.appendChild(p);
        }

        if (c.note) {
            var note = document.createElement('p');
            note.style.cssText = 'color:var(--ctf-purple);font-size:0.8125rem;margin-top:0.75rem;font-style:italic';
            note.textContent = c.note;
            prev.appendChild(note);
        }

        var typeP = document.createElement('p');
        typeP.style.cssText = 'font-size:0.75rem;color:var(--ctf-text-dim);margin-top:0.25rem';
        typeP.textContent = 'Type: ' + bundle.meta.type;
        prev.appendChild(typeP);

        if (c.data && !c.staticAsset) {
            var dl = document.createElement('button');
            dl.className = 'sg-btn sg-btn-secondary sg-btn-sm';
            dl.textContent = 'Download binary';
            dl.onclick = function() { downloadChallenge(); };
            dl.style.marginTop = '0.5rem';
            prev.appendChild(dl);
        }

        var sol = document.getElementById('solutionResult');
        var solHtml = '<div style="margin-bottom:0.75rem"><strong>Flag</strong><pre class="sg-json-pre" style="max-height:none">' + escHtml(bundle.solution.flag) + '</pre></div>';
        solHtml += '<div><strong>SHA-256</strong><pre class="sg-json-pre" style="font-size:0.65rem;word-break:break-all">' + escHtml(bundle.solution.hash || '-') + '</pre></div>';
        if (bundle.solution.xorKey != null) solHtml += '<div><strong>XOR Key</strong> 0x' + bundle.solution.xorKey.toString(16) + '</div>';
        if (bundle.solution.method) solHtml += '<div style="margin-top:0.5rem"><strong>Method</strong><p>' + escHtml(bundle.solution.method) + '</p></div>';
        sol.innerHTML = solHtml;

        bundle.hints.forEach(function(h) {
            var li = document.createElement('li');
            li.textContent = h;
            document.getElementById('hintsList').appendChild(li);
        });

        var jsonSafe = JSON.parse(JSON.stringify(bundle));
        if (jsonSafe.challenge && jsonSafe.challenge.data && jsonSafe.challenge.data.length > 300) jsonSafe.challenge.data = jsonSafe.challenge.data.substring(0, 300) + '...';
        document.getElementById('jsonPre').textContent = JSON.stringify(jsonSafe, null, 2);
    }

    function downloadChallenge(ev) {
        if (!currentBundle) return;
        var btn = ev && ev.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        var c = currentBundle.challenge;
        setStatus('Preparing...', 'var(--ctf-purple)', true);
        setTimeout(function() {
            if (c.staticAsset && c.assetUrl) {
                var a = document.createElement('a');
                a.href = ctxPath + c.assetUrl;
                a.download = c.filename || 'challenge.bin';
                a.click();
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
            } else {
                var text = c.code || c.outputBits || c.encodedHex || JSON.stringify(c.table || c.transitions || c);
                var blob = new Blob([text], { type: 'text/plain' });
                var a = document.createElement('a');
                a.href = URL.createObjectURL(blob);
                a.download = c.filename || 'puzzle.txt';
                a.click();
                URL.revokeObjectURL(a.href);
            }
            setStatus('Download started.', 'var(--ctf-purple)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1200);
    }

    function downloadJSON(ev) {
        if (!currentBundle) return;
        var btn = ev && ev.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        setStatus('Preparing...', 'var(--ctf-purple)', true);
        setTimeout(function() {
            var json = JSON.stringify(currentBundle, null, 2);
            if (window.ToolUtils) ToolUtils.downloadAsFile(json, 're-challenge-bundle.json', { mimeType: 'application/json', toolName: 'RE CTF Generator' });
            else { var a = document.createElement('a'); a.href = 'data:application/json,' + encodeURIComponent(json); a.download = 're-challenge-bundle.json'; a.click(); }
            setStatus('Downloaded.', 'var(--ctf-purple)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 1200);
    }

    function copyJSON(ev) {
        if (!currentBundle) return;
        var btn = ev && ev.currentTarget;
        if (btn && btn.disabled) return;
        if (btn) btn.disabled = true;
        setStatus('Copying...', 'var(--ctf-purple)', true);
        setTimeout(function() {
            var text = JSON.stringify(currentBundle, null, 2);
            if (window.ToolUtils) ToolUtils.copyToClipboard(text, { toastMessage: 'Copied!', toolName: 'RE CTF Generator' });
            else if (navigator.clipboard) navigator.clipboard.writeText(text);
            setStatus('Copied.', 'var(--ctf-purple)');
            if (btn) setTimeout(function() { btn.disabled = false; }, 2000);
        }, 800);
    }
    </script>
    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
