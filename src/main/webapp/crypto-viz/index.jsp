<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="How AES, RSA, ECC, TLS &amp; More Work — Crypto Visualizer" />
        <jsp:param name="toolDescription" value="See how cryptography works, step by step — AES, DES, Blowfish, MD5, SHA-256, RSA, Diffie-Hellman, elliptic curve (secp256k1), plus TLS and gRPC. Driven by real reference code and real captured packets — step through every operation and message." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="/crypto-viz/" />
        <jsp:param name="toolKeywords" value="how aes works, how rsa works, how tls works, how sha256 works, aes step by step, rsa encryption explained, diffie-hellman key exchange explained, elliptic curve cryptography, ecc secp256k1, des blowfish md5, sha-256 visualization, tls 1.3 handshake explained, ssl handshake, tls handshake step by step, grpc http2 protocol, block cipher visualizer, hash function visualizer, public key cryptography, encryption algorithm animation, learn cryptography, fips 197" />
        <jsp:param name="toolImage" value="crypto-viz-og.png" />
        <jsp:param name="toolFeatures" value="Step through AES, DES and Blowfish block ciphers,See how SHA-256 and MD5 hashes work round by round,RSA and Diffie-Hellman key exchange, key by key,Elliptic-curve crypto on secp256k1 (Bitcoin/Ethereum),Real TLS 1.0-1.3 handshakes captured message by message,gRPC over HTTP/2 frame by frame,Real reference code and captured packets - nothing faked" />
    </jsp:include>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- LCP optimization: ad-init.jsp is deferred to the bottom of body. Tiny stub here so
         the per-ad lazy-load observer can safely queue googletag.cmd / stpd.que pushes before
         the real GPT script arrives. (No ad slots on the page yet — ready for when they're added.) -->
    <link rel="preconnect" href="https://securepubads.g.doubleclick.net" crossorigin>
    <link rel="preconnect" href="https://stpd.cloud" crossorigin>
    <script>
        window.googletag = window.googletag || { cmd: [] };
        window.stpd = window.stpd || { que: [] };
    </script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg: #181818; --bar: #252526; --bar-2: #2d2d2e; --border: #3c3c3c;
            --text: #cccccc; --text-dim: #8a8a8a; --text-bright: #ffffff;
            --primary: #007acc; --primary-hi: #1f8fd6;
            --hl-xor: #e0a83033; --hl-xor-b: #e0a830;
            --hl-sub: #36a86433; --hl-sub-b: #36a864;
            --hl-permute: #c0568633; --hl-permute-b: #c05686;
            --hl-mix: #4f8cd433; --hl-mix-b: #4f8cd4;
            --hl-load: #8a8a8a33; --hl-emit: #d4694f33; --hl-emit-b: #d4694f;
            --hl-lookup: #e0a83055; --hl-operand: #ffffff22;
        }
        body.light {
            --bg: #ececed; --bar: #f3f3f3; --bar-2: #e7e7e7; --border: #d0d0d0;
            --text: #333333; --text-dim: #777777; --text-bright: #000000;
        }
        html, body { height: 100%; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg); color: var(--text);
            display: flex; flex-direction: column; min-height: 100vh;
        }

        /* ---- top bar ---- */
        .cv-bar {
            flex: 0 0 auto; display: flex; align-items: center; gap: 14px;
            background: var(--bar); border-bottom: 1px solid var(--border); padding: 10px 16px;
        }
        .cv-home img { display: block; }
        .cv-brand { display: flex; align-items: center; gap: 10px; }
        .cv-brand .logo {
            width: 34px; height: 34px; border-radius: 8px; display: grid; place-items: center;
            background: linear-gradient(135deg, var(--primary), var(--primary-hi)); color: #fff; font-size: 16px;
        }
        .cv-brand h1 { font-size: 16px; color: var(--text-bright); font-weight: 600; }
        .cv-brand .sub { font-size: 12px; color: var(--text-dim); }
        .cv-bar .spacer { flex: 1; }
        .cv-btn {
            background: var(--bar-2); color: var(--text); border: 1px solid var(--border);
            border-radius: 6px; padding: 7px 11px; font-size: 13px; cursor: pointer; display: inline-flex; align-items: center; gap: 6px;
        }
        .cv-btn:hover { border-color: var(--primary); color: var(--text-bright); }
        .cv-btn.primary { background: var(--primary); border-color: var(--primary); color: #fff; }
        .cv-btn.primary:hover { background: var(--primary-hi); }
        .cv-btn:disabled { opacity: .5; cursor: default; }

        /* ---- layout ---- */
        .cv-main { flex: 1; display: grid; grid-template-columns: 320px 1fr; gap: 0; min-height: 0; }
        .cv-side { background: var(--bar); border-right: 1px solid var(--border); padding: 16px; overflow: auto; }
        .cv-stage-wrap { padding: 18px 20px; overflow: auto; }
        @media (max-width: 860px) { .cv-main { grid-template-columns: 1fr; } .cv-side { border-right: none; border-bottom: 1px solid var(--border); } }

        .cv-section-title { font-size: 11px; text-transform: uppercase; letter-spacing: .06em; color: var(--text-dim); margin: 0 0 8px; }

        /* algorithm picker */
        #cvPicker { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 12px; }
        .cv-algo {
            position: relative; text-align: left; background: var(--bar-2); border: 1px solid var(--border);
            border-radius: 8px; padding: 8px 10px; cursor: pointer; color: var(--text); min-width: 88px;
        }
        .cv-algo:hover { border-color: var(--primary); }
        .cv-algo--active { border-color: var(--primary); box-shadow: 0 0 0 1px var(--primary) inset; }
        .cv-algo--soon { opacity: .55; cursor: default; }
        .cv-algo-name { display: block; font-weight: 600; color: var(--text-bright); font-size: 14px; }
        .cv-algo-cat { display: block; font-size: 11px; color: var(--text-dim); }
        .cv-soon-badge { position: absolute; top: 6px; right: 6px; font-size: 9px; background: var(--border); color: var(--text-dim); border-radius: 4px; padding: 1px 5px; text-transform: uppercase; }
        #cvAlgoDesc { font-size: 12.5px; color: var(--text-dim); line-height: 1.5; margin-bottom: 16px; }

        /* form */
        .cv-field { margin-bottom: 12px; }
        .cv-label { display: block; font-size: 12px; color: var(--text); margin-bottom: 4px; font-weight: 500; }
        .cv-input {
            width: 100%; background: var(--bg); border: 1px solid var(--border); border-radius: 6px;
            color: var(--text-bright); padding: 8px 10px; font-size: 13px; font-family: 'SFMono-Regular', Consolas, monospace;
        }
        .cv-input:focus { outline: none; border-color: var(--primary); }
        select.cv-input { font-family: inherit; }
        .cv-help { font-size: 11px; color: var(--text-dim); margin-top: 3px; }
        #cvRun { width: 100%; justify-content: center; margin-top: 4px; }
        .cv-status { margin-top: 10px; font-size: 12.5px; min-height: 16px; color: var(--text-dim); display: none; }
        .cv-status.show { display: block; }
        .cv-status--err { color: #e06c5a; }

        /* stage */
        #cvStage { display: none; }
        .cv-stage-head { display: flex; align-items: baseline; gap: 14px; flex-wrap: wrap; margin-bottom: 14px; }
        #cvTraceTitle { font-size: 17px; color: var(--text-bright); font-weight: 600; }
        #cvOutput { display: flex; gap: 8px; flex-wrap: wrap; }
        .cv-out-chip { background: var(--bar-2); border: 1px solid var(--border); border-radius: 6px; padding: 4px 9px; font-size: 12px; display: inline-flex; gap: 6px; }
        .cv-out-k { color: var(--text-dim); } .cv-out-v { color: var(--hl-emit-b); font-family: monospace; }

        /* full-flow strip */
        .cv-flow { margin-bottom: 18px; }
        .cv-flow-title { font-size: 11px; letter-spacing: .06em; color: var(--text-dim); text-transform: uppercase; margin-bottom: 6px; }
        .cv-flow-track { display: flex; align-items: stretch; gap: 6px; flex-wrap: wrap; }
        .cv-flow-stage { background: var(--bar); border: 1px solid var(--border); border-radius: 8px; padding: 7px 11px; cursor: pointer; min-width: 92px; max-width: 220px; transition: border-color .15s, background .15s; }
        .cv-flow-stage:hover { border-color: var(--primary); }
        .cv-flow-active { border-color: var(--primary); background: rgba(0,122,204,.14); box-shadow: 0 0 0 1px var(--primary) inset; }
        .cv-flow-stage-label { font-size: 12.5px; font-weight: 600; color: var(--text-bright); display: flex; align-items: center; gap: 6px; }
        .cv-flow-active .cv-flow-stage-label { color: var(--primary-hi); }
        .cv-flow-loop { font-size: 10px; color: #fff; background: var(--primary); border-radius: 4px; padding: 1px 5px; font-weight: 600; }
        .cv-flow-sub { font-size: 10.5px; color: var(--text-dim); margin-top: 3px; line-height: 1.35; }
        .cv-flow-note { font-size: 9.5px; color: var(--text-dim); font-style: italic; margin-top: 2px; }
        .cv-flow-arrow { align-self: center; color: var(--text-dim); font-size: 15px; }

        /* panels */
        #cvPanels { display: flex; flex-wrap: wrap; gap: 18px; align-items: flex-start; margin-bottom: 18px; }
        .cv-panel { background: var(--bar); border: 1px solid var(--border); border-radius: 10px; padding: 12px; }
        .cv-panel-head { display: flex; align-items: baseline; gap: 8px; margin-bottom: 8px; }
        .cv-panel-label { font-weight: 600; color: var(--text-bright); font-size: 13px; }
        .cv-panel-kind { font-size: 10px; color: var(--text-dim); text-transform: uppercase; }
        .cv-grid { display: grid; gap: 4px; }
        .cv-cell {
            min-width: 38px; height: 38px; display: grid; place-items: center;
            background: var(--bg); border: 1px solid var(--border); border-radius: 5px;
            font-family: 'SFMono-Regular', Consolas, monospace; font-size: 13px; color: var(--text-bright);
            transition: background .18s, border-color .18s, transform .18s;
        }
        .cv-grid--table .cv-cell { min-width: 23px; height: 22px; font-size: 10px; border-radius: 3px; color: var(--text-dim); }
        .cv-grid--words .cv-cell { min-width: 66px; height: 26px; font-size: 11px; letter-spacing: .04em; }
        /* op highlights */
        .cv-hl-xor { background: var(--hl-xor); border-color: var(--hl-xor-b); }
        .cv-hl-sub { background: var(--hl-sub); border-color: var(--hl-sub-b); }
        .cv-hl-permute { background: var(--hl-permute); border-color: var(--hl-permute-b); }
        .cv-hl-mix { background: var(--hl-mix); border-color: var(--hl-mix-b); }
        .cv-hl-load { background: var(--hl-load); }
        .cv-hl-emit { background: var(--hl-emit); border-color: var(--hl-emit-b); }
        .cv-hl-lookup { background: var(--hl-lookup) !important; border-color: var(--hl-xor-b) !important; color: var(--text-bright) !important; transform: scale(1.12); }
        .cv-hl-operand { background: var(--hl-operand); }
        .cv-hl-expand { background: #7e57c233; border-color: #7e57c2; }
        .cv-hl-round { background: #2aa19833; border-color: #2aa198; }
        .cv-hl-add { background: #d4694f33; border-color: var(--hl-emit-b); }
        .cv-hl-feistel { background: #e0833a33; border-color: #e0833a; }
        .cv-hl-modexp { background: #6a8cff33; border-color: #6a8cff; }
        .cv-hl-ecmul { background: #17a2b833; border-color: #17a2b8; }
        .cv-hl-msg { background: #5b8def33; border-color: #5b8def; }
        /* TLS handshake swimlane */
        .cv-swim { width: 460px; max-width: 100%; display: flex; flex-direction: column; gap: 5px; }
        .cv-swim-head { display: flex; justify-content: space-between; font-size: 11px; font-weight: 700; color: var(--text-dim); text-transform: uppercase; letter-spacing: .06em; padding: 0 4px 4px; border-bottom: 1px solid var(--border); }
        .cv-msg { transition: opacity .18s; }
        .cv-arrow { position: relative; display: flex; flex-direction: column; gap: 2px; font-size: 12px; color: var(--text-bright); background: var(--bar-2); border: 1px solid var(--border); border-radius: 6px; padding: 5px 10px; }
        .cv-arrow-top { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
        .cv-arrow-name { font-weight: 600; }
        .cv-arrow-annot { font-size: 10.5px; color: var(--text-dim); line-height: 1.35; }
        .cv-arrow-bytes { font-size: 10px; color: var(--text-dim); font-family: monospace; }
        .cv-msg-c2s .cv-arrow { border-left: 3px solid #5b8def; margin-right: 22%; }
        .cv-msg-s2c .cv-arrow { border-right: 3px solid #e0833a; margin-left: 22%; }
        .cv-msg-s2c .cv-arrow-top { flex-direction: row-reverse; }
        .cv-msg-s2c .cv-arrow-annot { text-align: right; }
        .cv-msg-c2s .cv-arrow::after { content: "▶"; position: absolute; right: -16px; color: #5b8def; font-size: 10px; }
        .cv-msg-s2c .cv-arrow::before { content: "◀"; position: absolute; left: -16px; color: #e0833a; font-size: 10px; }
        .cv-msg-active .cv-arrow { background: #5b8def22; border-color: #5b8def; box-shadow: 0 0 0 1px #5b8def inset; }
        .cv-detail-line.cv-hex { font-family: 'SFMono-Regular', Consolas, monospace; font-size: 11px; color: var(--text-dim); white-space: pre-wrap; word-break: break-all; max-height: 130px; overflow-y: auto; background: var(--bg); border-radius: 5px; padding: 6px 8px; margin-top: 4px; }
        /* elliptic-curve scatter plot */
        .cv-plot { width: 320px; max-width: 100%; background: var(--bg); border: 1px solid var(--border); border-radius: 8px; }
        .cv-plot-axis { stroke: var(--border); stroke-width: 1; fill: none; }
        .cv-plot-line { stroke: var(--text-dim); stroke-width: 1.6; stroke-dasharray: 4 3; }
        .cv-pt { fill: var(--text-dim); opacity: .45; }
        .cv-pt-base { fill: var(--primary); opacity: 1; r: 7; }
        .cv-pt-input { fill: #4f8cd4; opacity: 1; r: 7; }
        .cv-pt-result { fill: #e0833a; opacity: 1; r: 7.5; }
        .cv-pt-third { fill: #9a9aa6; opacity: .95; r: 6.5; }
        /* key/value panel (RSA big numbers) */
        .cv-kv { display: flex; flex-direction: column; gap: 6px; width: 520px; max-width: 100%; }
        .cv-kv-row { display: flex; flex-direction: column; gap: 2px; }
        .cv-kv-label { font-size: 11px; color: var(--text-dim); }
        .cv-kv-val { font-family: 'SFMono-Regular', Consolas, monospace; font-size: 12.5px; color: var(--text-bright);
            background: var(--bg); border: 1px solid var(--border); border-radius: 5px; padding: 5px 8px;
            overflow-x: auto; white-space: nowrap; }
        /* column labels (a..h, H0..H7) above a words panel */
        .cv-collabels { display: grid; gap: 4px; margin-bottom: 3px; }
        .cv-collabel { text-align: center; font-size: 10px; color: var(--text-dim); }

        /* step info */
        .cv-info { background: var(--bar); border: 1px solid var(--border); border-radius: 10px; padding: 14px 16px; margin-bottom: 14px; }
        .cv-info-top { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; flex-wrap: wrap; }
        .cv-phase { font-size: 12px; color: var(--text-dim); background: var(--bar-2); border-radius: 5px; padding: 3px 8px; }
        .cv-op-badge { font-size: 11px; text-transform: uppercase; letter-spacing: .05em; border-radius: 5px; padding: 3px 8px; color: #fff; }
        .cv-op-xor { background: var(--hl-xor-b); } .cv-op-sub { background: var(--hl-sub-b); }
        .cv-op-permute { background: var(--hl-permute-b); } .cv-op-mix { background: var(--hl-mix-b); }
        .cv-op-load { background: #8a8a8a; } .cv-op-emit { background: var(--hl-emit-b); }
        .cv-op-expand { background: #7e57c2; } .cv-op-round { background: #2aa198; } .cv-op-add { background: var(--hl-emit-b); } .cv-op-feistel { background: #e0833a; } .cv-op-modexp { background: #6a8cff; } .cv-op-ecmul { background: #17a2b8; } .cv-op-msg { background: #5b8def; }
        #cvStepTitle { font-size: 15px; color: var(--text-bright); font-weight: 600; }
        #cvFormula { font-family: monospace; font-size: 12.5px; color: var(--primary-hi); background: var(--bg); border-radius: 6px; padding: 7px 10px; margin: 8px 0; display: inline-block; }
        #cvExplain { font-size: 13px; color: var(--text); line-height: 1.55; }
        #cvDetail { margin-top: 8px; }
        .cv-detail-line { font-family: monospace; font-size: 12px; color: var(--text-dim); line-height: 1.7; }

        /* player */
        .cv-player { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; background: var(--bar); border: 1px solid var(--border); border-radius: 10px; padding: 10px 14px; margin-bottom: 12px; }
        .cv-player .cv-btn { padding: 7px 10px; }
        #cvStepNo { font-size: 12.5px; color: var(--text-dim); min-width: 64px; text-align: center; }
        #cvSpeed { background: var(--bar-2); color: var(--text); border: 1px solid var(--border); border-radius: 6px; padding: 6px; font-size: 12px; }
        .cv-player .label { font-size: 12px; color: var(--text-dim); margin-left: auto; }

        /* timeline */
        #cvTimeline { display: flex; gap: 3px; flex-wrap: wrap; }
        .cv-tl-dot { width: 16px; height: 16px; border-radius: 4px; border: none; cursor: pointer; opacity: .45; padding: 0; }
        .cv-tl-dot:hover { opacity: .8; }
        .cv-tl-active { opacity: 1; outline: 2px solid var(--text-bright); outline-offset: 1px; }

        /* about */
        .cv-about { max-width: 760px; margin: 28px 0 12px; color: var(--text-dim); font-size: 13px; line-height: 1.65; }
        .cv-about h2 { font-size: 14px; color: var(--text-bright); margin-bottom: 6px; }
        .cv-about-algo { margin-top: 8px; color: var(--text); }
        .cv-about-algo:empty { display: none; }
        .cv-legend { display: flex; gap: 14px; flex-wrap: wrap; margin: 10px 0; }
        .cv-legend span { display: inline-flex; align-items: center; gap: 6px; font-size: 12px; }
        .cv-swatch { width: 12px; height: 12px; border-radius: 3px; display: inline-block; }
    </style>
</head>
<body>
    <script>window.CV_CTX = '<%= ctx %>';</script>

    <!-- top bar -->
    <div class="cv-bar">
        <a href="<%=ctx%>/" class="cv-home" title="8gwifi.org Home" aria-label="8gwifi.org Home">
            <img src="<%=ctx%>/images/site/logo.svg" alt="8gwifi.org" width="28" height="28"
                 onerror="this.onerror=null;this.src='<%=ctx%>/images/site/logo.png';">
        </a>
        <div class="cv-brand">
            <div class="logo"><i class="fas fa-lock"></i></div>
            <div>
                <h1>Crypto Visualizer</h1>
                <div class="sub">See how encryption works, step by step</div>
            </div>
        </div>
        <div class="spacer"></div>
        <button class="cv-btn" onclick="document.body.classList.toggle('light')" title="Toggle light / dark">
            <i class="fas fa-moon"></i>
        </button>
    </div>

    <div class="cv-main">
        <!-- left: picker + form -->
        <aside class="cv-side">
            <div class="cv-section-title">Algorithm</div>
            <div id="cvPicker"></div>
            <div id="cvAlgoDesc"></div>

            <div class="cv-section-title">Inputs</div>
            <div id="cvForm"></div>
            <button class="cv-btn primary" id="cvRun"><i class="fas fa-play"></i> Visualize</button>
            <div class="cv-status" id="cvStatus"></div>
        </aside>

        <!-- right: stage -->
        <section class="cv-stage-wrap">
            <div id="cvStage">
                <div class="cv-stage-head">
                    <span id="cvTraceTitle"></span>
                    <div id="cvOutput"></div>
                </div>

                <div id="cvFlow" class="cv-flow"></div>

                <div id="cvPanels"></div>

                <div class="cv-info">
                    <div class="cv-info-top">
                        <span class="cv-phase" id="cvPhase"></span>
                        <span class="cv-op-badge" id="cvOp"></span>
                        <span id="cvStepTitle"></span>
                    </div>
                    <div id="cvFormula"></div>
                    <div id="cvExplain"></div>
                    <div id="cvDetail"></div>
                </div>

                <div class="cv-player">
                    <button class="cv-btn" id="cvFirst" title="First step"><i class="fas fa-backward-step"></i></button>
                    <button class="cv-btn" id="cvPrev" title="Previous (←)"><i class="fas fa-chevron-left"></i></button>
                    <button class="cv-btn primary" id="cvPlay" title="Play / pause (space)"><i class="fas fa-play"></i></button>
                    <button class="cv-btn" id="cvNext" title="Next (→)"><i class="fas fa-chevron-right"></i></button>
                    <button class="cv-btn" id="cvLast" title="Last step"><i class="fas fa-forward-step"></i></button>
                    <span id="cvStepNo"></span>
                    <select id="cvSpeed" title="Playback speed">
                        <option value="1500">Slow</option>
                        <option value="900" selected>Normal</option>
                        <option value="400">Fast</option>
                    </select>
                    <span class="label">← / → step · space play</span>
                </div>

                <div id="cvTimeline"></div>
            </div>

            <div class="cv-about">
                <h2>How this works</h2>
                <p>This visualizer runs the <strong>real reference implementation</strong> of each algorithm in a
                   sandbox and records the state before and after every transform — nothing is re-implemented or
                   faked. Pick an algorithm, enter your own input, and step through every operation.</p>
                <p id="cvAboutAlgo" class="cv-about-algo"></p>
                <div class="cv-legend" id="cvLegend"></div>
            </div>
        </section>
    </div>
    <script src="<%=ctx%>/crypto-viz/crypto-viz.js"></script>

    <%-- Analytics + ad system (deferred to end of body for LCP) --%>
    <%@ include file="/modern/components/analytics.jsp" %>
    <%@ include file="/modern/ads/ad-init.jsp" %>
</body>
</html>
