(function() {
'use strict';

// ── State ──
var pdfDoc = null;
var currentPage = 1;
var totalPages = 0;
var currentScale = 1.0;
var rendering = false;
var pendingPage = null;
var currentPdfUrl = null;

// Preview mode: 'native' (iframe) or 'canvas' (PDF.js)
var previewMode = 'native';

// Set PDF.js worker
if (typeof pdfjsLib !== 'undefined') {
  pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';
}

// ── Preview mode switching ──
function setPreviewMode(mode) {
  previewMode = mode;

  var iframe = document.getElementById('pdf-iframe');
  var canvas = document.getElementById('pdf-canvas');
  var btnNative = document.getElementById('btn-view-native');
  var btnCanvas = document.getElementById('btn-view-canvas');
  var pageControls = document.getElementById('btn-prev-page');

  if (mode === 'native') {
    if (iframe) iframe.style.display = '';
    if (canvas) canvas.style.display = 'none';
    if (btnNative) btnNative.classList.add('active');
    if (btnCanvas) btnCanvas.classList.remove('active');
    // Hide page nav — native viewer handles it
    togglePageControls(false);

    // If we have a PDF URL, load it in iframe
    if (currentPdfUrl) {
      iframe.src = currentPdfUrl;
    }
  } else {
    if (iframe) iframe.style.display = 'none';
    if (canvas) canvas.style.display = '';
    if (btnNative) btnNative.classList.remove('active');
    if (btnCanvas) btnCanvas.classList.add('active');
    togglePageControls(true);

    // If we have a PDF loaded, render current page
    if (pdfDoc) {
      renderPage(currentPage);
    }
  }
}

function togglePageControls(show) {
  var ids = ['btn-prev-page', 'page-info', 'btn-next-page'];
  for (var i = 0; i < ids.length; i++) {
    var el = document.getElementById(ids[i]);
    if (el) el.style.display = show ? '' : 'none';
  }
}

// ── Load PDF ──
function loadPDF(url) {
  currentPdfUrl = url;

  document.getElementById('empty-preview').classList.add('hidden');

  if (previewMode === 'native') {
    // Native: load in iframe
    var iframe = document.getElementById('pdf-iframe');
    if (iframe) {
      iframe.style.display = '';
      iframe.src = url;
    }
    // Also load via PDF.js in background for page count
    loadPDFjs(url);
  } else {
    // Canvas mode
    var canvas = document.getElementById('pdf-canvas');
    if (canvas) canvas.style.display = '';
    loadPDFjs(url);
  }
}

function loadPDFjs(url) {
  if (typeof pdfjsLib === 'undefined') {
    if (previewMode === 'canvas') {
      showErrorToast('PDF.js not loaded');
    }
    return;
  }

  var loadingTask = pdfjsLib.getDocument(url);
  loadingTask.promise.then(function(pdf) {
    pdfDoc = pdf;
    totalPages = pdf.numPages;
    currentPage = 1;
    updatePageInfo();
    if (previewMode === 'canvas') {
      renderPage(currentPage);
    }
  }).catch(function(err) {
    if (previewMode === 'canvas') {
      showErrorToast('Failed to load PDF: ' + err.message);
    }
  });
}

// ── Canvas rendering (PDF.js) ──
function renderPage(num) {
  if (!pdfDoc || previewMode !== 'canvas') return;

  if (rendering) {
    pendingPage = num;
    return;
  }

  rendering = true;
  var canvas = document.getElementById('pdf-canvas');
  var ctx = canvas.getContext('2d');

  pdfDoc.getPage(num).then(function(page) {
    var viewport = page.getViewport({ scale: currentScale });
    canvas.height = viewport.height;
    canvas.width = viewport.width;

    var renderTask = page.render({
      canvasContext: ctx,
      viewport: viewport
    });
    renderTask.promise.then(function() {
      rendering = false;
      if (pendingPage !== null) {
        var p = pendingPage;
        pendingPage = null;
        renderPage(p);
      }
    });
  }).catch(function() {
    rendering = false;
  });
}

function updatePageInfo() {
  var el = document.getElementById('page-info');
  if (el) {
    el.textContent = currentPage + ' / ' + totalPages;
  }
}

function prevPage() {
  if (currentPage <= 1) return;
  currentPage--;
  updatePageInfo();
  renderPage(currentPage);
}

function nextPage() {
  if (!pdfDoc || currentPage >= totalPages) return;
  currentPage++;
  updatePageInfo();
  renderPage(currentPage);
}

function zoomIn() {
  if (previewMode === 'native') return; // native viewer has its own zoom
  currentScale = Math.min(currentScale + 0.25, 3.0);
  updateZoomLevel();
  if (pdfDoc) renderPage(currentPage);
}

function zoomOut() {
  if (previewMode === 'native') return;
  currentScale = Math.max(currentScale - 0.25, 0.5);
  updateZoomLevel();
  if (pdfDoc) renderPage(currentPage);
}

function updateZoomLevel() {
  var el = document.getElementById('zoom-level');
  if (el) {
    el.textContent = Math.round(currentScale * 100) + '%';
  }
}

function showPDFLoading(show) {
  var overlay = document.getElementById('pdf-loading');
  if (overlay) {
    if (show) overlay.classList.add('visible');
    else overlay.classList.remove('visible');
  }
}

function downloadPDF() {
  if (!window.currentJobId) return;
  var url = CONFIG.pdfUrl + '/' + window.currentJobId;
  var a = document.createElement('a');
  a.href = url;
  a.download = 'document.pdf';
  a.click();
}

function toggleFullPreview() {
  var main = document.querySelector('.main');
  if (main) main.classList.toggle('full-preview');
}

// ── Mobile: toggle editor ↔ preview ──
var mobileShowingPreview = false;

function toggleMobileView() {
  mobileShowingPreview = !mobileShowingPreview;
  applyMobileView();
}

function showMobilePreview() {
  if (mobileShowingPreview) return;
  mobileShowingPreview = true;
  applyMobileView();
  // Pulse the FAB to draw attention
  var fab = document.getElementById('mobile-fab');
  if (fab) {
    fab.classList.remove('pulse');
    void fab.offsetWidth; // reflow to restart animation
    fab.classList.add('pulse');
  }
}

function applyMobileView() {
  var app = document.getElementById('latex-app');
  if (!app) return;

  // Toolbar toggle button
  var icon = document.getElementById('mobile-toggle-icon');
  var label = document.getElementById('mobile-toggle-label');
  // FAB
  var fabIcon = document.getElementById('fab-icon');
  var fabLabel = document.getElementById('fab-label');

  if (mobileShowingPreview) {
    app.classList.add('show-preview');
    if (icon) icon.textContent = '\u270F'; // pencil
    if (label) label.textContent = 'Editor';
    if (fabIcon) fabIcon.textContent = '\u270F';
    if (fabLabel) { fabLabel.textContent = 'Editor'; fabLabel.classList.remove('hidden'); }
  } else {
    app.classList.remove('show-preview');
    if (icon) icon.textContent = '\uD83D\uDCC4'; // page
    if (label) label.textContent = 'Preview';
    if (fabIcon) fabIcon.textContent = '\uD83D\uDCC4';
    if (fabLabel) { fabLabel.textContent = 'Preview'; fabLabel.classList.remove('hidden'); }
  }

  // Auto-hide label after 2s
  setTimeout(function() {
    if (fabLabel) fabLabel.classList.add('hidden');
  }, 2000);
}

function isMobile() {
  return window.innerWidth <= 768;
}

// Auto-hide FAB label after 3s so it doesn't clutter the screen
setTimeout(function() {
  var fabLabel = document.getElementById('fab-label');
  if (fabLabel) fabLabel.classList.add('hidden');
}, 3000);

// Expose
window.loadPDF = loadPDF;
window.prevPage = prevPage;
window.nextPage = nextPage;
window.zoomIn = zoomIn;
window.zoomOut = zoomOut;
window.showPDFLoading = showPDFLoading;
window.downloadPDF = downloadPDF;
window.toggleFullPreview = toggleFullPreview;
window.setPreviewMode = setPreviewMode;
window.toggleMobileView = toggleMobileView;
window.showMobilePreview = showMobilePreview;
window.isMobile = isMobile;

})();
