<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="log-header" onclick="toggleLogPanel()">
  <span class="log-title">Compiler Output</span>
  <span class="log-badge" id="log-error-badge" style="display:none"></span>
  <span class="error-count" id="error-count" style="display:none"></span>
  <div class="error-nav" id="error-nav" style="display:none" onclick="event.stopPropagation()">
    <button class="error-nav-btn" onclick="prevError()" title="Previous error (Shift+F8)">&#9650;</button>
    <button class="error-nav-btn" onclick="nextError()" title="Next error (F8)">&#9660;</button>
  </div>
  <span class="log-toggle" id="log-toggle-icon">&#9650; collapse</span>
</div>
<div class="log-body" id="log-output"></div>
