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
        <jsp:param name="toolName" value="Alternating Current - AC Circuits, Power & Transformers" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Alternating current (AC) formulas and calculators: RMS values, pure R/L/C, series RL/RC/RLC, resonance, AC power and power factor, and ideal transformers. With step-by-step explanations." />
        <jsp:param name="toolUrl" value="physics/ac-circuits.jsp" />
        <jsp:param name="toolKeywords" value="alternating current calculator, AC circuit, RMS voltage, RMS current, power factor, RLC resonance, transformers, JEE NEET AC circuits" />
        <jsp:param name="toolImage" value="ac-circuits.png" />
        <jsp:param name="toolFeatures" value="RMS calculators,AC pure R/L/C,Series RL/RC/RLC,Resonance & Q factor,AC power & power triangle,Transformer calculations,Step-by-step solutions" />
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
            --ac-blue: #0ea5e9;
            --ac-purple: #7c3aed;
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
            background: linear-gradient(135deg, #0ea5e9 0%, #7c3aed 100%);
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
            color: var(--ac-blue);
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 1rem;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .info-box {
            background: linear-gradient(135deg, rgba(14,165,233,0.1), rgba(124,58,237,0.1));
            border-left: 4px solid var(--ac-blue);
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
            background: linear-gradient(135deg, #0ea5e9, #7c3aed);
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

        .ac-tabs {
            display: flex;
            gap: 0.25rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .ac-tab {
            padding: 0.5rem 0.9rem;
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
        }

        .ac-tab:hover {
            border-color: var(--ac-blue);
            color: var(--ac-blue);
        }

        .ac-tab.active {
            background: linear-gradient(135deg, #0ea5e9, #7c3aed);
            border-color: #7c3aed;
            color: white;
        }

        .ac-panel {
            display: none;
        }

        .ac-panel.active {
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
            min-width: 90px;
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
            border-color: var(--ac-blue);
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
            background: linear-gradient(135deg, #0ea5e9, #7c3aed);
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
            background: linear-gradient(135deg, rgba(14,165,233,0.12), rgba(124,58,237,0.08));
            border: 2px solid var(--ac-blue);
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
            color: var(--ac-blue);
        }

        .ac-sim-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-light);
            margin: 1.25rem 0;
            overflow: hidden;
        }

        .ac-sim-header {
            background: linear-gradient(135deg, rgba(14,165,233,0.1), rgba(124,58,237,0.08));
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border-light);
        }

        .ac-sim-header h3 {
            margin: 0;
            font-size: 1rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .ac-chart-wrap {
            height: 220px;
            margin: 1rem;
            padding: 0 0.5rem;
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
            background: linear-gradient(135deg, rgba(14,165,233,0.12), rgba(124,58,237,0.12));
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
            background: linear-gradient(135deg, #0ea5e9, #7c3aed);
            color: white;
            font-weight: 700;
        }

        .ref-table .mono {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            color: var(--ac-blue);
        }

        .steps-section {
            margin: 1rem 0;
            background: var(--surface-2);
            border-radius: 12px;
            border: 1px solid var(--border-light);
            overflow: hidden;
        }

        .steps-header {
            background: linear-gradient(135deg, #0ea5e9, #7c3aed);
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
            border-left: 4px solid var(--ac-blue);
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
            background: var(--ac-blue);
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
            color: #0ea5e9;
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
            <h1 class="tool-page-title"><span>⚡</span> Alternating Current (AC) Circuits</h1>
            <p class="tool-page-description">RMS values, pure R/L/C, series RLC, resonance, AC power &amp; transformers</p>
            <div class="tool-badges">
                <span class="tool-badge">v = V₀ sin ωt</span>
                <span class="tool-badge">V_rms = V₀/√2</span>
                <span class="tool-badge">Z = √(R² + (X_L − X_C)²)</span>
                <span class="tool-badge">P = V_rms I_rms cos φ</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title">
                <span>💡</span>
                <span>AC quantities and circuits</span>
            </div>
            <p>
                Alternating voltage and current vary sinusoidally: <strong>v = V₀ sin ωt</strong>, <strong>i = I₀ sin(ωt + φ)</strong>. Effective (RMS) values
                are <strong>V_rms = V₀/√2</strong> and <strong>I_rms = I₀/√2</strong>. Inductors and capacitors introduce reactances <strong>X_L = ωL</strong> and
                <strong>X_C = 1/(ωC)</strong>, so the series RLC impedance is <strong>Z = √(R² + (X_L − X_C)²)</strong>. At resonance <strong>ω₀ = 1/√(LC)</strong>,
                current is maximum and the circuit is purely resistive. Average power is <strong>P_avg = V_rms I_rms cos φ</strong>, where cos φ is the
                power factor. Transformers use turns ratios to step voltage up or down while approximately conserving power.
            </p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>AC calculators</h2>
                    <p>RMS, pure R/L/C, series RLC, resonance, power &amp; transformers</p>
                </div>
                <div class="panel-body">
                    <div class="ac-tabs">
                        <button type="button" class="ac-tab active" data-tab="basics">AC basics &amp; RMS</button>
                        <button type="button" class="ac-tab" data-tab="pure">Pure R, L, C</button>
                        <button type="button" class="ac-tab" data-tab="series">Series RL/RC/RLC &amp; resonance</button>
                        <button type="button" class="ac-tab" data-tab="power">AC power &amp; power factor</button>
                        <button type="button" class="ac-tab" data-tab="transformer">Transformers</button>
                    </div>

                    <div id="panel-basics" class="ac-panel active">
                        <div class="input-section">
                            <div class="input-label">Peak voltage and frequency</div>
                            <div class="input-row">
                                <input type="number" id="acb-V0" class="number-input" value="230√2" step="any" placeholder="V₀ (V)">
                                <input type="number" id="acb-f" class="number-input" value="50" step="any" placeholder="f (Hz)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Peak current and phase</div>
                            <div class="input-row">
                                <input type="number" id="acb-I0" class="number-input" value="10" step="any" placeholder="I₀ (A)">
                                <input type="number" id="acb-phi" class="number-input" value="0" step="any" placeholder="φ (deg)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runAC()">Calculate RMS &amp; waveforms</button>
                        <div class="result-card">
                            <div class="result-value" id="acb-result">V_rms = —, I_rms = —, V_avg(half) = —</div>
                            <div>Uses V_rms = V₀/√2, I_rms = I₀/√2, V_avg (half‑cycle) = 2V₀/π.</div>
                        </div>
                    </div>

                    <div id="panel-pure" class="ac-panel">
                        <div class="input-section">
                            <div class="input-label">Choose element and parameters</div>
                            <div class="input-row">
                                <select id="pure-type" class="unit-select">
                                    <option value="R">Pure resistor</option>
                                    <option value="L">Pure inductor</option>
                                    <option value="C">Pure capacitor</option>
                                </select>
                                <input type="number" id="pure-Vrms" class="number-input" value="230" step="any" placeholder="V_rms (V)">
                                <input type="number" id="pure-f" class="number-input" value="50" step="any" placeholder="f (Hz)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Value (R, L or C)</div>
                            <div class="input-row">
                                <input type="number" id="pure-value" class="number-input" value="10" step="any" placeholder="R (Ω) or L (H) or C (F)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runAC()">Analyze pure element</button>
                        <div class="result-card">
                            <div class="result-value" id="pure-result">|Z| = —, I_rms = —, φ = —, cos φ = —</div>
                            <div>Resistor: φ = 0°, cos φ = 1. Inductor: φ = +90°, cos φ = 0. Capacitor: φ = −90°, cos φ = 0.</div>
                        </div>
                    </div>

                    <div id="panel-series" class="ac-panel">
                        <div class="input-section">
                            <div class="input-label">Series RLC circuit (R, L, C, V_rms, f)</div>
                            <div class="input-row">
                                <input type="number" id="ser-R" class="number-input" value="10" step="any" placeholder="R (Ω)">
                                <input type="number" id="ser-L" class="number-input" value="0.1" step="any" placeholder="L (H)">
                                <input type="number" id="ser-C" class="number-input" value="1e-6" step="any" placeholder="C (F)">
                            </div>
                            <div class="input-row" style="margin-top:0.5rem;">
                                <input type="number" id="ser-Vrms" class="number-input" value="230" step="any" placeholder="V_rms (V)">
                                <input type="number" id="ser-f" class="number-input" value="50" step="any" placeholder="f (Hz)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runAC()">Analyze RLC &amp; resonance</button>
                        <div class="result-card">
                            <div class="result-value" id="ser-result">|Z| = —, I_rms = —, φ = —, cos φ = —, f₀ = —, Q = —</div>
                            <div>Uses Z = √(R² + (X_L − X_C)²), tan φ = (X_L − X_C)/R, f₀ = 1/(2π√(LC)), Q = ω₀L/R.</div>
                        </div>
                    </div>

                    <div id="panel-power" class="ac-panel">
                        <div class="input-section">
                            <div class="input-label">RMS values and phase (for power)</div>
                            <div class="input-row">
                                <input type="number" id="pow-Vrms" class="number-input" value="230" step="any" placeholder="V_rms (V)">
                                <input type="number" id="pow-Irms" class="number-input" value="5" step="any" placeholder="I_rms (A)">
                                <input type="number" id="pow-phi" class="number-input" value="30" step="any" placeholder="φ (deg)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runAC()">Calculate AC power</button>
                        <div class="result-card">
                            <div class="result-value" id="pow-result">P = —, S = —, Q = —, cos φ = —</div>
                            <div>Average power P = V_rms I_rms cos φ, apparent power S = V_rms I_rms, reactive power Q = V_rms I_rms sin φ.</div>
                        </div>
                    </div>

                    <div id="panel-transformer" class="ac-panel">
                        <div class="input-section">
                            <div class="input-label">Ideal transformer (Vp, Np, Ns, η)</div>
                            <div class="input-row">
                                <input type="number" id="tr-Vp" class="number-input" value="230" step="any" placeholder="V_p (V)">
                                <input type="number" id="tr-Np" class="number-input" value="500" step="any" placeholder="N_p">
                                <input type="number" id="tr-Ns" class="number-input" value="100" step="any" placeholder="N_s">
                                <input type="number" id="tr-eta" class="number-input" value="100" step="any" placeholder="η (%)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Secondary current (load)</div>
                            <div class="input-row">
                                <input type="number" id="tr-Is" class="number-input" value="2" step="any" placeholder="I_s (A)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runAC()">Analyze transformer</button>
                        <div class="result-card">
                            <div class="result-value" id="tr-result">V_s = —, I_p = —, P_p ≈ —, P_s ≈ —</div>
                            <div>Uses V_s/V_p = N_s/N_p, I_p/I_s = N_s/N_p (ideal), P_s ≈ η P_p/100.</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="ac-sim-panel" id="ac-sim-panel">
                    <div class="ac-sim-header"><h3>📈 AC waveforms &amp; phasors</h3></div>
                    <div class="ac-chart-wrap">
                        <canvas id="ac-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleACSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="ac-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="ac-steps-body"></div>
                </div>

                <div class="ref-card" style="margin-bottom:1.25rem;">
                    <h3>AC basics &amp; pure elements</h3>
                    <table class="ref-table">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Instantaneous voltage</td>
                                <td class="mono">v = V₀ sin(ωt)</td>
                                <td>ω = 2πf</td>
                            </tr>
                            <tr>
                                <td>Instantaneous current</td>
                                <td class="mono">i = I₀ sin(ωt + φ)</td>
                                <td>φ = phase difference</td>
                            </tr>
                            <tr>
                                <td>RMS values</td>
                                <td class="mono">V_rms = V₀/√2, I_rms = I₀/√2</td>
                                <td>≈ 0.707 × peak</td>
                            </tr>
                            <tr>
                                <td>Half-cycle average</td>
                                <td class="mono">V_avg(half) = 2V₀/π</td>
                                <td>Used in rectifiers</td>
                            </tr>
                            <tr>
                                <td>Pure resistor</td>
                                <td class="mono">Z = R, φ = 0°</td>
                                <td>V and I in phase</td>
                            </tr>
                            <tr>
                                <td>Pure inductor</td>
                                <td class="mono">Z = jX_L = jωL</td>
                                <td>V leads I by 90°</td>
                            </tr>
                            <tr>
                                <td>Pure capacitor</td>
                                <td class="mono">Z = −jX_C = −j/(ωC)</td>
                                <td>I leads V by 90°</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="ref-card">
                    <h3>Series RLC, resonance, power &amp; transformers</h3>
                    <table class="ref-table">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Series RLC impedance</td>
                                <td class="mono">Z = √(R² + (X_L − X_C)²)</td>
                                <td>tan φ = (X_L − X_C)/R</td>
                            </tr>
                            <tr>
                                <td>Resonance</td>
                                <td class="mono">ω₀ = 1/√(LC), f₀ = 1/(2π√(LC))</td>
                                <td>X_L = X_C, Z = R</td>
                            </tr>
                            <tr>
                                <td>Quality factor</td>
                                <td class="mono">Q = ω₀L/R = 1/(ω₀RC)</td>
                                <td>Sharpness of resonance</td>
                            </tr>
                            <tr>
                                <td>AC power</td>
                                <td class="mono">P = V_rms I_rms cos φ</td>
                                <td>Real power (watts)</td>
                            </tr>
                            <tr>
                                <td>Power triangle</td>
                                <td class="mono">S² = P² + Q²</td>
                                <td>S = V_rms I_rms, Q = V_rms I_rms sin φ</td>
                            </tr>
                            <tr>
                                <td>Transformer voltage</td>
                                <td class="mono">V_s/V_p = N_s/N_p</td>
                                <td>Turns ratio</td>
                            </tr>
                            <tr>
                                <td>Transformer currents</td>
                                <td class="mono">I_p/I_s = N_s/N_p</td>
                                <td>Power conservation (ideal)</td>
                            </tr>
                            <tr>
                                <td>Efficiency</td>
                                <td class="mono">η = (V_s I_s)/(V_p I_p) × 100%</td>
                                <td>&lt; 100% in real transformers</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About this AC circuits tool</h2>
            <p>
                This page summarizes alternating current formulas commonly used in exams: sinusoidal voltage and current, RMS and average
                values, pure R/L/C behavior, series RLC impedance and resonance, AC power and power factor, and ideal transformers.
                Each calculator is paired with a short step-by-step explanation to reinforce the concepts.
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
    <script src="<%=request.getContextPath()%>/physics/js/ac-circuits.js?v=<%=cacheVersion%>"></script>
</body>
</html>

