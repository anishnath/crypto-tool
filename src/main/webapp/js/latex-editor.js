/**
 * LaTeX Equation Editor - JavaScript Engine
 */

let autoPreviewEnabled = true;

// LaTeX symbol definitions
const latexSymbols = {
    structures: [
        { latex: '\\frac{a}{b}', label: 'Fraction', cursor: 6 },
        { latex: 'x^{2}', label: 'Superscript', cursor: 3 },
        { latex: 'x_{i}', label: 'Subscript', cursor: 3 },
        { latex: '\\sqrt{x}', label: 'Square Root', cursor: 6 },
        { latex: '\\sqrt[n]{x}', label: 'Nth Root', cursor: 7 },
        { latex: '\\sum_{i=1}^{n}', label: 'Summation', cursor: 8 },
        { latex: '\\int_{a}^{b}', label: 'Integral', cursor: 7 },
        { latex: '\\lim_{x \\to \\infty}', label: 'Limit', cursor: 6 },
        { latex: '\\prod_{i=1}^{n}', label: 'Product', cursor: 8 },
        { latex: '\\bigcup_{i=1}^{n}', label: 'Union', cursor: 11 },
        { latex: '\\bigcap_{i=1}^{n}', label: 'Intersection', cursor: 11 },
        { latex: '\\begin{pmatrix}a & b\\\\c & d\\end{pmatrix}', label: '2×2 Matrix', cursor: 16 }
    ],
    functions: [
        { latex: '\\sin(x)', label: 'Sine' },
        { latex: '\\cos(x)', label: 'Cosine' },
        { latex: '\\tan(x)', label: 'Tangent' },
        { latex: '\\log(x)', label: 'Logarithm' },
        { latex: '\\ln(x)', label: 'Natural Log' },
        { latex: '\\exp(x)', label: 'Exponential' },
        { latex: '\\arcsin(x)', label: 'Arcsin' },
        { latex: '\\arccos(x)', label: 'Arccos' },
        { latex: '\\arctan(x)', label: 'Arctan' },
        { latex: '\\sinh(x)', label: 'Hyperbolic Sine' },
        { latex: '\\cosh(x)', label: 'Hyperbolic Cosine' },
        { latex: '\\tanh(x)', label: 'Hyperbolic Tangent' }
    ],
    operators: [
        { latex: '\\pm', label: 'Plus-Minus' },
        { latex: '\\mp', label: 'Minus-Plus' },
        { latex: '\\times', label: 'Times' },
        { latex: '\\div', label: 'Division' },
        { latex: '\\cdot', label: 'Dot' },
        { latex: '\\neq', label: 'Not Equal' },
        { latex: '\\leq', label: 'Less or Equal' },
        { latex: '\\geq', label: 'Greater or Equal' },
        { latex: '\\approx', label: 'Approximately' },
        { latex: '\\equiv', label: 'Equivalent' },
        { latex: '\\propto', label: 'Proportional' },
        { latex: '\\infty', label: 'Infinity' },
        { latex: '\\partial', label: 'Partial' },
        { latex: '\\nabla', label: 'Nabla' },
        { latex: '\\forall', label: 'For All' },
        { latex: '\\exists', label: 'Exists' },
        { latex: '\\in', label: 'Element Of' },
        { latex: '\\notin', label: 'Not Element Of' },
        { latex: '\\subset', label: 'Subset' },
        { latex: '\\supset', label: 'Superset' },
        { latex: '\\cup', label: 'Union' },
        { latex: '\\cap', label: 'Intersection' },
        { latex: '\\emptyset', label: 'Empty Set' },
        { latex: '\\mathbb{R}', label: 'Real Numbers' }
    ],
    greek: [
        { latex: '\\alpha', label: 'Alpha' },
        { latex: '\\beta', label: 'Beta' },
        { latex: '\\gamma', label: 'Gamma' },
        { latex: '\\delta', label: 'Delta' },
        { latex: '\\epsilon', label: 'Epsilon' },
        { latex: '\\zeta', label: 'Zeta' },
        { latex: '\\eta', label: 'Eta' },
        { latex: '\\theta', label: 'Theta' },
        { latex: '\\iota', label: 'Iota' },
        { latex: '\\kappa', label: 'Kappa' },
        { latex: '\\lambda', label: 'Lambda' },
        { latex: '\\mu', label: 'Mu' },
        { latex: '\\nu', label: 'Nu' },
        { latex: '\\xi', label: 'Xi' },
        { latex: '\\pi', label: 'Pi' },
        { latex: '\\rho', label: 'Rho' },
        { latex: '\\sigma', label: 'Sigma' },
        { latex: '\\tau', label: 'Tau' },
        { latex: '\\upsilon', label: 'Upsilon' },
        { latex: '\\phi', label: 'Phi' },
        { latex: '\\chi', label: 'Chi' },
        { latex: '\\psi', label: 'Psi' },
        { latex: '\\omega', label: 'Omega' },
        { latex: '\\Gamma', label: 'Gamma (Cap)' },
        { latex: '\\Delta', label: 'Delta (Cap)' },
        { latex: '\\Theta', label: 'Theta (Cap)' },
        { latex: '\\Lambda', label: 'Lambda (Cap)' },
        { latex: '\\Xi', label: 'Xi (Cap)' },
        { latex: '\\Pi', label: 'Pi (Cap)' },
        { latex: '\\Sigma', label: 'Sigma (Cap)' },
        { latex: '\\Phi', label: 'Phi (Cap)' },
        { latex: '\\Psi', label: 'Psi (Cap)' },
        { latex: '\\Omega', label: 'Omega (Cap)' }
    ],
    arrows: [
        { latex: '\\rightarrow', label: 'Right Arrow' },
        { latex: '\\leftarrow', label: 'Left Arrow' },
        { latex: '\\leftrightarrow', label: 'Left-Right Arrow' },
        { latex: '\\Rightarrow', label: 'Double Right' },
        { latex: '\\Leftarrow', label: 'Double Left' },
        { latex: '\\Leftrightarrow', label: 'Double Both' },
        { latex: '\\uparrow', label: 'Up Arrow' },
        { latex: '\\downarrow', label: 'Down Arrow' },
        { latex: '\\mapsto', label: 'Maps To' },
        { latex: '\\to', label: 'To' }
    ]
};

