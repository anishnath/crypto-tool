/**
 * LaTeX Document Editor
 * Full-featured LaTeX document editor with live preview, PDF export, and session storage
 */

// Storage keys
const STORAGE_KEY = 'latex_documents';
const AUTO_SAVE_KEY = 'latex_auto_save';
const CURRENT_DOC_KEY = 'latex_current_doc';

// Editor instance
let editor = null;
let autoCompileEnabled = true;
let autoSaveTimer = null;
let compileTimer = null;

/**
 * LaTeX Document Templates
 */
const templates = {
    article: `\\documentclass[12pt]{article}
\\usepackage[utf8]{inputenc}
\\usepackage{amsmath}
\\usepackage{graphicx}
\\usepackage{hyperref}

\\title{Your Article Title}
\\author{Your Name}
\\date{\\today}

\\begin{document}

\\maketitle

\\begin{abstract}
This is a brief summary of your article. Write a concise overview of your work here.
\\end{abstract}

\\section{Introduction}
Write your introduction here. You can include mathematical equations like this: $E = mc^2$.

For displayed equations, use:
\\[ \\int_{a}^{b} f(x) dx = F(b) - F(a) \\]

\\section{Methods}
Describe your methodology here.

\\subsection{First Subsection}
Add details about your methods.

\\section{Results}
Present your findings here. You can add lists:

\\begin{itemize}
    \\item First result
    \\item Second result
    \\item Third result
\\end{itemize}

\\section{Conclusion}
Summarize your work and draw conclusions.

\\end{document}`,

    report: `\\documentclass[12pt]{report}
\\usepackage[utf8]{inputenc}
\\usepackage{amsmath}
\\usepackage{graphicx}
\\usepackage{hyperref}

\\title{Technical Report Title}
\\author{Your Name}
\\date{\\today}

\\begin{document}

\\maketitle
\\tableofcontents

\\chapter{Introduction}
\\section{Background}
Provide background information for your report.

\\section{Problem Statement}
Clearly state the problem you're addressing.

\\chapter{Literature Review}
Discuss relevant prior work and research.

\\chapter{Methodology}
\\section{Approach}
Describe your approach to solving the problem.

\\section{Implementation}
Provide implementation details.

\\chapter{Results and Analysis}
Present and analyze your results here.

\\chapter{Conclusion}
\\section{Summary}
Summarize your findings.

\\section{Future Work}
Discuss potential future directions.

\\end{document}`,

    letter: `\\documentclass{article}
\\usepackage[utf8]{inputenc}

\\title{Business Letter}
\\date{}

\\begin{document}

\\noindent
\\textbf{Your Name} \\\\
Your Address \\\\
City, State ZIP \\\\
Email: your.email@example.com

\\vspace{1em}

\\noindent
\\today

\\vspace{1em}

\\noindent
Recipient Name \\\\
Recipient Address \\\\
City, State ZIP

\\vspace{1em}

\\noindent
Dear Sir or Madam,

\\vspace{0.5em}

Write the body of your letter here. Keep it professional and concise.

You can have multiple paragraphs as needed. Each paragraph should focus on a single point or idea.

Thank you for your time and consideration.

\\vspace{1em}

\\noindent
Sincerely,

\\vspace{2em}

\\noindent
Your Name

\\end{document}`,

    beamer: `\\documentclass{article}
\\usepackage[utf8]{inputenc}
\\usepackage{amsmath}

\\title{\\textbf{Your Presentation Title}}
\\author{Your Name \\\\ Your Institution}
\\date{\\today}

\\begin{document}

\\maketitle

\\section*{Outline}
\\begin{itemize}
    \\item Introduction
    \\item Main Content
    \\item Conclusion
\\end{itemize}

\\newpage

\\section{Introduction}

\\subsection*{Key Points}

\\begin{itemize}
    \\item First point
    \\item Second point
    \\item Third point
\\end{itemize}

\\newpage

\\section{Main Content}

\\subsection*{Key Concepts}

Here you can explain your main concepts.

Mathematical equation example:
\\[ E = mc^2 \\]

\\subsection*{More Details}

\\begin{enumerate}
    \\item First detail
    \\item Second detail
    \\item Third detail
\\end{enumerate}

\\newpage

\\section{Conclusion}

\\subsection*{Summary}

\\begin{itemize}
    \\item Summary point 1
    \\item Summary point 2
    \\item Thank you!
\\end{itemize}

\\end{document}`,

    exam: `\\documentclass[12pt]{article}
\\usepackage[utf8]{inputenc}
\\usepackage{amsmath}

\\title{\\textbf{Exam Title / Homework Assignment}}
\\author{Course Name}
\\date{Due Date: \\today}

\\begin{document}

\\maketitle

\\begin{center}
\\textbf{Instructions:} Answer all questions. Show all work for full credit.
\\end{center}

\\vspace{1em}

\\noindent
\\textbf{Name:} \\underline{\\hspace{10cm}}

\\vspace{0.5em}

\\noindent
\\textbf{Student ID:} \\underline{\\hspace{10cm}}

\\vspace{2em}

\\noindent
\\textbf{Question 1} (10 points) \\\\
Solve for $x$:
\\[ x^2 - 5x + 6 = 0 \\]

\\vspace{3em}

\\noindent
\\textbf{Question 2} (15 points) \\\\
Calculate the following integral:
\\[ \\int_{0}^{\\pi} \\sin(x) \\, dx \\]

\\vspace{3em}

\\noindent
\\textbf{Question 3} (20 points) \\\\
Prove that:
\\[ \\sum_{i=1}^{n} i = \\frac{n(n+1)}{2} \\]

\\vspace{3em}

\\noindent
\\textbf{Question 4} (15 points) \\\\
Multiple choice: What is the derivative of $f(x) = x^3$?

\\begin{itemize}
    \\item[(A)] $2x^2$
    \\item[(B)] $3x^2$
    \\item[(C)] $x^2$
    \\item[(D)] $3x$
\\end{itemize}

\\vspace{2em}

\\noindent
\\textbf{Total Points: 60}

\\end{document}`,

    cv: `\\documentclass[11pt]{article}
\\usepackage[utf8]{inputenc}
\\usepackage{amsmath}

\\begin{document}

\\begin{center}
{\\Large \\textbf{Your Full Name}}

\\vspace{0.5em}

your.email@example.com $\\cdot$ (123) 456-7890

LinkedIn: linkedin.com/in/yourprofile $\\cdot$ GitHub: github.com/yourusername
\\end{center}

\\vspace{1em}

\\section*{Education}

\\noindent
\\textbf{Your University Name} \\\\
Bachelor/Master of Science in Your Major \\\\
\\textit{Month Year - Month Year, City, State}

\\begin{itemize}
    \\item GPA: X.XX/4.0
    \\item Relevant Coursework: Course 1, Course 2, Course 3
\\end{itemize}

\\section*{Experience}

\\noindent
\\textbf{Job Title} \\\\
\\textit{Company Name, City, State} \\\\
\\textit{Month Year - Month Year}

\\begin{itemize}
    \\item Achieved [specific result] by implementing [action]
    \\item Improved [metric] by [percentage] through [method]
    \\item Collaborated with [team] to deliver [project]
\\end{itemize}

\\noindent
\\textbf{Previous Job Title} \\\\
\\textit{Company Name, City, State} \\\\
\\textit{Month Year - Month Year}

\\begin{itemize}
    \\item Responsibility or achievement 1
    \\item Responsibility or achievement 2
\\end{itemize}

\\section*{Projects}

\\noindent
\\textbf{Project Name} \\\\
\\textit{Technologies: Python, JavaScript, etc.} \\\\
\\textit{Month Year}

\\begin{itemize}
    \\item Brief description of project
    \\item Key achievement or learning
\\end{itemize}

\\section*{Skills}

\\noindent
\\textbf{Programming:} Python, Java, JavaScript, C++

\\noindent
\\textbf{Technologies:} React, Node.js, SQL, Git

\\noindent
\\textbf{Languages:} English (Native), Spanish (Fluent)

\\section*{Awards \\& Achievements}

\\begin{itemize}
    \\item Award Name, Year
    \\item Certification Name, Year
\\end{itemize}

\\end{document}`
};

