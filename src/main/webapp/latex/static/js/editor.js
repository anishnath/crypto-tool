(function() {
'use strict';

var editor = null;
var errorMarkers = [];
var errorLineHandles = [];
var errorWidgets = [];

var TEMPLATES = {
  article: [
    '% =============================================================================',
    '%  Polished technical article with title + authors + affiliations, abstract,',
    '%  keywords, sections, equations, tables, figures, theorem environments,',
    '%  cross-references, and inline bibliography.',
    '%',
    '%  TIP: hit Compile TWICE to resolve cross-references (\\ref, \\cite).',
    '% =============================================================================',
    '',
    '\\documentclass[11pt, a4paper]{article}',
    '',
    '\\usepackage[utf8]{inputenc}',
    '\\usepackage[T1]{fontenc}',
    '\\usepackage[margin=1in]{geometry}',
    '\\usepackage{microtype}',
    '\\usepackage{amsmath, amssymb, amsthm}',
    '\\usepackage{graphicx}',
    '\\usepackage{booktabs}',
    '\\usepackage{siunitx}',
    '\\usepackage{enumitem}',
    '\\usepackage{authblk}',
    '\\usepackage{tikz}',
    '\\usepackage[colorlinks=true, linkcolor=blue!60!black, citecolor=teal,',
    '            urlcolor=blue!60!black]{hyperref}',
    '\\usepackage[capitalize, noabbrev]{cleveref}',
    '',
    '% ── Theorem environments ────────────────────────────────────────────────',
    '\\theoremstyle{plain}',
    '\\newtheorem{theorem}{Theorem}[section]',
    '\\newtheorem{lemma}[theorem]{Lemma}',
    '\\theoremstyle{definition}',
    '\\newtheorem{definition}{Definition}[section]',
    '',
    '% ── Title block ─────────────────────────────────────────────────────────',
    '\\title{\\textbf{Your Article Title:\\\\[2pt] A Descriptive Subtitle}}',
    '\\author[1]{First Author\\thanks{Corresponding author. Email: \\texttt{first.author@example.com}}}',
    '\\author[2]{Second Author}',
    '\\affil[1]{Department of X, University of Y}',
    '\\affil[2]{Research Lab Z}',
    '\\date{\\today}',
    '',
    '\\begin{document}',
    '\\maketitle',
    '',
    '% ── Abstract ────────────────────────────────────────────────────────────',
    '\\begin{abstract}',
    'A concise summary of the article in 100--200 words. State the',
    '\\textbf{problem} you investigated, the \\textbf{approach} you used,',
    'the \\textbf{main results}, and the \\textbf{implications}. A reader who',
    'reads only this paragraph should walk away knowing what you did and why',
    'it matters.',
    '\\end{abstract}',
    '',
    '\\noindent\\textbf{Keywords:} keyword one, keyword two, keyword three.',
    '',
    '% ── 1. Introduction ─────────────────────────────────────────────────────',
    '\\section{Introduction}',
    '\\label{sec:intro}',
    '',
    'Open with broad context. Why is this topic interesting? Position the work',
    'against established literature~\\cite{turing1950, shannon1948}.',
    '',
    '\\paragraph{Contributions.}',
    'This article makes the following contributions:',
    '\\begin{enumerate}[noitemsep, label=(\\arabic*)]',
    '  \\item A formal framework for \\dots',
    '  \\item An empirical evaluation showing \\dots',
    '  \\item An open-source implementation released at \\url{https://example.com}.',
    '\\end{enumerate}',
    '',
    '\\paragraph{Organisation.}',
    '\\Cref{sec:related} reviews related work. \\Cref{sec:method} describes the',
    'approach. \\Cref{sec:results} presents the experiments and',
    '\\cref{sec:conclusion} concludes.',
    '',
    '% ── 2. Related Work ─────────────────────────────────────────────────────',
    '\\section{Related Work}',
    '\\label{sec:related}',
    '',
    'Group related work by theme rather than chronology. Reference seminal',
    'works~\\cite{lamport1978} and recent developments to show the conversation',
    'this article enters.',
    '',
    '% ── 3. Method ───────────────────────────────────────────────────────────',
    '\\section{Method}',
    '\\label{sec:method}',
    '',
    '\\subsection{Overview}',
    'High-level description of the approach in one paragraph. Ideally',
    'accompanied by a system diagram (see \\cref{fig:example}).',
    '',
    '\\subsection{Formulation}',
    'We seek parameters $\\theta$ that minimise the regularised loss',
    '\\begin{equation}',
    '  \\mathcal{L}(\\theta) = \\frac{1}{N} \\sum_{i=1}^{N}',
    '  \\bigl( y_i - f_\\theta(x_i) \\bigr)^{2} + \\lambda \\, \\lVert \\theta \\rVert_2^{2},',
    '  \\label{eq:loss}',
    '\\end{equation}',
    'where $\\lambda > 0$ trades off bias against variance. Minimising',
    '\\cref{eq:loss} by gradient descent gives the update rule',
    '$\\theta_{t+1} = \\theta_t - \\eta \\nabla \\mathcal{L}(\\theta_t)$.',
    '',
    '\\begin{definition}[Convergence]',
    '\\label{def:converge}',
    'We say the procedure has converged when $\\lVert \\nabla \\mathcal{L} \\rVert < \\epsilon$',
    'for a chosen tolerance $\\epsilon > 0$.',
    '\\end{definition}',
    '',
    '\\begin{theorem}',
    '\\label{thm:main}',
    'Under standard assumptions A1--A3, the procedure converges to a stationary',
    'point of $\\mathcal{L}$ in $O(1/\\epsilon^2)$ iterations.',
    '\\end{theorem}',
    '',
    '\\begin{proof}[Proof sketch]',
    'See \\cref{app:proof} for the full derivation; the key step is bounding',
    'the gradient norm by the loss curvature.',
    '\\end{proof}',
    '',
    '% ── 4. Experiments ──────────────────────────────────────────────────────',
    '\\section{Experiments}',
    '\\label{sec:results}',
    '',
    '\\subsection{Setup}',
    'We evaluate on three benchmark datasets. Implementation details appear in',
    '\\cref{app:impl}; all hyper-parameters are reported in \\cref{tab:results}.',
    '',
    '\\subsection{Main results}',
    '\\Cref{tab:results} summarises performance across the benchmark suite.',
    'The proposed method outperforms both baselines on every metric.',
    '',
    '\\begin{table}[h]',
    '  \\centering',
    '  \\begin{tabular}{lrrr}',
    '    \\toprule',
    '    \\textbf{Method} & \\textbf{Accuracy} & \\textbf{F1} & \\textbf{Latency} \\\\',
    '    \\midrule',
    '    Baseline   & \\SI{82.1}{\\percent} & \\SI{79.4}{\\percent} & \\SI{240}{\\milli\\second} \\\\',
    '    Optimised  & \\SI{86.3}{\\percent} & \\SI{84.0}{\\percent} & \\SI{60}{\\milli\\second}  \\\\',
    '    \\textbf{Ours} & \\textbf{\\SI{91.4}{\\percent}} & \\textbf{\\SI{89.7}{\\percent}} & \\textbf{\\SI{18}{\\milli\\second}} \\\\',
    '    \\bottomrule',
    '  \\end{tabular}',
    '  \\caption{Benchmark comparison on the standard test set. Bold marks the',
    '    best result in each column.}',
    '  \\label{tab:results}',
    '\\end{table}',
    '',
    '\\subsection{Qualitative analysis}',
    '\\Cref{fig:example} shows a representative output.',
    '',
    '\\begin{figure}[h]',
    '  \\centering',
    '  \\begin{tikzpicture}',
    '    \\draw[fill=blue!10, draw=blue!60, thick] (0,0) rectangle (10,3.5);',
    '    \\node[align=center] at (5,1.75) {\\Large Replace with \\\\[4pt]',
    '      \\texttt{\\textbackslash includegraphics\\{filename\\}}};',
    '  \\end{tikzpicture}',
    '  \\caption{Placeholder figure. Upload an image (PNG / PDF / JPG) to the',
    '    project and reference it here via \\texttt{\\textbackslash includegraphics}.}',
    '  \\label{fig:example}',
    '\\end{figure}',
    '',
    '% ── 5. Discussion ───────────────────────────────────────────────────────',
    '\\section{Discussion}',
    '\\label{sec:discussion}',
    '',
    'Interpret the results from \\cref{sec:results}. What worked, what didn\'t,',
    'what was surprising? Address limitations honestly --- under what',
    'conditions does the approach fail, and why?',
    '',
    '% ── 6. Conclusion ───────────────────────────────────────────────────────',
    '\\section{Conclusion}',
    '\\label{sec:conclusion}',
    '',
    'Recap the contributions in two or three sentences, anchoring on the',
    'concrete numbers from \\cref{tab:results}. Sketch two or three future',
    'directions worth pursuing.',
    '',
    '% ── Acknowledgements ────────────────────────────────────────────────────',
    '\\section*{Acknowledgements}',
    'The authors thank A.~Reviewer, B.~Reviewer, and the participants of the',
    'study for valuable feedback. This work was supported in part by Grant',
    'XYZ-12345.',
    '',
    '% ── References ──────────────────────────────────────────────────────────',
    '\\begin{thebibliography}{99}',
    '',
    '\\bibitem{turing1950}',
    'A.~M.\\ Turing. \\emph{Computing Machinery and Intelligence}.',
    'Mind, 59(236):433--460, 1950.',
    '',
    '\\bibitem{shannon1948}',
    'C.~E.\\ Shannon. \\emph{A Mathematical Theory of Communication}.',
    'Bell System Technical Journal, 27(3):379--423, 1948.',
    '',
    '\\bibitem{lamport1978}',
    'L.\\ Lamport. \\emph{Time, Clocks, and the Ordering of Events in a',
    'Distributed System}. Communications of the ACM, 21(7):558--565, 1978.',
    '',
    '\\end{thebibliography}',
    '',
    '% ── Appendices ──────────────────────────────────────────────────────────',
    '\\appendix',
    '',
    '\\section{Implementation Details}',
    '\\label{app:impl}',
    'Hyper-parameter sweeps, hardware setup, dataset preprocessing --- material',
    'that would have interrupted the main flow but is needed for reproducibility.',
    '',
    '\\section{Full Proof of \\cref{thm:main}}',
    '\\label{app:proof}',
    'A more rigorous derivation than the sketch given in \\cref{sec:method}.',
    '',
    '\\end{document}',
    ''
  ].join('\n'),
  report: [
    '% =============================================================================',
    '%  Professional technical report with title page, abstract, table of contents,',
    '%  chapters, theorem environments, tables, figures, appendix, and bibliography.',
    '%',
    '%  TIP: hit Compile TWICE to resolve cross-references (TOC, \\ref, \\cite).',
    '% =============================================================================',
    '',
    '\\documentclass[12pt, a4paper, oneside]{report}',
    '',
    '\\usepackage[utf8]{inputenc}',
    '\\usepackage[T1]{fontenc}',
    '\\usepackage[margin=1in, headheight=14pt]{geometry}',
    '\\usepackage{microtype}',
    '\\usepackage{amsmath, amssymb, amsthm}',
    '\\usepackage{graphicx}',
    '\\usepackage{booktabs}',
    '\\usepackage{siunitx}',
    '\\usepackage{enumitem}',
    '\\usepackage{fancyhdr}',
    '\\usepackage{tikz}',
    '\\usepackage[colorlinks=true, linkcolor=blue!60!black, citecolor=teal,',
    '            urlcolor=blue!60!black]{hyperref}',
    '\\usepackage[capitalize, noabbrev]{cleveref}',
    '',
    '% ── Running headers ──────────────────────────────────────────────────────',
    '\\pagestyle{fancy}',
    '\\fancyhf{}',
    '\\fancyhead[L]{\\leftmark}',
    '\\fancyhead[R]{\\thepage}',
    '\\renewcommand{\\chaptermark}[1]{\\markboth{\\chaptername\\ \\thechapter.\\ #1}{}}',
    '',
    '% ── Theorem environments ─────────────────────────────────────────────────',
    '\\theoremstyle{plain}',
    '\\newtheorem{theorem}{Theorem}[chapter]',
    '\\newtheorem{lemma}[theorem]{Lemma}',
    '\\theoremstyle{definition}',
    '\\newtheorem{definition}{Definition}[chapter]',
    '',
    '% ── Title metadata ───────────────────────────────────────────────────────',
    '\\title{Report Title: Subtitle Goes Here}',
    '\\author{Author Name \\\\ \\texttt{author@example.com} \\\\ Institution Name}',
    '\\date{\\today}',
    '',
    '\\begin{document}',
    '',
    '% ── Title page ───────────────────────────────────────────────────────────',
    '\\begin{titlepage}',
    '  \\centering',
    '  \\vspace*{2cm}',
    '  {\\huge\\bfseries Report Title \\par}',
    '  \\vspace{0.6cm}',
    '  {\\Large\\itshape A Detailed Investigation of \\dots\\par}',
    '  \\vspace{3cm}',
    '  {\\Large Author Name\\par}',
    '  \\vspace{0.4cm}',
    '  {\\large \\texttt{author@example.com}\\par}',
    '  \\vspace{2cm}',
    '  {\\large Institution Name \\\\ Department of X}',
    '  \\vfill',
    '  \\begin{tikzpicture}',
    '    \\draw[fill=blue!10, draw=blue!60, thick] (0,0) rectangle (4,4);',
    '    \\node at (2,2) {\\Large logo / cover image};',
    '  \\end{tikzpicture}',
    '  \\vfill',
    '  {\\large \\today\\par}',
    '\\end{titlepage}',
    '',
    '% ── Frontmatter: abstract + TOC + LoF + LoT ──────────────────────────────',
    '\\pagenumbering{roman}',
    '',
    '\\begin{abstract}',
    'A concise summary of the report --- three to five sentences. State the',
    '\\textbf{problem} investigated, the \\textbf{method} you used, the',
    '\\textbf{key results}, and the \\textbf{implications}. A reader who reads',
    'only this paragraph should still walk away with the gist of the work.',
    '\\end{abstract}',
    '',
    '\\tableofcontents',
    '\\listoffigures',
    '\\listoftables',
    '',
    '\\clearpage',
    '\\pagenumbering{arabic}',
    '',
    '% ── Chapter 1: Introduction ──────────────────────────────────────────────',
    '\\chapter{Introduction}',
    '\\label{ch:intro}',
    '',
    '\\section{Background}',
    'Open with the broad context. Why is this topic interesting? Position the',
    'work against established literature~\\cite{lamport1978, knuth1984}.',
    '',
    '\\section{Motivation}',
    'Narrow down to the specific question this report addresses. What gap in',
    'understanding does it fill?',
    '',
    '\\section{Contributions}',
    'This report makes the following contributions:',
    '\\begin{itemize}[noitemsep]',
    '  \\item A formal framework for \\dots',
    '  \\item An empirical evaluation showing \\dots',
    '  \\item Open-source release of the implementation.',
    '\\end{itemize}',
    '',
    '\\section{Document structure}',
    '\\Cref{ch:bg} reviews related work. \\Cref{ch:methods} describes the',
    'approach. Results are presented in \\cref{ch:results}, discussed in',
    '\\cref{ch:discussion}, and concluded in \\cref{ch:conclusion}.',
    '',
    '% ── Chapter 2: Background ────────────────────────────────────────────────',
    '\\chapter{Background and Related Work}',
    '\\label{ch:bg}',
    '',
    '\\section{Prior work}',
    'Cite and summarise the most relevant prior work. Group by theme rather',
    'than chronology.',
    '',
    '\\begin{definition}[Key Concept]',
    '\\label{def:concept}',
    'Define a technical term used throughout the report. Definitions are',
    'numbered by chapter (Definition~2.1, 2.2, \\dots).',
    '\\end{definition}',
    '',
    '\\begin{theorem}[Important Result]',
    '\\label{thm:main}',
    'State a key theorem. Use \\texttt{\\textbackslash begin\\{proof\\}\\dots\\textbackslash end\\{proof\\}}',
    'for the proof if desired.',
    '\\end{theorem}',
    '',
    '% ── Chapter 3: Methods ───────────────────────────────────────────────────',
    '\\chapter{Methods}',
    '\\label{ch:methods}',
    '',
    '\\section{Overview}',
    'Describe the approach at a high level before the formalism. One paragraph,',
    'optimally with a labelled diagram.',
    '',
    '\\section{Mathematical formulation}',
    'We seek parameters $\\theta$ that minimise the regularised loss:',
    '\\begin{equation}',
    '  \\mathcal{L}(\\theta) = \\frac{1}{N} \\sum_{i=1}^{N}',
    '  \\bigl(\\, y_i - f_\\theta(x_i) \\,\\bigr)^{2} + \\lambda \\, \\lVert \\theta \\rVert_2^{2}.',
    '  \\label{eq:loss}',
    '\\end{equation}',
    'We minimise \\cref{eq:loss} by gradient descent. The regularisation',
    'coefficient $\\lambda > 0$ controls the bias-variance trade-off.',
    '',
    '\\section{Procedure}',
    '\\begin{enumerate}[label=\\textbf{Step \\arabic*.}]',
    '  \\item Collect labelled data $\\{(x_i, y_i)\\}_{i=1}^{N}$.',
    '  \\item Initialise $\\theta_0$.',
    '  \\item Iterate: $\\theta_{t+1} = \\theta_t - \\eta\\, \\nabla \\mathcal{L}(\\theta_t)$.',
    '  \\item Stop when $\\lVert \\nabla \\mathcal{L} \\rVert < \\epsilon$.',
    '\\end{enumerate}',
    '',
    '% ── Chapter 4: Results ───────────────────────────────────────────────────',
    '\\chapter{Results}',
    '\\label{ch:results}',
    '',
    '\\section{Quantitative comparison}',
    '\\Cref{tab:bench} summarises the benchmark results across three datasets.',
    '',
    '\\begin{table}[h]',
    '  \\centering',
    '  \\begin{tabular}{lrrr}',
    '    \\toprule',
    '    \\textbf{Method} & \\textbf{Accuracy} & \\textbf{Throughput} & \\textbf{Memory} \\\\',
    '    \\midrule',
    '    Baseline   & \\SI{82.1}{\\percent} & \\SI{120}{\\hertz} & \\SI{1.4}{\\giga\\byte} \\\\',
    '    Optimised  & \\SI{86.3}{\\percent} & \\SI{150}{\\hertz} & \\SI{1.1}{\\giga\\byte} \\\\',
    '    \\textbf{Proposed} & \\textbf{\\SI{91.4}{\\percent}} & \\textbf{\\SI{180}{\\hertz}} & \\textbf{\\SI{0.9}{\\giga\\byte}} \\\\',
    '    \\bottomrule',
    '  \\end{tabular}',
    '  \\caption{Benchmark comparison on the standard test set.}',
    '  \\label{tab:bench}',
    '\\end{table}',
    '',
    '\\section{Qualitative analysis}',
    '\\Cref{fig:placeholder} shows a representative example output.',
    '',
    '\\begin{figure}[h]',
    '  \\centering',
    '  \\begin{tikzpicture}',
    '    \\draw[fill=blue!10, draw=blue!60, thick] (0,0) rectangle (10,4);',
    '    \\node[align=center] at (5,2) {\\Large Replace with \\\\[4pt]',
    '      \\texttt{\\textbackslash includegraphics\\{filename\\}}};',
    '  \\end{tikzpicture}',
    '  \\caption{Placeholder figure. Drop an image into the project tree and',
    '    reference it here with \\texttt{\\textbackslash includegraphics}.}',
    '  \\label{fig:placeholder}',
    '\\end{figure}',
    '',
    '% ── Chapter 5: Discussion ────────────────────────────────────────────────',
    '\\chapter{Discussion}',
    '\\label{ch:discussion}',
    '',
    'Interpret the results from \\cref{ch:results}. What worked, what didn\'t,',
    'what was surprising? Address limitations honestly --- where does the',
    'approach fail, and why?',
    '',
    '% ── Chapter 6: Conclusion ────────────────────────────────────────────────',
    '\\chapter{Conclusion}',
    '\\label{ch:conclusion}',
    '',
    '\\section{Summary}',
    'Recap the contributions briefly. One paragraph that mirrors the abstract',
    'but with concrete numbers from \\cref{tab:bench}.',
    '',
    '\\section{Future work}',
    '\\begin{itemize}[noitemsep]',
    '  \\item Direction 1 --- the obvious next step.',
    '  \\item Direction 2 --- a more ambitious extension.',
    '  \\item Direction 3 --- a longer-term research question.',
    '\\end{itemize}',
    '',
    '% ── Appendix ─────────────────────────────────────────────────────────────',
    '\\appendix',
    '',
    '\\chapter{Supplementary Material}',
    '\\label{app:supp}',
    '',
    'Additional derivations, large tables, full proofs, or extended figures',
    'that would have interrupted the main flow.',
    '',
    '% ── Bibliography ─────────────────────────────────────────────────────────',
    '\\begin{thebibliography}{99}',
    '',
    '\\bibitem{lamport1978}',
    'Leslie Lamport. \\emph{Time, Clocks, and the Ordering of Events in a',
    'Distributed System}. Communications of the ACM, 21(7):558--565, 1978.',
    '',
    '\\bibitem{knuth1984}',
    'Donald E.\\ Knuth. \\emph{The \\TeX{}book}. Addison-Wesley, 1984.',
    '',
    '\\bibitem{einstein1905}',
    'Albert Einstein. \\emph{Zur Elektrodynamik bewegter K\\"orper}.',
    'Annalen der Physik, 322(10):891--921, 1905.',
    '',
    '\\end{thebibliography}',
    '',
    '\\end{document}',
    ''
  ].join('\n'),
  beamer: [
    '% =============================================================================',
    '%  Modern Beamer presentation using the metropolis theme.',
    '%',
    '%  metropolis is a flat, minimalist theme — the de facto modern Beamer style.',
    '%  Ships with TeX Live since 2017. If your distribution lacks it, swap for a',
    '%  built-in theme like Madrid, CambridgeUS, Frankfurt, or Warsaw.',
    '%',
    '%  Compile with pdflatex.',
    '% =============================================================================',
    '',
    '\\documentclass[10pt, aspectratio=169]{beamer}',
    '',
    '\\usetheme{metropolis}',
    '\\usecolortheme{default}            % try: wolverine | seahorse | dolphin | crane',
    '',
    '\\setbeamertemplate{frame numbering}[fraction]',
    '',
    '% ── Packages ────────────────────────────────────────────────────────────',
    '\\usepackage{amsmath, amssymb}',
    '\\usepackage[utf8]{inputenc}',
    '\\usepackage[T1]{fontenc}',
    '\\usepackage{graphicx}',
    '\\usepackage{booktabs}',
    '\\usepackage{listings}',
    '\\usepackage{tikz}',
    '\\usepackage{hyperref}',
    '',
    '% Code-listing style',
    '\\lstdefinestyle{snippet}{',
    '  basicstyle=\\ttfamily\\small,',
    '  keywordstyle=\\color{blue}\\bfseries,',
    '  commentstyle=\\color{gray}\\itshape,',
    '  stringstyle=\\color{red!60!black},',
    '  numbers=left, numberstyle=\\tiny\\color{gray},',
    '  frame=single, framerule=0pt,',
    '  breaklines=true, showstringspaces=false,',
    '}',
    '\\lstset{style=snippet}',
    '',
    '% ── Title block ─────────────────────────────────────────────────────────',
    '\\title{Your Presentation Title}',
    '\\subtitle{A descriptive subtitle that frames the talk}',
    '\\author{Your Name \\\\ \\texttt{your.email@example.com}}',
    '\\institute{Your Institution \\\\ Department of X}',
    '\\date{\\today}',
    '',
    '\\begin{document}',
    '',
    '% ── Title slide ─────────────────────────────────────────────────────────',
    '\\maketitle',
    '',
    '% ── Outline ─────────────────────────────────────────────────────────────',
    '\\begin{frame}{Outline}',
    '  \\tableofcontents',
    '\\end{frame}',
    '',
    '% ─────────────────────────────────────────────────────────────────────────',
    '\\section{Introduction}',
    '',
    '\\begin{frame}{Why this talk}',
    '  \\begin{itemize}',
    '    \\item<1-> First reason --- set the stage.',
    '    \\item<2-> Second reason --- show why it matters.',
    '    \\item<3-> Third reason --- preview the punchline.',
    '  \\end{itemize}',
    '  \\bigskip',
    '  \\onslide<3->{\\textbf{Punchline.} The thing you want them to remember.}',
    '\\end{frame}',
    '',
    '\\begin{frame}{Two columns at a glance}',
    '  \\begin{columns}[T, onlytextwidth]',
    '    \\column{0.48\\textwidth}',
    '      \\textbf{Before}',
    '      \\begin{itemize}',
    '        \\item Manual workflow',
    '        \\item 10 minutes per task',
    '        \\item Error rate: 5\\%',
    '      \\end{itemize}',
    '    \\column{0.48\\textwidth}',
    '      \\textbf{After}',
    '      \\begin{itemize}',
    '        \\item Automated pipeline',
    '        \\item 30 seconds per task',
    '        \\item Error rate: 0.1\\%',
    '      \\end{itemize}',
    '  \\end{columns}',
    '\\end{frame}',
    '',
    '% ─────────────────────────────────────────────────────────────────────────',
    '\\section{Methods}',
    '',
    '\\begin{frame}{Block environments}',
    '  \\begin{block}{Definition}',
    '    The plain \\texttt{block} is the standard call-out box. Use for context',
    '    or background.',
    '  \\end{block}',
    '  \\begin{alertblock}{Watch out}',
    '    \\texttt{alertblock} draws extra attention --- warnings, pitfalls, or',
    '    crucial caveats.',
    '  \\end{alertblock}',
    '  \\begin{exampleblock}{Example}',
    '    \\texttt{exampleblock} for worked examples or illustrative cases.',
    '  \\end{exampleblock}',
    '\\end{frame}',
    '',
    '\\begin{frame}{A formula or two}',
    '  The Pythagorean identity:',
    '  \\[ \\sin^2(\\theta) + \\cos^2(\\theta) = 1 \\]',
    '',
    '  The Fundamental Theorem of Calculus:',
    '  \\[ \\int_{a}^{b} f\'(x) \\, dx = f(b) - f(a) \\]',
    '',
    '  Euler\'s identity --- arguably the most beautiful equation in mathematics:',
    '  \\[ e^{i\\pi} + 1 = 0 \\]',
    '\\end{frame}',
    '',
    '\\begin{frame}[fragile]{Code on a slide}',
    '\\begin{lstlisting}[language=Python]',
    'def fibonacci(n):',
    '    """Return the n-th Fibonacci number."""',
    '    a, b = 0, 1',
    '    for _ in range(n):',
    '        a, b = b, a + b',
    '    return a',
    '\\end{lstlisting}',
    '\\end{frame}',
    '',
    '\\begin{frame}{Results table}',
    '  \\centering',
    '  \\begin{tabular}{lrr}',
    '    \\toprule',
    '    \\textbf{Method} & \\textbf{Throughput} & \\textbf{Latency (p99)} \\\\',
    '    \\midrule',
    '    Baseline       & 1\\,200 req/s        & 240 ms \\\\',
    '    Optimized      & 4\\,800 req/s        & 60 ms \\\\',
    '    \\textbf{New}   & \\textbf{12\\,000 req/s} & \\textbf{18 ms} \\\\',
    '    \\bottomrule',
    '  \\end{tabular}',
    '\\end{frame}',
    '',
    '% ─────────────────────────────────────────────────────────────────────────',
    '\\section{Results}',
    '',
    '\\begin{frame}{Pull-quote}',
    '  \\vfill',
    '  \\begin{quote}',
    '    \\Large ``Worse is better.\'\'',
    '    \\par\\hfill --- Richard P.~Gabriel, 1991',
    '  \\end{quote}',
    '  \\vfill',
    '\\end{frame}',
    '',
    '\\begin{frame}{Figure placeholder}',
    '  \\begin{center}',
    '    \\begin{tikzpicture}',
    '      \\draw[fill=blue!10, draw=blue!60, thick] (0,0) rectangle (10,4);',
    '      \\node[align=center] at (5,2) {%',
    '        \\Large Replace with \\\\[4pt]',
    '        \\texttt{\\textbackslash includegraphics\\{filename\\}}};',
    '    \\end{tikzpicture}',
    '  \\end{center}',
    '\\end{frame}',
    '',
    '% ─────────────────────────────────────────────────────────────────────────',
    '\\section{Conclusion}',
    '',
    '\\begin{frame}{Key takeaways}',
    '  \\begin{enumerate}',
    '    \\item What the audience should remember.',
    '    \\item What\'s next on the roadmap.',
    '    \\item A clear call to action.',
    '  \\end{enumerate}',
    '\\end{frame}',
    '',
    '% Standout frame (metropolis special) --- big centered text on accent bg',
    '\\begin{frame}[standout]',
    '  Questions?',
    '\\end{frame}',
    '',
    '% ── Appendix (excluded from TOC / page count) ────────────────────────────',
    '\\appendix',
    '',
    '\\begin{frame}[allowframebreaks]{References}',
    '  \\footnotesize',
    '  \\begin{itemize}',
    '    \\item Author A. ``Title of Paper.\'\' \\textit{Journal Name}, vol.~1, 2023.',
    '    \\item Author B, Author C. ``Another Title.\'\' \\textit{Conference Proceedings}, 2022.',
    '    \\item Author D. ``Yet Another.\'\' arXiv:2024.12345.',
    '  \\end{itemize}',
    '\\end{frame}',
    '',
    '\\begin{frame}{Backup: extra details}',
    '  Use \\texttt{\\textbackslash appendix} for backup slides --- they\'re excluded',
    '  from the page count and TOC, so they don\'t inflate slide counts during',
    '  conference timing.',
    '\\end{frame}',
    '',
    '\\end{document}',
    ''
  ].join('\n'),
  letter: '\\documentclass{letter}\n\n\\signature{Your Name}\n\\address{Your Address \\\\ City, State ZIP}\n\n\\begin{document}\n\n\\begin{letter}{Recipient \\\\ Address \\\\ City, State ZIP}\n\n\\opening{Dear Sir or Madam,}\n\nBody of the letter goes here.\n\n\\closing{Sincerely,}\n\n\\end{letter}\n\\end{document}\n',
  cv: [
    '% =============================================================================',
    '%  Professional CV/Resume built with moderncv.',
    '%',
    '%  Styles:  banking | classic | casual | oldstyle | fancy',
    '%  Colors:  blue | orange | green | red | purple | grey | black',
    '%',
    '%  Compile with pdflatex. moderncv ships with TeX Live by default.',
    '% =============================================================================',
    '',
    '\\documentclass[11pt, a4paper, sans]{moderncv}',
    '',
    '\\moderncvstyle{banking}     % try classic for a sidebar layout',
    '\\moderncvcolor{blue}',
    '',
    '\\usepackage[scale=0.82]{geometry}',
    '\\usepackage[utf8]{inputenc}',
    '\\usepackage[T1]{fontenc}',
    '',
    '% ── Personal info ────────────────────────────────────────────────────────',
    '\\name{Your}{Name}',
    '\\title{Senior Software Engineer}',
    '\\address{1234 Main Street}{City, State 12345}{Country}',
    '\\phone[mobile]{+1~(555)~123-4567}',
    '\\email{your.email@example.com}',
    '\\homepage{www.yourwebsite.com}',
    '\\social[linkedin]{your-linkedin-handle}',
    '\\social[github]{your-github-username}',
    '% \\social[twitter]{your-twitter-handle}',
    '% \\photo[64pt][0.4pt]{photo}    % uncomment + provide photo.jpg',
    '',
    '\\begin{document}',
    '\\makecvtitle',
    '',
    '% ── Profile ──────────────────────────────────────────────────────────────',
    '\\section{Profile}',
    '\\cvitem{}{Software engineer with 5+ years building scalable backend',
    'systems and distributed services. Passionate about clean architecture,',
    'developer experience, and shipping reliable products at scale.',
    'Looking for senior individual-contributor roles where systems thinking',
    'and a bias for shipping matter.}',
    '',
    '% ── Education ────────────────────────────────────────────────────────────',
    '\\section{Education}',
    '\\cventry{2018--2022}{B.S.\\ in Computer Science}{Stanford University}{Stanford, CA}{\\textit{GPA: 3.9 / 4.0}}{%',
    '  Honors thesis: ``Scaling Lock-Free Data Structures in Multicore Environments.\'\'',
    '  Coursework: Distributed Systems, Operating Systems, Machine Learning,',
    '  Compilers, Algorithms, Networking.}',
    '\\cventry{2014--2018}{High School Diploma}{Lincoln High School}{Anytown, USA}{Valedictorian}{}',
    '',
    '% ── Experience ───────────────────────────────────────────────────────────',
    '\\section{Experience}',
    '\\cventry{Jan 2023 -- Present}{Senior Software Engineer}{Acme Corporation}{San Francisco, CA}{}{%',
    '\\begin{itemize}',
    '  \\item Designed and shipped a distributed task scheduler handling 50M jobs/day; reduced p99 latency by 75\\%.',
    '  \\item Led a team of 4 engineers migrating a legacy monolith to a microservices architecture (Go, Kubernetes).',
    '  \\item Mentored 2 junior engineers and ran weekly internal tech-talks on system design.',
    '  \\item Owned the company-wide observability stack: OpenTelemetry pipelines, Grafana dashboards, on-call rotation.',
    '\\end{itemize}}',
    '',
    '\\cventry{Jun 2022 -- Dec 2022}{Software Engineer Intern}{Globex Inc.}{Mountain View, CA}{}{%',
    '\\begin{itemize}',
    '  \\item Built a real-time analytics pipeline (Kafka + Flink) ingesting 1B events/day.',
    '  \\item Cut data-warehouse costs by 30\\% via tiered storage policies and partition pruning.',
    '  \\item Return offer extended; declined to take the role at Acme.',
    '\\end{itemize}}',
    '',
    '\\cventry{May 2021 -- Aug 2021}{Research Assistant}{Stanford Distributed Systems Lab}{Stanford, CA}{}{%',
    '  Contributed to an open-source CRDT library; co-authored a paper on',
    '  convergent replicated data types at low-latency edges (see Publications).}',
    '',
    '% ── Projects ─────────────────────────────────────────────────────────────',
    '\\section{Projects}',
    '\\cventry{2023}{\\href{https://github.com/your-username/scheduler}{distributed-scheduler}}{Open-source}{Go, Raft, gRPC}{}{%',
    '  Fault-tolerant job scheduler implementing Raft consensus. ``Cron at',
    '  planet scale.\'\' 1.5k stars on GitHub.}',
    '',
    '\\cventry{2022}{\\href{https://github.com/your-username/llm-eval}{llm-eval}}{Open-source}{Python, PyTorch}{}{%',
    '  Benchmarking framework comparing inference latency and output quality',
    '  across leading open-source LLMs. Used by 3 academic teams.}',
    '',
    '% ── Publications ─────────────────────────────────────────────────────────',
    '\\section{Publications}',
    '\\cvitem{2023}{\\textbf{Your Name}, Co-Author A, Co-Author B.',
    '  ``Convergent Replicated Data Types at the Edge.\'\'',
    '  \\textit{Proceedings of the 17th USENIX Symposium on Operating Systems',
    '  Design and Implementation (OSDI \'23)}, pp.~245--260.}',
    '',
    '\\cvitem{2022}{Co-Author X, \\textbf{Your Name}.',
    '  ``Latency Bounds for Lock-Free Queues on NUMA Hardware.\'\'',
    '  \\textit{ACM Transactions on Computer Systems}, vol.~40, no.~3, 2022.}',
    '',
    '% ── Skills ───────────────────────────────────────────────────────────────',
    '\\section{Skills}',
    '\\cvitem{Languages}{Go, Python, Rust, TypeScript, Java, C, SQL}',
    '\\cvitem{Infrastructure}{Kubernetes, Docker, AWS (EC2/S3/Lambda/RDS), Terraform, Linux}',
    '\\cvitem{Databases}{PostgreSQL, Redis, Kafka, ClickHouse, DynamoDB}',
    '\\cvitem{Tools}{Git, Bazel, Prometheus, Grafana, OpenTelemetry, Jaeger}',
    '\\cvitem{Domains}{Distributed systems, observability, performance engineering, ML infrastructure}',
    '',
    '% ── Languages (spoken) ───────────────────────────────────────────────────',
    '\\section{Languages}',
    '\\cvitemwithcomment{English}{Native}{}',
    '\\cvitemwithcomment{Spanish}{Conversational}{B2 -- DELE certified}',
    '\\cvitemwithcomment{German}{Basic}{A2}',
    '',
    '% ── Awards \\& certifications ──────────────────────────────────────────────',
    '\\section{Awards \\& Certifications}',
    '\\cvitem{2023}{AWS Certified Solutions Architect -- Professional}',
    '\\cvitem{2023}{Best Paper Award, USENIX OSDI \'23}',
    '\\cvitem{2021}{Stanford Computer Science Departmental Honors}',
    '\\cvitem{2018}{National Merit Scholar}',
    '',
    '% ── Volunteering / Hobbies (optional) ────────────────────────────────────',
    '% \\section{Volunteering}',
    '% \\cventry{2020 -- present}{Mentor}{Code 2040 Fellowship}{Remote}{}{Quarterly',
    '%   mentoring sessions with under-represented students pursuing CS careers.}',
    '',
    '% ── References ───────────────────────────────────────────────────────────',
    '% \\section{References}',
    '% \\cvitem{}{Available upon request.}',
    '',
    '\\end{document}',
    ''
  ].join('\n'),
  chemistry: [
    '\\documentclass[12pt, a4paper]{article}',
    '',
    '\\usepackage{amsmath, amssymb}',
    '\\usepackage{geometry}',
    '\\usepackage{graphicx, hyperref}',
    '\\usepackage[version=4]{mhchem}',
    '',
    '\\title{Chemistry Notes}',
    '\\author{Author Name}',
    '\\date{\\today}',
    '',
    '\\begin{document}',
    '\\maketitle',
    '',
    '% TIP: select any \\ce{...} below, then use the floating',
    '% \\textbf{Render} dropdown to insert Lewis / SMILES / 3D structures.',
    '',
    '\\section{Single molecules}',
    'Water: \\ce{H2O}.',
    '',
    'Carbon dioxide: \\ce{CO2}.',
    '',
    'Ammonia: \\ce{NH3}.',
    '',
    'Methane: \\ce{CH4}.',
    '',
    '\\section{Balanced reactions}',
    'Combustion of hydrogen: \\ce{2H2 + O2 -> 2H2O}.',
    '',
    'Combustion of methane: \\ce{CH4 + 2O2 -> CO2 + 2H2O}.',
    '',
    'Neutralisation: \\ce{HCl + NaOH -> NaCl + H2O}.',
    '',
    'Photosynthesis: \\ce{6CO2 + 6H2O -> C6H12O6 + 6O2}.',
    '',
    '\\section{Organic compounds (SMILES)}',
    '% Paste any valid SMILES inside \\ce{...} and choose ``SMILES\'\'',
    '% from the Render dropdown.',
    '',
    'Benzene: \\ce{c1ccccc1}.',
    '',
    'Caffeine: \\ce{CN1C=NC2=C1C(=O)N(C(=O)N2C)C}.',
    '',
    'Aspirin: \\ce{CC(=O)OC1=CC=CC=C1C(=O)O}.',
    '',
    'Glucose: \\ce{OCC1OC(O)C(O)C(O)C1O}.',
    '',
    '\\section{Ions and formal charges}',
    'Ammonium: \\ce{NH4+}.',
    '',
    'Hydroxide: \\ce{OH-}.',
    '',
    'Sulfate: \\ce{SO4^{2-}}.',
    '',
    'Carbonate: \\ce{CO3^{2-}}.',
    '',
    '\\end{document}',
    ''
  ].join('\n'),

  andrews: [
    '% Andrews Curves visualisation of the Fisher Iris dataset.',
    '% iris.csv is auto-loaded into your project file tree when you pick this template.',
    '% Compile and the curves render — three classes (setosa / versicolor / virginica)',
    '% mapped to a single trigonometric projection.',
    '',
    '\\documentclass[border=10pt]{standalone}',
    '\\usepackage{pgfplots}',
    '\\usepackage{pgfplotstable}',
    '\\pgfplotsset{compat=1.18}',
    '',
    '% Read the Iris dataset',
    '\\pgfplotstableread[col sep=comma]{iris.csv}\\irisdata',
    '',
    '% Plot all rows in [#1, #2] using colour #3 — legend handled at the call site',
    '\\newcommand{\\AndrewsCurves}[4]{%',
    '  \\foreach \\i in {#1,...,#2} {%',
    '    \\pgfplotstablegetelem{\\i}{sepal_length}\\of\\irisdata \\let\\sl\\pgfplotsretval',
    '    \\pgfplotstablegetelem{\\i}{sepal_width}\\of\\irisdata  \\let\\sw\\pgfplotsretval',
    '    \\pgfplotstablegetelem{\\i}{petal_length}\\of\\irisdata \\let\\pl\\pgfplotsretval',
    '    \\pgfplotstablegetelem{\\i}{petal_width}\\of\\irisdata  \\let\\pw\\pgfplotsretval',
    '    \\addplot+[no marks, #3, opacity=0.35]',
    '      {\\sl/sqrt(2) + \\sw*sin(deg(x)) + \\pl*cos(deg(x)) + \\pw*sin(deg(2*x))};',
    '  }',
    '}',
    '',
    '\\begin{document}',
    '\\begin{tikzpicture}',
    '\\begin{axis}[',
    '  width=14cm,',
    '  height=8cm,',
    '  domain=-pi:pi,',
    '  samples=100,',
    '  xlabel={$t$},',
    '  ylabel={$f(t)$},',
    '  xtick={-3.14159,-1.5708,0,1.5708,3.14159},',
    '  xticklabels={$-\\pi$,$-\\pi/2$,$0$,$\\pi/2$,$\\pi$},',
    '  grid=both,',
    '  legend pos=outer north east,',
    '  legend style={font=\\small}',
    ']',
    '',
    '\\AndrewsCurves{0}{49}{blue}{}',
    '\\addlegendentry{setosa}',
    '',
    '\\AndrewsCurves{50}{99}{red}{}',
    '\\addlegendentry{versicolor}',
    '',
    '\\AndrewsCurves{100}{149}{green!60!black}{}',
    '\\addlegendentry{virginica}',
    '',
    '\\end{axis}',
    '\\end{tikzpicture}',
    '\\end{document}',
    ''
  ].join('\n'),

  calculus: [
    '% Calculus and Sigma Solve --- a hands-on guide.',
    '% This template is both a calculus reference and a tutorial for the',
    '% built-in solver.  Read the "How to use" section and follow the',
    '% "Try it" callouts on each example.',
    '',
    '\\documentclass[12pt, a4paper]{article}',
    '',
    '\\usepackage{amsmath, amssymb}',
    '\\usepackage[margin=1in]{geometry}',
    '\\usepackage{hyperref}',
    '',
    '\\hypersetup{colorlinks=true, urlcolor=blue, linkcolor=black,',
    '             pdftitle={Calculus and Sigma Solve}}',
    '',
    '\\title{Calculus in the \\LaTeX{} Editor \\\\ \\large A Hands-On Guide to $\\Sigma$ Solve}',
    '\\author{}',
    '\\date{\\today}',
    '',
    '\\begin{document}',
    '\\maketitle',
    '',
    '\\section*{What this guide does}',
    'This document is both a calculus cheat sheet and a tutorial for the',
    'editor\'s built-in \\textbf{$\\Sigma$ Solve} feature. Every limit below is',
    '\\emph{live}: highlight it, click $\\Sigma$ Solve in the floating menu,',
    'and the answer appears inline.',
    '',
    '\\section*{How to use $\\Sigma$ Solve}',
    '\\begin{enumerate}',
    '  \\item \\textbf{Highlight a limit expression.} Drag across something',
    '        like \\verb|\\lim_{x \\to 2} (3x + 1)|. Select just the',
    '        \\verb|\\lim_{...}| construct, not the surrounding math',
    '        delimiters.',
    '  \\item \\textbf{Wait for the floating menu.} A toolbar appears below',
    '        your selection. The right-most button reads \\textbf{$\\Sigma$',
    '        Solve limit}.',
    '  \\item \\textbf{Click it.} Pick \\textbf{Solve} for a one-line answer',
    '        appended after your selection, or \\textbf{Solve with steps}',
    '        for a worked solution as an \\texttt{align*} block.',
    '\\end{enumerate}',
    '',
    '\\noindent\\textbf{Heads-up.} v1 supports \\textbf{limits} only.',
    'Integrals, derivatives, and series have proper \\LaTeX{} below but the',
    'Solve button is coming in the next release.',
    '',
    '\\section{Limits ($\\Sigma$ Solve enabled)}',
    '',
    '\\paragraph{1.1 Direct substitution.}',
    'Plug in the target when the function is continuous there:',
    '\\[ \\lim_{x \\to 2} (3x + 1) = 7 \\]',
    '\\textit{Try it: method should be ``Direct Substitution\'\'.}',
    '',
    '\\paragraph{1.2 L\'Hopital\'s rule.}',
    'Direct substitution gives $0/0$; the solver differentiates top and bottom:',
    '\\[ \\lim_{x \\to 0} \\frac{\\sin(x)}{x} = 1 \\]',
    '\\textit{Try it: method ``L\'Hopital\'\'s Rule\'\' or ``Known Limit\'\'.}',
    '',
    '\\paragraph{1.3 Algebraic simplification.}',
    'A removable discontinuity; the $(x-1)$ factor cancels:',
    '\\[ \\lim_{x \\to 1} \\frac{x^{2} - 1}{x - 1} = 2 \\]',
    '\\textit{Try it: method ``Algebraic Simplification\'\'.}',
    '',
    '\\paragraph{1.4 One-sided limit.}',
    'The $0^{+}$ marker means approach from the right only:',
    '\\[ \\lim_{x \\to 0^{+}} \\frac{1}{x} = +\\infty \\]',
    '\\textit{Try it: result $\\infty$, method ``Numerical (Right)\'\'.}',
    '',
    '\\paragraph{1.5 Limit at infinity.}',
    '\\[ \\lim_{x \\to \\infty} \\frac{x^{2} + 1}{x^{2} - 1} = 1 \\]',
    '\\textit{Try it: method ``Numerical Approximation\'\'.}',
    '',
    '\\section{Derivatives (Solve coming in v2)}',
    '',
    'Power rule: $\\frac{d}{dx} x^{n} = n\\, x^{n-1}$.',
    '',
    'Common derivatives:',
    '\\begin{align*}',
    '  \\frac{d}{dx} \\sin(x) &= \\cos(x) \\\\',
    '  \\frac{d}{dx} e^{x}    &= e^{x} \\\\',
    '  \\frac{d}{dx} \\ln(x)  &= \\frac{1}{x}',
    '\\end{align*}',
    '',
    'Product rule: $(fg)\' = f\'g + fg\'$.',
    '',
    'Chain rule: $\\frac{d}{dx} f(g(x)) = f\'(g(x)) \\cdot g\'(x)$.',
    '',
    '\\section{Integrals (Solve coming in v2)}',
    '',
    'Indefinite (antiderivative):',
    '\\[ \\int x^{2} \\, dx = \\frac{x^{3}}{3} + C \\]',
    '',
    'Definite integral via the Fundamental Theorem of Calculus:',
    '\\[ \\int_{0}^{1} x^{2} \\, dx = \\left[ \\frac{x^{3}}{3} \\right]_{0}^{1} = \\frac{1}{3} \\]',
    '',
    'Common integrals:',
    '\\begin{align*}',
    '  \\int \\sin(x) \\, dx       &= -\\cos(x) + C \\\\',
    '  \\int e^{x} \\, dx          &= e^{x} + C \\\\',
    '  \\int \\frac{1}{x} \\, dx   &= \\ln|x| + C',
    '\\end{align*}',
    '',
    'Integration by parts: $\\int u \\, dv = uv - \\int v \\, du$.',
    '',
    '\\section{Series (Solve coming in v2)}',
    '',
    'Taylor series of $e^{x}$:',
    '\\[ e^{x} = \\sum_{n=0}^{\\infty} \\frac{x^{n}}{n!}',
    '         = 1 + x + \\frac{x^{2}}{2!} + \\frac{x^{3}}{3!} + \\cdots \\]',
    '',
    'Geometric series ($|r| < 1$):',
    '\\[ \\sum_{n=0}^{\\infty} r^{n} = \\frac{1}{1 - r} \\]',
    '',
    'Sums:  $\\sum_{k=1}^{n} k = \\frac{n(n+1)}{2}$,',
    '\\quad $\\sum_{k=1}^{n} k^{2} = \\frac{n(n+1)(2n+1)}{6}$.',
    '',
    '\\section{Other features in this editor}',
    '\\begin{itemize}',
    '  \\item \\textbf{Chemistry rendering.} Type \\verb|\\ce{H2O}| or any',
    '        \\texttt{mhchem} expression, select it, and a render dropdown',
    '        lets you insert a Lewis dot structure, a 2D SMILES depiction,',
    '        or a 3D VSEPR model with a property table.',
    '  \\item \\textbf{Image to \\LaTeX.} Drag a screenshot of a math',
    '        equation, table, or matrix into the editor; vision AI converts',
    '        it to \\LaTeX{} source.',
    '  \\item \\textbf{AI Fix.} When compilation fails, click AI Fix on the',
    '        error to repair it automatically.',
    '  \\item \\textbf{Templates.} The Templates dropdown ships starters for',
    '        Article, Report, Presentation, Letter, CV, Chemistry, this',
    '        Calculus guide, and Andrews-curves visualisation.',
    '  \\item \\textbf{File uploads.} Use the ``$+$\'\' icon in the file tree',
    '        for figures, data files (\\verb|.csv|), and bibliography.',
    '\\end{itemize}',
    '',
    '\\section{Tips and limitations}',
    '\\begin{itemize}',
    '  \\item Select only the math --- skip the surrounding \\verb|$...$|.',
    '  \\item The original expression is preserved; Solve appends',
    '        \\verb|= <result>| after your selection.',
    '  \\item Supported patterns: \\verb|\\frac{a}{b}|, \\verb|\\sin x|,',
    '        \\verb|\\sqrt{x}|, Greek letters, \\verb|\\to|, \\verb|\\infty|.',
    '  \\item Long \\texttt{pgfplots}/\\texttt{TikZ} documents can take 30--90',
    '        seconds to compile.',
    '\\end{itemize}',
    '',
    '\\end{document}',
    ''
  ].join('\n')
};

// Some templates need companion data files preloaded into the project file
// tree (so they compile without the user manually uploading them). Map of
// template name -> list of filenames under /latex/static/data/.
var TEMPLATE_COMPANION_FILES = {
  andrews: ['iris.csv']
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

  // AI Fix button
  var aiBtn = document.createElement('button');
  aiBtn.className = 'ai-fix-btn';
  aiBtn.textContent = '\u2728 AI Fix';
  aiBtn.title = 'Let AI fix this error';
  aiBtn.onclick = function(e) {
    e.stopPropagation();
    if (typeof window.fixError === 'function') {
      window.fixError(message, lineNum);
    }
  };

  var dismiss = document.createElement('span');
  dismiss.className = 'cm-error-widget-dismiss';
  dismiss.textContent = '\u00D7';
  dismiss.title = 'Dismiss';

  widgetEl.appendChild(icon);
  widgetEl.appendChild(text);
  widgetEl.appendChild(aiBtn);
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
  if (!tmpl) return;
  setEditorContent(tmpl);

  // If this template has companion data files (e.g. iris.csv for Andrews
  // curves), fetch them from /latex/static/data/ and add to the file tree
  // + fileContents so compile-time reupload picks them up automatically.
  var files = TEMPLATE_COMPANION_FILES[name];
  if (!files || !files.length) return;
  if (!window.CONFIG || window.CONFIG.ctx == null) return;

  files.forEach(function (filename) {
    var url = window.CONFIG.ctx + '/latex/static/data/' + encodeURIComponent(filename);
    fetch(url)
      .then(function (res) {
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return res.text();
      })
      .then(function (content) {
        if (typeof window.fileContents === 'object' && window.fileContents !== null) {
          window.fileContents[filename] = content;
        }
        if (typeof window.addFileToTree === 'function') {
          window.addFileToTree(filename, false, content);
        }
        if (typeof window.showSuccessToast === 'function') {
          window.showSuccessToast('Loaded ' + filename + ' (' + content.length + ' bytes)');
        }
      })
      .catch(function (err) {
        if (typeof window.showWarningToast === 'function') {
          window.showWarningToast('Could not auto-load ' + filename + ': ' + err.message + '. Upload it manually.');
        }
      });
  });
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