// Templates
const templates = [
    {
        name: 'Quadratic Formula',
        latex: 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}',
        category: 'Algebra'
    },
    {
        name: 'Pythagorean Theorem',
        latex: 'a^2 + b^2 = c^2',
        category: 'Geometry'
    },
    {
        name: 'Euler\'s Identity',
        latex: 'e^{i\\pi} + 1 = 0',
        category: 'Analysis'
    },
    {
        name: 'Derivative Definition',
        latex: 'f\'(x) = \\lim_{h \\to 0} \\frac{f(x+h) - f(x)}{h}',
        category: 'Calculus'
    },
    {
        name: 'Integral Definition',
        latex: '\\int_{a}^{b} f(x) dx = F(b) - F(a)',
        category: 'Calculus'
    },
    {
        name: 'Taylor Series',
        latex: 'f(x) = \\sum_{n=0}^{\\infty} \\frac{f^{(n)}(a)}{n!}(x-a)^n',
        category: 'Analysis'
    },
    {
        name: 'Normal Distribution',
        latex: 'f(x) = \\frac{1}{\\sigma\\sqrt{2\\pi}} e^{-\\frac{(x-\\mu)^2}{2\\sigma^2}}',
        category: 'Statistics'
    },
    {
        name: 'Binomial Theorem',
        latex: '(x+y)^n = \\sum_{k=0}^{n} \\binom{n}{k} x^{n-k} y^k',
        category: 'Algebra'
    },
    {
        name: 'Chain Rule',
        latex: '\\frac{d}{dx}[f(g(x))] = f\'(g(x)) \\cdot g\'(x)',
        category: 'Calculus'
    },
    {
        name: 'Matrix Multiplication',
        latex: '\\begin{pmatrix}a & b\\\\c & d\\end{pmatrix} \\begin{pmatrix}e & f\\\\g & h\\end{pmatrix} = \\begin{pmatrix}ae+bg & af+bh\\\\ce+dg & cf+dh\\end{pmatrix}',
        category: 'Linear Algebra'
    },
    {
        name: 'Cauchy-Schwarz Inequality',
        latex: '|\\langle u, v \\rangle| \\leq \\|u\\| \\|v\\|',
        category: 'Analysis'
    },
    {
        name: 'Fourier Transform',
        latex: 'F(\\omega) = \\int_{-\\infty}^{\\infty} f(t) e^{-i\\omega t} dt',
        category: 'Analysis'
    }
];

