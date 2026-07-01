<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String ctx = request.getContextPath();
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    request.setAttribute("aiToolId", "latex/editor");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="/modern/components/ai-assistant-vars.inc.jsp" %>
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
    /* ═══════════════════════════════════════════════════════
       DESIGN TOKENS — Morphous Indigo Milkcap
       System: /systems/morphous-indigo-milkcap/system.json
       Light defaults at :root, dark via [data-theme="dark"].
       Legacy aliases (--primary, --bg-primary, etc.) keep existing
       site CSS (design-system.css, tool-page.css) working without
       per-rule rewrites.
       ═══════════════════════════════════════════════════════ */
    :root {
      /* Indigo Milkcap — light */
      --background: oklch(0.971 0.007 247.9);
      --foreground: oklch(0.183 0.031 263.4);
      --card: oklch(0.981 0.005 258.3);
      --card-foreground: oklch(0.183 0.031 263.4);
      --popover: oklch(0.981 0.005 258.3);
      --popover-foreground: oklch(0.183 0.031 263.4);
      --primary-im: oklch(0.381 0.146 264.1);
      --primary-foreground: oklch(0.981 0.005 258.3);
      --secondary: oklch(0.929 0.015 260.7);
      --secondary-foreground: oklch(0.225 0.061 264.4);
      --muted: oklch(0.929 0.015 260.7);
      --muted-foreground: oklch(0.372 0.039 257.3);
      --accent: oklch(0.581 0.229 263.9);
      --accent-foreground: oklch(0.981 0.005 258.3);
      --destructive: oklch(0.446 0.052 336.5);
      --border-im: oklch(0.883 0.020 260.2);
      --input: oklch(0.883 0.020 260.2);
      --ring: oklch(0.581 0.229 263.9);
      --chart-1: oklch(0.381 0.146 264.1);
      --chart-2: oklch(0.581 0.229 263.9);
      --chart-3: oklch(0.371 0.062 159.3);
      --chart-4: oklch(0.732 0.089 266.9);
      --chart-5: oklch(0.496 0.054 150.0);
      --sidebar: oklch(0.929 0.015 260.7);
      --sidebar-foreground: oklch(0.183 0.031 263.4);
      --sidebar-primary: oklch(0.381 0.146 264.1);
      --sidebar-primary-foreground: oklch(0.981 0.005 258.3);
      --sidebar-accent: oklch(0.827 0.034 255.2);
      --sidebar-accent-foreground: oklch(0.381 0.146 264.1);
      --sidebar-border: oklch(0.883 0.020 260.2);
      --sidebar-ring: oklch(0.581 0.229 263.9);
      --radius: 0.5rem;

      /* Legacy aliases — what existing rules (and external CSS files)
         expect. Mapped onto the Indigo Milkcap tokens above. */
      --primary:        var(--primary-im);
      --primary-dark:   oklch(0.300 0.130 264.1);
      --bg-primary:     var(--background);
      --bg-secondary:   var(--secondary);
      --text-primary:   var(--foreground);
      --text-secondary: var(--muted-foreground);
      --border:         var(--border-im);
    }

    [data-theme="dark"] {
      /* Indigo Milkcap — dark */
      --background: oklch(0.183 0.031 263.4);
      --foreground: oklch(0.981 0.005 258.3);
      --card: oklch(0.225 0.061 264.4);
      --card-foreground: oklch(0.981 0.005 258.3);
      --popover: oklch(0.225 0.061 264.4);
      --popover-foreground: oklch(0.981 0.005 258.3);
      --primary-im: oklch(0.655 0.183 266.5);
      --primary-foreground: oklch(0.183 0.031 263.4);
      --secondary: oklch(0.260 0.040 161.8);
      --secondary-foreground: oklch(0.981 0.005 258.3);
      --muted: oklch(0.315 0.036 258.3);
      --muted-foreground: oklch(0.827 0.034 255.2);
      --accent: oklch(0.581 0.229 263.9);
      --accent-foreground: oklch(0.981 0.005 258.3);
      --destructive: oklch(0.446 0.052 336.5);
      --border-im: oklch(1 0 0 / 12%);
      --input: oklch(1 0 0 / 16%);
      --ring: oklch(0.655 0.183 266.5);
      --chart-1: oklch(0.655 0.183 266.5);
      --chart-2: oklch(0.581 0.229 263.9);
      --chart-3: oklch(0.496 0.054 150.0);
      --chart-4: oklch(0.732 0.089 266.9);
      --chart-5: oklch(0.775 0.035 143.9);
      --sidebar: oklch(0.225 0.061 264.4);
      --sidebar-foreground: oklch(0.981 0.005 258.3);
      --sidebar-primary: oklch(0.655 0.183 266.5);
      --sidebar-primary-foreground: oklch(0.183 0.031 263.4);
      --sidebar-accent: oklch(0.314 0.081 264.3);
      --sidebar-accent-foreground: oklch(0.981 0.005 258.3);
      --sidebar-border: oklch(1 0 0 / 12%);
      --sidebar-ring: oklch(0.655 0.183 266.5);

      /* Legacy aliases — dark variants */
      --primary:        var(--primary-im);
      --primary-dark:   oklch(0.555 0.165 266.5);
      --bg-primary:     var(--background);
      --bg-secondary:   var(--card);
      --text-primary:   var(--foreground);
      --text-secondary: var(--muted-foreground);
      --border:         var(--border-im);
    }

    *{box-sizing:border-box;margin:0;padding:0}
    html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
    body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:oklch(0.183 0.031 263.4);background:oklch(0.971 0.007 247.9);margin:0}
