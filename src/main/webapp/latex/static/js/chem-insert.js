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
    var extractProps = opts.extractProps || null;

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
      function finish(err, result) {
        if (done) return;
        done = true;
        cleanup();
        if (err) reject(err); else resolve(result);
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
                // Scrape any extra info from the page BEFORE we tear the iframe down
                var props = {};
                if (extractProps) {
                  try { props = extractProps(doc) || {}; } catch (e) {}
                }
                finish(null, { dataUrl: dataUrl, props: props });
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

  // ── Auto-crop background whitespace (zoom into the rendered molecule) ────

  function autoTrim(dataUrl, bgRGB, tolerance, padding) {
    return new Promise(function (resolve, reject) {
      var img = new Image();
      img.onload = function () {
        try {
          var w = img.width, h = img.height;
          var c = document.createElement('canvas');
          c.width = w; c.height = h;
          var ctx = c.getContext('2d');
          ctx.drawImage(img, 0, 0);
          var data = ctx.getImageData(0, 0, w, h).data;
          var bgR = bgRGB[0], bgG = bgRGB[1], bgB = bgRGB[2];
          var tol = (tolerance != null) ? tolerance : 14;
          var minX = w, minY = h, maxX = -1, maxY = -1;
          for (var y = 0; y < h; y++) {
            for (var x = 0; x < w; x++) {
              var i = (y * w + x) * 4;
              // Treat near-transparent pixels as background too
              if (data[i + 3] < 8) continue;
              if (Math.abs(data[i] - bgR) > tol ||
                  Math.abs(data[i + 1] - bgG) > tol ||
                  Math.abs(data[i + 2] - bgB) > tol) {
                if (x < minX) minX = x;
                if (y < minY) minY = y;
                if (x > maxX) maxX = x;
                if (y > maxY) maxY = y;
              }
            }
          }
          if (maxX < 0) { resolve(dataUrl); return; } // entirely background
          var pad = (padding != null) ? padding : 24;
          minX = Math.max(0, minX - pad);
          minY = Math.max(0, minY - pad);
          maxX = Math.min(w - 1, maxX + pad);
          maxY = Math.min(h - 1, maxY + pad);
          var cw = maxX - minX + 1;
          var ch = maxY - minY + 1;
          var out = document.createElement('canvas');
          out.width = cw; out.height = ch;
          out.getContext('2d').drawImage(c, minX, minY, cw, ch, 0, 0, cw, ch);
          resolve(out.toDataURL('image/png'));
        } catch (e) { reject(e); }
      };
      img.onerror = function () { reject(new Error('Could not decode image for trim')); };
      img.src = dataUrl;
    });
  }

  // ── 3D: molecular-geometry-calculator ────────────────────────────────────

  function extract3DProps(doc) {
    var props = {};
    var resultEl = doc.getElementById('mg-result-content');
    if (!resultEl) return props;
    var text = resultEl.textContent || '';
    var geomMatch = text.match(/(Linear|Bent|Trigonal Planar|Trigonal Pyramidal|Tetrahedral|Trigonal Bipyramidal|Octahedral|T-shaped|See-saw|Square Planar|Square Pyramidal)/i);
    if (geomMatch) props.geometry = geomMatch[1];
    var angleMatch = text.match(/(\d+(?:\.\d+)?)\s*°/);
    if (angleMatch) props.angle = angleMatch[1] + '°';
    var hybridMatch = text.match(/(sp3d2|sp3d|sp3|sp2|sp)\b/i);
    if (hybridMatch) props.hybridization = hybridMatch[1];
    return props;
  }

  function render3DToDataUrl(formula) {
    var ctx = (window.CONFIG && window.CONFIG.ctx) || '';
    var payload = { mode: 'formula', f: formula };
    var d = btoa(unescape(encodeURIComponent(JSON.stringify(payload))));
    var url = ctx + '/molecular-geometry-calculator.jsp?d=' + encodeURIComponent(d);
    var oversizeCSS =
      '.mg-3d-viewer{width:1100px!important;height:1000px!important;min-height:1000px!important;}' +
      '.mg-3d-wrapper{width:1100px!important;}';
    return captureCanvasFromIframe(url,
      ['.mg-3d-viewer canvas', '#mg-result-content canvas'],
      '3D geometry',
      { iframeSize: { width: 1600, height: 1300 }, injectCSS: oversizeCSS,
        extractProps: extract3DProps })
      // Iframes default to light mode (#fff bg); trim whitespace to zoom in.
      .then(function (r) {
        return autoTrim(r.dataUrl, [255, 255, 255], 14, 24)
          .then(function (trimmed) { return { dataUrl: trimmed, props: r.props }; });
      });
  }

  // ── Lewis: lewis-structure-generator ─────────────────────────────────────

  function extractLewisProps(doc) {
    var props = {};
    var geomEl = doc.getElementById('geomLabel') || doc.querySelector('.lewis-geometry-label');
    if (geomEl && geomEl.textContent) props.geometry = geomEl.textContent.trim();
    // Some pages also expose total valence electrons / formal charges; grab anything obvious
    var resultText = (doc.getElementById('lewisResultPanel') ||
                      doc.getElementById('molecularFormula-result') || {}).textContent || '';
    var veMatch = resultText.match(/(\d+)\s*(?:total\s*)?valence\s*electrons?/i);
    if (veMatch) props.valenceElectrons = veMatch[1];
    return props;
  }

  function renderLewisToDataUrl(formula) {
    var ctx = (window.CONFIG && window.CONFIG.ctx) || '';
    var url = ctx + '/lewis-structure-generator.jsp?formula=' + encodeURIComponent(formula);
    return captureCanvasFromIframe(url,
      ['#lewisCanvasContainer canvas', '.lewis-canvas-container canvas', 'canvas'],
      'Lewis structure',
      { iframeSize: { width: 1400, height: 1100 }, extractProps: extractLewisProps })
      .then(function (r) {
        return autoTrim(r.dataUrl, [255, 255, 255], 14, 28)
          .then(function (trimmed) { return { dataUrl: trimmed, props: r.props }; });
      });
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

  // SMILES → 2D structure via OpenChemLib. The input is treated as SMILES
  // verbatim — no formula translation. If it's not valid SMILES we point the
  // user at /chemistry/molecule-draw.jsp where they can draw it and copy a
  // correct SMILES string back in.
  function render2DFromSmiles(smiles) {
    var ctx = (window.CONFIG && window.CONFIG.ctx) || '';
    var hint = ' Use ' + ctx + '/chemistry/molecule-draw.jsp to draw the structure and copy a valid SMILES.';

    return getOCL().then(function (OCL) {
      var mol;
      try { mol = OCL.Molecule.fromSmiles(smiles); }
      catch (e) {
        throw new Error('Invalid SMILES: "' + smiles + '"' +
          (e && e.message ? ' — ' + e.message : '') + '.' + hint);
      }
      if (!mol || mol.getAllAtoms() === 0) {
        throw new Error('Empty molecule from SMILES "' + smiles + '".' + hint);
      }

      var w = 400, h = 300;
      var svg = mol.toSVG(w, h, null, { suppressChiralText: true, suppressESR: true });

      var props = { smiles: smiles };
      try { props.formula = mol.getMolecularFormula().formula; } catch (e) {}
      try {
        var mw = mol.getMolweight();
        if (mw) props.weight = mw.toFixed(2) + ' g/mol';
      } catch (e) {}
      try { props.atoms = mol.getAllAtoms(); } catch (e) {}
      try { props.bonds = mol.getAllBonds(); } catch (e) {}

      return svgToPngDataUrl(svg, w, h)
        .then(function (dataUrl) { return { dataUrl: dataUrl, props: props }; });
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

  function escapeForLatex(s) {
    return String(s)
      .replace(/\\/g, '\\textbackslash{}')
      .replace(/([&%$#_{}])/g, '\\$1')
      .replace(/~/g, '\\textasciitilde{}')
      .replace(/\^/g, '\\textasciicircum{}');
  }

  // Build the property-table rows in mode-relevant order.
  // Returns an array of [labelLatex, valueLatex] pairs, already escaped.
  function buildPropRows(props) {
    var rows = [];
    if (!props) return rows;
    if (props.formula)          rows.push(['Formula',         '\\ce{' + props.formula + '}']);
    if (props.weight)           rows.push(['Mol.\\ weight',   escapeForLatex(props.weight)]);
    if (props.geometry)         rows.push(['Geometry',        escapeForLatex(props.geometry)]);
    if (props.angle)            rows.push(['Bond angle',      escapeForLatex(props.angle)]);
    if (props.hybridization)    rows.push(['Hybridization',   escapeForLatex(props.hybridization)]);
    if (props.atoms != null)    rows.push(['Atoms',           String(props.atoms)]);
    if (props.bonds != null)    rows.push(['Bonds',           String(props.bonds)]);
    if (props.valenceElectrons) rows.push(['Valence e\\textsuperscript{$-$}', String(props.valenceElectrons)]);
    if (props.smiles)           rows.push(['SMILES',          '\\texttt{' + escapeForLatex(props.smiles) + '}']);
    return rows;
  }

  function buildSimpleFigure(filename, ceRaw, modeLabel, label) {
    var caption = modeLabel + ' of ' + ceRaw;
    return [
      '',
      '',
      '\\begin{figure}[H]',
      '  \\centering',
      '  \\includegraphics[width=0.5\\textwidth,keepaspectratio]{' + filename + '}',
      '  \\caption[' + modeLabel + ' of ' + ceRaw + ']{' + caption + '}',
      '  \\label{fig:' + label + '}',
      '\\end{figure}',
      ''
    ].join('\n');
  }

  function buildSideBySideFigure(filename, ceRaw, modeLabel, label, rows) {
    var rowLines = rows.map(function (r) {
      return '      \\textbf{' + r[0] + '} & ' + r[1] + ' \\\\';
    }).join('\n');
    return [
      '',
      '',
      '\\begin{figure}[H]',
      '  \\centering',
      '  \\begin{minipage}[c]{0.48\\textwidth}',
      '    \\centering',
      '    \\includegraphics[width=\\linewidth,keepaspectratio]{' + filename + '}',
      '  \\end{minipage}\\hfill',
      '  \\begin{minipage}[c]{0.48\\textwidth}',
      '    \\small\\renewcommand{\\arraystretch}{1.2}%',
      '    \\begin{tabular}{@{}ll@{}}',
      '      \\toprule',
      rowLines,
      '      \\bottomrule',
      '    \\end{tabular}',
      '  \\end{minipage}',
      '  \\caption[' + modeLabel + ' of ' + ceRaw + ']{' + modeLabel + ' of ' + ceRaw + '}',
      '  \\label{fig:' + label + '}',
      '\\end{figure}',
      ''
    ].join('\n');
  }

  // Insert any missing \usepackage lines just before \begin{document}.
  // Each entry is either a string (plain package) or { name, options }.
  // Returns the number of lines actually inserted.
  function ensurePackages(cm, packages) {
    var content = cm.getValue();
    var missing = [];
    packages.forEach(function (p) {
      var name = (typeof p === 'string') ? p : p.name;
      var re = new RegExp(
        '\\\\usepackage(?:\\[[^\\]]*\\])?\\{[^}]*\\b' +
        name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') +
        '\\b[^}]*\\}');
      if (!re.test(content)) missing.push(p);
    });
    if (!missing.length) return 0;

    var beginDocLine = -1;
    var lastUsepkgLine = -1;
    for (var i = 0; i < cm.lineCount(); i++) {
      var ln = cm.getLine(i);
      if (beginDocLine < 0 && /\\begin\{document\}/.test(ln)) { beginDocLine = i; break; }
      if (/\\usepackage/.test(ln)) lastUsepkgLine = i;
    }
    if (beginDocLine < 0) return 0;

    var insertLine = (lastUsepkgLine >= 0) ? lastUsepkgLine + 1 : beginDocLine;
    var text = missing.map(function (p) {
      if (typeof p === 'string') return '\\usepackage{' + p + '}';
      return '\\usepackage' + (p.options ? '[' + p.options + ']' : '') + '{' + p.name + '}';
    }).join('\n') + '\n';
    cm.replaceRange(text, { line: insertLine, ch: 0 });
    return missing.length;
  }

  // Convenience: ensure mhchem v4 is loaded. Called from selection detection
  // so the doc compiles as soon as the user touches \ce{...}.
  function ensureMhchem(cm) {
    if (!cm) return 0;
    return ensurePackages(cm, [{ name: 'mhchem', options: 'version=4' }]);
  }

  function insertFigureBlock(cm, ceRaw, filename, modeLabel, props, anchorPos) {
    var label = filename.replace(/\.[^.]+$/, '').replace(/[^a-zA-Z0-9]/g, '-');
    var rows = buildPropRows(props);
    var mhchem = { name: 'mhchem', options: 'version=4' };
    var needsPackages = (rows.length > 0)
      ? ['booktabs', 'float', mhchem]   // booktabs for \toprule, float for [H], mhchem for \ce in caption/table
      : ['float', mhchem];

    // Add missing packages first; the anchor (a CodeMirror bookmark) auto-shifts.
    ensurePackages(cm, needsPackages);

    var pos = anchorPos || cm.getCursor('to');
    if (pos.line >= cm.lineCount()) pos.line = cm.lineCount() - 1;
    var lineEnd = { line: pos.line, ch: cm.getLine(pos.line).length };

    var block = (rows.length > 0)
      ? buildSideBySideFigure(filename, ceRaw, modeLabel, label, rows)
      : buildSimpleFigure(filename, ceRaw, modeLabel, label);
    cm.replaceRange(block, lineEnd, lineEnd);
    cm.focus();
  }

  // ── Public entry point ───────────────────────────────────────────────────

  var MODE_CONFIG = {
    lewis:  { fn: renderLewisToDataUrl,  label: 'Lewis structure',     prefix: 'lewis' },
    smiles: { fn: render2DFromSmiles,    label: 'SMILES structure',    prefix: 'smiles' },
    '3d':   { fn: render3DToDataUrl,     label: '3D geometry',         prefix: 'mol3d' }
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

    // CodeMirror bookmark survives all subsequent edits (user typing, our package
    // injection at top of file, etc). Insertion lands exactly where the user clicked.
    var anchorMark = cm.setBookmark(cm.getCursor('to'));

    toast('Success', 'Rendering ' + detected.main + ' (' + cfg.label + ')…');

    var capturedDataUrl = null;
    var capturedProps = {};
    cfg.fn(detected.main)
      .then(function (result) {
        if (!result || !result.dataUrl) throw new Error('Renderer returned no image');
        capturedDataUrl = result.dataUrl;
        capturedProps = result.props || {};
        var blob = dataUrlToBlob(capturedDataUrl);
        var filename = cfg.prefix + '-' + safeFilenamePart(detected.main) + '-' + Date.now() + '.png';
        return uploadImage(blob, filename);
      })
      .then(function (data) {
        var fname = data.filename;
        var fid = data.fileId;
        if (fid && typeof window.addUploadedFile === 'function') {
          window.addUploadedFile(fid, fname);
        }
        window.imageBlobs = window.imageBlobs || {};
        window.imageBlobs[fname] = capturedDataUrl;
        if (typeof window.addFileToTree === 'function') {
          window.addFileToTree(fname, true);
        }
        var anchorPos = anchorMark.find();
        if (anchorMark) anchorMark.clear();
        // For SMILES mode, prefer the parsed molecular formula in the caption —
        // a raw SMILES inside \ce{...} doesn't typeset cleanly with mhchem.
        var ceForCaption = detected.ceRaw;
        if (mode === 'smiles' && capturedProps && capturedProps.formula) {
          ceForCaption = '\\ce{' + capturedProps.formula + '}';
        }
        insertFigureBlock(cm, ceForCaption, fname, cfg.label, capturedProps, anchorPos);
        toast('Success', 'Inserted ' + cfg.label + ' for ' + detected.main);
      })
      .catch(function (err) {
        if (anchorMark) anchorMark.clear();
        toast('Error', (err && err.message) || ('Could not render ' + detected.main));
      });
  }

  window.ChemInsert = {
    detect: detect,
    render: render,
    ensureMhchem: ensureMhchem,
    MODES: ['lewis', 'smiles', '3d']
  };
})();