/**
 * Initialize the editor
 */
function init() {
    // Populate symbol buttons
    populateSymbolGrid('structuresGrid', latexSymbols.structures);
    populateSymbolGrid('functionsGrid', latexSymbols.functions);
    populateSymbolGrid('operatorsGrid', latexSymbols.operators);
    populateSymbolGrid('greekGrid', latexSymbols.greek);
    populateSymbolGrid('arrowsGrid', latexSymbols.arrows);

    // Populate templates
    populateTemplates();

    // Initial preview
    updatePreview();

    // Add input listener for auto-preview
    document.getElementById('latexInput').addEventListener('input', function() {
        if (autoPreviewEnabled) {
            updatePreview();
        }
    });

    // Load from URL if present
    loadFromURL();
}

/**
 * Populate symbol button grid
 */
function populateSymbolGrid(gridId, symbols) {
    const grid = document.getElementById(gridId);
    grid.innerHTML = '';

    symbols.forEach(symbol => {
        const btn = document.createElement('button');
        btn.className = 'latex-btn';
        btn.onclick = () => insertLatex(symbol.latex, symbol.cursor);

        const previewDiv = document.createElement('div');
        previewDiv.className = 'preview';
        try {
            katex.render(symbol.latex, previewDiv, {
                throwOnError: false,
                displayMode: false
            });
        } catch (e) {
            previewDiv.textContent = symbol.latex;
        }

        const labelDiv = document.createElement('div');
        labelDiv.className = 'label';
        labelDiv.textContent = symbol.label;

        btn.appendChild(previewDiv);
        btn.appendChild(labelDiv);
        grid.appendChild(btn);
    });
}

/**
 * Populate templates
 */
function populateTemplates() {
    const container = document.getElementById('templatesContainer');
    container.innerHTML = '';

    templates.forEach(template => {
        const card = document.createElement('div');
        card.className = 'template-card';
        card.onclick = () => loadTemplate(template.latex);

        const name = document.createElement('div');
        name.className = 'name';
        name.textContent = template.name;

        const preview = document.createElement('div');
        preview.className = 'preview-small';
        try {
            katex.render(template.latex, preview, {
                throwOnError: false,
                displayMode: true
            });
        } catch (e) {
            preview.textContent = 'Error rendering';
        }

        const code = document.createElement('div');
        code.className = 'code';
        code.textContent = template.latex;

        card.appendChild(name);
        card.appendChild(preview);
        card.appendChild(code);
        container.appendChild(card);
    });
}

/**
 * Insert LaTeX at cursor position
 */
function insertLatex(latex, cursorOffset = 0) {
    const input = document.getElementById('latexInput');
    const start = input.selectionStart;
    const end = input.selectionEnd;
    const text = input.value;

    // Insert latex at cursor
    const newText = text.substring(0, start) + latex + text.substring(end);
    input.value = newText;

    // Set cursor position
    const newCursorPos = start + (cursorOffset || latex.length);
    input.focus();
    input.setSelectionRange(newCursorPos, newCursorPos);

    if (autoPreviewEnabled) {
        updatePreview();
    }
}

/**
 * Load template
 */
function loadTemplate(latex) {
    document.getElementById('latexInput').value = latex;
    updatePreview();
    showMessage('Template loaded!', 'success');
}

/**
 * Update preview
 */