</style>

<!-- SEO -->
<jsp:include page="/modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Free AI LaTeX Editor with Math Solver and Run Code in 20 Languages" />
    <jsp:param name="toolDescription" value="Free AI-powered online LaTeX editor with a built-in symbolic math solver and inline code runner. Select any integral, derivative, limit, or matrix to solve with step-by-step LaTeX. Run Java, Python, C, C++, Go, Rust, JavaScript, and 13 more languages directly from your document - stdout and stderr are inserted as styled LaTeX. AI fixes compilation errors, generates LaTeX from plain English, renders chemistry structures (Lewis, 2D, 3D). Real-time PDF preview, 170+ autocomplete commands. No signup." />
    <jsp:param name="toolCategory" value="Developer Tools" />
    <jsp:param name="toolUrl" value="latex/editor.jsp" />
    <jsp:param name="toolKeywords" value="latex run code, latex code execution, executable latex, latex python runner, latex java compiler, run code in latex, latex math solver, ai latex editor, latex integral calculator, latex derivative calculator, latex limit calculator, latex matrix calculator, solve equation in latex, step by step math latex, latex editor online, ai latex generator, online latex compiler, latex to pdf, free latex editor, overleaf alternative, multi-file code latex, latex listings run, ai latex error fix, natural language to latex, latex chemistry editor, lewis structure latex, mhchem editor, latex syntax highlighting" />
    <jsp:param name="toolImage" value="latex-editor.png" />
    <jsp:param name="toolFeatures" value="Run code inline - execute Java Python C C++ Go Rust JavaScript and 13 more languages directly in your LaTeX document,Multi-file projects - adjacent lstlisting blocks with name= group automatically into one run,Captured stdout and stderr inserted as styled LaTeX (green or red bar) into a fresh solution file,Built-in math solver - select any equation and solve integrals derivatives limits and matrix operations inline,Step-by-step solutions inserted as LaTeX with full working,Symbolic math engine - nerdamer plus SymPy backend for exact answers,2D geometric viz for 2x2 matrix operations (parallelogram, eigenvectors),Chemistry rendering - Lewis dot SMILES 2D and 3D geometry from \ce{} formulas,Generated work routed to per-solution files (solution-001.tex) so the main document stays clean,AI error fix - automatically corrects LaTeX compilation errors,AI LaTeX generator - describe in English and get LaTeX code,AI rewrite - restyle text as formal academic or concise or expanded,Image to LaTeX - drag a screenshot of an equation and get LaTeX source,Real-time PDF preview,LaTeX syntax highlighting,170+ autocomplete commands,Symbol picker with Greek Math and Arrows,Polished templates (Article Report Beamer CV Letter Chemistry Calculus Linear Algebra Run Code),Voice to LaTeX dictation,Download PDF and .tex source,Project auto-save to localStorage,Dark and light theme support,No registration required" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Write or Generate LaTeX|Write LaTeX code with 170+ autocomplete commands or press Ctrl+Shift+A to describe what you want in plain English and let AI generate the LaTeX for you,Solve math inline|Select any integral derivative limit or matrix in your document and click the Σ Solve button in the popup. The answer and full step-by-step working are inserted as LaTeX in a fresh solution file right next to your equation,Run code inline|Select any lstlisting block with language=X and click the ▶ Run button. Output (stdout or stderr) is captured and inserted as styled LaTeX. Multi-file projects are detected automatically when adjacent blocks share the same language,Compile to PDF|Click Compile or press Ctrl+Enter to generate the PDF using pdfLaTeX. If there are errors the AI Fix button appears to correct them automatically,Preview and Download|Preview the PDF in the right pane then download the PDF or .tex source file. Select any text and click Rewrite to improve it with AI" />
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
    <jsp:param name="faq7q" value="Can I solve math equations directly in the LaTeX editor?" />
    <jsp:param name="faq7a" value="Yes. Select any integral, derivative, or limit expression (LaTeX or inline math) and a Σ Solve button appears in the popup. The editor recognises the operator, solves it symbolically with nerdamer (or the SymPy backend for harder cases), and inserts the result plus full step-by-step working as LaTeX directly into a fresh solution file. Side-by-side graphs are optional. Try the Calculus template for a worked example." />
    <jsp:param name="faq8q" value="How is the math worked out — are the step-by-step solutions accurate?" />
    <jsp:param name="faq8a" value="The editor uses two symbolic-math engines. Simple expressions run client-side through nerdamer for instant answers; trickier integrals (partial fractions, trig substitutions, integration by parts) are routed to a SymPy backend which produces textbook-quality step-by-step derivations. Derivatives use the product, quotient, and chain rules explicitly; limits try direct substitution, factoring, conjugate multiplication, and L'Hôpital's rule. Every step is shown as proper LaTeX so you can verify the working in your own PDF." />
    <jsp:param name="faq9q" value="Can I run code directly from inside my LaTeX document?" />
    <jsp:param name="faq9a" value="Yes. Any lstlisting block with [language=X] (or a leading % run: X comment) becomes runnable. Select the block, click the ▶ Run button in the floating menu, and the captured stdout is inserted as a green-bordered LaTeX box right after the code (red-bordered if the program errors). 20 languages are supported: Java, Python, C, C++, C#, Go, Rust, JavaScript, TypeScript, Ruby, PHP, Perl, Bash, Lua, R, Haskell, Kotlin, Scala, Swift, and Dart. Powered by the same OneCompiler engine that backs the dedicated /online-X-compiler tools." />
    <jsp:param name="faq10q" value="Does the run-code feature support multi-file projects (Java with two classes, C with headers)?" />
    <jsp:param name="faq10a" value="Yes. Place adjacent lstlisting blocks with the same language= and distinct name= attributes (for example name=Hello.java and name=Greeter.java). When you select all of them and click ▶ Run, the editor bundles them as a multi-file project. The popup label changes to ▶ Run Java (2 files) so you can confirm the grouping before running. Files are sent to the backend as a files array exactly the way the dedicated compiler tools do." />
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
<link rel="stylesheet" href="<%=ctx%>/modern/css/speech-to-text.css?v=<%=cssV%>"/>
<%@ include file="/modern/components/ai-assistant-head.inc.jsp" %>

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
<section class="latex-hero latex-hero-slim" id="latex-hero">
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
      <button class="nav-btn-primary" onclick="newProject()" id="btn-new-project" title="Start a fresh project">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        New&nbsp;project
      </button>
      <button class="nav-btn-secondary" onclick="showProjectMenu()" id="btn-project-menu" title="Open or manage saved projects">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14"><path d="M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
        Projects
      </button>
      <button class="nav-btn-secondary" onclick="openAbout()" id="btn-about" title="About this editor — features &amp; what makes it different">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14"><circle cx="12" cy="12" r="9"/><line x1="12" y1="11" x2="12" y2="16"/><circle cx="12" cy="8" r="0.6" fill="currentColor"/></svg>
        About
      </button>
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

