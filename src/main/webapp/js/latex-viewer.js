// Lightweight LaTeX viewer/editor using KaTeX
// Custom JS intentionally kept in js/ per project guidance

(function () {
  let auto = true;
  let inlineMode = false;
  let debounceTimer = null;

  function $(id) { return document.getElementById(id); }

  function showError(msg) {
    const el = $('errorMessage');
    el.textContent = msg || '';
    el.style.display = msg ? 'block' : 'none';
  }

  function updatePreview() {
    const input = $('latexInput').value;
    const preview = $('preview');
    showError('');

    // Detect unsupported full-LaTeX/TikZ content and guide the user
    if (/\\documentclass|\\usepackage|\\begin\{document\}/.test(input)) {
      showError('Full LaTeX documents (e.g., \\documentclass, \\usepackage) are not supported in this viewer. Paste just a math expression, or use a TikZ/TeX engine.');
      preview.innerHTML = '<span class="text-danger">Document-level LaTeX not supported here</span>';
      return;
    }
    if (/\\begin\{tikzpicture\}/.test(input)) {
      showError('TikZ drawings require a TikZ-capable engine. This KaTeX viewer renders math only.');
      preview.innerHTML = '<span class="text-danger">TikZ not supported in KaTeX</span>';
      return;
    }

    if (!input.trim()) {
      preview.innerHTML = '<span class="text-muted">Enter LaTeX to see a preview…</span>';
      return;
    }

    try {
      katex.render(input, preview, { throwOnError: true, displayMode: !inlineMode });
    } catch (e) {
      showError('LaTeX Error: ' + (e && e.message ? e.message : 'unknown'));
      preview.innerHTML = '<span class="text-danger">Invalid LaTeX</span>';
    }
  }

  function debouncedUpdate() {
    if (!auto) return;
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(updatePreview, 200);
  }

  function clearInput() {
    $('latexInput').value = '';
    updatePreview();
  }

  function copyLatex() {
    const text = $('latexInput').value;
    if (!text) return;
    navigator.clipboard.writeText(text).catch(() => {
      // Fallback prompt in case clipboard API is not allowed
      window.prompt('Copy LaTeX:', text);
    });
  }

  function exportAsSVG() {
    const svg = $('preview').querySelector('svg');
    if (!svg) { alert('Nothing to export.'); return; }
    const data = new XMLSerializer().serializeToString(svg);
    const blob = new Blob([data], { type: 'image/svg+xml;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'equation-' + Date.now() + '.svg';
    a.click();
    URL.revokeObjectURL(url);
  }

  function exportAsPNG() {
    const container = $('preview');
    const svg = container.querySelector('svg');
    if (!svg) { alert('Nothing to export.'); return; }

    const scale = 2; // simple HiDPI-ish scale
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');

    // Render SVG to image and draw to canvas
    const data = new XMLSerializer().serializeToString(svg);
    const blob = new Blob([data], { type: 'image/svg+xml;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const img = new Image();
    img.onload = function () {
      canvas.width = img.width * scale;
      canvas.height = img.height * scale;
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
      canvas.toBlob(function (pngBlob) {
        const dl = URL.createObjectURL(pngBlob);
        const a = document.createElement('a');
        a.href = dl;
        a.download = 'equation-' + Date.now() + '.png';
        a.click();
        URL.revokeObjectURL(dl);
      });
      URL.revokeObjectURL(url);
    };
    img.src = url;
  }

  function init() {
    // Controls
    $('btn-update').addEventListener('click', updatePreview);
    $('btn-clear').addEventListener('click', clearInput);
    $('btn-copy').addEventListener('click', copyLatex);
    $('btn-svg').addEventListener('click', exportAsSVG);
    $('btn-png').addEventListener('click', exportAsPNG);

    $('autoPreview').addEventListener('change', (e) => { auto = !!e.target.checked; if (auto) updatePreview(); });
    $('inlineMode').addEventListener('change', (e) => { inlineMode = !!e.target.checked; updatePreview(); });

    $('latexInput').addEventListener('input', debouncedUpdate);

    // Initial render
    updatePreview();
  }

  window.addEventListener('DOMContentLoaded', init);
})();