/**
 * Initialize the editor
 */
function init() {
    // Initialize CodeMirror
    editor = CodeMirror.fromTextArea(document.getElementById('latexEditor'), {
        mode: 'stex',
        theme: 'monokai',
        lineNumbers: true,
        lineWrapping: true,
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 4,
        tabSize: 4,
        indentWithTabs: false,
        extraKeys: {
            'Ctrl-Enter': compilePreview,
            'Cmd-Enter': compilePreview,
            'Ctrl-S': saveDocument,
            'Cmd-S': saveDocument
        }
    });

    // Load auto-saved content or default
    loadAutoSaved();

    // Setup auto-save
    setupAutoSave();

    // Editor change listener
    editor.on('change', function() {
        updateStats();

        if (autoCompileEnabled) {
            clearTimeout(compileTimer);
            compileTimer = setTimeout(compilePreview, 1500);
        }
    });

    // Initial compile
    setTimeout(compilePreview, 500);

    // Load saved documents count
    updateSavedDocsCount();

    // Keyboard shortcuts info
    console.log('Keyboard Shortcuts:');
    console.log('  Ctrl/Cmd + Enter: Compile Preview');
    console.log('  Ctrl/Cmd + S: Save Document');
}

/**
 * Load template
 */
function loadTemplate() {
    const select = document.getElementById('templateSelect');
    const templateName = select.value;

    if (!templateName) return;

    if (editor.getValue().trim() && !confirm('This will replace your current document. Continue?')) {
        select.value = '';
        return;
    }

    // Load template
    editor.setValue(templates[templateName]);

    compilePreview();
    showToast('Template loaded successfully!', 'success');
    select.value = '';
}

