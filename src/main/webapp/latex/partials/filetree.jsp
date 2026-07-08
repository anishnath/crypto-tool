<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="filetree-header">
  <span class="filetree-title">Files</span>
  <div class="filetree-actions">
    <button type="button" title="New file" aria-label="New file" onclick="newFile()">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
    </button>
    <button type="button" title="Upload file" aria-label="Upload file" onclick="document.getElementById('file-upload-input').click()">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 15V4"/><path d="m7 8 5-5 5 5"/><path d="M5 20h14"/></svg>
    </button>
  </div>
</div>
<input type="file" id="file-upload-input" style="display:none" onchange="uploadFile(this)" accept=".png,.jpg,.jpeg,.gif,.svg,.eps,.pdf,.tex,.bib,.bst,.cls,.sty,.csv,.dat,.txt"/>

<div id="file-list">
  <div class="file-item active" data-file="main.tex" onclick="selectFile(this)" oncontextmenu="event.preventDefault(); showFileContextMenu(event, 'main.tex', false, this);">
    <span class="file-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M6 3h8l4 4v14H6z"/><path d="M14 3v4h4"/></svg></span> <span class="file-name">main.tex</span>
    <button type="button" class="file-actions-btn" title="File actions" aria-label="File actions for main.tex" onclick="event.stopPropagation(); showFileContextMenu(event, 'main.tex', false, this.parentElement);">&#8942;</button>
  </div>
</div>

<div class="outline-section" id="outline-section">
  <div class="filetree-header" style="padding-bottom:4px">
    <span class="filetree-title">Outline</span>
  </div>
  <div id="outline-list"></div>
</div>
