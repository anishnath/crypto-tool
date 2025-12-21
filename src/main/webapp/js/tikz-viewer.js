// TikZ Viewer using TikZJax (open-source)
// Custom JS kept under js/ per project guidelines

(function () {
  function $(id) { return document.getElementById(id); }

  const TIKZJAX_SRC = "https://tikzjax.com/v1/tikzjax.js"; // public CDN

  let editor = null;
  let autoRenderTimeout = null;
  const AUTO_RENDER_DELAY = 1500; // ms
  // Prevent auto-render loops when we update the editor programmatically
  let suppressAuto = false;

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
        code: `\\begin{tikzpicture}[scale=1.2]
  % Battery
  \\draw[thick] (0,0) -- (0,0.3);
  \\draw[thick] (-0.3,0.3) -- (0.3,0.3);
  \\draw[thick] (-0.2,0.5) -- (0.2,0.5);
  \\draw[thick] (0,0.5) -- (0,1);
  \\node[left] at (-0.3,0.4) {$+$};
  \\node[left] at (-0.3,0.15) {$-$};

  % Top wire
  \\draw[thick] (0,1) -- (3,1);

  % Resistor
  \\draw[thick] (3,1) -- (3,0.8);
  \\draw[thick] (2.8,0.8) rectangle (3.2,0.2);
  \\node[right] at (3.2,0.5) {$R$};
  \\draw[thick] (3,0.2) -- (3,0);

  % Bottom wire
  \\draw[thick] (3,0) -- (0,0);

  % Labels
  \\node at (1.5,-0.6) {Basic Circuit};
\\end{tikzpicture}`
      },
      {
        name: 'Logic Gates',
        code: `\\begin{tikzpicture}[scale=0.8]
  % AND Gate
  \\draw[thick] (0,2) -- (0.5,2) arc[start angle=90, end angle=-90, radius=0.5] -- (0,1) -- cycle;
  \\draw[thick] (-0.5,2.3) -- (0,2.3) node[left] at (-0.5,2.3) {A};
  \\draw[thick] (-0.5,1.7) -- (0,1.7) node[left] at (-0.5,1.7) {B};
  \\draw[thick] (1,1.5) -- (1.5,1.5);
  \\node at (0.5,2.8) {AND};

  % OR Gate
  \\draw[thick] (0,0) .. controls (0.3,0) and (0.3,0) .. (0.5,0.5) .. controls (0.3,1) and (0.3,1) .. (0,1);
  \\draw[thick] (0,0.5) .. controls (0.2,0.5) .. (0,1);
  \\draw[thick] (-0.5,0.7) -- (0,0.7) node[left] at (-0.5,0.7) {C};
  \\draw[thick] (-0.5,0.3) -- (0,0.3) node[left] at (-0.5,0.3) {D};
  \\draw[thick] (0.5,0.5) -- (1,0.5);
  \\node at (0.25,1.3) {OR};

  % NOT Gate (Inverter)
  \\draw[thick] (2.5,1.5) -- (2.5,2) -- (3.2,1.75) -- cycle;
  \\draw[thick] (3.2,1.75) circle (0.1);
  \\draw[thick] (1.5,1.5) -- (2.5,1.75);
  \\draw[thick] (3.3,1.75) -- (3.8,1.75) node[right] {Out};
  \\node at (2.85,2.3) {NOT};

  \\node at (1.5,-0.8) {Digital Logic Gates};
\\end{tikzpicture}`
      },
      {
        name: 'Series-Parallel Circuit',
        code: `\\begin{tikzpicture}[scale=1.1]
  % Power source
  \\draw[thick] (0,0) circle (0.3);
  \\node at (0,0) {V};
  \\draw[thick] (0,0.3) -- (0,1);
  \\draw[thick] (0,-0.3) -- (0,-1);

  % Top branch with R1
  \\draw[thick] (0,1) -- (2,1);
  \\draw[thick,fill=white] (2,1) rectangle (2.8,0.6);
  \\node at (2.4,0.8) {$R_1$};
  \\draw[thick] (2.8,0.8) -- (4,0.8);

  % Parallel branches R2 and R3
  \\draw[thick] (4,0.8) -- (4,1.2);
  \\draw[thick] (4,0.8) -- (4,0.4);

  % R2 branch
  \\draw[thick] (4,1.2) -- (5,1.2);
  \\draw[thick,fill=white] (5,1.2) rectangle (5.8,0.8);
  \\node at (5.4,1) {$R_2$};
  \\draw[thick] (5.8,1) -- (6.5,1);

  % R3 branch
  \\draw[thick] (4,0.4) -- (5,0.4);
  \\draw[thick,fill=white] (5,0.4) rectangle (5.8,0);
  \\node at (5.4,0.2) {$R_3$};
  \\draw[thick] (5.8,0.2) -- (6.5,0.2);

  % Join parallel branches
  \\draw[thick] (6.5,1) -- (6.5,0.8);
  \\draw[thick] (6.5,0.2) -- (6.5,0.4);

  % Return to source
  \\draw[thick] (6.5,0.6) -- (7,0.6) -- (7,-1) -- (0,-1);

  \\node at (3.5,-1.5) {Series-Parallel Circuit};
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
  % Grid and axes
  \\draw[gray!30] (-3,-3) grid (3,3);
  \\draw[->] (-3.5,0) -- (3.5,0) node[right] {$x$};
  \\draw[->] (0,-3.5) -- (0,3.5) node[above] {$y$};

  % Original square (semi-transparent)
  \\draw[thick,blue!30,fill=blue!10] (-1,-1) rectangle (1,1);
  \\node[blue!50] at (0,0) {Original};

  % Rotated square using coordinate transformation
  \\draw[thick,red,fill=red!20,rotate=45] (-1,-1) rectangle (1,1);

  % Rotation arc
  \\draw[->,thick,green!70!black] (1.5,0) arc (0:45:1.5);
  \\node[green!70!black] at (1.8,0.5) {$45^\\circ$};

  % Center point
  \\fill[black] (0,0) circle (2pt);

  \\node at (0,-4) {Rotated Square (45 degrees)};
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
      if (editor) { suppressAuto = true; editor.setValue(input); suppressAuto = false; }
      else $('tikzInput').value = input;
    }
    // Clear any previous error/info banner
    showError('');

    showLoading(true);
    const html = buildIframeHtml(input);
    const iframe = $('viewer');
    iframe.srcdoc = html;

    // Wait for iframe to load, then poll for SVG (TikZJax renders async)
    iframe.onload = function() {
      waitForTikzRender(iframe, 50, 10000); // Check every 50ms, timeout after 10s
    };
  }

  // Poll for SVG element to appear (TikZJax renders asynchronously)
  function waitForTikzRender(iframe, interval, timeout) {
    const startTime = Date.now();

    function checkSvg() {
      try {
        const doc = iframe.contentDocument;
        const svg = doc && doc.querySelector('svg');

        if (svg) {
          // SVG found - rendering complete
          showLoading(false);
          return;
        }

        // Check for error message in iframe
        const errorText = doc && doc.body && doc.body.textContent;
        if (errorText && errorText.toLowerCase().includes('error')) {
          showLoading(false);
          return;
        }

        // Timeout check
        if (Date.now() - startTime > timeout) {
          showLoading(false);
          return;
        }

        // Keep polling
        setTimeout(checkSvg, interval);
      } catch (e) {
        // Cross-origin or other error - hide loading
        showLoading(false);
      }
    }

    // Start polling after a brief delay to let TikZJax initialize
    setTimeout(checkSvg, 200);
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
    // Toast notification and support popup
    if (window.ToolUtils) {
      if (ToolUtils.showToast) ToolUtils.showToast('SVG downloaded!', 2000, 'success');
      setTimeout(function() {
        if (ToolUtils.showSupportPopup) ToolUtils.showSupportPopup('TikZ Viewer', 'Downloaded SVG diagram');
      }, 500);
    }
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
        // Toast notification and support popup
        if (window.ToolUtils) {
          if (ToolUtils.showToast) ToolUtils.showToast('PNG downloaded!', 2000, 'success');
          setTimeout(function() {
            if (ToolUtils.showSupportPopup) ToolUtils.showSupportPopup('TikZ Viewer', 'Downloaded PNG diagram');
          }, 500);
        }
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
      // Toast notification and support popup
      if (window.ToolUtils) {
        if (ToolUtils.showToast) ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        setTimeout(function() {
          if (ToolUtils.showSupportPopup) ToolUtils.showSupportPopup('TikZ Viewer', 'Downloaded PDF diagram');
        }, 500);
      }
    };
    img.src = url;
  }

  function copyLatexToClipboard() {
    const input = editor ? editor.getValue() : $('tikzInput').value;

    // Use ToolUtils if available, fallback to basic copy
    if (window.ToolUtils && ToolUtils.copyToClipboard) {
      ToolUtils.copyToClipboard(input, {
        toastMessage: 'LaTeX code copied!',
        showSupportPopup: true,
        toolName: 'TikZ Viewer',
        resultText: 'Copied LaTeX code'
      });
    } else {
      // Fallback
      if (navigator.clipboard) {
        navigator.clipboard.writeText(input).then(() => {
          alert('LaTeX code copied to clipboard!');
        }).catch(() => {
          alert('Failed to copy to clipboard');
        });
      } else {
        const textarea = document.createElement('textarea');
        textarea.value = input;
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
        alert('LaTeX code copied to clipboard!');
      }
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
    if (editor) { suppressAuto = true; editor.setValue(combined); suppressAuto = false; } else { $('tikzInput').value = combined; }
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

    // Use ToolUtils if available
    if (window.ToolUtils && ToolUtils.copyToClipboard) {
      ToolUtils.copyToClipboard(shareUrl, {
        toastMessage: 'Share URL copied to clipboard!',
        showSupportPopup: true,
        toolName: 'TikZ Viewer'
      });
    } else {
      // Fallback
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
  }

  // Local storage: save/load/manage multiple TikZ snippets
  function saveTikzSet(){
    const name = prompt('Enter a name for this TikZ diagram:');
    if (!name) return;
    const code = editor ? editor.getValue() : ($('tikzInput')? $('tikzInput').value : '');
    const entry = { name, code, timestamp: Date.now() };
    try{
      const saved = JSON.parse(localStorage.getItem('tikz_saved_sets') || '[]');
      saved.push(entry);
      localStorage.setItem('tikz_saved_sets', JSON.stringify(saved));
      alert(`Saved "${name}" locally.`);
    }catch(e){ alert('Unable to save locally: ' + e.message); }
  }

  function loadTikzSet(){
    try{
      const saved = JSON.parse(localStorage.getItem('tikz_saved_sets') || '[]');
      if (!saved.length){ alert('No saved diagrams found.'); return; }
      let msg = 'Select a diagram to load:\n\n';
      saved.forEach((s,i)=>{ msg += `${i+1}. ${s.name} (${new Date(s.timestamp).toLocaleString()})\n`; });
      const pick = prompt(msg + '\nEnter number:');
      const idx = parseInt(pick) - 1;
      if (isNaN(idx) || idx<0 || idx>=saved.length){ alert('Invalid selection'); return; }
      const code = saved[idx].code;
      if (editor) editor.setValue(code); else if ($('tikzInput')) $('tikzInput').value = code;
      debouncedRender();
    }catch(e){ alert('Unable to load: ' + e.message); }
  }

  function manageTikzSets(){
    try{
      const saved = JSON.parse(localStorage.getItem('tikz_saved_sets') || '[]');
      if (!saved.length){ alert('No saved diagrams found.'); return; }
      let msg = 'Saved diagrams:\n\n';
      saved.forEach((s,i)=>{ msg += `${i+1}. ${s.name} (${new Date(s.timestamp).toLocaleString()})\n`; });
      msg += '\nEnter number to delete, or "all" to delete all:';
      const pick = prompt(msg);
      if (!pick) return;
      if (pick.toLowerCase() === 'all'){ if(confirm('Delete ALL saved diagrams?')){ localStorage.removeItem('tikz_saved_sets'); alert('All cleared.'); } return; }
      const idx = parseInt(pick)-1;
      if (isNaN(idx) || idx<0 || idx>=saved.length){ alert('Invalid selection'); return; }
      const name = saved[idx].name;
      if (confirm(`Delete "${name}"?`)){
        saved.splice(idx,1);
        localStorage.setItem('tikz_saved_sets', JSON.stringify(saved));
        alert('Deleted.');
      }
    }catch(e){ alert('Unable to manage: ' + e.message); }
  }

  function loadFromURL() {
    const params = new URLSearchParams(window.location.search);
    const code = params.get('code');

    if (code) {
      if (editor) { suppressAuto = true; editor.setValue(code); suppressAuto = false; } else { $('tikzInput').value = code; }
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

    // Auto-render on change if enabled (skip when setValue programmatically)
    editor.on('change', () => {
      if (suppressAuto) return;
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
        if (saved) { if (editor) { suppressAuto = true; editor.setValue(saved); suppressAuto = false; } else $('tikzInput').value = saved; }
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
    if ($('btn-save-local')) $('btn-save-local').addEventListener('click', saveTikzSet);
    if ($('btn-load-local')) $('btn-load-local').addEventListener('click', loadTikzSet);
    if ($('btn-manage-local')) $('btn-manage-local').addEventListener('click', manageTikzSets);
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
      if (editor) { suppressAuto = true; editor.setValue(san.code); suppressAuto = false; } else if ($('tikzInput')) $('tikzInput').value = san.code;
      debouncedRender();
    };
    reader.readAsText(f);
    e.target.value = '';
  }
})();
