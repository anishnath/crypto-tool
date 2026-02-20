(function() {
'use strict';

var editor = null;
var errorMarkers = [];
var errorLineHandles = [];
var errorWidgets = [];

var TEMPLATES = {
  article: '\\documentclass[12pt, a4paper]{article}\n\n\\usepackage{amsmath, amssymb}\n\\usepackage{geometry}\n\\usepackage{graphicx, hyperref}\n\n\\title{My Document}\n\\author{Author Name}\n\\date{\\today}\n\n\\begin{document}\n\\maketitle\n\n\\section{Introduction}\nYour text here.\n\n\\end{document}\n',
  report: '\\documentclass[12pt]{report}\n\n\\usepackage{amsmath, amssymb}\n\\usepackage{geometry}\n\\usepackage{graphicx, hyperref}\n\n\\title{Report Title}\n\\author{Author Name}\n\\date{\\today}\n\n\\begin{document}\n\\maketitle\n\\tableofcontents\n\n\\chapter{Introduction}\nYour text here.\n\n\\chapter{Methods}\n\n\\chapter{Results}\n\n\\chapter{Conclusion}\n\n\\end{document}\n',
  beamer: '\\documentclass{beamer}\n\n\\usetheme{Madrid}\n\\usepackage{amsmath}\n\n\\title{Presentation Title}\n\\author{Author Name}\n\\date{\\today}\n\n\\begin{document}\n\n\\begin{frame}\n\\titlepage\n\\end{frame}\n\n\\begin{frame}{Outline}\n\\tableofcontents\n\\end{frame}\n\n\\section{Introduction}\n\\begin{frame}{Introduction}\n  \\begin{itemize}\n    \\item First point\n    \\item Second point\n  \\end{itemize}\n\\end{frame}\n\n\\section{Conclusion}\n\\begin{frame}{Conclusion}\n  Thank you!\n\\end{frame}\n\n\\end{document}\n',
  letter: '\\documentclass{letter}\n\n\\signature{Your Name}\n\\address{Your Address \\\\ City, State ZIP}\n\n\\begin{document}\n\n\\begin{letter}{Recipient \\\\ Address \\\\ City, State ZIP}\n\n\\opening{Dear Sir or Madam,}\n\nBody of the letter goes here.\n\n\\closing{Sincerely,}\n\n\\end{letter}\n\\end{document}\n',
  cv: '\\documentclass[11pt, a4paper]{article}\n\n\\usepackage[margin=1in]{geometry}\n\\usepackage{enumitem}\n\\usepackage{hyperref}\n\n\\pagestyle{empty}\n\n\\begin{document}\n\n\\begin{center}\n  {\\LARGE \\textbf{Your Name}} \\\\\n  \\vspace{4pt}\n  email@example.com \\quad | \\quad (123) 456-7890 \\quad | \\quad City, State\n\\end{center}\n\n\\vspace{8pt}\n\\hrule\n\\vspace{8pt}\n\n\\section*{Education}\n\\textbf{University Name} \\hfill 2020 -- 2024 \\\\\nB.S. in Computer Science \\hfill GPA: 3.8/4.0\n\n\\section*{Experience}\n\\textbf{Company Name} \\hfill Jun 2023 -- Aug 2023 \\\\\n\\textit{Software Engineer Intern}\n\\begin{itemize}[noitemsep]\n  \\item Built features for the main product\n  \\item Improved test coverage by 30\\%\n\\end{itemize}\n\n\\section*{Skills}\n\\textbf{Languages:} Python, Java, JavaScript \\\\\n\\textbf{Tools:} Git, Docker, AWS\n\n\\end{document}\n'
};

// ══════════════════════════════════════════════════════════════
// AUTOCOMPLETE DATABASE
// Each entry: { cmd, snippet, detail, category }
//   cmd      — the command typed (matched against prefix)
//   snippet  — what gets inserted; uses $1 $2 for tab-stop placeholders
//   detail   — shown in the hint popup as description
//   category — for grouping/sorting
// ══════════════════════════════════════════════════════════════

var COMPLETIONS = [

  // ── Document structure ──
  { cmd: '\\documentclass', snippet: '\\documentclass[${1:12pt}]{${2:article}}', detail: 'Document class', category: 'structure' },
  { cmd: '\\usepackage',    snippet: '\\usepackage{${1:package}}',               detail: 'Import package', category: 'structure' },
  { cmd: '\\title',         snippet: '\\title{${1:Title}}',                      detail: 'Document title', category: 'structure' },
  { cmd: '\\author',        snippet: '\\author{${1:Name}}',                      detail: 'Author name', category: 'structure' },
  { cmd: '\\date',          snippet: '\\date{${1:\\today}}',                      detail: 'Date', category: 'structure' },
  { cmd: '\\maketitle',     snippet: '\\maketitle',                              detail: 'Render title block', category: 'structure' },
  { cmd: '\\tableofcontents', snippet: '\\tableofcontents',                      detail: 'Table of contents', category: 'structure' },
  { cmd: '\\input',         snippet: '\\input{${1:filename}}',                   detail: 'Include file', category: 'structure' },
  { cmd: '\\include',       snippet: '\\include{${1:filename}}',                 detail: 'Include with clearpage', category: 'structure' },
  { cmd: '\\pagestyle',     snippet: '\\pagestyle{${1:plain}}',                  detail: 'Page style', category: 'structure' },
  { cmd: '\\newpage',       snippet: '\\newpage',                                detail: 'New page', category: 'structure' },
  { cmd: '\\clearpage',     snippet: '\\clearpage',                              detail: 'Clear page + flush floats', category: 'structure' },

  // ── Sectioning ──
  { cmd: '\\part',           snippet: '\\part{${1:Title}}',                      detail: 'Part heading', category: 'section' },
  { cmd: '\\chapter',        snippet: '\\chapter{${1:Title}}',                   detail: 'Chapter (report/book)', category: 'section' },
  { cmd: '\\section',        snippet: '\\section{${1:Title}}',                   detail: 'Section heading', category: 'section' },
  { cmd: '\\subsection',     snippet: '\\subsection{${1:Title}}',               detail: 'Subsection', category: 'section' },
  { cmd: '\\subsubsection',  snippet: '\\subsubsection{${1:Title}}',            detail: 'Subsubsection', category: 'section' },
  { cmd: '\\paragraph',      snippet: '\\paragraph{${1:Title}}',                detail: 'Named paragraph', category: 'section' },
  { cmd: '\\subparagraph',   snippet: '\\subparagraph{${1:Title}}',             detail: 'Named subparagraph', category: 'section' },

  // ── Text formatting ──
  { cmd: '\\textbf',    snippet: '\\textbf{${1:text}}',               detail: 'Bold', category: 'format' },
  { cmd: '\\textit',    snippet: '\\textit{${1:text}}',               detail: 'Italic', category: 'format' },
  { cmd: '\\texttt',    snippet: '\\texttt{${1:text}}',               detail: 'Monospace', category: 'format' },
  { cmd: '\\textsc',    snippet: '\\textsc{${1:text}}',               detail: 'Small caps', category: 'format' },
  { cmd: '\\textrm',    snippet: '\\textrm{${1:text}}',               detail: 'Roman (serif)', category: 'format' },
  { cmd: '\\textsf',    snippet: '\\textsf{${1:text}}',               detail: 'Sans-serif', category: 'format' },
  { cmd: '\\underline',  snippet: '\\underline{${1:text}}',           detail: 'Underline', category: 'format' },
  { cmd: '\\emph',       snippet: '\\emph{${1:text}}',                detail: 'Emphasis', category: 'format' },
  { cmd: '\\tiny',       snippet: '\\tiny',                           detail: 'Tiny size', category: 'format' },
  { cmd: '\\small',      snippet: '\\small',                          detail: 'Small size', category: 'format' },
  { cmd: '\\large',      snippet: '\\large',                          detail: 'Large size', category: 'format' },
  { cmd: '\\Large',      snippet: '\\Large',                          detail: 'Larger size', category: 'format' },
  { cmd: '\\LARGE',      snippet: '\\LARGE',                          detail: 'Even larger', category: 'format' },
  { cmd: '\\huge',       snippet: '\\huge',                           detail: 'Huge size', category: 'format' },
  { cmd: '\\Huge',       snippet: '\\Huge',                           detail: 'Largest size', category: 'format' },
  { cmd: '\\centering',  snippet: '\\centering',                      detail: 'Center content', category: 'format' },
  { cmd: '\\raggedright', snippet: '\\raggedright',                   detail: 'Left align', category: 'format' },
  { cmd: '\\raggedleft',  snippet: '\\raggedleft',                    detail: 'Right align', category: 'format' },

  // ── References & citations ──
  { cmd: '\\label',      snippet: '\\label{${1:key}}',                detail: 'Set label', category: 'ref' },
  { cmd: '\\ref',        snippet: '\\ref{${1:key}}',                  detail: 'Reference', category: 'ref' },
  { cmd: '\\pageref',    snippet: '\\pageref{${1:key}}',              detail: 'Page reference', category: 'ref' },
  { cmd: '\\eqref',      snippet: '\\eqref{${1:key}}',               detail: 'Equation ref (amsmath)', category: 'ref' },
  { cmd: '\\cite',       snippet: '\\cite{${1:key}}',                 detail: 'Citation', category: 'ref' },
  { cmd: '\\bibliography', snippet: '\\bibliography{${1:bibfile}}',   detail: 'Bibliography file', category: 'ref' },
  { cmd: '\\bibliographystyle', snippet: '\\bibliographystyle{${1:plain}}', detail: 'Bib style', category: 'ref' },
  { cmd: '\\footnote',    snippet: '\\footnote{${1:text}}',           detail: 'Footnote', category: 'ref' },
  { cmd: '\\url',         snippet: '\\url{${1:https://}}',            detail: 'URL link', category: 'ref' },
  { cmd: '\\href',        snippet: '\\href{${1:url}}{${2:text}}',     detail: 'Hyperlink', category: 'ref' },

  // ── Figures & tables ──
  { cmd: '\\includegraphics', snippet: '\\includegraphics[width=${1:0.8}\\textwidth]{${2:filename}}', detail: 'Include image', category: 'float' },
  { cmd: '\\caption',    snippet: '\\caption{${1:Caption text}}',     detail: 'Figure/table caption', category: 'float' },
  { cmd: '\\hline',      snippet: '\\hline',                          detail: 'Horizontal rule (table)', category: 'float' },
  { cmd: '\\cline',      snippet: '\\cline{${1:1}-${2:2}}',          detail: 'Partial horizontal rule', category: 'float' },
  { cmd: '\\multicolumn', snippet: '\\multicolumn{${1:2}}{${2:c|}}{${3:text}}', detail: 'Span columns', category: 'float' },
  { cmd: '\\multirow',   snippet: '\\multirow{${1:2}}{*}{${2:text}}', detail: 'Span rows (multirow pkg)', category: 'float' },

  // ── Math — common ──
  { cmd: '\\frac',    snippet: '\\frac{${1:num}}{${2:den}}',          detail: 'Fraction', category: 'math' },
  { cmd: '\\dfrac',   snippet: '\\dfrac{${1:num}}{${2:den}}',         detail: 'Display fraction', category: 'math' },
  { cmd: '\\tfrac',   snippet: '\\tfrac{${1:num}}{${2:den}}',         detail: 'Text-style fraction', category: 'math' },
  { cmd: '\\sqrt',    snippet: '\\sqrt{${1:x}}',                      detail: 'Square root', category: 'math' },
  { cmd: '\\sum',     snippet: '\\sum_{${1:i=1}}^{${2:n}}',           detail: 'Summation', category: 'math' },
  { cmd: '\\prod',    snippet: '\\prod_{${1:i=1}}^{${2:n}}',          detail: 'Product', category: 'math' },
  { cmd: '\\int',     snippet: '\\int_{${1:a}}^{${2:b}}',             detail: 'Integral', category: 'math' },
  { cmd: '\\iint',    snippet: '\\iint',                              detail: 'Double integral', category: 'math' },
  { cmd: '\\iiint',   snippet: '\\iiint',                             detail: 'Triple integral', category: 'math' },
  { cmd: '\\oint',    snippet: '\\oint',                              detail: 'Contour integral', category: 'math' },
  { cmd: '\\lim',     snippet: '\\lim_{${1:x \\to \\infty}}',        detail: 'Limit', category: 'math' },
  { cmd: '\\max',     snippet: '\\max',                               detail: 'Maximum', category: 'math' },
  { cmd: '\\min',     snippet: '\\min',                               detail: 'Minimum', category: 'math' },
  { cmd: '\\sup',     snippet: '\\sup',                               detail: 'Supremum', category: 'math' },
  { cmd: '\\inf',     snippet: '\\inf',                               detail: 'Infimum', category: 'math' },
  { cmd: '\\log',     snippet: '\\log',                               detail: 'Logarithm', category: 'math' },
  { cmd: '\\ln',      snippet: '\\ln',                                detail: 'Natural log', category: 'math' },
  { cmd: '\\exp',     snippet: '\\exp',                               detail: 'Exponential', category: 'math' },
  { cmd: '\\sin',     snippet: '\\sin',                               detail: 'Sine', category: 'math' },
  { cmd: '\\cos',     snippet: '\\cos',                               detail: 'Cosine', category: 'math' },
  { cmd: '\\tan',     snippet: '\\tan',                               detail: 'Tangent', category: 'math' },
  { cmd: '\\arcsin',  snippet: '\\arcsin',                            detail: 'Arcsine', category: 'math' },
  { cmd: '\\arccos',  snippet: '\\arccos',                            detail: 'Arccosine', category: 'math' },
  { cmd: '\\arctan',  snippet: '\\arctan',                            detail: 'Arctangent', category: 'math' },
  { cmd: '\\binom',   snippet: '\\binom{${1:n}}{${2:k}}',            detail: 'Binomial coefficient', category: 'math' },
  { cmd: '\\overline', snippet: '\\overline{${1:x}}',                 detail: 'Overline', category: 'math' },
  { cmd: '\\underline', snippet: '\\underline{${1:x}}',               detail: 'Underline (math)', category: 'math' },
  { cmd: '\\hat',      snippet: '\\hat{${1:x}}',                     detail: 'Hat accent', category: 'math' },
  { cmd: '\\bar',      snippet: '\\bar{${1:x}}',                     detail: 'Bar accent', category: 'math' },
  { cmd: '\\vec',      snippet: '\\vec{${1:x}}',                     detail: 'Vector arrow', category: 'math' },
  { cmd: '\\dot',      snippet: '\\dot{${1:x}}',                     detail: 'Dot accent', category: 'math' },
  { cmd: '\\ddot',     snippet: '\\ddot{${1:x}}',                    detail: 'Double dot', category: 'math' },
  { cmd: '\\tilde',    snippet: '\\tilde{${1:x}}',                   detail: 'Tilde accent', category: 'math' },
  { cmd: '\\mathbb',   snippet: '\\mathbb{${1:R}}',                  detail: 'Blackboard bold', category: 'math' },
  { cmd: '\\mathcal',  snippet: '\\mathcal{${1:L}}',                 detail: 'Calligraphic', category: 'math' },
  { cmd: '\\mathfrak', snippet: '\\mathfrak{${1:g}}',                detail: 'Fraktur', category: 'math' },
  { cmd: '\\mathrm',   snippet: '\\mathrm{${1:text}}',               detail: 'Roman in math', category: 'math' },
  { cmd: '\\text',     snippet: '\\text{${1:text}}',                 detail: 'Text in math mode', category: 'math' },

  // ── Math — delimiters ──
  { cmd: '\\left',   snippet: '\\left${1:(} ${2:} \\right${3:)}',    detail: 'Auto-sized left', category: 'math' },
  { cmd: '\\right',  snippet: '\\right${1:)}',                       detail: 'Auto-sized right', category: 'math' },
  { cmd: '\\big',    snippet: '\\big',                                detail: 'Big delimiter', category: 'math' },
  { cmd: '\\Big',    snippet: '\\Big',                                detail: 'Bigger delimiter', category: 'math' },
  { cmd: '\\bigg',   snippet: '\\bigg',                               detail: 'Even bigger', category: 'math' },
  { cmd: '\\Bigg',   snippet: '\\Bigg',                               detail: 'Biggest delimiter', category: 'math' },

  // ── Math — relations & operators ──
  { cmd: '\\leq',     snippet: '\\leq',     detail: '\u2264 less or equal', category: 'math' },
  { cmd: '\\geq',     snippet: '\\geq',     detail: '\u2265 greater or equal', category: 'math' },
  { cmd: '\\neq',     snippet: '\\neq',     detail: '\u2260 not equal', category: 'math' },
  { cmd: '\\approx',  snippet: '\\approx',  detail: '\u2248 approximately', category: 'math' },
  { cmd: '\\equiv',   snippet: '\\equiv',   detail: '\u2261 equivalent', category: 'math' },
  { cmd: '\\sim',     snippet: '\\sim',     detail: '~ similar', category: 'math' },
  { cmd: '\\propto',  snippet: '\\propto',  detail: '\u221D proportional', category: 'math' },
  { cmd: '\\pm',      snippet: '\\pm',      detail: '\u00B1 plus-minus', category: 'math' },
  { cmd: '\\mp',      snippet: '\\mp',      detail: '\u2213 minus-plus', category: 'math' },
  { cmd: '\\times',   snippet: '\\times',   detail: '\u00D7 times', category: 'math' },
  { cmd: '\\div',     snippet: '\\div',     detail: '\u00F7 division', category: 'math' },
  { cmd: '\\cdot',    snippet: '\\cdot',    detail: '\u00B7 centered dot', category: 'math' },
  { cmd: '\\circ',    snippet: '\\circ',    detail: '\u2218 composition', category: 'math' },
  { cmd: '\\otimes',  snippet: '\\otimes',  detail: '\u2297 tensor product', category: 'math' },
  { cmd: '\\oplus',   snippet: '\\oplus',   detail: '\u2295 direct sum', category: 'math' },
  { cmd: '\\cup',     snippet: '\\cup',     detail: '\u222A union', category: 'math' },
  { cmd: '\\cap',     snippet: '\\cap',     detail: '\u2229 intersection', category: 'math' },
  { cmd: '\\subset',  snippet: '\\subset',  detail: '\u2282 subset', category: 'math' },
  { cmd: '\\supset',  snippet: '\\supset',  detail: '\u2283 superset', category: 'math' },
  { cmd: '\\subseteq', snippet: '\\subseteq', detail: '\u2286 subset or equal', category: 'math' },
  { cmd: '\\supseteq', snippet: '\\supseteq', detail: '\u2287 superset or equal', category: 'math' },
  { cmd: '\\in',      snippet: '\\in',      detail: '\u2208 element of', category: 'math' },
  { cmd: '\\notin',   snippet: '\\notin',   detail: '\u2209 not element of', category: 'math' },
  { cmd: '\\forall',  snippet: '\\forall',  detail: '\u2200 for all', category: 'math' },
  { cmd: '\\exists',  snippet: '\\exists',  detail: '\u2203 exists', category: 'math' },
  { cmd: '\\neg',     snippet: '\\neg',     detail: '\u00AC negation', category: 'math' },
  { cmd: '\\land',    snippet: '\\land',    detail: '\u2227 logical and', category: 'math' },
  { cmd: '\\lor',     snippet: '\\lor',     detail: '\u2228 logical or', category: 'math' },
  { cmd: '\\Rightarrow', snippet: '\\Rightarrow', detail: '\u21D2 implies', category: 'math' },
  { cmd: '\\Leftarrow',  snippet: '\\Leftarrow',  detail: '\u21D0 implied by', category: 'math' },
  { cmd: '\\Leftrightarrow', snippet: '\\Leftrightarrow', detail: '\u21D4 iff', category: 'math' },
  { cmd: '\\rightarrow', snippet: '\\rightarrow', detail: '\u2192 right arrow', category: 'math' },
  { cmd: '\\leftarrow',  snippet: '\\leftarrow',  detail: '\u2190 left arrow', category: 'math' },
  { cmd: '\\mapsto',     snippet: '\\mapsto',     detail: '\u21A6 maps to', category: 'math' },
  { cmd: '\\to',         snippet: '\\to',         detail: '\u2192 to (arrow)', category: 'math' },

  // ── Greek letters ──
  { cmd: '\\alpha',   snippet: '\\alpha',   detail: '\u03B1', category: 'greek' },
  { cmd: '\\beta',    snippet: '\\beta',    detail: '\u03B2', category: 'greek' },
  { cmd: '\\gamma',   snippet: '\\gamma',   detail: '\u03B3', category: 'greek' },
  { cmd: '\\Gamma',   snippet: '\\Gamma',   detail: '\u0393', category: 'greek' },
  { cmd: '\\delta',   snippet: '\\delta',   detail: '\u03B4', category: 'greek' },
  { cmd: '\\Delta',   snippet: '\\Delta',   detail: '\u0394', category: 'greek' },
  { cmd: '\\epsilon', snippet: '\\epsilon', detail: '\u03B5', category: 'greek' },
  { cmd: '\\varepsilon', snippet: '\\varepsilon', detail: '\u03B5 variant', category: 'greek' },
  { cmd: '\\zeta',    snippet: '\\zeta',    detail: '\u03B6', category: 'greek' },
  { cmd: '\\eta',     snippet: '\\eta',     detail: '\u03B7', category: 'greek' },
  { cmd: '\\theta',   snippet: '\\theta',   detail: '\u03B8', category: 'greek' },
  { cmd: '\\Theta',   snippet: '\\Theta',   detail: '\u0398', category: 'greek' },
  { cmd: '\\iota',    snippet: '\\iota',    detail: '\u03B9', category: 'greek' },
  { cmd: '\\kappa',   snippet: '\\kappa',   detail: '\u03BA', category: 'greek' },
  { cmd: '\\lambda',  snippet: '\\lambda',  detail: '\u03BB', category: 'greek' },
  { cmd: '\\Lambda',  snippet: '\\Lambda',  detail: '\u039B', category: 'greek' },
  { cmd: '\\mu',      snippet: '\\mu',      detail: '\u03BC', category: 'greek' },
  { cmd: '\\nu',      snippet: '\\nu',      detail: '\u03BD', category: 'greek' },
  { cmd: '\\xi',      snippet: '\\xi',      detail: '\u03BE', category: 'greek' },
  { cmd: '\\Xi',      snippet: '\\Xi',      detail: '\u039E', category: 'greek' },
  { cmd: '\\pi',      snippet: '\\pi',      detail: '\u03C0', category: 'greek' },
  { cmd: '\\Pi',      snippet: '\\Pi',      detail: '\u03A0', category: 'greek' },
  { cmd: '\\rho',     snippet: '\\rho',     detail: '\u03C1', category: 'greek' },
  { cmd: '\\sigma',   snippet: '\\sigma',   detail: '\u03C3', category: 'greek' },
  { cmd: '\\Sigma',   snippet: '\\Sigma',   detail: '\u03A3', category: 'greek' },
  { cmd: '\\tau',     snippet: '\\tau',     detail: '\u03C4', category: 'greek' },
  { cmd: '\\upsilon', snippet: '\\upsilon', detail: '\u03C5', category: 'greek' },
  { cmd: '\\phi',     snippet: '\\phi',     detail: '\u03C6', category: 'greek' },
  { cmd: '\\varphi',  snippet: '\\varphi',  detail: '\u03C6 variant', category: 'greek' },
  { cmd: '\\Phi',     snippet: '\\Phi',     detail: '\u03A6', category: 'greek' },
  { cmd: '\\chi',     snippet: '\\chi',     detail: '\u03C7', category: 'greek' },
  { cmd: '\\psi',     snippet: '\\psi',     detail: '\u03C8', category: 'greek' },
  { cmd: '\\Psi',     snippet: '\\Psi',     detail: '\u03A8', category: 'greek' },
  { cmd: '\\omega',   snippet: '\\omega',   detail: '\u03C9', category: 'greek' },
  { cmd: '\\Omega',   snippet: '\\Omega',   detail: '\u03A9', category: 'greek' },

  // ── Math symbols ──
  { cmd: '\\infty',    snippet: '\\infty',    detail: '\u221E infinity', category: 'math' },
  { cmd: '\\partial',  snippet: '\\partial',  detail: '\u2202 partial derivative', category: 'math' },
  { cmd: '\\nabla',    snippet: '\\nabla',    detail: '\u2207 nabla/gradient', category: 'math' },
  { cmd: '\\emptyset', snippet: '\\emptyset', detail: '\u2205 empty set', category: 'math' },
  { cmd: '\\ldots',    snippet: '\\ldots',    detail: '... low dots', category: 'math' },
  { cmd: '\\cdots',    snippet: '\\cdots',    detail: '\u22EF center dots', category: 'math' },
  { cmd: '\\vdots',    snippet: '\\vdots',    detail: '\u22EE vertical dots', category: 'math' },
  { cmd: '\\ddots',    snippet: '\\ddots',    detail: '\u22F1 diagonal dots', category: 'math' },
  { cmd: '\\quad',     snippet: '\\quad',     detail: 'Quad space', category: 'math' },
  { cmd: '\\qquad',    snippet: '\\qquad',    detail: 'Double quad space', category: 'math' },

  // ── Spacing ──
  { cmd: '\\vspace',   snippet: '\\vspace{${1:1em}}',    detail: 'Vertical space', category: 'spacing' },
  { cmd: '\\hspace',   snippet: '\\hspace{${1:1em}}',    detail: 'Horizontal space', category: 'spacing' },
  { cmd: '\\vfill',    snippet: '\\vfill',               detail: 'Vertical fill', category: 'spacing' },
  { cmd: '\\hfill',    snippet: '\\hfill',               detail: 'Horizontal fill', category: 'spacing' },
  { cmd: '\\noindent', snippet: '\\noindent',            detail: 'No indentation', category: 'spacing' },

  // ── Lists ──
  { cmd: '\\item',     snippet: '\\item ${1:}',          detail: 'List item', category: 'list' },

  // ── Commands & definitions ──
  { cmd: '\\newcommand',     snippet: '\\newcommand{\\${1:cmd}}[${2:0}]{${3:def}}', detail: 'Define new command', category: 'def' },
  { cmd: '\\renewcommand',   snippet: '\\renewcommand{\\${1:cmd}}{${2:def}}',       detail: 'Redefine command', category: 'def' },
  { cmd: '\\newenvironment', snippet: '\\newenvironment{${1:name}}{${2:begin}}{${3:end}}', detail: 'New environment', category: 'def' },
  { cmd: '\\thanks',         snippet: '\\thanks{${1:text}}',                        detail: 'Acknowledgement', category: 'def' },
  { cmd: '\\marginpar',      snippet: '\\marginpar{${1:text}}',                     detail: 'Margin note', category: 'def' }
];

// ── Environment names for \begin{} completion ──
var ENVIRONMENTS = [
  { name: 'document',     detail: 'Document body' },
  { name: 'figure',       detail: 'Float figure', snippet: '\\begin{figure}[${1:htbp}]\n\\centering\n${2:}\n\\caption{${3:Caption}}\n\\label{fig:${4:label}}\n\\end{figure}' },
  { name: 'table',        detail: 'Float table', snippet: '\\begin{table}[${1:htbp}]\n\\centering\n\\begin{tabular}{${2:c|c|c}}\n\\hline\n${3:A & B & C} \\\\\\\\\n\\hline\n\\end{tabular}\n\\caption{${4:Caption}}\n\\label{tab:${5:label}}\n\\end{table}' },
  { name: 'equation',     detail: 'Numbered equation' },
  { name: 'equation*',    detail: 'Unnumbered equation' },
  { name: 'align',        detail: 'Aligned equations (amsmath)' },
  { name: 'align*',       detail: 'Unnumbered aligned' },
  { name: 'gather',       detail: 'Centered equations' },
  { name: 'gather*',      detail: 'Unnumbered gathered' },
  { name: 'multline',     detail: 'Multi-line equation' },
  { name: 'cases',        detail: 'Piecewise cases' },
  { name: 'matrix',       detail: 'Matrix (no delims)' },
  { name: 'pmatrix',      detail: 'Parenthesized matrix' },
  { name: 'bmatrix',      detail: 'Bracketed matrix' },
  { name: 'vmatrix',      detail: 'Determinant matrix' },
  { name: 'itemize',      detail: 'Bullet list', snippet: '\\begin{itemize}\n\\item ${1:}\n\\end{itemize}' },
  { name: 'enumerate',    detail: 'Numbered list', snippet: '\\begin{enumerate}\n\\item ${1:}\n\\end{enumerate}' },
  { name: 'description',  detail: 'Description list', snippet: '\\begin{description}\n\\item[${1:Term}] ${2:Description}\n\\end{description}' },
  { name: 'tabular',      detail: 'Table body', snippet: '\\begin{tabular}{${1:c|c|c}}\n\\hline\n${2:} \\\\\\\\\n\\hline\n\\end{tabular}' },
  { name: 'verbatim',     detail: 'Literal text' },
  { name: 'quote',        detail: 'Block quote' },
  { name: 'center',       detail: 'Centered block' },
  { name: 'flushleft',    detail: 'Left-aligned block' },
  { name: 'flushright',   detail: 'Right-aligned block' },
  { name: 'abstract',     detail: 'Abstract block' },
  { name: 'minipage',     detail: 'Mini page', snippet: '\\begin{minipage}{${1:0.45\\textwidth}}\n${2:}\n\\end{minipage}' },
  { name: 'frame',        detail: 'Beamer slide', snippet: '\\begin{frame}{${1:Title}}\n${2:}\n\\end{frame}' },
  { name: 'block',        detail: 'Beamer block', snippet: '\\begin{block}{${1:Title}}\n${2:}\n\\end{block}' },
  { name: 'tikzpicture',  detail: 'TikZ drawing' },
  { name: 'lstlisting',   detail: 'Code listing (listings)' },
  { name: 'minted',       detail: 'Code listing (minted)' },
  { name: 'proof',        detail: 'Proof (amsthm)' },
  { name: 'theorem',      detail: 'Theorem' },
  { name: 'lemma',        detail: 'Lemma' },
  { name: 'definition',   detail: 'Definition' },
  { name: 'corollary',    detail: 'Corollary' },
  { name: 'example',      detail: 'Example' }
];

// ── Package names for \usepackage{} completion ──
var PACKAGES = [
  { name: 'amsmath',    detail: 'AMS math environments' },
  { name: 'amssymb',    detail: 'AMS math symbols' },
  { name: 'amsthm',     detail: 'Theorem environments' },
  { name: 'geometry',   detail: 'Page layout', snippet: '\\usepackage[margin=${1:1in}]{geometry}' },
  { name: 'graphicx',   detail: 'Graphics inclusion' },
  { name: 'hyperref',   detail: 'Hyperlinks & PDF metadata' },
  { name: 'xcolor',     detail: 'Colors', snippet: '\\usepackage[${1:dvipsnames}]{xcolor}' },
  { name: 'listings',   detail: 'Code listings' },
  { name: 'minted',     detail: 'Syntax-highlighted code' },
  { name: 'tikz',       detail: 'TikZ drawings' },
  { name: 'pgfplots',   detail: 'Data plots' },
  { name: 'booktabs',   detail: 'Better table rules' },
  { name: 'multirow',   detail: 'Multi-row table cells' },
  { name: 'array',      detail: 'Extended tabular' },
  { name: 'enumitem',   detail: 'Custom lists' },
  { name: 'fancyhdr',   detail: 'Custom headers/footers' },
  { name: 'float',      detail: 'Float placement [H]' },
  { name: 'subcaption', detail: 'Sub-figures' },
  { name: 'caption',    detail: 'Custom captions' },
  { name: 'setspace',   detail: 'Line spacing' },
  { name: 'parskip',    detail: 'Paragraph spacing' },
  { name: 'natbib',     detail: 'Natural bibliography' },
  { name: 'biblatex',   detail: 'Modern bibliography' },
  { name: 'algorithm2e', detail: 'Pseudocode algorithms' },
  { name: 'inputenc',   detail: 'Input encoding' },
  { name: 'fontenc',    detail: 'Font encoding' },
  { name: 'babel',      detail: 'Multilingual support' },
  { name: 'csquotes',   detail: 'Context-sensitive quotes' },
  { name: 'siunitx',    detail: 'SI units' },
  { name: 'mathtools',  detail: 'Extended amsmath' },
  { name: 'physics',    detail: 'Physics notation' },
  { name: 'cancel',     detail: 'Cancel in math' },
  { name: 'tcolorbox',  detail: 'Colored boxes' }
];

// ══════════════════════════════════════════════════════════════
// HINT ENGINE
// ══════════════════════════════════════════════════════════════

function initEditor() {
  var container = document.getElementById('codemirror-container');
  if (!container) return;

  editor = CodeMirror(container, {
    value: TEMPLATES.article,
    mode: 'stex',
    theme: 'material-darker',
    lineNumbers: true,
    matchBrackets: true,
    autoCloseBrackets: true,
    styleActiveLine: true,
    lineWrapping: true,
    tabSize: 2,
    indentWithTabs: false,
    gutters: ['CodeMirror-linenumbers', 'error-gutter'],
    extraKeys: {
      'Ctrl-Space': function(cm) { showHints(cm); },
      'Cmd-Enter': function() { triggerCompile(); },
      'Ctrl-Enter': function() { triggerCompile(); },
      'Ctrl-S': function() { triggerCompile(); },
      'Cmd-S': function() { triggerCompile(); },
      'F8': function() { if (typeof nextError === 'function') nextError(); },
      'Shift-F8': function() { if (typeof prevError === 'function') prevError(); },
      'Tab': function(cm) { return handleTab(cm); }
    }
  });

  window.editorInstance = editor;

  editor.on('change', function(cm, change) {
    if (typeof onEditorChange === 'function') {
      onEditorChange();
    }
    // Auto-close \begin{env} with \end{env}
    if (change.origin === '+input') {
      autoCloseEnvironment(cm, change);
    }
  });

  editor.on('cursorActivity', function() {
    var pos = editor.getCursor();
    var sbCursor = document.getElementById('sb-cursor');
    if (sbCursor) {
      sbCursor.textContent = 'Ln ' + (pos.line + 1) + ', Col ' + (pos.ch + 1);
    }
    updateOutline();
  });

  editor.on('inputRead', function(cm, change) {
    if (change.text[0] === '\\') {
      showHints(cm);
    }
  });

  if (window.LatexSymbols) {
    window.LatexSymbols.init();
  }

  // Sync CodeMirror theme with site theme
  syncEditorTheme();
  observeThemeChanges();
}

// ── Auto-close \begin{envName} → insert \end{envName} ──
function autoCloseEnvironment(cm, change) {
  if (change.text.length !== 1) return;
  var insertedChar = change.text[0];

  // Trigger on closing brace after \begin{...}
  if (insertedChar !== '}') return;

  var cursor = cm.getCursor();
  var lineText = cm.getLine(cursor.line);
  var beforeCursor = lineText.substring(0, cursor.ch);

  var match = beforeCursor.match(/\\begin\{([^}]+)\}$/);
  if (!match) return;

  var envName = match[1];

  // Check if \end{envName} already follows
  var afterCursor = lineText.substring(cursor.ch);
  var rest = afterCursor + '\n' + cm.getRange(
    { line: cursor.line + 1, ch: 0 },
    { line: Math.min(cursor.line + 5, cm.lineCount()), ch: 0 }
  );
  if (rest.indexOf('\\end{' + envName + '}') !== -1) return;

  // Check if environment has a custom snippet
  var envDef = null;
  for (var i = 0; i < ENVIRONMENTS.length; i++) {
    if (ENVIRONMENTS[i].name === envName && ENVIRONMENTS[i].snippet) {
      envDef = ENVIRONMENTS[i];
      break;
    }
  }

  // Insert \end{envName}
  var indent = lineText.match(/^(\s*)/)[1];
  var endTag = '\n' + indent + '\n' + indent + '\\end{' + envName + '}';

  cm.replaceRange(endTag, cursor);
  // Place cursor on blank line between begin and end
  cm.setCursor({ line: cursor.line + 1, ch: indent.length });
}

// ── Show hints ──
function showHints(cm) {
  cm.showHint({
    hint: latexHint,
    completeSingle: false,
    alignWithWord: true
  });
}

// ── Main hint function ──
function latexHint(cm) {
  var cursor = cm.getCursor();
  var line = cm.getLine(cursor.line);
  var end = cursor.ch;
  var start = end;

  // Walk back to find the start of the current token
  while (start > 0 && line[start - 1] !== ' ' && line[start - 1] !== '{' && line[start - 1] !== '\n' && line[start - 1] !== '}') {
    start--;
  }

  var word = line.slice(start, end);

  // ── Context: inside \begin{...} → complete environment names ──
  var beginMatch = line.substring(0, end).match(/\\begin\{([^}]*)$/);
  if (beginMatch) {
    var envPrefix = beginMatch[1].toLowerCase();
    var envStart = end - beginMatch[1].length;
    var envMatches = [];

    for (var i = 0; i < ENVIRONMENTS.length; i++) {
      if (ENVIRONMENTS[i].name.toLowerCase().indexOf(envPrefix) === 0) {
        envMatches.push(createEnvHint(ENVIRONMENTS[i], envStart, end, cursor.line, cm));
      }
    }
    if (envMatches.length === 0) return null;
    return { list: envMatches, from: CodeMirror.Pos(cursor.line, envStart), to: CodeMirror.Pos(cursor.line, end) };
  }

  // ── Context: inside \usepackage{...} → complete package names ──
  var pkgMatch = line.substring(0, end).match(/\\usepackage(?:\[.*?\])?\{([^}]*)$/);
  if (pkgMatch) {
    var pkgPrefix = pkgMatch[1].toLowerCase();
    // Handle comma-separated packages
    var lastComma = pkgPrefix.lastIndexOf(',');
    if (lastComma !== -1) {
      pkgPrefix = pkgPrefix.substring(lastComma + 1).trim();
    }
    var pkgStart = end - pkgPrefix.length;
    var pkgMatches = [];

    for (var p = 0; p < PACKAGES.length; p++) {
      if (PACKAGES[p].name.toLowerCase().indexOf(pkgPrefix) === 0) {
        pkgMatches.push({
          text: PACKAGES[p].name,
          displayText: PACKAGES[p].name + '  \u2014 ' + PACKAGES[p].detail,
          className: 'hint-package'
        });
      }
    }
    if (pkgMatches.length === 0) return null;
    return { list: pkgMatches, from: CodeMirror.Pos(cursor.line, pkgStart), to: CodeMirror.Pos(cursor.line, end) };
  }

  // ── Context: \end{...} → complete with matching \begin ──
  var endMatch = line.substring(0, end).match(/\\end\{([^}]*)$/);
  if (endMatch) {
    var endPrefix = endMatch[1];
    var endStart = end - endPrefix.length;
    var openEnv = findOpenEnvironment(cm, cursor.line);
    var endMatches = [];

    if (openEnv && openEnv.indexOf(endPrefix) === 0) {
      endMatches.push({
        text: openEnv,
        displayText: openEnv + '  \u2014 close environment',
        className: 'hint-env'
      });
    }
    // Also offer matching from ENVIRONMENTS list
    for (var e = 0; e < ENVIRONMENTS.length; e++) {
      if (ENVIRONMENTS[e].name.indexOf(endPrefix) === 0 && ENVIRONMENTS[e].name !== openEnv) {
        endMatches.push({
          text: ENVIRONMENTS[e].name,
          displayText: ENVIRONMENTS[e].name + '  \u2014 ' + ENVIRONMENTS[e].detail,
          className: 'hint-env'
        });
      }
    }
    if (endMatches.length === 0) return null;
    return { list: endMatches, from: CodeMirror.Pos(cursor.line, endStart), to: CodeMirror.Pos(cursor.line, end) };
  }

  // ── Context: \ command prefix → complete commands ──
  if (!word.startsWith('\\')) return null;

  var matches = [];
  var wordLower = word.toLowerCase();

  for (var c = 0; c < COMPLETIONS.length; c++) {
    if (COMPLETIONS[c].cmd.toLowerCase().indexOf(wordLower) === 0) {
      matches.push(createSnippetHint(COMPLETIONS[c], start, end, cursor.line, cm));
    }
  }

  if (matches.length === 0) return null;

  return {
    list: matches,
    from: CodeMirror.Pos(cursor.line, start),
    to: CodeMirror.Pos(cursor.line, end)
  };
}

// ── Find innermost open \begin{} without matching \end{} ──
function findOpenEnvironment(cm, upToLine) {
  var stack = [];
  for (var i = 0; i <= upToLine; i++) {
    var text = cm.getLine(i);
    var beginRe = /\\begin\{([^}]+)\}/g;
    var endRe = /\\end\{([^}]+)\}/g;
    var m;
    while ((m = beginRe.exec(text)) !== null) {
      stack.push(m[1]);
    }
    while ((m = endRe.exec(text)) !== null) {
      // Pop matching from stack
      for (var j = stack.length - 1; j >= 0; j--) {
        if (stack[j] === m[1]) {
          stack.splice(j, 1);
          break;
        }
      }
    }
  }
  return stack.length > 0 ? stack[stack.length - 1] : null;
}

