<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
    String ctx = request.getContextPath();

    // Auth state for the logo + login/logout button (mirrors code-playground).
    // Uses getSession(false) so it works under session="false".
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

    // AI assistant context (billing + routing); see /modern/components/ai-assistant-*.inc.jsp
    // Tiers: anonymous → guest, logged-in → free, premium (Pro subscription) → pro.
    // requireSignIn=false so anonymous users get the guest tier instead of being blocked.
    request.setAttribute("aiToolId", "developer-tools/manic");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="/modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="manic Playground - Make Awesome Educational Videos from Code" />
        <jsp:param name="toolDescription" value="Turn a few lines of manic - a tiny animation language - into share-ready educational videos. Live editor with semantic highlighting, error checking and autocomplete; render straight to MP4 in the browser." />
        <jsp:param name="toolCategory" value="Developer Tools" />
        <jsp:param name="toolUrl" value="/manic/" />
        <jsp:param name="toolKeywords" value="manic, animation dsl, code to video, manim alternative, animation language, render mp4, playground, monaco editor" />
            <jsp:param name="toolImage" value="manic-og.png" />
        <jsp:param name="toolFeatures" value="Live semantic highlighting,Inline error checking with one-click fixes,Context-aware autocomplete,Multiple files in your workspace,Render your animation to MP4,Read the full language docs" />
    </jsp:include>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs/editor/editor.main.min.css">
    <link rel="stylesheet" href="<%=ctx%>/manic/manic.css">
    <%@ include file="/modern/components/ai-assistant-head.inc.jsp" %>
</head>
<body>

<header class="mp-bar">
    <a class="mp-logo" href="<%=ctx%>/" title="8gwifi.org Home" aria-label="8gwifi.org Home">
        <img src="<%=ctx%>/images/site/logo.svg" alt="8gwifi.org" width="26" height="26"
             onerror="this.onerror=null;this.src='<%=ctx%>/images/site/logo.png';">
    </a>
    <a class="mp-brand" href="<%=ctx%>/manic/" title="manic playground">
        <h1 class="mp-title">manic <span>playground</span></h1>
    </a>
    <span class="mp-tagline">Make awesome educational videos&nbsp;<b>✨</b>&nbsp;code it, render it, ship it</span>
    <span class="mp-spacer"></span>
    <span id="plan-info" class="mp-plan-info"></span>
    <label class="mp-plan-info" for="quality-select">quality</label>
    <select id="quality-select" class="mp-select" title="Render quality (from your plan)"></select>
    <button id="run-btn" class="mp-btn primary" title="Render (⌘/Ctrl+Enter)">Render</button>
    <button type="button" id="btnManicAI" class="mp-btn ai" title="AI assistant — describe an animation (Ctrl+Shift+A)">✨ AI</button>
    <button type="button" id="btn-share" class="mp-btn" title="Copy a link to the file open in the editor">🔗 Share</button>
    <a id="docs-link" class="mp-link" href="<%=ctx%>/manic/docs/index.html" target="_blank" rel="noopener">Docs ↗</a>
    <button id="help-btn" class="mp-btn mp-icon-btn" title="What is manic? — show the welcome">?</button>
    <button id="theme-btn" class="mp-btn mp-icon-btn" title="Toggle theme">◐</button>
    <% if (navLoggedIn) { %>
    <a class="mp-link" href="<%=navLogoutUrl%>" title="Logout">Logout</a>
    <% } else { %>
    <a class="mp-link" href="<%=navLoginUrl%>" title="Login with Google">Login</a>
    <% } %>
</header>

<div class="mp-body">
    <!-- file rail -->
    <aside class="mp-rail">
        <div class="mp-rail-head">
            <h2>Files</h2>
            <div class="mp-rail-actions">
                <button id="examples-btn" class="mp-rail-btn" title="Load a manic example">Examples</button>
                <button id="new-file-btn" class="mp-newfile" title="New file">+</button>
            </div>
        </div>
        <ul id="file-list"></ul>
    </aside>

    <!-- editor -->
    <section class="mp-editor-wrap">
        <div id="manic-editor"></div>
    </section>

    <!-- drag to resize editor / output -->
    <div class="mp-splitter" id="split-eo" title="Drag to resize"></div>

    <!-- output -->
    <section class="mp-output" id="mp-output">
        <div class="mp-output-head">
            <h2>Output</h2>
            <span id="status-line">loading…</span>
        </div>
        <div class="mp-output-body">
            <div id="editor-errors" class="mp-errpanel">
                <div class="mp-errpanel-head"><span class="mp-errpanel-icon">!</span> <span id="editor-errors-count"></span> — fix to render</div>
                <ul id="editor-errors-list" class="mp-errpanel-list"></ul>
                <div class="mp-errpanel-foot">Click an error to jump to its line.</div>
            </div>
            <div id="output-placeholder">Write manic and press <b>Render</b> to produce a video.</div>
            <div id="video-wrap">
                <video id="result-video" controls playsinline preload="metadata"></video>
                <div class="mp-video-actions">
                    <button id="download-btn" class="mp-btn primary" type="button" title="Download the rendered MP4">Download video ↓</button>
                </div>
            </div>
            <div id="error-box"></div>
        </div>
    </section>
</div>