function updatePreview() {
    const input = document.getElementById('latexInput').value;
    const preview = document.getElementById('preview');
    const errorMsg = document.getElementById('errorMessage');

    errorMsg.style.display = 'none';

    if (!input.trim()) {
        preview.innerHTML = '<span style="color: #999;">Enter LaTeX code to see preview...</span>';
        return;
    }

    try {
        katex.render(input, preview, {
            throwOnError: true,
            displayMode: true
        });
    } catch (error) {
        errorMsg.textContent = 'LaTeX Error: ' + error.message;
        errorMsg.style.display = 'block';
        preview.innerHTML = '<span style="color: #dc3545;">Invalid LaTeX syntax</span>';
    }
}

/**
 * Clear input
 */
function clearInput() {
    if (confirm('Clear all input?')) {
        document.getElementById('latexInput').value = '';
        updatePreview();
    }
}

/**
 * Copy LaTeX to clipboard
 */
function copyLatex() {
    const input = document.getElementById('latexInput');
    input.select();
    document.execCommand('copy');
    showMessage('LaTeX code copied to clipboard!', 'success');
}

/**
 * Toggle auto-preview
 */
function toggleAutoPreview() {
    autoPreviewEnabled = document.getElementById('autoPreview').checked;
}

/**
 * Show message
 */
function showMessage(message, type) {
    const msgElement = document.getElementById(type === 'success' ? 'successMessage' : 'errorMessage');
    msgElement.textContent = message;
    msgElement.style.display = 'block';

    setTimeout(() => {
        msgElement.style.display = 'none';
    }, 3000);
}

/**
 * Export as PNG
 */
function exportAsImage() {
    const preview = document.getElementById('preview');

    // Create a canvas
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');

    // Set canvas size
    canvas.width = preview.offsetWidth * 2;
    canvas.height = preview.offsetHeight * 2;

    // Fill white background
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    // Get the SVG from KaTeX
    const svg = preview.querySelector('svg');
    if (svg) {
        const svgData = new XMLSerializer().serializeToString(svg);
        const img = new Image();
        const svgBlob = new Blob([svgData], {type: 'image/svg+xml;charset=utf-8'});
        const url = URL.createObjectURL(svgBlob);

        img.onload = function() {
            ctx.drawImage(img, 0, 0, canvas.width, canvas.height);

            // Download
            canvas.toBlob(function(blob) {
                const url = URL.createObjectURL(blob);
                const link = document.createElement('a');
                link.download = 'equation-' + Date.now() + '.png';
                link.href = url;
                link.click();
                URL.revokeObjectURL(url);
            });

            URL.revokeObjectURL(url);
        };

        img.src = url;
        showMessage('Image exported!', 'success');
    } else {
        alert('No equation to export. Please enter LaTeX code first.');
    }
}

/**
 * Export as SVG
 */
function exportAsSVG() {
    const preview = document.getElementById('preview');
    const svg = preview.querySelector('svg');

    if (svg) {
        const svgData = new XMLSerializer().serializeToString(svg);
        const blob = new Blob([svgData], {type: 'image/svg+xml;charset=utf-8'});
        const url = URL.createObjectURL(blob);

        const link = document.createElement('a');
        link.download = 'equation-' + Date.now() + '.svg';
        link.href = url;
        link.click();

        URL.revokeObjectURL(url);
        showMessage('SVG exported!', 'success');
    } else {
        alert('No equation to export. Please enter LaTeX code first.');
    }
}

/**
 * Share equation
 */
function shareEquation() {
    const latex = document.getElementById('latexInput').value;
    if (!latex.trim()) {
        alert('Please enter LaTeX code first.');
        return;
    }

    // Encode LaTeX to base64
    const encoded = btoa(encodeURIComponent(latex));
    const url = window.location.origin + window.location.pathname + '?eq=' + encoded;

    // Copy to clipboard
    navigator.clipboard.writeText(url).then(() => {
        showMessage('Share link copied to clipboard!', 'success');
    }).catch(() => {
        // Fallback
        prompt('Copy this link:', url);
    });
}

/**
 * Load from URL
 */
function loadFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    const encoded = urlParams.get('eq');

    if (encoded) {
        try {
            const latex = decodeURIComponent(atob(encoded));
            document.getElementById('latexInput').value = latex;
            updatePreview();
        } catch (e) {
            console.error('Error loading from URL:', e);
        }
    }
}

// Initialize when page loads
window.addEventListener('DOMContentLoaded', init);