// ── Create a hint item for a command with snippet support ──
function createSnippetHint(comp, start, end, lineNum, cm) {
  var categoryIcons = {
    structure: '\u25A0', section: '\u00A7', format: 'A',
    ref: '\u2197', float: '\u25A3', math: '\u2211',
    greek: '\u03B1', spacing: '\u2194', list: '\u2022', def: '\u2318'
  };
  var icon = categoryIcons[comp.category] || '\u25B6';

  return {
    text: comp.cmd,
    displayText: icon + ' ' + comp.cmd + '  \u2014 ' + comp.detail,
    className: 'hint-' + comp.category,
    hint: function(cm, data, completion) {
      var from = data.from;
      var to = data.to;
      insertSnippet(cm, comp.snippet, from, to);
    }
  };
}

// ── Create a hint item for an environment ──
function createEnvHint(env, start, end, lineNum, cm) {
  return {
    text: env.name,
    displayText: '\u25CB ' + env.name + '  \u2014 ' + env.detail,
    className: 'hint-env',
    hint: function(cm, data, completion) {
      // Just insert the environment name; auto-close handles \end{}
      cm.replaceRange(env.name, CodeMirror.Pos(lineNum, start), CodeMirror.Pos(lineNum, end));
    }
  };
}

// ══════════════════════════════════════════════════════════════
// SNIPPET ENGINE — handles ${1:placeholder} tab stops
// ══════════════════════════════════════════════════════════════

