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
        <jsp:param name="toolName" value="How AES &amp; SHA-256 Work - Step-by-Step Crypto Visualizer" />
        <jsp:param name="toolDescription" value="See how AES-128 and SHA-256 work, step by step - watch SubBytes, ShiftRows, MixColumns, AddRoundKey, the AES key schedule, and SHA-256's 64 rounds. Driven by the real reference implementation; enter your own input and step through every operation." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="/crypto-viz/" />
        <jsp:param name="toolKeywords" value="how aes works, aes step by step, aes encryption visualization, aes animation, subbytes shiftrows mixcolumns addroundkey, aes key expansion explained, aes rounds explained, how sha-256 works, sha256 step by step, sha-256 visualization, sha-256 compression function, sha-256 message schedule, block cipher visualizer, learn cryptography, fips 197, encryption algorithm visualizer, interactive aes" />
        <jsp:param name="toolImage" value="crypto-viz-og.png" />
        <jsp:param name="toolFeatures" value="See how AES-128 encrypts and decrypts step by step,Visualize the AES key schedule (round-key expansion),Animated SubBytes / ShiftRows / MixColumns / AddRoundKey,See how SHA-256 hashes - message schedule plus 64 compression rounds,Driven by the real reference implementation - nothing re-implemented or faked,Play, scrub and step through every operation" />
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
        .cv-op-expand { background: #7e57c2; } .cv-op-round { background: #2aa198; } .cv-op-add { background: var(--hl-emit-b); }
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
