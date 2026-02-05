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
        <jsp:param name="toolName" value="Kinetic Theory of Gases - Speeds, Pressure & Energy" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Kinetic theory of gases calculators: rms, average and most probable speeds, kinetic energy-temperature relations, pressure from molecular motion, mean free path, degrees of freedom and Graham's law with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/kinetic-theory.jsp" />
        <jsp:param name="toolKeywords" value="kinetic theory of gases, rms speed, most probable speed, average speed, mean free path, Graham's law, KE and temperature, JEE, NEET" />
        <jsp:param name="toolImage" value="kinetic-theory.png" />
        <jsp:param name="toolFeatures" value="v_rms, v_avg, v_mp,Pressure from molecular motion,KE-temperature relation,Degrees of freedom & γ,Mean free path & collision frequency,Graham's law of diffusion,Step-by-step derivations" />
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
            --ktg-green: #22c55e;
            --ktg-blue: #0ea5e9;
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
            background: linear-gradient(135deg, #22c55e 0%, #0ea5e9 100%);
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
            color: var(--ktg-green);
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 1rem;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .info-box {
            background: linear-gradient(135deg, rgba(34,197,94,0.12), rgba(14,165,233,0.10));
            border-left: 4px solid var(--ktg-green);
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
            background: linear-gradient(135deg, #22c55e, #0ea5e9);
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

        .ktg-tabs {
            display: flex;
            gap: 0.25rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .ktg-tab {
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

        .ktg-tab:hover {
            border-color: var(--ktg-green);
            color: var(--ktg-green);
        }

        .ktg-tab.active {
            background: linear-gradient(135deg, #22c55e, #0ea5e9);
            border-color: #0ea5e9;
            color: white;
        }

        .ktg-panel {
            display: none;
        }

        .ktg-panel.active {
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
            border-color: var(--ktg-green);
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
            background: linear-gradient(135deg, #22c55e, #0ea5e9);
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
            background: linear-gradient(135deg, rgba(34,197,94,0.12), rgba(14,165,233,0.08));
            border: 2px solid var(--ktg-green);
            border-radius: 12px;
            padding: 1rem 1.1rem;
            margin-top: 0.9rem;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .result-value {
            font-size: 1.05rem;
            font-weight: 800;
            font-family: 'JetBrains Mono', monospace;
            color: var(--ktg-green);
        }

        .ktg-sim-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-light);
            margin: 1.25rem 0;
            overflow: hidden;
        }

        .ktg-sim-header {
            background: linear-gradient(135deg, rgba(34,197,94,0.1), rgba(14,165,233,0.08));
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border-light);
        }

        .ktg-sim-header h3 {
            margin: 0;
            font-size: 1rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .ktg-chart-wrap {
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
            background: linear-gradient(135deg, rgba(34,197,94,0.12), rgba(14,165,233,0.12));
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
            background: linear-gradient(135deg, #22c55e, #0ea5e9);
            color: white;
            font-weight: 700;
        }

        .ref-table .mono {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            color: var(--ktg-green);
        }

        .steps-section {
            margin: 1rem 0;
            background: var(--surface-2);
            border-radius: 12px;
            border: 1px solid var(--border-light);
            overflow: hidden;
        }

        .steps-header {
            background: linear-gradient(135deg, #22c55e, #0ea5e9);
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
            border-left: 4px solid var(--ktg-green);
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
            background: var(--ktg-green);
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
            color: #22c55e;
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
            <h1 class="tool-page-title"><span>💨</span> Kinetic Theory of Gases</h1>
            <p class="tool-page-description">Molecular speeds, pressure from collisions, kinetic energy and temperature, mean free path &amp; diffusion</p>
            <div class="tool-badges">
                <span class="tool-badge">P = (1/3) ρ v_rms²</span>
                <span class="tool-badge">K.E_avg = (3/2) kT</span>
                <span class="tool-badge">v_rms = √(3RT/M)</span>
                <span class="tool-badge">λ = 1/(√2 π d² n)</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title">
                <span>💡</span>
                <span>Molecules in random motion</span>
            </div>
            <p>
                Kinetic theory models a gas as a large number of tiny molecules in constant random motion making perfectly elastic collisions
                with each other and the container walls. From these microscopic assumptions, we can derive macroscopic quantities like pressure
                <strong>P = (1/3) (N/V) m v_rms²</strong> and show that average kinetic energy per molecule
                <strong>K.E_avg = (3/2) kT</strong> is proportional to absolute temperature. The theory also explains molecular speed
                distributions, mean free path, diffusion/effusion and the specific heats of gases via degrees of freedom.
            </p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Kinetic theory calculators</h2>
                    <p>Speeds, pressure, kinetic energy, degrees of freedom, mean free path &amp; diffusion</p>
                </div>
                <div class="panel-body">
                    <div class="ktg-tabs">
                        <button type="button" class="ktg-tab active" data-tab="speeds">Speeds &amp; KE vs T</button>
                        <button type="button" class="ktg-tab" data-tab="pressure">Pressure from molecular motion</button>
                        <button type="button" class="ktg-tab" data-tab="dof">Degrees of freedom &amp; γ</button>
                        <button type="button" class="ktg-tab" data-tab="mfp">Mean free path</button>
                        <button type="button" class="ktg-tab" data-tab="graham">Graham's law</button>
                    </div>

                    <div id="panel-speeds" class="ktg-panel active">
                        <div class="input-section">
                            <div class="input-label">Temperature and molar mass</div>
                            <div class="input-row">
                                <input type="number" id="ktg-T" class="number-input" value="300" step="any" placeholder="T (K)">
                                <input type="number" id="ktg-M" class="number-input" value="0.028" step="any" placeholder="M (kg/mol)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runKTG()">Calculate speeds &amp; KE</button>
                        <div class="result-card">
                            <div class="result-value" id="ktg-speeds-result">v_mp = —, v_avg = —, v_rms = —</div>
                            <div>Uses v_rms = √(3RT/M), v_avg = √(8RT/(πM)), v_mp = √(2RT/M) and K.E_avg = (3/2)kT.</div>
                        </div>
                    </div>

                    <div id="panel-pressure" class="ktg-panel">
                        <div class="input-section">
                            <div class="input-label">Moles, volume and temperature</div>
                            <div class="input-row">
                                <input type="number" id="ktg-n" class="number-input" value="1" step="any" placeholder="n (mol)">
                                <input type="number" id="ktg-V" class="number-input" value="0.024" step="any" placeholder="V (m³)">
                                <input type="number" id="ktg-Tp" class="number-input" value="300" step="any" placeholder="T (K)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Molar mass (for v_rms and ρ)</div>
                            <div class="input-row">
                                <input type="number" id="ktg-Mp" class="number-input" value="0.028" step="any" placeholder="M (kg/mol)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runKTG()">Calculate pressure</button>
                        <div class="result-card">
                            <div class="result-value" id="ktg-pressure-result">P_kinetic = —, P_ideal = —</div>
                            <div>Uses P = (1/3) (N/V) m v_rms² and compares with ideal gas law P = nRT/V.</div>
                        </div>
                    </div>

                    <div id="panel-dof" class="ktg-panel">
                        <div class="input-section">
                            <div class="input-label">Gas type and amount</div>
                            <div class="input-row">
                                <select id="ktg-gastype" class="unit-select">
                                    <option value="mono">Monatomic</option>
                                    <option value="dia">Diatomic (room T)</option>
                                    <option value="dia-high">Diatomic (high T, vibration)</option>
                                    <option value="poly">Polyatomic (non-linear)</option>
                                </select>
                                <input type="number" id="ktg-Td" class="number-input" value="300" step="any" placeholder="T (K)">
                                <input type="number" id="ktg-nd" class="number-input" value="1" step="any" placeholder="n (mol)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runKTG()">Calculate U, C_v, C_p, γ</button>
                        <div class="result-card">
                            <div class="result-value" id="ktg-dof-result">U = —, C_v = —, C_p = —, γ = —</div>
                            <div>Uses equipartition: U = (f/2) nRT, C_v = (f/2)R, C_p = C_v + R, γ = C_p/C_v.</div>
                        </div>
                    </div>

                    <div id="panel-mfp" class="ktg-panel">
                        <div class="input-section">
                            <div class="input-label">Temperature, pressure and molecular diameter</div>
                            <div class="input-row">
                                <input type="number" id="ktg-Tm" class="number-input" value="300" step="any" placeholder="T (K)">
                                <input type="number" id="ktg-Pm" class="number-input" value="1.01e5" step="any" placeholder="P (Pa)">
                                <input type="number" id="ktg-d" class="number-input" value="3e-10" step="any" placeholder="d (m)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runKTG()">Calculate λ &amp; collision rate</button>
                        <div class="result-card">
                            <div class="result-value" id="ktg-mfp-result">λ = —, Z = —</div>
                            <div>Uses λ = (kT)/(√2 π d² P) and Z = v_avg/λ with v_avg from temperature.</div>
                        </div>
                    </div>

                    <div id="panel-graham" class="ktg-panel">
                        <div class="input-section">
                            <div class="input-label">Molar masses for diffusion/effusion</div>
                            <div class="input-row">
                                <input type="number" id="ktg-M1" class="number-input" value="0.028" step="any" placeholder="M₁ (kg/mol)">
                                <input type="number" id="ktg-M2" class="number-input" value="0.032" step="any" placeholder="M₂ (kg/mol)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runKTG()">Apply Graham's law</button>
                        <div class="result-card">
                            <div class="result-value" id="ktg-graham-result">r₁/r₂ = —, t₁/t₂ = —</div>
                            <div>Uses r₁/r₂ = √(M₂/M₁) and t₁/t₂ = √(M₁/M₂) at same T and P.</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="ktg-sim-panel" id="ktg-sim-panel">
                    <div class="ktg-sim-header"><h3>📈 Maxwell speed distribution</h3></div>
                    <div class="ktg-chart-wrap">
                        <canvas id="ktg-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleKTGSteps()">
                        <span>🧮</span>
                        <span>Step-by-Step Solution</span>
                        <span class="steps-toggle" id="ktg-steps-toggle">▼ Show</span>
                    </div>
                    <div class="steps-body collapsed" id="ktg-steps-body"></div>
                </div>

                <div class="ref-card" style="margin-bottom:1.25rem;">
                    <h3>Pressure, kinetic energy and speeds</h3>
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
                                <td>Pressure of ideal gas</td>
                                <td class="mono">P = (1/3) (N/V) m v_rms²</td>
                                <td>From molecular collisions</td>
                            </tr>
                            <tr>
                                <td>Density form</td>
                                <td class="mono">P = (1/3) ρ v_rms²</td>
                                <td>ρ = Nm/V</td>
                            </tr>
                            <tr>
                                <td>Average KE per molecule</td>
                                <td class="mono">(1/2) m v_rms² = (3/2) kT</td>
                                <td>Kinetic interpretation of T</td>
                            </tr>
                            <tr>
                                <td>Total KE</td>
                                <td class="mono">K_total = (3/2) N kT = (3/2) nRT</td>
                                <td>Translational KE</td>
                            </tr>
                            <tr>
                                <td>Root mean square speed</td>
                                <td class="mono">v_rms = √(3RT/M)</td>
                                <td>Also √(3kT/m)</td>
                            </tr>
                            <tr>
                                <td>Average speed</td>
                                <td class="mono">v_avg = √(8RT/(πM))</td>
                                <td>v_avg ≈ 0.921 v_rms</td>
                            </tr>
                            <tr>
                                <td>Most probable speed</td>
                                <td class="mono">v_mp = √(2RT/M)</td>
                                <td>v_mp : v_avg : v_rms ≈ 1 : 1.128 : 1.224</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="ref-card">
                    <h3>Degrees of freedom, mean free path &amp; diffusion</h3>
                    <table class="ref-table">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula / Values</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Equipartition</td>
                                <td class="mono">Each f gives (1/2)kT per molecule</td>
                                <td>Or (1/2)RT per mole</td>
                            </tr>
                            <tr>
                                <td>Internal energy</td>
                                <td class="mono">U = (f/2) nRT</td>
                                <td>f = degrees of freedom</td>
                            </tr>
                            <tr>
                                <td>Mean free path</td>
                                <td class="mono">λ = (kT)/(√2 π d² P)</td>
                                <td>Air at STP: ~10⁻⁷ m</td>
                            </tr>
                            <tr>
                                <td>Collision frequency</td>
                                <td class="mono">Z = v_avg/λ</td>
                                <td>Collisions per second</td>
                            </tr>
                            <tr>
                                <td>Graham's law</td>
                                <td class="mono">r₁/r₂ = √(M₂/M₁)</td>
                                <td>Diffusion/effusion rates</td>
                            </tr>
                            <tr>
                                <td>Effusion times</td>
                                <td class="mono">t₁/t₂ = √(M₁/M₂)</td>
                                <td>Same T and P</td>
                            </tr>
                            <tr>
                                <td>Ideal gas law (kinetic)</td>
                                <td class="mono">PV = (1/3) N m v_rms² = nRT</td>
                                <td>Bridges micro and macro</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About this kinetic theory tool</h2>
            <p>
                This tool focuses on the kinetic theory part of thermodynamics: how random molecular motion leads to gas pressure, temperature,
                energy and transport properties. Use it to quickly compute rms/average/most probable speeds, relate kinetic energy to
                temperature, compare kinetic and ideal-gas pressure, find internal energy from degrees of freedom, estimate mean free path
                and collision frequency, and apply Graham's law for diffusion or effusion questions.
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
    <script src="<%=request.getContextPath()%>/physics/js/kinetic-theory.js?v=<%=cacheVersion%>"></script>
</body>
</html>