var activeSnippet = null; // { marks: [{from, to, index}], currentIndex }

function insertSnippet(cm, snippetText, from, to) {
  // Parse ${N:placeholder} patterns
  var tabStops = [];
  var plain = '';
  var re = /\$\{(\d+):([^}]*)\}/g;
  var lastIndex = 0;
  var match;

  while ((match = re.exec(snippetText)) !== null) {
    plain += snippetText.slice(lastIndex, match.index);
    var stopStart = plain.length;
    plain += match[2]; // placeholder text
    var stopEnd = plain.length;
    tabStops.push({ index: parseInt(match[1], 10), start: stopStart, end: stopEnd, placeholder: match[2] });
    lastIndex = match.index + match[0].length;
  }
  plain += snippetText.slice(lastIndex);

  // Replace the range
  cm.replaceRange(plain, from, to);

  if (tabStops.length === 0) return;

  // Sort by index
  tabStops.sort(function(a, b) { return a.index - b.index; });

  // Calculate absolute positions and create markers
  var startOffset = cm.indexFromPos(from);
  var marks = [];

  for (var i = 0; i < tabStops.length; i++) {
    var absStart = startOffset + tabStops[i].start;
    var absEnd = startOffset + tabStops[i].end;
    var posFrom = cm.posFromIndex(absStart);
    var posTo = cm.posFromIndex(absEnd);

    var marker = cm.markText(posFrom, posTo, {
      className: 'cm-snippet-field' + (i === 0 ? ' cm-snippet-active' : ''),
      clearOnEnter: false,
      inclusiveLeft: true,
      inclusiveRight: true
    });

    marks.push({ marker: marker, index: tabStops[i].index });
  }

  // Select first tab stop
  activeSnippet = { marks: marks, currentStop: 0 };
  selectSnippetStop(cm, 0);
}

