<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String ctx = request.getContextPath();
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<meta name="robots" content="index,follow"/>

<!-- Resource Hints -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="dns-prefetch" href="https://cdnjs.cloudflare.com">

<!-- Critical CSS -->
<style>
    *{box-sizing:border-box;margin:0;padding:0}
    html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
    body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
</style>

<!-- SEO -->
<jsp:include page="/modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Free AI-Powered LaTeX Editor - Write, Fix and Compile Instantly" />
    <jsp:param name="toolDescription" value="Free AI-powered online LaTeX editor with instant PDF compilation. AI fixes errors automatically, generates LaTeX from plain English, and rewrites text in academic style. Real-time preview, 170+ autocomplete commands, syntax highlighting. No signup required." />
    <jsp:param name="toolCategory" value="Developer Tools" />
    <jsp:param name="toolUrl" value="latex/editor.jsp" />
    <jsp:param name="toolKeywords" value="ai latex editor, latex editor online, ai latex generator, online latex compiler, latex to pdf, free latex editor, overleaf alternative, ai latex error fix, natural language to latex, latex editor free, write latex online, ai powered latex, latex compiler online, latex pdf preview, latex syntax highlighting, ai academic writing" />
    <jsp:param name="toolImage" value="latex-editor.svg" />
    <jsp:param name="toolFeatures" value="AI error fix - automatically corrects LaTeX compilation errors,AI LaTeX generator - describe in English and get LaTeX code,AI rewrite - restyle text as formal academic or concise or expanded,Real-time PDF preview,LaTeX syntax highlighting,170+ autocomplete commands,Symbol picker with Greek Math and Arrows,Multiple templates (Article Report Beamer CV Letter),File upload for images,Download PDF and .tex source,Project save to localStorage,Dark and light theme support,No registration required" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Write or Generate LaTeX|Write LaTeX code with 170+ autocomplete commands or press Ctrl+Shift+A to describe what you want in plain English and let AI generate the LaTeX for you,Compile to PDF|Click Compile or press Ctrl+Enter to generate the PDF using pdfLaTeX. If there are errors the AI Fix button appears to correct them automatically,Preview and Download|Preview the PDF in the right pane then download the PDF or .tex source file. Select any text and click Rewrite to improve it with AI" />
    <jsp:param name="faq1q" value="What is this AI-powered LaTeX editor?" />
    <jsp:param name="faq1a" value="A free browser-based LaTeX editor with built-in AI that compiles documents to PDF in real-time. The AI can fix compilation errors automatically, generate LaTeX from plain English descriptions, and rewrite selected text in formal academic, concise, or expanded style." />
    <jsp:param name="faq2q" value="How does the AI LaTeX generator work?" />
    <jsp:param name="faq2a" value="Press Ctrl+Shift+A or click the AI button in the toolbar, then describe what you want in plain English such as a 3x3 matrix or a table comparing algorithms. The AI streams valid LaTeX code directly into your editor at the cursor position." />
    <jsp:param name="faq3q" value="Can AI fix my LaTeX errors?" />
    <jsp:param name="faq3a" value="Yes. When compilation fails, an AI Fix button appears on each error. Click it and the AI reads the error message and surrounding code, then replaces the broken lines with corrected LaTeX automatically." />
    <jsp:param name="faq4q" value="Is this a free alternative to Overleaf?" />
    <jsp:param name="faq4a" value="Yes. This editor offers everything Overleaf does including real-time PDF preview, syntax highlighting, autocomplete, templates, and file uploads plus AI-powered error fixing, code generation, and text rewriting. Completely free with no account required." />
    <jsp:param name="faq5q" value="Are my documents saved?" />
    <jsp:param name="faq5a" value="Yes, all projects are auto-saved to your browser localStorage. You can create multiple projects, rename them, and switch between them from the Projects menu." />
    <jsp:param name="faq6q" value="Which LaTeX packages are supported?" />
    <jsp:param name="faq6a" value="The server runs a full TeX Live distribution so all standard packages like amsmath, graphicx, tikz, hyperref, booktabs, listings, and thousands more are available." />
</jsp:include>

<!-- Fonts -->
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
<noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

