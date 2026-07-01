<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis());
   request.setAttribute("aiToolId", "math-ai");
   request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        System of Equations Solver — migrated to math-studio shell.

        Architecture:
          · Each equation row is a <math-field> rendered by the legacy core's
            (patched) _makeEqRow. Hidden .sy-eq-input twin per row preserves
            the legacy text-input contract.
          · Method pills carry .sy-method-btn class — core's existing handler
            wires them directly.
          · Solve / worksheet / share / latex buttons keep their sy-* IDs.
          · Empty-state chips call window.SystemsSolverCore.loadExample(eqs).
          · AI image-scan via image-to-math.js + system-of-equations prompt.

        Absorbs linear-equations-solver.jsp (Cloudflare 301 handles redirect).

        SEO ported VERBATIM from legacy (5 FAQ pairs + howToSteps +
        educationalLevel + teaches).
    --%>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="System of Equations Solver — AI Scan &amp; 2,000 Worksheets" />
        <jsp:param name="toolDescription" value="Free system of equations solver with AI photo scan + 2,000 practice problems. Solves 2x2-6x6 linear and nonlinear systems with full steps." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="system-equations-solver.jsp" />
        <jsp:param name="toolKeywords" value="system of equations solver, solve system of equations, simultaneous equations solver, 2x2 system solver, 3x3 system solver, systems of equations step by step, cramer's rule calculator, gaussian elimination calculator, substitution method calculator, nonlinear system solver, linear system solver, solve simultaneous equations online, systems of equations calculator, algebra solver, ai system of equations solver, photo math solver, scan system of equations from photo, ai math homework helper, simultaneous equations photo solver, math problem photo scanner, system of equations worksheet, system of equations worksheet pdf, system of equations worksheet with answers, simultaneous equations worksheet, linear systems practice problems, 3x3 system worksheet, printable system of equations worksheet, system of equations practice problems with answers" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Linear and nonlinear system solving,Step-by-step Cramer's rule with determinants,Gaussian elimination with row operation trace,Substitution method with full algebraic steps,Matrix inversion A-inverse times B,All-methods comparison mode,Interactive graph of intersection curves including 3D for 3x3,Solves up to 6x6 systems via SymPy,AI photo scanner extracts systems from images,2000+ SymPy-verified practice problems with answer key,24 problem types from basic to scholar level,Printable system of equations worksheet,Photo math problem solver,Auto-detect linear vs nonlinear from image,Free with no signup or limits" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="High School, College, AP Precalculus, Linear Algebra" />
        <jsp:param name="teaches" value="Systems of equations, Cramer's rule, Gaussian elimination, matrix inversion, substitution method, nonlinear systems" />
        <jsp:param name="howToSteps" value="Enter your equations|Type each equation naturally, e.g. 2x + 3y = 8 or x^2 + y = 5. Unicode superscripts like x² are also supported.,Choose a method|Select Cramer's Rule, Gaussian Elimination, Substitution, Matrix Inversion, or All Methods to compare all four side by side.,Click Solve System|The solution appears instantly with full step-by-step work and a verification check.,View the graph|Click the Graph tab to see the intersection of the curves plotted automatically." />
        <jsp:param name="faq1q" value="Can this solver handle nonlinear equations like x² + y = 5?" />
        <jsp:param name="faq1a" value="Yes. The solver automatically detects nonlinear equations (containing x^2, xy, sqrt, etc.) and switches to a symbolic substitution engine. It solves for all real intersection points, verifies each solution, and plots the curves on the Graph tab." />
        <jsp:param name="faq2q" value="What is the difference between Cramer's Rule and Gaussian Elimination?" />
        <jsp:param name="faq2a" value="Cramer's Rule computes each variable using determinants: x = det(Ax)/det(A). It gives a clean formula ideal for 2x2 and 3x3 exams but doesn't scale beyond that. Gaussian Elimination applies row operations to the augmented matrix to reach row echelon form, then back-substitutes. It works for any size system and handles the det=0 case where Cramer's Rule fails." />
        <jsp:param name="faq3q" value="What does 'No Unique Solution — determinant is zero' mean?" />
        <jsp:param name="faq3a" value="When det(A) = 0, the system is either inconsistent (parallel lines, no solution) or dependent (same line, infinitely many solutions). Try Gaussian Elimination which identifies which case you have. If you entered a nonlinear equation, make sure Nerdamer loaded — check your browser console for script errors." />
        <jsp:param name="faq4q" value="How do I enter a 3×3 system?" />
        <jsp:param name="faq4a" value="Click the '+ Add equation' button below the equation inputs. Enter three equations with three variables (e.g. x, y, z). The solver automatically detects the 3x3 system and applies your chosen method." />
        <jsp:param name="faq5q" value="Does it show step-by-step work?" />
        <jsp:param name="faq5a" value="Yes — every linear method (Cramer's Rule, Gaussian Elimination, Substitution, Matrix Inversion) shows the complete solution trace: determinant expansions, row operations, substitution steps, and the final answer with verification. For nonlinear systems it shows the substitution path and residual check for each solution." />
        <jsp:param name="faq6q" value="Can I scan a system of equations from a photo or textbook?" />
        <jsp:param name="faq6a" value="Yes. Click the Scan button and upload (or drop in) a photo of handwritten or printed equations. The AI vision model extracts each equation, fills the rows automatically, and detects whether the system is linear or nonlinear. Works on phone snapshots, textbook pages, whiteboard photos, and worksheet scans." />
        <jsp:param name="faq7q" value="Where is the system of equations practice worksheet?" />
        <jsp:param name="faq7a" value="Click the 'Practice Worksheet — 2,000+ systems with answer key' button below the result. The worksheet engine generates printable problem sets across 4 difficulty tiers (basic, medium, hard, scholar) and 24 problem types — 2x2 and 3x3 linear, decimal coefficients, fractional, parameter-dependent, circuit/network-flow word problems, 4x4/5x5/6x6 systems, and more. Every problem and answer is SymPy-verified." />
        <jsp:param name="faq8q" value="What grade levels and curricula does this cover?" />
        <jsp:param name="faq8a" value="The problem set spans Algebra 1 (basic 2x2), Algebra 2 (3x3 and word problems), Precalculus (parameter analysis), AP Precalculus, and college Linear Algebra (4x4-6x6 systems, network flow, multi-parameter). Aligned with Common Core HSA-REI.C and CBSE/ICSE class 9-10 simultaneous equations. SAT, ACT, and JEE practice covered." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.css"></noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>
    <%@ include file="modern/components/math-ai-head.inc.jsp" %>
    <style>
    .ic-expr-label-actions .math-ai-tab-btn {
        display: inline-flex; align-items: center; gap: 0.35rem;
        appearance: none; border: 1px solid var(--ms-accent, #15803d);
        background: var(--ms-panel-bg, #fff); color: var(--ms-accent, #15803d);
        font: 600 0.78rem/1 var(--ms-font, system-ui);
        padding: 0.35rem 0.75rem; border-radius: 6px; cursor: pointer;
    }
    .ic-expr-label-actions .math-ai-tab-btn:hover { background: rgba(21, 128, 61, 0.08); }
    </style>

    <style>
        /* sy-* result rendering classes — the legacy render module emits
           these. Pulled forward and tuned to math-studio tokens. */
        .sy-sym-row {
            display: flex; align-items: center; gap: 0.5rem;
            margin-bottom: 0.6rem;
        }
        .sy-sym-row:last-child { margin-bottom: 0; }
        .sy-sym-num {
            min-width: 1.6rem;
            font-size: 0.78rem; font-weight: 600;
            color: var(--ms-muted, #78716c);
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
        }
        .sy-sym-mathfield {
            flex: 1;
            min-height: 48px;
            padding: 0.6rem 0.85rem;
            font-size: 1.05rem;
            border: 1.5px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius, 14px);
            background: var(--ms-panel-bg-soft, #faf8f4);
            color: var(--ms-ink, #1c1917);
            transition: border-color 200ms, box-shadow 200ms, background 200ms;
        }
        .sy-sym-mathfield:focus-within {
            border-color: var(--ms-accent, #15803d);
            background: var(--ms-panel-bg, #fefdfb);
            box-shadow: var(--ms-ring, 0 0 0 3px rgba(21,128,61,0.22));
        }
        .sy-remove-eq-btn {
            flex-shrink: 0; width: 32px; height: 32px;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: 50%;
            background: transparent;
            color: var(--ms-muted, #78716c);
            font-size: 1.2rem; line-height: 1;
            cursor: pointer;
            transition: background 200ms, color 200ms, border-color 200ms;
        }
        .sy-remove-eq-btn:hover {
            background: rgba(220, 38, 38, 0.08);
            color: #dc2626;
            border-color: #dc2626;
        }
        .sy-add-eq-btn {
            display: inline-flex; align-items: center; gap: 0.4rem;
            padding: 0.45rem 0.85rem;
            font-size: 0.82rem; font-weight: 500;
            border: 1px dashed var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-pill, 999px);
            background: transparent;
            color: var(--ms-ink-soft, #44403c);
            cursor: pointer;
            margin-top: 0.6rem;
            transition: background 200ms, color 200ms, border-color 200ms;
        }
        .sy-add-eq-btn:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            border-color: var(--ms-accent, #15803d);
        }
        .sy-add-eq-btn:disabled {
            opacity: 0.4; cursor: not-allowed;
            background: transparent; color: var(--ms-muted, #78716c);
            border-color: var(--ms-line, rgba(0,0,0,0.08));
        }

        /* Method pill bar */
        .sy-method-bar {
            display: flex; flex-wrap: wrap; gap: 0.35rem;
            padding: 0.4rem 0.5rem;
            background: var(--ms-panel-bg-soft, #faf8f4);
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius, 14px);
            margin: 0.75rem 0;
            align-items: center;
        }
        .sy-method-label {
            font-size: 0.7rem; font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase; letter-spacing: 0.05em;
            margin-right: 0.25rem;
        }
        .sy-method-btn {
            flex: 0 1 auto;
            padding: 0.4rem 0.7rem;
            font-size: 0.78rem; font-weight: 500;
            border: none;
            border-radius: var(--ms-radius-pill, 999px);
            background: transparent;
            color: var(--ms-ink-soft, #44403c);
            cursor: pointer;
            font-family: var(--ms-font-sans, Inter, sans-serif);
            transition: background 200ms, color 200ms;
        }
        .sy-method-btn:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
        }
        .sy-method-btn.active {
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-accent, #15803d);
            box-shadow: 0 1px 2px rgba(0,0,0,0.06);
            font-weight: 600;
        }

        /* Live preview of the system */
        #sy-preview {
            margin: 0.6rem 0 0.4rem;
            padding: 0.8rem 1rem;
            background: var(--ms-panel-bg-soft, #faf8f4);
            border-radius: var(--ms-radius, 14px);
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            font-size: 1.05rem;
            text-align: center;
            overflow-x: auto;
        }

        /* Sys badge (e.g. "2×2 Linear") */
        #sy-sys-badge {
            display: inline-block;
            padding: 0.2rem 0.55rem;
            background: var(--ms-accent-soft, rgba(21,128,61,0.1));
            color: var(--ms-accent, #15803d);
            border-radius: var(--ms-radius-pill, 999px);
            font-size: 0.7rem; font-weight: 600;
            margin-bottom: 0.5rem;
        }

        /* Result section bits the legacy render emits */
        .sy-result-section { padding: 1rem 1.25rem; }
        .sy-steps-hdr {
            display: block; width: 100%;
            padding: 0.55rem 1rem;
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            font-size: 0.8rem; font-weight: 600;
            border: none;
            border-radius: var(--ms-radius-sm, 8px);
            text-align: left;
            cursor: pointer;
            margin-top: 0.75rem;
        }

        /* CTA + Clear row */
        .ic-hero-cta-row .ic-clear-btn {
            padding: 0.5rem 0.9rem;
            font-size: 0.82rem; font-weight: 500;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-pill, 999px);
            background: transparent;
            color: var(--ms-ink-soft, #44403c);
            cursor: pointer;
            font-family: var(--ms-font-sans, Inter, sans-serif);
            transition: background 200ms, color 200ms, border-color 200ms;
        }
        .ic-hero-cta-row .ic-clear-btn:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            border-color: var(--ms-accent, #15803d);
        }

        /* Empty-state chip grid */
        .qs-empty-chips {
            display: grid; grid-template-columns: auto 1fr;
            gap: 0.45rem 0.75rem; align-items: center;
            max-width: 480px; margin: 1rem auto 0; text-align: left;
        }
        .qs-empty-chips .qs-chip-label {
            font-size: 0.72rem; font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase; letter-spacing: 0.05em;
        }
        .qs-empty-chips .ic-example-chip {
            justify-self: start; text-align: left;
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            font-size: 0.85rem;
        }
        .qs-empty-hint {
            color: var(--ms-muted, #78716c);
            font-size: 0.8rem; margin: 1.25rem 0 0; text-align: center;
        }

        /* ───── Result panel rendering — sy-* classes the legacy core
                emits via _buildResultHTML / _buildSympyResultHTML /
                _allMethodsHTML. Tuned to math-studio tokens so the look
                matches integral / quadratic / polynomial result cards. ───── */

        /* System display (the cases environment with the original equations) */
        .sy-system-display {
            background: var(--ms-panel-bg-soft, #faf8f4);
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius, 14px);
            padding: 1rem 1.25rem;
            margin-bottom: 1rem;
            text-align: center;
            font-size: 1.05rem;
            overflow-x: auto;
        }

        /* The "2×2 Linear" / "Nonlinear System" badge above the display */
        #sy-result-content .sy-sys-badge {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            background: var(--ms-accent-soft, rgba(21,128,61,0.1));
            color: var(--ms-accent, #15803d);
            border-radius: var(--ms-radius-pill, 999px);
            font-size: 0.7rem; font-weight: 600;
            margin-bottom: 0.5rem;
            text-transform: uppercase; letter-spacing: 0.05em;
        }
        #sy-result-content .sy-sys-badge.nonlinear {
            background: rgba(99,102,241,0.1);
            color: #6366f1;
        }

        /* Solution badge — green dot + "Unique Solution" / "1 Solution Found" */
        .sy-solution-badge {
            display: inline-flex; align-items: center; gap: 0.4rem;
            padding: 0.35rem 0.75rem;
            background: var(--ms-accent-soft, rgba(21,128,61,0.1));
            color: var(--ms-accent, #15803d);
            border-radius: var(--ms-radius-pill, 999px);
            font-size: 0.78rem; font-weight: 600;
            margin-bottom: 0.75rem;
        }
        .sy-badge-dot {
            width: 8px; height: 8px;
            background: currentColor; border-radius: 50%;
            flex-shrink: 0;
        }

        /* Solution chips — "x = 1.5", "y = 2.3" pills + numerical-approx hint */
        .sy-sol-count {
            font-size: 0.72rem; font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-align: center; margin: 0.75rem 0 0.5rem;
            text-transform: uppercase; letter-spacing: 0.05em;
        }
        .sy-sol-pair {
            display: flex; flex-wrap: wrap; justify-content: center;
            align-items: center;
            gap: 0.4rem 0.75rem;
            padding: 0.85rem 1rem;
            background: var(--ms-panel-bg-soft, #faf8f4);
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius, 14px);
            margin: 0.5rem 0 0.75rem;
        }
        .sy-chip {
            display: inline-block;
            padding: 0.4rem 0.7rem;
            background: var(--ms-panel-bg, #fefdfb);
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-sm, 8px);
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            font-size: 0.95rem;
            color: var(--ms-ink, #1c1917);
        }
        .sy-chip-approx {
            font-size: 0.78rem;
            color: var(--ms-muted, #78716c);
            margin-left: 0.25rem;
        }
        .sy-chips {
            display: flex; flex-wrap: wrap; gap: 0.4rem 0.6rem;
        }

        /* Method label — "Cramer's Rule", "Substitution", "Symbolic CAS" */
        .sy-method-label {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            background: rgba(99,102,241,0.1);
            color: #6366f1;
            border-radius: var(--ms-radius-pill, 999px);
            font-size: 0.7rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.05em;
            margin: 0.5rem 0;
        }
        .sy-method-label.elim    { background: rgba(16,185,129,0.1); color: #10b981; }
        .sy-method-label.subst   { background: rgba(59,130,246,0.1); color: #3b82f6; }
        .sy-method-label.sympy   { background: rgba(139,92,246,0.1); color: #8b5cf6; }

        /* Steps container — wraps the row-reduction trace + method-specific steps */
        .sy-steps-container {
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius, 14px);
            overflow: hidden;
            margin-top: 1rem;
            background: var(--ms-panel-bg, #fefdfb);
        }
        .sy-steps-header {
            padding: 0.65rem 1rem;
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            font-size: 0.78rem; font-weight: 600;
            border-bottom: 1px solid var(--ms-line, rgba(0,0,0,0.08));
        }
        .sy-steps-body {
            padding: 0.5rem 1rem 0.75rem;
            max-height: 0; overflow: hidden;
            transition: max-height 220ms ease-out, padding 220ms ease-out;
        }
        .sy-steps-body.open {
            max-height: 9999px;
            padding: 0.5rem 1rem 0.75rem;
        }

        /* Collapsible "Show Steps" toggle button */
        .sy-steps-hdr {
            display: flex; align-items: center; justify-content: space-between;
            padding: 0.6rem 1rem;
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            font-size: 0.82rem; font-weight: 600;
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius, 14px);
            cursor: pointer;
            width: 100%;
            text-align: left;
            margin-top: 0.75rem;
        }
        .sy-steps-hdr:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.12));
        }
        .sy-steps-hdr.open {
            border-radius: var(--ms-radius, 14px) var(--ms-radius, 14px) 0 0;
            border-bottom: none;
        }

        /* Individual step item */
        .sy-step-item {
            padding: 0.7rem 0;
            border-bottom: 1px solid var(--ms-line, rgba(0,0,0,0.06));
            display: flex; gap: 0.7rem; align-items: flex-start;
        }
        .sy-step-item:last-child { border-bottom: none; }
        .sy-step-num {
            flex-shrink: 0;
            width: 22px; height: 22px;
            border-radius: 50%;
            background: var(--ms-accent, #15803d); color: #fff;
            font-size: 0.7rem; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
        }
        .sy-step-body { flex: 1; min-width: 0; }
        .sy-step-title {
            font-size: 0.78rem; font-weight: 600;
            color: var(--ms-ink-soft, #44403c);
            margin-bottom: 0.3rem;
        }
        .sy-step-math {
            font-size: 0.95rem;
            overflow-x: auto;
            margin-top: 0.2rem;
            padding: 0.2rem 0;
        }
        /* Nonlinear-specific step number — purple to differentiate */
        .sy-nl-step-num {
            flex-shrink: 0;
            width: 22px; height: 22px;
            border-radius: 50%;
            background: #6366f1; color: #fff;
            font-size: 0.7rem; font-weight: 700;
            display: inline-flex; align-items: center; justify-content: center;
            margin-right: 0.5rem;
        }
        .sy-nl-step-title {
            font-size: 0.78rem; font-weight: 600;
            color: var(--ms-ink-soft, #44403c);
            margin-bottom: 0.3rem;
        }

        /* Numerical verification — the "✓ Eq 1: 2x+3y=8" sanity-check rows */
        .sy-verify-section, .sy-verify-card {
            margin-top: 1rem;
            padding: 0.85rem 1rem;
            background: rgba(16,185,129,0.05);
            border: 1px solid rgba(16,185,129,0.2);
            border-radius: var(--ms-radius, 14px);
        }
        .sy-verify-header {
            font-size: 0.78rem; font-weight: 600;
            color: var(--ms-ink-soft, #44403c);
            margin-bottom: 0.5rem;
            display: flex; align-items: center; gap: 0.4rem;
        }
        .sy-verify-num {
            color: #10b981;
            font-size: 1.05rem;
        }
        .sy-verify-pair {
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            font-size: 0.85rem;
            margin-bottom: 0.5rem;
            color: var(--ms-ink-soft, #44403c);
        }
        .sy-verify-row {
            display: flex; align-items: center; gap: 0.5rem;
            font-size: 0.82rem;
            padding: 0.2rem 0;
            color: var(--ms-ink-soft, #44403c);
        }
        .sy-verify-row.sy-verify-ok   > span:first-child { color: #15803d; font-weight: 700; }
        .sy-verify-row.sy-verify-fail > span:first-child { color: #dc2626; font-weight: 700; }
        .sy-verify-code {
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            font-size: 0.82rem;
            background: var(--ms-panel-bg-soft, #faf8f4);
            padding: 0.1rem 0.45rem;
            border-radius: 4px;
            color: var(--ms-ink, #1c1917);
        }

        /* Summary card (used by render module's lightweight summary view) */
        .sy-summary-card {
            background: var(--ms-panel-bg, #fefdfb);
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius, 14px);
            padding: 1rem 1.25rem;
            margin-bottom: 1rem;
        }
        .sy-summary-card-title {
            font-size: 0.72rem; font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase; letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }
        .sy-summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 0.5rem 1rem;
        }
        .sy-summary-result {
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            font-size: 0.95rem;
            color: var(--ms-ink, #1c1917);
            padding: 0.4rem 0.7rem;
            background: var(--ms-panel-bg-soft, #faf8f4);
            border-radius: var(--ms-radius-sm, 8px);
            border-left: 3px solid var(--ms-accent, #15803d);
        }

        /* Warning / status boxes — used by SymPy pending, no-solution, etc. */
        .sy-warn-box {
            padding: 0.85rem 1rem;
            background: rgba(245,158,11,0.08);
            border: 1px solid rgba(245,158,11,0.3);
            border-left: 3px solid #f59e0b;
            border-radius: var(--ms-radius, 14px);
            color: var(--ms-ink, #1c1917);
            font-size: 0.88rem;
            line-height: 1.5;
            margin: 0.75rem 0;
        }
        .sy-warn-box strong { color: var(--ms-ink, #1c1917); }
        .sy-sympy-pending {
            background: var(--ms-panel-bg-soft, #faf8f4);
            border-color: var(--ms-line, rgba(0,0,0,0.08));
            border-left-color: var(--ms-accent, #15803d);
        }
        /* Method-N/A notice (Fix #2) — informational, not a warning */
        .sy-method-notice {
            background: rgba(139,92,246,0.08);
            border-color: rgba(139,92,246,0.3);
            border-left-color: #8b5cf6;
        }
        /* Parameter notice (Fix #4) — purple/indigo accent */
        .sy-param-notice {
            background: rgba(99,102,241,0.08) !important;
            border: 1px solid rgba(99,102,241,0.25) !important;
            border-left: 3px solid #6366f1 !important;
        }
        .sy-param-notice code {
            font-family: var(--ms-font-mono, JetBrains Mono, monospace);
            background: var(--ms-panel-bg, #fefdfb);
            padding: 0.05rem 0.35rem;
            border-radius: 3px;
            color: var(--ms-ink, #1c1917);
            font-size: 0.85em;
        }

        /* Chevron icon used by collapsibles */
        .sy-chev {
            transition: transform 220ms ease;
            width: 14px; height: 14px;
            flex-shrink: 0;
        }
        .sy-chev.open { transform: rotate(180deg); }

        /* Spacing between consecutive sy-* sections inside the result panel */
        #sy-result-content > * + * { margin-top: 0.5rem; }
        #sy-result-content .sy-system-display + * { margin-top: 0.75rem; }
    </style>
</head>
<body class="ms-body">

    <%@ include file="modern/components/nav-header.jsp" %>

    <jsp:include page="/math/partials/matter-bg.jsp" />

    <div class="ms-hero">
        <%@ include file="modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="ms-main">

        <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
            &#9776; Math tools
        </button>

        <% request.setAttribute("activeService", "system-equations"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">System of Equations</span>
                </nav>
                <h1>System of Equations Solver &mdash; Cramer, Gaussian, Substitution, Matrix</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="ic-hero">

                    <div class="ic-hero-top">
                        <div id="sy-sys-badge">2×2 Linear</div>
                        <div class="ic-expr-label-actions" style="display:flex;gap:0.5rem;align-items:center;margin-left:auto;">
                            <button type="button" class="ic-image-btn" id="sy-image-btn" title="Scan a system from an image">&#128247; Scan</button>
                            <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — solve in chat (Ctrl+Shift+A)">&#10024; AI</button>
                        </div>
                    </div>

                    <!-- Equation rows — the (patched) core renders MathLive
                         rows into #sy-eq-list. Each row carries its hidden
                         .sy-eq-input twin for legacy compatibility. -->
                    <div id="sy-eq-list" class="ic-expr-wrap"></div>

                    <button type="button" id="sy-add-eq-btn" class="sy-add-eq-btn">
                        <span aria-hidden="true">+</span> Add equation
                    </button>

                    <!-- Method pills. Legacy core looks them up by ID
                         `sy-method-{method}` (NOT class), so each carries
                         that ID. The .sy-method-btn class is for styling. -->
                    <div class="sy-method-bar" role="radiogroup" aria-label="Solution method">
                        <span class="sy-method-label">Method</span>
                        <button type="button" id="sy-method-cramer"       class="sy-method-btn active" data-method="cramer"       role="radio" aria-checked="true">Cramer</button>
                        <button type="button" id="sy-method-gaussian"     class="sy-method-btn"        data-method="gaussian"     role="radio" aria-checked="false">Gaussian</button>
                        <button type="button" id="sy-method-substitution" class="sy-method-btn"        data-method="substitution" role="radio" aria-checked="false">Substitution</button>
                        <button type="button" id="sy-method-matrix"       class="sy-method-btn"        data-method="matrix"       role="radio" aria-checked="false">Matrix Inverse</button>
                        <button type="button" id="sy-method-all"          class="sy-method-btn"        data-method="all"          role="radio" aria-checked="false">All Methods</button>
                    </div>

                    <!-- Live preview (KaTeX cases environment) -->
                    <div id="sy-preview" style="display:none;"></div>

                    <!-- Primary CTA + Clear -->
                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta is-disabled" id="sy-solve-btn" aria-disabled="true">Solve System</button>
                        <button type="button" class="ic-clear-btn" id="sy-clear-btn" title="Reset to a blank 2-equation system">Clear</button>
                    </div>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs" role="tablist">
                        <button type="button" id="sy-tab-result" class="ic-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                        <button type="button" id="sy-tab-graph"  class="ic-output-tab" data-panel="graph"  role="tab" aria-selected="false">Graph</button>
                    </div>

                    <div class="ic-panel sy-panel active" id="sy-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="sy-result-content">
                                <div class="tool-empty-state ic-empty-state" id="sy-empty-state">
                                    <div class="ic-empty-illustration">{ }</div>
                                    <h3>Try a system</h3>
                                    <div class="qs-empty-chips">
                                        <span class="qs-chip-label">2×2 Linear</span>
                                        <button type="button" class="ic-example-chip" data-eqs="2x + 3y = 8|4x - y = 2">2x+3y=8 · 4x−y=2</button>

                                        <span class="qs-chip-label">3×3 Linear</span>
                                        <button type="button" class="ic-example-chip" data-eqs="x + y + z = 6|2x - y + z = 3|x + 2y - z = 4">x+y+z=6 · …</button>

                                        <span class="qs-chip-label">Circle + Line</span>
                                        <button type="button" class="ic-example-chip" data-eqs="x^2 + y^2 = 25|x - y = 1">x²+y²=25 · x−y=1</button>

                                        <span class="qs-chip-label">Parabola</span>
                                        <button type="button" class="ic-example-chip" data-eqs="x^2 + y = 5|4x - y = 2">x²+y=5 · 4x−y=2</button>

                                        <span class="qs-chip-label">Two Curves</span>
                                        <button type="button" class="ic-example-chip" data-eqs="x^2 + y^2 = 7|x^2 + y = 5">x²+y²=7 · x²+y=5</button>

                                        <span class="qs-chip-label">xy Product</span>
                                        <button type="button" class="ic-example-chip" data-eqs="x*y = 6|x + y = 5">xy=6 · x+y=5</button>
                                    </div>
                                    <p class="qs-empty-hint">or type your own equations above</p>
                                </div>
                            </div>

                            <div class="tool-result-actions">
                                <button type="button" class="tool-action-btn" id="sy-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="sy-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="sy-toolbar-worksheet-btn">Worksheet</button>
                            </div>

                            <!-- Prominent worksheet CTA (matches limit / polynomial pattern).
                                 The legacy core wires #sy-worksheet-btn → openWorksheet(),
                                 which opens the WorksheetEngine modal with 2,000 problems
                                 across 24 types (basic/medium/hard/scholar). -->
                            <div class="ic-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="sy-worksheet-btn">
                                    Practice Worksheet &mdash; 2,000+ systems with answer key
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel sy-panel" id="sy-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:380px;padding:0.75rem;">
                                <div id="sy-graph-container" style="width:100%;height:100%;min-height:380px;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <section class="ic-learn" aria-label="Methods at a glance">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Cramer's Rule</span>
                    <code class="ic-learn-formula">x<sub>i</sub> = det(A<sub>i</sub>) / det(A)</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Gaussian elimination</span>
                    <code class="ic-learn-formula">augmented [A|b] &rarr; row echelon &rarr; back-substitute</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Matrix inverse</span>
                    <code class="ic-learn-formula">x = A<sup>&minus;1</sup> b &nbsp;(when det(A) &ne; 0)</code>
                </article>
            </section>

            <section class="ic-related-strip" style="margin-top:2rem;display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:0.75rem;">
                <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Single quadratic?</div>
                    <div style="font-weight:600;">Quadratic Formula Calculator &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">Vertex form, completing the square, factoring, and a 50-problem practice worksheet.</div>
                </a>
                <a href="<%=request.getContextPath()%>/inequality-solver.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Inequality?</div>
                    <div style="font-weight:600;">Inequality Solver &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">Linear, polynomial, rational, absolute-value, and compound inequalities with sign chart.</div>
                </a>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- Visible FAQ — keep in sync with faqNq/faqNa jsp:params. -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="System of equations FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can this solver handle nonlinear equations like x&sup2; + y = 5?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. The solver automatically detects nonlinear equations (containing <em>x&sup2;</em>, <em>xy</em>, <em>sqrt</em>, etc.) and switches to a symbolic substitution engine. It solves for all real intersection points, verifies each solution, and plots the curves on the Graph tab.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What is the difference between Cramer's Rule and Gaussian Elimination?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a"><strong>Cramer's Rule</strong> computes each variable using determinants: <em>x<sub>i</sub> = det(A<sub>i</sub>) / det(A)</em>. Clean formula, ideal for 2×2 and 3×3 exams but doesn't scale beyond that. <strong>Gaussian Elimination</strong> applies row operations to the augmented matrix to reach row echelon form, then back-substitutes. Works for any size, and handles the <em>det = 0</em> case where Cramer's Rule fails.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What does "No Unique Solution &mdash; determinant is zero" mean?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">When <em>det(A) = 0</em>, the system is either <strong>inconsistent</strong> (parallel lines, no solution) or <strong>dependent</strong> (same line, infinitely many solutions). Try Gaussian Elimination &mdash; it identifies which case you have. For nonlinear systems, make sure Nerdamer loaded (check the browser console).</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do I enter a 3×3 system?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Click the <strong>+ Add equation</strong> button below the equation rows. Enter three equations with three variables (e.g. <em>x</em>, <em>y</em>, <em>z</em>). The solver auto-detects the 3×3 system and applies your chosen method.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Does it show step-by-step work?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes &mdash; every linear method (Cramer's Rule, Gaussian Elimination, Substitution, Matrix Inversion) shows the complete trace: determinant expansions, row operations, substitution steps, and the final answer with verification. For nonlinear systems, the substitution path and residual check for each solution are shown.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Can I scan a system of equations from a photo or textbook?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes. Click the <strong>&#128247; Scan</strong> button and upload (or drop in) a photo of handwritten or printed equations. The AI vision model extracts each equation, fills the rows automatically, and detects whether the system is linear or nonlinear. Works on phone snapshots, textbook pages, whiteboard photos, and worksheet scans.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Where is the system of equations practice worksheet?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Click the <strong>Practice Worksheet &mdash; 2,000+ systems with answer key</strong> button below the result. The worksheet engine generates printable problem sets across 4 difficulty tiers (basic, medium, hard, scholar) and 24 problem types &mdash; 2&times;2 and 3&times;3 linear, decimal coefficients, fractional, parameter-dependent, circuit/network-flow word problems, 4&times;4/5&times;5/6&times;6 systems, and more. Every problem and answer is <em>SymPy-verified</em>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">What grade levels and curricula does this cover?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">The problem set spans <strong>Algebra 1</strong> (basic 2&times;2), <strong>Algebra 2</strong> (3&times;3 and word problems), <strong>Precalculus</strong> (parameter analysis), <strong>AP Precalculus</strong>, and college <strong>Linear Algebra</strong> (4&times;4&ndash;6&times;6 systems, network flow, multi-parameter). Aligned with Common Core HSA-REI.C and CBSE/ICSE class 9&ndash;10 simultaneous equations. SAT, ACT, and JEE practice covered.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <%--
        Canonical 3-partial load order:
          1. math-libs                       — KaTeX, nerdamer (core+Algebra+Calculus),
                                               Plotly loader, tool-utils, dark-mode,
                                               search, image-to-math
          2. system-equations-scripts        — Solve.js, worksheet-engine,
                                               systems-solver-{render,graph,export,core},
                                               math-studio wiring, image-scan init
          3. math-input-setup                — MathLive ES module (the patched
                                               _makeEqRow uses customElements.whenDefined
                                               to seed each row when ML upgrades)
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />
    <jsp:include page="/math/partials/system-equations-scripts.jsp" />
    <jsp:include page="/math/partials/math-input-setup.jsp" />

    <%@ include file="/modern/components/math-calculus-cores.inc.jsp" %>
    <%
        request.setAttribute("mathAiButtonId", "btnMathAI");
        request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
        request.setAttribute("mathAiProfileExport", "configureSystemMathShell");
    %>
    <%@ include file="/modern/components/math-ai-boot.inc.jsp" %>

</body>
</html>