function selectSnippetStop(cm, stopIndex) {
  if (!activeSnippet || stopIndex >= activeSnippet.marks.length) {
    clearSnippet(cm);
    return;
  }

  // Update active styling
  for (var i = 0; i < activeSnippet.marks.length; i++) {
    var range = activeSnippet.marks[i].marker.find();
    if (!range) continue;
    activeSnippet.marks[i].marker.clear();
    activeSnippet.marks[i].marker = cm.markText(range.from, range.to, {
      className: 'cm-snippet-field' + (i === stopIndex ? ' cm-snippet-active' : ''),
      clearOnEnter: false,
      inclusiveLeft: true,
      inclusiveRight: true
    });
  }

  var mark = activeSnippet.marks[stopIndex].marker;
  var range = mark.find();
  if (range) {
    cm.setSelection(range.from, range.to);
    cm.focus();
  }

  activeSnippet.currentStop = stopIndex;
}

function handleTab(cm) {
  if (activeSnippet) {
    var nextStop = activeSnippet.currentStop + 1;
    if (nextStop < activeSnippet.marks.length) {
      selectSnippetStop(cm, nextStop);
      return; // prevent default tab
    }
    clearSnippet(cm);
    return;
  }
  // Default: insert spaces
  cm.replaceSelection('  ');
}

