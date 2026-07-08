<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="toolbar">
  <div class="toolbar-group">
    <button class="tb-btn primary" id="btn-compile" onclick="triggerCompile()" title="Compile (Ctrl+Enter / Cmd+S)">
      <svg viewBox="0 0 24 24" fill="currentColor" width="11" height="11" aria-hidden="true"><path d="M7 4.5v15l13-7.5z"/></svg>
      <span id="btn-compile-label">Compile</span>
      <span class="dot"></span>
    </button>
    <span class="tb-shortcut">Ctrl+Enter</span>
  </div>

  <div class="toolbar-group">
    <button class="tb-btn" id="btn-download-pdf" onclick="downloadPDF()" disabled>
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="12" height="12" aria-hidden="true"><path d="M12 3v12"/><path d="m7 11 5 5 5-5"/><path d="M5 20h14"/></svg>
      PDF
    </button>
    <button class="tb-btn" id="btn-download-tex" onclick="downloadTex()">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="12" height="12" aria-hidden="true"><path d="M12 3v12"/><path d="m7 11 5 5 5-5"/><path d="M5 20h14"/></svg>
      .tex
    </button>
  </div>

  <div class="toolbar-group">
    <select class="tb-select" id="template-select" onchange="loadTemplate(this.value)" aria-label="Load template">
      <option value="article">Article</option>
      <option value="report">Report</option>
      <option value="beamer">Presentation</option>
      <option value="letter">Letter</option>
      <option value="cv">CV</option>
      <option value="chemistry">Chemistry</option>
      <option value="calculus">Calculus</option>
      <option value="linearalgebra">Linear Algebra</option>
      <option value="runcode">Run Code</option>
      <option value="andrews">Andrews Curves (Iris)</option>
      <option value="journalbib">Modern Article (BibTeX)</option>
      <option value="multiproject">Research Bundle (3 PDFs)</option>
    </select>
  </div>

  <div class="toolbar-group">
    <button class="tb-btn" onclick="insertCommand('\\textbf{}')" title="Bold" aria-label="Insert bold"><b>B</b></button>
    <button class="tb-btn" onclick="insertCommand('\\textit{}')" title="Italic" aria-label="Insert italic"><i>I</i></button>
    <button class="tb-btn" onclick="insertCommand('\\section{}')" title="Section" aria-label="Insert section">H1</button>
    <button class="tb-btn" onclick="insertCommand('\\subsection{}')" title="Subsection" aria-label="Insert subsection">H2</button>
    <button class="tb-btn" id="btn-symbols" onclick="toggleSymbolPicker()">&#8721; Symbol</button>
    <button class="tb-btn" onclick="insertTableTemplate()">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="12" height="12" aria-hidden="true"><rect x="3" y="4" width="18" height="16" rx="1.5"/><path d="M3 10h18M9 4v16"/></svg>
      Table
    </button>
    <button class="tb-btn" onclick="insertFigureTemplate()">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="12" height="12" aria-hidden="true"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="10" r="1.5"/><path d="m5 18 5-5 3 3 3.5-3.5L21 17"/></svg>
      Figure
    </button>
  </div>

  <div class="toolbar-group ai-group">
    <button class="tb-btn ai-btn" id="btn-ai-prompt" title="AI assistant — generate, fix, explain LaTeX (Ctrl+Shift+A)">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" width="12" height="12" aria-hidden="true"><path d="M12 3l1.9 5.1L19 10l-5.1 1.9L12 17l-1.9-5.1L5 10l5.1-1.9z"/><path d="M19 15l.7 1.8 1.8.7-1.8.7L19 20l-.7-1.8-1.8-.7 1.8-.7z"/></svg>
      AI
    </button>
    <button class="tb-btn" id="btn-voice" title="Voice to LaTeX: Dictate text or equations">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="12" height="12" aria-hidden="true"><rect x="9" y="3" width="6" height="11" rx="3"/><path d="M5 11a7 7 0 0 0 14 0"/><path d="M12 18v3"/></svg>
      Voice
    </button>
  </div>

  <span class="compile-status" id="compile-status"></span>

  <!-- Mobile: files drawer toggle -->
  <button class="tb-btn mobile-files-btn" id="btn-mobile-files" onclick="toggleMobileDrawer()" title="Files">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="13" height="13" aria-hidden="true"><path d="M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
    Files
  </button>

  <!-- Mobile: toggle between editor and preview -->
  <button class="tb-btn mobile-toggle" id="btn-mobile-toggle" onclick="toggleMobileView()">
    <span id="mobile-toggle-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M6 3h8l4 4v14H6z"/><path d="M14 3v4h4"/></svg></span>
    <span id="mobile-toggle-label">Preview</span>
  </button>
</div>