<!-- welcome modal (first visit) -->
<div class="mp-overlay" id="welcome-overlay">
    <div class="mp-sheet mp-welcome">
        <button class="mp-sheet-close" id="welcome-close" title="Close (Esc)">&times;</button>
        <div class="mp-welcome-hero">
            <svg class="mp-motif" viewBox="0 0 320 120" preserveAspectRatio="xMidYMid meet" aria-hidden="true">
                <path class="mp-axis" d="M24 60 H300 M44 18 V102" />
                <path class="mp-wave" d="M44 60 C 84 12, 124 108, 164 60 S 244 12, 300 60" />
                <circle class="mp-spark" r="4.5" />
            </svg>
            <h2 class="mp-welcome-title">Welcome to <span>manic</span></h2>
            <p class="mp-welcome-lede">A tiny language for making animations. Write a short text file —
                manic renders a smooth, glowing video. No timeline, no keyframes: you <em>describe</em>
                what's on screen and <em>when</em> things happen.</p>
        </div>
        <div class="mp-welcome-body">
            <div class="mp-welcome-two">
                <div class="mp-welcome-col">
                    <h4><span class="mp-num">1</span> The cast</h4>
                    <p>Name the shapes on screen — a circle, a line, some text.</p>
                </div>
                <div class="mp-welcome-col">
                    <h4><span class="mp-num">2</span> The script</h4>
                    <p>Say what happens over time, by name: draw this, move that, flash it green.</p>
                </div>
            </div>
<pre class="mp-welcome-code"><code><span class="t-b">title</span>(<span class="t-s">"Hello"</span>);
<span class="t-b">canvas</span>(<span class="t-s">"16:9"</span>);

<span class="t-b">circle</span>(<span class="t-i">sun</span>, (<span class="t-n">640</span>, <span class="t-n">360</span>), <span class="t-n">90</span>);   <span class="t-x">// the cast: a circle named sun</span>
<span class="t-b">color</span>(<span class="t-i">sun</span>, <span class="t-c">cyan</span>);

<span class="t-b">show</span>(<span class="t-i">sun</span>, <span class="t-n">0.6</span>);                 <span class="t-x">// the script: fade it in</span>
<span class="t-b">pulse</span>(<span class="t-i">sun</span>);</code></pre>
            <p class="mp-welcome-hint">Then hit <b>Render</b> to turn it into an MP4. Bring an idea, or start from a gallery example.</p>
            <div class="mp-welcome-actions">
                <button class="mp-btn primary" id="welcome-start">Start writing</button>
                <button class="mp-btn" id="welcome-examples">Browse examples</button>
                <a class="mp-link" href="<%=ctx%>/manic/docs/index.html" target="_blank" rel="noopener">Read the docs ↗</a>
            </div>
        </div>
    </div>
</div>

<!-- examples picker -->
<div class="mp-overlay" id="examples-overlay">
    <div class="mp-sheet">
        <div class="mp-sheet-head">
            <div>
                <h3>Examples</h3>
                <p class="mp-sheet-sub">Every animation from the manic gallery — click one to open it as a file.</p>
            </div>
            <button class="mp-sheet-close" id="examples-close" title="Close (Esc)">&times;</button>
        </div>
        <div class="mp-sheet-body" id="examples-body"></div>
    </div>
</div>

<!-- render progress modal -->
<div class="mp-overlay" id="render-overlay">
    <div class="mp-sheet mp-render">
        <div class="mp-render-orbit" aria-hidden="true">
            <span></span><span></span><span></span>
            <div class="mp-render-core"></div>
        </div>
        <h3 class="mp-render-title">Rendering your animation…</h3>
        <p class="mp-render-sub" id="render-status">queued…</p>
        <div class="mp-render-bar"><div class="mp-render-bar-fill" id="render-bar"></div></div>
        <p class="mp-render-time"><span id="render-elapsed">0:00</span> elapsed
            &nbsp;·&nbsp; <span id="render-remaining">~3 min left</span></p>
        <div class="mp-render-tip" id="render-tip"></div>
        <button class="mp-btn" id="render-hide" title="Keep rendering; the video appears here when it's ready">
            Hide — keep rendering in the background
        </button>
    </div>
</div>

<!-- share modal -->
<div class="mp-overlay" id="share-overlay">
    <div class="mp-sheet mp-share">
        <div class="mp-sheet-head">
            <div>
                <h3>Share your animation</h3>
                <p class="mp-sheet-sub">Anyone with the link can open this file in the playground.</p>
            </div>
            <button class="mp-sheet-close" id="share-close" title="Close (Esc)">&times;</button>
        </div>
        <div class="mp-sheet-body">
            <div class="mp-share-link">
                <input type="text" id="share-url" readonly aria-label="Share link">
                <button class="mp-btn primary" id="share-copy" type="button">Copy</button>
            </div>
            <p class="mp-share-label">Post it</p>
            <div class="mp-share-grid" id="share-social"></div>
        </div>
    </div>
</div>

<div id="toast"></div>

<script>
  window.MANIC = {
    ctx: '<%=ctx%>',
    servlet: '<%=ctx%>/ManicFunctionality',
    wasmUrl: '<%=ctx%>/manic/wasm/manic_lang.js',
    docs: '<%=ctx%>/manic/docs/index.html',
    monacoBase: 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs',
    plan: 'free'
  };
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs/loader.min.js"></script>
<script src="<%=ctx%>/manic/manic-autofix.js"></script>
<script src="<%=ctx%>/manic/manic-editor.js"></script>
<script src="<%=ctx%>/manic/manic-playground.js"></script>

<!-- AI assistant: lazy-loaded on first open (button / Ctrl+Shift+A) -->
<script type="module">
<%@ include file="/modern/components/ai-assistant-boot.inc.jsp" %>
import { wireLazyAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/lazy-assistant.js';

window.manicAssistant = wireLazyAssistant({
  moduleUrl: '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/manic-ai.js',
  exportName: 'createManicAssistant',
  buttonId: 'btnManicAI',
  boot: aiAssistantBoot,
});
</script>
<%@ include file="/modern/components/analytics.jsp" %>
</body>
</html>