function clearSnippet(cm) {
  if (!activeSnippet) return;
  for (var i = 0; i < activeSnippet.marks.length; i++) {
    activeSnippet.marks[i].marker.clear();
  }
  activeSnippet = null;
}

// Clear snippet on Escape
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape' && activeSnippet) {
    clearSnippet(editor);
  }
});

// ══════════════════════════════════════════════════════════════
// REST OF EDITOR FUNCTIONS (unchanged)
// ══════════════════════════════════════════════════════════════

function getEditorContent() {
  if (!editor) return '';
  return editor.getValue();
}

function setEditorContent(source) {
  if (!editor) return;
  editor.setValue(source);
}

function markErrorLine(lineNum, message) {
  if (!editor) return;
  var line = lineNum - 1;
  if (line < 0 || line >= editor.lineCount()) return;

  var marker = document.createElement('div');
  marker.className = 'error-gutter-marker';
  marker.innerHTML = '&#9679;';
  marker.title = message || 'Error';
  marker.onclick = function() { jumpToEditorLine(lineNum); };
  editor.setGutterMarker(line, 'error-gutter', marker);
  errorMarkers.push(line);

  var handle = editor.addLineClass(line, 'background', 'error-line-highlight');
  errorLineHandles.push(handle);
}

function addErrorWidget(lineNum, message) {
  if (!editor) return;
  var line = lineNum - 1;
  if (line < 0 || line >= editor.lineCount()) return;

  var widgetEl = document.createElement('div');
  widgetEl.className = 'cm-error-widget';

  var icon = document.createElement('span');
  icon.className = 'cm-error-widget-icon';
  icon.textContent = '\u2715';

  var text = document.createElement('span');
  text.className = 'cm-error-widget-text';
  text.textContent = message;

  var dismiss = document.createElement('span');
  dismiss.className = 'cm-error-widget-dismiss';
  dismiss.textContent = '\u00D7';
  dismiss.title = 'Dismiss';

  widgetEl.appendChild(icon);
  widgetEl.appendChild(text);
  widgetEl.appendChild(dismiss);

  var widget = editor.addLineWidget(line, widgetEl, {
    coverGutter: false, noHScroll: true, above: false
  });

  dismiss.onclick = function() { widget.clear(); };
  errorWidgets.push(widget);
}

