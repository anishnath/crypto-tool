<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Significant Figures Calculator — math-studio shell.

        Migrated to match the trig calculator pages (sidebar, ic-stack,
        ic-hero, ic-result-card, ic-mode-toggle).  Sig-figs is a pure
        rules-engine: no MathLive (inputs are plain numeric strings —
        "1.23e5" would mis-render in Visual mode), no AI compute (rules
        are deterministic), no SymPy (no symbolic computation needed).
        All ~700 lines of compute JS preserved verbatim — only the
        outer shell + mode-toggle selector changed.

        Six modes: Count / Arithmetic / Round / Scientific / Expression /
        Practice.  All inputs and onclick handlers preserved by ID.
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow,max-image-preview:large,max-snippet:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Sig Fig Calculator - Count, Round, Convert with Steps" />
        <jsp:param name="toolDescription" value="Free sig fig calculator with step-by-step solutions. Count significant figures, round to N digits, perform arithmetic with proper rules, convert to scientific notation, and evaluate multi-step expressions. Pure deterministic rules — no AI, instant results." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="significant-figures-calculator.jsp" />
        <jsp:param name="toolKeywords" value="significant figures calculator, sig figs calculator, significant digits, sig fig counter, scientific notation, chemistry calculator, rounding sig figs, sig fig rules, sig fig arithmetic, expression evaluator sig figs" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Count significant figures in any number,Addition and subtraction with sig fig rules,Multiplication and division with sig fig rules,Round to any number of sig figs,Convert to scientific notation,Multi-step expression evaluator with sig figs,Step-by-step explanations citing each rule,Color-coded digit display,Practice quiz mode,Free no signup no limits" />
        <jsp:param name="teaches" value="Significant figures rules, scientific notation, rounding for precision, arithmetic with measurement uncertainty" />
        <jsp:param name="educationalLevel" value="Middle School, High School, College" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Pick a mode|Choose Count to count sig figs OR Arithmetic for + - × ÷ with sig fig rules OR Round to a target precision OR Scientific to convert OR Expression for multi-step OR Practice for a quick quiz.,Enter your number|Type any number including scientific notation (e.g. 1.23e5).,Click Calculate|Step-by-step explanation renders with each rule cited.,Read the rules|Each step links the result to a named sig-fig rule (leading zeros, trailing zeros, decimal places, etc.).,Copy or share|Copy the result text or share the URL." />
        <jsp:param name="faq1q" value="What are significant figures?" />
        <jsp:param name="faq1a" value="Significant figures (sig figs) are the digits in a number that carry meaning contributing to its measurement precision. All non-zero digits are significant, trapped zeros between non-zero digits are significant, leading zeros are not significant, and trailing zeros after a decimal point are significant." />
        <jsp:param name="faq2q" value="How do you count significant figures?" />
        <jsp:param name="faq2a" value="Follow five rules: (1) All non-zero digits are significant. (2) Trapped zeros between non-zero digits are significant. (3) Leading zeros are NOT significant. (4) Trailing zeros after a decimal point ARE significant. (5) Trailing zeros in a whole number without a decimal point are ambiguous." />
        <jsp:param name="faq3q" value="What are the sig fig rules for addition and subtraction?" />
        <jsp:param name="faq3a" value="For addition and subtraction, the result should be rounded to the same number of decimal places as the measurement with the fewest decimal places. For example, 12.34 + 5.6 = 17.9 (rounded to 1 decimal place, matching 5.6)." />
        <jsp:param name="faq4q" value="What are the sig fig rules for multiplication and division?" />
        <jsp:param name="faq4a" value="For multiplication and division, the result should be rounded to the same number of significant figures as the measurement with the fewest sig figs. For example, 12.34 times 5.6 = 69 (2 sig figs, matching 5.6 which has 2 sig figs)." />
        <jsp:param name="faq5q" value="How do trailing zeros affect significant figures?" />
        <jsp:param name="faq5a" value="Trailing zeros after a decimal point are always significant (e.g., 1.200 has 4 sig figs). Trailing zeros in a whole number without a decimal point are ambiguous (e.g., 1200 could have 2, 3, or 4 sig figs). Use scientific notation to clarify: 1.20 times 10 cubed = 3 sig figs." />
        <jsp:param name="faq6q" value="How do you round to a specific number of significant figures?" />
        <jsp:param name="faq6a" value="To round to n significant figures, identify the nth significant digit, look at the digit after it, and round up if it is 5 or greater. For example, 123.456 rounded to 3 sig figs becomes 123, and 0.004567 rounded to 2 sig figs becomes 0.0046." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <!-- Shared site CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">

    <!-- Math shell -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=cacheVersion%>">

    <style>
    /* ─── Sig-fig-specific styles (preserved from legacy page) ─── */

    /* Mode-section visibility (we re-use ic-mode-toggle for the chips) */
    .sf-section { display: none; }
    .sf-section.active { display: block; }

    /* Example chips inside each mode panel */
    .example-chip {
        display: inline-block;
        margin: 3px;
        padding: 5px 10px;
        background: var(--ms-surface-2, #f8fafc);
        border: 1px solid var(--ms-border, #e2e8f0);
        border-radius: 9999px;
        cursor: pointer;
        font-size: 0.8rem;
        font-family: var(--font-mono);
        transition: all 0.15s;
        color: var(--ms-ink, #0f172a);
    }
    .example-chip:hover {
        background: var(--ms-tool-light, #eff6ff);
        border-color: var(--ms-tool, #3b82f6);
        color: var(--ms-tool, #3b82f6);
    }
    .example-category-label {
        font-weight: 600;
        font-size: 0.75rem;
        color: var(--ms-muted, #475569);
        margin-top: 0.75rem;
        margin-bottom: 0.375rem;
        padding-bottom: 0.25rem;
        border-bottom: 1px solid var(--ms-border, #e2e8f0);
        text-transform: uppercase;
        letter-spacing: 0.04em;
    }
    .example-category-label:first-child { margin-top: 0; }

    /* Result badges */
    .result-badge { background: #10b981; color: #fff; padding: 3px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: 600; letter-spacing: 0.03em; }
    .step-badge   { background: #8b5cf6; color: #fff; padding: 3px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: 600; letter-spacing: 0.03em; }
    .sig-badge    { background: #3b82f6; color: #fff; padding: 3px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: 600; letter-spacing: 0.03em; }

    /* Color-coded number display (THE pedagogical centrepiece) */
    .number-display {
        font-family: var(--font-mono);
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--ms-ink, #1f2937);
        background: var(--ms-surface-3, #f3f4f6);
        padding: 0.75rem 1rem;
        border-radius: 0.5rem;
        margin: 0.75rem 0;
        word-break: break-all;
    }
    .sig-digit { color: #059669; font-weight: 700; }
    .non-sig-digit { color: #9ca3af; }

    /* Result and step blocks */
    .result-section {
        background: var(--ms-surface-2, #f9fafb);
        border-left: 4px solid #3b82f6;
        padding: 1rem 1.25rem;
        margin-top: 1rem;
        border-radius: 0 0.5rem 0.5rem 0;
    }
    .result-section h4 { margin: 0 0 0.75rem; color: var(--ms-ink, #1f2937); }
    .result-section h6 { margin: 0 0 0.5rem; }
    .result-section hr { border: none; border-top: 1px solid var(--ms-border, #e5e7eb); margin: 0.75rem 0; }
    .result-section p { margin: 0.25rem 0; font-size: 0.875rem; color: var(--ms-muted, #475569); }
    .step-section {
        background: var(--ms-surface, #fff);
        border: 1px solid var(--ms-border, #e5e7eb);
        padding: 0.75rem 1rem;
        margin- top: 0.5rem;
        border-radius: 0.375rem;
    }
    .step-section p { margin: 0.25rem 0; font-size: 0.875rem; color: var(--ms-muted, #475569); }
    .step-section .indent { padding-left: 1rem; }

    .info-box {
        background: var(--ms-tool-light, #eff6ff);
        border-left: 4px solid #3b82f6;
        padding: 0.75rem 1rem;
        margin: 0.75rem 0;
        border-radius: 0 0.375rem 0.375rem 0;
    }
    .info-box p { margin: 0; font-size: 0.875rem; color: var(--ms-muted, #475569); }
    .rule-box {
        background: rgba(16,185,129,0.08);
        border-left: 4px solid #059669;
        padding: 0.75rem 1rem;
        margin: 0.75rem 0;
        border-radius: 0 0.375rem 0.375rem 0;
    }
    .rule-box p { margin: 0.25rem 0; font-size: 0.875rem; color: var(--ms-muted, #475569); }

    /* Expression-mode input */
    .expr-input {
        width: 100%;
        padding: 0.625rem 0.75rem;
        border: 1.5px solid var(--ms-border, #e2e8f0);
        border-radius: 0.5rem;
        font-size: 1rem;
        font-family: var(--font-mono);
        background: var(--ms-surface, #fff);
        color: var(--ms-ink, #0f172a);
        transition: border-color 0.15s, box-shadow 0.15s;
    }
    .expr-input:focus {
        outline: none;
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
    }

    /* Practice quiz */
    .quiz-question {
        background: var(--ms-surface-2, #f8fafc);
        border: 1px solid var(--ms-border, #e2e8f0);
        border-radius: 0.5rem;
        padding: 0.875rem 1rem;
        margin-bottom: 0.75rem;
    }
    .quiz-question-text { font-weight: 600; font-size: 0.875rem; color: var(--ms-ink); margin-bottom: 0.5rem; }
    .quiz-number { font-family: var(--font-mono); font-size: 1.1rem; font-weight: 700; color: #3b82f6; }
    .quiz-options { display: flex; gap: 0.375rem; flex-wrap: wrap; }
    .quiz-option {
        padding: 0.375rem 0.75rem;
        border: 1.5px solid var(--ms-border, #e2e8f0);
        border-radius: 9999px;
        background: var(--ms-surface, #fff);
        color: var(--ms-ink, #0f172a);
        font-size: 0.8125rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.15s;
    }
    .quiz-option:hover { border-color: #3b82f6; background: var(--ms-tool-light, #eff6ff); }
    .quiz-option.correct { border-color: #10b981; background: rgba(16,185,129,0.15); color: #10b981; font-weight: 600; }
    .quiz-option.wrong { border-color: #ef4444; background: rgba(239,68,68,0.1); color: #ef4444; text-decoration: line-through; }
    .quiz-option.disabled { pointer-events: none; opacity: 0.6; }
    .quiz-feedback { margin-top: 0.5rem; font-size: 0.8125rem; font-weight: 500; display: none; }
    .quiz-feedback.show { display: block; }
    .quiz-feedback.correct-fb { color: #10b981; }
    .quiz-feedback.wrong-fb { color: #ef4444; }
    .quiz-score {
        text-align: center;
        padding: 0.75rem;
        background: var(--ms-tool-light, #eff6ff);
        border-radius: 0.5rem;
        font-weight: 600;
        font-size: 0.9375rem;
        color: #1d4ed8;
        margin-top: 0.5rem;
    }

    /* Show actions only after first calculate */
    .tool-result-actions { display: none; }
    .tool-result-actions.visible { display: flex; gap: 0.5rem; padding: 1rem 1.25rem;
        border-top: 1px solid var(--ms-border, #e2e8f0); flex-wrap: wrap; }
    .tool-result-actions .tool-action-btn { flex: 1; min-width: 90px; }

    /* Dark-mode tweaks for sig-fig elements */
    [data-theme="dark"] .example-chip { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.15); color: var(--ms-ink, #e2e8f0); }
    [data-theme="dark"] .example-chip:hover { background: rgba(59,130,246,0.15); border-color: #3b82f6; color: #60a5fa; }
    [data-theme="dark"] .example-category-label { color: var(--ms-muted, #94a3b8); border-bottom-color: var(--ms-border, #334155); }
    [data-theme="dark"] .number-display { background: var(--ms-surface-3, #334155); color: var(--ms-ink, #f1f5f9); }
    [data-theme="dark"] .result-section { background: var(--ms-surface-3, #334155); }
    [data-theme="dark"] .result-section h4 { color: var(--ms-ink, #f1f5f9); }
    [data-theme="dark"] .step-section { background: var(--ms-surface-2, #1e293b); border-color: var(--ms-border, #334155); }
    [data-theme="dark"] .info-box { background: rgba(59,130,246,0.12); }
    [data-theme="dark"] .rule-box { background: rgba(16,185,129,0.12); }
    [data-theme="dark"] .expr-input { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.15); color: var(--ms-ink, #e2e8f0); }
    [data-theme="dark"] .quiz-question { background: rgba(255,255,255,0.05); border-color: var(--ms-border, #334155); }
    [data-theme="dark"] .quiz-option { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.15); color: var(--ms-ink, #e2e8f0); }
    [data-theme="dark"] .quiz-score { background: rgba(59,130,246,0.15); color: #93c5fd; }

    /* Tool-action-btn (compact form) for the in-panel Calculate buttons */
    .sf-action-btn {
        width: 100%;
        padding: 0.7rem 1rem;
        font-weight: 600;
        font-size: 0.9rem;
        border: none;
        border-radius: 0.5rem;
        cursor: pointer;
        background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
        color: #fff;
        margin-top: 1rem;
        transition: opacity .15s, transform .15s;
    }
    .sf-action-btn:hover { opacity: 0.92; }

    /* Re-style the inline native select to match math-studio inputs */
    .sf-select {
        width: 100%;
        padding: 0.55rem 0.7rem;
        border: 1px solid var(--ms-border, #e2e8f0);
        border-radius: 0.5rem;
        background: var(--ms-surface, #fff);
        color: var(--ms-ink, #0f172a);
        font-family: var(--font-sans);
        font-size: 0.9rem;
        cursor: pointer;
    }
    [data-theme="dark"] .sf-select { background: var(--ms-surface-2, #1e293b); border-color: var(--ms-border, #334155); color: var(--ms-ink, #f1f5f9); }

    /* Generic compact text input */
    .sf-input {
        width: 100%;
        padding: 0.55rem 0.7rem;
        border: 1.5px solid var(--ms-border, #e2e8f0);
        border-radius: 0.5rem;
        background: var(--ms-surface, #fff);
        color: var(--ms-ink, #0f172a);
        font-family: var(--font-mono);
        font-size: 0.95rem;
        transition: border-color 0.15s, box-shadow 0.15s;
    }
    .sf-input:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.15); }
    [data-theme="dark"] .sf-input { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.15); color: var(--ms-ink, #e2e8f0); }

    .sf-form-group { margin-bottom: 0.85rem; }
    .sf-form-group > label {
        display: block; font-weight: 500; font-size: 0.8125rem;
        margin-bottom: 0.3rem; color: var(--ms-ink, #0f172a);
    }
    [data-theme="dark"] .sf-form-group > label { color: var(--ms-ink, #f1f5f9); }
    .sf-form-hint { font-size: 0.7rem; color: var(--ms-muted, #475569); margin-top: 0.25rem; }
    </style>

    <%@ include file="modern/ads/ad-init.jsp" %>
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

        <% request.setAttribute("activeService", "sig-figs"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Significant Figures</span>
                </nav>
                <h1>Significant Figures Calculator</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero">

                    <!-- 5-mode chip rail (Calculate is the default smart
                         input — handles single numbers AND expressions
                         including functions like log, sqrt, ^, pi). -->
                    <div class="ic-mode-toggle" role="radiogroup" aria-label="Sig fig calculator mode" style="flex-wrap:wrap;">
                        <button type="button" class="ic-mode-btn sf-mode-btn active" data-mode="expression" role="radio" aria-checked="true"  title="Numbers, arithmetic, log, sqrt, ^, pi — type anything">&#129518; Calculate</button>
                        <button type="button" class="ic-mode-btn sf-mode-btn"        data-mode="count"      role="radio" aria-checked="false" title="Count sig figs in a single number with color-coded digits">&#128290; Count</button>
                        <button type="button" class="ic-mode-btn sf-mode-btn"        data-mode="round"      role="radio" aria-checked="false" title="Round to N sig figs">&#128260; Round</button>
                        <button type="button" class="ic-mode-btn sf-mode-btn"        data-mode="notation"   role="radio" aria-checked="false" title="Convert to scientific notation">&#128300; Scientific</button>
                        <button type="button" class="ic-mode-btn sf-mode-btn"        data-mode="practice"   role="radio" aria-checked="false" title="Practice quiz">&#127891; Practice</button>
                    </div>

                    <!-- ═══ Mode 1: Count ═══ -->
                    <div id="countSection" class="sf-section">
                        <div class="sf-form-group">
                            <label for="countNumber">Number</label>
                            <input type="text" id="countNumber" class="sf-input" placeholder="e.g., 0.00450, 1200, 3.140" inputmode="decimal" autocomplete="off" spellcheck="false">
                            <p class="sf-form-hint">Enter any number including scientific notation (e.g., 1.23e5)</p>
                        </div>
                        <button type="button" class="sf-action-btn" onclick="countSigFigs()">Count significant figures</button>

                        <div class="ic-method-row" style="margin:0.5rem 0 0.25rem;">
                            <span class="ic-method-label">Try one</span>
                            <span class="example-chip" onclick="setCountExample('0.00450')">0.00450</span>
                            <span class="example-chip" onclick="setCountExample('1200')">1200</span>
                            <span class="example-chip" onclick="setCountExample('1.0023')">1.0023</span>
                            <span class="example-chip" onclick="setCountExample('1.23e5')">1.23&times;10&#8309;</span>
                        </div>
                        <details class="ic-hero-methods">
                            <summary class="ic-hero-methods-summary"><span>More examples</span><svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></summary>
                            <div class="ic-hero-methods-body">
                                <div class="example-category-label">Leading zeros</div>
                                <span class="example-chip" onclick="setCountExample('0.00450')">0.00450</span>
                                <span class="example-chip" onclick="setCountExample('0.0123')">0.0123</span>
                                <span class="example-chip" onclick="setCountExample('0.500')">0.500</span>
                                <div class="example-category-label">Trailing zeros</div>
                                <span class="example-chip" onclick="setCountExample('1200')">1200</span>
                                <span class="example-chip" onclick="setCountExample('1200.')">1200.</span>
                                <span class="example-chip" onclick="setCountExample('1200.0')">1200.0</span>
                                <span class="example-chip" onclick="setCountExample('120')">120</span>
                                <div class="example-category-label">Trapped zeros</div>
                                <span class="example-chip" onclick="setCountExample('1002')">1002</span>
                                <span class="example-chip" onclick="setCountExample('50.03')">50.03</span>
                                <span class="example-chip" onclick="setCountExample('1.0023')">1.0023</span>
                                <div class="example-category-label">Scientific notation</div>
                                <span class="example-chip" onclick="setCountExample('1.23e5')">1.23&times;10&#8309;</span>
                                <span class="example-chip" onclick="setCountExample('4.500e-3')">4.500&times;10&#8315;&#179;</span>
                                <span class="example-chip" onclick="setCountExample('6.02e23')">6.02&times;10&#178;&#179;</span>
                            </div>
                        </details>
                    </div>

                    <!-- ═══ Mode 2: Arithmetic ═══ -->
                    <div id="arithmeticSection" class="sf-section">
                        <div class="sf-form-group">
                            <label for="arithmeticOp">Operation</label>
                            <select id="arithmeticOp" class="sf-select">
                                <option value="add">Addition (+)</option>
                                <option value="subtract">Subtraction (&minus;)</option>
                                <option value="multiply">Multiplication (&times;)</option>
                                <option value="divide">Division (&divide;)</option>
                            </select>
                        </div>
                        <div class="sf-form-group">
                            <label for="arithmeticNum1">First number</label>
                            <input type="text" id="arithmeticNum1" class="sf-input" placeholder="e.g., 12.34" inputmode="decimal" autocomplete="off" spellcheck="false">
                        </div>
                        <div class="sf-form-group">
                            <label for="arithmeticNum2">Second number</label>
                            <input type="text" id="arithmeticNum2" class="sf-input" placeholder="e.g., 5.6" inputmode="decimal" autocomplete="off" spellcheck="false">
                        </div>
                        <button type="button" class="sf-action-btn" onclick="calculateArithmetic()">Calculate with sig figs</button>

                        <div class="ic-method-row" style="margin:0.5rem 0 0.25rem;">
                            <span class="ic-method-label">Try one</span>
                            <span class="example-chip" onclick="setArithmeticExample('add', '12.34', '5.6')">12.34 + 5.6</span>
                            <span class="example-chip" onclick="setArithmeticExample('subtract', '1000', '5.5')">1000 &minus; 5.5</span>
                            <span class="example-chip" onclick="setArithmeticExample('multiply', '12.34', '5.6')">12.34 &times; 5.6</span>
                            <span class="example-chip" onclick="setArithmeticExample('divide', '100', '3.0')">100 &divide; 3.0</span>
                        </div>
                        <details class="ic-hero-methods">
                            <summary class="ic-hero-methods-summary"><span>More examples</span><svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></summary>
                            <div class="ic-hero-methods-body">
                                <div class="example-category-label">Addition</div>
                                <span class="example-chip" onclick="setArithmeticExample('add', '12.34', '5.6')">12.34 + 5.6</span>
                                <span class="example-chip" onclick="setArithmeticExample('add', '100.5', '23.456')">100.5 + 23.456</span>
                                <div class="example-category-label">Subtraction</div>
                                <span class="example-chip" onclick="setArithmeticExample('subtract', '45.67', '12.3')">45.67 &minus; 12.3</span>
                                <span class="example-chip" onclick="setArithmeticExample('subtract', '1000', '5.5')">1000 &minus; 5.5</span>
                                <div class="example-category-label">Multiplication</div>
                                <span class="example-chip" onclick="setArithmeticExample('multiply', '12.34', '5.6')">12.34 &times; 5.6</span>
                                <span class="example-chip" onclick="setArithmeticExample('multiply', '0.0045', '123')">0.0045 &times; 123</span>
                                <div class="example-category-label">Division</div>
                                <span class="example-chip" onclick="setArithmeticExample('divide', '45.67', '12.3')">45.67 &divide; 12.3</span>
                                <span class="example-chip" onclick="setArithmeticExample('divide', '100', '3.0')">100 &divide; 3.0</span>
                            </div>
                        </details>
                    </div>

                    <!-- ═══ Mode 3: Round ═══ -->
                    <div id="roundSection" class="sf-section">
                        <div class="sf-form-group">
                            <label for="roundNumber">Number to round</label>
                            <input type="text" id="roundNumber" class="sf-input" placeholder="e.g., 123.4567" inputmode="decimal" autocomplete="off" spellcheck="false">
                        </div>
                        <div class="sf-form-group">
                            <label for="roundSigFigs">Target significant figures</label>
                            <input type="number" id="roundSigFigs" class="sf-input" placeholder="e.g., 3" min="1" max="10">
                        </div>
                        <button type="button" class="sf-action-btn" onclick="roundToSigFigs()">Round number</button>

                        <div class="ic-method-row" style="margin:0.5rem 0 0.25rem;">
                            <span class="ic-method-label">Try one</span>
                            <span class="example-chip" onclick="setRoundExample('123.456', 3)">123.456 &rarr; 3</span>
                            <span class="example-chip" onclick="setRoundExample('0.004567', 2)">0.004567 &rarr; 2</span>
                            <span class="example-chip" onclick="setRoundExample('12345', 3)">12345 &rarr; 3</span>
                            <span class="example-chip" onclick="setRoundExample('45.678', 4)">45.678 &rarr; 4</span>
                        </div>
                        <details class="ic-hero-methods">
                            <summary class="ic-hero-methods-summary"><span>More examples</span><svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></summary>
                            <div class="ic-hero-methods-body">
                                <div class="example-category-label">Basic</div>
                                <span class="example-chip" onclick="setRoundExample('123.456', 3)">123.456 &rarr; 3</span>
                                <span class="example-chip" onclick="setRoundExample('0.004567', 2)">0.004567 &rarr; 2</span>
                                <div class="example-category-label">Large numbers</div>
                                <span class="example-chip" onclick="setRoundExample('12345', 3)">12345 &rarr; 3</span>
                                <span class="example-chip" onclick="setRoundExample('98765', 2)">98765 &rarr; 2</span>
                                <div class="example-category-label">Decimal numbers</div>
                                <span class="example-chip" onclick="setRoundExample('45.678', 4)">45.678 &rarr; 4</span>
                                <span class="example-chip" onclick="setRoundExample('0.123456', 3)">0.123456 &rarr; 3</span>
                            </div>
                        </details>
                    </div>

                    <!-- ═══ Mode 4: Scientific Notation ═══ -->
                    <div id="notationSection" class="sf-section">
                        <div class="sf-form-group">
                            <label for="notationNumber">Number</label>
                            <input type="text" id="notationNumber" class="sf-input" placeholder="e.g., 0.00456 or 1.23e-5" inputmode="decimal" autocomplete="off" spellcheck="false">
                        </div>
                        <div class="sf-form-group">
                            <label for="notationSigFigs">Significant figures (optional)</label>
                            <input type="number" id="notationSigFigs" class="sf-input" placeholder="Leave blank for auto">
                        </div>
                        <button type="button" class="sf-action-btn" onclick="convertNotation()">Convert to scientific notation</button>

                        <div class="ic-method-row" style="margin:0.5rem 0 0.25rem;">
                            <span class="ic-method-label">Try one</span>
                            <span class="example-chip" onclick="setNotationExample('0.00456')">0.00456</span>
                            <span class="example-chip" onclick="setNotationExample('123000')">123000</span>
                            <span class="example-chip" onclick="setNotationExample('6020000000000000000000000')">Avogadro's</span>
                            <span class="example-chip" onclick="setNotationExample('1.23e5')">1.23&times;10&#8309;</span>
                        </div>
                        <details class="ic-hero-methods">
                            <summary class="ic-hero-methods-summary"><span>More examples</span><svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></summary>
                            <div class="ic-hero-methods-body">
                                <div class="example-category-label">Small numbers</div>
                                <span class="example-chip" onclick="setNotationExample('0.00456')">0.00456</span>
                                <span class="example-chip" onclick="setNotationExample('0.0000789')">0.0000789</span>
                                <div class="example-category-label">Large numbers</div>
                                <span class="example-chip" onclick="setNotationExample('123000')">123000</span>
                                <span class="example-chip" onclick="setNotationExample('6020000000000000000000000')">Avogadro's</span>
                                <div class="example-category-label">Already scientific</div>
                                <span class="example-chip" onclick="setNotationExample('1.23e5')">1.23&times;10&#8309;</span>
                                <span class="example-chip" onclick="setNotationExample('4.5e-3')">4.5&times;10&#8315;&#179;</span>
                            </div>
                        </details>
                    </div>

                    <!-- ═══ Default mode: Calculate (smart) ═══
                         Single input, smart-routes:
                           · Bare number          → counts sig figs (color-coded)
                           · Expression           → evaluates with sig fig rules
                           · Functions / constants → log, ln, sqrt, exp, sin, cos,
                                                     tan, asin, acos, atan, abs,
                                                     pi, e, ^ (power)
                    -->
                    <div id="expressionSection" class="sf-section active">
                        <div class="sf-form-group">
                            <label for="exprInput">Number or expression</label>
                            <input type="text" id="exprInput" class="expr-input" placeholder="e.g. log(102) + 2^10  or  0.00450  or  pi*5.5^2" autocomplete="off" spellcheck="false">
                            <p class="sf-form-hint">Operators: <code>+ &minus; &times; &divide;</code> &nbsp;&middot;&nbsp; Powers: <code>^</code> or <code>**</code> &nbsp;&middot;&nbsp; Functions: <code>log</code> <code>ln</code> <code>sqrt</code> <code>exp</code> <code>sin</code> <code>cos</code> <code>tan</code> <code>arcsin</code>/<code>arccos</code>/<code>arctan</code> <code>abs</code> &nbsp;&middot;&nbsp; Constants: <code>pi</code> <code>e</code></p>
                        </div>

                        <!-- Trig deg/rad toggle (only relevant when input has a trig function) -->
                        <div class="sf-form-group" id="trigUnitGroup" style="display:flex;align-items:center;gap:0.6rem;">
                            <label style="margin:0;">Trig unit</label>
                            <div class="ic-input-mode-toggle" role="radiogroup" aria-label="Trig unit">
                                <button type="button" id="trigUnitRad" class="ic-input-mode-btn active" data-trig-mode="rad" role="radio" aria-checked="true">Radians</button>
                                <button type="button" id="trigUnitDeg" class="ic-input-mode-btn"        data-trig-mode="deg" role="radio" aria-checked="false">Degrees</button>
                            </div>
                            <span style="flex:1;font-size:0.7rem;color:var(--ms-muted,#94a3b8);">Used by sin / cos / tan and inverse trig.</span>
                        </div>

                        <button type="button" class="sf-action-btn" onclick="evaluateExpression()">Calculate</button>

                        <div class="ic-method-row" style="margin:0.5rem 0 0.25rem;">
                            <span class="ic-method-label">Try one</span>
                            <span class="example-chip" onclick="setExprExample('log(102)')">log(102)</span>
                            <span class="example-chip" onclick="setExprExample('log(102) + 2^10')">log(102) + 2^10</span>
                            <span class="example-chip" onclick="setExprExample('sqrt(2.0)')">&radic;(2.0)</span>
                            <span class="example-chip" onclick="setExprExample('pi*5.5^2')">&pi;&middot;5.5&sup2;</span>
                            <span class="example-chip" onclick="setExprExample('0.00450')">0.00450</span>
                        </div>
                        <details class="ic-hero-methods">
                            <summary class="ic-hero-methods-summary"><span>More examples</span><svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></summary>
                            <div class="ic-hero-methods-body">
                                <div class="example-category-label">Single number (counts sig figs)</div>
                                <span class="example-chip" onclick="setExprExample('0.00450')">0.00450</span>
                                <span class="example-chip" onclick="setExprExample('1200')">1200</span>
                                <span class="example-chip" onclick="setExprExample('1.23e5')">1.23&times;10&#8309;</span>
                                <div class="example-category-label">Arithmetic</div>
                                <span class="example-chip" onclick="setExprExample('(12.34 + 5.6) * 2.1')">(12.34 + 5.6) * 2.1</span>
                                <span class="example-chip" onclick="setExprExample('45.67 - 12.3')">45.67 &minus; 12.3</span>
                                <span class="example-chip" onclick="setExprExample('100.5 / 3.0 + 2.45')">100.5 / 3.0 + 2.45</span>
                                <div class="example-category-label">Logarithms</div>
                                <span class="example-chip" onclick="setExprExample('log(102)')">log(102)</span>
                                <span class="example-chip" onclick="setExprExample('log(2.0)')">log(2.0)</span>
                                <span class="example-chip" onclick="setExprExample('ln(10)')">ln(10)</span>
                                <span class="example-chip" onclick="setExprExample('exp(2.0)')">exp(2.0)</span>
                                <div class="example-category-label">Roots and powers</div>
                                <span class="example-chip" onclick="setExprExample('sqrt(2.0)')">sqrt(2.0)</span>
                                <span class="example-chip" onclick="setExprExample('sqrt(2)')">sqrt(2)</span>
                                <span class="example-chip" onclick="setExprExample('2^10')">2^10</span>
                                <span class="example-chip" onclick="setExprExample('2.0^3')">2.0^3</span>
                                <div class="example-category-label">Constants and mixed</div>
                                <span class="example-chip" onclick="setExprExample('pi')">&pi;</span>
                                <span class="example-chip" onclick="setExprExample('2*pi')">2&pi;</span>
                                <span class="example-chip" onclick="setExprExample('pi*5.5^2')">&pi;r&sup2; (r=5.5)</span>
                                <span class="example-chip" onclick="setExprExample('log(102) + 2^10')">log(102) + 2^10</span>
                                <div class="example-category-label">Trig</div>
                                <span class="example-chip" onclick="setExprExample('sin(30)')">sin(30) [deg]</span>
                                <span class="example-chip" onclick="setExprExample('cos(45)')">cos(45) [deg]</span>
                                <span class="example-chip" onclick="setExprExample('tan(pi/4)')">tan(&pi;/4) [rad]</span>
                            </div>
                        </details>
                    </div>

                    <!-- ═══ Mode 6: Practice ═══ -->
                    <div id="practiceSection" class="sf-section">
                        <p class="sf-form-hint" style="margin-bottom: 1rem;">Test your sig fig knowledge. Click an answer for each question.</p>
                        <div id="quizContainer"></div>
                        <div id="quizScore" class="quiz-score" style="display: none;"></div>
                        <button type="button" class="sf-action-btn" onclick="generateQuiz()" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">New quiz</button>
                    </div>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="tool-card tool-result-card">
                        <div class="tool-result-content" id="displaySection">
                            <div class="tool-empty-state ic-empty-state" id="emptyState">
                                <div class="ic-empty-illustration" style="font-size:2.4rem;opacity:0.6;">&#128290;</div>
                                <h3>Sig Fig Calculator</h3>
                                <p>Pick a mode above and enter a number to see the result with step-by-step explanation.</p>
                            </div>
                        </div>
                        <div class="tool-result-actions" id="resultActions">
                            <button type="button" class="tool-action-btn" id="copyResultBtn">&#128203; Copy text</button>
                            <button type="button" class="tool-action-btn" id="shareUrlBtn">&#128279; Share URL</button>
                            <button type="button" class="tool-action-btn" id="sf-worksheet-btn-toolbar">&#128214; Worksheet</button>
                        </div>

                        <!-- Practice worksheet CTA — 1,500-problem sig-fig
                             bank covering all 5 rules, scientific notation,
                             arithmetic with sig-fig rounding rules, plus
                             chemistry / physics / IIT-JEE problems. -->
                        <div class="ic-worksheet-cta" style="padding:0.75rem 1rem;">
                            <button type="button" class="tool-action-btn" id="sf-worksheet-btn"
                                    style="width:100%;font-weight:600;">
                                Practice Worksheet &mdash; 1,500+ sig-fig &amp; scientific-notation problems with answer key
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- In-content ad (mobile/tablet) -->
            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- ════════════ EDUCATIONAL CONTENT (preserved for SEO) ════════════ -->
            <section class="tool-expertise-section" style="margin:2rem 0;">

                <!-- 1. What Are Significant Figures? -->
                <div class="tool-card" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">What Are Significant Figures?</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.75rem;"><strong>Significant figures</strong> (sig figs) are the digits in a number that carry meaningful information about its precision. When you measure something with a ruler, balance, or instrument, every digit you record reflects how precise the measurement is. Mastering sig figs is essential in chemistry, physics, engineering, and any quantitative science.</p>
                    <div class="info-box">
                        <p><strong>Why it matters:</strong> Reporting too many digits implies false precision; too few discards real precision. Sig figs propagate measurement uncertainty correctly through calculations.</p>
                    </div>
                </div>

                <!-- 2. The 5 Counting Rules -->
                <div class="tool-card" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">The 5 Rules for Counting Sig Figs</h2>
                    <ol style="line-height:1.9;color:var(--ms-ink-soft,#475569);padding-left:1.25rem;">
                        <li><strong>All non-zero digits are significant.</strong> &nbsp;e.g. 1234 has 4 sig figs.</li>
                        <li><strong>Trapped zeros are significant.</strong> &nbsp;e.g. 1002 has 4 sig figs.</li>
                        <li><strong>Leading zeros are NOT significant.</strong> &nbsp;e.g. 0.00450 has 3 sig figs (4, 5, 0).</li>
                        <li><strong>Trailing zeros after a decimal ARE significant.</strong> &nbsp;e.g. 1.200 has 4 sig figs; 0.500 has 3.</li>
                        <li><strong>Trailing zeros without a decimal are AMBIGUOUS.</strong> &nbsp;e.g. 1200 could have 2, 3, or 4 sig figs &mdash; use scientific notation to clarify (1.20 &times; 10&sup3; = 3 sig figs).</li>
                    </ol>
                </div>

                <!-- 3. Quick Reference Table -->
                <div class="tool-card" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.5rem;">Quick Reference</h2>
                    <div style="overflow-x:auto;">
                        <table style="width:100%;border-collapse:collapse;font-size:0.9rem;">
                            <thead>
                                <tr style="border-bottom:2px solid var(--ms-border,#e5e7eb);text-align:left;">
                                    <th style="padding:0.5rem 0.75rem;">Number</th>
                                    <th style="padding:0.5rem 0.75rem;">Sig figs</th>
                                    <th style="padding:0.5rem 0.75rem;">Why</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr style="border-bottom:1px solid var(--ms-border,#e5e7eb);"><td style="padding:0.4rem 0.75rem;font-family:var(--font-mono);">1234</td><td style="padding:0.4rem 0.75rem;">4</td><td style="padding:0.4rem 0.75rem;color:var(--ms-muted);">All non-zero</td></tr>
                                <tr style="border-bottom:1px solid var(--ms-border,#e5e7eb);"><td style="padding:0.4rem 0.75rem;font-family:var(--font-mono);">1002</td><td style="padding:0.4rem 0.75rem;">4</td><td style="padding:0.4rem 0.75rem;color:var(--ms-muted);">Trapped zeros count</td></tr>
                                <tr style="border-bottom:1px solid var(--ms-border,#e5e7eb);"><td style="padding:0.4rem 0.75rem;font-family:var(--font-mono);">0.00450</td><td style="padding:0.4rem 0.75rem;">3</td><td style="padding:0.4rem 0.75rem;color:var(--ms-muted);">Leading zeros don't count; trailing zero after decimal counts</td></tr>
                                <tr style="border-bottom:1px solid var(--ms-border,#e5e7eb);"><td style="padding:0.4rem 0.75rem;font-family:var(--font-mono);">1.200</td><td style="padding:0.4rem 0.75rem;">4</td><td style="padding:0.4rem 0.75rem;color:var(--ms-muted);">Trailing zeros after decimal are significant</td></tr>
                                <tr style="border-bottom:1px solid var(--ms-border,#e5e7eb);"><td style="padding:0.4rem 0.75rem;font-family:var(--font-mono);">1200</td><td style="padding:0.4rem 0.75rem;">2-4</td><td style="padding:0.4rem 0.75rem;color:var(--ms-muted);">Ambiguous &mdash; rewrite as 1.2&times;10&sup3; (2), 1.20&times;10&sup3; (3), or 1.200&times;10&sup3; (4)</td></tr>
                                <tr><td style="padding:0.4rem 0.75rem;font-family:var(--font-mono);">6.02&times;10&sup2;&sup3;</td><td style="padding:0.4rem 0.75rem;">3</td><td style="padding:0.4rem 0.75rem;color:var(--ms-muted);">Scientific form makes it unambiguous</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 4. Calculation Rules -->
                <div class="tool-card" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">Calculation Rules</h2>
                    <div class="rule-box">
                        <p><strong>Addition / Subtraction</strong> &mdash; round to the same number of <em>decimal places</em> as the value with the fewest. &nbsp; e.g. 12.34 + 5.6 = 17.94 &rarr; <strong>17.9</strong> (1 dp).</p>
                    </div>
                    <div class="rule-box">
                        <p><strong>Multiplication / Division</strong> &mdash; round to the same number of <em>sig figs</em> as the value with the fewest. &nbsp; e.g. 12.34 &times; 5.6 = 69.104 &rarr; <strong>69</strong> (2 sf).</p>
                    </div>
                </div>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- ═══ VISIBLE FAQ (mirrors faqNq/faqNa above) ═══ -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Significant figures calculator FAQ">
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What are significant figures?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Significant figures are the digits in a number that carry meaningful precision. Non-zero digits are always significant; trapped zeros are significant; leading zeros are not; trailing zeros after a decimal are significant; trailing zeros without a decimal are ambiguous.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How do you count significant figures?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Apply the 5 rules in order: (1) all non-zero digits, (2) trapped zeros count, (3) leading zeros don't, (4) trailing zeros after a decimal do, (5) trailing zeros without a decimal are ambiguous &mdash; use scientific notation to clarify.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What are the sig fig rules for + and &minus; ?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Round the result to the same number of decimal places as the operand with the <em>fewest</em> decimal places. Example: 12.34 + 5.6 = 17.94 &rarr; 17.9 (one decimal place, matching 5.6).</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What are the sig fig rules for &times; and &divide; ?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Round the result to the same number of sig figs as the operand with the <em>fewest</em> sig figs. Example: 12.34 &times; 5.6 = 69.104 &rarr; 69 (two sig figs, matching 5.6).</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How do trailing zeros affect sig figs?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Trailing zeros after a decimal are <strong>always significant</strong> (1.200 has 4 sig figs). Trailing zeros in a whole number without a decimal are <strong>ambiguous</strong> &mdash; rewrite in scientific notation: 1.20 &times; 10&sup3; = 3 sig figs.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How do you round to a specific number of sig figs?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Identify the n<sup>th</sup> significant digit, then look at the next digit. If it's 5 or greater, round up. Example: 123.456 to 3 sig figs &rarr; 123 (the next digit, 4, rounds down).</div></div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2026 8gwifi.org &mdash; Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%--
        Script load order:
          1. tool-utils + dark-mode + search   — site-wide JS
          2. inline sig-fig logic              — preserved from legacy page,
             only the mode-toggle selector retargeted (.tool-tab → .sf-mode-btn,
             .tool-form-section → .sf-section, data-tab → data-mode)
          3. ms-faq accordion                  — math-studio FAQ behaviour
    --%>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <script>
    // ========== Tab switching ==========
    document.querySelectorAll('.sf-mode-btn').forEach(function(tab) {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.sf-mode-btn').forEach(function(t) { t.classList.remove('active'); });
            document.querySelectorAll('.sf-section').forEach(function(s) { s.classList.remove('active'); });
            this.classList.add('active');
            var tabName = this.getAttribute('data-mode');
            var sectionId = tabName + 'Section';
            var section = document.getElementById(sectionId);
            if (section) section.classList.add('active');
            if (tabName === 'practice' && document.getElementById('quizContainer').innerHTML === '') {
                generateQuiz();
            }
        });
    });

    // ========== Constants ==========
    var TOOL_NAME = 'Significant Figures Calculator';
    var lastResultText = '';

    // ========== Helper: show result and actions bar ==========
    function showResult(html, plainText) {
        document.getElementById('displaySection').innerHTML = html;
        document.getElementById('resultActions').classList.add('visible');
        lastResultText = plainText || '';
    }

    // ========== Color-coded digit display ==========
    function colorCodeNumber(numStr) {
        var str = numStr.trim();
        var sciMatch = str.match(/^([+-]?[\d.]+)[eE]([+-]?\d+)$/);
        if (sciMatch) {
            return colorCodeNumber(sciMatch[1]) +
                '<span style="font-size:0.85em"> \u00D7 10<sup>' + sciMatch[2] + '</sup></span>';
        }
        var html = '', idx = 0;
        if (str[0] === '+' || str[0] === '-') { html += str[0]; idx = 1; }
        var body = str.substring(idx);
        var dotPos = body.indexOf('.');
        var hasDot = dotPos !== -1;
        var intP = hasDot ? body.substring(0, dotPos) : body;
        var decP = hasDot ? body.substring(dotPos + 1) : '';

        if (hasDot && (intP === '0' || intP === '')) {
            for (var i = 0; i < intP.length; i++) html += '<span class="non-sig-digit">' + intP[i] + '</span>';
            html += '<span class="non-sig-digit">.</span>';
            var nz = false;
            for (var i = 0; i < decP.length; i++) {
                if (!nz && decP[i] !== '0') nz = true;
                html += '<span class="' + (nz ? 'sig-digit' : 'non-sig-digit') + '">' + decP[i] + '</span>';
            }
        } else if (hasDot) {
            for (var i = 0; i < intP.length; i++) html += '<span class="sig-digit">' + intP[i] + '</span>';
            html += '<span class="sig-digit">.</span>';
            for (var i = 0; i < decP.length; i++) html += '<span class="sig-digit">' + decP[i] + '</span>';
        } else {
            var lastNZ = -1;
            for (var i = intP.length - 1; i >= 0; i--) { if (intP[i] !== '0') { lastNZ = i; break; } }
            var started = false;
            for (var i = 0; i < intP.length; i++) {
                if (!started && intP[i] !== '0') started = true;
                if (!started) html += '<span class="non-sig-digit">' + intP[i] + '</span>';
                else if (i <= lastNZ) html += '<span class="sig-digit">' + intP[i] + '</span>';
                else html += '<span class="non-sig-digit">' + intP[i] + '</span>';
            }
        }
        return html;
    }

    // ========== Scientific notation normalizer ==========
    // Accept the way students/teachers actually WRITE scientific notation
    // (× 10^n, ×10⁵, · 10^n, * 10^n, with or without spaces, with caret
    // OR Unicode superscripts) and convert to the e-notation form the
    // rest of the JS expects (1.23e5).  Idempotent: clean inputs pass
    // through unchanged.
    function normalizeScientific(str) {
        if (str == null) return str;
        var s = String(str).trim();
        if (!s) return s;

        // Form A: explicit caret — 1.23 × 10^5 / 1.23 ×10^-3 / 1.23*10^5
        s = s.replace(/\s*[×x·*]\s*10\s*\^\s*([+\u2212-]?\d+)/gi,
            function (_, exp) { return 'e' + exp.replace('\u2212', '-'); });

        // Form B: Unicode superscripts — 1.23 × 10⁵ / 6.02 × 10²³ / 4.5 × 10⁻³
        var SUPER = { '\u2070':'0','\u00B9':'1','\u00B2':'2','\u00B3':'3',
                      '\u2074':'4','\u2075':'5','\u2076':'6','\u2077':'7',
                      '\u2078':'8','\u2079':'9','\u207A':'+','\u207B':'-' };
        s = s.replace(/\s*[×x·*]\s*10\s*([\u207A\u207B]?[\u2070\u00B9\u00B2\u00B3\u2074-\u2079]+)/g,
            function (_, sup) {
                var out = '';
                for (var i = 0; i < sup.length; i++) out += SUPER[sup.charAt(i)] || sup.charAt(i);
                return 'e' + out;
            });

        // Cleanup: collapse remaining unicode minus to ASCII (e.g. "1.23e\u22125")
        s = s.replace(/\u2212/g, '-');
        return s;
    }

    // ========== Core: Analyze Significant Figures ==========
    function analyzeSigFigs(numStr) {
        numStr = normalizeScientific(numStr).trim();

        // Handle scientific notation (e.g., 1.23e5 or 1.23E5)
        var sciMatch = numStr.match(/^([+-]?[\d.]+)[eE]([+-]?\d+)$/);
        if (sciMatch) {
            return analyzeSigFigs(sciMatch[1]);
        }

        // Remove positive sign if present
        numStr = numStr.replace(/^\+/, '');

        // Check if negative
        var isNegative = numStr.startsWith('-');
        if (isNegative) {
            numStr = numStr.substring(1);
        }

        // Split by decimal point
        var parts = numStr.split('.');
        var hasDecimal = parts.length === 2;
        var integerPart = parts[0];
        var decimalPart = parts[1] || '';

        var sigFigs = 0;
        var explanation = [];

        if (hasDecimal) {
            if (integerPart === '0' || integerPart === '') {
                // Number like 0.00450
                var foundNonZero = false;
                for (var i = 0; i < decimalPart.length; i++) {
                    var digit = decimalPart[i];
                    if (!foundNonZero && digit !== '0') {
                        foundNonZero = true;
                    }
                    if (foundNonZero) {
                        sigFigs++;
                    }
                }
                explanation.push('Leading zeros after decimal are NOT significant');
                explanation.push('All digits after the first non-zero digit ARE significant (including trailing zeros)');
            } else {
                // Number like 123.450
                for (var j = 0; j < integerPart.length; j++) {
                    if (integerPart[j] !== '0' || sigFigs > 0) {
                        sigFigs++;
                    }
                }
                sigFigs += decimalPart.length;
                explanation.push('All non-zero digits are significant');
                explanation.push('Trailing zeros after decimal point ARE significant');
            }
        } else {
            // No decimal point (e.g., 1200)
            var foundNZ = false;
            var trailingZeros = 0;

            for (var k = 0; k < integerPart.length; k++) {
                var d = integerPart[k];
                if (d !== '0') {
                    foundNZ = true;
                    sigFigs++;
                    trailingZeros = 0;
                } else if (foundNZ) {
                    if (k < integerPart.length - 1 && integerPart.substring(k + 1).match(/[1-9]/)) {
                        sigFigs++;
                    } else {
                        trailingZeros++;
                    }
                }
            }

            if (trailingZeros > 0) {
                explanation.push('Trailing zeros without decimal point are AMBIGUOUS');
                explanation.push('Assuming ' + sigFigs + ' sig figs (not counting trailing zeros)');
                explanation.push('Use scientific notation to clarify');
            } else {
                explanation.push('All non-zero digits are significant');
                explanation.push('Trapped zeros (between non-zero digits) are significant');
            }
        }

        return {
            sigFigs: sigFigs,
            explanation: explanation,
            original: (isNegative ? '-' : '') + numStr
        };
    }

    // ========== Count Significant Figures ==========
    function countSigFigs() {
        var input = normalizeScientific(document.getElementById('countNumber').value).trim();
        if (!input) {
            ToolUtils.showToast('Please enter a number', 2000, 'warning');
            return;
        }

        var result = analyzeSigFigs(input);
        displaySigFigCount(result, input);
    }

    function displaySigFigCount(result, original) {
        var html = '<div class="result-section">' +
            '<h6><span class="result-badge">SIGNIFICANT FIGURES</span></h6>' +
            '<div class="number-display">' + colorCodeNumber(original) + '</div>' +
            '<p style="font-size:0.7rem;margin-top:0.375rem;"><span class="sig-digit">\u25CF</span> Significant digit &nbsp;&nbsp; <span class="non-sig-digit">\u25CF</span> Not significant</p>' +
            '<h4>' + result.sigFigs + ' significant figure' + (result.sigFigs !== 1 ? 's' : '') + '</h4>' +
            '<hr>' +
            '<h6><span class="step-badge">EXPLANATION</span></h6>' +
            '<div class="step-section">';

        for (var i = 0; i < result.explanation.length; i++) {
            html += '<p>&bull; ' + result.explanation[i] + '</p>';
        }

        html += '</div></div>';

        var plain = original + ' has ' + result.sigFigs + ' significant figure' + (result.sigFigs !== 1 ? 's' : '');
        showResult(html, plain);
    }

    // ========== Arithmetic with Sig Figs ==========
    function calculateArithmetic() {
        var op = document.getElementById('arithmeticOp').value;
        var num1Str = normalizeScientific(document.getElementById('arithmeticNum1').value).trim();
        var num2Str = normalizeScientific(document.getElementById('arithmeticNum2').value).trim();

        if (!num1Str || !num2Str) {
            ToolUtils.showToast('Please enter both numbers', 2000, 'warning');
            return;
        }

        var num1 = parseFloat(num1Str);
        var num2 = parseFloat(num2Str);

        if (isNaN(num1) || isNaN(num2)) {
            ToolUtils.showToast('Please enter valid numbers', 2000, 'warning');
            return;
        }

        var sig1 = analyzeSigFigs(num1Str);
        var sig2 = analyzeSigFigs(num2Str);

        var rawResult, finalResult, rule, steps;

        if (op === 'add' || op === 'subtract') {
            rawResult = op === 'add' ? num1 + num2 : num1 - num2;

            var dec1 = getDecimalPlaces(num1Str);
            var dec2 = getDecimalPlaces(num2Str);
            var minDecimals = Math.min(dec1, dec2);

            finalResult = rawResult.toFixed(minDecimals);
            rule = 'Round to ' + minDecimals + ' decimal place' + (minDecimals !== 1 ? 's' : '') + ' (fewest among inputs)';

            steps = '<p><strong>Input Numbers:</strong></p>' +
                '<p class="indent">' + num1Str + ' (' + dec1 + ' decimal places)</p>' +
                '<p class="indent">' + num2Str + ' (' + dec2 + ' decimal places)</p>' +
                '<p><strong>Raw Result:</strong></p>' +
                '<p class="indent">' + rawResult + '</p>' +
                '<p><strong>Rule for Addition/Subtraction:</strong></p>' +
                '<p class="indent">Round to the fewest decimal places</p>' +
                '<p><strong>Final Result:</strong></p>' +
                '<p class="indent">' + finalResult + ' (' + minDecimals + ' decimal places)</p>';
        } else {
            rawResult = op === 'multiply' ? num1 * num2 : num1 / num2;

            var minSigFigs = Math.min(sig1.sigFigs, sig2.sigFigs);

            finalResult = roundToNSigFigs(rawResult, minSigFigs);
            rule = 'Round to ' + minSigFigs + ' sig fig' + (minSigFigs !== 1 ? 's' : '') + ' (fewest among inputs)';

            steps = '<p><strong>Input Numbers:</strong></p>' +
                '<p class="indent">' + num1Str + ' (' + sig1.sigFigs + ' sig figs)</p>' +
                '<p class="indent">' + num2Str + ' (' + sig2.sigFigs + ' sig figs)</p>' +
                '<p><strong>Raw Result:</strong></p>' +
                '<p class="indent">' + rawResult + '</p>' +
                '<p><strong>Rule for Multiplication/Division:</strong></p>' +
                '<p class="indent">Round to the fewest significant figures</p>' +
                '<p><strong>Final Result:</strong></p>' +
                '<p class="indent">' + finalResult + ' (' + minSigFigs + ' sig figs)</p>';
        }

        var opSymbol = { add: '+', subtract: '\u2212', multiply: '\u00D7', divide: '\u00F7' }[op];

        var html = '<div class="result-section">' +
            '<h6><span class="result-badge">RESULT</span></h6>' +
            '<div class="number-display">' + num1Str + ' ' + opSymbol + ' ' + num2Str + ' = ' + finalResult + '</div>' +
            '<hr>' +
            '<h6><span class="step-badge">CALCULATION STEPS</span></h6>' +
            '<div class="step-section">' + steps + '</div>' +
            '<hr>' +
            '<div class="info-box"><p><strong>Rule Applied:</strong> ' + rule + '</p></div>' +
            '</div>';

        var plain = num1Str + ' ' + opSymbol + ' ' + num2Str + ' = ' + finalResult + ' (' + rule + ')';
        showResult(html, plain);
    }

    function getDecimalPlaces(numStr) {
        var parts = numStr.split('.');
        return parts.length === 2 ? parts[1].length : 0;
    }

    function roundToNSigFigs(num, n) {
        if (num === 0) return '0';
        // Exact result (n = Infinity) — return the natural string form.
        // Integers come out as plain digits (so `2^10` shows "1024", not
        // "1.024×10³"), floats keep full double precision.
        if (!isFinite(n)) {
            // Exact integer → plain digit string (no exponential).
            if (Number.isInteger(num) && Math.abs(num) < 1e15) return String(num);
            // Exact float → use ~12 sig figs to hide trailing FP fuzz from
            // ops like sin(30°) returning 0.4999999999999999 instead of 0.5.
            return parseFloat(num.toPrecision(12)).toString();
        }
        // Defensive: SymPy / textbook convention requires n ≥ 1.  Some upstream
        // paths (e.g. analyzeSigFigs("0")) report 0 sf which would crash
        // toPrecision() — clamp to a safe minimum.
        if (n < 1) n = 1;
        if (n > 100) n = 100;

        var d = Math.ceil(Math.log10(Math.abs(num)));
        var power = n - d;

        var magnitude = Math.pow(10, power);
        var shifted = Math.round(num * magnitude);
        var result = shifted / magnitude;

        if (Math.abs(result) >= 1000 || Math.abs(result) < 0.001) {
            return result.toExponential(n - 1);
        }
        // Preserve trailing zeros — they ARE significant.  toPrecision returns
        // e.g. (8).toPrecision(2) === "8.0" which we keep verbatim.  (Earlier
        // code stripped trailing zeros, which silently dropped sig fig
        // information for results like "8.0", "1.20", "0.0050".)
        return result.toPrecision(n);
    }

    // ========== Round to Sig Figs ==========
    function roundToSigFigs() {
        var numStr = normalizeScientific(document.getElementById('roundNumber').value).trim();
        var targetSigFigs = parseInt(document.getElementById('roundSigFigs').value);

        if (!numStr || isNaN(targetSigFigs) || targetSigFigs < 1) {
            ToolUtils.showToast('Please enter a valid number and number of sig figs', 2000, 'warning');
            return;
        }

        var num = parseFloat(numStr);
        var original = analyzeSigFigs(numStr);

        var rounded = roundToNSigFigs(num, targetSigFigs);

        var html = '<div class="result-section">' +
            '<h6><span class="result-badge">ROUNDED RESULT</span></h6>' +
            '<div class="number-display">' + rounded + '</div>' +
            '<p>' + targetSigFigs + ' significant figure' + (targetSigFigs !== 1 ? 's' : '') + '</p>' +
            '<hr>' +
            '<h6><span class="step-badge">ORIGINAL NUMBER</span></h6>' +
            '<div class="step-section">' +
            '<p>Number: ' + numStr + '</p>' +
            '<p>Original sig figs: ' + original.sigFigs + '</p>' +
            '</div>' +
            '<hr>' +
            '<div class="info-box"><p><strong>Rounding:</strong> ' +
            (original.sigFigs > targetSigFigs ? 'Decreased' : 'Increased') +
            ' precision from ' + original.sigFigs + ' to ' + targetSigFigs + ' sig figs</p></div>' +
            '</div>';

        var plain = numStr + ' rounded to ' + targetSigFigs + ' sig figs = ' + rounded;
        showResult(html, plain);
    }

    // ========== Scientific Notation ==========
    function convertNotation() {
        var numStr = normalizeScientific(document.getElementById('notationNumber').value).trim();
        var targetSigFigs = document.getElementById('notationSigFigs').value;

        if (!numStr) {
            ToolUtils.showToast('Please enter a number', 2000, 'warning');
            return;
        }

        var sciMatch = numStr.match(/^([+-]?[\d.]+)[eE]([+-]?\d+)$/);

        var num = parseFloat(numStr);
        var original = analyzeSigFigs(numStr);

        var mantissa, exponent, scientific, standard;

        if (sciMatch) {
            exponent = parseInt(sciMatch[2]);
            mantissa = parseFloat(sciMatch[1]);
            scientific = numStr;
            standard = num.toString();
        } else {
            if (num === 0) {
                scientific = '0';
                standard = '0';
                exponent = 0;
                mantissa = 0;
            } else {
                exponent = Math.floor(Math.log10(Math.abs(num)));
                mantissa = num / Math.pow(10, exponent);

                var sigFigs = targetSigFigs ? parseInt(targetSigFigs) : original.sigFigs;
                var mantissaStr = mantissa.toPrecision(sigFigs);

                scientific = mantissaStr + ' \u00D7 10^' + exponent;
                standard = num.toString();
            }
        }

        var html = '<div class="result-section">' +
            '<h6><span class="sig-badge">SCIENTIFIC NOTATION</span></h6>' +
            '<div class="number-display">' + scientific + '</div>' +
            '<hr>' +
            '<h6><span class="step-badge">CONVERSIONS</span></h6>' +
            '<div class="step-section">' +
            '<p><strong>Standard Form:</strong></p>' +
            '<p class="indent">' + standard + '</p>' +
            '<p><strong>Scientific Notation:</strong></p>' +
            '<p class="indent">' + scientific + '</p>' +
            '<p><strong>Components:</strong></p>' +
            '<p class="indent">Mantissa: ' + mantissa + '</p>' +
            '<p class="indent">Exponent: ' + exponent + '</p>' +
            '</div>' +
            '<hr>' +
            '<div class="info-box"><p><strong>Significant Figures:</strong> ' + original.sigFigs + '</p></div>' +
            '</div>';

        var plain = standard + ' = ' + scientific + ' (' + original.sigFigs + ' sig figs)';
        showResult(html, plain);
    }

    // ========== Expression Parser ==========
    // ─── Function & constant tables ──────────────────────────────
    // For functions whose result-precision depends on the INPUT's sig
    // figs, an "exact integer" literal like `102` (no decimal point) is
    // ambiguous: in pure math it's exact (precision is irrelevant),
    // but in a chemistry context students write `log(102)` expecting
    // a 3-decimal answer because 102 reads as 3 sig figs.  We resolve
    // this with effSigFigs(): if the arg is marked exact, fall back to
    // the digit-count of its display string.  Constants (pi, e) stay
    // truly exact — their sigFigs stays Infinity.
    function effSigFigs(a) {
        // Constants (π, e) stay exact — Infinity propagates
        if (a.display === '\u03C0' || a.display === 'e') return Infinity;
        // Exact integer literal in an expression: count ALL digits.
        // Reasoning: when a student writes log(100), they mean "exactly
        // 100" (= 10²), not "1 sig fig because trailing zeros are
        // ambiguous".  Trailing-zero ambiguity is a counting/measurement
        // concern, not a function-argument one.
        if (a.exact && a.display) {
            var s = a.display.replace(/^-/, '');
            if (/^\d+$/.test(s)) return s.length;
        }
        if (isFinite(a.sigFigs)) return a.sigFigs;
        var asf = analyzeSigFigs(a.display || ('' + a.val));
        return Math.max(1, asf.sigFigs);
    }
    function effDecPlaces(a) {
        if (isFinite(a.decPlaces)) return a.decPlaces;
        var s = a.display || ('' + a.val);
        return getDecimalPlaces(s);
    }

    var EXPR_FUNCS = {
        // name → { fn(x), label, rule(argResult, raw, mode) }
        log:    { fn: function (x) { return Math.log10(x); },
                  label: 'log',  rule: function (a) {
                    var sf = effSigFigs(a);
                    return { sigFigs: Math.max(1, sf), decPlaces: isFinite(sf) ? sf : null,
                             rule: 'log: decimal places of result = sig figs of input (' + sf + ')' }; } },
        ln:     { fn: function (x) { return Math.log(x); },
                  label: 'ln',   rule: function (a) {
                    var sf = effSigFigs(a);
                    return { sigFigs: Math.max(1, sf), decPlaces: isFinite(sf) ? sf : null,
                             rule: 'ln: decimal places of result = sig figs of input (' + sf + ')' }; } },
        exp:    { fn: function (x) { return Math.exp(x); },
                  label: 'exp',  rule: function (a) {
                    var dp = effDecPlaces(a);
                    if (!isFinite(dp)) dp = effSigFigs(a);
                    return { sigFigs: Math.max(1, dp), decPlaces: null,
                             rule: 'exp: sig figs of result = decimal places of input (' + dp + ')' }; } },
        sqrt:   { fn: function (x) { return Math.sqrt(x); },
                  label: 'sqrt', rule: function (a) { var sf = effSigFigs(a);
                    return { sigFigs: sf, decPlaces: null,
                             rule: 'sqrt: same sig figs as input (' + sf + ')' }; } },
        cbrt:   { fn: function (x) { return Math.cbrt(x); },
                  label: 'cbrt', rule: function (a) { var sf = effSigFigs(a);
                    return { sigFigs: sf, decPlaces: null,
                             rule: 'cbrt: same sig figs as input (' + sf + ')' }; } },
        abs:    { fn: function (x) { return Math.abs(x); },
                  label: 'abs',  rule: function (a) { return { sigFigs: a.sigFigs, decPlaces: a.decPlaces,
                             rule: 'abs: precision unchanged' }; } },
        sin:    { fn: function (x, mode) { return Math.sin(mode === 'deg' ? x * Math.PI / 180 : x); },
                  label: 'sin', isTrig: true, rule: function (a, raw, mode) {
                    return { sigFigs: a.sigFigs, decPlaces: null,
                             rule: 'sin (' + (mode || 'rad') + '): same sig figs as input (' + a.sigFigs + ')' }; } },
        cos:    { fn: function (x, mode) { return Math.cos(mode === 'deg' ? x * Math.PI / 180 : x); },
                  label: 'cos', isTrig: true, rule: function (a, raw, mode) {
                    return { sigFigs: a.sigFigs, decPlaces: null,
                             rule: 'cos (' + (mode || 'rad') + '): same sig figs as input (' + a.sigFigs + ')' }; } },
        tan:    { fn: function (x, mode) { return Math.tan(mode === 'deg' ? x * Math.PI / 180 : x); },
                  label: 'tan', isTrig: true, rule: function (a, raw, mode) {
                    return { sigFigs: a.sigFigs, decPlaces: null,
                             rule: 'tan (' + (mode || 'rad') + '): same sig figs as input (' + a.sigFigs + ')' }; } },
        asin:   { fn: function (x, mode) { var r = Math.asin(x); return mode === 'deg' ? r * 180 / Math.PI : r; },
                  label: 'arcsin', isTrig: true, rule: function (a, raw, mode) {
                    return { sigFigs: a.sigFigs, decPlaces: null,
                             rule: 'arcsin (output ' + (mode || 'rad') + '): same sig figs as input' }; } },
        acos:   { fn: function (x, mode) { var r = Math.acos(x); return mode === 'deg' ? r * 180 / Math.PI : r; },
                  label: 'arccos', isTrig: true, rule: function (a, raw, mode) {
                    return { sigFigs: a.sigFigs, decPlaces: null,
                             rule: 'arccos (output ' + (mode || 'rad') + '): same sig figs as input' }; } },
        atan:   { fn: function (x, mode) { var r = Math.atan(x); return mode === 'deg' ? r * 180 / Math.PI : r; },
                  label: 'arctan', isTrig: true, rule: function (a, raw, mode) {
                    return { sigFigs: a.sigFigs, decPlaces: null,
                             rule: 'arctan (output ' + (mode || 'rad') + '): same sig figs as input' }; } }
    };
    // Aliases
    EXPR_FUNCS.arcsin = EXPR_FUNCS.asin;
    EXPR_FUNCS.arccos = EXPR_FUNCS.acos;
    EXPR_FUNCS.arctan = EXPR_FUNCS.atan;

    var EXPR_CONSTS = {
        // Constants are EXACT — they don't limit the precision of the result.
        // We tag them with sigFigs:Infinity so min(...) ignores them.
        pi: { val: Math.PI, display: '\u03C0' },
        PI: { val: Math.PI, display: '\u03C0' },
        e:  { val: Math.E,  display: 'e' },
        E:  { val: Math.E,  display: 'e' }
    };

    // The deg/rad mode for trig functions. Toggleable by the UI; defaults to
    // radians (the JS Math convention).  Inspected at evaluation time.
    var TRIG_MODE = 'rad';
    function setTrigMode(m) { TRIG_MODE = (m === 'deg') ? 'deg' : 'rad'; }

    // Helper — true sig-fig combine that respects "exact" markers (Infinity).
    function combineExactSF(a, b) {
        if (!isFinite(a)) return b;
        if (!isFinite(b)) return a;
        return Math.min(a, b);
    }
    function combineExactDP(a, b) {
        if (!isFinite(a)) return b;
        if (!isFinite(b)) return a;
        return Math.min(a, b);
    }

    // ─── Tokenizer (function-aware) ──────────────────────────────
    function tokenizeExpr(expr) {
        var tokens = [], i = 0;
        function lastTok() { return tokens.length ? tokens[tokens.length - 1] : null; }
        function isUnaryContext() {
            var t = lastTok();
            return !t || t.type === '(' || t.type === 'op' || t.type === 'fn';
        }
        function readNumber(startCh) {
            var ns = startCh || '';
            while (i < expr.length && /[\d.]/.test(expr[i])) { ns += expr[i]; i++; }
            if (i < expr.length && /[eE]/.test(expr[i])) {
                ns += expr[i]; i++;
                if (i < expr.length && /[+-]/.test(expr[i])) { ns += expr[i]; i++; }
                while (i < expr.length && /\d/.test(expr[i])) { ns += expr[i]; i++; }
            }
            return ns;
        }
        while (i < expr.length) {
            var ch = expr[i];
            if (ch === ' ' || ch === '\t') { i++; continue; }
            if (ch === '(' || ch === ')' || ch === ',') { tokens.push({ type: ch }); i++; continue; }
            // Power operator: `^` or `**`
            if (ch === '^') { tokens.push({ type: 'op', value: '^' }); i++; continue; }
            if (ch === '*' && expr[i + 1] === '*') { tokens.push({ type: 'op', value: '^' }); i += 2; continue; }
            // Other operators
            if ('+-*/\u00D7\u00F7\u2212'.indexOf(ch) !== -1) {
                // Unary +/- attached to a number literal (only in unary context)
                if ((ch === '-' || ch === '+' || ch === '\u2212') && isUnaryContext() &&
                    i + 1 < expr.length && /[\d.]/.test(expr[i + 1])) {
                    var sign = (ch === '\u2212') ? '-' : ch; i++;
                    var ns2 = readNumber(sign);
                    tokens.push({ type: 'num', str: ns2, val: parseFloat(ns2) });
                    continue;
                }
                var op = ch;
                if (op === '\u00D7') op = '*';
                if (op === '\u00F7') op = '/';
                if (op === '\u2212') op = '-';
                tokens.push({ type: 'op', value: op }); i++; continue;
            }
            // Numeric literal
            if (/[\d.]/.test(ch)) {
                var ns3 = readNumber('');
                tokens.push({ type: 'num', str: ns3, val: parseFloat(ns3) });
                continue;
            }
            // Identifier — function name OR constant
            if (/[a-zA-Z]/.test(ch)) {
                var name = '';
                while (i < expr.length && /[a-zA-Z]/.test(expr[i])) { name += expr[i]; i++; }
                // Skip whitespace before paren
                var j = i;
                while (j < expr.length && /\s/.test(expr[j])) j++;
                if (expr[j] === '(' && EXPR_FUNCS[name]) {
                    i = j;
                    tokens.push({ type: 'fn', name: name });
                    continue;
                }
                if (EXPR_CONSTS[name]) {
                    tokens.push({ type: 'const', name: name });
                    continue;
                }
                throw new Error('Unknown identifier: ' + name);
            }
            throw new Error('Unexpected character: ' + ch);
        }
        return tokens;
    }

    // ─── Parser (with function and ^ support) ────────────────────
    function parseExprAddSub(tokens, pos, steps) {
        var left = parseExprMulDiv(tokens, pos, steps);
        while (pos.i < tokens.length && tokens[pos.i].type === 'op' &&
               (tokens[pos.i].value === '+' || tokens[pos.i].value === '-')) {
            var op = tokens[pos.i].value; pos.i++;
            var right = parseExprMulDiv(tokens, pos, steps);
            left = combineExprValues(left, right, op, steps);
        }
        return left;
    }
    function parseExprMulDiv(tokens, pos, steps) {
        var left = parseExprPower(tokens, pos, steps);
        while (pos.i < tokens.length && tokens[pos.i].type === 'op' &&
               (tokens[pos.i].value === '*' || tokens[pos.i].value === '/')) {
            var op = tokens[pos.i].value; pos.i++;
            var right = parseExprPower(tokens, pos, steps);
            left = combineExprValues(left, right, op, steps);
        }
        return left;
    }
    // Right-associative ^: 2^3^2 = 2^(3^2) = 2^9 = 512
    function parseExprPower(tokens, pos, steps) {
        var base = parseExprAtom(tokens, pos, steps);
        if (pos.i < tokens.length && tokens[pos.i].type === 'op' && tokens[pos.i].value === '^') {
            pos.i++;
            var exp = parseExprPower(tokens, pos, steps);
            return combineExprValues(base, exp, '^', steps);
        }
        return base;
    }
    function parseExprAtom(tokens, pos, steps) {
        if (pos.i >= tokens.length) throw new Error('Unexpected end of expression');
        var tok = tokens[pos.i];
        // Parenthesised sub-expression
        if (tok.type === '(') {
            pos.i++;
            var result = parseExprAddSub(tokens, pos, steps);
            if (pos.i >= tokens.length || tokens[pos.i].type !== ')') throw new Error('Missing closing parenthesis');
            pos.i++;
            return result;
        }
        // Function call: fn ( … )
        if (tok.type === 'fn') {
            var name = tok.name; pos.i++;
            if (pos.i >= tokens.length || tokens[pos.i].type !== '(')
                throw new Error('Expected ( after ' + name);
            pos.i++;
            var arg = parseExprAddSub(tokens, pos, steps);
            if (pos.i >= tokens.length || tokens[pos.i].type !== ')')
                throw new Error('Missing closing parenthesis after ' + name + '(...)');
            pos.i++;
            return applyUnaryFunc(name, arg, steps);
        }
        // Constant
        if (tok.type === 'const') {
            pos.i++;
            var c = EXPR_CONSTS[tok.name];
            return { val: c.val, sigFigs: Infinity, decPlaces: Infinity, display: c.display, exact: true };
        }
        // Numeric literal
        if (tok.type === 'num') {
            pos.i++;
            // In expression mode, integer literals (no decimal point, no e-form)
            // are treated as EXACT — this is the textbook convention so that
            // `2^10 = 1024` exactly, not "1×10³ (1 sf)".  Trailing-zero
            // ambiguity is a counting-mode concern, not a calculation one.
            var isExactInt = /^-?\d+$/.test(tok.str) && Number.isInteger(tok.val);
            if (isExactInt) {
                return { val: tok.val, sigFigs: Infinity, decPlaces: Infinity,
                         display: tok.str, exact: true };
            }
            var sf = analyzeSigFigs(tok.str);
            // analyzeSigFigs returns 0 for the literal "0"; clamp to 1
            // so downstream toPrecision()/roundToNSigFigs work safely.
            var nSf = Math.max(1, sf.sigFigs);
            return { val: tok.val, sigFigs: nSf, decPlaces: getDecimalPlaces(tok.str), display: tok.str };
        }
        throw new Error('Unexpected token');
    }

    // ─── Apply unary function with the right sig-fig propagation ─
    function applyUnaryFunc(name, argResult, steps) {
        var spec = EXPR_FUNCS[name];
        if (!spec) throw new Error('Unknown function: ' + name);
        var raw = spec.fn(argResult.val, TRIG_MODE);
        if (!isFinite(raw)) throw new Error(name + '(' + argResult.display + ') is undefined');
        var rule = spec.rule(argResult, raw, TRIG_MODE);
        var display;
        if (rule.decPlaces != null && isFinite(rule.decPlaces)) {
            display = raw.toFixed(Math.max(0, rule.decPlaces));
        } else {
            display = roundToNSigFigs(raw, rule.sigFigs);
        }
        var finalVal = parseFloat(display);
        var finalDP = rule.decPlaces != null && isFinite(rule.decPlaces) ? rule.decPlaces : getDecimalPlaces('' + finalVal);
        steps.push({
            desc: spec.label + '(' + argResult.display + ')',
            raw: '' + parseFloat(raw.toPrecision(10)),
            rule: rule.rule,
            rounded: display
        });
        return { val: finalVal, sigFigs: rule.sigFigs, decPlaces: finalDP, display: display };
    }

    // ─── Combine binary op (+, -, *, /, ^) ───────────────────────
    function combineExprValues(a, b, op, steps) {
        var raw, finalVal, finalSF, finalDP, rule, display;
        var opSym = { '+': '+', '-': '\u2212', '*': '\u00D7', '/': '\u00F7', '^': '^' }[op];
        if (op === '/' && b.val === 0) throw new Error('Division by zero');

        if (op === '+' || op === '-') {
            raw = op === '+' ? a.val + b.val : a.val - b.val;
            finalDP = combineExactDP(a.decPlaces, b.decPlaces);
            if (!isFinite(finalDP)) finalDP = Math.max(getDecimalPlaces('' + a.val), getDecimalPlaces('' + b.val));
            display = raw.toFixed(Math.max(0, finalDP));
            finalVal = parseFloat(display);
            finalSF = analyzeSigFigs(display).sigFigs;
            rule = 'Add/Sub: round to ' + finalDP + ' decimal place' + (finalDP !== 1 ? 's' : '');
        } else if (op === '*' || op === '/') {
            raw = op === '*' ? a.val * b.val : a.val / b.val;
            finalSF = combineExactSF(a.sigFigs, b.sigFigs);
            if (!isFinite(finalSF)) finalSF = Math.max(1, Math.min(analyzeSigFigs('' + a.val).sigFigs, analyzeSigFigs('' + b.val).sigFigs));
            display = roundToNSigFigs(raw, finalSF);
            finalVal = parseFloat(display);
            finalDP = getDecimalPlaces('' + finalVal);
            rule = 'Mul/Div: round to ' + finalSF + ' sig fig' + (finalSF !== 1 ? 's' : '');
        } else if (op === '^') {
            raw = Math.pow(a.val, b.val);
            if (!isFinite(raw)) throw new Error(a.display + '^' + b.display + ' is undefined');
            var nIsExactInt = (b.exact || (Number.isInteger(b.val) && b.decPlaces === 0));
            // Both exact → exact result.  e.g. 2^10 = 1024, 10^3 = 1000.
            // Don't clamp Infinity — let it ride through to the exact-display
            // path in roundToNSigFigs.
            if (a.exact && b.exact) {
                finalSF = Infinity;
                rule = 'Both operands exact \u2192 result is exact';
            } else if (nIsExactInt) {
                finalSF = a.sigFigs;
                if (!isFinite(finalSF)) finalSF = effSigFigs(a);
                rule = 'Power with exact integer exponent: keep ' + finalSF + ' sig fig' + (finalSF !== 1 ? 's' : '') + ' from base';
            } else {
                finalSF = a.sigFigs;
                if (!isFinite(finalSF)) finalSF = effSigFigs(a);
                rule = 'Power: result has same sig figs as the base (' + finalSF + ')';
            }
            display = roundToNSigFigs(raw, finalSF);
            finalVal = parseFloat(display);
            finalDP = isFinite(finalSF) ? getDecimalPlaces('' + finalVal) : Infinity;
        }

        steps.push({
            desc: a.display + ' ' + opSym + ' ' + b.display,
            raw: '' + parseFloat(raw.toPrecision(10)),
            rule: rule,
            rounded: display
        });
        return { val: finalVal, sigFigs: finalSF, decPlaces: finalDP, display: display };
    }

    // Render an expression string for the result panel — replaces the
    // ASCII operators/keywords with their typeset glyphs so users see
    // "log(102) + 2¹⁰ = 1026.009" instead of "log(102) + 2^10 = 1026.009".
    function prettifyExpr(s) {
        if (s == null) return '';
        s = String(s);
        // Order matters — do operator + constant + function replacements
        // FIRST so they don't run over the HTML tags we add for powers.
        s = s.replace(/\*\*/g, '^');     // ** alias → ^ for the sup pass
        s = s.replace(/\*/g, '\u00B7');  // multiplication: ·
        s = s.replace(/(\d|\))\s*\/\s*(\d|\(|[a-zA-Z])/g, '$1 \u00F7 $2');  // divide: ÷  (only between operands; never on tag-closing /)
        s = s.replace(/\bpi\b/g, '\u03C0');
        s = s.replace(/\bsqrt\(/g, '\u221A(');
        // Powers LAST — wrap `^…` in <sup>.  Two patterns: bare number
        // exponent, or parenthesised exponent.
        s = s.replace(/\^\(([^()]+)\)/g, '<sup>($1)</sup>');
        s = s.replace(/\^([+-]?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)/g, '<sup>$1</sup>');
        return s;
    }

    function evaluateExpression() {
        var expr = normalizeScientific(document.getElementById('exprInput').value).trim();
        if (!expr) { ToolUtils.showToast('Please enter a number or expression', 2000, 'warning'); return; }

        // Smart router: bare-number input → show the pedagogical
        // color-coded count display, not the bracketed evaluation result.
        // Detection: digits (with optional sign, decimal, e-notation) only.
        if (/^[+-]?\d*\.?\d+(?:[eE][+-]?\d+)?$/.test(expr)) {
            var result = analyzeSigFigs(expr);
            displaySigFigCount(result, expr);
            return;
        }

        try {
            var tokens = tokenizeExpr(expr);
            var pos = { i: 0 };
            var steps = [];
            var result = parseExprAddSub(tokens, pos, steps);
            if (pos.i < tokens.length) throw new Error('Unexpected token after expression');

            var prettyExpr = prettifyExpr(expr);
            var sfNote = isFinite(result.sigFigs)
                ? (result.sigFigs + ' significant figure' + (result.sigFigs !== 1 ? 's' : ''))
                : 'exact';
            var html = '<div class="result-section">' +
                '<h6><span class="result-badge">EXPRESSION RESULT</span></h6>' +
                '<div class="number-display">' + prettyExpr + ' = ' + result.display + '</div>' +
                '<p>' + sfNote + '</p>';

            if (steps.length > 0) {
                html += '<hr><h6><span class="step-badge">STEP-BY-STEP</span></h6>';
                for (var s = 0; s < steps.length; s++) {
                    html += '<div class="step-section">' +
                        '<p><strong>Step ' + (s + 1) + ':</strong> ' + prettifyExpr(steps[s].desc) + '</p>' +
                        '<p class="indent">Raw: ' + steps[s].raw + '</p>' +
                        '<p class="indent">Rule: ' + steps[s].rule + '</p>' +
                        '<p class="indent">Result: <strong>' + steps[s].rounded + '</strong></p>' +
                        '</div>';
                }
            }
            html += '</div>';

            var plain = expr + ' = ' + result.display + ' (' + result.sigFigs + ' sig figs)';
            showResult(html, plain);
        } catch (e) {
            ToolUtils.showToast(e.message || 'Invalid expression', 3000, 'warning');
        }
    }

    function setExprExample(expr) {
        document.getElementById('exprInput').value = expr;
    }

    // ========== Practice Quiz ==========
    var quizData = [], quizScore = 0, quizAnswered = 0;

    function generateQuiz() {
        quizData = []; quizScore = 0; quizAnswered = 0;
        var pool = [
            { num: '0.00450', sf: 3 }, { num: '1200', sf: 2 }, { num: '1200.', sf: 4 },
            { num: '100', sf: 1 }, { num: '100.0', sf: 4 }, { num: '0.500', sf: 3 },
            { num: '1002', sf: 4 }, { num: '0.0123', sf: 3 }, { num: '45.00', sf: 4 },
            { num: '8000', sf: 1 }, { num: '8000.', sf: 4 }, { num: '0.070', sf: 2 },
            { num: '30.40', sf: 4 }, { num: '0.0001', sf: 1 }, { num: '50.003', sf: 5 },
            { num: '0.200', sf: 3 }, { num: '120', sf: 2 }, { num: '3.14', sf: 3 },
            { num: '6.022e23', sf: 4 }, { num: '1.00e-5', sf: 3 }, { num: '10.0', sf: 3 },
            { num: '0.00208', sf: 3 }, { num: '4050', sf: 3 }, { num: '90.0', sf: 3 }
        ];
        var shuffled = pool.slice().sort(function() { return Math.random() - 0.5; });
        quizData = shuffled.slice(0, 5);
        var container = document.getElementById('quizContainer');
        var html = '';
        for (var i = 0; i < quizData.length; i++) {
            var q = quizData[i];
            var opts = quizGenOptions(q.sf);
            html += '<div class="quiz-question" id="quiz-q-' + i + '">' +
                '<div class="quiz-question-text">Q' + (i + 1) + '. How many sig figs in <span class="quiz-number">' + q.num + '</span>?</div>' +
                '<div class="quiz-options">';
            for (var j = 0; j < opts.length; j++) {
                html += '<button type="button" class="quiz-option" onclick="checkQuizAnswer(' + i + ',' + opts[j] + ',this)">' + opts[j] + '</button>';
            }
            html += '</div><div class="quiz-feedback" id="quiz-fb-' + i + '"></div></div>';
        }
        container.innerHTML = html;
        document.getElementById('quizScore').style.display = 'none';
    }

    function quizGenOptions(correct) {
        var opts = [correct], cands = [];
        for (var i = 1; i <= 7; i++) { if (i !== correct) cands.push(i); }
        cands.sort(function() { return Math.random() - 0.5; });
        opts.push(cands[0], cands[1], cands[2]);
        opts.sort(function() { return Math.random() - 0.5; });
        return opts;
    }

    function checkQuizAnswer(qIdx, answer, btn) {
        var q = quizData[qIdx];
        var fb = document.getElementById('quiz-fb-' + qIdx);
        if (fb.classList.contains('show')) return;
        quizAnswered++;
        var allBtns = document.getElementById('quiz-q-' + qIdx).querySelectorAll('.quiz-option');
        for (var i = 0; i < allBtns.length; i++) {
            allBtns[i].classList.add('disabled');
            if (parseInt(allBtns[i].textContent) === q.sf) allBtns[i].classList.add('correct');
        }
        if (answer === q.sf) {
            quizScore++;
            btn.classList.add('correct');
            fb.textContent = '\u2713 Correct!';
            fb.className = 'quiz-feedback show correct-fb';
        } else {
            btn.classList.add('wrong');
            fb.textContent = '\u2717 Answer: ' + q.sf + ' sig fig' + (q.sf !== 1 ? 's' : '');
            fb.className = 'quiz-feedback show wrong-fb';
        }
        if (quizAnswered >= quizData.length) {
            var scoreEl = document.getElementById('quizScore');
            var msg = quizScore === quizData.length ? ' \u2014 Perfect!' : quizScore >= 3 ? ' \u2014 Good job!' : ' \u2014 Keep practicing!';
            scoreEl.textContent = 'Score: ' + quizScore + ' / ' + quizData.length + msg;
            scoreEl.style.display = 'block';
        }
    }

    // ========== Example Setters ==========
    function setCountExample(num) {
        document.getElementById('countNumber').value = num;
    }

    function setArithmeticExample(op, num1, num2) {
        document.getElementById('arithmeticOp').value = op;
        document.getElementById('arithmeticNum1').value = num1;
        document.getElementById('arithmeticNum2').value = num2;
    }

    function setRoundExample(num, sigFigs) {
        document.getElementById('roundNumber').value = num;
        document.getElementById('roundSigFigs').value = sigFigs;
    }

    function setNotationExample(num) {
        document.getElementById('notationNumber').value = num;
        document.getElementById('notationSigFigs').value = '';
    }

    // ========== Result Actions ==========
    document.getElementById('copyResultBtn').addEventListener('click', function() {
        if (lastResultText) {
            ToolUtils.copyToClipboard(lastResultText, { toolName: TOOL_NAME });
        }
    });

    document.getElementById('shareUrlBtn').addEventListener('click', function() {
        var activeTab = document.querySelector('.sf-mode-btn.active');
        var tabName = activeTab ? activeTab.getAttribute('data-mode') : 'count';
        var params = { tab: tabName };

        if (tabName === 'count') {
            params.num = document.getElementById('countNumber').value;
        } else if (tabName === 'arithmetic') {
            params.op = document.getElementById('arithmeticOp').value;
            params.num1 = document.getElementById('arithmeticNum1').value;
            params.num2 = document.getElementById('arithmeticNum2').value;
        } else if (tabName === 'round') {
            params.num = document.getElementById('roundNumber').value;
            params.sigfigs = document.getElementById('roundSigFigs').value;
        } else if (tabName === 'notation') {
            params.num = document.getElementById('notationNumber').value;
            params.sigfigs = document.getElementById('notationSigFigs').value;
        } else if (tabName === 'expression') {
            params.expr = document.getElementById('exprInput').value;
        }

        var shareUrl = ToolUtils.generateShareUrl(params, { toolName: TOOL_NAME });
        ToolUtils.copyToClipboard(shareUrl, { toolName: TOOL_NAME, toastMessage: 'Share URL copied!' });
    });

    // ========== Trig deg/rad toggle (Calculate mode) ==========
    document.querySelectorAll('[data-trig-mode]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var mode = btn.getAttribute('data-trig-mode');
            setTrigMode(mode);
            document.querySelectorAll('[data-trig-mode]').forEach(function (b) {
                var active = b.getAttribute('data-trig-mode') === mode;
                b.classList.toggle('active', active);
                b.setAttribute('aria-checked', active ? 'true' : 'false');
            });
        });
    });

    // ========== DOMContentLoaded: auto-load from URL params ==========
    document.addEventListener('DOMContentLoaded', function() {
        var urlParams = new URLSearchParams(window.location.search);
        var tab = urlParams.get('tab');
        if (!tab) return;

        // Switch to the requested tab
        var tabBtn = document.querySelector('.sf-mode-btn[data-mode="' + tab + '"]');
        if (tabBtn) tabBtn.click();

        if (tab === 'count' && urlParams.get('num')) {
            document.getElementById('countNumber').value = decodeURIComponent(urlParams.get('num'));
            countSigFigs();
        } else if (tab === 'arithmetic' && urlParams.get('num1') && urlParams.get('num2')) {
            if (urlParams.get('op')) document.getElementById('arithmeticOp').value = decodeURIComponent(urlParams.get('op'));
            document.getElementById('arithmeticNum1').value = decodeURIComponent(urlParams.get('num1'));
            document.getElementById('arithmeticNum2').value = decodeURIComponent(urlParams.get('num2'));
            calculateArithmetic();
        } else if (tab === 'round' && urlParams.get('num') && urlParams.get('sigfigs')) {
            document.getElementById('roundNumber').value = decodeURIComponent(urlParams.get('num'));
            document.getElementById('roundSigFigs').value = decodeURIComponent(urlParams.get('sigfigs'));
            roundToSigFigs();
        } else if (tab === 'notation' && urlParams.get('num')) {
            document.getElementById('notationNumber').value = decodeURIComponent(urlParams.get('num'));
            if (urlParams.get('sigfigs')) document.getElementById('notationSigFigs').value = decodeURIComponent(urlParams.get('sigfigs'));
            convertNotation();
        } else if (tab === 'expression' && urlParams.get('expr')) {
            document.getElementById('exprInput').value = decodeURIComponent(urlParams.get('expr'));
            evaluateExpression();
        } else if (tab === 'practice') {
            generateQuiz();
        }
    });
    </script>

    <script>
    // ── ms-faq accordion (math-studio FAQ pattern) ──
    document.querySelectorAll('.ms-faq-q').forEach(function (q) {
        q.addEventListener('click', function () { q.closest('.ms-faq-item').classList.toggle('open'); });
    });
    </script>

    <!-- ─── Practice worksheet — 1,500-problem sig-fig & scientific-notation bank ─── -->
    <script src="<%=request.getContextPath()%>/js/worksheet-engine.js?v=<%=cacheVersion%>"></script>
    <script>
    (function () {
        function openSigFigWorksheet() {
            if (!window.WorksheetEngine || typeof window.WorksheetEngine.open !== 'function') {
                if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
                    ToolUtils.showToast('Worksheet engine not loaded', 2500, 'warning');
                }
                return;
            }
            window.WorksheetEngine.open({
                jsonUrl: '<%=request.getContextPath()%>/worksheet/math/numerics/significant_figures.json',
                title: 'Significant Figures &amp; Scientific Notation',
                accentColor: '#7c3aed',
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
            var primary = document.getElementById('sf-worksheet-btn');
            if (primary) primary.addEventListener('click', openSigFigWorksheet);
            var toolbar = document.getElementById('sf-worksheet-btn-toolbar');
            if (toolbar) toolbar.addEventListener('click', openSigFigWorksheet);
        });
    })();
    </script>
</body>
</html>
