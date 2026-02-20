<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="toolbar">
  <div class="toolbar-group">
    <button class="tb-btn primary" id="btn-compile" onclick="triggerCompile()" title="Compile (Ctrl+Enter / Cmd+S)">
      <span>&#9654;</span>
      <span id="btn-compile-label">Compile</span>
      <span class="dot"></span>
    </button>
    <span class="tb-shortcut">Ctrl+Enter</span>
  </div>

  <div class="toolbar-group">
    <button class="tb-btn" id="btn-download-pdf" onclick="downloadPDF()" disabled>&#8595; PDF</button>
    <button class="tb-btn" id="btn-download-tex" onclick="downloadTex()">&#8595; .tex</button>
  </div>

  <div class="toolbar-group">
    <select class="tb-select" id="template-select" onchange="loadTemplate(this.value)">
      <option value="article">Article</option>
      <option value="report">Report</option>
      <option value="beamer">Presentation</option>
      <option value="letter">Letter</option>
      <option value="cv">CV</option>
    </select>
  </div>

  <div class="toolbar-group">
    <button class="tb-btn" onclick="insertCommand('\\textbf{}')"><b>B</b></button>
    <button class="tb-btn" onclick="insertCommand('\\textit{}')"><i>I</i></button>
    <button class="tb-btn" onclick="insertCommand('\\section{}')">H1</button>
    <button class="tb-btn" onclick="insertCommand('\\subsection{}')">H2</button>
    <button class="tb-btn" id="btn-symbols" onclick="toggleSymbolPicker()">&#8721; Symbol</button>
    <button class="tb-btn" onclick="insertTableTemplate()">&#8862; Table</button>
    <button class="tb-btn" onclick="insertFigureTemplate()">&#8980; Figure</button>
  </div>

  <span class="compile-status" id="compile-status"></span>

  <!-- Mobile: toggle between editor and preview -->
  <button class="tb-btn mobile-toggle" id="btn-mobile-toggle" onclick="toggleMobileView()">
    <span id="mobile-toggle-icon">&#128196;</span>
    <span id="mobile-toggle-label">Preview</span>
  </button>
</div>
