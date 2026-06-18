<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
    String ctx = request.getContextPath();
    request.setAttribute("aiToolId", "developer-tools/code-playground");
    request.setAttribute("aiRequireSignIn", "true");

    // Auth state for the logo + login/logout button (mirrors nav-header.jsp).
    // Use getSession(false) so it works under session="false".
    String navUserSub = null, navUserEmail = null;
    javax.servlet.http.HttpSession navSession = request.getSession(false);
    if (navSession != null) {
        Object subObj = navSession.getAttribute("oauth_user_sub");
        Object emailObj = navSession.getAttribute("oauth_user_email");
        if (subObj != null) navUserSub = subObj.toString();
        if (emailObj != null) navUserEmail = emailObj.toString();
    }
    boolean navLoggedIn = (navUserSub != null && !navUserSub.isEmpty()) || (navUserEmail != null && !navUserEmail.isEmpty());
    String navRedirectPath = request.getRequestURI();
    if (ctx != null && !ctx.isEmpty() && navRedirectPath.startsWith(ctx)) {
        navRedirectPath = navRedirectPath.substring(ctx.length());
        if (navRedirectPath.isEmpty()) navRedirectPath = "/";
    }
    if (request.getQueryString() != null && !request.getQueryString().isEmpty()) {
        navRedirectPath += "?" + request.getQueryString();
    }
    String navLoginUrl = ctx + "/GoogleOAuthFunctionality?action=login&redirect_path="
            + java.net.URLEncoder.encode(navRedirectPath, "UTF-8");
    String navLogoutUrl = ctx + "/GoogleOAuthFunctionality?action=logout&redirect_path="
            + java.net.URLEncoder.encode(navRedirectPath, "UTF-8");
