<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="System of Equations Solver — Step-by-Step" />
        <jsp:param name="toolDescription" value="Solve any system of equations instantly — linear or nonlinear, 2&times;2 or 3&times;3. See full step-by-step work using Cramer&apos;s rule, Gaussian elimination, substitution, or matrix inversion. Free, no signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="system-equations-solver.jsp" />
        <jsp:param name="toolKeywords" value="system of equations solver, solve system of equations, simultaneous equations solver, 2x2 system solver, 3x3 system solver, systems of equations step by step, cramer's rule calculator, gaussian elimination calculator, substitution method calculator, nonlinear system solver, linear system solver, solve simultaneous equations online, systems of equations calculator, algebra solver" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Linear and nonlinear system solving,Step-by-step Cramer's rule with determinants,Gaussian elimination with row operation trace,Substitution method with full algebraic steps,Matrix inversion A-inverse times B,All-methods comparison mode,Interactive graph of intersection curves,500+ printable practice worksheets with answer keys" />
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
        <jsp:param name="faq4a" value="Click the '+ Add 3rd equation' button below the equation inputs. Enter three equations with three variables (e.g. x, y, z). The solver automatically detects the 3x3 system and applies your chosen method." />
        <jsp:param name="faq5q" value="Does it show step-by-step work?" />
        <jsp:param name="faq5a" value="Yes — every linear method (Cramer's Rule, Gaussian Elimination, Substitution, Matrix Inversion) shows the complete solution trace: determinant expansions, row operations, substitution steps, and the final answer with verification. For nonlinear systems it shows the substitution path and residual check for each solution." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <!-- Critical inline CSS — eliminates render-blocking requests for LCP -->
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff}
        :root{
            --sy-tool:#10b981;--sy-tool-dark:#059669;--sy-gradient:linear-gradient(135deg,#10b981 0%,#34d399 100%);--sy-light:#d1fae5;
            --bg-primary:#fff;--bg-secondary:#f8fafc;--bg-tertiary:#f1f5f9;
            --text-primary:#0f172a;--text-secondary:#475569;--text-muted:#94a3b8;
            --border:#e2e8f0;--font-sans:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;
            --font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
            --shadow-sm:0 1px 2px rgba(0,0,0,0.05);--shadow-lg:0 10px 15px -3px rgba(0,0,0,0.1);
            --radius-md:0.5rem;--radius-lg:0.75rem;
            --z-dropdown:1000;--z-fixed:1030;--z-modal:1050;
            --header-height-desktop:72px;--header-height-mobile:64px
        }
        [data-theme="dark"]{--sy-light:rgba(16,185,129,0.15);--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155}
        [data-theme="dark"] body{background:var(--bg-primary);color:var(--text-primary)}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed);background:var(--bg-primary);border-bottom:1px solid var(--border);height:var(--header-height-desktop)}
        .tool-page-header{background:var(--bg-primary);border-bottom:1px solid var(--border);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--sy-light);color:var(--sy-tool)}
        .tool-description-section{border-bottom:1px solid var(--border);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary)}
        .tool-page-container{display:grid;grid-template-columns:minmax(180px,200px) minmax(0,1fr) 280px;gap:1rem;max-width:1600px;margin:0 auto;padding:1rem 1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(170px,190px) minmax(0,1fr)}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;display:flex;flex-direction:column}.tool-input-column{order:1}.tool-output-column{order:2;min-height:350px}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-card{background:var(--bg-primary);border:1px solid var(--border);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--sy-gradient);color:#fff;padding:0.625rem 0.875rem;font-weight:600;font-size:0.875rem}
        .tool-card-body{padding:0.75rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary);font-size:0.8125rem}
        .tool-form-hint{font-size:0.6875rem;color:var(--text-secondary);margin-top:0.25rem}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--sy-gradient)!important;color:#fff;transition:opacity .15s}
        .tool-action-btn:hover{opacity:.88}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary);border-bottom:1px solid var(--border);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary);flex:1}
        .tool-result-content{padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary);border-color:var(--border)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary)}
        /* Size toggle */
        .sy-size-toggle{display:flex;gap:0.375rem;background:var(--bg-tertiary);padding:0.25rem;border-radius:0.5rem}
        .sy-size-btn{flex:1;padding:0.375rem 0.625rem;font-size:0.8125rem;font-weight:500;border:none;border-radius:0.375rem;cursor:pointer;background:transparent;color:var(--text-secondary);transition:all .15s}
        .sy-size-btn.active{background:var(--sy-gradient);color:#fff;box-shadow:var(--shadow-sm)}
        /* Method toggle */
        .sy-method-toggle{display:flex;flex-wrap:wrap;gap:0.25rem;margin-top:0.25rem}
        .sy-method-btn{padding:0.2rem 0.45rem;font-size:0.6875rem;font-weight:500;border:1px solid var(--border);border-radius:0.3rem;cursor:pointer;background:var(--bg-primary);color:var(--text-secondary);transition:all .15s;white-space:nowrap}
        .sy-method-btn.active{background:var(--sy-gradient);color:#fff;border-color:transparent}
        /* Equation row inputs */
        .sy-eq-row{display:flex;align-items:center;gap:0.3rem;margin-bottom:0.5rem;flex-wrap:wrap}
        .sy-eq-label{font-size:0.75rem;color:var(--text-secondary);min-width:3.5rem;font-weight:500}
        .sy-coef-input{width:3.25rem;padding:0.3rem 0.375rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.8125rem;font-family:var(--font-mono);text-align:center;background:var(--bg-primary);color:var(--text-primary)}
        .sy-coef-input:focus{outline:none;border-color:var(--sy-tool);box-shadow:0 0 0 2px rgba(16,185,129,0.2)}
        .sy-eq-op{font-size:0.8125rem;color:var(--text-secondary);font-weight:600}
        .sy-eq-var{font-size:0.8125rem;font-style:italic;color:var(--text-primary);font-weight:600}
        /* Output tabs */
        .sy-output-tabs{display:flex;border-bottom:1px solid var(--border);background:var(--bg-secondary);border-radius:0.75rem 0.75rem 0 0;overflow:hidden}
        .sy-output-tab{flex:1;padding:0.75rem 1rem;font-size:0.875rem;font-weight:500;border:none;background:transparent;cursor:pointer;color:var(--text-secondary);border-bottom:2px solid transparent;transition:all .15s}
        .sy-output-tab.active{color:var(--sy-tool);border-bottom-color:var(--sy-tool);background:var(--bg-primary)}
        .sy-output-tab:disabled{opacity:0.35;cursor:not-allowed}
        /* Panels */
        .sy-panel{display:none}
        .sy-panel.active{display:block}
        /* Toolbar buttons */
        .sy-toolbar-btn{display:inline-flex;align-items:center;gap:0.3rem;padding:0.3rem 0.65rem;font-size:0.75rem;font-weight:500;border:1px solid var(--border);border-radius:0.375rem;cursor:pointer;background:var(--bg-primary);color:var(--text-secondary);transition:all .15s;white-space:nowrap}
        .sy-toolbar-btn:hover{border-color:var(--sy-tool);color:var(--sy-tool)}
        /* Worksheet button */
        .sy-worksheet-btn{width:100%;padding:0.625rem 1rem;font-size:0.8125rem;font-weight:600;border:2px dashed var(--sy-tool);border-radius:0.5rem;cursor:pointer;background:var(--sy-light);color:var(--sy-tool-dark);transition:all .15s;display:flex;align-items:center;justify-content:center;gap:0.5rem}
        .sy-worksheet-btn:hover{background:var(--sy-tool);color:#fff}
        /* Python template buttons */
        .sy-tpl-bar{display:flex;gap:0.5rem;flex-wrap:wrap;padding:0.75rem;border-bottom:1px solid var(--border);background:var(--bg-secondary)}
        .sy-tpl-btn{padding:0.3rem 0.625rem;font-size:0.75rem;font-weight:500;border:1px solid var(--border);border-radius:0.375rem;cursor:pointer;background:var(--bg-primary);color:var(--text-secondary);transition:all .15s}
        .sy-tpl-btn:hover{border-color:var(--sy-tool);color:var(--sy-tool)}
        /* Graph note */
        .sy-graph-note{font-size:0.8125rem;color:var(--text-muted);text-align:center;margin-top:0.75rem;padding:0.5rem;background:var(--bg-secondary);border-radius:0.375rem;border:1px solid var(--border)}
        /* Animations */
        .sy-anim{opacity:0;transform:translateY(16px);transition:opacity .45s ease,transform .45s ease}
        .sy-anim.sy-visible{opacity:1;transform:none}
        .sy-anim-d1{transition-delay:.05s}.sy-anim-d2{transition-delay:.12s}.sy-anim-d3{transition-delay:.19s}.sy-anim-d4{transition-delay:.26s}.sy-anim-d5{transition-delay:.33s}
        /* Edu grid */
        .sy-edu-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1rem;margin-top:1rem}
        .sy-edu-card{padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--sy-tool)}
        .sy-edu-card h4{font-size:0.875rem;font-weight:600;margin-bottom:0.375rem;color:var(--text-primary)}
        .sy-edu-card p{font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0}
        /* Methods grid */
        .sy-methods-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(230px,1fr));gap:1rem;margin-top:1rem}
        .sy-method-card{padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border:1px solid var(--border)}
        .sy-method-card h4{font-size:0.875rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-primary);display:flex;align-items:center;gap:0.5rem}
        .sy-method-card p{font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0}
        .sy-method-tag{display:inline-block;font-size:0.625rem;font-weight:600;padding:0.125rem 0.4rem;border-radius:9999px;text-transform:uppercase;letter-spacing:.04em}
        /* Solution type cards */
        .sy-solution-types{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:1rem;margin-top:1rem}
        .sy-sol-card{padding:1rem 1.125rem;border-radius:0.5rem;border:1px solid var(--border)}
        .sy-sol-badge{display:inline-block;font-size:0.6875rem;font-weight:700;padding:0.2rem 0.6rem;border-radius:9999px;margin-bottom:0.5rem;text-transform:uppercase;letter-spacing:.05em}
        .sy-sol-card h4{font-size:0.875rem;font-weight:600;margin-bottom:0.375rem;color:var(--text-primary)}
        .sy-sol-card p{font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;margin:0}
        /* Callout */
        .sy-callout{display:flex;gap:0.75rem;padding:0.875rem 1rem;border-radius:0.5rem;margin-top:1rem;background:var(--sy-light);border:1px solid rgba(16,185,129,0.25)}
        .sy-callout-icon{font-size:1.125rem;flex-shrink:0;line-height:1.5}
        .sy-callout-text{font-size:0.8125rem;color:var(--text-secondary);line-height:1.6}
        /* FAQ */
        .faq-item{border-bottom:1px solid var(--border);padding:0.25rem 0}
        .faq-question{width:100%;display:flex;align-items:center;justify-content:space-between;padding:0.875rem 0;font-size:0.9rem;font-weight:600;background:transparent;border:none;cursor:pointer;color:var(--text-primary);text-align:left;gap:0.5rem}
        .faq-chevron{flex-shrink:0;transition:transform .25s}
        .faq-answer{font-size:0.875rem;color:var(--text-secondary);line-height:1.7;padding:0 0 1rem;display:none}
        .faq-item.open .faq-chevron{transform:rotate(180deg)}
        .faq-item.open .faq-answer{display:block}
        /* Symbolic equation inputs */
        .sy-sym-row{display:flex;align-items:center;gap:0.375rem;margin-bottom:0.375rem}
        .sy-sym-num{font-size:0.6875rem;font-weight:700;color:var(--sy-tool);min-width:1.25rem;font-family:var(--font-mono);text-align:right}
        .sy-sym-input{flex:1;padding:0.375rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.8125rem;font-family:var(--font-mono);background:var(--bg-primary);color:var(--text-primary);transition:border-color .15s}
        .sy-sym-input:focus{outline:none;border-color:var(--sy-tool);box-shadow:0 0 0 2px rgba(16,185,129,0.2)}
        .sy-sym-input.sy-input-error{border-color:#ef4444}
        .sy-remove-eq-btn{width:1.5rem;height:1.5rem;border:1px solid var(--border);border-radius:0.375rem;background:transparent;color:var(--text-muted);cursor:pointer;font-size:1rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;transition:all .15s;padding:0;line-height:1}
        .sy-remove-eq-btn:hover{border-color:#ef4444;color:#ef4444}
        .sy-add-eq-btn{width:100%;padding:0.4rem 0.75rem;border:1px dashed var(--border);border-radius:0.375rem;background:transparent;color:var(--text-muted);cursor:pointer;font-size:0.8rem;transition:all .15s;margin-top:0.25rem;text-align:center}
        .sy-add-eq-btn:hover{border-color:var(--sy-tool);color:var(--sy-tool);background:var(--sy-light)}
        .sy-add-eq-btn:disabled{opacity:.4;cursor:not-allowed}
        /* System type badge */
        .sy-sys-badge{display:inline-flex;align-items:center;padding:0.15rem 0.5rem;border-radius:0.3rem;font-size:0.6875rem;font-weight:700;margin-left:0.5rem;vertical-align:middle;text-transform:uppercase;letter-spacing:.04em}
        .sy-sys-badge.linear{background:#d1fae5;color:#059669}
        .sy-sys-badge.nonlinear{background:#fef3c7;color:#b45309}
        /* Live preview */
        .sy-preview{margin-top:0.5rem;padding:0.5rem 0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.375rem;min-height:2.25rem;overflow-x:auto;text-align:center;font-size:0.9rem;display:none}
        /* Answer chips */
        .sy-chips{display:flex;flex-wrap:wrap;gap:0.5rem;justify-content:center;margin:0.375rem 0 1rem}
        .sy-chip{padding:0.375rem 1rem;background:var(--sy-light);border:1.5px solid rgba(16,185,129,0.35);border-radius:2rem;font-size:0.9rem;color:var(--sy-tool-dark);font-weight:700}
        /* Collapsible steps */
        .sy-steps-hdr{width:100%;display:flex;align-items:center;justify-content:space-between;padding:0.5rem 0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.375rem;font-size:0.8125rem;font-weight:600;cursor:pointer;color:var(--text-primary);margin:0.75rem 0 0;transition:background .15s}
        .sy-steps-hdr:hover{background:var(--bg-tertiary)}
        .sy-steps-hdr .sy-chev{transition:transform .2s;flex-shrink:0}
        .sy-steps-hdr.open .sy-chev{transform:rotate(180deg)}
        .sy-steps-body{margin-top:0.5rem;display:none}
        .sy-steps-body.open{display:block}
        /* Method section - dim when nonlinear */
        .sy-method-section.sy-nonlinear-mode{opacity:.4;pointer-events:none}
        /* Example chips */
        .sy-example-chip{padding:0.2rem 0.55rem;font-size:0.7rem;font-weight:500;border:1px solid var(--border);border-radius:0.3rem;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all .15s;white-space:nowrap;font-family:var(--font-mono)}
        .sy-example-chip:hover{border-color:var(--sy-tool);color:var(--sy-tool);background:var(--sy-light)}

        /* ── Step items ── */
        .sy-step-item{display:flex;gap:0.75rem;margin-bottom:0.875rem;align-items:flex-start}
        .sy-step-num{min-width:1.75rem;height:1.75rem;border-radius:50%;background:var(--sy-gradient);color:#fff;display:flex;align-items:center;justify-content:center;font-size:0.7rem;font-weight:700;flex-shrink:0;box-shadow:0 1px 3px rgba(16,185,129,.3)}
        .sy-step-body{flex:1;min-width:0}
        .sy-step-title{font-size:0.8rem;color:var(--text-muted,#94a3b8);margin-bottom:0.3rem;line-height:1.4}
        .sy-step-math{overflow-x:auto;padding:0.25rem 0}

        /* ── Nonlinear step items (slightly bolder title) ── */
        .sy-nl-step-num{flex-shrink:0;width:1.5rem;height:1.5rem;background:var(--sy-gradient);border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-size:0.65rem;font-weight:700;color:#fff;margin-top:0.1rem;box-shadow:0 1px 3px rgba(16,185,129,.3)}
        .sy-nl-step-title{font-size:0.8125rem;font-weight:600;color:var(--text-primary,#0f172a);margin-bottom:0.25rem;line-height:1.5}

        /* ── Solution count label ── */
        .sy-sol-count{font-size:0.6875rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:var(--sy-tool);margin-bottom:0.5rem;text-align:center}
        .sy-sol-pair{display:flex;justify-content:center;gap:0.5rem;margin-bottom:0.375rem;flex-wrap:wrap}

        /* ── System display header ── */
        .sy-system-display{text-align:center;margin-bottom:1rem}

        /* ── Verify section ── */
        .sy-verify-section{margin-top:1rem;padding:0.75rem;background:var(--bg-secondary);border-radius:0.5rem;border:1px solid var(--border)}
        .sy-verify-header{font-size:0.75rem;font-weight:700;color:var(--text-secondary);margin-bottom:0.5rem;display:flex;align-items:center;gap:0.5rem}
        .sy-verify-num{width:1.5rem;height:1.5rem;background:var(--bg-tertiary,#f1f5f9);border:1px solid var(--border);border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-size:0.6rem;font-weight:700;color:var(--text-muted);flex-shrink:0}
        .sy-verify-pair{font-size:0.75rem;font-weight:600;color:var(--text-secondary);margin:0.375rem 0 0.2rem;padding-left:1.75rem}
        .sy-verify-row{font-size:0.8125rem;padding-left:2rem;margin-bottom:0.2rem;display:flex;align-items:baseline;gap:0.375rem;flex-wrap:wrap}
        .sy-verify-ok{color:#10b981}
        .sy-verify-fail{color:#ef4444}
        .sy-verify-code{font-size:0.75rem;background:var(--bg-primary,#fff);border:1px solid var(--border);padding:.1rem .35rem;border-radius:.25rem;font-family:var(--font-mono)}

        /* ── Inline warning/info boxes ── */
        .sy-warn-box{padding:0.875rem 1rem;background:#fef3c7;border-left:3px solid #f59e0b;border-radius:0.5rem;color:#92400e;font-size:0.875rem;margin-bottom:0.75rem}
        [data-theme="dark"] .sy-warn-box{background:rgba(245,158,11,.12);color:#fcd34d}

        /* ── Method label strip ── */
        .sy-method-label{display:inline-flex;align-items:center;gap:0.375rem;font-size:0.6875rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em;padding:0.2rem 0.6rem;border-radius:9999px;margin-bottom:0.75rem}
        .sy-method-label.elim{background:#d1fae5;color:#065f46}
        .sy-method-label.subst{background:#e0f2fe;color:#0369a1}
        .sy-method-label.sympy{background:#ede9fe;color:#6d28d9}
        [data-theme="dark"] .sy-method-label.elim{background:rgba(16,185,129,.15);color:#34d399}
        [data-theme="dark"] .sy-method-label.subst{background:rgba(59,130,246,.15);color:#60a5fa}
        [data-theme="dark"] .sy-method-label.sympy{background:rgba(139,92,246,.15);color:#a78bfa}
        .sy-chip-approx{font-size:0.72rem;color:var(--text-muted);font-family:var(--font-mono);margin-left:0.25rem;align-self:center}

        @keyframes spin{to{transform:rotate(360deg)}}
    </style>

    <!-- Non-blocking CSS (preload + noscript fallback) -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/css/systems-solver.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/systems-solver.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">System of Equations Solver</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                System of Equations Solver
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Linear &amp; Nonlinear</span>
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">Graph Included</span>
            <span class="tool-badge">Free</span>
        </div>
    </div>
</header>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--sy-gradient);">System Solver</div>
            <div class="tool-card-body">

                <!-- Symbolic Equation Inputs -->
                <div class="tool-form-group" style="margin-bottom:0.625rem;">
                    <label class="tool-form-label" style="margin-bottom:0.25rem;">
                        Equations
                        <span id="sy-sys-badge" class="sy-sys-badge" style="display:none;"></span>
                    </label>
                    <div id="sy-eq-list">
                        <!-- Equation rows injected by JS -->
                    </div>
                    <button type="button" id="sy-add-eq-btn" class="sy-add-eq-btn">+ Add 3rd equation (3&times;3 system)</button>
                    <div class="tool-form-hint" style="margin-top:0.375rem;">Type naturally: <code style="font-size:0.75rem;">2x + 3y = 8</code> or <code style="font-size:0.75rem;">x^2 + y = 5</code></div>
                    <!-- Live KaTeX preview -->
                    <div class="sy-preview" id="sy-preview"></div>
                </div>

                <!-- Examples -->
                <div class="tool-form-group" style="margin-top:0.5rem;">
                    <label class="tool-form-label" style="margin-bottom:0.25rem;">Examples</label>
                    <div id="sy-examples" style="display:flex;flex-wrap:wrap;gap:0.3rem;"></div>
                </div>

                <!-- Method Selector -->
                <div class="tool-form-group sy-method-section" id="sy-method-section" style="margin-top:0.625rem;">
                    <label class="tool-form-label" style="margin-bottom:0.25rem;">Method</label>
                    <div class="sy-method-toggle" id="sy-method-toggle">
                        <button type="button" class="sy-method-btn active" id="sy-method-cramer" data-method="cramer">Cramer&rsquo;s Rule</button>
                        <button type="button" class="sy-method-btn" id="sy-method-gaussian" data-method="gaussian">Gaussian</button>
                        <button type="button" class="sy-method-btn" id="sy-method-substitution" data-method="substitution">Substitution</button>
                        <button type="button" class="sy-method-btn" id="sy-method-matrix" data-method="matrix">Matrix A&sup1;B</button>
                        <button type="button" class="sy-method-btn" id="sy-method-all" data-method="all">All Methods</button>
                    </div>
                </div>

                <!-- Solve Button -->
                <div style="margin-top:0.625rem;">
                    <button type="button" class="tool-action-btn" id="sy-solve-btn">
                        Solve System
                    </button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:0.75rem 0">

                <!-- Worksheet Generator -->
                <div>
                    <button type="button" class="sy-worksheet-btn" id="sy-worksheet-btn">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:15px;height:15px;flex-shrink:0;">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <polyline points="14 2 14 8 20 8"/>
                            <line x1="16" y1="13" x2="8" y2="13"/>
                            <line x1="16" y1="17" x2="8" y2="17"/>
                        </svg>
                        Print Worksheet
                    </button>
                </div>

            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="sy-output-tabs">
            <button type="button" id="sy-tab-result" class="sy-output-tab active" data-panel="result">Result</button>
            <button type="button" id="sy-tab-graph" class="sy-output-tab" data-panel="graph" disabled>Graph</button>
        </div>

        <!-- Result Panel -->
        <div class="sy-panel active" id="sy-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--sy-tool);">
                        <path d="M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18"/>
                    </svg>
                    <h4>Solution</h4>
                    <button type="button" id="sy-copy-latex-btn" class="sy-toolbar-btn" title="Copy LaTeX">LaTeX</button>
                    <button type="button" id="sy-share-btn" class="sy-toolbar-btn" title="Share">Share</button>
                    <button type="button" id="sy-toolbar-worksheet-btn" class="sy-toolbar-btn" title="Worksheet">Worksheet</button>
                </div>
                <div class="tool-result-content" id="sy-result-content">
                    <div class="tool-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1D4D0;</div>
                        <h3>Enter coefficients and solve</h3>
                        <p>Choose your system size and solving method, then click Solve to see step-by-step work.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Graph Panel -->
        <div class="sy-panel" id="sy-panel-graph">
            <div class="tool-card">
                <div class="tool-card-header" style="background:var(--sy-gradient);">Graphical Solution</div>
                <div class="tool-card-body" style="padding:0.5rem;">
                    <div id="sy-graph-container" style="height:420px;"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="system-equations-solver.jsp"/>
    <jsp:param name="keyword" value="algebra"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD CONTENT ========== -->
<section style="max-width:1200px;margin:1.5rem auto;padding:0 1.25rem;">

    <!-- What does this tool do? -->
    <div class="tool-card" style="padding:1.25rem 1.5rem;margin-bottom:1rem;">
        <h2 style="font-size:1.125rem;font-weight:700;margin:0 0 0.75rem;color:var(--text-primary);">What Does This Tool Do?</h2>
        <p style="font-size:0.9rem;color:var(--text-secondary);line-height:1.7;margin:0 0 0.75rem;">
            This solver accepts any system of 2 or 3 equations and finds all solutions — showing the <strong>complete step-by-step working</strong> just like a math teacher would present it.
            Enter equations naturally (e.g. <code style="font-size:0.8rem;">2x + 3y = 8</code> or <code style="font-size:0.8rem;">x² + y² = 7</code>) and choose your preferred method.
        </p>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:0.75rem;margin-top:0.75rem;">
            <div style="display:flex;gap:0.625rem;align-items:flex-start;">
                <span style="font-size:1.25rem;line-height:1;">&#x2705;</span>
                <div>
                    <strong style="font-size:0.875rem;color:var(--text-primary);">Linear systems</strong>
                    <p style="margin:0.15rem 0 0;font-size:0.8125rem;color:var(--text-secondary);">2&times;2 and 3&times;3 — Cramer&rsquo;s Rule, Gaussian elimination, substitution, matrix inversion</p>
                </div>
            </div>
            <div style="display:flex;gap:0.625rem;align-items:flex-start;">
                <span style="font-size:1.25rem;line-height:1;">&#x2705;</span>
                <div>
                    <strong style="font-size:0.875rem;color:var(--text-primary);">Nonlinear systems</strong>
                    <p style="margin:0.15rem 0 0;font-size:0.8125rem;color:var(--text-secondary);">Circles, parabolas, products — finds all intersection points with elimination or substitution</p>
                </div>
            </div>
            <div style="display:flex;gap:0.625rem;align-items:flex-start;">
                <span style="font-size:1.25rem;line-height:1;">&#x2705;</span>
                <div>
                    <strong style="font-size:0.875rem;color:var(--text-primary);">Exact symbolic roots</strong>
                    <p style="margin:0.15rem 0 0;font-size:0.8125rem;color:var(--text-secondary);">Answers shown as &radic;6, &minus;&radic;3, etc. — not just decimals</p>
                </div>
            </div>
            <div style="display:flex;gap:0.625rem;align-items:flex-start;">
                <span style="font-size:1.25rem;line-height:1;">&#x2705;</span>
                <div>
                    <strong style="font-size:0.875rem;color:var(--text-primary);">Graph of intersections</strong>
                    <p style="margin:0.15rem 0 0;font-size:0.8125rem;color:var(--text-secondary);">Click the Graph tab — both curves plotted with the solution point highlighted</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick-reference: methods + solution types in one row -->
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(480px,1fr));gap:1rem;margin-bottom:1rem;">

        <!-- Methods -->
        <div class="tool-card" style="padding:1.25rem 1.5rem;">
            <h2 style="font-size:1rem;font-weight:700;margin:0 0 0.875rem;color:var(--text-primary);">Solving Methods</h2>
            <div style="display:flex;flex-direction:column;gap:0.5rem;">
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:1.75rem;height:1.75rem;background:linear-gradient(135deg,#10b981,#34d399);border-radius:0.3rem;display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.6875rem;font-weight:700;">D</span>
                    <div><strong style="font-size:0.875rem;">Cramer&rsquo;s Rule</strong> <span style="font-size:0.75rem;color:var(--text-muted);">— 2&times;2 / 3&times;3</span><br><span style="font-size:0.8125rem;color:var(--text-secondary);">x&thinsp;=&thinsp;det(A<sub>x</sub>)/det(A). Clean formula ideal for exams; requires det(A)&thinsp;&ne;&thinsp;0.</span></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:1.75rem;height:1.75rem;background:linear-gradient(135deg,#3b82f6,#60a5fa);border-radius:0.3rem;display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.6875rem;font-weight:700;">G</span>
                    <div><strong style="font-size:0.875rem;">Gaussian Elimination</strong> <span style="font-size:0.75rem;color:var(--text-muted);">— any size</span><br><span style="font-size:0.8125rem;color:var(--text-secondary);">Row-reduces [A|b] to echelon form, then back-substitutes. Works even when det(A)&thinsp;=&thinsp;0.</span></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:1.75rem;height:1.75rem;background:linear-gradient(135deg,#f59e0b,#fcd34d);border-radius:0.3rem;display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.6875rem;font-weight:700;">S</span>
                    <div><strong style="font-size:0.875rem;">Substitution</strong> <span style="font-size:0.75rem;color:var(--text-muted);">— 2&times;2, nonlinear</span><br><span style="font-size:0.8125rem;color:var(--text-secondary);">Solves one equation for a variable, substitutes into the other. Also used for nonlinear systems.</span></div>
                </div>
                <div style="display:flex;gap:0.75rem;align-items:flex-start;">
                    <span style="flex-shrink:0;width:1.75rem;height:1.75rem;background:linear-gradient(135deg,#8b5cf6,#a78bfa);border-radius:0.3rem;display:flex;align-items:center;justify-content:center;color:#fff;font-size:0.6875rem;font-weight:700;">M</span>
                    <div><strong style="font-size:0.875rem;">Matrix A<sup>&minus;1</sup>B</strong> <span style="font-size:0.75rem;color:var(--text-muted);">— linear algebra</span><br><span style="font-size:0.8125rem;color:var(--text-secondary);">Computes A<sup>&minus;1</sup>, then X&thinsp;=&thinsp;A<sup>&minus;1</sup>B. Useful when solving multiple systems with the same A.</span></div>
                </div>
            </div>
        </div>

        <!-- Solution types -->
        <div class="tool-card" style="padding:1.25rem 1.5rem;">
            <h2 style="font-size:1rem;font-weight:700;margin:0 0 0.875rem;color:var(--text-primary);">Three Types of Solutions</h2>
            <div style="display:flex;flex-direction:column;gap:0.625rem;">
                <div style="padding:0.75rem;border-radius:0.375rem;background:var(--bg-secondary);border-left:3px solid #10b981;">
                    <span style="font-size:0.6875rem;font-weight:700;text-transform:uppercase;letter-spacing:.04em;color:#059669;">Unique Solution</span>
                    <p style="margin:0.2rem 0 0;font-size:0.8125rem;color:var(--text-secondary);">det(A)&thinsp;&ne;&thinsp;0 — lines/planes meet at exactly one point. All methods give the same answer.</p>
                </div>
                <div style="padding:0.75rem;border-radius:0.375rem;background:var(--bg-secondary);border-left:3px solid #f59e0b;">
                    <span style="font-size:0.6875rem;font-weight:700;text-transform:uppercase;letter-spacing:.04em;color:#b45309;">Infinite Solutions</span>
                    <p style="margin:0.2rem 0 0;font-size:0.8125rem;color:var(--text-secondary);">det(A)&thinsp;=&thinsp;0, consistent — equations are multiples of each other. One free variable parameterises the solution set.</p>
                </div>
                <div style="padding:0.75rem;border-radius:0.375rem;background:var(--bg-secondary);border-left:3px solid #ef4444;">
                    <span style="font-size:0.6875rem;font-weight:700;text-transform:uppercase;letter-spacing:.04em;color:#b91c1c;">No Solution</span>
                    <p style="margin:0.2rem 0 0;font-size:0.8125rem;color:var(--text-secondary);">det(A)&thinsp;=&thinsp;0, inconsistent — parallel lines/planes. The augmented matrix has a row [0 … 0 | c], c&thinsp;&ne;&thinsp;0.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- FAQ -->
    <div class="tool-card" style="padding:1.25rem 1.5rem;margin-bottom:1rem;">
        <h2 style="font-size:1rem;font-weight:700;margin:0 0 0.5rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can this solver handle nonlinear equations like x² + y = 5?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes. The solver automatically detects equations containing x^2, x*y, sqrt(), etc. and switches to a symbolic substitution engine. It finds <strong>all real intersection points</strong>, verifies each solution numerically, and plots both curves on the Graph tab. Type either <code>x^2 + y = 5</code> or <code>x²+y=5</code> — Unicode superscripts are normalised automatically.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between Cramer&rsquo;s Rule and Gaussian Elimination?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer"><strong>Cramer&rsquo;s Rule</strong> computes each variable using determinants: x = det(A<sub>x</sub>)/det(A). Gives a clean formula — great for 2×2/3×3 exams but fails when det(A) = 0. <strong>Gaussian Elimination</strong> applies row operations to the augmented matrix [A|b], reaches row echelon form, then back-substitutes. It works for any size system and handles the singular case where det(A) = 0. Use <em>All Methods</em> to see both side by side.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What does &ldquo;No Unique Solution — determinant is zero&rdquo; mean?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">det(A) = 0 means two things are possible: the system is <strong>inconsistent</strong> (parallel lines — no solution) or <strong>dependent</strong> (same line — infinitely many solutions). Switch to Gaussian Elimination to see which case applies. If you entered a nonlinear equation and still see this, the CAS library (Nerdamer) may not have loaded — check your browser console for script errors.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I solve a 3&times;3 system?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Click <strong>+ Add 3rd equation</strong> in the input panel, then enter three equations with three variables (x, y, z). The solver detects the 3×3 system automatically. All methods except Substitution work for 3×3 systems. <em>All Methods</em> mode shows Cramer&rsquo;s Rule, Gaussian Elimination, and Matrix Inversion simultaneously.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Does it show step-by-step work?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes — every method shows the complete solution trace. Cramer&rsquo;s Rule expands each determinant. Gaussian Elimination lists every row operation. Substitution shows the algebraic substitution. Matrix Inversion shows A<sup>&minus;1</sup> and the multiplication. For nonlinear systems, the solve trace shows which equation was used as the pivot, the reduced polynomial, and residual verification for each solution.</div>
        </div>
    </div>

</section>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<!-- Scroll-triggered animations -->
<script>
(function(){
    var els = document.querySelectorAll('.sy-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        els.forEach(function(el){ el.classList.add('sy-visible'); });
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        entries.forEach(function(e){
            if (e.isIntersecting) {
                e.target.classList.add('sy-visible');
                obs.unobserve(e.target);
            }
        });
    }, { threshold: 0.15 });
    els.forEach(function(el){ obs.observe(el); });
})();

function toggleFaq(btn) {
    var item = btn.parentElement;
    var isOpen = item.classList.contains('open');
    document.querySelectorAll('.faq-item.open').forEach(function(i){ i.classList.remove('open'); });
    if (!isOpen) item.classList.add('open');
}

// ==================== Example Chips ====================
(function() {
    var EXAMPLES = [
        { label: '2×2 Linear',    eqs: ['2x + 3y = 8', '4x - y = 2'] },
        { label: '3×3 Linear',    eqs: ['x + y + z = 6', '2x - y + z = 3', 'x + 2y - z = 4'] },
        { label: 'Circle + Line', eqs: ['x^2 + y^2 = 25', 'x - y = 1'] },
        { label: 'Parabola',      eqs: ['x^2 + y = 5', '4x - y = 2'] },
        { label: 'Two Circles',   eqs: ['x^2 + y^2 = 7', 'x^2 + y = 5'] },
        { label: 'xy Product',    eqs: ['x*y = 6', 'x + y = 5'] },
        { label: 'Cubic + Circle', eqs: ['y = x^3', 'x^2 + y^2 = 5'] },
    ];

    function loadExample(example) {
        var core = window.SystemsSolverCore;
        if (core && core.loadExample) core.loadExample(example.eqs);
    }

    document.addEventListener('DOMContentLoaded', function() {
        var container = document.getElementById('sy-examples');
        if (!container) return;
        EXAMPLES.forEach(function(ex) {
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'sy-example-chip';
            btn.textContent = ex.label;
            btn.title = ex.eqs.join(' | ');
            btn.addEventListener('click', function() { loadExample(ex); });
            container.appendChild(btn);
        });
    });
})();
</script>

<!-- Core Scripts -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script src="<%=request.getContextPath()%>/js/worksheet-engine.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/systems-solver-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/systems-solver-graph.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/systems-solver-export.js?v=<%=cacheVersion%>"></script>
<!-- Nerdamer CAS: symbolic parsing, linearity detection, nonlinear solving -->
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Solve.min.js"></script>
<script>window.SYSTEMS_SOLVER_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/js/systems-solver-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