function clearErrorMarkers() {
  if (!editor) return;
  for (var i = 0; i < errorMarkers.length; i++) {
    editor.setGutterMarker(errorMarkers[i], 'error-gutter', null);
  }
  for (var j = 0; j < errorLineHandles.length; j++) {
    editor.removeLineClass(errorLineHandles[j], 'background', 'error-line-highlight');
  }
  errorMarkers = [];
  errorLineHandles = [];
}

function clearErrorWidgets() {
  for (var i = 0; i < errorWidgets.length; i++) {
    errorWidgets[i].clear();
  }
  errorWidgets = [];
}

function jumpToEditorLine(lineNum) {
  if (!editor) return;
  var line = lineNum - 1;
  if (line < 0 || line >= editor.lineCount()) return;

  editor.setCursor(line, 0);
  editor.scrollIntoView({ line: line, ch: 0 }, 100);
  editor.focus();

  var handle = editor.addLineClass(line, 'background', 'error-line-pulse');
  setTimeout(function() {
    editor.removeLineClass(handle, 'background', 'error-line-pulse');
  }, 1500);
}

function loadTemplate(name) {
  var tmpl = TEMPLATES[name];
  if (tmpl) setEditorContent(tmpl);
}

function insertCommand(cmd) {
  if (!editor) return;
  var doc = editor.getDoc();
  var cursor = doc.getCursor();
  var selection = doc.getSelection();

  if (selection && cmd.indexOf('{}') !== -1) {
    doc.replaceSelection(cmd.replace('{}', '{' + selection + '}'));
  } else {
    doc.replaceRange(cmd, cursor);
    var bracePos = cmd.indexOf('{}');
    if (bracePos !== -1) {
      doc.setCursor({ line: cursor.line, ch: cursor.ch + bracePos + 1 });
    }
  }
  editor.focus();
}

