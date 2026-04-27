// Chemistry → structure insert for the LaTeX editor.
//
// Detects \ce{...} (mhchem) inside a CodeMirror selection and offers three
// render modes via the floating selection popup:
//   - lewis : lewis-structure-generator.jsp (p5.js canvas, formula input)
//   - 2d    : OpenChemLib in-page (SMILES → SVG, no iframe)
//   - 3d    : molecular-geometry-calculator.jsp (3Dmol canvas, formula input)
//
// All paths upload the captured image to /upload and insert a \begin{figure}
// block after the selection so the original \ce{...} text is preserved.
(function () {
  'use strict';

  var REACTION_ARROWS = /->|<->|<=>|<=|=>/;
  var IFRAME_TIMEOUT_MS = 25000;
  var POLL_INTERVAL_MS = 250;
  var OCL_CDN = 'https://esm.sh/openchemlib@9.21.0';

  // ── Parse ────────────────────────────────────────────────────────────────

  function extractCeContent(text) {
    if (!text) return null;
    var markers = ['\\ce{', '\\ch{'];
    for (var m = 0; m < markers.length; m++) {
      var idx = text.indexOf(markers[m]);
      if (idx < 0) continue;
      var start = idx + markers[m].length;
      var depth = 1, i = start;
      while (i < text.length && depth > 0) {
        var c = text.charAt(i);
        if (c === '{') depth++;
        else if (c === '}') {
          depth--;
          if (depth === 0) return { raw: text.substring(idx, i + 1), inner: text.substring(start, i) };
        }
        i++;
      }
    }
    return null;
  }

  function stripCompound(c) {
    return c
      .replace(/^\s*\d+\s*/, '')         // stoichiometric coefficient
      .replace(/\([slgaq]+\)/gi, '')     // (s) (l) (g) (aq)
      .replace(/\^\{[^}]*\}/g, '')       // ^{2+}
      .replace(/\^[\d+\-]+/g, '')        // ^+, ^-, ^2-
      .replace(/\$\\cdot\$/g, '')        // hydrate dots
      .replace(/\\,|\\;|\\:|\\!/g, '')   // spacing macros
      .replace(/\s+/g, '')
      .trim();
  }

  function parseCe(inner) {
    var segments = inner.split(REACTION_ARROWS);
    var all = [];
    var products = [];
    segments.forEach(function (seg, segIdx) {
      seg.split('+').forEach(function (raw) {
        var f = stripCompound(raw);
        if (!f) return;
        all.push(f);
        if (segIdx === segments.length - 1) products.push(f);
      });
    });
    if (!all.length) return null;
    var main = products.length ? products[products.length - 1] : all[all.length - 1];
    return { all: all, products: products, main: main };
  }

  function detect(selection) {
    if (!selection) return null;
    var ce = extractCeContent(selection);
    if (!ce) return null;
    var parsed = parseCe(ce.inner);
    if (!parsed) return null;
    return {
      ceRaw: ce.raw,
      ceInner: ce.inner,
      compounds: parsed.all,
      main: parsed.main
    };
  }

  // ── Formula → SMILES (for the 2D OpenChemLib path) ───────────────────────

  // Common species; covers most introductory chemistry. If a formula is not
  // here, the 2D mode shows a toast suggesting Lewis or 3D Geometry instead.
  var FORMULA_TO_SMILES = {
    H2O: 'O', H2: '[H][H]', O2: 'O=O', N2: 'N#N',
    F2: 'FF', Cl2: 'ClCl', Br2: 'BrBr', I2: 'II',
    HF: 'F', HCl: 'Cl', HBr: 'Br', HI: 'I',
    HCN: 'C#N', NH3: 'N', PH3: 'P', H2S: 'S',
    CH4: 'C', CO: '[C-]#[O+]', CO2: 'O=C=O',
    SO2: 'O=S=O', SO3: 'O=S(=O)=O',
    NO: '[N]=O', NO2: 'O=N[O]', N2O: 'N=[N+]=[O-]', O3: '[O-][O+]=O',
    CH3OH: 'CO', CH4O: 'CO',
    C2H6O: 'CCO', CH3CH2OH: 'CCO',
    C2H4: 'C=C', C2H6: 'CC', C2H2: 'C#C',
    C6H6: 'c1ccccc1',
    CH2O: 'C=O', HCHO: 'C=O',
    CH2O2: 'OC=O', HCOOH: 'OC=O',
    C2H4O2: 'CC(=O)O', CH3COOH: 'CC(=O)O',
    H2SO4: 'OS(=O)(=O)O',
    H3PO4: 'OP(=O)(O)O',
    HNO3: 'O[N+](=O)[O-]',
    NaCl: '[Na+].[Cl-]', KCl: '[K+].[Cl-]',
    CaCO3: '[Ca+2].[O-]C(=O)[O-]',
    NaOH: '[Na+].[OH-]', KOH: '[K+].[OH-]'
  };

  function lookupSmiles(formula) {
    return FORMULA_TO_SMILES[formula] || null;
  }

  // ── Iframe + canvas capture (for Lewis & 3D paths) ───────────────────────

  function findCanvas(doc, selectors) {
    for (var i = 0; i < selectors.length; i++) {
      var el = doc.querySelector(selectors[i]);
      if (el) return el;
    }
    return null;
  }

  function captureCanvasFromIframe(url, canvasSelectors, label, opts) {
    opts = opts || {};
    var iframeW = (opts.iframeSize && opts.iframeSize.width) || 1200;
    var iframeH = (opts.iframeSize && opts.iframeSize.height) || 800;
    var injectCSS = opts.injectCSS || '';

    return new Promise(function (resolve, reject) {
      var iframe = document.createElement('iframe');
      iframe.src = url;
      iframe.style.cssText =
        'position:fixed;left:-20000px;top:0;width:' + iframeW + 'px;height:' + iframeH + 'px;' +
        'border:0;visibility:hidden;pointer-events:none;';
      iframe.setAttribute('aria-hidden', 'true');
      iframe.setAttribute('tabindex', '-1');

      var done = false;
      var pollTimer = null;
      var timeoutTimer = null;

      function cleanup() {
        if (pollTimer) clearInterval(pollTimer);
        if (timeoutTimer) clearTimeout(timeoutTimer);
        if (iframe.parentNode) iframe.parentNode.removeChild(iframe);
      }
      function finish(err, dataUrl) {
        if (done) return;
        done = true;
        cleanup();
        if (err) reject(err); else resolve(dataUrl);
      }

      timeoutTimer = setTimeout(function () {
        finish(new Error(label + ' render timed out'));
      }, IFRAME_TIMEOUT_MS);

      iframe.addEventListener('load', function () {
        var doc;
        try { doc = iframe.contentDocument; }
        catch (e) { return finish(new Error('Cannot access ' + label + ' frame')); }
        if (!doc) return finish(new Error(label + ' frame has no document'));

        // Inject CSS overrides early so the renderer picks up the larger size.
        // Also nudge a resize event so libraries (3Dmol) re-sync to the new container.
        if (injectCSS && doc.head) {
          var styleEl = doc.createElement('style');
          styleEl.textContent = injectCSS;
          doc.head.appendChild(styleEl);
          try { iframe.contentWindow.dispatchEvent(new Event('resize')); } catch (e) {}
        }

        var stableFrames = 0;
        var lastSig = '';
        pollTimer = setInterval(function () {
          // Re-dispatch resize while waiting in case the renderer initialised
          // before our CSS landed
          if (injectCSS) { try { iframe.contentWindow.dispatchEvent(new Event('resize')); } catch (e) {} }
          var canvas = findCanvas(doc, canvasSelectors);
          if (!canvas || !canvas.width || !canvas.height) return;
          var sig = canvas.width + 'x' + canvas.height;
          if (sig === lastSig) {
            stableFrames++;
            if (stableFrames >= 2) {
              try {
                var dataUrl = canvas.toDataURL('image/png');
                if (!dataUrl || dataUrl.length < 1000) return;
                finish(null, dataUrl);
              } catch (e) {
                finish(new Error('Canvas capture failed: ' + e.message));
              }
            }
          } else {
            stableFrames = 0;
            lastSig = sig;
          }
        }, POLL_INTERVAL_MS);
      });
      iframe.addEventListener('error', function () {
        finish(new Error(label + ' failed to load'));
      });
      document.body.appendChild(iframe);
    });
  }

  // ── 3D: molecular-geometry-calculator ────────────────────────────────────

  function render3DToDataUrl(formula) {
    var ctx = (window.CONFIG && window.CONFIG.ctx) || '';
    var payload = { mode: 'formula', f: formula };
    var d = btoa(unescape(encodeURIComponent(JSON.stringify(payload))));
    var url = ctx + '/molecular-geometry-calculator.jsp?d=' + encodeURIComponent(d);
    // Default .mg-3d-viewer is hard-coded to 420px tall — too small for figures.
    // Inject an override so 3Dmol renders at higher resolution, then we capture
    // the WebGL canvas at that native size.
    var oversizeCSS =
      '.mg-3d-viewer{width:1100px!important;height:1000px!important;min-height:1000px!important;}' +
      '.mg-3d-wrapper{width:1100px!important;}';
    return captureCanvasFromIframe(url,
      ['.mg-3d-viewer canvas', '#mg-result-content canvas'],
      '3D geometry',
      { iframeSize: { width: 1600, height: 1300 }, injectCSS: oversizeCSS });
  }

  // ── Lewis: lewis-structure-generator ─────────────────────────────────────

  function renderLewisToDataUrl(formula) {
    var ctx = (window.CONFIG && window.CONFIG.ctx) || '';
    var url = ctx + '/lewis-structure-generator.jsp?formula=' + encodeURIComponent(formula);
    return captureCanvasFromIframe(url,
      ['#lewisCanvasContainer canvas', '.lewis-canvas-container canvas', 'canvas'],
      'Lewis structure',
      { iframeSize: { width: 1400, height: 1100 } });
  }

  // ── 2D: OpenChemLib in-page (SMILES → SVG → PNG) ─────────────────────────

  var oclPromise = null;
  function getOCL() {
    if (!oclPromise) {
      oclPromise = import(/* webpackIgnore: true */ OCL_CDN)
        .catch(function (e) {
          oclPromise = null;
          throw new Error('Failed to load OpenChemLib: ' + e.message);
        });
    }
    return oclPromise;
  }

  function svgToPngDataUrl(svgString, width, height) {
    return new Promise(function (resolve, reject) {
      var blob = new Blob([svgString], { type: 'image/svg+xml;charset=utf-8' });
      var url = URL.createObjectURL(blob);
      var img = new Image();
      img.onload = function () {
        try {
          var scale = 2; // hi-DPI
          var canvas = document.createElement('canvas');
          canvas.width = width * scale;
          canvas.height = height * scale;
          var c = canvas.getContext('2d');
          c.fillStyle = '#ffffff';
          c.fillRect(0, 0, canvas.width, canvas.height);
          c.drawImage(img, 0, 0, canvas.width, canvas.height);
          URL.revokeObjectURL(url);
          resolve(canvas.toDataURL('image/png'));
        } catch (e) { reject(e); }
      };
      img.onerror = function () {
        URL.revokeObjectURL(url);
        reject(new Error('Could not rasterize SVG'));
      };
      img.src = url;
    });
  }

  function render2DToDataUrl(formula) {
    var smiles = lookupSmiles(formula);
    if (!smiles) {
      return Promise.reject(new Error(
        'No SMILES known for ' + formula + '. Try Lewis or 3D Geometry.'));
    }
    return getOCL().then(function (OCL) {
      var mol = OCL.Molecule.fromSmiles(smiles);
      var w = 400, h = 300;
      var svg = mol.toSVG(w, h, null, { suppressChiralText: true, suppressESR: true });
      return svgToPngDataUrl(svg, w, h);
    });
  }

  // ── Upload + insert ──────────────────────────────────────────────────────

  function safeFilenamePart(s) {
    return (s || 'mol').replace(/[^A-Za-z0-9]/g, '').slice(0, 24) || 'mol';
  }

  function dataUrlToBlob(dataUrl) {
    var parts = dataUrl.split(',');
    var mime = (parts[0].match(/data:([^;]+);/) || [])[1] || 'image/png';
    var bin = atob(parts[1]);
    var arr = new Uint8Array(bin.length);
    for (var i = 0; i < bin.length; i++) arr[i] = bin.charCodeAt(i);
    return new Blob([arr], { type: mime });
  }

  function uploadImage(blob, filename) {
    var fd = new FormData();
    fd.append('file', blob, filename);
    return fetch(window.CONFIG.uploadUrl, { method: 'POST', body: fd })
      .then(function (res) {
        if (!res.ok) return res.json().then(function (d) { throw new Error(d.error || 'Upload failed'); });
        return res.json();
      });
  }

  function insertFigureBlock(cm, ceRaw, filename, modeLabel, anchorLine) {
    var label = filename.replace(/\.[^.]+$/, '').replace(/[^a-zA-Z0-9]/g, '-');
    var caption = modeLabel + ' of ' + ceRaw;
    // Insert with surrounding blank lines so \includegraphics is a paragraph
    // on its own — graphicx is sensitive to neighbouring tokens
    var block =
      '\n\n\\begin{figure}[h]\n' +
      '  \\centering\n' +
      '  \\includegraphics[width=0.45\\textwidth]{' + filename + '}\n' +
      '  \\caption{' + caption + '}\n' +
      '  \\label{fig:' + label + '}\n' +
      '\\end{figure}\n';
    var line = (typeof anchorLine === 'number') ? anchorLine : cm.getCursor('to').line;
    if (line >= cm.lineCount()) line = cm.lineCount() - 1;
    var lineEnd = { line: line, ch: cm.getLine(line).length };
    cm.replaceRange(block, lineEnd, lineEnd);
    cm.focus();
  }

  // ── Public entry point ───────────────────────────────────────────────────

  var MODE_CONFIG = {
    lewis: { fn: renderLewisToDataUrl, label: 'Lewis structure',  prefix: 'lewis' },
    '2d':  { fn: render2DToDataUrl,    label: '2D structure',     prefix: 'mol2d' },
    '3d':  { fn: render3DToDataUrl,    label: '3D geometry',      prefix: 'mol3d' }
  };

  function toast(kind, msg) {
    var fn = window['show' + kind + 'Toast'];
    if (typeof fn === 'function') fn(msg);
  }

  function render(detected, mode) {
    var cm = window.editorInstance;
    if (!cm || !detected || !detected.main) return;
    if (!window.CONFIG || !window.CONFIG.uploadUrl) {
      toast('Error', 'Editor not ready');
      return;
    }
    var cfg = MODE_CONFIG[mode];
    if (!cfg) { toast('Error', 'Unknown render mode: ' + mode); return; }

    // Capture insertion anchor NOW — render is async (3–15 s) and the cursor
    // may move during the wait. Anchor to the line containing the selection's end.
    var anchorLine = cm.getCursor('to').line;

    toast('Success', 'Rendering ' + detected.main + ' (' + cfg.label + ')…');

    var capturedDataUrl = null;
    cfg.fn(detected.main)
      .then(function (dataUrl) {
        capturedDataUrl = dataUrl;
        var blob = dataUrlToBlob(dataUrl);
        var filename = cfg.prefix + '-' + safeFilenamePart(detected.main) + '-' + Date.now() + '.png';
        return uploadImage(blob, filename);
      })
      .then(function (data) {
        var fname = data.filename;
        var fid = data.fileId;
        if (fid && typeof window.addUploadedFile === 'function') {
          window.addUploadedFile(fid, fname);
        }
        // Register the binary so the file-tree download can retrieve it locally.
        window.imageBlobs = window.imageBlobs || {};
        window.imageBlobs[fname] = capturedDataUrl;
        if (typeof window.addFileToTree === 'function') {
          window.addFileToTree(fname, true);
        }
        insertFigureBlock(cm, detected.ceRaw, fname, cfg.label, anchorLine);
        toast('Success', 'Inserted ' + cfg.label + ' for ' + detected.main);
      })
      .catch(function (err) {
        toast('Error', (err && err.message) || ('Could not render ' + detected.main));
      });
  }

  window.ChemInsert = {
    detect: detect,
    render: render,
    MODES: ['lewis', '2d', '3d']
  };
})();