/**
 * Compile and preview LaTeX document
 */
function compilePreview() {
    const latexCode = editor.getValue();
    const previewContent = document.getElementById('previewContent');
    const status = document.getElementById('previewStatus');

    if (!latexCode.trim()) {
        previewContent.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-file-code" style="font-size: 3rem; opacity: 0.3; margin-bottom: 1rem;"></i>
                <p>Select a template or start typing to see preview...</p>
            </div>
        `;
        return;
    }

    // Update status
    status.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Compiling...';

    try {
        // Convert LaTeX to HTML using LaTeX.js (handles math rendering internally)
        const html = convertLatexToHTML(latexCode);
        previewContent.innerHTML = html;

        status.innerHTML = '<i class="fas fa-circle" style="color: #28a745; font-size: 0.6rem;"></i> Compiled';

        setTimeout(() => {
            status.innerHTML = '<i class="fas fa-circle" style="color: #28a745; font-size: 0.6rem;"></i> Ready';
        }, 2000);

    } catch (error) {
        console.error('Compilation error:', error);
        previewContent.innerHTML = `
            <div style="color: #dc3545; padding: 2rem;">
                <h4><i class="fas fa-exclamation-triangle"></i> Compilation Error</h4>
                <p>${error.message}</p>
            </div>
        `;
        status.innerHTML = '<i class="fas fa-circle" style="color: #dc3545; font-size: 0.6rem;"></i> Error';
    }
}

/**
 * Convert LaTeX to HTML using LaTeX.js
 */
function convertLatexToHTML(latex) {
    try {
        // Use LaTeX.js to parse and generate HTML
        const generator = new latexjs.HtmlGenerator({
            hyphenate: false,
            languagePatterns: null
        });

        // Parse the LaTeX document
        const fragment = latexjs.parse(latex, { generator: generator }).htmlDocument();

        // Get the body content
        const body = fragment.querySelector('body');

        if (body) {
            // Return the body content wrapped in our container
            return `<div class="latex-js-output">${body.innerHTML}</div>`;
        } else {
            // Fallback if no body found
            return `<div class="latex-js-output">${fragment.outerHTML || fragment.textContent}</div>`;
        }
    } catch (error) {
        console.error('LaTeX.js parsing error:', error);

        // Fallback to simple display on error
        return `
            <div class="latex-error">
                <h4><i class="fas fa-exclamation-triangle"></i> LaTeX Parsing Error</h4>
                <p>${error.message || 'Failed to parse LaTeX document'}</p>
                <details>
                    <summary>View LaTeX Source</summary>
                    <pre style="background: #f5f5f5; padding: 1rem; border-radius: 4px; overflow-x: auto;">${escapeHtml(latex)}</pre>
                </details>
            </div>
        `;
    }
}

/**
 * Download as PDF
 */
function downloadPDF() {
    const element = document.getElementById('previewContent');
    const latexCode = editor.getValue();

    // Extract title for filename
    const titleMatch = latexCode.match(/\\title\{([^}]+)\}/);
    const baseFilename = titleMatch ? titleMatch[1].replace(/[^a-z0-9]/gi, '_').toLowerCase() : 'document';

    // Get current date in YYYY-MM-DD format
    const today = new Date();
    const dateStr = today.getFullYear() + '-' +
                    String(today.getMonth() + 1).padStart(2, '0') + '-' +
                    String(today.getDate()).padStart(2, '0');

    // Create filename with prefix: 8gwifi.org-LaTeX-{date}-{title}.pdf
    const filename = `8gwifi.org-LaTeX-${dateStr}-${baseFilename}.pdf`;

    showToast('Generating PDF...', 'info');

    const opt = {
        margin: 15,
        filename: filename,
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2, useCORS: true },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };

    html2pdf().set(opt).from(element).save().then(() => {
        showToast('PDF downloaded successfully!', 'success');
    }).catch(error => {
        console.error('PDF generation error:', error);
        showToast('Error generating PDF', 'error');
    });
}

/**
 * Save document to session storage
 */
function saveDocument() {
    const latexCode = editor.getValue();

    if (!latexCode.trim()) {
        showToast('Nothing to save', 'error');
        return;
    }

    // Extract title for document name
    const titleMatch = latexCode.match(/\\title\{([^}]+)\}/);
    const title = titleMatch ? titleMatch[1] : 'Untitled Document';

    const doc = {
        id: Date.now(),
        title: title,
        content: latexCode,
        timestamp: new Date().toISOString(),
        preview: latexCode.substring(0, 100)
    };

    // Get existing documents
    let documents = getSavedDocuments();

    // Check if document with same content exists
    const existingIndex = documents.findIndex(d => d.content === latexCode);
    if (existingIndex >= 0) {
        // Update existing
        documents[existingIndex] = doc;
        showToast('Document updated!', 'success');
    } else {
        // Add new
        documents.unshift(doc);
        showToast('Document saved!', 'success');
    }

    // Limit to 10 documents
    if (documents.length > 10) {
        documents = documents.slice(0, 10);
    }

    // Save to storage
    sessionStorage.setItem(STORAGE_KEY, JSON.stringify(documents));
    updateSavedDocsCount();
}

/**
 * Get saved documents
 */
function getSavedDocuments() {
    try {
        const saved = sessionStorage.getItem(STORAGE_KEY);
        return saved ? JSON.parse(saved) : [];
    } catch (e) {
        console.error('Error reading documents:', e);
        return [];
    }
}

/**
 * Toggle saved documents dropdown
 */
function toggleSavedDocs() {
    const list = document.getElementById('savedDocsList');
    const documents = getSavedDocuments();

    if (list.classList.contains('show')) {
        list.classList.remove('show');
        return;
    }

    if (documents.length === 0) {
        list.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-inbox" style="font-size: 2rem; opacity: 0.3;"></i>
                <p>No saved documents</p>
            </div>
        `;
    } else {
        list.innerHTML = documents.map(doc => {
            const date = new Date(doc.timestamp);
            return `
                <div class="saved-doc-item">
                    <div style="flex: 1; cursor: pointer;" onclick="loadDocument(${doc.id})">
                        <div class="saved-doc-title">${escapeHtml(doc.title)}</div>
                        <div class="saved-doc-meta">
                            ${date.toLocaleDateString()} ${date.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'})}
                        </div>
                    </div>
                    <button class="btn-delete-doc" onclick="event.stopPropagation(); deleteDocument(${doc.id})" title="Delete document">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            `;
        }).join('');
    }

    list.classList.add('show');
}