function insertTableTemplate() {
  var tmpl = '\\begin{table}[h]\n\\centering\n\\begin{tabular}{|c|c|c|}\n\\hline\nA & B & C \\\\\\\\\n\\hline\n1 & 2 & 3 \\\\\\\\\n\\hline\n\\end{tabular}\n\\caption{Table caption}\n\\label{tab:mytable}\n\\end{table}\n';
  insertCommand(tmpl);
}

function insertFigureTemplate() {
  var tmpl = '\\begin{figure}[h]\n\\centering\n\\includegraphics[width=0.8\\textwidth]{filename}\n\\caption{Figure caption}\n\\label{fig:myfigure}\n\\end{figure}\n';
  insertCommand(tmpl);
}

function downloadTex() {
  var content = getEditorContent();
  var blob = new Blob([content], { type: 'text/plain' });
  var a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = 'document.tex';
  a.click();
  URL.revokeObjectURL(a.href);
}

function toggleSymbolPicker() {
  var picker = document.getElementById('symbol-picker');
  if (picker) picker.classList.toggle('visible');
}

function updateOutline() {
  var content = getEditorContent();
  var lines = content.split('\n');
  var outline = document.getElementById('outline-list');
  if (!outline) return;

  var items = [];
  var sectionPattern = /\\(section|subsection|subsubsection|chapter)\{([^}]+)\}/;

  for (var i = 0; i < lines.length; i++) {
    var match = lines[i].match(sectionPattern);
    if (match) {
      var level = match[1];
      var title = match[2];
      var cls = 'outline-item';
      if (level === 'section' || level === 'chapter') cls += ' h1';
      else if (level === 'subsection') cls += ' h2';
      else cls += ' h3';
      items.push({ cls: cls, title: title, line: i });
    }
  }

  outline.innerHTML = '';
  for (var j = 0; j < items.length; j++) {
    var div = document.createElement('div');
    div.className = items[j].cls;
    div.textContent = items[j].title;
    div.onclick = (function(line) {
      return function() {
        if (editor) {
          editor.setCursor(line, 0);
          editor.scrollIntoView({ line: line, ch: 0 }, 100);
          editor.focus();
        }
      };
    })(items[j].line);
    outline.appendChild(div);
  }
}