<!-- System CSS -->
<link rel="stylesheet" href="<%=ctx%>/modern/css/design-system.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/navigation.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/tool-page.css">
<link rel="preload" href="<%=ctx%>/modern/css/ads.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<link rel="preload" href="<%=ctx%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<link rel="preload" href="<%=ctx%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<link rel="preload" href="<%=ctx%>/modern/css/search.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<noscript>
    <link rel="stylesheet" href="<%=ctx%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=ctx%>/modern/css/dark-mode.css">
    <link rel="stylesheet" href="<%=ctx%>/modern/css/footer.css">
    <link rel="stylesheet" href="<%=ctx%>/modern/css/search.css">
</noscript>

<!-- CodeMirror CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/codemirror.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/theme/material-darker.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/addon/hint/show-hint.min.css"/>

<!-- LaTeX Editor CSS -->
<%  long cssV = System.currentTimeMillis(); %>
<link rel="stylesheet" href="<%=ctx%>/latex/static/css/layout.css?v=<%=cssV%>"/>
<link rel="stylesheet" href="<%=ctx%>/latex/static/css/editor.css?v=<%=cssV%>"/>
<link rel="stylesheet" href="<%=ctx%>/latex/static/css/toolbar.css?v=<%=cssV%>"/>
<link rel="stylesheet" href="<%=ctx%>/latex/static/css/image-to-latex.css?v=<%=cssV%>"/>

<%@ include file="/modern/ads/ad-init.jsp" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

</head>
<body>

<!-- Server config injected at page load -->
<script>
  var CONFIG = {
    ctx: "<%=ctx%>",
    projectId: "<%= request.getAttribute("projectId") != null ? request.getAttribute("projectId") : "" %>",
    compileUrl: "<%=ctx%>/compile",
    logsUrl: "<%=ctx%>/logs",
    pdfUrl: "<%=ctx%>/pdf",
    uploadUrl: "<%=ctx%>/upload",
    jobsUrl: "<%=ctx%>/jobs",
    aiUrl: "<%=ctx%>/ai"
  };
</script>

<!-- Navigation -->
<%@ include file="/modern/components/nav-header.jsp" %>

<!-- ========== HERO SECTION — SEO heading + Ad placement ========== -->
<section class="latex-hero" id="latex-hero">
  <div class="latex-hero-content">
    <h1 class="latex-hero-title">Free AI-Powered LaTeX Editor</h1>
    <p class="latex-hero-desc">Write, generate and compile LaTeX to PDF with AI. Fix errors, generate code from English, rewrite text. No signup.</p>
  </div>
  <div class="latex-hero-ad">
    <%@ include file="/modern/ads/ad-hero-banner.jsp" %>
  </div>
  <button class="latex-hero-dismiss" id="hero-dismiss" onclick="dismissHero()" title="Collapse">&times;</button>
</section>