/**
 * Load saved document
 */
function loadDocument(id) {
    const documents = getSavedDocuments();
    const doc = documents.find(d => d.id === id);

    if (doc) {
        if (editor.getValue().trim() && !confirm('This will replace your current document. Continue?')) {
            return;
        }

        editor.setValue(doc.content);
        compilePreview();
        showToast('Document loaded!', 'success');

        // Close dropdown
        document.getElementById('savedDocsList').classList.remove('show');
    }
}

/**
 * Delete saved document
 */
function deleteDocument(id) {
    if (!confirm('Are you sure you want to delete this document?')) {
        return;
    }

    let documents = getSavedDocuments();
    documents = documents.filter(d => d.id !== id);

    sessionStorage.setItem(STORAGE_KEY, JSON.stringify(documents));
    updateSavedDocsCount();

    // Refresh the list
    const list = document.getElementById('savedDocsList');
    list.classList.remove('show');
    toggleSavedDocs();

    showToast('Document deleted', 'info');
}

/**
 * Update saved documents count
 */
function updateSavedDocsCount() {
    const count = getSavedDocuments().length;
    document.getElementById('savedCount').textContent = count;
}

/**
 * Clear editor
 */
function clearEditor() {
    if (!editor.getValue().trim() || confirm('Clear all content? This cannot be undone.')) {
        editor.setValue('');
        compilePreview();
        showToast('Editor cleared', 'info');
    }
}