document.addEventListener('click', function(e) {
  var picker = document.getElementById('symbol-picker');
  if (picker && picker.classList.contains('visible')) {
    if (!picker.contains(e.target) && e.target.id !== 'btn-symbols') {
      picker.classList.remove('visible');
    }
  }
});

// ══════════════════════════════════════════════════════════════
// THEME SYNC — switch CodeMirror theme when site theme changes
// ══════════════════════════════════════════════════════════════

function syncEditorTheme() {
  if (!editor) return;
  var theme = document.documentElement.getAttribute('data-theme');
  editor.setOption('theme', theme === 'light' ? 'default' : 'material-darker');
}

function observeThemeChanges() {
  var observer = new MutationObserver(function(mutations) {
    for (var i = 0; i < mutations.length; i++) {
      if (mutations[i].attributeName === 'data-theme') {
        syncEditorTheme();
        break;
      }
    }
  });
  observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
}

// Expose globally
window.getEditorContent = getEditorContent;
window.setEditorContent = setEditorContent;
window.markErrorLine = markErrorLine;
window.addErrorWidget = addErrorWidget;
window.clearErrorMarkers = clearErrorMarkers;
window.clearErrorWidgets = clearErrorWidgets;
window.jumpToEditorLine = jumpToEditorLine;
window.loadTemplate = loadTemplate;
window.insertCommand = insertCommand;
window.insertTableTemplate = insertTableTemplate;
window.insertFigureTemplate = insertFigureTemplate;
window.downloadTex = downloadTex;
window.toggleSymbolPicker = toggleSymbolPicker;
window.filterSymbols = window.LatexSymbols ? window.LatexSymbols.filter : function() {};

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initEditor);
} else {
  initEditor();
}

})();
