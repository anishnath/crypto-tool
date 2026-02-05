<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">

    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Spring Force Calculator - Hooke's Law (F = -kx)" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription"
            value="Calculate spring force using Hooke's Law (F = -kx). Find spring constant, displacement, elastic potential energy with interactive visualization and step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/spring-force-calculator.jsp" />
        <jsp:param name="toolKeywords"
            value="spring force calculator, Hooke's law calculator, spring constant, elastic force, displacement calculator, potential energy spring, physics calculator, k constant, spring physics" />
        <jsp:param name="toolImage" value="spring-force-calculator.png" />
        <jsp:param name="toolFeatures"
            value="Hooke's Law F=-kx,Spring constant calculator,Displacement calculation,Elastic potential energy,Interactive spring visualization,Step-by-step solutions,Unit conversions,Real-world examples" />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">

    <style>
        :root {
            --physics-blue: #2563eb;
            --physics-purple: #7c3aed;
            --physics-green: #059669;
            --physics-orange: #ea580c;
            --physics-pink: #db2777;
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

        [data-theme="dark"], .dark-mode {
            --surface-1: #1e293b;
            --surface-2: #0f172a;
            --surface-3: #334155;
            --text-primary: #f1f5f9;
            --text-secondary: #cbd5e1;
            --text-tertiary: #64748b;
            --border-light: #334155;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--surface-2);
            margin: 0;
        }

        .tool-header {
            background: linear-gradient(135deg, #db2777 0%, #9333ea 100%);
            padding: 1.25rem 1.5rem;
            margin-top: 72px;
            border-bottom: 1px solid var(--border-light);
        }

        .tool-header-container { max-width: 1400px; margin: 0 auto; }

        .tool-page-title {
            margin: 0;
            font-size: 1.75rem;
            font-weight: 700;
            color: white;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .tool-page-description {
            color: rgba(255, 255, 255, 0.9);
            margin: 0.5rem 0 0 0;
            font-size: 1rem;
        }

        .tool-badges {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            flex-wrap: wrap;
        }

        .tool-badge {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }

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
                grid-template-columns: 400px 1fr;
                gap: 2rem;
            }
        }

        .info-box {
            background: linear-gradient(135deg, rgba(219, 39, 119, 0.1), rgba(147, 51, 234, 0.1));
            border-left: 4px solid var(--physics-pink);
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
        }

        .info-box p {
            margin: 0;
            color: var(--text-secondary);
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .control-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            border: 1px solid var(--border-light);
        }

        .panel-header {
            background: linear-gradient(135deg, #db2777, #9333ea);
            color: white;
            padding: 1.25rem 1.5rem;
        }

        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0 0; opacity: 0.9; font-size: 0.875rem; }

        .panel-body { padding: 1.5rem; }

        .solve-for-section {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1.25rem;
            border: 1px solid var(--border-light);
        }

        .solve-for-label {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-secondary);
            margin-bottom: 0.75rem;
            display: block;
        }

        .solve-for-btns {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .solve-btn {
            flex: 1;
            min-width: 80px;
            padding: 0.625rem 1rem;
            background: var(--surface-1);
            border: 2px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
        }

        .solve-btn:hover {
            border-color: var(--physics-pink);
            color: var(--physics-pink);
        }

        .solve-btn.active {
            background: var(--physics-pink);
            border-color: var(--physics-pink);
            color: white;
        }

        .input-section { margin-bottom: 1.25rem; }

        .input-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .input-with-unit {
            display: flex;
            gap: 0;
            align-items: stretch;
        }

        .number-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border-light);
            border-radius: 10px 0 0 10px;
            font-size: 1rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--surface-1);
            color: var(--text-primary);
            transition: all 0.2s;
        }

        .number-input:focus {
            outline: none;
            border-color: var(--physics-pink);
        }

        .unit-select {
            padding: 0.75rem;
            background: var(--surface-3);
            border: 2px solid var(--border-light);
            border-left: none;
            border-radius: 0 10px 10px 0;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            min-width: 70px;
        }

        .calc-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, #db2777, #9333ea);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: var(--shadow-md);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .calc-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .results-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
            margin-top: 1.5rem;
        }

        .result-card {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            border: 1px solid var(--border-light);
        }

        .result-card.highlight {
            background: linear-gradient(135deg, #db2777, #9333ea);
            color: white;
            border: none;
            grid-column: span 2;
        }

        .result-icon { font-size: 1.5rem; margin-bottom: 0.5rem; }

        .result-label {
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            opacity: 0.8;
            margin-bottom: 0.25rem;
        }

        .result-value {
            font-size: 1.25rem;
            font-weight: 800;
            font-family: 'JetBrains Mono', monospace;
        }

        .result-card:not(.highlight) .result-value { color: var(--text-primary); }

        .examples-section {
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border-light);
        }

        .examples-section h4 { margin: 0 0 1rem 0; font-size: 0.9rem; color: var(--text-primary); }

        .examples-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
        }

        .example-card {
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 10px;
            padding: 0.75rem;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }

        .example-card:hover {
            border-color: var(--physics-pink);
            transform: translateY(-2px);
        }

        .example-icon { font-size: 1.5rem; margin-bottom: 0.25rem; }
        .example-title { font-size: 0.8rem; font-weight: 600; color: var(--text-primary); }
        .example-desc { font-size: 0.7rem; color: var(--text-secondary); }

        /* Spring Visualization */
        .simulation-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            border: 1px solid var(--border-light);
        }

        .simulation-header {
            background: linear-gradient(135deg, rgba(219, 39, 119, 0.1), rgba(147, 51, 234, 0.05));
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border-light);
        }

        .simulation-header h3 {
            margin: 0;
            font-size: 1rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .spring-container {
            position: relative;
            width: 100%;
            height: 300px;
            background: linear-gradient(180deg, #fdf4ff 0%, #fae8ff 100%);
            margin: 1rem;
            border-radius: 12px;
            overflow: hidden;
            border: 2px solid var(--border-light);
        }

        [data-theme="dark"] .spring-container,
        .dark-mode .spring-container {
            background: linear-gradient(180deg, #4a044e 0%, #0f172a 100%);
        }

        .spring-canvas {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .spring-info {
            position: absolute;
            bottom: 10px;
            left: 10px;
            right: 10px;
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .spring-info-pill {
            background: rgba(255, 255, 255, 0.95);
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-primary);
            box-shadow: var(--shadow-sm);
        }

        [data-theme="dark"] .spring-info-pill,
        .dark-mode .spring-info-pill {
            background: rgba(30, 41, 59, 0.95);
        }

        .formula-section {
            padding: 1rem;
            border-top: 1px solid var(--border-light);
        }

        .formula-section h4 { margin: 0 0 1rem 0; font-size: 0.9rem; color: var(--text-primary); }

        .formula-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 0.75rem;
        }

        .formula-card {
            background: var(--surface-2);
            border-radius: 10px;
            padding: 1rem;
            border: 1px solid var(--border-light);
        }

        .formula-code {
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--physics-pink);
            margin-bottom: 0.25rem;
        }

        .formula-name { font-size: 0.75rem; color: var(--text-secondary); }

        .steps-section {
            margin: 1rem;
            background: var(--surface-2);
            border-radius: 12px;
            border: 1px solid var(--border-light);
            overflow: hidden;
        }

        .steps-header {
            background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple));
            color: white;
            padding: 0.75rem 1rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
        }

        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }

        .steps-body {
            padding: 1rem;
            max-height: 400px;
            overflow-y: auto;
        }

        .steps-body.collapsed { display: none; }

        .step-item {
            background: var(--surface-1);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            border-left: 4px solid var(--physics-pink);
        }

        .step-item:last-child { margin-bottom: 0; }

        .step-number {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            background: var(--physics-pink);
            color: white;
            border-radius: 50%;
            font-size: 0.75rem;
            font-weight: 700;
            margin-right: 0.5rem;
        }

        .step-title {
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .step-formula {
            background: var(--surface-2);
            padding: 0.75rem;
            border-radius: 8px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.9rem;
            color: var(--physics-blue);
            margin: 0.5rem 0;
        }

        .step-calc {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.85rem;
            color: var(--text-secondary);
            line-height: 1.8;
        }

        .step-calc .highlight {
            color: var(--physics-pink);
            font-weight: 700;
        }

        .step-result {
            background: linear-gradient(135deg, rgba(5, 150, 105, 0.1), rgba(16, 185, 129, 0.1));
            border: 1px solid rgba(5, 150, 105, 0.3);
            border-radius: 8px;
            padding: 0.75rem;
            margin-top: 0.5rem;
        }

        .step-result-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--physics-green);
            font-weight: 600;
        }

        .step-result-value {
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--physics-green);
        }

        .edu-content {
            background: var(--surface-1);
            border-radius: 16px;
            padding: 2rem;
            margin-top: 2rem;
            border: 1px solid var(--border-light);
        }

        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem 0; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem 0; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .edu-content ul { padding-left: 1.5rem; }

        @media (max-width: 768px) {
            .tool-header { padding: 1rem; }
            .tool-page-title { font-size: 1.25rem; }
            .edu-container { padding: 1rem; }
            .spring-container { height: 250px; }
            .results-grid { grid-template-columns: 1fr; }
            .result-card.highlight { grid-column: span 1; }
        }
    </style>
