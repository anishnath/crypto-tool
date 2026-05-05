<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Percentage Calculator — migrated to math-studio shell.

        No MathLive, no AI scan — number-only inputs, focus on easy UX.

        Architecture:
          · Legacy core/render/export reused unchanged. The JSP preserves
            every DOM ID the core looks up: pc-x, pc-y, pc-a, pc-b,
            pc-disc-pct, pc-final-price, pc-base-price, pc-disc-sim,
            pc-tax-sim, pc-qty, pc-chain-start, pc-chain-steps,
            pc-result-content, pc-empty-state, pc-result-actions,
            pc-solve-btn, pc-clear-btn, pc-preview, pc-compiler-iframe,
            pc-compiler-template, pc-copy-latex-btn, pc-share-btn.
          · #pc-preview is kept in the DOM (legacy renders KaTeX into it)
            but visually hidden — the Result card itself is now the live
            preview.
          · Tiny bridge IIFE at end of body wires every .pc-input / .pc-input-text
            input event + .pc-mode-btn click → debounced #pc-solve-btn.click()
            so users see results live without pressing Calculate.
          · 8 modes, examples chips, KaTeX result, Python compiler, share, LaTeX —
            all behavior preserved.
    --%>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Percentage Calculator with Steps - All Formulas Free Online" />
        <jsp:param name="toolDescription" value="Free percentage calculator with step-by-step solutions. Find percent of, percent change, increase, decrease, reverse percentage, and discount with tax." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="percentage-calculator.jsp" />
        <jsp:param name="toolKeywords" value="percentage calculator, percent of calculator, percent change calculator, percent increase calculator, percent decrease calculator, discount calculator, reverse percentage, percentage formula, step by step percentage, tax calculator, percentage solver" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Calculate X percent of Y with steps,Find what percent X is of Y,Percent increase and decrease calculator,Percent change from A to B,Reverse percentage - find original price,Discount plus tax simulator with quantity,Chained percentage steps with running total,Built-in Python compiler with 3 templates,LaTeX export and shareable URLs,8 quick example presets,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="teaches" value="Percentages, percent change, percent increase and decrease, reverse percentage, discount and tax calculations" />
        <jsp:param name="educationalLevel" value="Middle School, High School" />
        <jsp:param name="howToSteps" value="Select a calculation mode|Choose from 8 modes: percent of or what percent or increase or decrease or percent change or reverse percentage or discount simulator or chained steps,Enter your values|Type numbers into the X and Y input fields. For discount mode enter base price and discount and tax percentages,View live result|The result card updates as you type with the step-by-step solution and KaTeX-rendered formulas,Review steps and export|Read each solution step then copy LaTeX or share the URL or try the Python compiler" />
        <jsp:param name="faq1q" value="How do you calculate a percentage of a number?" />
        <jsp:param name="faq1a" value="To find X percent of Y multiply Y by X divided by 100. For example 25 percent of 200 equals 200 times 25 divided by 100 equals 50. The formula is Result equals X divided by 100 times Y. This calculator shows every step of the computation." />
        <jsp:param name="faq2q" value="How do you calculate percent change between two numbers?" />
        <jsp:param name="faq2a" value="Percent change equals the difference B minus A divided by the original value A times 100. For example going from 120 to 150 gives (150 minus 120) divided by 120 times 100 equals 25 percent increase. A negative result means a decrease." />
        <jsp:param name="faq3q" value="How do you find the original price before a discount?" />
        <jsp:param name="faq3a" value="Divide the final price by 1 minus the discount percentage divided by 100. For example if the final price is 75 after a 25 percent discount the original is 75 divided by 0.75 which equals 100. The formula is Original equals Final divided by (1 minus Discount percent divided by 100)." />
        <jsp:param name="faq4q" value="How do chained percentage steps work?" />
        <jsp:param name="faq4a" value="Each percentage step applies to the running total not the original. For example starting at 100 then plus 10 percent gives 110 then minus 5 percent gives 104.5 then plus 8 percent gives 112.86. Note that plus 10 percent then minus 10 percent does not return to the original because each step uses the current value as its base." />
        <jsp:param name="faq5q" value="Is this percentage calculator free?" />
        <jsp:param name="faq5a" value="Yes 100 percent free with no signup required. Features include 8 calculation modes with step by step KaTeX solutions a discount tax simulator chained steps a Python compiler LaTeX export and shareable URLs. All computation runs in your browser." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />
    <meta name="context-path" content="<%=request.getContextPath()%>">

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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/percentage-calculator.css">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        /* ───── Mode pill bar (8 modes) — math-studio tuned ───── */
        .pc-mode-bar {
            display: flex; flex-wrap: wrap; gap: 0.35rem;
            padding: 0.4rem 0.5rem;
            background: var(--ms-panel-bg-soft, #faf8f4);
            border: 1px solid var(--ms-line, rgba(0,0,0,0.08));
            border-radius: var(--ms-radius, 14px);
            align-items: center;
            margin-bottom: 0.85rem;
        }
        .pc-mode-bar .pc-mode-label {
            font-size: 0.7rem; font-weight: 600;
            color: var(--ms-muted, #78716c);
            text-transform: uppercase; letter-spacing: 0.05em;
            margin-right: 0.25rem;
        }
        .pc-mode-bar .pc-mode-btn {
            flex: 0 1 auto;
            padding: 0.4rem 0.7rem;
            font-size: 0.8rem; font-weight: 500;
            border: none;
            border-radius: var(--ms-radius-pill, 999px);
            background: transparent;
            color: var(--ms-ink-soft, #44403c);
            cursor: pointer;
            font-family: var(--ms-font-sans, Inter, sans-serif);
            transition: background 200ms, color 200ms;
        }
        .pc-mode-bar .pc-mode-btn:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
        }
        .pc-mode-bar .pc-mode-btn.active {
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-accent, #15803d);
            box-shadow: 0 1px 2px rgba(0,0,0,0.06);
            font-weight: 600;
        }

        /* ───── Mode-form area (only one .pc-mode-form is .active at a time) ───── */
        .pc-mode-form { display: none; }
        .pc-mode-form.active { display: block; }
        .pc-input-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.65rem;
            margin-bottom: 0.5rem;
        }
        .pc-input-row:last-child { margin-bottom: 0; }
        .pc-input-group { display: flex; flex-direction: column; gap: 0.3rem; }
        .pc-input-label {
            font-size: 0.74rem; font-weight: 600;
            color: var(--ms-ink-soft, #44403c);
        }
        .pc-input,
        .pc-input-text {
            width: 100%;
            padding: 0.6rem 0.85rem;
            font-size: 1rem;
            font-family: var(--ms-font-mono, 'JetBrains Mono', monospace);
            border: 1.5px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius, 14px);
            background: var(--ms-panel-bg-soft, #faf8f4);
            color: var(--ms-ink, #1c1917);
            transition: border-color 200ms, box-shadow 200ms, background 200ms;
            box-sizing: border-box;
        }
        .pc-input:focus,
        .pc-input-text:focus {
            outline: none;
            border-color: var(--ms-accent, #15803d);
            background: var(--ms-panel-bg, #fefdfb);
            box-shadow: var(--ms-ring, 0 0 0 3px rgba(21,128,61,0.22));
        }
        .pc-form-hint {
            font-size: 0.78rem;
            color: var(--ms-muted, #78716c);
            margin-top: 0.4rem;
        }

        /* ───── Hidden legacy preview node (kept for core compatibility) ───── */
        #pc-preview { display: none !important; }

        /* ───── Inline-formula hint above inputs (per active mode) ───── */
        .pc-formula-hint {
            display: block;
            padding: 0.55rem 0.9rem;
            margin-bottom: 0.65rem;
            font-family: var(--ms-font-mono, 'JetBrains Mono', monospace);
            font-size: 0.85rem;
            color: var(--ms-ink-soft, #44403c);
            background: var(--ms-panel-bg-soft, #faf8f4);
            border-left: 3px solid var(--ms-accent, #15803d);
            border-radius: var(--ms-radius-sm, 8px);
        }
        .pc-formula-hint code {
            font-family: inherit;
            color: var(--ms-accent, #15803d);
            font-weight: 600;
            background: transparent;
            padding: 0;
        }

        /* ───── Examples chip row ───── */
        .pc-examples {
            display: flex; flex-wrap: wrap; gap: 0.4rem;
        }
        .pc-example-chip {
            padding: 0.35rem 0.7rem;
            font-size: 0.78rem; font-weight: 500;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-pill, 999px);
            background: transparent;
            color: var(--ms-ink-soft, #44403c);
            cursor: pointer;
            font-family: var(--ms-font-mono, 'JetBrains Mono', monospace);
            transition: background 200ms, color 200ms, border-color 200ms;
        }
        .pc-example-chip:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            border-color: var(--ms-accent, #15803d);
        }

        /* ───── CTA + Clear row ───── */
        .pc-cta-row {
            display: flex; gap: 0.6rem; align-items: center;
            margin-top: 0.85rem;
        }
        .pc-cta-row .ic-hero-cta { flex: 1; }
        .pc-cta-row .ic-clear-btn {
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
        .pc-cta-row .ic-clear-btn:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
            color: var(--ms-accent, #15803d);
            border-color: var(--ms-accent, #15803d);
        }

        /* ───── Result card overrides — match polynomial/quadratic look ───── */
        .pc-output-tabs { display: flex; }
        .pc-panel { display: none; }
        .pc-panel.active { display: block; }

        /* Compiler dropdown (placed inside the result-header) */
        #pc-compiler-template {
            margin-left: auto;
            padding: 0.3rem 0.55rem;
            border: 1px solid var(--ms-line-strong, rgba(0,0,0,0.14));
            border-radius: var(--ms-radius-sm, 8px);
            font-size: 0.78rem;
            font-family: var(--ms-font-sans, Inter, sans-serif);
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-ink, #1c1917);
            cursor: pointer;
        }

        /* Result content tunes — the legacy render emits classes (.pc-step,
           .pc-step-number, .pc-rule-badge, .pc-sim-item, …) that come from
           percentage-calculator.css using site-theme tokens. Those tokens
           flip in dark mode but don't match math-studio's cream/dark
           surface, which made the result area invisible in some themes.
           The rules below re-skin those classes inside the math-studio
           result card using --ms-* tokens, which DO have proper light/dark
           variants. */
        #pc-result-content { padding: 1rem 1.25rem; min-height: 220px; }
        #pc-result-content .tool-empty-state,
        #pc-result-content .ic-empty-state {
            background: transparent !important;
            color: var(--ms-ink, #1c1917);
            padding: 2.25rem 1rem;
        }
        #pc-result-content .tool-empty-state h3,
        #pc-result-content .ic-empty-state h3 { color: var(--ms-ink, #1c1917); }
        #pc-result-content .tool-empty-state p,
        #pc-result-content .ic-empty-state p { color: var(--ms-muted, #78716c); }

        /* Step rows */
        #pc-result-content .pc-step {
            background: var(--ms-panel-bg-soft, #faf8f4);
            border-left-color: var(--ms-accent, #15803d);
            color: var(--ms-ink, #1c1917);
        }
        #pc-result-content .pc-step:hover {
            background: var(--ms-accent-soft, rgba(21,128,61,0.08));
        }
        #pc-result-content .pc-step-number {
            background: var(--ms-accent, #15803d);
            color: #fff;
        }
        #pc-result-content .pc-step-desc { color: var(--ms-ink, #1c1917); }
        #pc-result-content .pc-step-math { color: var(--ms-ink, #1c1917); }
        #pc-result-content .pc-step-math .katex { color: var(--ms-ink, #1c1917); }

        /* Rule badge ("Formula" pill etc.) */
        #pc-result-content .pc-rule-badge {
            background: var(--ms-accent, #15803d);
            color: #fff;
        }

        /* Discount-simulator items */
        #pc-result-content .pc-sim-item {
            background: var(--ms-panel-bg-soft, #faf8f4);
            color: var(--ms-ink, #1c1917);
        }
        #pc-result-content .pc-sim-item-label { color: var(--ms-muted, #78716c); }
        #pc-result-content .pc-sim-item-value { color: var(--ms-ink, #1c1917); }
        #pc-result-content .pc-sim-item.pc-sim-total {
            background: var(--ms-accent-soft, rgba(21,128,61,0.10));
            border-left: 3px solid var(--ms-accent, #15803d);
            color: var(--ms-ink, #1c1917);
        }

        /* Any heading or paragraph the renderer emits */
        #pc-result-content h2,
        #pc-result-content h3,
        #pc-result-content h4,
        #pc-result-content p,
        #pc-result-content strong,
        #pc-result-content span { color: var(--ms-ink, #1c1917); }
        #pc-result-content .katex { color: var(--ms-ink, #1c1917); }

        /* Mobile: shrink the mode pill bar so 8 chips wrap nicely */
        @media (max-width: 720px) {
            .pc-mode-bar .pc-mode-btn { padding: 0.35rem 0.55rem; font-size: 0.74rem; }
            .pc-input-row { grid-template-columns: 1fr; }
        }
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

        <% request.setAttribute("activeService", "percentage"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Percentage</span>
                </nav>
                <h1>Percentage Calculator &mdash; All 8 Formulas with Steps</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="ic-hero">

                    <!-- Mode pill bar -->
                    <div class="pc-mode-bar" role="radiogroup" aria-label="Percentage mode">
                        <span class="pc-mode-label">Mode</span>
                        <button type="button" class="pc-mode-btn active" data-mode="percentOf"     role="radio" aria-checked="true">% of</button>
                        <button type="button" class="pc-mode-btn"        data-mode="whatPercent"   role="radio" aria-checked="false">What %?</button>
                        <button type="button" class="pc-mode-btn"        data-mode="increaseBy"    role="radio" aria-checked="false">+ %</button>
                        <button type="button" class="pc-mode-btn"        data-mode="decreaseBy"    role="radio" aria-checked="false">&minus; %</button>
                        <button type="button" class="pc-mode-btn"        data-mode="percentChange" role="radio" aria-checked="false">% Change</button>
                        <button type="button" class="pc-mode-btn"        data-mode="reversePct"    role="radio" aria-checked="false">Reverse</button>
                        <button type="button" class="pc-mode-btn"        data-mode="discountSim"   role="radio" aria-checked="false">Discount</button>
                        <button type="button" class="pc-mode-btn"        data-mode="chain"         role="radio" aria-checked="false">Chain</button>
                    </div>

                    <!-- Per-mode formula hint (small grey snippet, updated by bridge IIFE) -->
                    <div class="pc-formula-hint" id="pc-formula-hint">
                        <code>X% of Y = (X / 100) &times; Y</code>
                    </div>

                    <!-- ───── Form: simple modes (percentOf / whatPercent / increaseBy / decreaseBy) ───── -->
                    <div class="pc-mode-form active" id="pc-form-simple">
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" id="pc-x-label" for="pc-x">X (percent)</label>
                                <input type="number" class="pc-input" id="pc-x" value="10" step="any" inputmode="decimal">
                            </div>
                            <div class="pc-input-group">
                                <label class="pc-input-label" id="pc-y-label" for="pc-y">Y (base)</label>
                                <input type="number" class="pc-input" id="pc-y" value="200" step="any" inputmode="decimal">
                            </div>
                        </div>
                        <div class="pc-form-hint" id="pc-simple-hint">Calculate X% of Y with step-by-step solution</div>
                    </div>

                    <!-- ───── Form: percent change ───── -->
                    <div class="pc-mode-form" id="pc-form-percentChange">
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-a">A (from)</label>
                                <input type="number" class="pc-input" id="pc-a" value="120" step="any" inputmode="decimal">
                            </div>
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-b">B (to)</label>
                                <input type="number" class="pc-input" id="pc-b" value="150" step="any" inputmode="decimal">
                            </div>
                        </div>
                        <div class="pc-form-hint">Percentage change from A to B</div>
                    </div>

                    <!-- ───── Form: reverse percentage ───── -->
                    <div class="pc-mode-form" id="pc-form-reversePct">
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-disc-pct">Discount %</label>
                                <input type="number" class="pc-input" id="pc-disc-pct" value="20" step="any" inputmode="decimal">
                            </div>
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-final-price">Final Price</label>
                                <input type="number" class="pc-input" id="pc-final-price" value="80" step="any" inputmode="decimal">
                            </div>
                        </div>
                        <div class="pc-form-hint">Find the original price before the discount</div>
                    </div>

                    <!-- ───── Form: discount + tax simulator ───── -->
                    <div class="pc-mode-form" id="pc-form-discountSim">
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-base-price">Base Price</label>
                                <input type="number" class="pc-input" id="pc-base-price" value="1000" step="any" inputmode="decimal">
                            </div>
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-disc-sim">Discount %</label>
                                <input type="number" class="pc-input" id="pc-disc-sim" value="15" step="any" inputmode="decimal">
                            </div>
                        </div>
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-tax-sim">Tax %</label>
                                <input type="number" class="pc-input" id="pc-tax-sim" value="5" step="any" inputmode="decimal">
                            </div>
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-qty">Quantity</label>
                                <input type="number" class="pc-input" id="pc-qty" value="1" step="1" min="1" inputmode="numeric">
                            </div>
                        </div>
                        <div class="pc-form-hint">Full breakdown: discount, tax, and total</div>
                    </div>

                    <!-- ───── Form: chained steps ───── -->
                    <div class="pc-mode-form" id="pc-form-chain">
                        <div class="pc-input-row" style="grid-template-columns: 1fr;">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-chain-start">Start Value</label>
                                <input type="number" class="pc-input" id="pc-chain-start" value="100" step="any" inputmode="decimal">
                            </div>
                        </div>
                        <div class="pc-input-row" style="grid-template-columns: 1fr;">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-chain-steps">Steps (comma-separated)</label>
                                <input type="text" class="pc-input-text" id="pc-chain-steps" value="+10%, -5%, +8%">
                            </div>
                        </div>
                        <div class="pc-form-hint">Use <code>+X%</code> or <code>-X%</code> for percentage steps; <code>+X</code> or <code>-X</code> for absolute amounts</div>
                    </div>

                    <!-- Legacy live-preview node — hidden but kept for core compatibility -->
                    <div id="pc-preview" aria-hidden="true"></div>

                    <!-- CTA + Clear (auto-calc covers the typing case; button is for explicit submit / Enter affordance) -->
                    <div class="pc-cta-row">
                        <button type="button" class="ic-hero-cta" id="pc-solve-btn">Calculate</button>
                        <button type="button" class="ic-clear-btn" id="pc-clear-btn" title="Reset to defaults">Clear</button>
                    </div>

                    <!-- Examples chips -->
                    <div style="margin-top: 0.85rem;">
                        <div style="font-size: 0.7rem; font-weight: 600; color: var(--ms-muted, #78716c); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.4rem;">Examples</div>
                        <div class="pc-examples">
                            <button type="button" class="pc-example-chip" data-example="pct-of">25% of 200</button>
                            <button type="button" class="pc-example-chip" data-example="what-pct">45 of 180</button>
                            <button type="button" class="pc-example-chip" data-example="increase">500 + 15%</button>
                            <button type="button" class="pc-example-chip" data-example="decrease">800 &minus; 20%</button>
                            <button type="button" class="pc-example-chip" data-example="change">120 &rarr; 150</button>
                            <button type="button" class="pc-example-chip" data-example="reverse">$75 after 25% off</button>
                            <button type="button" class="pc-example-chip" data-example="discount">Cart: 1000 &times; 2 + tax</button>
                            <button type="button" class="pc-example-chip" data-example="chain">+10%, &minus;5%, +8%</button>
                        </div>
                    </div>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs pc-output-tabs" role="tablist">
                        <button type="button" class="ic-output-tab pc-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                        <button type="button" class="ic-output-tab pc-output-tab"        data-panel="python" role="tab" aria-selected="false">Python Compiler</button>
                    </div>

                    <!-- Result panel -->
                    <div class="ic-panel pc-panel active" id="pc-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="pc-result-content">
                                <div class="tool-empty-state ic-empty-state" id="pc-empty-state">
                                    <div class="ic-empty-illustration">%</div>
                                    <h3>Enter values to calculate</h3>
                                    <p>Pick a mode above and the result updates as you type. Try one of the examples to see a worked solution.</p>
                                </div>
                            </div>
                            <div class="tool-result-actions" id="pc-result-actions" style="display:none;">
                                <button type="button" class="tool-action-btn" id="pc-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="pc-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="pc-worksheet-btn-toolbar">Worksheet</button>
                            </div>

                            <!-- Practice worksheet CTA — 1,500-problem CAS-verified
                                 percentages bank covering NCERT Class 7-8 commercial
                                 math (profit/loss, discount, tax, CI, partnership)
                                 plus alligation, geometry % change, JEE classics. -->
                            <div class="ic-worksheet-cta" style="padding:0.75rem 1rem;">
                                <button type="button" class="tool-action-btn" id="pc-worksheet-btn"
                                        style="width:100%;font-weight:600;">
                                    Practice Worksheet &mdash; 1,500+ percentage &amp; commercial-math problems with answer key
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Python Compiler panel -->
                    <div class="ic-panel pc-panel" id="pc-panel-python" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="display:flex;align-items:center;gap:0.6rem;padding:0.75rem 1rem;border-bottom:1px solid var(--ms-line, rgba(0,0,0,0.08));">
                                <strong style="font-size:0.85rem;color:var(--ms-ink-soft, #44403c);">Python template</strong>
                                <select id="pc-compiler-template">
                                    <option value="basic-pct">Basic Percentage</option>
                                    <option value="discount-sim">Discount Simulator</option>
                                    <option value="chain-steps">Chain Steps</option>
                                </select>
                            </div>
                            <div style="flex:1;min-height:0;">
                                <iframe id="pc-compiler-iframe" loading="lazy" title="Python compiler" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- Method-at-a-glance cards -->
            <section class="ic-learn" aria-label="Percentage formulas">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">% of</span>
                    <code class="ic-learn-formula">X% of Y = (X / 100) &times; Y</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">% change</span>
                    <code class="ic-learn-formula">((B &minus; A) / A) &times; 100%</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Reverse</span>
                    <code class="ic-learn-formula">Original = Final / (1 &minus; Disc% / 100)</code>
                </article>
            </section>

            <section class="ic-related-strip" style="margin-top:2rem;display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:0.75rem;">
                <a href="<%=request.getContextPath()%>/exponent-calculator.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Powers</div>
                    <div style="font-weight:600;">Exponent Calculator &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">All 8 laws of exponents with steps.</div>
                </a>
                <a href="<%=request.getContextPath()%>/significant-figures-calculator.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Rounding</div>
                    <div style="font-weight:600;">Significant Figures &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">Round to N sig figs with rule explanations.</div>
                </a>
                <a href="<%=request.getContextPath()%>/logarithm-calculator.jsp" class="tool-card" style="padding:1rem;text-decoration:none;color:inherit;border-left:3px solid var(--ms-accent,#15803d);">
                    <div style="font-size:0.72rem;font-weight:600;color:var(--ms-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.25rem;">Logs</div>
                    <div style="font-weight:600;">Logarithm Calculator &rarr;</div>
                    <div style="font-size:0.85rem;color:var(--ms-ink-soft);margin-top:0.2rem;">Compute logs with step-by-step solutions.</div>
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
        <div class="ms-faq" aria-label="Percentage calculator FAQ">
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you calculate a percentage of a number?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">To find <em>X%</em> of <em>Y</em>, multiply <em>Y</em> by <em>X / 100</em>. For example, 25% of 200 = (25 / 100) &times; 200 = 0.25 &times; 200 = 50. The formula is <strong>Result = (X / 100) &times; Y</strong>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you calculate percent change between two numbers?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Percent change = <em>((B &minus; A) / A) &times; 100</em>. For example, going from 120 to 150 gives ((150 &minus; 120) / 120) &times; 100 = <strong>+25%</strong> increase. A negative result means a decrease.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">How do you find the original price before a discount?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Divide the final price by <em>1 &minus; (Discount% / 100)</em>. If the final price is $75 after a 25% discount, the original is $75 / 0.75 = <strong>$100</strong>. Formula: <strong>Original = Final / (1 &minus; Disc% / 100)</strong>.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Why don't chained percentages add up simply?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Each step applies to the running total, not the original. Starting at 100: <em>+10%</em> gives 110, then <em>&minus;10%</em> gives 99 (not 100). The second step uses 110 as its base, so <em>+X%</em> followed by <em>&minus;X%</em> never returns to the start.</div>
            </div>
            <div class="ms-faq-item">
                <button type="button" class="ms-faq-q">Is this percentage calculator free?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="ms-faq-a">Yes &mdash; 100% free with no signup. You get 8 calculation modes with step-by-step KaTeX solutions, a discount + tax simulator, chained steps, a Python compiler, LaTeX export, and shareable URLs. All computation runs in your browser.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Core scripts — KaTeX + tool-utils + render/export/core (legacy, unchanged) -->
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js" defer></script>
    <script src="<%=request.getContextPath()%>/js/percentage-calculator-render.js" defer></script>
    <script src="<%=request.getContextPath()%>/js/percentage-calculator-export.js" defer></script>
    <script src="<%=request.getContextPath()%>/js/percentage-calculator-core.js" defer></script>

    <!--
        Bridge IIFE — adds two non-invasive UX layers without touching the legacy core:
          1. Live result on input — debounced, calls the existing #pc-solve-btn.click()
             so the legacy core's calculate() runs after each keystroke / mode change.
          2. Per-mode formula hint — updates the small grey snippet above the inputs
             when the user picks a different mode.
    -->
    <script>
    (function(){
        'use strict';
        var FORMULA = {
            percentOf:     'X% of Y = (X / 100) × Y',
            whatPercent:   '(X / Y) × 100 = ?%',
            increaseBy:    'Y × (1 + X / 100)',
            decreaseBy:    'Y × (1 − X / 100)',
            percentChange: '((B − A) / A) × 100%',
            reversePct:    'Original = Final / (1 − Disc% / 100)',
            discountSim:   '(Price − Discount) + Tax',
            chain:         'Apply each ±X% to the running total'
        };

        function ready(fn){
            if (document.readyState !== 'loading') fn();
            else document.addEventListener('DOMContentLoaded', fn);
        }

        ready(function(){
            var solveBtn = document.getElementById('pc-solve-btn');
            var hint = document.getElementById('pc-formula-hint');

            function setHint(mode){
                if (!hint) return;
                var f = FORMULA[mode] || FORMULA.percentOf;
                hint.innerHTML = '<code>' + f + '</code>';
            }

            function activeMode(){
                var btn = document.querySelector('.pc-mode-bar .pc-mode-btn.active');
                return btn ? btn.getAttribute('data-mode') : 'percentOf';
            }

            // Debounced auto-calc — waits ~250ms of typing inactivity then re-runs
            // the existing legacy calculate() via the Solve button click.
            var t = null;
            function autoCalc(){
                if (!solveBtn) return;
                clearTimeout(t);
                t = setTimeout(function(){ solveBtn.click(); }, 250);
            }

            // Attach to all numeric / text inputs
            var inputs = document.querySelectorAll('.pc-input, .pc-input-text');
            for (var i = 0; i < inputs.length; i++) {
                inputs[i].addEventListener('input', autoCalc);
            }

            // Mode-pill clicks: legacy switchMode() runs first (its own listener),
            // then we update the hint and trigger an auto-calc on the new fields.
            var modeBtns = document.querySelectorAll('.pc-mode-bar .pc-mode-btn');
            for (var m = 0; m < modeBtns.length; m++) {
                modeBtns[m].addEventListener('click', function(){
                    setHint(this.getAttribute('data-mode'));
                    autoCalc();
                });
            }

            // Initial hint reflects the default-active mode
            setHint(activeMode());

            // Run an initial calculation so users see a populated result on load
            // (instead of the empty state) — matches the "live preview" intent.
            // Defer to next tick so legacy core has finished init.
            setTimeout(function(){ if (solveBtn) solveBtn.click(); }, 100);
        });
    })();
    </script>

    <!-- FAQ accordion — math-studio standard -->
    <script>
    (function(){
        var qs = document.querySelectorAll('.ms-faq-q');
        for (var i = 0; i < qs.length; i++) {
            qs[i].addEventListener('click', function(){
                var item = this.parentElement;
                if (item) item.classList.toggle('open');
            });
        }
    })();
    </script>

    <!-- ─── Practice worksheet — 1,500-problem CAS-verified percentages bank ─── -->
    <script src="<%=request.getContextPath()%>/js/worksheet-engine.js?v=<%=v%>"></script>
    <script>
    (function () {
        function openPercentageWorksheet() {
            if (!window.WorksheetEngine || typeof window.WorksheetEngine.open !== 'function') {
                if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
                    ToolUtils.showToast('Worksheet engine not loaded', 2500, 'warning');
                }
                return;
            }
            window.WorksheetEngine.open({
                jsonUrl: '<%=request.getContextPath()%>/worksheet/math/algebra/percentages.json',
                title: 'Percentages & Commercial Math',
                accentColor: '#0e7490',
                branding: '8gwifi.org',
                defaultCount: 20
            });
        }
        function whenReady(fn) {
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', fn);
            } else { fn(); }
        }
        whenReady(function () {
            var primary = document.getElementById('pc-worksheet-btn');
            if (primary) primary.addEventListener('click', openPercentageWorksheet);
            var toolbar = document.getElementById('pc-worksheet-btn-toolbar');
            if (toolbar) toolbar.addEventListener('click', openPercentageWorksheet);
        });
    })();
    </script>

</body>
</html>