<!-- ========== LATEX EDITOR APP — fills viewport below nav ========== -->
<div class="latex-app" id="latex-app">

  <!-- Title bar -->
  <div class="titlebar">
    <div class="titlebar-logo">
      <svg viewBox="0 0 24 24" fill="none" width="18" height="18">
        <path d="M4 6h16M4 10h16M4 14h10M4 18h7" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
        <circle cx="19" cy="17" r="3" stroke="currentColor" stroke-width="1.5"/>
        <path d="M21.5 19.5L23 21" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
      </svg>
      LaTeX Editor
    </div>
    <div class="titlebar-project">
      <span class="sep">/</span>
      <span class="project-name" id="project-name" onclick="renameProject()" title="Click to rename">Untitled Document</span>
      <span class="save-indicator" id="save-indicator"></span>
    </div>
    <div class="titlebar-right">
      <button class="nav-btn" onclick="showProjectMenu()" id="btn-project-menu" title="Projects">&#9776; Projects</button>
      <a href="<%=ctx%>/" class="nav-btn" style="text-decoration:none">8gwifi.org</a>
    </div>
  </div>

  <!-- Toolbar -->
  <div id="toolbar">
    <%@ include file="partials/toolbar.jsp" %>
  </div>

  <!-- Mobile file drawer backdrop -->
  <div class="filetree-backdrop" id="filetree-backdrop" onclick="closeMobileDrawer()"></div>

  <!-- Main layout -->
  <div class="main">
    <!-- File tree sidebar (slide-in drawer on mobile) -->
    <div class="filetree" id="file-tree">
      <%@ include file="partials/filetree.jsp" %>
    </div>

    <!-- Editor pane -->
    <div class="editor-pane">
      <div class="editor-tabs" id="editor-tabs">
        <div class="editor-tab active" data-file="main.tex">main.tex</div>
      </div>
      <div class="editor-body">
        <div id="codemirror-container"></div>
      </div>
    </div>

    <!-- PDF Preview pane -->
    <div class="preview-pane">
      <div class="preview-toolbar">
        <button class="preview-btn" id="btn-view-canvas" onclick="setPreviewMode('canvas')" title="Canvas view (page-by-page)">Canvas</button>
        <button class="preview-btn active" id="btn-view-native" onclick="setPreviewMode('native')" title="Native PDF viewer (text select, scroll, links)">PDF</button>
        <div class="preview-sep"></div>
        <button class="preview-btn" id="btn-prev-page" onclick="prevPage()">&#9664;</button>
        <span class="page-info" id="page-info">0 / 0</span>
        <button class="preview-btn" id="btn-next-page" onclick="nextPage()">&#9654;</button>
        <div class="preview-sep"></div>
        <button class="preview-btn" onclick="zoomOut()">-</button>
        <span class="zoom-level" id="zoom-level">100%</span>
        <button class="preview-btn" onclick="zoomIn()">+</button>
        <button class="preview-btn" style="margin-left:auto" onclick="toggleFullPreview()">&#10530; Full</button>
      </div>

      <div class="preview-body" id="preview-body">
        <!-- Native PDF embed (default) -->
        <iframe id="pdf-iframe" class="pdf-iframe" style="display:none"></iframe>

        <!-- Canvas fallback (PDF.js page-by-page) -->
        <canvas id="pdf-canvas" style="display:none"></canvas>

        <div class="compiling-overlay" id="pdf-loading">
          <div class="spinner"></div>
          <div class="spinner-text">Compiling...</div>
        </div>
        <div class="empty-preview" id="empty-preview">
          <div class="empty-preview-icon">&#128196;</div>
          <div class="empty-preview-text">Click <b>Compile</b> to generate PDF preview</div>
        </div>
      </div>
    </div>
  </div>

  <!-- Log panel -->
  <div class="log-panel collapsed" id="log-panel">
    <%@ include file="partials/logpanel.jsp" %>
  </div>

  <!-- Status bar -->
  <div class="statusbar">
    <span class="sb-item accent" id="sb-engine">&#9679; pdfLaTeX</span>
    <span class="sb-sep"></span>
    <span class="sb-item" id="sb-cursor">Ln 1, Col 1</span>
    <span class="sb-sep"></span>
    <span class="sb-item sb-errors" id="sb-errors" style="display:none" onclick="nextError()"></span>
    <span class="sb-sep"></span>
    <span class="sb-item ai-status" id="sb-ai-status" style="display:none"></span>
    <span class="sb-sep"></span>
    <span class="sb-item">UTF-8</span>
  </div>

</div><!-- /.latex-app -->

<!-- Mobile FAB: toggle editor ↔ preview (visible only on mobile) -->
<button class="mobile-fab" id="mobile-fab" onclick="toggleMobileView()">
  <span id="fab-icon">&#128196;</span>
  <span class="fab-label" id="fab-label">Preview</span>
</button>

<!-- AI Prompt popup -->
<div class="ai-prompt-popup" id="ai-prompt-popup">
  <div class="ai-prompt-header">
    <span class="ai-prompt-icon">&#10024;</span>
    <span class="ai-prompt-title">Describe LaTeX to generate</span>
    <span class="ai-prompt-close" onclick="toggleAIPrompt()">&times;</span>
  </div>
  <div class="ai-prompt-body">
    <textarea id="ai-prompt-input" class="ai-prompt-input" rows="3"
      placeholder="e.g. &quot;3x3 identity matrix&quot; or &quot;table comparing sorting algorithms&quot;"
      onkeydown="handleAIPromptKey(event)"></textarea>
    <div class="ai-prompt-actions">
      <span class="ai-prompt-hint">Enter to submit &middot; Esc to close</span>
      <button class="ai-prompt-submit" onclick="submitAIPrompt()">Generate &#8594;</button>
    </div>
  </div>
</div>