</head>

<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title">
                <span>🌀</span> Spring Force Calculator
            </h1>
            <p class="tool-page-description">Calculate spring force, constant, and displacement using Hooke's Law</p>
            <div class="tool-badges">
                <span class="tool-badge">F = -kx</span>
                <span class="tool-badge">Hooke's Law</span>
                <span class="tool-badge">Elastic PE</span>
                <span class="tool-badge">Step-by-Step</span>
            </div>
        </div>
    </header>

    <main class="edu-container">

        <div class="info-box">
            <div class="info-box-title">
                <span>💡</span> Hooke's Law
            </div>
            <p>
                <strong>F = -kx</strong> — The force exerted by a spring is proportional to its displacement from equilibrium.
                The negative sign indicates the force opposes the displacement (restoring force).
            </p>
        </div>

        <div class="edu-grid">

            <!-- Control Panel -->
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Spring Calculator</h2>
                    <p>Configure spring parameters</p>
                </div>
                <div class="panel-body">

                    <!-- Solve For -->
                    <div class="solve-for-section">
                        <span class="solve-for-label">Solve for:</span>
                        <div class="solve-for-btns">
                            <button class="solve-btn active" onclick="setSolveFor('force')" data-var="force">Force (F)</button>
                            <button class="solve-btn" onclick="setSolveFor('k')" data-var="k">Constant (k)</button>
                            <button class="solve-btn" onclick="setSolveFor('x')" data-var="x">Displacement (x)</button>
                        </div>
                    </div>

                    <!-- Spring Constant -->
                    <div class="input-section" id="k-input-section">
                        <div class="input-label">
                            <span>🔧</span>
                            <span>Spring Constant (k)</span>
                        </div>
                        <div class="input-with-unit">
                            <input type="number" id="spring-constant" class="number-input" value="100" min="0.1" step="1">
                            <select id="k-unit" class="unit-select" onchange="calculate()">
                                <option value="N/m" selected>N/m</option>
                                <option value="kN/m">kN/m</option>
                                <option value="lbf/in">lbf/in</option>
                            </select>
                        </div>
                        <div style="margin-top: 0.5rem; display: flex; gap: 0.5rem; flex-wrap: wrap;">
                            <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.75rem;" onclick="setSpringPreset(10)">Soft 10</button>
                            <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.75rem;" onclick="setSpringPreset(100)">Medium 100</button>
                            <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.75rem;" onclick="setSpringPreset(1000)">Stiff 1000</button>
                        </div>
                    </div>

                    <!-- Displacement -->
                    <div class="input-section" id="x-input-section">
                        <div class="input-label">
                            <span>↔️</span>
                            <span>Displacement (x)</span>
                        </div>
                        <div class="input-with-unit">
                            <input type="number" id="displacement" class="number-input" value="0.1" step="0.01">
                            <select id="x-unit" class="unit-select" onchange="calculate()">
                                <option value="m" selected>m</option>
                                <option value="cm">cm</option>
                                <option value="mm">mm</option>
                                <option value="in">in</option>
                            </select>
                        </div>
                    </div>

                    <!-- Force (for solving k or x) -->
                    <div class="input-section" id="force-input-section" style="display: none;">
                        <div class="input-label">
                            <span>💪</span>
                            <span>Force (F)</span>
                        </div>
                        <div class="input-with-unit">
                            <input type="number" id="force" class="number-input" value="10" min="0" step="0.1">
                            <select id="force-unit" class="unit-select" onchange="calculate()">
                                <option value="N" selected>N</option>
                                <option value="kN">kN</option>
                                <option value="lbf">lbf</option>
                            </select>
                        </div>
                    </div>

                    <!-- Calculate Button -->
                    <button class="calc-btn" onclick="calculate()">
                        <span>⚡</span>
                        <span>Calculate</span>
                    </button>

                    <!-- Oscillate Button -->
                    <button class="calc-btn" onclick="startOscillation()" style="margin-top: 0.75rem; background: linear-gradient(135deg, #059669, #047857);">
                        <span>🔄</span>
                        <span>Oscillate Spring</span>
                    </button>

                    <!-- Results -->
                    <div class="results-grid">
                        <div class="result-card highlight">
                            <div class="result-icon">🌀</div>
                            <div class="result-label">Spring Force</div>
                            <div class="result-value" id="result-force">10.00 N</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">⚡</div>
                            <div class="result-label">Elastic PE</div>
                            <div class="result-value" id="result-pe">0.50 J</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">🔧</div>
                            <div class="result-label">Spring Constant</div>
                            <div class="result-value" id="result-k">100 N/m</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">↔️</div>
                            <div class="result-label">Displacement</div>
                            <div class="result-value" id="result-x">0.10 m</div>
                        </div>
                    </div>

                    <!-- Examples -->
                    <div class="examples-section">
                        <h4>📚 Try These Examples</h4>
                        <div class="examples-grid">
                            <div class="example-card" onclick="loadExample(1)">
                                <div class="example-icon">🚗</div>
                                <div class="example-title">Car Suspension</div>
                                <div class="example-desc">k=50000 N/m, x=5cm</div>
                            </div>
                            <div class="example-card" onclick="loadExample(2)">
                                <div class="example-icon">✏️</div>
                                <div class="example-title">Pen Spring</div>
                                <div class="example-desc">k=500 N/m, x=1cm</div>
                            </div>
                            <div class="example-card" onclick="loadExample(3)">
                                <div class="example-icon">🛏️</div>
                                <div class="example-title">Mattress Spring</div>
                                <div class="example-desc">k=2000 N/m, x=3cm</div>
                            </div>
                            <div class="example-card" onclick="loadExample(4)">
                                <div class="example-icon">⌚</div>
                                <div class="example-title">Watch Spring</div>
                                <div class="example-desc">k=50 N/m, x=2mm</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Simulation Panel -->
            <div class="simulation-panel">
                <div class="simulation-header">
                    <h3>🌀 Spring Visualization</h3>
                </div>

                <div class="spring-container" id="spring-container">
                    <canvas class="spring-canvas" id="spring-canvas"></canvas>
                    <div class="spring-info">
                        <div class="spring-info-pill" id="info-k">k = 100 N/m</div>
                        <div class="spring-info-pill" id="info-x">x = 0.10 m</div>
                        <div class="spring-info-pill" id="info-f">F = 10 N</div>
                    </div>
                </div>

                <!-- Formulas -->
                <div class="formula-section">
                    <h4>📝 Spring Formulas</h4>
                    <div class="formula-grid">
                        <div class="formula-card">
                            <div class="formula-code">F = -kx</div>
                            <div class="formula-name">Hooke's Law</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula-code">PE = ½kx²</div>
                            <div class="formula-name">Elastic Potential Energy</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula-code">k = F/x</div>
                            <div class="formula-name">Spring Constant</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula-code">T = 2π√(m/k)</div>
                            <div class="formula-name">Oscillation Period</div>
                        </div>
                    </div>
                </div>

                <!-- Steps -->
                <div class="steps-section">
                    <div class="steps-header" onclick="toggleSteps()">
                        <span>🧮</span>
                        <span>Step-by-Step Solution</span>
                        <span class="steps-toggle" id="steps-toggle">▼ Show</span>
                    </div>
                    <div class="steps-body collapsed" id="steps-body"></div>
                </div>
            </div>

        </div>

        <!-- Educational Content -->
        <div class="edu-content">
            <h2>Understanding Hooke's Law and Springs</h2>
            <p>
                Hooke's Law describes the behavior of elastic materials like springs. When a spring is stretched or compressed
                from its natural length, it exerts a restoring force proportional to the displacement.
            </p>

            <h3>Key Concepts</h3>
            <ul>
                <li><strong>Spring Constant (k):</strong> Measures stiffness - higher k means stiffer spring</li>
                <li><strong>Displacement (x):</strong> Distance from equilibrium position (can be + or -)</li>
                <li><strong>Restoring Force:</strong> The negative sign means force opposes displacement</li>
                <li><strong>Elastic Limit:</strong> Beyond this point, Hooke's Law no longer applies</li>
            </ul>

            <h3>Elastic Potential Energy</h3>
            <p>
                When a spring is deformed, it stores elastic potential energy: <strong>PE = ½kx²</strong>.
                This energy can be converted to kinetic energy (like in a spring-loaded toy).
            </p>

            <h3>Real-World Applications</h3>
            <ul>
                <li><strong>Vehicle Suspension:</strong> Springs absorb bumps (k ≈ 20,000-100,000 N/m)</li>
                <li><strong>Mattresses:</strong> Provide comfort and support (k ≈ 1,000-5,000 N/m)</li>
                <li><strong>Mechanical Watches:</strong> Hairspring controls timing (k ≈ 10-100 N/m)</li>
                <li><strong>Trampolines:</strong> Convert PE to KE for jumping</li>
            </ul>
        </div>

    </main>

    <footer class="tool-page-footer" style="background: var(--surface-1); border-top: 1px solid var(--border-light); padding: 2rem; text-align: center; margin-top: 2rem;">
        <div class="tool-page-footer-inner">
            <p style="color: var(--text-secondary); margin: 0;">&copy; 2025 8gwifi.org. All rights reserved.</p>
        </div>
    </footer>
    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <!-- Matter.js Physics Engine -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/matter-js/0.19.0/matter.min.js"></script>
    <script src="<%=request.getContextPath()%>/physics/js/spring-force-calculator.js?v=<%=cacheVersion%>"></script>
</body>

</html>
