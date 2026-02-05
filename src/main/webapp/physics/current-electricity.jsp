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
        <jsp:param name="toolName" value="Current Electricity - Ohm’s Law, Circuits, RC & Heating" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Current electricity formulas and calculators: current, drift velocity, resistivity and conductivity, Ohm’s law, series/parallel resistance, cells with internal resistance, bridges, potentiometer, Joule heating, and RC time constant." />
        <jsp:param name="toolUrl" value="physics/current-electricity.jsp" />
        <jsp:param name="toolKeywords" value="current electricity calculator, Ohm law, resistance, resistivity, drift velocity, cells and EMF, wheatstone bridge, potentiometer, RC circuits, JEE NEET current electricity" />
        <jsp:param name="toolImage" value="current-electricity.png" />
        <jsp:param name="toolFeatures" value="Current and drift velocity,Resistivity and conductivity,Ohm’s law and combinations,Cells with internal resistance,Bridge and potentiometer calculators,Joule heating and RC time constant,Step-by-step solutions" />
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
            --ce-blue: #0ea5e9;
            --ce-amber: #f59e0b;
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
            background: linear-gradient(135deg, #0ea5e9 0%, #f59e0b 100%);
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
            color: var(--ce-blue);
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 1rem;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .info-box {
            background: linear-gradient(135deg, rgba(14,165,233,0.1), rgba(245,158,11,0.1));
            border-left: 4px solid var(--ce-blue);
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
            background: linear-gradient(135deg, #0ea5e9, #f59e0b);
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

        .ce-tabs {
            display: flex;
            gap: 0.25rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .ce-tab {
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

        .ce-tab:hover {
            border-color: var(--ce-blue);
            color: var(--ce-blue);
        }

        .ce-tab.active {
            background: linear-gradient(135deg, #0ea5e9, #f59e0b);
            border-color: #f59e0b;
            color: white;
        }

        .ce-panel {
            display: none;
        }

        .ce-panel.active {
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
            border-color: var(--ce-blue);
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
            background: linear-gradient(135deg, #0ea5e9, #f59e0b);
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
            background: linear-gradient(135deg, rgba(14,165,233,0.12), rgba(245,158,11,0.08));
            border: 2px solid var(--ce-blue);
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
            color: var(--ce-blue);
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
            background: linear-gradient(135deg, rgba(14,165,233,0.12), rgba(245,158,11,0.12));
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
            background: linear-gradient(135deg, #0ea5e9, #f59e0b);
            color: white;
            font-weight: 700;
        }

        .ref-table .mono {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            color: var(--ce-blue);
        }

        .ce-sim-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-light);
            margin: 1.25rem 0;
            overflow: hidden;
        }

        .ce-sim-header {
            background: linear-gradient(135deg, rgba(14,165,233,0.1), rgba(245,158,11,0.08));
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border-light);
        }

        .ce-sim-header h3 {
            margin: 0;
            font-size: 1rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .ce-chart-wrap {
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
            background: linear-gradient(135deg, #0ea5e9, #f59e0b);
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
            border-left: 4px solid var(--ce-blue);
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
            background: var(--ce-blue);
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
            <h1 class="tool-page-title"><span>🔌</span> Current Electricity – Ohm’s Law & Circuits</h1>
            <p class="tool-page-description">Current, drift, resistivity, Ohm’s law, cells, bridges, potentiometer, Joule heating, RC time</p>
            <div class="tool-badges">
                <span class="tool-badge">I = Q/t</span>
                <span class="tool-badge">R = ρL/A</span>
                <span class="tool-badge">V = IR</span>
                <span class="tool-badge">τ = RC</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title">
                <span>💡</span>
                <span>Current electricity at a glance</span>
            </div>
            <p>
                Electric current <strong>I = Q/t</strong> flows when charge moves through a conductor; at microscopic level electrons drift with
                <strong>v_d</strong> so that <strong>I = n e A v_d</strong>. Resistance <strong>R = ρ L/A</strong> depends on material (resistivity ρ) and geometry.
                Ohm’s law <strong>V = IR</strong> holds for ohmic conductors. Cells have EMF ε and internal resistance r; circuits obey
                Kirchhoff’s current and voltage laws. RC circuits charge/discharge with time constant <strong>τ = RC</strong>, and Joule’s law
                <strong>H = I² R t</strong> describes heating.
            </p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Current electricity calculators</h2>
                    <p>Microscopic current, Ohm’s law, cells, bridges, potentiometer, heating & RC</p>
                </div>
                <div class="panel-body">
                    <div class="ce-tabs">
                        <button type="button" class="ce-tab active" data-tab="basics">Current, drift &amp; material</button>
                        <button type="button" class="ce-tab" data-tab="ohm">Ohm’s law &amp; resistance</button>
                        <button type="button" class="ce-tab" data-tab="cells">Cells, EMF &amp; power</button>
                        <button type="button" class="ce-tab" data-tab="bridge">Bridge &amp; potentiometer</button>
                        <button type="button" class="ce-tab" data-tab="heating">Heating &amp; RC</button>
                    </div>

                    <div id="panel-basics" class="ce-panel active">
                        <div class="input-section">
                            <div class="input-label">Current from charge and time (I = Q/t)</div>
                            <div class="input-row">
                                <input type="number" id="ce-Q" class="number-input" value="1" step="any" placeholder="Q (C)">
                                <input type="number" id="ce-t" class="number-input" value="1" step="any" placeholder="t (s)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Current density and drift (J, v_d)</div>
                            <div class="input-row">
                                <input type="number" id="ce-A" class="number-input" value="1e-6" step="any" placeholder="Area A (m²)">
                                <input type="number" id="ce-n" class="number-input" value="8.5e28" step="any" placeholder="n (m⁻³)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Resistance, resistivity, conductivity (R, ρ, σ)</div>
                            <div class="input-row">
                                <input type="number" id="ce-R" class="number-input" value="10" step="any" placeholder="R (Ω)">
                                <input type="number" id="ce-L" class="number-input" value="1" step="any" placeholder="L (m)">
                                <input type="number" id="ce-A-wire" class="number-input" value="1e-6" step="any" placeholder="A (m²)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runCurrent()">Calculate I, J, v_d, ρ, σ</button>
                        <div class="result-card">
                            <div class="result-value" id="ce-basics-result">I = —, J = —, v_d = —, ρ = —, σ = —</div>
                            <div>I = Q/t, J = I/A, v_d = I/(n e A), ρ = R A/L, σ = 1/ρ.</div>
                        </div>
                    </div>

                    <div id="panel-ohm" class="ce-panel">
                        <div class="input-section">
                            <div class="input-label">Ohm’s law (any two → third)</div>
                            <div class="input-row">
                                <input type="number" id="ohm-V" class="number-input" value="12" step="any" placeholder="V (volts)">
                                <input type="number" id="ohm-I" class="number-input" value="2" step="any" placeholder="I (A)">
                                <input type="number" id="ohm-R" class="number-input" value="" step="any" placeholder="R (Ω)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Wire resistance (R = ρL/A)</div>
                            <div class="input-row">
                                <input type="number" id="ohm-rho" class="number-input" value="1.7e-8" step="any" placeholder="ρ (Ω·m)">
                                <input type="number" id="ohm-L" class="number-input" value="2" step="any" placeholder="L (m)">
                                <input type="number" id="ohm-Awire" class="number-input" value="1e-6" step="any" placeholder="A (m²)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Temperature dependence (R = R₀ (1 + αΔT))</div>
                            <div class="input-row">
                                <input type="number" id="ohm-R0" class="number-input" value="10" step="any" placeholder="R₀ (Ω)">
                                <input type="number" id="ohm-alpha" class="number-input" value="0.004" step="any" placeholder="α (1/K)">
                                <input type="number" id="ohm-dT" class="number-input" value="20" step="any" placeholder="ΔT (K)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runCurrent()">Solve Ohm’s law &amp; R</button>
                        <div class="result-card">
                            <div class="result-value" id="ce-ohm-result">V = —, I = —, R = —, R_wire = —, R(T) = —</div>
                            <div>Uses V = IR, R = ρL/A, and R = R₀ (1 + αΔT).</div>
                        </div>
                    </div>

                    <div id="panel-cells" class="ce-panel">
                        <div class="input-section">
                            <div class="input-label">Single cell with external resistance (ε, r, R)</div>
                            <div class="input-row">
                                <input type="number" id="cell-eps" class="number-input" value="12" step="any" placeholder="ε (V)">
                                <input type="number" id="cell-r" class="number-input" value="1" step="any" placeholder="r (Ω)">
                                <input type="number" id="cell-R" class="number-input" value="5" step="any" placeholder="R (Ω)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Identical cells in series/parallel (n, ε, r)</div>
                            <div class="input-row">
                                <input type="number" id="cell-n" class="number-input" value="3" step="1" placeholder="n cells">
                                <input type="number" id="cell-eps2" class="number-input" value="1.5" step="any" placeholder="ε (V)">
                                <input type="number" id="cell-r2" class="number-input" value="0.5" step="any" placeholder="r (Ω)">
                            </div>
                            <div class="input-row" style="margin-top:0.5rem;">
                                <input type="number" id="cell-Rload2" class="number-input" value="5" step="any" placeholder="R_load (Ω)">
                                <select id="cell-mode" class="unit-select">
                                    <option value="series">Series</option>
                                    <option value="parallel">Parallel</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runCurrent()">Analyze cell &amp; battery</button>
                        <div class="result-card">
                            <div class="result-value" id="ce-cells-result">I = —, V_term = —, P_load = —, (ε_eq, r_eq, I_batt) = —</div>
                            <div>Single: I = ε/(R+r), V_term = ε − Ir, P = I²R. For n identical cells: series ε_eq = nε, r_eq = nr; parallel ε_eq = ε, r_eq = r/n.</div>
                        </div>
                    </div>

                    <div id="panel-bridge" class="ce-panel">
                        <div class="input-section">
                            <div class="input-label">Balanced Wheatstone bridge (P, Q, R → S)</div>
                            <div class="input-row">
                                <input type="number" id="bridge-P" class="number-input" value="10" step="any" placeholder="P (Ω)">
                                <input type="number" id="bridge-Q" class="number-input" value="20" step="any" placeholder="Q (Ω)">
                                <input type="number" id="bridge-R" class="number-input" value="5" step="any" placeholder="R (Ω)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Meter bridge (slide wire): R, l₁, l₂ → X</div>
                            <div class="input-row">
                                <input type="number" id="mb-R" class="number-input" value="10" step="any" placeholder="R known (Ω)">
                                <input type="number" id="mb-l1" class="number-input" value="60" step="any" placeholder="l₁ (cm)">
                                <input type="number" id="mb-l2" class="number-input" value="40" step="any" placeholder="l₂ (cm)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Potentiometer: comparison &amp; internal resistance</div>
                            <div class="input-row">
                                <input type="number" id="pot-L" class="number-input" value="100" step="any" placeholder="L (cm, wire length)">
                                <input type="number" id="pot-Vdrive" class="number-input" value="2" step="any" placeholder="Driving ε (V)">
                            </div>
                            <div class="input-row" style="margin-top:0.5rem;">
                                <input type="number" id="pot-l1" class="number-input" value="60" step="any" placeholder="l₁ (cm)">
                                <input type="number" id="pot-l2" class="number-input" value="40" step="any" placeholder="l₂ (cm)">
                                <input type="number" id="pot-Rext" class="number-input" value="10" step="any" placeholder="R (Ω) for internal r">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runCurrent()">Solve bridge &amp; potentiometer</button>
                        <div class="result-card">
                            <div class="result-value" id="ce-bridge-result">S = —, X = —, k = —, ε₁/ε₂ = —, r = —</div>
                            <div>Bridge: P/Q = R/S. Meter bridge: R/X = l₁/l₂. Potentiometer: k = V/L, ε₁/ε₂ = l₁/l₂, r = R(l₁ − l₂)/l₂.</div>
                        </div>
                    </div>

                    <div id="panel-heating" class="ce-panel">
                        <div class="input-section">
                            <div class="input-label">Joule heating (H = I² R t)</div>
                            <div class="input-row">
                                <input type="number" id="heat-I" class="number-input" value="2" step="any" placeholder="I (A)">
                                <input type="number" id="heat-R" class="number-input" value="10" step="any" placeholder="R (Ω)">
                                <input type="number" id="heat-t" class="number-input" value="10" step="any" placeholder="t (s)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">RC time constant (τ = RC) and key times</div>
                            <div class="input-row">
                                <input type="number" id="rc-R" class="number-input" value="1e3" step="any" placeholder="R (Ω)">
                                <input type="number" id="rc-C" class="number-input" value="1e-6" step="any" placeholder="C (F)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runCurrent()">Calculate H and τ</button>
                        <div class="result-card">
                            <div class="result-value" id="ce-heating-result">H = —, τ = —, charging/discharging values listed below</div>
                            <div>Shows Joule heat H and τ, plus approximate V_C(t) for charging/discharging at t = τ, 2τ, 3τ, 5τ.</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="ce-sim-panel" id="ce-sim-panel">
                    <div class="ce-sim-header"><h3>📈 Current electricity graph</h3></div>
                    <div class="ce-chart-wrap">
                        <canvas id="ce-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleCurrentSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="ce-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="ce-steps-body"></div>
                </div>

                <div class="ref-card" style="margin-bottom:1.25rem;">
                    <h3>Basic current electricity quantities &amp; definitions</h3>
                    <table class="ref-table">
                        <thead>
                            <tr>
                                <th>Quantity</th>
                                <th>Symbol / Formula</th>
                                <th>SI unit</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Electric current</td>
                                <td class="mono">I = Q / t</td>
                                <td>A (ampere)</td>
                                <td>Rate of flow of charge</td>
                            </tr>
                            <tr>
                                <td>Current density</td>
                                <td class="mono">J = I / A</td>
                                <td>A/m²</td>
                                <td>Vector, direction of conventional current</td>
                            </tr>
                            <tr>
                                <td>Drift velocity</td>
                                <td class="mono">I = n e A v_d ⇒ v_d = I / (n e A)</td>
                                <td>m/s</td>
                                <td>Average slow drift of electrons</td>
                            </tr>
                            <tr>
                                <td>Resistance</td>
                                <td class="mono">R = V / I</td>
                                <td>Ω</td>
                                <td>Opposition to current</td>
                            </tr>
                            <tr>
                                <td>Resistivity &amp; conductivity</td>
                                <td class="mono">R = ρ L / A,  σ = 1/ρ</td>
                                <td>ρ: Ω·m, σ: S/m</td>
                                <td>Material properties</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="ref-card">
                    <h3>Ohm’s law, cells, bridges, potentiometer, heating &amp; RC</h3>
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
                                <td>Ohm’s law</td>
                                <td class="mono">V = I R</td>
                                <td>Ohmic conductors at constant temperature</td>
                            </tr>
                            <tr>
                                <td>Temperature dependence</td>
                                <td class="mono">R = R₀ (1 + αΔT)</td>
                                <td>α = temperature coefficient</td>
                            </tr>
                            <tr>
                                <td>Series &amp; parallel</td>
                                <td class="mono">R_s = ΣRᵢ, 1/R_p = Σ(1/Rᵢ)</td>
                                <td>Current same in series, voltage same in parallel</td>
                            </tr>
                            <tr>
                                <td>Cell with internal resistance</td>
                                <td class="mono">I = ε / (R + r), V_term = ε − I r</td>
                                <td>P_load = I²R, max when R = r</td>
                            </tr>
                            <tr>
                                <td>Wheatstone bridge</td>
                                <td class="mono">P/Q = R/S (balanced)</td>
                                <td>No galvanometer current at balance</td>
                            </tr>
                            <tr>
                                <td>Meter bridge</td>
                                <td class="mono">R/X = l₁/l₂</td>
                                <td>l₁ + l₂ = 100 cm</td>
                            </tr>
                            <tr>
                                <td>Potentiometer</td>
                                <td class="mono">k = V/L,  ε₁/ε₂ = l₁/l₂,  r = R(l₁ − l₂)/l₂</td>
                                <td>Null deflection method (no current from test cell)</td>
                            </tr>
                            <tr>
                                <td>Joule heating</td>
                                <td class="mono">H = I² R t</td>
                                <td>Heat produced in resistor</td>
                            </tr>
                            <tr>
                                <td>RC circuit</td>
                                <td class="mono">τ = R C</td>
                                <td>Charging: V_C = ε(1 − e^{−t/τ}); discharging: V = V₀ e^{−t/τ}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About this current electricity tool</h2>
            <p>
                This page organizes the main current electricity formulas used in school physics, JEE, and NEET: microscopic current and
                drift, resistivity and conductivity, Ohm’s law and combinations, cells with internal resistance and power transfer,
                Wheatstone/meter bridge, potentiometer, Joule heating, and RC time constant. Each calculator is paired with
                step-by-step reasoning to connect formulas to physical intuition.
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
    <script src="<%=request.getContextPath()%>/physics/js/current-electricity.js?v=<%=cacheVersion%>"></script>
</body>
</html>