<!-- AI Rewrite menu -->
<div class="ai-rewrite-menu" id="ai-rewrite-menu">
  <div class="ai-rw-header">Rewrite selection as...</div>
  <button class="ai-rw-item" onclick="rewriteSelection('formal'); document.getElementById('ai-rewrite-menu').classList.remove('visible')">&#127891; Formal Academic</button>
  <button class="ai-rw-item" onclick="rewriteSelection('concise'); document.getElementById('ai-rewrite-menu').classList.remove('visible')">&#9986; Concise</button>
  <button class="ai-rw-item" onclick="rewriteSelection('expand'); document.getElementById('ai-rewrite-menu').classList.remove('visible')">&#128214; Expand with Detail</button>
</div>

<!-- Symbol picker popup (fixed position, outside app flow) -->
<div class="symbol-picker" id="symbol-picker">
  <div class="sp-header">
    <input class="sp-search" type="text" placeholder="Search symbols..." oninput="filterSymbols(this.value)"/>
  </div>
  <div class="sp-tabs" id="sp-tabs"></div>
  <div class="sp-grid" id="sp-grid"></div>
</div>

<!-- Project manager popup -->
<div class="project-menu" id="project-menu">
  <div class="pm-header">Saved Projects</div>
  <div class="pm-list" id="pm-list"></div>
  <div class="pm-actions">
    <button class="pm-btn" onclick="newProject()">+ New Project</button>
    <button class="pm-btn" onclick="exportProject()">&#8595; Export .tex</button>
    <button class="pm-btn danger" onclick="deleteCurrentProject()">&#10005; Delete</button>
  </div>
</div>

<!-- Related Tools (below the fold — user scrolls past editor to see) -->
<jsp:include page="/modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="editor"/>
    <jsp:param name="category" value="Developer Tools"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- Support Section -->
<%@ include file="/modern/components/support-section.jsp" %>

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=ctx%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=ctx%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="/modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="/modern/components/analytics.jsp" %>

<!-- System JS -->
<script src="<%=ctx%>/modern/js/tool-utils.js" defer></script>
<script src="<%=ctx%>/modern/js/dark-mode.js" defer></script>
<script src="<%=ctx%>/modern/js/search.js" defer></script>

<!-- CDN Libraries -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/codemirror.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/mode/stex/stex.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/addon/edit/matchbrackets.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/addon/edit/closebrackets.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/addon/hint/show-hint.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/addon/selection/active-line.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>

<!-- Hero section controller -->
<script>
(function() {
  var HERO_DISMISSED_KEY = 'latex_hero_dismissed';

  function measureHero() {
    var hero = document.getElementById('latex-hero');
    var app = document.getElementById('latex-app');
    if (!app) return;
    if (!hero || hero.classList.contains('dismissed')) {
      app.style.setProperty('--hero-h', '0px');
      return;
    }
    var h = hero.offsetHeight;
    app.style.setProperty('--hero-h', h + 'px');
  }

  window.dismissHero = function() {
    var hero = document.getElementById('latex-hero');
    if (hero) hero.classList.add('dismissed');
    try { localStorage.setItem(HERO_DISMISSED_KEY, '1'); } catch(e) {}
    measureHero();
  };

  // Restore dismissed state
  try {
    if (localStorage.getItem(HERO_DISMISSED_KEY) === '1') {
      var hero = document.getElementById('latex-hero');
      if (hero) hero.classList.add('dismissed');
    }
  } catch(e) {}

  // Measure on load + resize
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', measureHero);
  } else {
    measureHero();
  }
  window.addEventListener('resize', measureHero);
})();
</script>

<!-- App JS -->
<%  long jsV = System.currentTimeMillis(); %>
<script src="<%=ctx%>/latex/static/js/storage.js?v=<%=jsV%>"></script>
<script src="<%=ctx%>/latex/static/js/symbols.js?v=<%=jsV%>"></script>
<script src="<%=ctx%>/latex/static/js/editor.js?v=<%=jsV%>"></script>
<script src="<%=ctx%>/latex/static/js/preview.js?v=<%=jsV%>"></script>
<script src="<%=ctx%>/latex/static/js/compile.js?v=<%=jsV%>"></script>
<script src="<%=ctx%>/latex/static/js/ai.js?v=<%=jsV%>"></script>
<script src="<%=ctx%>/latex/static/js/image-to-latex.js?v=<%=jsV%>"></script>

</body>
</html>
