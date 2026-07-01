<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    request.setAttribute("aiToolId", "math-ai");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="../modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Unified Matrix Calculator — single page covering 13 ops:
          determinant, inverse, transpose, trace, rank, RREF,
          eigenvalues, eigenvectors, characteristic polynomial,
          power (A^n), addition, subtraction, multiplication.

        Architecture:
          · MathLive native <math-field> for matrix entry — no custom
            grid widget, no plain-text fallback.  Tab/arrows navigate
            between cells.
          · Single JS controller at /modern/js/matrix-calculator.js
            handles op switching, validation, SymPy code generation,
            result + steps rendering.
          · SymPy backend via /OneCompilerFunctionality (same pattern
            as series + limit + vector-calc).
          · Tutorial-grade steps for det / inverse / eigenvalues /
            multiplication; symbolic chain for the rest.
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow,max-image-preview:large,max-snippet:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="author" content="Anish Nath">

    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Matrix Calculator with Steps + AI Photo Scan" />
        <jsp:param name="toolDescription" value="Free AI matrix calculator with step-by-step solutions and photo scan. 13 ops in one page: determinant, inverse, multiply, eigenvalues, eigenvectors, RREF, A^n, transpose, rank, trace, char. polynomial, A+B, A-B. Snap a problem from your textbook, paste a Symbolab-style expression, or type with the visual MathLive editor. Live geometric visualization. No signup." />
        <jsp:param name="toolCategory" value="Linear Algebra" />
        <jsp:param name="toolUrl" value="math/matrix-calculator.jsp" />
        <jsp:param name="toolKeywords" value="matrix calculator, matrix calculator with steps, AI matrix calculator, matrix calculator scan image, matrix calculator photo, snap matrix problem, photo math matrix, scan math problem from photo, AI matrix solver, matrix step by step solver, determinant calculator with steps, matrix inverse calculator with steps, matrix multiplication calculator, eigenvalue calculator, eigenvector calculator, matrix transpose calculator, matrix power calculator A^n, matrix addition calculator, matrix subtraction calculator, matrix rank calculator, RREF calculator, gauss jordan elimination calculator, characteristic polynomial calculator, trace of matrix calculator, adjugate matrix calculator, cofactor expansion calculator, linear algebra calculator step by step, matrix solver online free, MathLive matrix editor, Symbolab style matrix calculator, visualize matrix transformation, matrix transformation graph, eigenvector visualization, parallelogram determinant, AP linear algebra solver, college linear algebra homework help, no signup matrix calculator, free matrix calculator online" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="13 matrix operations on one page,AI photo scan with step-by-step solver (camera + PDF + image upload),Symbolab-style smart input (\det A / A^{-1} / A*B / A^T auto-detected),Geometric visualization tab (unit-square / unit-cube transformation overlay),MathLive visual matrix editor with Tab and arrow navigation,Determinant with cofactor expansion steps,Inverse via adjugate (n<=3) or augmented Gauss-Jordan (n>=4),Eigenvalues from characteristic polynomial,Eigenvectors with (A - lambda I) RREF derivation,Matrix power A^n with intermediate products,Multiplication shown as row-by-column dot products,Add subtract transpose trace rank RREF char. poly,Up to 8x8 matrices including rectangular shapes,Symbolic entries (fractions pi e variables),Step-by-step LaTeX-rendered solutions,Built-in Python (SymPy) compiler with editable code,Batch solve all problems from a single image,Shareable deep links per operation,Dark mode,No signup no limits free forever" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="High School, AP Linear Algebra, College, University" />
        <jsp:param name="teaches" value="Linear algebra, matrix operations, determinant, cofactor expansion, matrix inverse, adjugate method, Gauss-Jordan elimination, eigenvalues, eigenvectors, characteristic polynomial, matrix multiplication, RREF, matrix rank, geometric interpretation of matrices as linear transformations" />
        <jsp:param name="howToSteps" value="Snap a photo OR type the matrix|Click the camera button to scan a problem from a photo or PDF (AI extracts the matrix and the operation in one shot) OR type cells directly using the visual MathLive editor with Tab and arrow keys to navigate.,Pick an operation OR let smart-detect figure it out|Click a chip (det / inverse / eigenvalues / multiply / etc.) OR paste a self-describing expression like \\det A or A^{-1} or A B and the chip auto-switches.,Click Calculate|Result and step-by-step solution render with full LaTeX. Tutorial-grade derivations for det / inverse / eigenvalues / multiply.,Review steps and visualize|Switch to Steps for the worked solution; Visualize for the unit-square / unit-cube transformation overlay (2x2 and 3x3 numeric matrices); Python for the editable SymPy code." />
        <jsp:param name="faq1q" value="Can I scan a matrix problem from a photo?" />
        <jsp:param name="faq1a" value="Yes. Click the green Scan button next to Matrix A, upload a photo or PDF of your homework, and our AI extracts every matrix problem from the page and tells you the operation (determinant, inverse, eigenvalues, A times B, etc.). Pick one to fill the form and solve, or click Solve All to batch-solve every problem in the image with full step-by-step solutions for each. Works on textbook pages, exam papers, and handwritten work." />
        <jsp:param name="faq2q" value="What matrix operations does this calculator support?" />
        <jsp:param name="faq2a" value="Thirteen operations on a single page: determinant, inverse, transpose, trace, rank, reduced row echelon form (RREF / Gauss-Jordan), eigenvalues, eigenvectors, characteristic polynomial, matrix power A^n (positive or negative integer), addition A+B, subtraction A-B, and multiplication A*B. Switch operations with one click; your matrix persists across switches. Up to 8x8 plus rectangular shapes (2x3, 3x4, 4x2, etc.) where the operation supports them." />
        <jsp:param name="faq3q" value="How do I enter a matrix? Can I type Symbolab-style expressions?" />
        <jsp:param name="faq3a" value="Three ways: (1) Visual matrix editor — pick a size from the dropdown and a fresh grid appears; Tab and arrow keys move between cells. Integers, fractions like 1/2, decimals, symbols (a, x, theta), and constants (pi, e) all work. (2) Symbolab-style smart input — paste a self-describing expression like \\det A, A^{-1}, A^T, A B (juxtaposition for multiply), \\tr A, gauss jordan A, eigenvectors A and the calculator auto-detects the operation and switches the chip. (3) AI photo scan — upload an image and the AI extracts the matrix into the editor for you." />
        <jsp:param name="faq4q" value="What does the Visualize tab show?" />
        <jsp:param name="faq4a" value="A geometric overlay of the matrix as a linear transformation. For 2x2 numeric matrices the unit square is drawn in grey and the transformed parallelogram is overlaid in green (or red if det A is negative, indicating orientation flip). For determinants the shaded area equals |det A|. For eigenvectors, coloured arrows mark the directions A leaves invariant. For multiplication, you see B applied first then A applied to the result, making composition order obvious. For powers A^n, you see successive frames. 3x3 numeric matrices show the unit cube and parallelepiped via 3D mesh. Operations like rank, trace, char. polynomial, RREF, and eigenvalues alone are purely algebraic and don't get a visualization." />
        <jsp:param name="faq5q" value="How do you calculate the determinant of a matrix step by step?" />
        <jsp:param name="faq5a" value="For a 2x2 matrix [[a,b],[c,d]] the determinant is ad-bc. For 3x3 and larger, this calculator uses cofactor expansion along the first row: det(A) = sum over j of (-1)^(1+j) * a_{1j} * M_{1j}, where M_{1j} is the minor — the determinant of the submatrix obtained by deleting row 1 and column j. The Steps tab walks through each minor, the signed sum, and the simplification to a single number. The Visualize tab shows the geometric meaning: |det A| is the area of the parallelogram (2x2) or the volume of the parallelepiped (3x3) that A maps the unit square or cube to." />
        <jsp:param name="faq6q" value="How is the matrix inverse computed step by step?" />
        <jsp:param name="faq6a" value="For 2x2 and 3x3 matrices the calculator uses the adjugate method shown step by step: compute det(A), build the cofactor matrix, transpose to get the adjugate adj(A), then divide every entry by det(A). The full chain A^-1 = (1/det A) * adj(A) is rendered with LaTeX. For 4x4 and larger we use Gauss-Jordan elimination on the augmented matrix [A | I]: row-reduce until the left block becomes the identity I, and the right block is A^-1. If the determinant is zero the matrix is singular and the calculator clearly explains that no inverse exists." />
        <jsp:param name="faq7q" value="How do you find eigenvalues and eigenvectors with steps?" />
        <jsp:param name="faq7a" value="Eigenvalues solve det(A - lambda*I) = 0, the characteristic equation. The Steps tab shows: (1) form A - lambda*I, (2) compute its determinant as a polynomial in lambda, (3) set it to zero and solve for lambda. Eigenvectors then come from solving (A - lambda*I) * v = 0 for each lambda — the calculator displays (A - lambda*I), its row-reduced echelon form, and the basis eigenvectors with algebraic multiplicities. For 2x2 numeric cases, the Visualize tab draws each eigenvector as a coloured arrow with a dotted arrow showing A*v = lambda*v on the same line, demonstrating the invariant-direction property visually." />
        <jsp:param name="faq8q" value="When does matrix multiplication A*B work?" />
        <jsp:param name="faq8a" value="A*B is defined when the number of columns of A equals the number of rows of B. If A is m x n and B is n x p, then AB is m x p. The (i,j) entry of AB is the dot product of row i of A with column j of B: (AB)_ij = sum over k of A_ik * B_kj. The calculator validates dimensions before computing (saving you the typo) and, for results up to 3x3, shows each entry as an explicit row-by-column dot product. The Visualize tab shows AB as the composition of two linear transformations: B is applied first (dashed parallelogram), then A is applied to that result (solid parallelogram), making the order of composition geometrically obvious." />
        <jsp:param name="faq9q" value="What happens if my matrix is not square or is singular?" />
        <jsp:param name="faq9a" value="The calculator validates each operation before solving and shows a clear inline warning. Determinant, trace, eigenvalues, eigenvectors, characteristic polynomial, inverse, and power all require a square matrix; non-square inputs are caught immediately. Inverse additionally requires a non-zero determinant; if A is singular the warning explains that no inverse exists. RREF, rank, transpose, addition, subtraction, and multiplication work on rectangular matrices subject to their own dimension rules — A+B and A-B need matching shapes, A*B needs A.cols = B.rows." />
        <jsp:param name="faq10q" value="Is this matrix calculator really free? Any signup or limits?" />
        <jsp:param name="faq10a" value="Yes — 100 percent free, no signup, no daily limits, no paywalls on step-by-step solutions. You get all 13 operations, AI photo scan, batch solve, geometric visualization, the Python (SymPy) compiler with editable code, and shareable deep-link URLs. Everything runs in your browser; the only server calls are the AI image extraction and the SymPy execution itself, neither of which require an account. Dark mode included." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <!-- Shared site CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">

    <!-- Math shell -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css">

    <!-- KaTeX + MathLive + image-to-math (scan modal styling) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css">

    <%@ include file="../modern/components/math-ai-head.inc.jsp" %>
    <style>
    .mc-card-tools .math-ai-tab-btn {
        display: inline-flex; align-items: center; gap: 0.35rem;
        appearance: none; border: 1px solid var(--ms-accent, #15803d);
        background: var(--ms-panel-bg, #fff); color: var(--ms-accent, #15803d);
        font: 600 0.78rem/1 var(--ms-font, system-ui);
        padding: 0.35rem 0.75rem; border-radius: 6px; cursor: pointer;
    }
    .mc-card-tools .math-ai-tab-btn:hover {
        background: var(--ms-accent, #15803d); color: #fff;
    }
    .mc-card-tools .math-ai-tab-btn[aria-busy="true"] { opacity: 0.75; cursor: wait; }
    </style>

    <%@ include file="../modern/ads/ad-init.jsp" %>

    <style>
    /* ── Matrix Calculator — page-local styles ────────────────────────
       Single-tool stylesheet inlined here to keep the contract clean:
       one JSP + one JS file, no extra CSS asset.  Uses the math-studio
       custom properties (--ms-accent, --ms-line, --ms-panel-bg, …) so
       it inherits theme tokens automatically.                          */

    .mc-stack { display: flex; flex-direction: column; gap: 1.25rem; }

    /* Operation chip rail — one row that scrolls horizontally on mobile.
       Active chip carries the accent fill; pressed state for keyboard
       a11y. */
    .mc-op-rail {
        display: flex;
        flex-wrap: wrap;
        gap: 0.45rem;
        padding: 0.85rem;
        background: var(--ms-panel-bg, #fff);
        border: 1px solid var(--ms-line, #e2e8f0);
        border-radius: 14px;
        box-shadow: var(--ms-shadow, 0 1px 3px rgba(0,0,0,0.05));
    }
    .mc-op-chip {
        appearance: none;
        border: 1px solid var(--ms-line-strong, #cbd5e1);
        background: var(--ms-panel-bg-soft, #f8fafc);
        color: var(--ms-ink, #0f172a);
        font: 500 0.82rem/1 var(--ms-font, system-ui);
        padding: 0.5rem 0.85rem;
        border-radius: 9999px;
        cursor: pointer;
        transition: all 0.15s;
        white-space: nowrap;
    }
    .mc-op-chip:hover { border-color: var(--ms-accent, #15803d); color: var(--ms-accent, #15803d); }
    .mc-op-chip.active {
        background: var(--ms-accent, #15803d);
        border-color: var(--ms-accent, #15803d);
        color: #fff;
        box-shadow: 0 1px 4px rgba(21, 128, 61, 0.25);
    }

    /* Matrix card — wraps the math-field plus its toolbar (size picker,
       reset, random). */
    .mc-card {
        background: var(--ms-panel-bg, #fff);
        border: 1px solid var(--ms-line, #e2e8f0);
        border-radius: 14px;
        padding: 1rem 1.15rem;
        box-shadow: var(--ms-shadow, 0 1px 3px rgba(0,0,0,0.05));
    }
    .mc-card-head {
        display: flex; align-items: center; justify-content: space-between;
        gap: 0.65rem; margin-bottom: 0.75rem; flex-wrap: wrap;
    }
    .mc-card-title { font-weight: 600; font-size: 0.95rem; color: var(--ms-ink, #0f172a); }
    .mc-card-tools { display: flex; gap: 0.45rem; align-items: center; flex-wrap: wrap; }

    .mc-size-picker {
        font: 500 0.78rem/1 var(--ms-font-mono, monospace);
        padding: 0.35rem 0.55rem;
        border: 1px solid var(--ms-line-strong, #cbd5e1);
        border-radius: 6px;
        background: var(--ms-panel-bg, #fff);
        color: var(--ms-ink, #0f172a);
        cursor: pointer;
    }
    .mc-icon-btn {
        appearance: none;
        border: 1px solid var(--ms-line-strong, #cbd5e1);
        background: var(--ms-panel-bg, #fff);
        color: var(--ms-ink-soft, #475569);
        padding: 0.35rem 0.7rem;
        border-radius: 6px;
        font-size: 0.78rem;
        cursor: pointer;
    }
    .mc-icon-btn:hover { border-color: var(--ms-accent, #15803d); color: var(--ms-accent, #15803d); }

    /* Matrix math-field — taller than scalar inputs so multi-row
       matrices render comfortably.  Subtle focus ring matches the
       site accent. */
    .mc-mathfield {
        display: block;
        width: 100%;
        min-height: 90px;
        padding: 0.7rem 1rem;
        font-size: 1.15rem;
        border: 1.5px solid var(--ms-line-strong, #cbd5e1);
        border-radius: 10px;
        background: var(--ms-panel-bg-soft, #fafafa);
        color: var(--ms-ink, #0f172a);
        transition: border-color 0.15s, box-shadow 0.15s, background 0.15s;
    }
    .mc-mathfield:focus-within {
        outline: none;
        border-color: var(--ms-accent, #15803d);
        background: var(--ms-panel-bg, #fff);
        box-shadow: 0 0 0 3px rgba(21, 128, 61, 0.12);
    }
    [data-theme="dark"] .mc-mathfield {
        background: var(--bg-secondary, #1e293b);
        border-color: var(--border, #334155);
        color: var(--text-primary, #f1f5f9);
    }

    /* Calculate button — primary CTA pill, matches limit/integral. */
    .mc-cta-row {
        display: flex; align-items: center; gap: 0.85rem; flex-wrap: wrap;
        padding: 0.5rem 0;
    }
    .mc-cta {
        appearance: none;
        background: var(--ms-cta-start, #15803d);
        background: linear-gradient(135deg, var(--ms-cta-start, #15803d), var(--ms-cta-end, #16a34a));
        color: #fff;
        border: none;
        font: 600 0.95rem/1 var(--ms-font, system-ui);
        padding: 0.85rem 1.6rem;
        border-radius: 9999px;
        cursor: pointer;
        transition: transform 0.1s, box-shadow 0.15s;
        box-shadow: 0 1px 3px rgba(21, 128, 61, 0.3);
    }
    .mc-cta:hover { transform: translateY(-1px); box-shadow: 0 4px 10px rgba(21, 128, 61, 0.35); }
    .mc-cta.is-busy { opacity: 0.65; cursor: progress; pointer-events: none; }
    .mc-cta.is-busy::after {
        content: ''; display: inline-block; margin-left: 0.5rem;
        width: 12px; height: 12px;
        border: 2px solid rgba(255,255,255,0.4); border-top-color: #fff;
        border-radius: 50%; animation: mc-spin 0.7s linear infinite;
        vertical-align: middle;
    }
    @keyframes mc-spin { to { transform: rotate(360deg); } }

    .mc-warn {
        display: none;
        font-size: 0.82rem;
        color: #b45309;
        background: #fef3c7;
        border: 1px solid #fcd34d;
        padding: 0.45rem 0.75rem;
        border-radius: 8px;
    }
    .mc-warn.show { display: inline-block; }

    /* Practice Worksheet CTA — subtle ghost button so it sits a tier
       below the primary green Calculate button visually.  Same row
       layout for the helper hint text. */
    .mc-worksheet-row {
        display: flex; align-items: center; gap: 0.85rem; flex-wrap: wrap;
        padding: 0.4rem 0;
    }
    .mc-worksheet-cta {
        appearance: none;
        background: var(--ms-panel-bg, #fff);
        color: var(--ms-accent, #15803d);
        border: 1.5px solid var(--ms-accent, #15803d);
        font: 600 0.88rem/1 var(--ms-font, system-ui);
        padding: 0.7rem 1.2rem;
        border-radius: 9999px;
        cursor: pointer;
        transition: background 0.15s, color 0.15s, transform 0.1s;
    }
    .mc-worksheet-cta:hover {
        background: var(--ms-accent, #15803d);
        color: #fff;
        transform: translateY(-1px);
    }
    .mc-worksheet-hint {
        font-size: 0.78rem;
        color: var(--ms-muted, #94a3b8);
    }

    /* Exponent input — small, inline, only visible for A^n. */
    .mc-exp-row {
        display: flex; align-items: center; gap: 0.65rem;
        padding: 0.7rem 1rem;
        background: var(--ms-panel-bg-soft, #f8fafc);
        border: 1px solid var(--ms-line, #e2e8f0);
        border-radius: 10px;
    }
    .mc-exp-row label { font-weight: 600; font-size: 0.88rem; }
    .mc-exp-row input {
        width: 6em; font: 500 0.92rem/1 var(--ms-font-mono, monospace);
        padding: 0.5rem 0.7rem;
        border: 1px solid var(--ms-line-strong, #cbd5e1);
        border-radius: 6px;
        background: var(--ms-panel-bg, #fff);
        color: var(--ms-ink, #0f172a);
    }

    /* Examples band — collapsible, chip grid. */
    .mc-examples-card { padding: 0.85rem 1rem; }
    .mc-examples-summary {
        cursor: pointer; font-weight: 600; font-size: 0.9rem;
        list-style: none; display: flex; align-items: center; gap: 0.4rem;
        color: var(--ms-ink, #0f172a);
    }
    .mc-examples-summary::-webkit-details-marker { display: none; }
    .mc-examples-summary::before {
        content: '\25B8'; transition: transform 0.15s;
    }
    .mc-examples-card[open] .mc-examples-summary::before { transform: rotate(90deg); }
    .mc-examples-grid {
        display: flex; flex-wrap: wrap; gap: 0.4rem; margin-top: 0.6rem;
    }
    .mc-example-chip {
        appearance: none;
        background: var(--ms-panel-bg-soft, #f8fafc);
        border: 1px solid var(--ms-line, #e2e8f0);
        color: var(--ms-ink-soft, #475569);
        font: 500 0.78rem/1 var(--ms-font, system-ui);
        padding: 0.4rem 0.75rem;
        border-radius: 9999px;
        cursor: pointer;
    }
    .mc-example-chip:hover { border-color: var(--ms-accent, #15803d); color: var(--ms-accent, #15803d); }

    /* Output card — Result / Steps / Python tabs. */
    .mc-output-tabs {
        display: flex; gap: 0.5rem; padding: 0.5rem 0.85rem 0;
        background: var(--ms-panel-bg, #fff);
        border: 1px solid var(--ms-line, #e2e8f0);
        border-bottom: none;
        border-radius: 14px 14px 0 0;
    }
    .mc-output-tab {
        appearance: none; background: transparent; border: none;
        font: 500 0.85rem/1 var(--ms-font, system-ui);
        color: var(--ms-ink-soft, #475569);
        padding: 0.65rem 1rem; cursor: pointer;
        border-bottom: 2px solid transparent;
        border-radius: 6px 6px 0 0;
    }
    .mc-output-tab:hover { color: var(--ms-accent, #15803d); }
    .mc-output-tab.active {
        color: var(--ms-accent, #15803d);
        border-bottom-color: var(--ms-accent, #15803d);
        font-weight: 600;
    }
    .mc-panel {
        display: none;
        background: var(--ms-panel-bg, #fff);
        border: 1px solid var(--ms-line, #e2e8f0);
        border-top: none;
        border-radius: 0 0 14px 14px;
        padding: 1.25rem;
        min-height: 220px;
    }
    .mc-panel.active { display: block; }

    .mc-empty { color: var(--ms-muted, #94a3b8); font-size: 0.9rem; text-align: center; padding: 1.5rem 0; }
    .mc-error { color: #b91c1c; background: #fee2e2; border: 1px solid #fca5a5;
                padding: 0.7rem 0.95rem; border-radius: 8px; font-size: 0.88rem; }
    .mc-spinner {
        margin: 1.5rem auto;
        width: 28px; height: 28px;
        border: 3px solid var(--ms-line, #e2e8f0); border-top-color: var(--ms-accent, #15803d);
        border-radius: 50%; animation: mc-spin 0.8s linear infinite;
    }

    .mc-result-tex { font-size: 1.1rem; padding: 0.5rem 0; overflow-x: auto; }
    .mc-result-text { font: 500 0.78rem/1.5 var(--ms-font-mono, monospace);
                      color: var(--ms-ink-soft, #475569);
                      background: var(--ms-panel-bg-soft, #f8fafc);
                      padding: 0.55rem 0.75rem; border-radius: 6px;
                      margin: 0.65rem 0; word-break: break-word; }
    .mc-result-actions { display: flex; gap: 0.5rem; flex-wrap: wrap; margin-top: 0.6rem; }
    .mc-action-btn {
        appearance: none;
        border: 1px solid var(--ms-line-strong, #cbd5e1);
        background: transparent; color: var(--ms-ink, #0f172a);
        font: 500 0.78rem/1 var(--ms-font, system-ui);
        padding: 0.45rem 0.85rem; border-radius: 9999px; cursor: pointer;
    }
    .mc-action-btn:hover { border-color: var(--ms-accent, #15803d); color: var(--ms-accent, #15803d); }

    .mc-steps { list-style: none; counter-reset: step; padding: 0; margin: 0; }
    .mc-step { counter-increment: step;
               border-left: 3px solid var(--ms-accent, #15803d);
               padding: 0.5rem 0.95rem 0.7rem; margin-bottom: 0.85rem;
               background: var(--ms-panel-bg-soft, #f8fafc);
               border-radius: 0 8px 8px 0; }
    .mc-step-title { font-weight: 600; font-size: 0.85rem; color: var(--ms-ink, #0f172a); margin-bottom: 0.35rem; }
    .mc-step-title::before { content: 'Step ' counter(step) ' \2014 '; color: var(--ms-accent, #15803d); }
    .mc-step-tex { font-size: 1rem; padding: 0.3rem 0; overflow-x: auto; }

    /* Visualize panel — Plotly chart container.  Plotly needs explicit
       height to render; width is responsive. */
    .mc-viz-container { width: 100%; height: 520px; min-height: 360px; }
    .mc-viz-caption {
        font-size: 0.85rem; color: var(--ms-ink-soft, #475569);
        background: var(--ms-panel-bg-soft, #f8fafc);
        border-left: 3px solid var(--ms-accent, #15803d);
        padding: 0.55rem 0.85rem; border-radius: 0 6px 6px 0;
        margin-bottom: 0.85rem;
    }
    .mc-viz-na {
        text-align: center; color: var(--ms-muted, #94a3b8);
        padding: 2.5rem 1rem; font-size: 0.9rem; line-height: 1.6;
    }
    .mc-viz-na strong { color: var(--ms-ink, #0f172a); }

    /* Mobile tweaks. */
    @media (max-width: 640px) {
        .mc-mathfield { font-size: 1rem; min-height: 80px; }
        .mc-op-rail { padding: 0.6rem; gap: 0.35rem; }
        .mc-op-chip { padding: 0.4rem 0.7rem; font-size: 0.78rem; }
        .mc-cta { width: 100%; justify-content: center; text-align: center; }
    }
    </style>
</head>
<body class="ms-body">

    <%@ include file="../modern/components/nav-header.jsp" %>

    <jsp:include page="/math/partials/matter-bg.jsp" />

    <div class="ms-hero">
        <%@ include file="../modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="ms-main">

        <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
            &#9776; Math tools
        </button>

        <% request.setAttribute("activeService", "matrix"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Matrix</span>
                </nav>
                <h1>Matrix Calculator</h1>
                <p class="ms-tag" style="color:var(--ms-muted);font-size:0.92rem;margin-top:0.4rem;">
                    13 operations on one page. Determinant, inverse, eigenvalues, multiplication, and more &mdash; with step-by-step solutions.
                </p>
            </header>

            <div class="mc-stack">

                <!-- ═══ OPERATION CHIPS ═══ -->
                <div class="mc-op-rail" role="toolbar" aria-label="Matrix operations">
                    <button type="button" class="mc-op-chip" data-op="determinant"  aria-pressed="false">det A</button>
                    <button type="button" class="mc-op-chip" data-op="inverse"      aria-pressed="false">A&#8315;&#185;</button>
                    <button type="button" class="mc-op-chip" data-op="transpose"    aria-pressed="false">A&#7488;</button>
                    <button type="button" class="mc-op-chip" data-op="trace"        aria-pressed="false">tr A</button>
                    <button type="button" class="mc-op-chip" data-op="rank"         aria-pressed="false">rank A</button>
                    <button type="button" class="mc-op-chip" data-op="rref"         aria-pressed="false">RREF</button>
                    <button type="button" class="mc-op-chip" data-op="power"        aria-pressed="false">A&#8319;</button>
                    <button type="button" class="mc-op-chip" data-op="eigenvalues"  aria-pressed="false">eigenvalues</button>
                    <button type="button" class="mc-op-chip" data-op="eigenvectors" aria-pressed="false">eigenvectors</button>
                    <button type="button" class="mc-op-chip" data-op="charpoly"     aria-pressed="false">char. poly</button>
                    <button type="button" class="mc-op-chip" data-op="add"          aria-pressed="false">A + B</button>
                    <button type="button" class="mc-op-chip" data-op="subtract"     aria-pressed="false">A &minus; B</button>
                    <button type="button" class="mc-op-chip" data-op="multiply"     aria-pressed="false">A &middot; B</button>
                </div>

                <!-- ═══ MATRIX A ═══ -->
                <div class="mc-card">
                    <div class="mc-card-head">
                        <div class="mc-card-title">Matrix A</div>
                        <div class="mc-card-tools">
                            <select class="mc-size-picker" id="mc-size-a" aria-label="Matrix A size">
                                <option value="2x2">2&times;2</option>
                                <option value="3x3" selected>3&times;3</option>
                                <option value="4x4">4&times;4</option>
                                <option value="5x5">5&times;5</option>
                                <option value="6x6">6&times;6</option>
                                <option value="2x3">2&times;3</option>
                                <option value="3x2">3&times;2</option>
                                <option value="2x4">2&times;4</option>
                                <option value="4x2">4&times;2</option>
                                <option value="3x4">3&times;4</option>
                                <option value="4x3">4&times;3</option>
                            </select>
                            <button type="button" class="mc-icon-btn" id="mc-reset-a" title="Reset to zeros">&#8634; Reset</button>
                            <button type="button" class="mc-icon-btn" id="mc-random-a" title="Fill with random integers">&#127922; Random</button>
                            <button type="button" class="mc-icon-btn" id="mc-scan-btn" title="Scan a matrix problem from image or PDF" style="border-color:var(--ms-accent,#15803d);color:var(--ms-accent,#15803d);">&#128247; Scan</button>
                            <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — matrix tutor + solver in chat (Ctrl+Shift+A)">&#10024; AI</button>
                        </div>
                    </div>
                    <math-field id="mc-matrix-a" class="mc-mathfield"
                                aria-label="Matrix A"
                                math-virtual-keyboard-policy="manual"
                                smart-mode="off" smart-fence="off"></math-field>
                </div>

                <!-- ═══ MATRIX B (visible only for binary ops) ═══ -->
                <div class="mc-card" id="mc-wrap-b" style="display:none;">
                    <div class="mc-card-head">
                        <div class="mc-card-title">Matrix B</div>
                        <div class="mc-card-tools">
                            <select class="mc-size-picker" id="mc-size-b" aria-label="Matrix B size">
                                <option value="2x2">2&times;2</option>
                                <option value="3x3" selected>3&times;3</option>
                                <option value="4x4">4&times;4</option>
                                <option value="5x5">5&times;5</option>
                                <option value="6x6">6&times;6</option>
                                <option value="2x3">2&times;3</option>
                                <option value="3x2">3&times;2</option>
                                <option value="2x4">2&times;4</option>
                                <option value="4x2">4&times;2</option>
                                <option value="3x4">3&times;4</option>
                                <option value="4x3">4&times;3</option>
                            </select>
                            <button type="button" class="mc-icon-btn" id="mc-reset-b" title="Reset to zeros">&#8634; Reset</button>
                            <button type="button" class="mc-icon-btn" id="mc-random-b" title="Fill with random integers">&#127922; Random</button>
                        </div>
                    </div>
                    <math-field id="mc-matrix-b" class="mc-mathfield"
                                aria-label="Matrix B"
                                math-virtual-keyboard-policy="manual"
                                smart-mode="off" smart-fence="off"></math-field>
                </div>

                <!-- ═══ EXPONENT (visible only for A^n) ═══ -->
                <div class="mc-exp-row" id="mc-wrap-exp" style="display:none;">
                    <label for="mc-exponent">Exponent <em>n</em> =</label>
                    <input type="number" id="mc-exponent" value="2" step="1">
                    <span style="font-size:0.78rem;color:var(--ms-muted,#94a3b8);">Integer; negative powers require an invertible matrix.</span>
                </div>

                <!-- ═══ CALCULATE ═══ -->
                <div class="mc-cta-row">
                    <button type="button" id="mc-calculate-btn" class="mc-cta">Calculate</button>
                    <span id="mc-warn" class="mc-warn" role="alert" aria-live="polite"></span>
                </div>

                <!-- ═══ PRACTICE WORKSHEET CTA ═══
                     Opens WorksheetEngine modal backed by
                     /worksheet/math/linear-algebra/matrices.json (2,000+ problems
                     across 48 question types, generated by generate_matrices.py). -->
                <div class="mc-worksheet-row">
                    <button type="button" id="mc-worksheet-btn" class="mc-worksheet-cta">
                        &#128221; Practice Matrix Worksheet &mdash; 2,000+ problems
                    </button>
                    <span class="mc-worksheet-hint">Filter by op &amp; difficulty &middot; printable PDF &middot; full answer key</span>
                </div>

                <!-- ═══ EXAMPLES ═══ -->
                <details class="mc-card mc-examples-card">
                    <summary class="mc-examples-summary">Examples &mdash; click to load</summary>
                    <div class="mc-examples-grid">
                        <button type="button" class="mc-example-chip" data-preset='{"op":"determinant","size_a":"3x3","matrix_a":"\\begin{pmatrix}1 & 2 & 3\\\\4 & 5 & 6\\\\7 & 8 & 10\\end{pmatrix}"}'>det 3&times;3</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"determinant","size_a":"2x2","matrix_a":"\\begin{pmatrix}3 & 8\\\\4 & 6\\end{pmatrix}"}'>det 2&times;2</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"inverse","size_a":"3x3","matrix_a":"\\begin{pmatrix}1 & 2 & 3\\\\0 & 1 & 4\\\\5 & 6 & 0\\end{pmatrix}"}'>inverse 3&times;3</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"inverse","size_a":"2x2","matrix_a":"\\begin{pmatrix}4 & 7\\\\2 & 6\\end{pmatrix}"}'>inverse 2&times;2</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"transpose","size_a":"3x4","matrix_a":"\\begin{pmatrix}1 & 2 & 3 & 4\\\\5 & 6 & 7 & 8\\\\9 & 10 & 11 & 12\\end{pmatrix}"}'>transpose 3&times;4</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"trace","size_a":"3x3","matrix_a":"\\begin{pmatrix}5 & 1 & 0\\\\2 & 3 & 1\\\\0 & 4 & 7\\end{pmatrix}"}'>trace</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"rank","size_a":"3x4","matrix_a":"\\begin{pmatrix}1 & 2 & 1 & 4\\\\2 & 4 & 3 & 7\\\\3 & 6 & 4 & 11\\end{pmatrix}"}'>rank 3&times;4</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"rref","size_a":"3x4","matrix_a":"\\begin{pmatrix}1 & 2 & -1 & -4\\\\2 & 3 & -1 & -11\\\\-2 & 0 & -3 & 22\\end{pmatrix}"}'>RREF</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"power","size_a":"2x2","matrix_a":"\\begin{pmatrix}1 & 1\\\\1 & 0\\end{pmatrix}","n":5}'>Fibonacci A&#8309;</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"eigenvalues","size_a":"2x2","matrix_a":"\\begin{pmatrix}6 & -1\\\\2 & 3\\end{pmatrix}"}'>eigenvalues 2&times;2</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"eigenvectors","size_a":"2x2","matrix_a":"\\begin{pmatrix}4 & 1\\\\2 & 3\\end{pmatrix}"}'>eigenvectors</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"charpoly","size_a":"3x3","matrix_a":"\\begin{pmatrix}1 & 2 & 0\\\\0 & 1 & 1\\\\1 & 0 & 1\\end{pmatrix}"}'>char. poly 3&times;3</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"add","size_a":"2x2","size_b":"2x2","matrix_a":"\\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}","matrix_b":"\\begin{pmatrix}5 & 6\\\\7 & 8\\end{pmatrix}"}'>A + B 2&times;2</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"subtract","size_a":"2x2","size_b":"2x2","matrix_a":"\\begin{pmatrix}9 & 8\\\\7 & 6\\end{pmatrix}","matrix_b":"\\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}"}'>A &minus; B</button>
                        <button type="button" class="mc-example-chip" data-preset='{"op":"multiply","size_a":"2x3","size_b":"3x2","matrix_a":"\\begin{pmatrix}1 & 2 & 3\\\\4 & 5 & 6\\end{pmatrix}","matrix_b":"\\begin{pmatrix}7 & 8\\\\9 & 10\\\\11 & 12\\end{pmatrix}"}'>A&middot;B (2&times;3)(3&times;2)</button>
                    </div>
                </details>

                <!-- ═══ OUTPUT ═══ -->
                <div>
                    <div class="mc-output-tabs" role="tablist">
                        <button type="button" class="mc-output-tab active" data-panel="result"    role="tab" aria-selected="true">Result</button>
                        <button type="button" class="mc-output-tab"        data-panel="steps"     role="tab" aria-selected="false">Steps</button>
                        <button type="button" class="mc-output-tab"        data-panel="visualize" role="tab" aria-selected="false">Visualize</button>
                        <button type="button" class="mc-output-tab"        data-panel="python"    role="tab" aria-selected="false">Python</button>
                    </div>
                    <div class="mc-panel active" data-panel="result" role="tabpanel">
                        <div id="mc-result-content"><div class="mc-empty">Pick an operation, enter a matrix, and click Calculate.</div></div>
                    </div>
                    <div class="mc-panel" data-panel="steps" role="tabpanel">
                        <div id="mc-steps-content"><div class="mc-empty">Steps appear here after you Calculate.</div></div>
                    </div>
                    <div class="mc-panel" data-panel="visualize" role="tabpanel">
                        <div id="mc-viz-content">
                            <div class="mc-viz-na">
                                <strong>Geometric overlay</strong> appears here after you Calculate &mdash;
                                shown for <strong>2&times;2 and 3&times;3 numeric matrices</strong> on operations
                                with a clean geometric interpretation (det, inverse, transpose, eigenvectors, power, A&middot;B, A+B, A&minus;B).
                            </div>
                        </div>
                    </div>
                    <div class="mc-panel" data-panel="python" role="tabpanel">
                        <iframe id="mc-compiler-iframe" loading="lazy"
                                style="width:100%;height:520px;border:none;border-radius:8px;"
                                title="Python (SymPy) compiler"></iframe>
                    </div>
                </div>
            </div>

            <!-- In-content ad (mobile/tablet). -->
            <div class="ms-inline-ad">
                <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- ═══ BELOW-FOLD EDUCATIONAL CONTENT ═══ -->
            <section class="tool-expertise-section" style="margin:2rem 0;">

                <div class="mc-card" style="padding:1.5rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.6rem;">What is a matrix?</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);">
                        A <strong>matrix</strong> is a rectangular grid of numbers (or symbolic expressions) arranged in rows and columns.
                        Matrices are the fundamental object of <em>linear algebra</em> &mdash; they encode systems of equations, linear
                        transformations, rotations, projections, networks, and the state of physical systems. Almost every numerical
                        computation in science, engineering, machine learning, and computer graphics is, at some level, a matrix
                        operation.
                    </p>
                </div>

                <div class="mc-card" style="padding:1.5rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.6rem;">The 13 operations on this page</h2>
                    <table style="width:100%;border-collapse:collapse;font-size:0.85rem;margin-top:0.6rem;">
                        <thead>
                            <tr style="background:var(--ms-panel-bg-soft,#f8fafc);">
                                <th style="text-align:left;padding:0.5rem 0.75rem;border-bottom:1px solid var(--ms-line);">Operation</th>
                                <th style="text-align:left;padding:0.5rem 0.75rem;border-bottom:1px solid var(--ms-line);">Input shape</th>
                                <th style="text-align:left;padding:0.5rem 0.75rem;border-bottom:1px solid var(--ms-line);">Output</th>
                                <th style="text-align:left;padding:0.5rem 0.75rem;border-bottom:1px solid var(--ms-line);">Method shown in steps</th>
                            </tr>
                        </thead>
                        <tbody style="color:var(--ms-ink-soft,#475569);">
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">det A</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">square</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">scalar</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">cofactor expansion (row 1)</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">A&#8315;&#185;</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">square &amp; non-singular</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">matrix</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">adjugate (n&le;3) / Gauss-Jordan (n&ge;4)</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">A&#7488;</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">any</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">matrix</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">swap rows &harr; columns</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">tr A</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">square</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">scalar</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">sum of main diagonal</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">rank A</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">any</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">integer</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);"># of pivot columns in RREF</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">RREF</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">any</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">matrix</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">Gauss-Jordan elimination</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">A&#8319;</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">square (invertible if n&lt;0)</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">matrix</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">repeated multiplication</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">eigenvalues</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">square</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">list</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">det(A&minus;&lambda;I)=0 &rarr; solve</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">eigenvectors</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">square</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">vectors</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">solve (A&minus;&lambda;I)v=0 per &lambda;</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">char. poly</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">square</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">polynomial</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">det(A&minus;&lambda;I) expanded</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">A + B / A &minus; B</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">same shape</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">matrix</td><td style="padding:0.45rem 0.75rem;border-bottom:1px solid var(--ms-line);">element-wise</td></tr>
                            <tr><td style="padding:0.45rem 0.75rem;">A &middot; B</td><td style="padding:0.45rem 0.75rem;">A.cols = B.rows</td><td style="padding:0.45rem 0.75rem;">matrix</td><td style="padding:0.45rem 0.75rem;">row-by-column dot products</td></tr>
                        </tbody>
                    </table>
                </div>

                <div class="mc-card" style="padding:1.5rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">Identities worth memorising</h2>
                    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:0.75rem;">
                        <div style="border-left:3px solid var(--ms-accent,#15803d);padding:0.7rem 1rem;background:var(--ms-panel-bg-soft,#f8fafc);border-radius:0 8px 8px 0;">
                            <strong>(AB)<sup>T</sup> = B<sup>T</sup>A<sup>T</sup></strong>
                            <p style="margin:0.25rem 0 0;font-size:0.82rem;color:var(--ms-ink-soft,#475569);">Transpose reverses order.</p>
                        </div>
                        <div style="border-left:3px solid var(--ms-accent,#15803d);padding:0.7rem 1rem;background:var(--ms-panel-bg-soft,#f8fafc);border-radius:0 8px 8px 0;">
                            <strong>(AB)<sup>&minus;1</sup> = B<sup>&minus;1</sup>A<sup>&minus;1</sup></strong>
                            <p style="margin:0.25rem 0 0;font-size:0.82rem;color:var(--ms-ink-soft,#475569);">Inverse reverses order too.</p>
                        </div>
                        <div style="border-left:3px solid var(--ms-accent,#15803d);padding:0.7rem 1rem;background:var(--ms-panel-bg-soft,#f8fafc);border-radius:0 8px 8px 0;">
                            <strong>det(AB) = det(A) det(B)</strong>
                            <p style="margin:0.25rem 0 0;font-size:0.82rem;color:var(--ms-ink-soft,#475569);">Determinant is multiplicative.</p>
                        </div>
                        <div style="border-left:3px solid var(--ms-accent,#15803d);padding:0.7rem 1rem;background:var(--ms-panel-bg-soft,#f8fafc);border-radius:0 8px 8px 0;">
                            <strong>tr(A + B) = tr(A) + tr(B)</strong>
                            <p style="margin:0.25rem 0 0;font-size:0.82rem;color:var(--ms-ink-soft,#475569);">Trace is linear.</p>
                        </div>
                        <div style="border-left:3px solid var(--ms-accent,#15803d);padding:0.7rem 1rem;background:var(--ms-panel-bg-soft,#f8fafc);border-radius:0 8px 8px 0;">
                            <strong>tr(AB) = tr(BA)</strong>
                            <p style="margin:0.25rem 0 0;font-size:0.82rem;color:var(--ms-ink-soft,#475569);">Cyclic property of trace.</p>
                        </div>
                        <div style="border-left:3px solid var(--ms-accent,#15803d);padding:0.7rem 1rem;background:var(--ms-panel-bg-soft,#f8fafc);border-radius:0 8px 8px 0;">
                            <strong>det(A<sup>T</sup>) = det(A)</strong>
                            <p style="margin:0.25rem 0 0;font-size:0.82rem;color:var(--ms-ink-soft,#475569);">Transpose preserves determinant.</p>
                        </div>
                        <div style="border-left:3px solid var(--ms-accent,#15803d);padding:0.7rem 1rem;background:var(--ms-panel-bg-soft,#f8fafc);border-radius:0 8px 8px 0;">
                            <strong>A invertible &iff; det(A) &ne; 0</strong>
                            <p style="margin:0.25rem 0 0;font-size:0.82rem;color:var(--ms-ink-soft,#475569);">Singular matrices have no inverse.</p>
                        </div>
                        <div style="border-left:3px solid var(--ms-accent,#15803d);padding:0.7rem 1rem;background:var(--ms-panel-bg-soft,#f8fafc);border-radius:0 8px 8px 0;">
                            <strong>tr(A) = &Sigma; &lambda;<sub>i</sub></strong>
                            <p style="margin:0.25rem 0 0;font-size:0.82rem;color:var(--ms-ink-soft,#475569);">Sum of eigenvalues.</p>
                        </div>
                    </div>
                </div>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="../modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="../modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- ═══ VISIBLE FAQ (mirrors faqNq/faqNa params above) ═══ -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Matrix calculator FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can I scan a matrix problem from a photo?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Click the green <strong>&#128247; Scan</strong> button next to Matrix A, upload a photo or PDF of your homework, and our AI extracts every matrix problem from the page and tells you the operation (determinant, inverse, eigenvalues, A&middot;B, etc.). Pick one to fill the form and solve, or click <strong>Solve All</strong> to batch-solve every problem in the image with full step-by-step solutions for each. Works on textbook pages, exam papers, and handwritten work.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What matrix operations does this calculator support?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Thirteen operations on a single page: <strong>determinant, inverse, transpose, trace, rank, RREF (Gauss-Jordan), eigenvalues, eigenvectors, characteristic polynomial, matrix power A<sup>n</sup>, addition A+B, subtraction A&minus;B, and multiplication A&middot;B</strong>. Switch operations with one click; your matrix persists across switches. Up to <strong>8&times;8</strong> plus rectangular shapes (2&times;3, 3&times;4, 4&times;2&hellip;) where the operation supports them.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do I enter a matrix? Can I type Symbolab-style expressions?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Three ways: (1) <strong>Visual matrix editor</strong> &mdash; pick a size and a fresh grid appears; <strong>Tab</strong> and arrow keys move between cells. Integers, fractions like <em>1/2</em>, decimals, symbols (<em>a</em>, <em>x</em>, <em>&theta;</em>), and constants (<em>&pi;</em>, <em>e</em>) all work. (2) <strong>Symbolab-style smart input</strong> &mdash; paste a self-describing expression like <code>\det A</code>, <code>A^{-1}</code>, <code>A^T</code>, <code>A B</code> (juxtaposition for multiply), <code>\tr A</code>, <code>gauss jordan A</code>, <code>eigenvectors A</code> and the calculator auto-detects the operation and switches the chip. (3) <strong>AI photo scan</strong> &mdash; upload an image and the AI extracts the matrix into the editor for you.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What does the Visualize tab show?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">A <strong>geometric overlay</strong> of the matrix as a linear transformation. For 2&times;2 numeric matrices the unit square is drawn in grey and the transformed parallelogram is overlaid in green (or red if <em>det A</em> is negative, indicating orientation flip). For determinants the shaded area equals <em>|det A|</em>. For eigenvectors, coloured arrows mark the directions A leaves invariant. For multiplication you see B applied first, then A applied to the result &mdash; making composition order obvious. For powers <em>A<sup>n</sup></em>, you see successive frames. 3&times;3 numeric matrices show the unit cube and parallelepiped via 3D mesh. Operations like rank, trace, char. polynomial, RREF, and eigenvalues alone are purely algebraic and don&rsquo;t get a visualization.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you calculate the determinant of a matrix step by step?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">For a 2&times;2 matrix &lbrack;&lbrack;a,b&rbrack;,&lbrack;c,d&rbrack;&rbrack; the determinant is <em>ad&minus;bc</em>. For 3&times;3 and larger, this calculator uses <strong>cofactor expansion along the first row</strong>: <em>det(A) = &Sigma;<sub>j</sub> (&minus;1)<sup>1+j</sup> a<sub>1j</sub> M<sub>1j</sub></em>, where <em>M<sub>1j</sub></em> is the minor &mdash; the determinant of the submatrix obtained by deleting row 1 and column <em>j</em>. The <strong>Steps</strong> tab walks through each minor, the signed sum, and the simplification to a single number. The <strong>Visualize</strong> tab shows the geometric meaning: <em>|det A|</em> is the area of the parallelogram (2&times;2) or the volume of the parallelepiped (3&times;3) that A maps the unit square or cube to.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How is the matrix inverse computed step by step?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">For 2&times;2 and 3&times;3 matrices the calculator uses the <strong>adjugate method</strong> shown step by step: compute <em>det(A)</em>, build the cofactor matrix, transpose to get the adjugate <em>adj(A)</em>, then divide every entry by <em>det(A)</em>. The full chain <em>A<sup>&minus;1</sup> = (1/det A) &middot; adj(A)</em> is rendered with LaTeX. For 4&times;4 and larger we use <strong>Gauss-Jordan elimination</strong> on the augmented matrix <em>[A | I]</em>: row-reduce until the left block becomes the identity <em>I</em>, and the right block is <em>A<sup>&minus;1</sup></em>. If the determinant is zero the matrix is singular and the calculator clearly explains that no inverse exists.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you find eigenvalues and eigenvectors with steps?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Eigenvalues solve <em>det(A &minus; &lambda;I) = 0</em>, the <strong>characteristic equation</strong>. The <strong>Steps</strong> tab shows: (1) form <em>A &minus; &lambda;I</em>, (2) compute its determinant as a polynomial in <em>&lambda;</em>, (3) set it to zero and solve for <em>&lambda;</em>. Eigenvectors then come from solving <em>(A &minus; &lambda;I) v = 0</em> for each <em>&lambda;</em> &mdash; the calculator displays <em>(A &minus; &lambda;I)</em>, its row-reduced echelon form, and the basis eigenvectors with algebraic multiplicities. For 2&times;2 numeric cases, the <strong>Visualize</strong> tab draws each eigenvector as a coloured arrow with a dotted arrow showing <em>A&middot;v = &lambda;&middot;v</em> on the same line, demonstrating the invariant-direction property visually.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">When does matrix multiplication A&middot;B work?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a"><em>A&middot;B</em> is defined when the number of <strong>columns of A equals the number of rows of B</strong>. If A is <em>m&times;n</em> and B is <em>n&times;p</em>, then <em>AB</em> is <em>m&times;p</em>. The <em>(i,j)</em> entry of <em>AB</em> is the dot product of row <em>i</em> of A with column <em>j</em> of B: <em>(AB)<sub>ij</sub> = &Sigma;<sub>k</sub> A<sub>ik</sub> B<sub>kj</sub></em>. The calculator validates dimensions before computing (saving you the typo) and, for results up to 3&times;3, shows each entry as an explicit row-by-column dot product. The <strong>Visualize</strong> tab shows AB as the composition of two linear transformations: B is applied first (dashed parallelogram), then A is applied to that result (solid parallelogram), making the order of composition geometrically obvious.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What happens if my matrix is not square or is singular?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The calculator validates each operation before solving and shows a clear inline warning. <strong>Determinant, trace, eigenvalues, eigenvectors, characteristic polynomial, inverse, and power</strong> all require a <strong>square</strong> matrix; non-square inputs are caught immediately. Inverse additionally requires a <strong>non-zero determinant</strong>; if A is singular the warning explains that no inverse exists. RREF, rank, transpose, addition, subtraction, and multiplication work on rectangular matrices subject to their own dimension rules &mdash; A+B and A&minus;B need matching shapes, A&middot;B needs <em>A.cols = B.rows</em>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Is this matrix calculator really free? Any signup or limits?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes &mdash; <strong>100% free, no signup, no daily limits, no paywalls on step-by-step solutions</strong>. You get all 13 operations, AI photo scan, batch solve, geometric visualization, the Python (SymPy) compiler with editable code, and shareable deep-link URLs. Everything runs in your browser; the only server calls are the AI image extraction and the SymPy execution itself, neither of which require an account. Dark mode included.</div>
            </div>
        </div>
    </section>

    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="../modern/components/analytics.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2025 8gwifi.org &mdash; Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%--
        Two-partial load order:
          1. math-libs              — KaTeX, nerdamer, plotly loader, image-to-math, tool-utils, dark-mode, search
          2. inline MathLive ES module
          3. matrix-calculator.js   — the single tool controller
    --%>
    <%@ include file="/modern/components/math-tool-engine-boot.inc.jsp" %>
    <!-- MathLive registers <math-field> as a custom element. -->
    <script type="module">
        import 'https://cdn.jsdelivr.net/npm/mathlive/+esm';
        if (window.MathfieldElement) {
            window.MathfieldElement.fontsDirectory = 'https://cdn.jsdelivr.net/npm/mathlive/dist/fonts';
            try { window.MathfieldElement.soundsDirectory = null; } catch (e) {}
        }
    </script>

    <!-- Context for OneCompiler iframe + Python tab. -->
    <script>window.__MC_CTX = '<%=request.getContextPath()%>';</script>

        <script src="<%=request.getContextPath()%>/modern/js/matrix-calculator.js"></script>

    <!-- Reusable Print Worksheet engine (config modal → KaTeX-rendered
         worksheet overlay → printable PDF).  Same engine the limit /
         integral / derivative / series tools use; matrices.json schema
         is fully compatible (same id/type/difficulty/question_text/
         answer_latex/answer_plain field set). -->
    <script src="<%=request.getContextPath()%>/js/worksheet-engine.js"></script>

    <script>
    // ── Practice Worksheet hook ──
    (function () {
        var btn = document.getElementById('mc-worksheet-btn');
        if (!btn) return;
        btn.addEventListener('click', function () {
            if (typeof WorksheetEngine === 'undefined') {
                alert('Worksheet engine still loading — try again in a moment.');
                return;
            }
            var ctx = (window.__MC_CTX || '');
            WorksheetEngine.open({
                jsonUrl: ctx + '/worksheet/math/linear-algebra/matrices.json',
                title: 'Matrices',
                accentColor: '#15803d',
                branding: '8gwifi.org',
                defaultCount: 20
            });
        });
    })();

    // FAQ accordion
    (function () {
        document.querySelectorAll('.ms-faq-q').forEach(function (q) {
            q.addEventListener('click', function () {
                q.closest('.ms-faq-item').classList.toggle('open');
            });
        });
    })();
    </script>

    <%
        request.setAttribute("mathAiButtonId", "btnMathAI");
        request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
        request.setAttribute("mathAiProfileExport", "configureMatrixMathShell");
    %>
    <%@ include file="../modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