/**
 * Toggle auto-compile
 */
function toggleAutoCompile() {
    autoCompileEnabled = document.getElementById('autoCompile').checked;
    showToast(autoCompileEnabled ? 'Auto-compile enabled' : 'Auto-compile disabled', 'info');
}

/**
 * Auto-save functionality
 */
function setupAutoSave() {
    autoSaveTimer = setInterval(function() {
        const content = editor.getValue();
        if (content.trim()) {
            sessionStorage.setItem(AUTO_SAVE_KEY, content);
            document.getElementById('autoSaveStatus').innerHTML =
                '<i class="fas fa-check-circle" style="color: #28a745;"></i> Auto-saved at ' +
                new Date().toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
        }
    }, 10000); // Auto-save every 10 seconds
}

/**
 * Load auto-saved content
 */
function loadAutoSaved() {
    const autoSaved = sessionStorage.getItem(AUTO_SAVE_KEY);
    if (autoSaved) {
        editor.setValue(autoSaved);
        showToast('Auto-saved content restored', 'info');
    } else {
        // Load simple article template by default (more compatible with latex.js)
        editor.setValue(templates.article);
    }
}

/**
 * Get comprehensive demonstration template
 */
function getDemoTemplate() {
    return `\\documentclass[12pt]{article}
\\usepackage[utf8]{inputenc}
\\usepackage{amsmath, amssymb}
\\usepackage{graphicx}
\\usepackage{xcolor}
\\usepackage{hyperref}
\\usepackage{geometry}
\\geometry{margin=1in}

\\title{\\textbf{Comprehensive LaTeX Features Demonstration}}
\\author{LaTeX Document Editor - 8gwifi.org}
\\date{\\today}

\\begin{document}

\\maketitle

\\begin{abstract}
This document demonstrates all major LaTeX features including text formatting, mathematical formulas, special characters, spacing, boxes, fonts, and more. Use this as a reference guide for your own documents.
\\end{abstract}

\\tableofcontents

\\section{Characters and Special Symbols}

\\subsection{Special Characters}
LaTeX reserves special characters: \\# \\$ \\% \\^{} \\& \\_ \\{ \\} \\~{} \\textbackslash

\\subsection{Quotes and Dashes}
Single quotes: \`text' produces 'text'

Double quotes: \`\`text'' produces "text"

\\textbf{Dashes:} Three types of dashes
\\begin{itemize}
    \\item Hyphen: X-ray (-)
    \\item En-dash: pages 1--10 (--)
    \\item Em-dash: Yes---or no? (---)
\\end{itemize}

\\subsection{Ligatures}
LaTeX automatically creates ligatures: fi, fl, ff, ffi, ffl

Words with ligatures: office,ffle, difficult, efficient

\\section{Text Formatting and Fonts}

\\subsection{Text Styles}
\\textbf{Bold text} using \\textbackslash textbf

\\textit{Italic text} using \\textbackslash textit

\\underline{Underlined text} using \\textbackslash underline

\\texttt{Monospace/typewriter text} using \\textbackslash texttt

\\textsf{Sans-serif text} using \\textbackslash textsf

\\textsc{Small Caps Text} using \\textbackslash textsc

\\subsection{Font Sizes}
{\\tiny Tiny text} $\\cdot$
{\\scriptsize Script size} $\\cdot$
{\\footnotesize Footnote size} $\\cdot$
{\\small Small text} $\\cdot$
{\\normalsize Normal size} $\\cdot$
{\\large Large text} $\\cdot$
{\\Large Larger text} $\\cdot$
{\\LARGE Even larger} $\\cdot$
{\\huge Huge text} $\\cdot$
{\\Huge Largest text}

\\subsection{Text Colors}
\\textcolor{red}{Red text},
\\textcolor{blue}{Blue text},
\\textcolor{green}{Green text},
\\textcolor{orange}{Orange text},
\\textcolor{purple}{Purple text}

\\section{Spacing and Alignment}

\\subsection{Horizontal Spacing}
No space\\,thin space\\:medium space\\;thick space\\quad quad\\qquad qquad

Custom spacing: A\\hspace{2cm}B (2cm space between A and B)

\\subsection{Vertical Spacing}
This is a paragraph with normal spacing.

\\vspace{1cm}

This paragraph has 1cm vertical space above it.

\\subsection{Line Breaks}
This is the first line.\\\\
This is the second line (forced line break).

This is a new paragraph (blank line in source).

\\section{Lists and Enumerations}

\\subsection{Bulleted Lists}
\\begin{itemize}
    \\item First item
    \\item Second item
    \\begin{itemize}
        \\item Nested item 1
        \\item Nested item 2
    \\end{itemize}
    \\item Third item
\\end{itemize}

\\subsection{Numbered Lists}
\\begin{enumerate}
    \\item First numbered item
    \\item Second numbered item
    \\begin{enumerate}
        \\item Nested 1
        \\item Nested 2
    \\end{enumerate}
    \\item Third numbered item
\\end{enumerate}

\\section{Mathematical Formulas}

\\subsection{Inline Mathematics}
Inline math: $E = mc^2$, $a^2 + b^2 = c^2$, $\\sum_{i=1}^{n} i = \\frac{n(n+1)}{2}$

\\subsection{Display Mathematics}
Display equation (centered):
\\[ \\int_{a}^{b} f(x)\\,dx = F(b) - F(a) \\]

Quadratic formula:
\\[ x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a} \\]

\\subsection{Multiple Equations}
Multiple steps:
\\[ f(x) = x^2 + 2x + 1 \\]
\\[ f(x) = (x+1)^2 \\]
\\[ f(x) = (x+1)(x+1) \\]

\\subsection{Math Symbols and Operators}
Greek letters: $\\alpha, \\beta, \\gamma, \\delta, \\epsilon, \\theta, \\lambda, \\pi, \\sigma, \\omega$

Uppercase Greek: $\\Gamma, \\Delta, \\Theta, \\Lambda, \\Pi, \\Sigma, \\Omega$

Operators: $\\pm, \\times, \\div, \\cdot, \\neq, \\leq, \\geq, \\approx, \\equiv$

Set notation: $\\in, \\notin, \\subset, \\subseteq, \\cup, \\cap, \\emptyset$

Logic: $\\forall, \\exists, \\neg, \\wedge, \\vee, \\Rightarrow, \\Leftrightarrow$

Calculus: $\\int, \\oint, \\sum, \\prod, \\lim, \\partial, \\nabla, \\infty$

\\subsection{Fractions and Binomials}
Fractions: $\\frac{a}{b}$, $\\frac{x^2 + y^2}{z}$, $\\frac{\\frac{a}{b}}{\\frac{c}{d}}$

Binomial coefficient: $\\binom{n}{k} = \\frac{n!}{k!(n-k)!}$

\\subsection{Roots and Powers}
Square root: $\\sqrt{x}$, $\\sqrt{x^2 + y^2}$

Nth root: $\\sqrt[3]{x}$, $\\sqrt[n]{x^n}$

Powers: $x^2, x^{n+1}, e^{i\\pi}, 2^{2^{2^2}}$

\\subsection{Matrices and Arrays}
Matrix:
\\[
\\begin{pmatrix}
a & b & c \\\\
d & e & f \\\\
g & h & i
\\end{pmatrix}
\\]

Determinant:
\\[
\\begin{vmatrix}
a & b \\\\
c & d
\\end{vmatrix} = ad - bc
\\]

\\subsection{Advanced Math Examples}
Limit:
\\[ \\lim_{x \\to \\infty} \\frac{1}{x} = 0 \\]

Summation:
\\[ \\sum_{n=1}^{\\infty} \\frac{1}{n^2} = \\frac{\\pi^2}{6} \\]

Product:
\\[ \\prod_{i=1}^{n} x_i = x_1 \\cdot x_2 \\cdot \\ldots \\cdot x_n \\]

Multiple integrals:
\\[ \\iint_D f(x,y)\\,dA = \\int_{a}^{b}\\int_{c}^{d} f(x,y)\\,dy\\,dx \\]

\\section{Boxes and Frames}

\\subsection{Basic Boxes}
\\fbox{Text in a framed box}

\\framebox[4cm]{Centered text in 4cm box}

\\subsection{Math in Boxes}
\\fbox{$E = mc^2$} is Einstein's equation.

\\boxed{x^2 + y^2 = r^2} is the circle equation.

\\section{Labels and References}

\\subsection{Section References}
\\label{sec:references}
This is Section~\\ref{sec:references}. You can reference any labeled section.

\\subsection{Equation References}
The quadratic formula:
\\[ x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a} \\]

This equation is very important in algebra.

\\section{Grouping and Scope}

\\subsection{Groups with Braces}
{\\Large This text is large} but this text is normal size.

{\\color{red} This is red} and this is back to normal color.

\\subsection{Math Groups}
$(a+b)^2 = a^2 + 2ab + b^2$

$\\left(\\frac{a}{b}\\right)^2 = \\frac{a^2}{b^2}$

Auto-sizing delimiters:
\\[ \\left(\\frac{x^2}{y^3}\\right) \\quad \\left[\\frac{x^2}{y^3}\\right] \\quad \\left\\{\\frac{x^2}{y^3}\\right\\} \\]

\\section{Comments and Verbatim}

\\subsection{Comments}
% This is a comment - it won't appear in output
This line appears, but comments don't.

\\subsection{Special Environments}

\\textbf{Quote:}
\\begin{quote}
This is a quotation environment. It's useful for highlighting quotes from other sources with proper indentation.
\\end{quote}

\\textbf{Verbatim (code):}
\\begin{verbatim}
\\documentclass{article}
\\begin{document}
    This shows LaTeX code exactly as typed.
\\end{document}
\\end{verbatim}

\\section{Tables}

\\subsection{Simple Table}
\\begin{center}
\\begin{tabular}{|l|c|r|}
\\hline
\\textbf{Left} & \\textbf{Center} & \\textbf{Right} \\\\
\\hline
Text & 123 & \\$456 \\\\
More & 789 & \\$012 \\\\
\\hline
\\end{tabular}
\\end{center}

\\section{Additional Features}

\\subsection{Footnotes}
This text has a footnote.\\footnote{This is the footnote text at the bottom of the page.}

\\subsection{Emphasis}
You can \\emph{emphasize} text or \\textbf{make it bold} for \\textit{different effects}.

\\subsection{URLs and Links}
Visit \\href{https://8gwifi.org}{8gwifi.org} for more tools.

\\url{https://www.latex-project.org}

\\section{Conclusion}

This document has demonstrated:
\\begin{itemize}
    \\item Text formatting and fonts
    \\item Special characters and symbols
    \\item Spacing and alignment
    \\item Mathematical formulas and equations
    \\item Lists and enumerations
    \\item Boxes and frames
    \\item Labels and references
    \\item Tables and structures
    \\item Comments and verbatim text
    \\item And much more!
\\end{itemize}

You can now modify this template or start with one of the other templates (Article, Report, Letter, Beamer, Exam, CV) to create your own LaTeX documents.

\\textbf{Happy LaTeXing!}

\\end{document}`;
}