%>
<%@ include file="/modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Code Playground - Run Languages Side by Side" />
        <jsp:param name="toolDescription" value="Run multiple programming languages and versions side by side - Python, Java, Go, C++, Rust, JS and more. Pick a language and version per pane, write code, and run them together." />
        <jsp:param name="toolCategory" value="Developer Tools" />
        <jsp:param name="toolUrl" value="/code-playground/" />
        <jsp:param name="toolKeywords" value="code playground, compare programming languages, run code online, online compiler, side by side compiler, polyglot playground, python, java, go, c++, rust, javascript" />
        <jsp:param name="toolImage" value="code-playground-og.png" />
        <jsp:param name="toolFeatures" value="Run multiple languages side by side,Choose any language and version per pane,Run all panes at once,Resizable split-screen panes,Columns or rows layout,Share your setup with a link" />
    </jsp:include>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%=ctx%>/modern/css/ads.css">
    <%@ include file="/modern/components/ai-assistant-head.inc.jsp" %>

    <!-- LCP optimization: defer ad-init.jsp to bottom of body. Tiny stub here so
         the per-ad lazy-load observer can safely queue googletag.cmd / stpd.que
         pushes before the real GPT script arrives. -->
    <link rel="preconnect" href="https://securepubads.g.doubleclick.net" crossorigin>
    <link rel="preconnect" href="https://stpd.cloud" crossorigin>
    <script>
        window.googletag = window.googletag || { cmd: [] };
        window.stpd = window.stpd || { que: [] };
    </script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg: #181818;
            --bar: #252526;
            --bar-2: #2d2d2e;
            --border: #3c3c3c;
            --text: #cccccc;
            --text-dim: #8a8a8a;
            --text-bright: #ffffff;
            --primary: #007acc;
            --primary-hi: #1f8fd6;
        }
        body.light {
            --bg: #ececed;
            --bar: #f3f3f3;
            --bar-2: #e7e7e7;
            --border: #d0d0d0;
            --text: #333333;
            --text-dim: #777777;
            --text-bright: #000000;
        }

        html, body { height: 100%; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg);
            color: var(--text);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* ---- Top toolbar ---- */
        .pp-bar {
            flex: 0 0 auto;
            background: var(--bar);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 8px 14px;
            flex-wrap: wrap;
        }
        .pp-home {
            display: flex;
            align-items: center;
            flex: 0 0 auto;
            padding: 2px;
            border-radius: 6px;
        }
        .pp-home img { display: block; border-radius: 5px; }
        .pp-home:hover { background: var(--border); }

        .pp-brand {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-right: auto;
        }
        .pp-brand .logo {
            width: 30px; height: 30px;
            border-radius: 7px;
            background: linear-gradient(135deg, var(--primary), #6f42c1);
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 14px;
        }
        .pp-brand .title { font-size: 14px; font-weight: 600; color: var(--text-bright); line-height: 1.1; }
        .pp-brand .sub { font-size: 11px; color: var(--text-dim); }

        .pp-actions { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }

        .pp-btn {
            display: inline-flex; align-items: center; gap: 7px;
            background: var(--bar-2);
            color: var(--text);
            border: 1px solid var(--border);
            border-radius: 6px;
            padding: 7px 12px;
            font-size: 13px;
            cursor: pointer;
            white-space: nowrap;
            transition: background .12s, border-color .12s, color .12s;
        }
        .pp-btn:hover { background: var(--border); color: var(--text-bright); }
        .pp-btn i { font-size: 12px; }
        .pp-btn.primary {
            background: var(--primary); border-color: var(--primary); color: #fff;
        }
        .pp-btn.primary:hover { background: var(--primary-hi); border-color: var(--primary-hi); }
        .pp-btn:disabled { opacity: .45; cursor: not-allowed; }
        .pp-btn .label-collapse { }
        @media (max-width: 720px) { .pp-btn .label-collapse { display: none; } }

        /* ---- In-content ad band (after H1 hero) ---- */
        .pp-ad {
            flex: 0 0 auto;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 0;
            padding: 6px 10px;
            background: var(--bar);
            border-bottom: 1px solid var(--border);
            overflow: hidden;
        }
        .pp-ad:empty { display: none; }

        /* ---- Shared stdin bar ---- */
        .pp-stdin {
            flex: 0 0 auto;
            display: none;
            align-items: stretch;
            gap: 10px;
            padding: 8px 14px;
            background: var(--bar);
            border-bottom: 1px solid var(--border);
        }
        .pp-stdin.show { display: flex; }
        .pp-stdin label {
            display: flex; align-items: center; gap: 6px;
            font-size: 12px; color: var(--text-dim); white-space: nowrap; padding-top: 4px;
        }
        .pp-stdin textarea {
            flex: 1 1 auto;
            height: 44px;
            resize: vertical;
            background: var(--bg);
            color: var(--text);
            border: 1px solid var(--border);
            border-radius: 6px;
            padding: 6px 10px;
            font-family: 'SF Mono','Menlo','Consolas',monospace;
            font-size: 12px;
            outline: none;
        }
        .pp-stdin textarea:focus { border-color: var(--primary); }

        /* ---- Panes ---- */
        .pp-panes {
            flex: 1 1 auto;
            display: flex;
            flex-direction: row;
            min-height: 0;
            overflow: hidden;
        }
        .pp-panes.layout-rows { flex-direction: column; }

        .pane {
            flex: 1 1 0;
            min-width: 240px;
            min-height: 160px;
            display: flex;
            flex-direction: column;
            background: var(--bg);
            overflow: hidden;
        }
        .pane-head {
            flex: 0 0 auto;
            height: 30px;
            background: var(--bar);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 0 8px 0 10px;
            cursor: pointer;
        }
        .pane.active .pane-head {
            box-shadow: inset 0 -2px 0 var(--primary);
        }
        .pane.active .pane-dot {
            background: #6f42c1;
            box-shadow: 0 0 0 2px rgba(0, 122, 204, 0.45);
        }
        .pp-btn.pp-btn-ai {
            background: linear-gradient(135deg, #10b981 0%, #0ea5a4 100%);
            border-color: transparent;
            color: #fff;
        }
        .pp-btn.pp-btn-ai:hover {
            filter: brightness(1.08);
            color: #fff;
        }
        .pane-dot {
            width: 9px; height: 9px; border-radius: 50%;
            background: var(--primary);
            flex: 0 0 auto;
        }
        .pane-label { font-size: 12px; color: var(--text-dim); margin-right: auto; }
        .pane-close {
            background: transparent; border: none; color: var(--text-dim);
            cursor: pointer; font-size: 13px; padding: 4px 6px; border-radius: 4px;
        }
        .pane-close:hover { background: var(--border); color: var(--text-bright); }
        .pane iframe { flex: 1 1 auto; width: 100%; border: none; background: var(--bg); }

        /* ---- Splitter ---- */
        .splitter {
            flex: 0 0 auto;
            background: var(--border);
            position: relative;
            z-index: 5;
            touch-action: none;
        }
        .pp-panes:not(.layout-rows) > .splitter { width: 6px; cursor: col-resize; }
        .pp-panes.layout-rows > .splitter { height: 6px; cursor: row-resize; }
        .splitter:hover { background: var(--primary); }
        .splitter::after {
            content: ''; position: absolute;
            background: var(--text-dim); border-radius: 2px; opacity: .5;
        }
        .pp-panes:not(.layout-rows) > .splitter::after {
            width: 2px; height: 26px; left: 2px; top: 50%; transform: translateY(-50%);
        }
        .pp-panes.layout-rows > .splitter::after {
            height: 2px; width: 26px; top: 2px; left: 50%; transform: translateX(-50%);
        }

        /* Shield captures mouse while dragging over iframes */
        .drag-shield { position: fixed; inset: 0; z-index: 9999; display: none; }
        body.dragging .drag-shield { display: block; }
        body.dragging.col-drag .drag-shield { cursor: col-resize; }
        body.dragging.row-drag .drag-shield { cursor: row-resize; }

        /* Toast */
        .pp-toast {
            position: fixed; bottom: 22px; left: 50%; transform: translateX(-50%) translateY(20px);
            background: #323233; color: #fff; padding: 10px 16px; border-radius: 8px;
            font-size: 13px; box-shadow: 0 6px 24px rgba(0,0,0,.4);
            opacity: 0; pointer-events: none; transition: opacity .2s, transform .2s; z-index: 10000;
        }
        .pp-toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }

        /* ---- Mobile: stack panes and let the page scroll ---- */
        @media (max-width: 760px) {
            html, body { height: auto; min-height: 100%; }
            body { overflow-y: auto; }
            .pp-bar { padding: 7px 10px; gap: 8px; }
            .pp-brand .sub { display: none; }
            .pp-actions { gap: 6px; }
            .pp-btn { padding: 8px 10px; }
            .pp-panes, .pp-panes.layout-rows {
                flex: 0 0 auto;
                flex-direction: column;
                overflow: visible;
            }
            /* On phones, drag-to-resize is awkward — stack and scroll instead. */
            .pp-panes > .splitter { display: none; }
            .pane {
                flex: 0 0 auto;
                width: 100% !important;
                min-width: 0;
                height: 72vh;
                flex-grow: 0 !important;
                border-bottom: 3px solid var(--border);
            }
            .pp-stdin textarea { height: 60px; }
        }
    </style>
</head>
<body>
    <!-- Toolbar -->
    <div class="pp-bar">
        <a href="<%=ctx%>/" class="pp-home" title="8gwifi.org Home" aria-label="8gwifi.org Home">
            <img src="<%=ctx%>/images/site/logo.svg" alt="8gwifi.org" width="28" height="28"
                 onerror="this.onerror=null;this.src='<%=ctx%>/images/site/logo.png';">
        </a>
        <div class="pp-brand">
            <div class="logo"><i class="fas fa-code-compare"></i></div>
            <div>
                <h1 class="title">Polyglot Playground</h1>
                <div class="sub">Run languages &amp; versions side by side</div>
            </div>
        </div>
        <div class="pp-actions">
            <button class="pp-btn primary" id="runAllBtn" onclick="runAll()" title="Run every pane (Ctrl+Enter)">
                <i class="fas fa-play"></i> Run all
            </button>
            <button class="pp-btn" id="addPaneBtn" onclick="addPane()" title="Add another pane">
                <i class="fas fa-plus"></i> <span class="label-collapse">Add pane</span>
            </button>
            <button class="pp-btn" id="layoutBtn" onclick="toggleLayout()" title="Switch between columns and rows">
                <i class="fas fa-table-columns" id="layoutIcon"></i> <span class="label-collapse" id="layoutLabel">Columns</span>
            </button>
            <button class="pp-btn" id="stdinBtn" onclick="toggleSharedStdin()" title="Feed the same stdin to every pane">
                <i class="fas fa-keyboard"></i> <span class="label-collapse">Shared input</span>
            </button>
            <button type="button" class="pp-btn pp-btn-ai" id="btnPlaygroundAI" title="AI assistant — generate or edit code per pane (Ctrl+Shift+A)">
                <i class="fas fa-wand-magic-sparkles"></i> <span class="label-collapse">AI</span>
            </button>
            <button class="pp-btn" onclick="toggleTheme()" title="Toggle light / dark">
                <i class="fas fa-moon" id="themeIcon"></i>
            </button>
            <button class="pp-btn" onclick="shareSetup()" title="Copy a link to this setup">
                <i class="fas fa-share-nodes"></i> <span class="label-collapse">Share</span>
            </button>
            <a class="pp-btn" href="<%=ctx%>/onecompiler.jsp" target="_blank" title="Open the full IDE">
                <i class="fas fa-up-right-from-square"></i>
            </a>
            <% if (navLoggedIn) { %>
            <a class="pp-btn" href="<%=navLogoutUrl%>" title="Logout" aria-label="Logout">
                <i class="fas fa-user"></i> <span class="label-collapse">Logout</span>
            </a>
            <% } else { %>
            <a class="pp-btn" href="<%=navLoginUrl%>" title="Login with Google" aria-label="Login with Google">
                <i class="fas fa-right-to-bracket"></i> <span class="label-collapse">Login</span>
            </a>
            <% } %>
        </div>
    </div>

    <!-- In-content leaderboard ad: directly after the H1 hero -->
<%--    <div class="pp-ad">--%>
<%--        <%@ include file="/modern/ads/ad-in-content-top.jsp" %>--%>
<%--    </div>--%>

    <!-- Shared stdin: feeds the same input to every pane -->
    <div class="pp-stdin" id="sharedStdinBar">
        <label for="sharedStdin"><i class="fas fa-keyboard"></i> Shared stdin</label>
        <textarea id="sharedStdin" placeholder="Type input here to feed every pane's program (one value per line)..." oninput="broadcastStdin()"></textarea>
    </div>

    <!-- Panes -->
    <div class="pp-panes" id="panes"></div>

    <div class="drag-shield" id="dragShield"></div>
    <div class="pp-toast" id="toast"></div>

    <!-- Shared copy/toast helpers (ToolUtils) -->
    <script src="<%=ctx%>/modern/js/tool-utils.js"></script>

    <script>
        var CTX = '<%=ctx%>';
        var EMBED = CTX + '/onecompiler-embed.jsp';
        var SNIP_API = CTX + '/OneCompilerFunctionality';
        var MAX_PANES = 4;
        var MIN_PANE_PX = 220;
        // Fallback order if the languages API is unreachable. The live list is
        // fetched from the servlet on load (see loadSupportedLangs) so new
        // languages appear in the "Add pane" cycle automatically.
        var LANG_CYCLE = ['python','javascript','go','java','cpp','rust','ruby','php','typescript','c','haskell'];
        var supportedLangs = LANG_CYCLE.slice();

        function loadSupportedLangs() {
            fetch(SNIP_API + '?action=languages')
                .then(function(r){ return r.json(); })
                .then(function(data){
                    var arr = Array.isArray(data) ? data : (data && data.languages) || [];
                    var names = arr.map(function(l){ return String(l.name || '').toLowerCase(); }).filter(Boolean);
                    if (names.length) supportedLangs = names;
                })
                .catch(function(){ /* keep fallback */ });
        }

        // UTF-8 safe base64 (matches the embed's encode/decode scheme)
        function b64enc(s) { try { return btoa(unescape(encodeURIComponent(s))); } catch (e) { return ''; } }

        var panesEl = document.getElementById('panes');
        var theme = 'dark';
        var layout = 'columns';
        var paneSeq = 0;
        var sharedStdin = '';
        var activePaneId = null;
        var paneCodeCache = {};

        var LANG_CANON = {
            py: 'python', python3: 'python', js: 'javascript', node: 'javascript',
            ts: 'typescript', golang: 'go', 'c++': 'cpp', cxx: 'cpp', cc: 'cpp',
            rs: 'rust', rb: 'ruby'
        };
        function canonLang(lang) {
            var k = String(lang || '').trim().toLowerCase();
            return LANG_CANON[k] || k;
        }

        function setActivePane(pane) {
            if (!pane) return;
            panesEl.querySelectorAll('.pane').forEach(function(p) {
                p.classList.toggle('active', p === pane);
            });
            activePaneId = pane.dataset.paneId || null;
        }

        function fetchPaneCode(iframe, requestId) {
            return new Promise(function(resolve) {
                var done = false;
                var timeout = setTimeout(finish, 3500);
                function finish(payload) {
                    if (done) return;
                    done = true;
                    clearTimeout(timeout);
                    window.removeEventListener('message', onMsg);
                    resolve(payload || { code: '', lang: '', version: '' });
                }
                function onMsg(e) {
                    var msg = e.data || {};
                    if (msg.type !== 'compare-code' || msg.requestId !== requestId) return;
                    finish({ code: msg.code || '', lang: msg.lang || '', version: msg.version || '' });
                }
                window.addEventListener('message', onMsg);
                try {
                    iframe.contentWindow.postMessage({ type: 'compare-get-code', requestId: requestId }, '*');
                } catch (err) {
                    finish({ code: '', lang: '', version: '' });
                }
            });
        }

        function refreshPaneCodesAsync() {
            var panes = panesEl.querySelectorAll('.pane');
            var jobs = [];
            panes.forEach(function(p) {
                var pid = p.dataset.paneId;
                var iframe = p.querySelector('iframe');
                if (!pid || !iframe) return;
                var rid = 'pp-' + pid + '-' + Date.now() + '-' + Math.random().toString(36).slice(2, 8);
                jobs.push(fetchPaneCode(iframe, rid).then(function(res) {
                    paneCodeCache[pid] = {
                        code: res.code || '',
                        lang: res.lang || p.dataset.lang || 'python',
                        version: res.version || ''
                    };
                    if (res.lang) {
                        p.dataset.lang = res.lang;
                    }
                }));
            });
            return Promise.all(jobs).then(function() { relabel(); });
        }

        function getPaneSnapshotList() {
            var list = [];
            var i = 0;
            panesEl.querySelectorAll('.pane').forEach(function(p) {
                i++;
                var pid = p.dataset.paneId;
                var cached = paneCodeCache[pid] || {};
                list.push({
                    id: pid,
                    index: i,
                    lang: canonLang(cached.lang || p.dataset.lang || 'python'),
                    code: cached.code || ''
                });
            });
            return list;
        }

        function applyCodeToPanes(updates) {
            var applied = [];
            panesEl.querySelectorAll('.pane').forEach(function(p) {
                var pid = p.dataset.paneId;
                var plang = canonLang(p.dataset.lang);
                updates.forEach(function(u) {
                    if (canonLang(u.lang) !== plang) return;
                    var iframe = p.querySelector('iframe');
                    if (!iframe) return;
                    try {
                        iframe.contentWindow.postMessage({ type: 'compare-set-code', code: String(u.code || '') }, '*');
                        paneCodeCache[pid] = { code: u.code, lang: plang, version: (paneCodeCache[pid] && paneCodeCache[pid].version) || '' };
                        applied.push({ paneId: pid, lang: plang });
                    } catch (e) { /* cross-origin */ }
                });
            });
            return { applied: applied };
        }

        window.ppShell = {
            getSnapshot: function() {
                return {
                    panes: getPaneSnapshotList(),
                    activePaneId: activePaneId,
                    layout: layout
                };
            },
            refreshPaneCodes: refreshPaneCodesAsync,
            applyToPanes: applyCodeToPanes
        };

        // ---- Init from URL ----
        (function init() {
            loadSupportedLangs(); // refresh the "Add pane" cycle from the live API
            var p = new URLSearchParams(location.search);
            if (p.get('theme') === 'light') setTheme('light');
            if (p.get('layout') === 'rows') setLayout('rows');

            // Shared setup: ?s=<snippetId> holds the full bundle (code + panes).
            var snip = p.get('s');
            if (snip) { loadSharedSnippet(snip); return; }

            var initial = (p.get('panes') || 'python,javascript').split(',')
                .map(function(s){ return s.trim(); }).filter(Boolean).slice(0, MAX_PANES);
            if (!initial.length) initial = ['python', 'javascript'];
            initial.forEach(function(lang){ addPane(lang, true); });
            finishLayout();
        })();

        // Mobile: stacked rows read better than cramped columns.
        function finishLayout() {
            if (window.innerWidth < 760 && layout === 'columns') setLayout('rows');
        }

        // Rebuild the whole playground from a shared bundle snippet (no backend
        // change — the snippet just stores our JSON manifest as its code).
        function loadSharedSnippet(id) {
            fetch(SNIP_API + '?action=snippet_get&id=' + encodeURIComponent(id))
                .then(function(r){ return r.json(); })
                .then(function(data){
                    var raw = data.code || (data.files && data.files[0] && data.files[0].content) || '';
                    var bundle = JSON.parse(raw);
                    if (!bundle || !bundle.panes || !bundle.panes.length) throw new Error('empty bundle');
                    if (bundle.theme === 'light') setTheme('light');
                    if (bundle.layout === 'rows') setLayout('rows');
                    bundle.panes.slice(0, MAX_PANES).forEach(function(pn){
                        addPane(canonLang(pn.lang || 'python'), true, { version: pn.version || '', code: pn.code || '' });
                    });
                    finishLayout();
                })
                .catch(function(){
                    toast('Could not load that shared setup — starting fresh');
                    ['python','javascript'].forEach(function(lang){ addPane(lang, true); });
                    finishLayout();
                });
        }

        // ---- Pane management ----
        function paneCount() { return panesEl.querySelectorAll('.pane').length; }

        function nextUnusedLang() {
            var used = [];
            panesEl.querySelectorAll('.pane').forEach(function(p){ used.push(p.dataset.lang); });
            var list = (supportedLangs && supportedLangs.length) ? supportedLangs : LANG_CYCLE;
            for (var i = 0; i < list.length; i++) {
                if (used.indexOf(list[i]) === -1) return list[i];
            }
            return list[0] || 'python';
        }

        function addPane(lang, skipResetGrow, opts) {
            if (paneCount() >= MAX_PANES) return;
            lang = lang || nextUnusedLang();
            opts = opts || {};
            var initVersion = opts.version || '';
            var initCode = (opts.code != null) ? String(opts.code) : null;

            if (paneCount() > 0) {
                var sp = document.createElement('div');
                sp.className = 'splitter';
                sp.addEventListener('pointerdown', startDrag);
                panesEl.appendChild(sp);
            }

            var id = ++paneSeq;
            var paneId = 'pane-' + id;
            var pane = document.createElement('div');
            pane.className = 'pane';
            pane.dataset.lang = lang;
            pane.dataset.paneId = paneId;
            pane.style.flexGrow = '1';

            var head = document.createElement('div');
            head.className = 'pane-head';
            head.innerHTML =
                '<span class="pane-dot"></span>' +
                '<span class="pane-label">Pane</span>' +
                '<button type="button" class="pane-close" title="Close pane"><i class="fas fa-xmark"></i></button>';
            head.addEventListener('click', function(e) {
                if (e.target.closest('.pane-close')) return;
                setActivePane(pane);
            });
            head.querySelector('.pane-close').addEventListener('click', function(e) {
                e.stopPropagation();
                removePane(pane);
            });

            var iframe = document.createElement('iframe');
            // When rehydrating from a shared snippet, pass the code via the embed's
            // ?c= param so the embed loads it after Monaco is ready (no template
            // flash, no postMessage race). Otherwise just preselect the language.
            var src = EMBED + '?picker=true';
            if (initCode != null) {
                src += '&c=' + encodeURIComponent(JSON.stringify({ lang: lang, code: b64enc(initCode) }));
            } else {
                src += '&lang=' + encodeURIComponent(lang);
            }
            if (initVersion) src += '&version=' + encodeURIComponent(initVersion);
            if (theme === 'light') src += '&theme=light';
            iframe.src = src;
            iframe.setAttribute('title', 'Compiler pane ' + id);
            // Push current shared stdin into the new pane once it has loaded.
            iframe.addEventListener('load', function() {
                if (sharedStdin) {
                    try { iframe.contentWindow.postMessage({ type: 'compare-stdin', value: sharedStdin }, '*'); } catch (e) {}
                }
                var rid = 'pp-load-' + paneId;
                fetchPaneCode(iframe, rid).then(function(res) {
                    paneCodeCache[paneId] = {
                        code: res.code || initCode || '',
                        lang: res.lang || lang,
                        version: res.version || initVersion || ''
                    };
                    if (res.lang) pane.dataset.lang = res.lang;
                    relabel();
                });
            });

            pane.appendChild(head);
            pane.appendChild(iframe);
            panesEl.appendChild(pane);
            paneCodeCache[paneId] = { code: initCode || '', lang: lang, version: initVersion };

            if (!activePaneId) setActivePane(pane);
            else if (!panesEl.querySelector('.pane.active')) setActivePane(pane);

            if (!skipResetGrow) resetGrow();
            relabel();
            updateControls();
        }

        function removePane(pane) {
            if (paneCount() <= 1) return;
            // Remove an adjacent splitter (prefer the one before this pane).
            var prev = pane.previousElementSibling;
            var next = pane.nextElementSibling;
            if (prev && prev.classList.contains('splitter')) prev.remove();
            else if (next && next.classList.contains('splitter')) next.remove();
            var removedId = pane.dataset.paneId;
            pane.remove();
            if (removedId) delete paneCodeCache[removedId];
            if (activePaneId === removedId) {
                var first = panesEl.querySelector('.pane');
                setActivePane(first || null);
            }
            resetGrow();
            relabel();
            updateControls();
        }

        function relabel() {
            var i = 0;
            panesEl.querySelectorAll('.pane').forEach(function(p){
                i++;
                var lbl = p.querySelector('.pane-label');
                var name = p.dataset.lang ? (p.dataset.lang.charAt(0).toUpperCase() + p.dataset.lang.slice(1)) : '';
                lbl.textContent = 'Pane ' + i + (name ? ' · ' + name : '');
            });
        }

        function resetGrow() {
            panesEl.querySelectorAll('.pane').forEach(function(p){ p.style.flexGrow = '1'; });
        }

        function updateControls() {
            document.getElementById('addPaneBtn').disabled = paneCount() >= MAX_PANES;
            var closable = paneCount() > 1;
            panesEl.querySelectorAll('.pane-close').forEach(function(b){ b.style.display = closable ? '' : 'none'; });
        }

        // ---- Resizable splitters (with iframe-safe drag shield) ----
        function startDrag(e) {
            e.preventDefault();
            var splitter = e.currentTarget;
            var prev = splitter.previousElementSibling;
            var next = splitter.nextElementSibling;
            if (!prev || !next) return;

            var rows = panesEl.classList.contains('layout-rows');
            var dim = rows ? 'height' : 'width';
            var axis = rows ? 'clientY' : 'clientX';

            // Freeze current pixel layout into flex-grow values so only this seam moves.
            panesEl.querySelectorAll('.pane').forEach(function(p){
                p.style.flexGrow = String(p.getBoundingClientRect()[dim]);
            });

            var startPos = e[axis];
            var growA = parseFloat(prev.style.flexGrow);
            var growB = parseFloat(next.style.flexGrow);

            document.body.classList.add('dragging', rows ? 'row-drag' : 'col-drag');

            function onMove(ev) {
                var delta = ev[axis] - startPos;
                var a = growA + delta, b = growB - delta;
                if (a < MIN_PANE_PX) { b -= (MIN_PANE_PX - a); a = MIN_PANE_PX; }
                if (b < MIN_PANE_PX) { a -= (MIN_PANE_PX - b); b = MIN_PANE_PX; }
                prev.style.flexGrow = String(a);
                next.style.flexGrow = String(b);
            }
            function onUp() {
                document.body.classList.remove('dragging', 'row-drag', 'col-drag');
                window.removeEventListener('pointermove', onMove);
                window.removeEventListener('pointerup', onUp);
                window.removeEventListener('pointercancel', onUp);
            }
            window.addEventListener('pointermove', onMove);
            window.addEventListener('pointerup', onUp);
            window.addEventListener('pointercancel', onUp);
        }

        // ---- Run all ----
        function runAll() {
            panesEl.querySelectorAll('.pane iframe').forEach(function(f){
                try { f.contentWindow.postMessage({ type: 'compare-run' }, '*'); } catch (e) {}
            });
        }
        document.addEventListener('keydown', function(e) {
            if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') { e.preventDefault(); runAll(); }
        });

        // ---- Layout ----
        function setLayout(mode) {
            layout = mode;
            panesEl.classList.toggle('layout-rows', mode === 'rows');
            resetGrow();
            document.getElementById('layoutIcon').className = mode === 'rows' ? 'fas fa-table-rows' : 'fas fa-table-columns';
            document.getElementById('layoutLabel').textContent = mode === 'rows' ? 'Rows' : 'Columns';
        }
        function toggleLayout() { setLayout(layout === 'columns' ? 'rows' : 'columns'); }

        // ---- Theme ----
        function setTheme(mode) {
            theme = mode;
            document.body.classList.toggle('light', mode === 'light');
            document.getElementById('themeIcon').className = mode === 'light' ? 'fas fa-sun' : 'fas fa-moon';
            panesEl.querySelectorAll('.pane iframe').forEach(function(f){
                try { f.contentWindow.postMessage({ type: 'compare-theme', theme: mode }, '*'); } catch (e) {}
            });
        }
        function toggleTheme() { setTheme(theme === 'light' ? 'dark' : 'light'); }

        // ---- Shared stdin ----
        function toggleSharedStdin() {
            var bar = document.getElementById('sharedStdinBar');
            var shown = bar.classList.toggle('show');
            document.getElementById('stdinBtn').classList.toggle('primary', shown);
            if (shown) document.getElementById('sharedStdin').focus();
        }
        function broadcastStdin() {
            sharedStdin = document.getElementById('sharedStdin').value;
            panesEl.querySelectorAll('.pane iframe').forEach(function(f){
                try { f.contentWindow.postMessage({ type: 'compare-stdin', value: sharedStdin }, '*'); } catch (e) {}
            });
        }

        // ---- Keep pane language in sync (for accurate Share) ----
        window.addEventListener('message', function(e) {
            var msg = e.data || {};
            if (msg.type !== 'compare-lang') return;
            panesEl.querySelectorAll('.pane').forEach(function(p){
                var f = p.querySelector('iframe');
                if (f && f.contentWindow === e.source) { p.dataset.lang = msg.lang; relabel(); }
            });
        });

        // ---- Share ----
        // Collects every pane's current code + language + version into one bundle,
        // stores it as a single snippet (existing API, no backend change), and
        // copies a short ?s=<id> link. Falls back to a languages-only link.
        function shareSetup() {
            toast('Creating share link…');
            refreshPaneCodesAsync().then(function(){
                var panes = [];
                panesEl.querySelectorAll('.pane').forEach(function(p){
                    var c = paneCodeCache[p.dataset.paneId] || {};
                    panes.push({
                        lang: canonLang(c.lang || p.dataset.lang || 'python'),
                        version: c.version || '',
                        code: c.code || ''
                    });
                });
                if (!panes.length) return;
                var bundle = { v: 1, layout: layout, theme: theme, panes: panes };
                var body = {
                    language: panes[0].lang,
                    code: JSON.stringify(bundle),
                    title: 'Polyglot Playground (' + panes.length + ' pane' + (panes.length > 1 ? 's' : '') + ')'
                };
                fetch(SNIP_API + '?action=snippet_create', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(body)
                })
                .then(function(r){ return r.json(); })
                .then(function(data){
                    if (!data || !data.id) throw new Error('no id');
                    var url = location.origin + location.pathname + '?s=' + encodeURIComponent(data.id);
                    copyLink(url, 'Share link copied — code + ' + panes.length + ' pane' + (panes.length > 1 ? 's' : ''));
                })
                .catch(function(){ shareLangsOnly(); });
            });
        }

        // Lightweight fallback: language + layout only, no code, no network.
        function shareLangsOnly() {
            var langs = [];
            panesEl.querySelectorAll('.pane').forEach(function(p){ langs.push(p.dataset.lang || 'python'); });
            var url = location.origin + location.pathname + '?panes=' + langs.join(',') +
                      '&layout=' + layout + (theme === 'light' ? '&theme=light' : '');
            copyLink(url, 'Link copied (languages only)');
        }

        function copyLink(url, msg) {
            // Use the shared ToolUtils copy helper (toast + support popup).
            if (window.ToolUtils && ToolUtils.copyToClipboard) {
                ToolUtils.copyToClipboard(url, { toastMessage: msg, showSupportPopup: true, toolName: 'Code Playground' });
                return;
            }
            // Fallback if tool-utils.js hasn't loaded — use our own toast, never a prompt().
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(url).then(function(){ toast(msg); }, function(){ toast('Copy failed — link: ' + url); });
            } else {
                toast('Copy failed — link: ' + url);
            }
        }

        var toastTimer = null;
        function toast(msg) {
            var t = document.getElementById('toast');
            t.textContent = msg;
            t.classList.add('show');
            clearTimeout(toastTimer);
            toastTimer = setTimeout(function(){ t.classList.remove('show'); }, 2200);
        }
    </script>

    <%-- Analytics + ad system (deferred to end of body for LCP) --%>
    <%@ include file="/modern/components/analytics.jsp" %>
    <%@ include file="/modern/ads/ad-init.jsp" %>

    <script type="module">
    <%@ include file="/modern/components/ai-assistant-boot.inc.jsp" %>
    import { wireLazyAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/lazy-assistant.js';

    window.playgroundAssistant = wireLazyAssistant({
      moduleUrl: '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/code-playground-ai.js',
      exportName: 'createCodePlaygroundAssistant',
      buttonId: 'btnPlaygroundAI',
      boot: aiAssistantBoot,
    });
    </script>
</body>
</html>