<!-- About / Killer features — most users assume this is "just another LaTeX editor"
     so we showcase the things that aren't elsewhere -->
<style>
  .latex-about{padding:3rem 1.5rem;background:var(--bg-secondary,#f1f5f9);border-top:1px solid var(--border,#e2e8f0)}
  .latex-about-inner{max-width:1100px;margin:0 auto}
  .latex-about-eyebrow{display:inline-block;font-size:0.75rem;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:oklch(0.371 0.062 159.3);background:oklch(0.371 0.062 159.3 / 0.12);padding:4px 10px;border-radius:999px;margin-bottom:0.6rem}
  .latex-about-title{font-size:1.75rem;font-weight:700;color:var(--text-primary,#0f172a);margin:0 0 0.5rem}
  .latex-about-subtitle{font-size:1rem;color:var(--text-secondary,#475569);margin:0 0 2rem;max-width:720px;line-height:1.55}
  .latex-about-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:1rem}
  .latex-about-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:12px;padding:1.25rem;position:relative;transition:transform 0.15s ease,box-shadow 0.15s ease}
  .latex-about-card:hover{transform:translateY(-2px);box-shadow:0 8px 24px oklch(0.183 0.031 263.4 / 0.06)}
  .latex-about-icon{font-size:1.6rem;line-height:1;margin-bottom:0.6rem;display:block}
  .latex-about-card h3{font-size:1rem;font-weight:600;color:var(--text-primary,#0f172a);margin:0 0 0.4rem;display:flex;align-items:center;gap:0.4rem;flex-wrap:wrap}
  .latex-about-card p{font-size:0.85rem;color:var(--text-secondary,#475569);line-height:1.5;margin:0}
  .latex-about-card code{font-family:'JetBrains Mono',ui-monospace,monospace;font-size:0.78rem;background:oklch(0.581 0.229 263.9 / 0.12);color:oklch(0.381 0.146 264.1);padding:1px 5px;border-radius:4px}
  .latex-about-badge{font-size:0.62rem;font-weight:700;letter-spacing:0.06em;color:#fff;background:linear-gradient(135deg,oklch(0.496 0.054 150.0),oklch(0.371 0.062 159.3));padding:2px 7px;border-radius:6px;text-transform:uppercase}
  .latex-about-cta{margin-top:1.75rem;font-size:0.9rem;color:var(--text-secondary,#475569)}
  .latex-about-cta a{color:oklch(0.381 0.146 264.1);font-weight:600;text-decoration:none}
  .latex-about-cta a:hover{text-decoration:underline}
  [data-theme="dark"] .latex-about{background:oklch(0.183 0.031 263.4);border-top-color:oklch(0.225 0.061 264.4)}
  [data-theme="dark"] .latex-about-card{background:oklch(0.225 0.061 264.4);border-color:oklch(1 0 0 / 12%)}
  [data-theme="dark"] .latex-about-card code{background:oklch(0.655 0.183 266.5 / 0.18);color:oklch(0.732 0.089 266.9)}

  /* ── Slim hero: ad strip only (H1 moved into the About modal) ── */
  .latex-hero-slim{padding:6px 20px;min-height:0}
  .latex-hero-slim .latex-hero-ad{width:100%}

  /* ── About as a modal overlay (opened by the About button) ── */
  .latex-about-overlay{position:fixed;inset:0;z-index:1000;background:oklch(0.183 0.031 263.4 / 0.55);backdrop-filter:blur(2px);display:flex;align-items:flex-start;justify-content:center;padding:5vh 16px;overflow-y:auto;overscroll-behavior:contain}
  .latex-about-overlay[hidden]{display:none}
  .latex-about-overlay .latex-about{border-top:none;border-radius:16px;max-width:1000px;width:100%;margin:auto;padding:2.25rem 2rem 2.5rem;position:relative;box-shadow:0 24px 70px oklch(0.183 0.031 263.4 / 0.45);animation:latexAboutIn .18s ease}
  @keyframes latexAboutIn{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:none}}
  .latex-about-h1{font-size:1.55rem;font-weight:800;color:var(--text-primary,#0f172a);margin:0 0 0.75rem;line-height:1.2}
  .latex-about-close{position:absolute;top:12px;right:14px;width:34px;height:34px;border:none;border-radius:9px;background:var(--bg-secondary,#f1f5f9);color:var(--text-secondary,#475569);font-size:22px;line-height:1;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:background .15s,color .15s}
  .latex-about-close:hover{background:oklch(0.581 0.229 263.9 / 0.12);color:var(--text-primary,#0f172a)}
  [data-theme="dark"] .latex-about-overlay{background:oklch(0 0 0 / 0.6)}
  [data-theme="dark"] .latex-about-h1{color:#fff}
  [data-theme="dark"] .latex-about-close{background:oklch(0.225 0.061 264.4);color:oklch(0.732 0.089 266.9)}
  body.latex-about-open{overflow:hidden}
</style>
<div class="latex-about-overlay" id="latex-about-overlay" hidden onclick="if(event.target===this)closeAbout()">
<section class="latex-about" id="latex-about" role="dialog" aria-modal="true" aria-labelledby="latex-about-h1">
  <button class="latex-about-close" onclick="closeAbout()" aria-label="Close about" title="Close">&times;</button>
  <div class="latex-about-inner">
    <h1 class="latex-about-h1" id="latex-about-h1">Free AI LaTeX Editor with Math Solver &amp; Run Code</h1>
    <span class="latex-about-eyebrow">More than a LaTeX editor</span>
    <h2 class="latex-about-title">What this editor does that others don't</h2>
    <p class="latex-about-subtitle">A full LaTeX compiler with an <strong>inline code runner (20 languages)</strong>, <strong>built-in symbolic math solver</strong>, chemistry rendering, AI assistance, and image-to-code conversion. Everything runs in your browser — no signup, no install, no Overleaf account.</p>

    <div class="latex-about-grid">

      <div class="latex-about-card">
        <span class="latex-about-icon">&#9654;</span>
        <h3>Run code inline <span class="latex-about-badge">New</span></h3>
        <p>Select any <code>lstlisting</code> block with <code>[language=X]</code> and click <strong>▶ Run</strong>. Output (stdout or stderr) is captured and inserted as a green or red-bordered LaTeX box, right after the code. <strong>20 languages</strong> supported — Java, Python, C, C++, C#, Go, Rust, JavaScript, Ruby, PHP, Bash, and more. <strong>Multi-file projects</strong> work: adjacent blocks with <code>name=</code> group automatically. Same engine as the dedicated <code>/online-X-compiler</code> tools.</p>
      </div>

      <div class="latex-about-card">
        <span class="latex-about-icon">&#931;</span>
        <h3>Math solver</h3>
        <p>Select any <code>\int</code>, <code>\frac{d}{dx}</code>, <code>\lim</code>, or matrix operation (<code>\det A</code>, <code>A^{-1}</code>, eigenvalues, …) and hit <strong>Σ Solve</strong>. The answer and a full <strong>step-by-step derivation</strong> are inserted as LaTeX into a fresh <code>solution-001.tex</code>. Powered by nerdamer + SymPy for partial fractions, trig substitutions, L'Hôpital, cofactor expansion, and more — optional pgfplots graph or geometric viz included.</p>
      </div>

      <div class="latex-about-card">
        <span class="latex-about-icon">&#9883;</span>
        <h3>Chemistry rendering</h3>
        <p>Select any <code>\ce{H2O}</code> or <code>\ce{2H2 + O2 -&gt; 2H2O}</code> and choose <strong>Lewis dot</strong>, <strong>SMILES 2D</strong>, or <strong>3D geometry</strong>. The structure renders as an image with a property table (geometry, polarity, mol. weight, hybridization, etc.) inserted as a ready figure.</p>
      </div>

      <div class="latex-about-card">
        <span class="latex-about-icon">&#10024;</span>
        <h3>AI assistant</h3>
        <p>Describe LaTeX in plain English and get code (<code>Ctrl+Shift+A</code>). When compilation fails, click <strong>AI Fix</strong> on the error to repair it automatically. Rewrite selections as formal academic, concise, or expanded tone.</p>
      </div>

      <div class="latex-about-card">
        <span class="latex-about-icon">&#128247;</span>
        <h3>Image to LaTeX</h3>
        <p>Drag a screenshot of a math equation, table, or matrix into the editor — vision AI converts it into LaTeX source you can edit. Works for handwritten equations, textbook scans, and whiteboard photos.</p>
      </div>

      <div class="latex-about-card">
        <span class="latex-about-icon">&#9889;</span>
        <h3>Real-time PDF preview</h3>
        <p>Full TeX Live distribution on the server — every package you need (mhchem, tikz, hyperref, booktabs, listings, &hellip; thousands more). Compile with <code>Ctrl+Enter</code>, preview as native PDF or page-by-page canvas.</p>
      </div>

      <div class="latex-about-card">
        <span class="latex-about-icon">&#9000;</span>
        <h3>Smart editor</h3>
        <p>170+ autocomplete commands, syntax highlighting, bracket matching, symbol picker (Greek, math, arrows), multi-file projects with <code>\input{}</code>, voice-to-LaTeX dictation, and inline error markers.</p>
      </div>

      <div class="latex-about-card">
        <span class="latex-about-icon">&#128190;</span>
        <h3>Auto-save, no signup</h3>
        <p>Projects auto-save to browser localStorage. Switch between multiple documents, rename, export <code>.tex</code> or PDF. No account, no email, no tracking — your work never leaves your browser unless you compile.</p>
      </div>

    </div>

    <p class="latex-about-cta">
      Try it now: pick <strong><a href="#" onclick="document.getElementById('template-select').value='runcode';loadTemplate('runcode');return false;">Run Code</a></strong> for a multi-language tour with single-file and multi-file examples, <strong><a href="#" onclick="document.getElementById('template-select').value='calculus';loadTemplate('calculus');return false;">Calculus</a></strong> or <strong><a href="#" onclick="document.getElementById('template-select').value='linearalgebra';loadTemplate('linearalgebra');return false;">Linear Algebra</a></strong> for Σ Solve, or <strong><a href="#" onclick="document.getElementById('template-select').value='chemistry';loadTemplate('chemistry');return false;">Chemistry</a></strong> for Lewis / 2D / 3D rendering.
    </p>
  </div>
</section>
</div>

<!-- Footer -->
<%--<footer class="page-footer">--%>
<%--    <div class="footer-content">--%>
<%--        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>--%>
<%--        <div class="footer-links">--%>
<%--            <a href="<%=ctx%>/index.jsp" class="footer-link">Home</a>--%>
<%--            <a href="<%=ctx%>/tutorials/" class="footer-link">Tutorials</a>--%>
<%--            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</footer>--%>

<%--<%@ include file="/modern/ads/ad-sticky-footer.jsp" %>--%>
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

  // ── About modal (feature grid + SEO H1 live here now) ──
  window.openAbout = function() {
    var ov = document.getElementById('latex-about-overlay');
    if (!ov) return;
    ov.hidden = false;
    document.body.classList.add('latex-about-open');
    var c = ov.querySelector('.latex-about-close');
    if (c) c.focus();
  };
  window.closeAbout = function() {
    var ov = document.getElementById('latex-about-overlay');
    if (!ov) return;
    ov.hidden = true;
    document.body.classList.remove('latex-about-open');
  };
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      var ov = document.getElementById('latex-about-overlay');
      if (ov && !ov.hidden) closeAbout();
    }
  });

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
<script src="<%=ctx%>/latex/static/js/storage.js"></script>
<script src="<%=ctx%>/latex/static/js/symbols.js"></script>
<script src="<%=ctx%>/latex/static/js/editor.js"></script>
<script src="<%=ctx%>/latex/static/js/preview.js"></script>
<script src="<%=ctx%>/latex/static/js/compile.js"></script>
<script src="<%=ctx%>/latex/static/js/latex-shell.js?v=<%=jsV%>"></script>
<script type="module">
<%@ include file="/modern/components/ai-assistant-boot.inc.jsp" %>
import { streamChat, chat, buildHeaders } from '<%= request.getAttribute("aiCtx") %>/modern/js/llm-client.js';
import { wireLazyAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/lazy-assistant.js';

window.latexAiBoot = aiAssistantBoot;
window.latexAiTransport = { streamChat, chat, buildHeaders };

window.latexAssistant = wireLazyAssistant({
  moduleUrl: '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/latex-editor-ai.js',
  exportName: 'createLatexEditorAssistant',
  buttonId: 'btn-ai-prompt',
  boot: aiAssistantBoot,
});
</script>
<script src="<%=ctx%>/modern/js/speech-to-text.js"></script>
<script defer src="<%=ctx%>/latex/static/js/ai.js?v=<%=jsV%>"></script>
<script defer src="<%=ctx%>/latex/static/js/image-to-latex.js?v=<%=jsV%>"></script>
<!-- Generated content (Solve / Steps / Graph / chemistry figures) routes
     through SolutionsFile so the main editor stays clean -->
<script src="<%=ctx%>/latex/static/js/solutions-file.js"></script>
<script src="<%=ctx%>/latex/static/js/chem-insert.js"></script>

<!-- Math inline solver (Σ Solve in selection popup) -->
<script src="<%=ctx%>/modern/js/math-ai-cores-engine.js"></script>
<script src="<%=ctx%>/modern/js/code-runner-core.js"></script>
<script src="<%=ctx%>/latex/static/js/math-insert.js"></script>

</body>
</html>