/**
 * Update document statistics
 */
function updateStats() {
    const content = editor.getValue();
    const lines = content.split('\n').length;
    const words = content.trim().split(/\s+/).filter(w => w.length > 0).length;
    const chars = content.length;

    document.getElementById('lineCount').textContent = `Lines: ${lines}`;
    document.getElementById('wordCount').textContent = `Words: ${words}`;
    document.getElementById('charCount').textContent = `Characters: ${chars}`;
}

/**
 * Show toast notification
 */
function showToast(message, type = 'info') {
    const toast = document.getElementById('toast');
    toast.textContent = message;
    toast.className = `toast-notification ${type} show`;

    setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
}

/**
 * Escape HTML
 */
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

/**
 * Close dropdowns when clicking outside
 */
document.addEventListener('click', function(event) {
    const savedDropdown = document.querySelector('.saved-docs-dropdown');
    if (savedDropdown && !savedDropdown.contains(event.target)) {
        document.getElementById('savedDocsList').classList.remove('show');
    }
});

/**
 * Prevent Ctrl/Cmd+S from saving page
 */
document.addEventListener('keydown', function(e) {
    if ((e.ctrlKey || e.metaKey) && e.key === 's') {
        e.preventDefault();
        saveDocument();
    }
});

// Initialize when page loads
window.addEventListener('DOMContentLoaded', init);
