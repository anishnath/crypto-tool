<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.*" %>
        <% String cacheVersion=String.valueOf(System.currentTimeMillis()); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta name="robots" content="index,follow">

                <jsp:include page="../modern/components/seo-tool-page.jsp">
                    <jsp:param name="toolName"
                        value="Acceleration Calculator - Calculate Velocity, Distance & Time with Acceleration" />
                    <jsp:param name="toolCategory" value="Physics Tools" />
                    <jsp:param name="toolDescription"
                        value="Free acceleration calculator for motion with constant acceleration. Calculate final velocity, distance, time using kinematic equations. Features step-by-step solutions, interactive visualization, and unit conversions. Perfect for physics students." />
                    <jsp:param name="toolUrl" value="physics/acceleration-calculator.jsp" />
                    <jsp:param name="toolKeywords"
                        value="acceleration calculator, kinematics calculator, physics calculator, v=u+at calculator, motion calculator, constant acceleration, kinematic equations, physics homework help, free fall calculator" />
                    <jsp:param name="toolImage" value="acceleration-calculator.png" />
                    <jsp:param name="toolFeatures"
                        value="Interactive acceleration calculator,Calculate final velocity,Calculate distance,Calculate time,Kinematic equations,Step-by-step solutions,Unit conversions,Visual animations,Free physics tool,Educational calculator" />
                    <jsp:param name="faq1q" value="How do I calculate acceleration?" />
                    <jsp:param name="faq1a" value="Enter initial velocity (u), final velocity (v), and time (t). The calculator uses a = (v-u)/t to compute acceleration. You can also use distance and time with s = ut + ½at²." />
                    <jsp:param name="faq2q" value="Is this acceleration calculator free?" />
                    <jsp:param name="faq2a" value="Yes, completely free with no registration required. All calculations run in your browser for instant results." />
                    <jsp:param name="faq3q" value="What units does the acceleration calculator support?" />
                    <jsp:param name="faq3a" value="Supports SI units (m/s²) and Imperial (ft/s²). Automatic unit conversion for velocity (m/s, km/h, mph) and time (s, min, h)." />
                    <jsp:param name="faq4q" value="Can I use this for physics homework?" />
                    <jsp:param name="faq4a" value="Yes! Perfect for high school and college physics. Includes step-by-step solutions showing all kinematic equations used, so you can learn while solving problems." />
                    <jsp:param name="faq5q" value="Does this work for constant acceleration only?" />
                    <jsp:param name="faq5a" value="Yes, this calculator uses kinematic equations (SUVAT) which apply to motion with constant acceleration. For variable acceleration, use calculus-based methods." />
                </jsp:include>

                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap"
                    rel="stylesheet">

                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">

                <style>
                    :root {
                        --physics-blue: #2563eb;
                        --physics-purple: #7c3aed;
                        --physics-green: #059669;
                        --physics-orange: #ea580c;
                        --physics-red: #dc2626;
                        --surface-1: #ffffff;
                        --surface-2: #f8fafc;
                        --surface-3: #f1f5f9;
                        --text-primary: #0f172a;
                        --text-secondary: #475569;
                        --text-tertiary: #94a3b8;
                        --border-light: #e2e8f0;
                        --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
                        --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
                        --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
                    }

                    [data-theme="dark"] {
                        --surface-1: #1e293b;
                        --surface-2: #0f172a;
                        --surface-3: #334155;
                        --text-primary: #f1f5f9;
                        --text-secondary: #cbd5e1;
                        --text-tertiary: #64748b;
                        --border-light: #334155;
                    }

                    /* Dark mode for tool header */
                    [data-theme="dark"] .tool-header {
                        background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
                    }

                    [data-theme="dark"] .tool-page-title,
                    [data-theme="dark"] .tool-page-description {
                        color: var(--text-primary);
                    }

                    body {
                        font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                        background: var(--surface-2);
                    }

                    /* Educational Layout */
                    .edu-container {
                        max-width: 1400px;
                        margin: 0 auto;
                        padding: 2rem 1rem;
                    }

                    .edu-grid {
                        display: grid;
                        grid-template-columns: 1fr;
                        gap: 1.5rem;
                    }

                    @media (min-width: 1024px) {
                        .edu-grid {
                            grid-template-columns: 380px 1fr;
                            gap: 2rem;
                        }
                    }

                    /* Back Link */
                    .back-link {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        color: var(--physics-blue);
                        font-weight: 600;
                        text-decoration: none;
                        margin-bottom: 1rem;
                    }

                    .back-link:hover {
                        text-decoration: underline;
                    }

                    /* Control Panel */
                    .control-panel {
                        background: var(--surface-1);
                        border-radius: 16px;
                        border: 1px solid var(--border-light);
                        box-shadow: var(--shadow-md);
                        overflow: hidden;
                    }

                    .panel-header {
                        background: linear-gradient(135deg, var(--physics-orange), var(--physics-red));
                        color: white;
                        padding: 1.5rem;
                        text-align: center;
                    }

                    .panel-header h2 {
                        margin: 0 0 0.5rem 0;
                        font-size: 1.5rem;
                        font-weight: 700;
                    }

                    .panel-header p {
                        margin: 0;
                        opacity: 0.95;
                        font-size: 0.9rem;
                    }

                    .panel-body {
                        padding: 1.5rem;
                    }

                    /* Mode Selector */
                    .mode-selector {
                        display: grid;
                        grid-template-columns: repeat(2, 1fr);
                        gap: 0.5rem;
                        margin-bottom: 1.5rem;
                        padding: 0.5rem;
                        background: var(--surface-2);
                        border-radius: 12px;
                    }

                    .mode-btn {
                        padding: 0.875rem 0.5rem;
                        background: transparent;
                        border: 2px solid transparent;
                        border-radius: 8px;
                        color: var(--text-secondary);
                        font-weight: 600;
                        font-size: 0.875rem;
                        cursor: pointer;
                        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
                        position: relative;
                    }

                    .mode-btn::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: linear-gradient(135deg, var(--physics-orange), var(--physics-red));
                        opacity: 0;
                        border-radius: 6px;
                        transition: opacity 0.2s;
                    }

                    .mode-btn span {
                        position: relative;
                        z-index: 1;
                    }

                    .mode-btn.active {
                        color: white;
                        border-color: transparent;
                    }

                    .mode-btn.active::before {
                        opacity: 1;
                    }

                    .mode-btn:hover:not(.active) {
                        background: var(--surface-3);
                    }

                    /* Input Groups */
                    .input-section {
                        margin-bottom: 1.5rem;
                    }

                    .input-label {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        margin-bottom: 0.75rem;
                        font-weight: 600;
                        font-size: 0.9375rem;
                        color: var(--text-primary);
                    }

                    .input-label .emoji {
                        font-size: 1.25rem;
                    }

                    .input-row {
                        display: grid;
                        grid-template-columns: 1fr 120px;
                        gap: 0.75rem;
                    }

                    .number-input {
                        width: 100%;
                        padding: 1rem;
                        border: 2px solid var(--border-light);
                        border-radius: 10px;
                        font-size: 1.125rem;
                        font-weight: 600;
                        background: var(--surface-1);
                        color: var(--text-primary);
                        transition: all 0.2s;
                        font-family: 'JetBrains Mono', monospace;
                    }

                    .number-input:focus {
                        outline: none;
                        border-color: var(--physics-orange);
                        box-shadow: 0 0 0 4px rgba(234, 88, 12, 0.1);
                    }

                    .unit-select {
                        padding: 1rem;
                        border: 2px solid var(--border-light);
                        border-radius: 10px;
                        font-size: 0.9375rem;
                        font-weight: 600;
                        background: var(--surface-1);
                        color: var(--text-primary);
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .unit-select:focus {
                        outline: none;
                        border-color: var(--physics-orange);
                        box-shadow: 0 0 0 4px rgba(234, 88, 12, 0.1);
                    }

                    /* Result Display */
                    .result-card {
                        background: linear-gradient(135deg, var(--physics-orange), var(--physics-red));
                        border-radius: 12px;
                        padding: 1.5rem;
                        color: white;
                        margin-top: 1.5rem;
                        box-shadow: var(--shadow-lg);
                    }

                    .result-label {
                        font-size: 0.875rem;
                        opacity: 0.9;
                        margin-bottom: 0.5rem;
                        font-weight: 500;
                    }

                    .result-main {
                        font-size: 2.5rem;
                        font-weight: 800;
                        margin-bottom: 1rem;
                        font-family: 'JetBrains Mono', monospace;
                    }

                    .result-conversions {
                        display: grid;
                        grid-template-columns: repeat(2, 1fr);
                        gap: 0.75rem;
                    }

                    .conversion-item {
                        background: rgba(255, 255, 255, 0.15);
                        backdrop-filter: blur(10px);
                        padding: 0.75rem;
                        border-radius: 8px;
                        text-align: center;
                    }

                    .conversion-value {
                        font-size: 1.125rem;
                        font-weight: 700;
                        font-family: 'JetBrains Mono', monospace;
                    }

                    .conversion-unit {
                        font-size: 0.75rem;
                        opacity: 0.9;
                        margin-top: 0.25rem;
                    }

                    /* Visualization Panel */
                    .viz-panel {
                        background: var(--surface-1);
                        border-radius: 16px;
                        border: 1px solid var(--border-light);
                        box-shadow: var(--shadow-md);
                        padding: 2rem;
                    }

                    .viz-header {
                        margin-bottom: 2rem;
                    }

                    .viz-header h3 {
                        margin: 0 0 0.5rem 0;
                        font-size: 1.75rem;
                        font-weight: 700;
                        color: var(--text-primary);
                    }

                    .viz-header p {
                        margin: 0;
                        color: var(--text-secondary);
                        font-size: 1rem;
                    }

                    /* Animation Stage */
                    .animation-stage {
                        position: relative;
                        height: 280px;
                        background: var(--surface-2);
                        border-radius: 12px;
                        margin-bottom: 2rem;
                        overflow: hidden;
                        border: 2px solid var(--border-light);
                    }

                    .stage-info {
                        position: absolute;
                        top: 1rem;
                        left: 1rem;
                        right: 1rem;
                        display: flex;
                        justify-content: space-between;
                        z-index: 10;
                    }

                    .info-badge {
                        background: var(--surface-1);
                        padding: 0.5rem 1rem;
                        border-radius: 8px;
                        font-weight: 600;
                        font-size: 0.875rem;
                        color: var(--text-primary);
                        box-shadow: var(--shadow-sm);
                        border: 1px solid var(--border-light);
                    }

                    .info-badge .label {
                        color: var(--text-tertiary);
                        font-size: 0.75rem;
                        display: block;
                        margin-bottom: 0.125rem;
                    }

                    .info-badge .value {
                        font-family: 'JetBrains Mono', monospace;
                        font-size: 1rem;
                    }

                    .road {
                        position: absolute;
                        bottom: 80px;
                        left: 0;
                        right: 0;
                        height: 60px;
                        background: linear-gradient(to bottom, #64748b 0%, #475569 100%);
                    }

                    .road-line {
                        position: absolute;
                        top: 50%;
                        left: 0;
                        right: 0;
                        height: 3px;
                        background: repeating-linear-gradient(to right,
                                white 0px,
                                white 30px,
                                transparent 30px,
                                transparent 60px);
                        transform: translateY(-50%);
                    }

                    .vehicle-container {
                        position: absolute;
                        bottom: 90px;
                        left: 40px;
                        transition: left 2s cubic-bezier(0.25, 0.46, 0.45, 0.94);
                    }

                    .vehicle {
                        font-size: 4.5rem;
                        filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.2));
                    }

                    .distance-markers {
                        position: absolute;
                        bottom: 40px;
                        left: 40px;
                        right: 40px;
                        display: flex;
                        justify-content: space-between;
                        font-size: 0.875rem;
                        font-weight: 600;
                        color: var(--text-secondary);
                    }

                    /* Formula Section */
                    .formula-section {
                        background: var(--surface-2);
                        border-radius: 12px;
                        padding: 1.5rem;
                        margin-bottom: 2rem;
                        border-left: 4px solid var(--physics-orange);
                    }

                    .formula-section h4 {
                        margin: 0 0 1rem 0;
                        font-size: 1.125rem;
                        font-weight: 700;
                        color: var(--text-primary);
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .step {
                        margin-bottom: 1rem;
                        padding-left: 1.5rem;
                        position: relative;
                    }

                    .step::before {
                        content: '';
                        position: absolute;
                        left: 0;
                        top: 0.5rem;
                        width: 8px;
                        height: 8px;
                        background: var(--physics-orange);
                        border-radius: 50%;
                    }

                    .step-label {
                        font-weight: 600;
                        color: var(--text-primary);
                        margin-bottom: 0.25rem;
                    }

                    .step-content {
                        color: var(--text-secondary);
                        line-height: 1.6;
                    }

                    .formula {
                        display: inline-block;
                        background: rgba(234, 88, 12, 0.1);
                        padding: 0.25rem 0.75rem;
                        border-radius: 6px;
                        font-family: 'JetBrains Mono', monospace;
                        font-weight: 600;
                        color: var(--physics-orange);
                        margin: 0.25rem 0;
                    }

                    /* Example Cards */
                    .examples-section {
                        margin-top: 2rem;
                    }

                    .examples-section h4 {
                        margin: 0 0 1rem 0;
                        font-size: 1.125rem;
                        font-weight: 700;
                        color: var(--text-primary);
                    }

                    .examples-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 1rem;
                    }

                    .example-card {
                        background: var(--surface-2);
                        border: 2px solid var(--border-light);
                        border-radius: 10px;
                        padding: 1rem;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .example-card:hover {
                        border-color: var(--physics-orange);
                        transform: translateY(-2px);
                        box-shadow: var(--shadow-md);
                    }

                    .example-icon {
                        font-size: 2rem;
                        margin-bottom: 0.5rem;
                    }

                    .example-title {
                        font-weight: 600;
                        color: var(--text-primary);
                        margin-bottom: 0.25rem;
                        font-size: 0.9375rem;
                    }

                    .example-desc {
                        color: var(--text-secondary);
                        font-size: 0.8125rem;
                    }

                    /* Info Box */
                    .info-box {
                        background: linear-gradient(135deg, rgba(234, 88, 12, 0.1), rgba(220, 38, 38, 0.1));
                        border-left: 4px solid var(--physics-orange);
                        border-radius: 12px;
                        padding: 1rem 1.25rem;
                        margin-bottom: 2rem;
                    }

                    .info-box-title {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        font-weight: 700;
                        color: var(--text-primary);
                        margin-bottom: 0.5rem;
                        font-size: 0.9375rem;
                    }

                    .info-box-content {
                        color: var(--text-secondary);
                        font-size: 0.875rem;
                        line-height: 1.6;
                        margin: 0;
                    }

                    .info-box-content strong {
                        color: var(--text-primary);
                        font-weight: 600;
                    }

                    /* Interactive Graphs */
                    .graphs-container {
                        display: grid;
                        grid-template-columns: repeat(2, 1fr);
                        gap: 1.5rem;
                        margin-top: 2rem;
                    }

                    .graph-card {
                        background: var(--surface-2);
                        border-radius: 12px;
                        padding: 1.5rem;
                        border: 2px solid var(--border-light);
                    }

                    .graph-title {
                        font-weight: 700;
                        color: var(--text-primary);
                        margin-bottom: 1rem;
                        font-size: 1rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .graph-svg {
                        width: 100%;
                        height: 200px;
                        background: var(--surface-1);
                        border-radius: 8px;
                    }

                    .graph-axis {
                        stroke: var(--text-tertiary);
                        stroke-width: 2;
                    }

                    .graph-grid {
                        stroke: var(--border-light);
                        stroke-width: 1;
                        stroke-dasharray: 4 4;
                    }

                    .graph-line {
                        fill: none;
                        stroke: var(--physics-orange);
                        stroke-width: 3;
                        stroke-linecap: round;
                    }

                    .graph-point {
                        fill: var(--physics-red);
                        r: 5;
                    }

                    .graph-label {
                        fill: var(--text-secondary);
                        font-size: 12px;
                        font-weight: 600;
                    }

                    @media (max-width: 768px) {
                        .graphs-container {
                            grid-template-columns: 1fr;
                        }
                    }

                    @media (max-width: 1023px) {
                        .result-main {
                            font-size: 2rem;
                        }

                        .animation-stage {
                            height: 220px;
                        }

                        .vehicle {
                            font-size: 3rem;
                        }

                        .road {
                            bottom: 60px;
                            height: 40px;
                        }

                        .vehicle-container {
                            bottom: 70px;
                        }

                        .distance-markers {
                            bottom: 25px;
                        }
                    }
                </style>
            </head>

            <body>
                <%@ include file="../modern/components/nav-header.jsp" %>

                    <!-- Tool Header -->
                    <header class="tool-header" style="padding: 1rem 1.5rem; margin-top: 72px;">
                        <div class="tool-header-container">
                            <h1 class="tool-page-title" style="margin: 0; font-size: 1.75rem;">⚡ Acceleration Calculator
                            </h1>
                        </div>
                    </header>

                    <!-- Main Content -->
                    <main class="edu-container">
                        <a href="<%=request.getContextPath()%>/physics/" class="back-link">← Physics Tools</a>

                        <!-- Info Box -->
                        <div class="info-box">
                            <div class="info-box-title">
                                <span>ℹ️</span>
                                <span>Acceleration Calculator (a ≠ 0)</span>
                            </div>
                            <p class="info-box-content">
                                This calculator is for <strong>constant acceleration</strong> motion using
                                kinematic equations.
                                Use it for objects speeding up or slowing down at a steady rate - like cars
                                accelerating,
                                braking vehicles, or free-falling objects. <strong>Uses formulas: v = u + at, s
                                    = ut + ½at², v² = u² + 2as</strong>
                            </p>
                        </div>

                        <div class="edu-grid">

                            <!-- Control Panel -->
                            <div class="control-panel">
                                <div class="panel-header">
                                    <h2>Calculate</h2>
                                    <p>Choose what you want to find</p>
                                </div>
                                <div class="panel-body">
                                    <div class="mode-selector"
                                        style="grid-template-columns: repeat(3, 1fr); gap: 0.5rem;">
                                        <button class="mode-btn active" onclick="setMode('velocity')">
                                            <span>v = u+at</span>
                                        </button>
                                        <button class="mode-btn" onclick="setMode('velocity-no-time')">
                                            <span>v² = u²+2as</span>
                                        </button>
                                        <button class="mode-btn" onclick="setMode('distance')">
                                            <span>s = ut+½at²</span>
                                        </button>
                                        <button class="mode-btn" onclick="setMode('distance-avg')">
                                            <span>s = ½(u+v)t</span>
                                        </button>
                                        <button class="mode-btn" onclick="setMode('avg-velocity')">
                                            <span>v_avg</span>
                                        </button>
                                    </div>

                                    <!-- Final Velocity Mode (v = u + at) -->
                                    <div id="velocity-inputs">
                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">🚀</span>
                                                <span>Initial Velocity (u)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="initial-velocity" class="number-input"
                                                    value="0" oninput="calculate()">
                                                <select id="initial-velocity-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m/s">m/s</option>
                                                    <option value="km/h">km/h</option>
                                                    <option value="mph">mph</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">⚡</span>
                                                <span>Acceleration (a)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="acceleration" class="number-input"
                                                    value="5" oninput="calculate()">
                                                <select id="acceleration-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m/s²" selected>m/s²</option>
                                                    <option value="km/h²">km/h²</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">⏱️</span>
                                                <span>Time (t)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="time" class="number-input" value="10"
                                                    oninput="calculate()">
                                                <select id="time-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="s" selected>seconds</option>
                                                    <option value="min">minutes</option>
                                                    <option value="h">hours</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Distance Mode (s = ut + ½at²) -->
                                    <div id="distance-inputs" style="display: none;">
                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">🚀</span>
                                                <span>Initial Velocity (u)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="initial-velocity-d"
                                                    class="number-input" value="0" oninput="calculate()">
                                                <select id="initial-velocity-d-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m/s">m/s</option>
                                                    <option value="km/h">km/h</option>
                                                    <option value="mph">mph</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">⚡</span>
                                                <span>Acceleration (a)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="acceleration-d" class="number-input"
                                                    value="5" oninput="calculate()">
                                                <select id="acceleration-d-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m/s²" selected>m/s²</option>
                                                    <option value="km/h²">km/h²</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">⏱️</span>
                                                <span>Time (t)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="time-d" class="number-input" value="10"
                                                    oninput="calculate()">
                                                <select id="time-d-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="s" selected>seconds</option>
                                                    <option value="min">minutes</option>
                                                    <option value="h">hours</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Velocity No Time Mode (v² = u² + 2as) -->
                                    <div id="velocity-no-time-inputs" style="display: none;">
                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">🚀</span>
                                                <span>Initial Velocity (u)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="initial-velocity-vnt"
                                                    class="number-input" value="0" oninput="calculate()">
                                                <select id="initial-velocity-vnt-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m/s">m/s</option>
                                                    <option value="km/h">km/h</option>
                                                    <option value="mph">mph</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">⚡</span>
                                                <span>Acceleration (a)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="acceleration-vnt" class="number-input"
                                                    value="5" oninput="calculate()">
                                                <select id="acceleration-vnt-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m/s²" selected>m/s²</option>
                                                    <option value="km/h²">km/h²</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">📏</span>
                                                <span>Distance (s)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="distance-vnt" class="number-input"
                                                    value="100" oninput="calculate()">
                                                <select id="distance-vnt-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m" selected>meters</option>
                                                    <option value="km">kilometers</option>
                                                    <option value="mi">miles</option>
                                                    <option value="ft">feet</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Distance Average Mode (s = ½(u+v)t) -->
                                    <div id="distance-avg-inputs" style="display: none;">
                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">🚀</span>
                                                <span>Initial Velocity (u)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="initial-velocity-da"
                                                    class="number-input" value="0" oninput="calculate()">
                                                <select id="initial-velocity-da-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m/s">m/s</option>
                                                    <option value="km/h">km/h</option>
                                                    <option value="mph">mph</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">🏁</span>
                                                <span>Final Velocity (v)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="final-velocity-da" class="number-input"
                                                    value="50" oninput="calculate()">
                                                <select id="final-velocity-da-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m/s">m/s</option>
                                                    <option value="km/h">km/h</option>
                                                    <option value="mph">mph</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">⏱️</span>
                                                <span>Time (t)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="time-da" class="number-input"
                                                    value="10" oninput="calculate()">
                                                <select id="time-da-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="s" selected>seconds</option>
                                                    <option value="min">minutes</option>
                                                    <option value="h">hours</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Average Velocity Mode (v_avg = (u+v)/2) -->
                                    <div id="avg-velocity-inputs" style="display: none;">
                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">🚀</span>
                                                <span>Initial Velocity (u)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="initial-velocity-av"
                                                    class="number-input" value="0" oninput="calculate()">
                                                <select id="initial-velocity-av-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m/s">m/s</option>
                                                    <option value="km/h">km/h</option>
                                                    <option value="mph">mph</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="input-section">
                                            <div class="input-label">
                                                <span class="emoji">🏁</span>
                                                <span>Final Velocity (v)</span>
                                            </div>
                                            <div class="input-row">
                                                <input type="number" id="final-velocity-av" class="number-input"
                                                    value="50" oninput="calculate()">
                                                <select id="final-velocity-av-unit" class="unit-select"
                                                    onchange="calculate()">
                                                    <option value="m/s">m/s</option>
                                                    <option value="km/h">km/h</option>
                                                    <option value="mph">mph</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Result -->
                                    <div class="result-card">
                                        <div class="result-label">Result</div>
                                        <div class="result-main" id="result-value">50 m/s</div>
                                        <div class="result-conversions" id="conversions"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Visualization Panel -->
                            <div class="viz-panel">
                                <div class="viz-header">
                                    <h3>📊 Live Visualization</h3>
                                    <p>Watch acceleration in action</p>
                                </div>

                                <div class="animation-stage">
                                    <div class="stage-info">
                                        <div class="info-badge">
                                            <div class="label">Acceleration</div>
                                            <div class="value" id="accel-viz">5 m/s²</div>
                                        </div>
                                        <div class="info-badge">
                                            <div class="label">Time</div>
                                            <div class="value" id="time-viz">10 s</div>
                                        </div>
                                    </div>
                                    <div class="vehicle-container" id="vehicle-container">
                                        <div class="vehicle" id="vehicle">🚗</div>
                                    </div>
                                    <div class="road">
                                        <div class="road-line"></div>
                                    </div>
                                    <div class="distance-markers">
                                        <span>Start</span>
                                        <span>Finish</span>
                                    </div>
                                </div>

                                <!-- Interactive Graphs -->
                                <div class="graphs-container">
                                    <!-- Velocity-Time Graph -->
                                    <div class="graph-card">
                                        <div class="graph-title">
                                            <span>📈</span>
                                            <span>Velocity vs Time</span>
                                        </div>
                                        <svg class="graph-svg" id="velocity-graph" viewBox="0 0 300 200">
                                            <!-- Grid -->
                                            <line class="graph-grid" x1="40" y1="20" x2="40" y2="160" />
                                            <line class="graph-grid" x1="40" y1="160" x2="280" y2="160" />

                                            <!-- Axes -->
                                            <line class="graph-axis" x1="40" y1="160" x2="280" y2="160" />
                                            <line class="graph-axis" x1="40" y1="20" x2="40" y2="160" />

                                            <!-- Labels -->
                                            <text class="graph-label" x="150" y="190">Time (s)</text>
                                            <text class="graph-label" x="5" y="90"
                                                transform="rotate(-90 5 90)">Velocity (m/s)</text>

                                            <!-- Graph line (will be updated by JS) -->
                                            <path id="v-t-line" class="graph-line" d="M 40 160 L 280 20" />
                                            <circle id="v-t-point" class="graph-point" cx="40" cy="160" />
                                        </svg>
                                    </div>

                                    <!-- Position-Time Graph -->
                                    <div class="graph-card">
                                        <div class="graph-title">
                                            <span>📊</span>
                                            <span>Position vs Time</span>
                                        </div>
                                        <svg class="graph-svg" id="position-graph" viewBox="0 0 300 200">
                                            <!-- Grid -->
                                            <line class="graph-grid" x1="40" y1="20" x2="40" y2="160" />
                                            <line class="graph-grid" x1="40" y1="160" x2="280" y2="160" />

                                            <!-- Axes -->
                                            <line class="graph-axis" x1="40" y1="160" x2="280" y2="160" />
                                            <line class="graph-axis" x1="40" y1="20" x2="40" y2="160" />

                                            <!-- Labels -->
                                            <text class="graph-label" x="150" y="190">Time (s)</text>
                                            <text class="graph-label" x="5" y="90"
                                                transform="rotate(-90 5 90)">Position (m)</text>

                                            <!-- Graph line (will be updated by JS) -->
                                            <path id="s-t-line" class="graph-line"
                                                d="M 40 160 Q 160 90 280 20" />
                                            <circle id="s-t-point" class="graph-point" cx="40" cy="160" />
                                        </svg>
                                    </div>
                                </div>

                                <div class="formula-section">
                                    <h4>📝 Step-by-Step Solution</h4>
                                    <div id="formula-steps"></div>
                                </div>

                                <div class="examples-section">
                                    <h4>💡 Quick Examples</h4>
                                    <div class="examples-grid">
                                        <div class="example-card" onclick="loadExample(1)">
                                            <div class="example-icon">🚗</div>
                                            <div class="example-title">Car Accelerating</div>
                                            <div class="example-desc">0 to 100 km/h</div>
                                        </div>
                                        <div class="example-card" onclick="loadExample(2)">
                                            <div class="example-icon">🪂</div>
                                            <div class="example-title">Free Fall</div>
                                            <div class="example-desc">Gravity: 9.8 m/s²</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Related Tools -->
                                <div class="examples-section">
                                    <h4>🔗 Related Tools</h4>
                                    <div class="examples-grid">
                                        <a href="<%=request.getContextPath()%>/physics/velocity-calculator.jsp"
                                            style="text-decoration: none;">
                                            <div class="example-card">
                                                <div class="example-icon">⚡</div>
                                                <div class="example-title">Velocity Calculator</div>
                                                <div class="example-desc">For constant velocity (a = 0)</div>
                                            </div>
                                        </a>
                                        <a href="<%=request.getContextPath()%>/physics/"
                                            style="text-decoration: none;">
                                            <div class="example-card">
                                                <div class="example-icon">⚛️</div>
                                                <div class="example-title">All Physics Tools</div>
                                                <div class="example-desc">Browse all calculators</div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </main>

                    <footer style="background: var(--surface-1); border-top: 1px solid var(--border-light); padding: 2rem; text-align: center; margin-top: 2rem;">
                        <div class="tool-page-footer-inner">
                            <p style="color: var(--text-secondary); margin: 0;">&copy; 2025 8gwifi.org. All rights reserved.</p>
                        </div>
                    </footer>

                    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

                        <script
                            src="<%=request.getContextPath()%>/physics/js/acceleration-calculator.js?v=<%=cacheVersion%>"></script>
            </body>

            </html>