<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="filetree-header">
  <span class="filetree-title">Files</span>
  <div class="filetree-actions">
    <span title="New file" onclick="newFile()">+</span>
    <span title="Upload file" onclick="document.getElementById('file-upload-input').click()">&#8593;</span>
  </div>
</div>
<input type="file" id="file-upload-input" style="display:none" onchange="uploadFile(this)" accept=".png,.jpg,.jpeg,.gif,.svg,.eps,.pdf,.tex,.bib,.bst,.cls,.sty,.csv,.dat,.txt"/>

<div id="file-list">
  <div class="file-item active" data-file="main.tex" onclick="selectFile(this)">
    <span class="file-icon">&#128196;</span> main.tex
  </div>
</div>

<div class="outline-section" id="outline-section">
  <div class="filetree-header" style="padding-bottom:4px">
    <span class="filetree-title">Outline</span>
  </div>
  <div id="outline-list"></div>
</div>
