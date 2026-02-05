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
                    <jsp:param name="toolName" value="Velocity Calculator - Interactive Physics Learning Tool" />
                    <jsp:param name="toolCategory" value="Physics Tools" />
                    <jsp:param name="toolDescription"
                        value="Learn velocity, speed, distance and time with interactive visualizations. Educational physics calculator with real-time animations, step-by-step solutions, and instant feedback. Perfect for students learning kinematics." />
                    <jsp:param name="toolUrl" value="physics/velocity-calculator.jsp" />
                    <jsp:param name="toolKeywords"
                        value="velocity calculator, learn physics, interactive physics, kinematics calculator, speed distance time, physics education, visual learning, physics simulator, velocity formula, educational calculator" />
                    <jsp:param name="toolImage" value="velocity-calculator.png" />
                    <jsp:param name="toolFeatures"
                        value="Interactive learning,Real-time visualization,Step-by-step explanations,Instant feedback,Multiple examples,Unit conversions,Educational animations,Mobile friendly,Free physics tool,Visual physics" />
                    <jsp:param name="faq1q" value="How do I calculate velocity?" />
                    <jsp:param name="faq1a" value="Enter distance (d) and time (t) to calculate average velocity using v = d/t. For final velocity with acceleration, use v = u + at where u is initial velocity and a is acceleration." />
                    <jsp:param name="faq2q" value="What's the difference between speed and velocity?" />
                    <jsp:param name="faq2a" value="Speed is a scalar (magnitude only, e.g., 60 mph). Velocity is a vector (magnitude + direction, e.g., 60 mph north). This calculator handles both - use positive/negative values for direction." />
                    <jsp:param name="faq3q" value="Is this velocity calculator free to use?" />
                    <jsp:param name="faq3a" value="Yes, 100% free with no signup required. All calculations happen instantly in your browser with interactive visualizations to help you learn." />
                    <jsp:param name="faq4q" value="Can I use this for my physics class?" />
                    <jsp:param name="faq4a" value="Absolutely! Perfect for high school and college kinematics. The step-by-step solutions show exactly which formulas are used, making it great for homework and exam prep." />
                    <jsp:param name="faq5q" value="What units are supported?" />
                    <jsp:param name="faq5a" value="Supports m/s, km/h, mph, ft/s for velocity. Distance units include meters, kilometers, miles, feet. Time units: seconds, minutes, hours. Automatic conversions included." />
                </jsp:include>

                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap"
                    rel="stylesheet">

                <link rel="stylesheet"
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
                            grid-template-columns: 420px 1fr;
                            gap: 2rem;
                        }
                    }

                    /* Control Panel - Educational Style */
                    .control-panel {
                        background: var(--surface-1);
                        border-radius: 16px;
                        border: 1px solid var(--border-light);
                        box-shadow: var(--shadow-md);
                        overflow: hidden;
                    }

                    .panel-header {
                        background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple));
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

                    /* Mode Selector - Educational */
                    .mode-selector {
                        display: grid;
                        grid-template-columns: repeat(3, 1fr);
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
                        background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple));
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

                    /* Input Groups - Clean & Educational */
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

                    .input-wrapper {
                        position: relative;
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
                        border-color: var(--physics-blue);
                        box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
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
                        border-color: var(--physics-blue);
                        box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
                    }

                    /* Result Display - Prominent */
                    .result-card {
                        background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple));
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

                    /* Visualization Panel - Educational Focus */
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

                    /* Interactive Animation - Educational */
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
                        transition: left 2s cubic-bezier(0.4, 0, 0.2, 1);
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

                    /* Formula Explanation - Educational */
                    .formula-section {
                        background: var(--surface-2);
                        border-radius: 12px;
                        padding: 1.5rem;
                        margin-bottom: 2rem;
                        border-left: 4px solid var(--physics-blue);
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
                        background: var(--physics-blue);
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
                        background: rgba(37, 99, 235, 0.1);
                        padding: 0.25rem 0.75rem;
                        border-radius: 6px;
                        font-family: 'JetBrains Mono', monospace;
                        font-weight: 600;
                        color: var(--physics-blue);
                        margin: 0.25rem 0;
                    }

                    /* Example Cards - Interactive Learning */
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
                        border-color: var(--physics-blue);
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

                    /* Educational Content */
                    .edu-content {
                        margin-top: 3rem;
                        background: var(--surface-1);
                        border-radius: 16px;
                        padding: 2rem;
                        border: 1px solid var(--border-light);
                    }

                    .edu-content h2 {
                        font-size: 1.75rem;
                        font-weight: 700;
                        color: var(--text-primary);
                        margin: 0 0 1rem 0;
                    }

                    .edu-content h3 {
                        font-size: 1.25rem;
                        font-weight: 600;
                        color: var(--text-primary);
                        margin: 2rem 0 1rem 0;
                    }

                    .edu-content p {
                        color: var(--text-secondary);
                        line-height: 1.7;
                        margin-bottom: 1rem;
                    }

                    .edu-content ul,
                    .edu-content ol {
                        color: var(--text-secondary);
                        line-height: 1.7;
                        margin-bottom: 1rem;
                        padding-left: 1.5rem;
                    }

                    .edu-content li {
                        margin-bottom: 0.5rem;
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
                        stroke: var(--physics-blue);
                        stroke-width: 3;
                        stroke-linecap: round;
                    }

                    .graph-point {
                        fill: var(--physics-purple);
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

                    /* Info Box */
                    .info-box {
                        background: linear-gradient(135deg, rgba(37, 99, 235, 0.1), rgba(124, 58, 237, 0.1));
                        border-left: 4px solid var(--physics-blue);
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

                    <!-- Breadcrumbs -->
                    <nav class="breadcrumbs">
                        <div class="breadcrumbs-container">
                            <a href="<%=request.getContextPath()%>/">Home</a>
                            <span class="breadcrumb-separator">›</span>
                            <a href="<%=request.getContextPath()%>/physics/">Physics Tools</a>
                            <span class="breadcrumb-separator">›</span>
                            <span class="breadcrumb-current">Velocity Calculator</span>
                        </div>
                    </nav>

                    <!-- Tool Header -->
                    <header class="tool-header" style="padding: 1rem 1.5rem;">
                        <div class="tool-header-container">
                            <h1 class="tool-page-title" style="margin: 0; font-size: 1.75rem;">⚡ Velocity Calculator
                            </h1>
                        </div>
                    </header>

                    <!-- Main Content -->
                    <main class="tool-main">
                        <div class="tool-container">
                            <div class="edu-container">

                                <!-- Info Box -->
                                <div class="info-box">
                                    <div class="info-box-title">
                                        <span>ℹ️</span>
                                        <span>Constant Velocity Calculator (a = 0)</span>
                                    </div>
                                    <p class="info-box-content">
                                        This calculator uses <strong>v = d / t</strong> for uniform motion where
                                        <strong>acceleration = 0</strong>.
                                        Use it when speed stays constant - like cruise control, steady train, or
                                        constant walking pace.
                                        <strong>For accelerating/decelerating motion, you'll need different formulas (v
                                            = u + at, etc.).</strong>
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
                                            <div class="mode-selector">
                                                <button class="mode-btn active" onclick="setMode('velocity')">
                                                    <span>Velocity</span>
                                                </button>
                                                <button class="mode-btn" onclick="setMode('distance')">
                                                    <span>Distance</span>
                                                </button>
                                                <button class="mode-btn" onclick="setMode('time')">
                                                    <span>Time</span>
                                                </button>
                                            </div>

                                            <!-- Velocity Mode -->
                                            <div id="velocity-inputs">
                                                <div class="input-section">
                                                    <div class="input-label">
                                                        <span class="emoji">📏</span>
                                                        <span>Distance</span>
                                                    </div>
                                                    <div class="input-row">
                                                        <input type="number" id="distance" class="number-input"
                                                            value="100" oninput="calculate()">
                                                        <select id="distance-unit" class="unit-select"
                                                            onchange="calculate()">
                                                            <option value="m">meters</option>
                                                            <option value="km" selected>kilometers</option>
                                                            <option value="mi">miles</option>
                                                            <option value="ft">feet</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="input-section">
                                                    <div class="input-label">
                                                        <span class="emoji">⏱️</span>
                                                        <span>Time</span>
                                                    </div>
                                                    <div class="input-row">
                                                        <input type="number" id="time" class="number-input" value="2"
                                                            oninput="calculate()">
                                                        <select id="time-unit" class="unit-select"
                                                            onchange="calculate()">
                                                            <option value="s">seconds</option>
                                                            <option value="min">minutes</option>
                                                            <option value="h" selected>hours</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Distance Mode -->
                                            <div id="distance-inputs" style="display: none;">
                                                <div class="input-section">
                                                    <div class="input-label">
                                                        <span class="emoji">⚡</span>
                                                        <span>Velocity</span>
                                                    </div>
                                                    <div class="input-row">
                                                        <input type="number" id="velocity-d" class="number-input"
                                                            value="50" oninput="calculate()">
                                                        <select id="velocity-d-unit" class="unit-select"
                                                            onchange="calculate()">
                                                            <option value="m/s">m/s</option>
                                                            <option value="km/h" selected>km/h</option>
                                                            <option value="mph">mph</option>
                                                            <option value="ft/s">ft/s</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="input-section">
                                                    <div class="input-label">
                                                        <span class="emoji">⏱️</span>
                                                        <span>Time</span>
                                                    </div>
                                                    <div class="input-row">
                                                        <input type="number" id="time-d" class="number-input" value="2"
                                                            oninput="calculate()">
                                                        <select id="time-d-unit" class="unit-select"
                                                            onchange="calculate()">
                                                            <option value="s">seconds</option>
                                                            <option value="min">minutes</option>
                                                            <option value="h" selected>hours</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Time Mode -->
                                            <div id="time-inputs" style="display: none;">
                                                <div class="input-section">
                                                    <div class="input-label">
                                                        <span class="emoji">📏</span>
                                                        <span>Distance</span>
                                                    </div>
                                                    <div class="input-row">
                                                        <input type="number" id="distance-t" class="number-input"
                                                            value="100" oninput="calculate()">
                                                        <select id="distance-t-unit" class="unit-select"
                                                            onchange="calculate()">
                                                            <option value="m">meters</option>
                                                            <option value="km" selected>kilometers</option>
                                                            <option value="mi">miles</option>
                                                            <option value="ft">feet</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="input-section">
                                                    <div class="input-label">
                                                        <span class="emoji">⚡</span>
                                                        <span>Velocity</span>
                                                    </div>
                                                    <div class="input-row">
                                                        <input type="number" id="velocity-t" class="number-input"
                                                            value="50" oninput="calculate()">
                                                        <select id="velocity-t-unit" class="unit-select"
                                                            onchange="calculate()">
                                                            <option value="m/s">m/s</option>
                                                            <option value="km/h" selected>km/h</option>
                                                            <option value="mph">mph</option>
                                                            <option value="ft/s">ft/s</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Result -->
                                            <div class="result-card">
                                                <div class="result-label">Result</div>
                                                <div class="result-main" id="result-value">50 km/h</div>
                                                <div class="result-conversions" id="conversions"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Visualization Panel -->
                                    <div class="viz-panel">
                                        <div class="viz-header">
                                            <h3>📊 Live Visualization</h3>
                                            <p>Watch the relationship between velocity, distance, and time</p>
                                        </div>

                                        <div class="animation-stage">
                                            <div class="stage-info">
                                                <div class="info-badge">
                                                    <div class="label">Distance</div>
                                                    <div class="value" id="distance-viz">100 km</div>
                                                </div>
                                                <div class="info-badge">
                                                    <div class="label">Time</div>
                                                    <div class="value" id="time-viz">2.0 h</div>
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

                                                    <!-- Graph line (horizontal for constant velocity) -->
                                                    <path id="v-t-line" class="graph-line" d="M 40 90 L 280 90" />
                                                    <circle id="v-t-point" class="graph-point" cx="40" cy="90" />
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

                                                    <!-- Graph line (diagonal for constant velocity) -->
                                                    <path id="s-t-line" class="graph-line" d="M 40 160 L 280 20" />
                                                    <circle id="s-t-point" class="graph-point" cx="40" cy="160" />
                                                </svg>
                                            </div>
                                        </div>

                                        <div class="formula-section">
                                            <h4>📝 Step-by-Step Solution</h4>
                                            <div id="formula-steps"></div>
                                        </div>

                                        <div class="examples-section">
                                            <h4>💡 Try These Examples</h4>
                                            <div class="examples-grid">
                                                <div class="example-card" onclick="loadExample(1)">
                                                    <div class="example-icon">🚗</div>
                                                    <div class="example-title">Car Trip</div>
                                                    <div class="example-desc">100 km in 2 hours</div>
                                                </div>
                                                <div class="example-card" onclick="loadExample(2)">
                                                    <div class="example-icon">🏃</div>
                                                    <div class="example-title">Running</div>
                                                    <div class="example-desc">5 km in 30 min</div>
                                                </div>
                                                <div class="example-card" onclick="loadExample(3)">
                                                    <div class="example-icon">✈️</div>
                                                    <div class="example-title">Airplane</div>
                                                    <div class="example-desc">900 km in 1 hour</div>
                                                </div>
                                                <div class="example-card" onclick="loadExample(4)">
                                                    <div class="example-icon">🚴</div>
                                                    <div class="example-title">Cycling</div>
                                                    <div class="example-desc">20 km in 1 hour</div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Related Tools -->
                                        <div class="examples-section">
                                            <h4>🔗 Related Tools</h4>
                                            <div class="examples-grid">
                                                <a href="<%=request.getContextPath()%>/physics/acceleration-calculator.jsp"
                                                    style="text-decoration: none;">
                                                    <div class="example-card">
                                                        <div class="example-icon">⚡</div>
                                                        <div class="example-title">Acceleration Calculator</div>
                                                        <div class="example-desc">For changing velocity (a ≠ 0)</div>
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

                                <!-- Educational Content -->
                                <div class="edu-content">
                                    <h2>Understanding Velocity, Distance, and Time</h2>
                                    <p>Velocity is one of the fundamental concepts in physics that describes how fast an
                                        object moves. This interactive calculator helps you understand the relationship
                                        between velocity, distance, and time through visual learning and step-by-step
                                        explanations.</p>

                                    <h3>The Velocity Formula</h3>
                                    <p>The relationship between velocity (v), distance (d), and time (t) is expressed by
                                        three interconnected formulas:</p>
                                    <ul>
                                        <li><strong>Velocity = Distance ÷ Time</strong> → v = d / t</li>
                                        <li><strong>Distance = Velocity × Time</strong> → d = v × t</li>
                                        <li><strong>Time = Distance ÷ Velocity</strong> → t = d / v</li>
                                    </ul>

                                    <h3>How to Use This Calculator</h3>
                                    <ol>
                                        <li><strong>Choose what to calculate:</strong> Select whether you want to find
                                            velocity, distance, or time</li>
                                        <li><strong>Enter known values:</strong> Input the two values you know with
                                            their units</li>
                                        <li><strong>Watch the visualization:</strong> See how the values relate to each
                                            other in real-time</li>
                                        <li><strong>Study the solution:</strong> Review the step-by-step calculation to
                                            understand the process</li>
                                        <li><strong>Try examples:</strong> Click on example scenarios to see different
                                            real-world applications</li>
                                    </ol>

                                    <h3>Real-World Applications</h3>
                                    <p>Understanding velocity is essential for:</p>
                                    <ul>
                                        <li><strong>Transportation:</strong> Calculating travel times, fuel efficiency,
                                            and trip planning</li>
                                        <li><strong>Sports:</strong> Analyzing athlete performance, race times, and
                                            training metrics</li>
                                        <li><strong>Science:</strong> Studying motion, forces, and energy in physics
                                        </li>
                                        <li><strong>Engineering:</strong> Designing vehicles, machines, and
                                            transportation systems</li>
                                        <li><strong>Daily Life:</strong> Estimating arrival times, comparing speeds, and
                                            making decisions</li>
                                    </ul>

                                    <h3>Units of Measurement</h3>
                                    <p>This calculator supports multiple unit systems to match your needs:</p>
                                    <ul>
                                        <li><strong>Distance:</strong> meters (m), kilometers (km), miles (mi), feet
                                            (ft)</li>
                                        <li><strong>Time:</strong> seconds (s), minutes (min), hours (h)</li>
                                        <li><strong>Velocity:</strong> m/s, km/h, mph, ft/s</li>
                                    </ul>

                                    <h3>Learning Tips</h3>
                                    <ul>
                                        <li>Start with simple examples and gradually increase complexity</li>
                                        <li>Pay attention to the units - they must be consistent in calculations</li>
                                        <li>Use the visualization to develop intuition about the relationships</li>
                                        <li>Try to predict the answer before calculating to test your understanding</li>
                                        <li>Practice with real-world scenarios to make learning more meaningful</li>
                                    </ul>
                                </div>

                            </div>
                        </div>
                    </main>

                    <!-- Footer -->
                    <footer class="tool-page-footer">
                        <div class="tool-page-footer-inner">
                            <p>&copy; 2025 8gwifi.org. All rights reserved.</p>
                        </div>
                    </footer>

                    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
                        <script
                            src="<%=request.getContextPath()%>/physics/js/velocity-calculator.js?v=<%=cacheVersion%>"></script>
            </body>

            </html>