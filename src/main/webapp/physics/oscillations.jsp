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
        <jsp:param name="toolName" value="Oscillations & Simple Harmonic Motion (SHM) - Displacement, Velocity, Energy, Time Period" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Simple harmonic motion (SHM) formulas and calculators: displacement x = A sin(ωt + φ), velocity, acceleration, total energy E = ½kA², KE/PE, and time period for mass–spring and pendulum systems." />
        <jsp:param name="toolUrl" value="physics/oscillations.jsp" />
        <jsp:param name="toolKeywords" value="simple harmonic motion, SHM calculator, oscillations, spring mass system, pendulum time period, x = A sin(ωt+φ), energy in SHM, JEE NEET oscillations" />
        <jsp:param name="toolImage" value="oscillations-shm.png" />
        <jsp:param name="toolFeatures" value="SHM displacement calculator,Velocity and acceleration in SHM,Energy in SHM (KE and PE),Mass–spring and pendulum period calculators,Concept tables for damped/forced oscillations" />
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
            --shm-primary: #6366f1;
            --shm-secondary: #ec4899;
            --surface-1: #ffffff;
            --surface-2: #f8fafc;
            --surface-3: #e5e7eb;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --border-light: #e2e8f0;
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
        }

        [data-theme="dark"], .dark-mode {
            --surface-1: #1e293b;
            --surface-2: #0f172a;
            --surface-3: #111827;
            --text-primary: #f1f5f9;
            --text-secondary: #cbd5e1;
            --border-light: #334155;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--surface-2);
            margin: 0;
        }

        .tool-header {
            background: linear-gradient(135deg, #6366f1 0%, #ec4899 100%);
            padding: 1.25rem 1.5rem;
            margin-top: 72px;
        }

        .tool-header-container {
            max-width: 1400px;
            margin: 0 auto;
        }

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
            margin: 0.5rem 0 0;
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
                grid-template-columns: 380px 1fr;
                gap: 2rem;
            }
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--shm-primary);
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 1rem;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .info-box {
            background: linear-gradient(135deg, rgba(99,102,241,0.1), rgba(236,72,153,0.1));
            border-left: 4px solid var(--shm-primary);
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
            background: linear-gradient(135deg, #6366f1, #ec4899);
            color: white;
            padding: 1.25rem 1.5rem;
        }

        .panel-header h2 {
            margin: 0;
            font-size: 1.25rem;
            font-weight: 700;
        }

        .panel-header p {
            margin: 0.25rem 0 0;
            opacity: 0.9;
            font-size: 0.875rem;
        }

        .panel-body {
            padding: 1.5rem;
        }

        .shm-tabs {
            display: flex;
            gap: 0.25rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .shm-tab {
            padding: 0.5rem 1rem;
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
        }

        .shm-tab:hover {
            border-color: var(--shm-primary);
            color: var(--shm-primary);
        }

        .shm-tab.active {
            background: linear-gradient(135deg, #6366f1, #ec4899);
            border-color: #ec4899;
            color: white;
        }

        .shm-panel {
            display: none;
        }

        .shm-panel.active {
            display: block;
        }

        .input-section {
            margin-bottom: 1.1rem;
        }

        .input-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.4rem;
            font-size: 0.9rem;
        }

        .input-row {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .number-input {
            flex: 1;
            min-width: 80px;
            padding: 0.7rem 0.9rem;
            border: 2px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--surface-1);
            color: var(--text-primary);
        }

        .number-input:focus {
            outline: none;
            border-color: var(--shm-primary);
        }

        .unit-select {
            padding: 0.7rem 0.9rem;
            border-radius: 10px;
            border: 2px solid var(--border-light);
            background: var(--surface-3);
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            min-width: 80px;
            cursor: pointer;
        }

        .calc-btn {
            width: 100%;
            padding: 0.9rem;
            background: linear-gradient(135deg, #6366f1, #ec4899);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: var(--shadow-md);
        }

        .calc-btn:hover {
            transform: translateY(-1px);
        }

        .result-card {
            background: linear-gradient(135deg, rgba(99,102,241,0.12), rgba(236,72,153,0.08));
            border: 2px solid var(--shm-primary);
            border-radius: 12px;
            padding: 1rem 1.1rem;
            margin-top: 0.9rem;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .result-value {
            font-size: 1.1rem;
            font-weight: 800;
            font-family: 'JetBrains Mono', monospace;
            color: var(--shm-primary);
        }

        .ref-card {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-light);
            overflow: hidden;
        }

        .ref-card h3 {
            margin: 0;
            padding: 0.9rem 1.1rem;
            background: linear-gradient(135deg, rgba(99,102,241,0.12), rgba(236,72,153,0.12));
            border-bottom: 1px solid var(--border-light);
            font-size: 0.95rem;
            color: var(--text-primary);
        }

        .ref-table {
            width: 100%;
            border-collapse: collapse;
        }

        .ref-table th,
        .ref-table td {
            padding: 0.6rem 0.9rem;
            text-align: left;
            border-bottom: 1px solid var(--border-light);
            font-size: 0.85rem;
        }

        .ref-table thead th {
            background: linear-gradient(135deg, #6366f1, #ec4899);
            color: white;
            font-weight: 700;
        }

        .ref-table .mono {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            color: var(--shm-primary);
        }

        .simulation-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            border: 1px solid var(--border-light);
            margin-top: 1.5rem;
        }

        .simulation-header {
            background: linear-gradient(135deg, rgba(99,102,241,0.1), rgba(236,72,153,0.08));
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

        .shm-viz-container {
            position: relative;
            width: 100%;
            height: 260px;
            background: linear-gradient(180deg, #eef2ff 0%, #e0e7ff 100%);
            margin: 1rem;
            border-radius: 12px;
            overflow: hidden;
            border: 2px solid var(--border-light);
        }

        [data-theme="dark"] .shm-viz-container,
        .dark-mode .shm-viz-container {
            background: linear-gradient(180deg, #312e81 0%, #1e293b 100%);
        }

        .shm-viz-canvas {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .shm-viz-pills {
            position: absolute;
            bottom: 10px;
            left: 10px;
            right: 10px;
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .shm-viz-pill {
            background: rgba(255, 255, 255, 0.95);
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-primary);
            box-shadow: var(--shadow-md);
        }

        [data-theme="dark"] .shm-viz-pill,
        .dark-mode .shm-viz-pill {
            background: rgba(15, 23, 42, 0.95);
        }

        .shm-chart-wrap {
            height: 220px;
            margin: 1rem;
            padding: 0 0.5rem;
        }

        .steps-section {
            margin: 1rem 0;
            background: var(--surface-2);
            border-radius: 12px;
            border: 1px solid var(--border-light);
            overflow: hidden;
        }

        .steps-header {
            background: linear-gradient(135deg, #6366f1, #ec4899);
            color: white;
            padding: 0.75rem 1rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
        }

        .steps-toggle {
            margin-left: auto;
            font-size: 0.8rem;
            opacity: 0.8;
        }

        .steps-body {
            padding: 1rem;
            max-height: 360px;
            overflow-y: auto;
        }

        .steps-body.collapsed {
            display: none;
        }

        .step-item {
            background: var(--surface-1);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            border-left: 4px solid var(--shm-primary);
        }

        .step-item:last-child {
            margin-bottom: 0;
        }

        .step-number {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            background: var(--shm-primary);
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
            color: #6366f1;
            margin: 0.5rem 0;
        }

        .step-calc {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.85rem;
            color: var(--text-secondary);
            line-height: 1.8;
        }

        .edu-content {
            background: var(--surface-1);
            border-radius: 16px;
            padding: 1.6rem;
            margin-top: 1.8rem;
            border: 1px solid var(--border-light);
        }

        .edu-content h2 {
            color: var(--text-primary);
            margin: 0 0 0.8rem;
            font-size: 1.3rem;
        }

        .edu-content h3 {
            color: var(--text-primary);
            margin: 1.1rem 0 0.4rem;
            font-size: 1rem;
        }

        .edu-content p,
        .edu-content li {
            color: var(--text-secondary);
            line-height: 1.6;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🪤</span> Oscillations & Simple Harmonic Motion (SHM)</h1>
            <p class="tool-page-description">x = A sin(ωt + φ), v, a, energy in SHM, time period of spring–mass and pendulum systems</p>
            <div class="tool-badges">
                <span class="tool-badge">x = A sin(ωt + φ)</span>
                <span class="tool-badge">v, a in SHM</span>
                <span class="tool-badge">E = ½kA²</span>
                <span class="tool-badge">T = 2π√(m/k), 2π√(L/g)</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title">
                <span>💡</span>
                <span>Simple Harmonic Motion at a glance</span>
            </div>
            <p>
                In SHM, restoring force is proportional to displacement and opposite in direction: F = −kx.
                Displacement can be written as x = A sin(ωt + φ) or x = A cos(ωt + φ) with angular frequency ω = 2π/T.
                Velocity is v = Aω cos(ωt + φ), acceleration is a = −ω²x, and total mechanical energy E = ½kA² remains constant in ideal SHM.
            </p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>SHM calculators</h2>
                    <p>Displacement, velocity, acceleration, energy, and time period</p>
                </div>
                <div class="panel-body">
                    <div class="shm-tabs">
                        <button type="button" class="shm-tab active" data-tab="basics">SHM basics (x, v, a)</button>
                        <button type="button" class="shm-tab" data-tab="energy">Energy in SHM</button>
                        <button type="button" class="shm-tab" data-tab="systems">Time period (standard)</button>
                        <button type="button" class="shm-tab" data-tab="damped">Damped SHM</button>
                        <button type="button" class="shm-tab" data-tab="forced">Forced &amp; resonance</button>
                    </div>

                    <div id="panel-basics" class="shm-panel active">
                        <div class="input-section">
                            <div class="input-label">Amplitude (A)</div>
                            <div class="input-row">
                                <input type="number" id="shm-A" class="number-input" value="0.10" step="any">
                                <span class="unit-select" style="display:inline-flex;align-items:center;border-radius:10px;">m</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Angular frequency (ω)</div>
                            <div class="input-row">
                                <input type="number" id="shm-omega" class="number-input" value="10" step="any">
                                <span class="unit-select" style="display:inline-flex;align-items:center;border-radius:10px;">rad/s</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Time (t) and phase (φ)</div>
                            <div class="input-row">
                                <input type="number" id="shm-t" class="number-input" value="0.20" step="any" placeholder="t (s)">
                                <input type="number" id="shm-phi" class="number-input" value="0" step="any" placeholder="φ (rad)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runOscillations()">Calculate x, v, a</button>
                        <div class="result-card">
                            <div>Using x = A sin(ωt + φ)</div>
                            <div class="result-value" id="shm-basics-result">x = —, v = —, a = —</div>
                        </div>
                    </div>

                    <div id="panel-energy" class="shm-panel">
                        <div class="input-section">
                            <div class="input-label">Mass–spring system (mass m, spring constant k)</div>
                            <div class="input-row">
                                <input type="number" id="shm-m" class="number-input" value="0.50" step="any" placeholder="m (kg)">
                                <input type="number" id="shm-k" class="number-input" value="100" step="any" placeholder="k (N/m)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Amplitude (A) and current displacement (x)</div>
                            <div class="input-row">
                                <input type="number" id="shm-A-energy" class="number-input" value="0.10" step="any" placeholder="A (m)">
                                <input type="number" id="shm-x-energy" class="number-input" value="0.05" step="any" placeholder="x (m)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runOscillations()">Calculate energies</button>
                        <div class="result-card">
                            <div class="result-value" id="shm-energy-result">E = —, KE = —, PE = —</div>
                            <div>Ideal SHM: E = ½kA², PE = ½kx², KE = E − PE</div>
                        </div>
                    </div>

                    <div id="panel-systems" class="shm-panel">
                        <div class="input-section">
                            <div class="input-label">Mass–spring system</div>
                            <div class="input-row">
                                <input type="number" id="sys-m" class="number-input" value="0.50" step="any" placeholder="m (kg)">
                                <input type="number" id="sys-k" class="number-input" value="100" step="any" placeholder="k (N/m)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Simple pendulum (small angle)</div>
                            <div class="input-row">
                                <input type="number" id="sys-L" class="number-input" value="1.0" step="any" placeholder="L (m)">
                                <input type="number" id="sys-g" class="number-input" value="9.8" step="any" placeholder="g (m/s²)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runOscillations()">Calculate time periods</button>
                        <div class="result-card">
                            <div class="result-value" id="shm-systems-result">T_spring = —, T_pendulum = —</div>
                            <div>T_spring = 2π√(m/k), T_pendulum = 2π√(L/g) (small angle)</div>
                        </div>
                    </div>

                    <div id="panel-damped" class="shm-panel">
                        <div class="input-section">
                            <div class="input-label">Mass–spring with damping (m, k, b)</div>
                            <div class="input-row">
                                <input type="number" id="damp-m" class="number-input" value="1.0" step="any" placeholder="m (kg)">
                                <input type="number" id="damp-k" class="number-input" value="100" step="any" placeholder="k (N/m)">
                                <input type="number" id="damp-b" class="number-input" value="1.0" step="any" placeholder="b (kg/s)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runOscillations()">Analyze damping</button>
                        <div class="result-card">
                            <div class="result-value" id="shm-damped-result">ω₀ = —, ω' = —, Q = —</div>
                            <div>Classifies motion (under/critical/over-damped) and gives damped frequency &amp; quality factor.</div>
                        </div>
                    </div>

                    <div id="panel-forced" class="shm-panel">
                        <div class="input-section">
                            <div class="input-label">Driven oscillator (m, k, b, F₀, ω_d)</div>
                            <div class="input-row">
                                <input type="number" id="force-m" class="number-input" value="1.0" step="any" placeholder="m (kg)">
                                <input type="number" id="force-k" class="number-input" value="100" step="any" placeholder="k (N/m)">
                                <input type="number" id="force-b" class="number-input" value="1.0" step="any" placeholder="b (kg/s)">
                            </div>
                            <div class="input-row" style="margin-top:0.5rem;">
                                <input type="number" id="force-F0" class="number-input" value="1.0" step="any" placeholder="F₀ (N)">
                                <input type="number" id="force-omega-d" class="number-input" value="10.0" step="any" placeholder="ω_d (rad/s)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runOscillations()">Calculate steady-state amplitude</button>
                        <div class="result-card">
                            <div class="result-value" id="shm-forced-result">A_ss = —</div>
                            <div>Uses A = (F₀/m) / √((ω₀² − ω_d²)² + (2β ω_d)²) and compares ω_d with ω₀ for resonance.</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="simulation-panel">
                <div class="simulation-header"><h3>📈 SHM visualization &amp; graphs</h3></div>
                <div class="shm-viz-container" id="shm-viz-container">
                    <canvas id="shm-viz-canvas" class="shm-viz-canvas"></canvas>
                    <div class="shm-viz-pills" id="shm-viz-pills"></div>
                </div>
                <div class="shm-chart-wrap">
                    <canvas id="shm-chart-canvas"></canvas>
                </div>
            </div>

            <div class="steps-section">
                <div class="steps-header" onclick="window.toggleOscSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="osc-steps-toggle">▼ Show</span></div>
                <div class="steps-body collapsed" id="osc-steps-body"></div>
            </div>

            <div class="ref-card">
                <h3>Key SHM formulas & systems</h3>
                <table class="ref-table">
                    <thead>
                        <tr>
                            <th>Concept / System</th>
                            <th>Formula</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Displacement in SHM</td>
                            <td class="mono">x = A sin(ωt + φ) = A cos(ωt + φ')</td>
                            <td>A = amplitude, φ = phase constant</td>
                        </tr>
                        <tr>
                            <td>Velocity & acceleration</td>
                            <td class="mono">v = Aω cos(ωt + φ), a = −ω²x</td>
                            <td>Maximum v = Aω at x = 0, maximum |a| = Aω² at x = ±A</td>
                        </tr>
                        <tr>
                            <td>Angular frequency & time period</td>
                            <td class="mono">ω = 2π/T, T = 2π/ω, f = 1/T</td>
                            <td>f in hertz (Hz), ω in rad/s</td>
                        </tr>
                        <tr>
                            <td>Total energy in SHM</td>
                            <td class="mono">E = ½kA² = ½mω²A²</td>
                            <td>Constant for ideal SHM</td>
                        </tr>
                        <tr>
                            <td>Kinetic & potential energy</td>
                            <td class="mono">KE = ½mω²(A² − x²), PE = ½kx²</td>
                            <td>⟨KE⟩ = ⟨PE⟩ = ¼kA² over a cycle</td>
                        </tr>
                        <tr>
                            <td>Mass–spring system</td>
                            <td class="mono">T = 2π√(m/k)</td>
                            <td>Horizontal or vertical (small oscillations)</td>
                        </tr>
                        <tr>
                            <td>Simple pendulum</td>
                            <td class="mono">T = 2π√(L/g)</td>
                            <td>Small-angle approximation (θ ≲ 10°)</td>
                        </tr>
                        <tr>
                            <td>Physical pendulum</td>
                            <td class="mono">T = 2π√(I / m g d)</td>
                            <td>I: moment of inertia about pivot, d: COM distance from pivot</td>
                        </tr>
                        <tr>
                            <td>Torsional pendulum</td>
                            <td class="mono">T = 2π√(I / κ)</td>
                            <td>κ: torsional constant of wire/rod</td>
                        </tr>
                        <tr>
                            <td>Floating cylinder</td>
                            <td class="mono">T = 2π√(L / g)</td>
                            <td>L: length of immersed part of cylinder</td>
                        </tr>
                        <tr>
                            <td>Liquid in U-tube</td>
                            <td class="mono">T = 2π√(L / 2g)</td>
                            <td>L: total length of liquid column</td>
                        </tr>
                        <tr>
                            <td>Springs in series</td>
                            <td class="mono">1/k_eff = 1/k₁ + 1/k₂ + …</td>
                            <td>Use k_eff in T = 2π√(m/k_eff)</td>
                        </tr>
                        <tr>
                            <td>Damped SHM (under-damped)</td>
                            <td class="mono">x = A e^(−bt/2m) sin(ω' t + φ)</td>
                            <td>ω' = √(ω₀² − β²), β = b/(2m)</td>
                        </tr>
                        <tr>
                            <td>Resonance (driven SHM)</td>
                            <td class="mono">A(ω_d) ∝ 1 / √((ω₀² − ω_d²)² + (2βω_d)²)</td>
                            <td>Amplitude peaks near ω_d ≈ ω₀ for light damping</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="edu-content">
            <h2>About this SHM tool</h2>
            <p>
                This page focuses on core oscillation formulas used in school physics, JEE, and NEET:
                displacement, velocity, acceleration, energy, and time period of standard SHM systems.
                For energy storage (KE, gravitational and elastic PE) see the
                <a href="<%=request.getContextPath()%>/physics/energy-calculator.jsp" style="color:var(--shm-primary); font-weight:600;">Energy Calculator</a>.
            </p>
            <h3>Visual SHM graphs & next steps</h3>
            <p>
                This tool already plots x(t), v(t), and a(t) for your chosen SHM parameters and shows step-by-step solutions
                for each calculator. In a later batch we will add Matter.js visualizations of a mass–spring system and a
                simple pendulum to make the motion even more intuitive.
            </p>
        </div>
    </main>

    <footer style="background: var(--surface-1); border-top: 1px solid var(--border-light); padding: 1.5rem; text-align: center; margin-top: 2rem;">
        <p style="margin:0; color: var(--text-secondary); font-size: 0.85rem;">&copy; 2025 8gwifi.org.</p>
    </footer>

    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/matter-js@0.19.0/build/matter.min.js" crossorigin="anonymous"></script>
    <script src="<%=request.getContextPath()%>/physics/js/oscillations.js?v=<%=cacheVersion%>"></script>
</body>
</html>

