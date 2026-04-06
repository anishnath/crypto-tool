/* ═══════════════════════════════════════════════════════════
   Logic Simulator — File I/O (Phase 9)
   JSON save/load, PNG export, SVG export, URL sharing.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const FileIO = {

    /* ═══════════ JSON Save / Load ═══════════ */

    /** Save circuit to JSON file download */
    saveJSON(circuit, filename) {
      const json = circuit.toJSON();
      const blob = new Blob([JSON.stringify(json, null, 2)], { type: 'application/json' });
      _download(blob, filename || 'circuit.json');
    },

    /** Load circuit from JSON file → returns parsed JSON (caller creates circuit via fromJSON) */
    loadJSON(callback) {
      const input = document.createElement('input');
      input.type = 'file';
      input.accept = '.json';
      input.addEventListener('change', () => {
        const file = input.files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = () => {
          try {
            const json = JSON.parse(reader.result);
            callback(null, json, file.name);
          } catch (e) {
            callback('Invalid JSON: ' + e.message);
          }
        };
        reader.onerror = () => callback('Failed to read file');
        reader.readAsText(file);
      });
      input.click();
    },

    /* ═══════════ PNG Export ═══════════ */

    /** Export SVG canvas to PNG download */
    exportPNG(svgElement, filename, scale) {
      scale = scale || 2;
      const svgRect = svgElement.getBoundingClientRect();
      const w = svgRect.width * scale;
      const h = svgRect.height * scale;

      // Clone SVG and inline styles
      const clone = svgElement.cloneNode(true);
      clone.setAttribute('width', w);
      clone.setAttribute('height', h);
      // Inject computed CSS vars as inline styles for portability
      clone.setAttribute('style', _getComputedVars(svgElement));

      const svgData = new XMLSerializer().serializeToString(clone);
      const blob = new Blob([svgData], { type: 'image/svg+xml;charset=utf-8' });
      const url = URL.createObjectURL(blob);

      const img = new Image();
      img.onload = () => {
        const canvas = document.createElement('canvas');
        canvas.width = w;
        canvas.height = h;
        const ctx = canvas.getContext('2d');
        // Background
        ctx.fillStyle = getComputedStyle(svgElement).getPropertyValue('--lg-canvas-bg').trim() || '#13151c';
        ctx.fillRect(0, 0, w, h);
        ctx.drawImage(img, 0, 0, w, h);
        URL.revokeObjectURL(url);

        canvas.toBlob(pngBlob => {
          if (pngBlob) _download(pngBlob, filename || 'circuit.png');
        }, 'image/png');
      };
      img.onerror = () => { URL.revokeObjectURL(url); };
      img.src = url;
    },

    /* ═══════════ SVG Export ═══════════ */

    /** Export SVG canvas as SVG file download */
    exportSVG(svgElement, filename) {
      const clone = svgElement.cloneNode(true);
      clone.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
      clone.setAttribute('style', _getComputedVars(svgElement));

      const svgData = '<?xml version="1.0" encoding="UTF-8"?>\n' +
                      new XMLSerializer().serializeToString(clone);
      const blob = new Blob([svgData], { type: 'image/svg+xml;charset=utf-8' });
      _download(blob, filename || 'circuit.svg');
    },

    /* ═══════════ URL Sharing ═══════════ */

    /** Encode circuit JSON to URL hash */
    encodeToHash(circuit) {
      const json = JSON.stringify(circuit.toJSON());
      const compressed = _b64Encode(json);
      return compressed;
    },

    /** Decode circuit JSON from URL hash */
    decodeFromHash(hash) {
      try {
        const json = _b64Decode(hash);
        return JSON.parse(json);
      } catch (e) {
        return null;
      }
    },

    /** Update URL hash with circuit data */
    shareURL(circuit) {
      const encoded = FileIO.encodeToHash(circuit);
      if (encoded.length > 8000) {
        return { error: 'Circuit too large for URL sharing (max ~6KB JSON)' };
      }
      const url = window.location.origin + window.location.pathname + '#logic=' + encoded;
      history.replaceState(null, '', '#logic=' + encoded);
      return { url };
    },

    /** Check if current URL has a shared circuit */
    loadFromHash() {
      const hash = window.location.hash;
      if (!hash.startsWith('#logic=')) return null;
      return FileIO.decodeFromHash(hash.slice(7));
    }
  };

  /* ── Helpers ── */
  function _download(blob, filename) {
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    setTimeout(() => { URL.revokeObjectURL(a.href); a.remove(); }, 100);
  }

  function _b64Encode(str) {
    try {
      const bytes = new TextEncoder().encode(str);
      return btoa(String.fromCharCode(...bytes));
    } catch (e) {
      return btoa(unescape(encodeURIComponent(str)));
    }
  }

  function _b64Decode(b64) {
    try {
      const bin = atob(b64);
      const bytes = new Uint8Array(bin.length);
      for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
      return new TextDecoder().decode(bytes);
    } catch (e) {
      return decodeURIComponent(escape(atob(b64)));
    }
  }

  function _getComputedVars(el) {
    const cs = getComputedStyle(el);
    const vars = ['--lg-bg','--lg-panel','--lg-border','--lg-text','--lg-muted','--lg-accent',
                  '--lg-canvas-bg','--lg-grid-dot','--lg-gate-fill','--lg-gate-stroke',
                  '--lg-success','--lg-error'];
    return vars.map(v => v + ':' + (cs.getPropertyValue(v).trim() || '')).join(';');
  }

  L.FileIO = FileIO;
})(window.LogicSim);
