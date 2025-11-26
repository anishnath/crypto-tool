// TikZ Viewer using TikZJax (open-source)
// Custom JS kept under js/ per project guidelines

(function () {
  function $(id) { return document.getElementById(id); }

  const TIKZJAX_SRC = "https://tikzjax.com/v1/tikzjax.js"; // public CDN

  let editor = null;
  let autoRenderTimeout = null;
  const AUTO_RENDER_DELAY = 1500; // ms

  // Example gallery organized by category
  const EXAMPLES = {
    'Geometry': [
      {
        name: 'Coordinate Plane',
        code: `\\begin{tikzpicture}[scale=0.8]
  \\draw[step=1cm,gray!30,very thin] (-3,-2) grid (5,5);
  \\draw[->] (-3,0) -- (5,0) node[right] {$x$};
  \\draw[->] (0,-2) -- (0,5) node[above] {$y$};
  \\draw[thick,blue] (-2,-1) -- (4,4);
  \\fill[red] (2,3) circle (2pt) node[above right] {$P(2,3)$};
\\end{tikzpicture}`
      },
      {
        name: 'Circle and Tangent',
        code: `\\begin{tikzpicture}
  \\draw[thick] (0,0) circle (2cm);
  \\draw[blue,thick] (-3,1.732) -- (3,1.732);
  \\fill (0,2) circle (2pt) node[above] {Tangent Point};
  \\draw[dashed] (0,0) -- (0,2);
  \\node at (0,-2.5) {Circle with Tangent Line};
\\end{tikzpicture}`
      },
      {
        name: 'Triangle',
        code: `\\begin{tikzpicture}[scale=1.2]
  \\coordinate (A) at (0,0);
  \\coordinate (B) at (4,0);
  \\coordinate (C) at (1.5,3);
  \\draw[thick] (A) -- (B) -- (C) -- cycle;
  \\fill (A) circle (2pt) node[below left] {$A$};
  \\fill (B) circle (2pt) node[below right] {$B$};
  \\fill (C) circle (2pt) node[above] {$C$};
\\end{tikzpicture}`
      }
    ],
    'Graphs': [
      {
        name: 'Simple Graph',
        code: `\\begin{tikzpicture}
  \\draw[->] (0,0) -- (6,0) node[right] {$x$};
  \\draw[->] (0,0) -- (0,4) node[above] {$y$};
  \\draw[blue,thick,domain=0:5.5] plot (\\x,{0.1*\\x*\\x});
  \\node at (3,3.5) {$y = 0.1x^2$};
\\end{tikzpicture}`
      },
      {
        name: 'Node Graph',
        code: `\\begin{tikzpicture}[node distance=2cm]
  \\node[circle,draw] (A) {A};
  \\node[circle,draw] (B) [right of=A] {B};
  \\node[circle,draw] (C) [below of=A] {C};
  \\node[circle,draw] (D) [right of=C] {D};
  \\draw[->] (A) -- (B);
  \\draw[->] (A) -- (C);
  \\draw[->] (B) -- (D);
  \\draw[->] (C) -- (D);
\\end{tikzpicture}`
      },
      {
        name: 'Tree Structure',
        code: `\\begin{tikzpicture}[level distance=1.5cm,
  level 1/.style={sibling distance=3cm},
  level 2/.style={sibling distance=1.5cm}]
  \\node[circle,draw] {Root}
    child {node[circle,draw] {L}
      child {node[circle,draw] {LL}}
      child {node[circle,draw] {LR}}
    }
    child {node[circle,draw] {R}
      child {node[circle,draw] {RL}}
      child {node[circle,draw] {RR}}
    };
\\end{tikzpicture}`
      }
    ],
    'Diagrams': [
      {
        name: 'Flowchart',
        code: `\\begin{tikzpicture}[node distance=1.5cm]
  \\node[rectangle,draw] (start) {Start};
  \\node[diamond,draw,below of=start] (decision) {Decision?};
  \\node[rectangle,draw,below left of=decision] (no) {Action A};
  \\node[rectangle,draw,below right of=decision] (yes) {Action B};
  \\node[rectangle,draw,below of=decision,yshift=-2cm] (end) {End};
  \\draw[->] (start) -- (decision);
  \\draw[->] (decision) -| node[near start,left] {No} (no);
  \\draw[->] (decision) -| node[near start,right] {Yes} (yes);
  \\draw[->] (no) |- (end);
  \\draw[->] (yes) |- (end);
\\end{tikzpicture}`
      },
      {
        name: 'Venn Diagram',
        code: `\\begin{tikzpicture}
  \\draw[thick] (0,0) circle (1.5cm) node {$A$};
  \\draw[thick] (2,0) circle (1.5cm) node {$B$};
  \\node at (1,0) {$A \\cap B$};
  \\node at (-1.5,-2.5) {Venn Diagram};
\\end{tikzpicture}`
      },
      {
        name: 'Block Diagram',
        code: `\\begin{tikzpicture}[node distance=2.5cm]
  \\node[rectangle,draw,minimum width=2cm,minimum height=1cm] (input) {Input};
  \\node[rectangle,draw,minimum width=2cm,minimum height=1cm,right of=input] (process) {Process};
  \\node[rectangle,draw,minimum width=2cm,minimum height=1cm,right of=process] (output) {Output};
  \\draw[->,thick] (input) -- (process);
  \\draw[->,thick] (process) -- (output);
\\end{tikzpicture}`
      }
    ],
    'Mathematical': [
      {
        name: 'Unit Circle',
        code: `\\begin{tikzpicture}[scale=2]
  \\draw[->] (-1.3,0) -- (1.3,0) node[right] {$x$};
  \\draw[->] (0,-1.3) -- (0,1.3) node[above] {$y$};
  \\draw[thick] (0,0) circle (1cm);
  \\draw[blue,thick] (0,0) -- (45:1cm);
  \\fill (45:1cm) circle (1pt) node[above right] {$(\\cos\\theta,\\sin\\theta)$};
  \\draw[red] (0.3,0) arc (0:45:0.3) node[midway,right] {$\\theta$};
\\end{tikzpicture}`
      },
      {
        name: 'Sine Wave',
        code: `\\begin{tikzpicture}[scale=1.5]
  \\draw[->] (0,0) -- (7,0) node[right] {$x$};
  \\draw[->] (0,-1.5) -- (0,1.5) node[above] {$y$};
  \\draw[blue,thick,domain=0:6.28,samples=100] plot (\\x,{sin(\\x r)});
  \\node at (3.5,1.8) {$y = \\sin(x)$};
\\end{tikzpicture}`
      },
      {
        name: 'Vector Addition',
        code: `\\begin{tikzpicture}[scale=1.2]
  \\draw[->] (0,0) -- (3,1) node[midway,above] {$\\vec{a}$};
  \\draw[->] (3,1) -- (4,3) node[midway,right] {$\\vec{b}$};
  \\draw[->,thick,red] (0,0) -- (4,3) node[midway,below right] {$\\vec{a}+\\vec{b}$};
  \\draw[dashed] (0,0) -- (1,2);
  \\draw[dashed] (4,3) -- (1,2);
\\end{tikzpicture}`
      }
    ],
    'Circuits': [
      {
        name: 'Simple Circuit',
        code: `\\begin{tikzpicture}[circuit ee IEC]
  \\draw (0,0) to [battery] (0,2)
              to [resistor] (3,2)
              to [bulb] (3,0)
              to (0,0);
  \\node at (1.5,-0.5) {Basic Circuit};
\\end{tikzpicture}`,
        preamble: '\\usetikzlibrary{circuits.ee.IEC}'
      },
      {
        name: 'Logic Gates',
        code: `\\begin{tikzpicture}[circuit logic US]
  \\node[and gate] (and1) at (0,0) {};
  \\node[or gate] (or1) at (0,-2) {};
  \\node[not gate] (not1) at (3,0) {};
  \\draw (and1.input 1) -- ++(-1,0) node[left] {A};
  \\draw (and1.input 2) -- ++(-1,0) node[left] {B};
  \\draw (and1.output) -- (not1.input);
  \\draw (not1.output) -- ++(1,0) node[right] {Out};
\\end{tikzpicture}`,
        preamble: '\\usetikzlibrary{circuits.logic.US}'
      },
      {
        name: 'Resistor Network',
        code: `\\begin{tikzpicture}[>=stealth]
  \\draw (0,0) -- (2,0) node[midway,above] {$R_1$};
  \\draw (2,0) -- (2,-1.5) node[midway,right] {$R_2$};
  \\draw (2,0) -- (4,0) node[midway,above] {$R_3$};
  \\draw (0,0) circle (2pt);
  \\draw (4,0) circle (2pt);
  \\node at (2,-2.5) {Resistor Network};
\\end{tikzpicture}`
      }
    ],
    '3D Diagrams': [
      {
        name: 'Cube 3D',
        code: `\\begin{tikzpicture}[scale=1.5]
  \\draw[thick] (0,0) -- (2,0) -- (2,2) -- (0,2) -- cycle;
  \\draw[thick] (0,2) -- (0.5,2.5) -- (2.5,2.5) -- (2,2);
  \\draw[thick] (2,0) -- (2.5,0.5) -- (2.5,2.5);
  \\draw[dashed] (0,0) -- (0.5,0.5) -- (0.5,2.5);
  \\draw[dashed] (0.5,0.5) -- (2.5,0.5);
\\end{tikzpicture}`
      },
      {
        name: '3D Coordinate System',
        code: `\\begin{tikzpicture}[x={(1cm,0cm)}, y={(0.5cm,0.5cm)}, z={(0cm,1cm)}]
  \\draw[->] (0,0,0) -- (3,0,0) node[right] {$x$};
  \\draw[->] (0,0,0) -- (0,3,0) node[above right] {$y$};
  \\draw[->] (0,0,0) -- (0,0,3) node[above] {$z$};
  \\draw[blue,thick] (0,0,0) -- (2,2,2);
  \\fill[red] (2,2,2) circle (2pt);
\\end{tikzpicture}`
      },
      {
        name: 'Sphere Projection',
        code: `\\begin{tikzpicture}
  \\shade[ball color=blue!40] (0,0) circle (2cm);
  \\draw[thick] (0,0) circle (2cm);
  \\draw[thick,dashed] (-2,0) arc (180:360:2 and 0.6);
  \\draw[thick] (-2,0) arc (180:0:2 and 0.6);
  \\fill (0,0) circle (1.5pt);
\\end{tikzpicture}`
      }
    ],
    'Animations': [
      {
        name: 'Rotation Example',
        code: `\\begin{tikzpicture}[scale=1.2]
  \\draw[gray!30] (-2,-2) grid (2,2);
  \\draw[->] (-2.5,0) -- (2.5,0) node[right] {$x$};
  \\draw[->] (0,-2.5) -- (0,2.5) node[above] {$y$};
  \\draw[thick,blue,rotate=30] (-1,-1) rectangle (1,1);
  \\node at (0,-3) {Rotated Square (30°)};
\\end{tikzpicture}`
      },
      {
        name: 'Transformation Sequence',
        code: `\\begin{tikzpicture}
  \\draw[fill=blue!20] (0,0) rectangle (1,1);
  \\draw[fill=red!20,xshift=2cm] (0,0) rectangle (1,1);
  \\draw[fill=green!20,xshift=4cm,rotate=45] (0,0) rectangle (1,1);
  \\node at (0.5,-0.5) {Original};
  \\node at (2.5,-0.5) {Shifted};
  \\node at (4.5,-0.5) {Rotated};
\\end{tikzpicture}`
      },
      {
        name: 'Scale Animation',
        code: `\\begin{tikzpicture}[scale=1.5]
  \\foreach \\s in {0.3,0.6,1.0} {
    \\draw[blue,opacity=0.5,scale=\\s] (0,0) circle (1cm);
  }
  \\fill (0,0) circle (2pt);
  \\node at (0,-2) {Scaling Effect};
\\end{tikzpicture}`
      }
    ]
  };

  function showError(msg) {
    const el = $('errorMessage');
    el.textContent = msg || '';
    el.style.display = msg ? 'block' : 'none';
  }

  function showLoading(show) {
    const overlay = $('loading-overlay');
    if (show) {
      overlay.classList.add('show');
    } else {
      overlay.classList.remove('show');
    }
  }

  function buildIframeHtml(tikz) {
    // Ensure it's wrapped in a tikzpicture environment if user pasted only contents
    const hasEnv = /\\begin\{tikzpicture\}[\s\S]*\\end\{tikzpicture\}/.test(tikz);
    const bodyTikz = hasEnv ? tikz : ("\\begin{tikzpicture}\n" + tikz + "\n\\end{tikzpicture}");

    // Minimal HTML that TikZJax will process on load
    return `<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
      body {
        margin: 0;
        padding: 20px;
        font-family: system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,Cantarell,Noto Sans,sans-serif;
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
      }
      svg {
        display: block;
        margin: auto;
      }
    </style>
    <script src="${TIKZJAX_SRC}"></script>
  </head>
  <body>
    <script type="text/tikz">
${bodyTikz}
    </script>
  </body>
</html>`;
  }

  // Strip full LaTeX preamble and keep only tikzpicture; keep \usetikzlibrary lines before it
  function sanitizeTikzInput(code) {
    let modified = false;
    let c = code || '';

    // Collect \usetikzlibrary lines
    const libRegex = /^\s*\\usetikzlibrary\{[^}]+\}\s*$/gm;
    const libs = c.match(libRegex);
    if (libs && libs.length) {
      c = c.replace(libRegex, '');
      modified = true;
    }

    // Remove documentclass, usepackage, begin/end{document}
    const dropPatterns = [/^\s*\\documentclass[^\n]*$/gm, /^\s*\\usepackage[^\n]*$/gm, /\\begin\{document\}/g, /\\end\{document\}/g];
    dropPatterns.forEach(rx => { if (rx.test(c)) { c = c.replace(rx, ''); modified = true; } });

    // Extract first tikzpicture environment if present
    const envMatch = c.match(/\\begin\{tikzpicture\}[\s\S]*?\\end\{tikzpicture\}/);
    if (envMatch) {
      const tikzBlock = envMatch[0].trim();
      const libsJoined = libs && libs.length ? libs.join('\n') + '\n\n' : '';
      c = libsJoined + tikzBlock;
      modified = true;
    }

    return { code: c.trim(), modified };
  }

  function render() {
    let input = editor ? editor.getValue() : $('tikzInput').value;
    // Auto-sanitize input: keep tikzpicture and \usetikzlibrary in code
    const san = sanitizeTikzInput(input);
    if (san.modified) {
      input = san.code;
      if (editor) editor.setValue(input); else $('tikzInput').value = input;
    }
    // Clear any previous error/info banner
    showError('');

    showLoading(true);
    const html = buildIframeHtml(input);
    const iframe = $('viewer');
    iframe.srcdoc = html;

    // Hide loading after a short delay (TikZJax loads async)
    setTimeout(() => showLoading(false), 800);
  }

  function debouncedRender() {
    if (autoRenderTimeout) clearTimeout(autoRenderTimeout);
    autoRenderTimeout = setTimeout(render, AUTO_RENDER_DELAY);
  }

  function clearInput() {
    if (editor) {
      editor.setValue('');
    } else {
      $('tikzInput').value = '';
    }
    showError('');
    $('viewer').srcdoc = buildIframeHtml('');
  }

  function exportSVG() {
    const doc = $('viewer').contentDocument;
    if (!doc) { alert('Please render first.'); return; }
    const svg = doc.querySelector('svg');
    if (!svg) { alert('No SVG found. Check TikZ syntax.'); return; }
    const data = new XMLSerializer().serializeToString(svg);
    const blob = new Blob([data], { type: 'image/svg+xml;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = '8gwifi.org-tikz-diagram-' + Date.now() + '.svg';
    a.click();
    URL.revokeObjectURL(url);
  }

  function exportPNG() {
    const doc = $('viewer').contentDocument;
    if (!doc) { alert('Please render first.'); return; }
    const svg = doc.querySelector('svg');
    if (!svg) { alert('No SVG found. Check TikZ syntax.'); return; }

    const data = new XMLSerializer().serializeToString(svg);
    const blob = new Blob([data], { type: 'image/svg+xml;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const img = new Image();
    img.onload = function () {
      const scale = 2;
      const canvas = document.createElement('canvas');
      const ctx = canvas.getContext('2d');
      // Use intrinsic SVG size when available
      const w = img.width || 800; const h = img.height || 600;
      canvas.width = Math.max(1, Math.floor(w * scale));
      canvas.height = Math.max(1, Math.floor(h * scale));
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
      canvas.toBlob(function (pngBlob) {
        const dl = URL.createObjectURL(pngBlob);
        const a = document.createElement('a');
        a.href = dl;
        a.download = '8gwifi.org-tikz-diagram-' + Date.now() + '.png';
        a.click();
        URL.revokeObjectURL(dl);
      });
      URL.revokeObjectURL(url);
    };
    img.src = url;
  }

  function exportPDF() {
    const doc = $('viewer').contentDocument;
    if (!doc) { alert('Please render first.'); return; }
    const svg = doc.querySelector('svg');
    if (!svg) { alert('No SVG found. Check TikZ syntax.'); return; }

    const data = new XMLSerializer().serializeToString(svg);
    const blob = new Blob([data], { type: 'image/svg+xml;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const img = new Image();

    img.onload = function () {
      const canvas = document.createElement('canvas');
      const ctx = canvas.getContext('2d');
      const w = img.width || 800;
      const h = img.height || 600;
      canvas.width = w;
      canvas.height = h;
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      ctx.drawImage(img, 0, 0);

      // Convert canvas to PDF using jsPDF
      const { jsPDF } = window.jspdf;
      const pdf = new jsPDF({
        orientation: w > h ? 'landscape' : 'portrait',
        unit: 'px',
        format: [w, h]
      });

      const imgData = canvas.toDataURL('image/png');
      pdf.addImage(imgData, 'PNG', 0, 0, w, h);
      pdf.save('8gwifi.org-tikz-diagram-' + Date.now() + '.pdf');
      URL.revokeObjectURL(url);
    };
    img.src = url;
  }

  function copyLatexToClipboard() {
    const input = editor ? editor.getValue() : $('tikzInput').value;
    const fullLatex = input;


    if (navigator.clipboard) {
      navigator.clipboard.writeText(fullLatex).then(() => {
        // Visual feedback
        const btn = $('btn-copy-latex');
        const originalHTML = btn.innerHTML;
        btn.innerHTML = '✓';
        btn.classList.add('btn-success');
        btn.classList.remove('btn-outline-success');
        setTimeout(() => {
          btn.innerHTML = originalHTML;
          btn.classList.remove('btn-success');
          btn.classList.add('btn-outline-success');
        }, 1500);
      }).catch(() => {
        alert('Failed to copy to clipboard');
      });
    } else {
      // Fallback for older browsers
      const textarea = document.createElement('textarea');
      textarea.value = fullLatex;
      document.body.appendChild(textarea);
      textarea.select();
      document.execCommand('copy');
      document.body.removeChild(textarea);
      alert('LaTeX code copied to clipboard!');
    }
  }

  // Zoom functionality
  let currentZoom = 1.0;
  const ZOOM_STEP = 0.1;
  const MIN_ZOOM = 0.5;
  const MAX_ZOOM = 3.0;

  function updateZoom() {
    const viewer = $('viewer');
    viewer.style.transform = `scale(${currentZoom})`;
    $('zoom-level').textContent = Math.round(currentZoom * 100) + '%';
  }

  // Expand viewer to full width toggle
  let expanded = false;
  function applyExpand() {
    const editorCol = $('editorCol');
    const viewerCol = $('viewerCol');
    const btn = $('btn-expand');
    if (!editorCol || !viewerCol || !btn) return;
    if (expanded) {
      // Full width viewer
      editorCol.style.display = 'none';
      viewerCol.classList.remove('col-lg-6');
      viewerCol.classList.add('col-lg-12');
      btn.textContent = 'Shrink';
    } else {
      // Split view
      viewerCol.classList.remove('col-lg-12');
      viewerCol.classList.add('col-lg-6');
      editorCol.style.display = '';
      btn.textContent = 'Expand';
    }
    try { localStorage.setItem('tikz_expanded', expanded ? '1' : '0'); } catch(_) {}
  }

  function zoomIn() {
    if (currentZoom < MAX_ZOOM) {
      currentZoom = Math.min(currentZoom + ZOOM_STEP, MAX_ZOOM);
      updateZoom();
    }
  }

  function zoomOut() {
    if (currentZoom > MIN_ZOOM) {
      currentZoom = Math.max(currentZoom - ZOOM_STEP, MIN_ZOOM);
      updateZoom();
    }
  }

  function zoomReset() {
    currentZoom = 1.0;
    updateZoom();
  }

  function loadExample(code, preamble = '') {
    const combined = (preamble ? preamble + '\n\n' : '') + code;
    if (editor) {
      editor.setValue(combined);
    } else {
      $('tikzInput').value = combined;
    }
    render();
  }

  function populateExamples() {
    const menu = $('examples-menu');
    Object.keys(EXAMPLES).forEach(category => {
      // Add category header
      const categoryLi = document.createElement('li');
      const categoryDiv = document.createElement('div');
      categoryDiv.className = 'example-category';
      categoryDiv.textContent = category;
      categoryLi.appendChild(categoryDiv);
      menu.appendChild(categoryLi);

      // Add examples in this category
      EXAMPLES[category].forEach(example => {
        const li = document.createElement('li');
        const div = document.createElement('div');
        div.className = 'example-item';
        div.textContent = example.name;
        div.onclick = () => loadExample(example.code, example.preamble || '');
        li.appendChild(div);
        menu.appendChild(li);
      });
    });
  }

  function shareURL() {
    const input = editor ? editor.getValue() : $('tikzInput').value;

    // Encode the TikZ code in URL
    const params = new URLSearchParams();
    params.set('code', input);

    const shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();

    // Copy to clipboard
    if (navigator.clipboard) {
      navigator.clipboard.writeText(shareUrl).then(() => {
        alert('Shareable URL copied to clipboard!');
      }).catch(() => {
        prompt('Copy this URL to share:', shareUrl);
      });
    } else {
      prompt('Copy this URL to share:', shareUrl);
    }
  }

  function loadFromURL() {
    const params = new URLSearchParams(window.location.search);
    const code = params.get('code');

    if (code) {
      if (editor) {
        editor.setValue(code);
      } else {
        $('tikzInput').value = code;
      }
    }

    // Auto-render if we loaded from URL
    if (code) {
      setTimeout(render, 500);
    }
  }

  function initCodeMirror() {
    const textarea = $('tikzInput');
    editor = CodeMirror.fromTextArea(textarea, {
      mode: 'stex',
      lineNumbers: true,
      matchBrackets: true,
      autoCloseBrackets: true,
      theme: 'default',
      indentUnit: 2,
      tabSize: 2,
      lineWrapping: true,
      extraKeys: {
        'Ctrl-Enter': render,
        'Cmd-Enter': render
      }
    });

    // Auto-render on change if enabled
    editor.on('change', () => {
      if ($('auto-render') && $('auto-render').checked) {
        debouncedRender();
      }
    });
  }

  function init() {
    // Initialize CodeMirror
    initCodeMirror();

    // Restore from localStorage (unless URL provided)
    try {
      if (!window.location.search) {
        const saved = localStorage.getItem('tikz_code');
        if (saved) {
          if (editor) editor.setValue(saved); else $('tikzInput').value = saved;
        }
      }
    } catch(_) {}

    // Populate examples dropdown
    populateExamples();

    // Event listeners
    $('btn-render').addEventListener('click', render);
    $('btn-clear').addEventListener('click', clearInput);
    $('btn-svg').addEventListener('click', exportSVG);
    $('btn-png').addEventListener('click', exportPNG);
    $('btn-pdf').addEventListener('click', exportPDF);
    $('btn-share').addEventListener('click', shareURL);
    $('btn-copy-latex').addEventListener('click', copyLatexToClipboard);
    $('btn-download-tex').addEventListener('click', downloadTex);
    $('input-upload-tex').addEventListener('change', uploadTex);
    if ($('btn-expand')) {
      $('btn-expand').addEventListener('click', function(){ expanded = !expanded; applyExpand(); });
    }

    // Zoom controls
    $('btn-zoom-in').addEventListener('click', zoomIn);
    $('btn-zoom-out').addEventListener('click', zoomOut);
    $('btn-zoom-reset').addEventListener('click', zoomReset);

    // Auto-render toggle
    $('auto-render').addEventListener('change', (e) => {
      if (e.target.checked) {
        debouncedRender();
      }
    });

    // Dark theme toggle
    const themeToggle = $('cmThemeToggle');
    if (themeToggle){
      try{
        const pref = localStorage.getItem('tikz_cm_dark');
        const on = pref === '1';
        themeToggle.checked = on;
        setCmTheme(on);
      }catch(_){ setCmTheme(false); }
      themeToggle.addEventListener('change', function(){ setCmTheme(this.checked); });
    }

    // Load from URL if present
    loadFromURL();

    // Initial blank render if no URL params
    if (!window.location.search) {
      $('viewer').srcdoc = buildIframeHtml('');
    }

    // Restore expand preference
    try { expanded = (localStorage.getItem('tikz_expanded') === '1'); } catch(_) { expanded = false; }
    applyExpand();
  }

  window.addEventListener('DOMContentLoaded', init);

  // Persist editor state
  function persist(){
    try{
      const code = editor ? editor.getValue() : ($('tikzInput')? $('tikzInput').value : '');
      localStorage.setItem('tikz_code', code);
    }catch(_){ }
  }
  // Hook persistence into changes
  document.addEventListener('keyup', function(e){ if (e.target && e.target.id==='tikzInput') persist(); });
  setInterval(persist, 3000);

  // Editor theme
  function setCmTheme(dark){
    if (!editor) return;
    editor.setOption('theme', dark ? 'monokai' : 'default');
    try{ localStorage.setItem('tikz_cm_dark', dark? '1':'0'); }catch(_){ }
  }

  // Download .tex file
  function downloadTex(){
    const code = editor ? editor.getValue() : ($('tikzInput')? $('tikzInput').value : '');
    const blob = new Blob([ code ], {type:'text/x-tex'});
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = 'diagram-'+Date.now()+'.tex';
    document.body.appendChild(a); a.click(); document.body.removeChild(a);
    setTimeout(()=>URL.revokeObjectURL(a.href), 1000);
  }

  // Upload .tex file
  function uploadTex(e){
    const f = e.target.files && e.target.files[0];
    if (!f) return;
    const reader = new FileReader();
    reader.onload = function(){
      let text = String(reader.result||'');
      // Sanitize on import
      const san = sanitizeTikzInput(text);
      if (editor) editor.setValue(san.code); else if ($('tikzInput')) $('tikzInput').value = san.code;
      debouncedRender();
    };
    reader.readAsText(f);
    e.target.value = '';
  }
})();
