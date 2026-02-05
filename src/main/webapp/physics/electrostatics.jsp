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
        <jsp:param name="toolName" value="Electrostatics - Coulomb's Law, Fields, Potential & Capacitors" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Electrostatics formulas and calculators: Coulomb's law for point charges, electric field and potential, Gauss's law shortcuts, and capacitor/capacitance formulas with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/electrostatics.jsp" />
        <jsp:param name="toolKeywords" value="electrostatics calculator, Coulomb law, electric field, electric potential, Gauss law, capacitor calculator, capacitance, JEE NEET electrostatics" />
        <jsp:param name="toolImage" value="electrostatics.png" />
        <jsp:param name="toolFeatures" value="Coulomb's law calculator,Electric field & potential calculators,Continuous charge distributions,Gauss's law shortcuts,Capacitor and capacitance calculator,Step-by-step solutions,Reference tables for electrostatics constants" />
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
            --es-blue: #2563eb;
            --es-purple: #7c3aed;
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
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
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
            color: var(--es-blue);
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 1rem;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .info-box {
            background: linear-gradient(135deg, rgba(37,99,235,0.1), rgba(124,58,237,0.1));
            border-left: 4px solid var(--es-blue);
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
            background: linear-gradient(135deg, #2563eb, #7c3aed);
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

        .es-tabs {
            display: flex;
            gap: 0.25rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .es-tab {
            padding: 0.5rem 1rem;
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
        }

        .es-tab:hover {
            border-color: var(--es-blue);
            color: var(--es-blue);
        }

        .es-tab.active {
            background: linear-gradient(135deg, #2563eb, #7c3aed);
            border-color: #7c3aed;
            color: white;
        }

        .es-panel {
            display: none;
        }

        .es-panel.active {
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
            border-color: var(--es-blue);
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
            background: linear-gradient(135deg, #2563eb, #7c3aed);
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
            background: linear-gradient(135deg, rgba(37,99,235,0.12), rgba(124,58,237,0.08));
            border: 2px solid var(--es-blue);
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
            color: var(--es-blue);
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
            background: linear-gradient(135deg, rgba(37,99,235,0.12), rgba(124,58,237,0.12));
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
            background: linear-gradient(135deg, #2563eb, #7c3aed);
            color: white;
            font-weight: 700;
        }

        .ref-table .mono {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            color: var(--es-blue);
        }

        .es-sim-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-light);
            margin: 1.25rem 0;
            overflow: hidden;
        }

        .es-sim-header {
            background: linear-gradient(135deg, rgba(37,99,235,0.1), rgba(124,58,237,0.08));
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border-light);
        }

        .es-sim-header h3 {
            margin: 0;
            font-size: 1rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .es-chart-wrap {
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
            background: linear-gradient(135deg, #2563eb, #7c3aed);
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
            border-left: 4px solid var(--es-blue);
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
            background: var(--es-blue);
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
            color: #2563eb;
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
            <h1 class="tool-page-title"><span>⚡</span> Electrostatics – Fields, Potential & Capacitors</h1>
            <p class="tool-page-description">Coulomb’s law, electric field and potential, Gauss’s law shortcuts, and capacitor formulas</p>
            <div class="tool-badges">
                <span class="tool-badge">F = k q₁q₂/r²</span>
                <span class="tool-badge">E = kq/r², V = kq/r</span>
                <span class="tool-badge">∮E·dA = Q/ε₀</span>
                <span class="tool-badge">C = ε₀A/d</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title">
                <span>💡</span>
                <span>Electrostatics at a glance</span>
            </div>
            <p>
                Charges interact via Coulomb’s law <strong>F = k q₁ q₂ / r²</strong>, producing an electric field <strong>E</strong> (vector, N/C) and potential
                <strong>V</strong> (scalar, J/C). Superposition lets you sum contributions from multiple charges or continuous distributions.
                Gauss’s law <strong>∮ E·dA = Q_enclosed / ε₀</strong> simplifies symmetric cases. Capacitors store energy with
                <strong>U = ½ C V²</strong> and effective capacitance depends on geometry and series/parallel combinations.
            </p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Electrostatics calculators</h2>
                    <p>Point charges, continuous fields, potentials, and capacitors</p>
                </div>
                <div class="panel-body">
                    <div class="es-tabs">
                        <button type="button" class="es-tab active" data-tab="coulomb">Coulomb’s law &amp; point charges</button>
                        <button type="button" class="es-tab" data-tab="field">Continuous fields</button>
                        <button type="button" class="es-tab" data-tab="potential">Potential &amp; energy</button>
                        <button type="button" class="es-tab" data-tab="capacitor">Capacitors &amp; combinations</button>
                    </div>

                    <div id="panel-coulomb" class="es-panel active">
                        <div class="input-section">
                            <div class="input-label">Two point charges (q₁, q₂) and separation r</div>
                            <div class="input-row">
                                <input type="number" id="coulomb-q1" class="number-input" value="1e-6" step="any" placeholder="q₁ (C)">
                                <input type="number" id="coulomb-q2" class="number-input" value="2e-6" step="any" placeholder="q₂ (C)">
                                <input type="number" id="coulomb-r" class="number-input" value="0.10" step="any" placeholder="r (m)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElectrostatics()">Calculate F and E</button>
                        <div class="result-card">
                            <div class="result-value" id="es-coulomb-result">F = —, E at q₂ due to q₁ = —</div>
                            <div>Uses F = k q₁ q₂ / r² and E = k q / r² with k ≈ 9 × 10⁹ N·m²/C².</div>
                        </div>
                    </div>

                    <div id="panel-field" class="es-panel">
                        <div class="input-section">
                            <div class="input-label">Choose configuration and parameters</div>
                            <div class="input-row">
                                <select id="field-config" class="unit-select">
                                    <option value="line">Infinite line (λ, r)</option>
                                    <option value="sheet">Infinite sheet (σ)</option>
                                    <option value="parallel">Parallel sheets (σ)</option>
                                    <option value="sphere-out">Solid/shell (outside, Q, r)</option>
                                    <option value="sphere-in">Solid sphere (inside, Q, r, R)</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Charge parameters</div>
                            <div class="input-row">
                                <input type="number" id="field-param1" class="number-input" value="1e-6" step="any" placeholder="λ or σ or Q">
                                <input type="number" id="field-param2" class="number-input" value="0.10" step="any" placeholder="r (m)">
                                <input type="number" id="field-param3" class="number-input" value="0.20" step="any" placeholder="R (m, for inside sphere)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElectrostatics()">Calculate E</button>
                        <div class="result-card">
                            <div class="result-value" id="es-field-result">E = —</div>
                            <div>Uses E(∞ line) = λ/(2πε₀ r), E(sheet) = σ/(2ε₀), E(between sheets) = σ/ε₀, E(sphere) as in Gauss’s law.</div>
                        </div>
                    </div>

                    <div id="panel-potential" class="es-panel">
                        <div class="input-section">
                            <div class="input-label">Point charge potential (q, r)</div>
                            <div class="input-row">
                                <input type="number" id="pot-q" class="number-input" value="1e-6" step="any" placeholder="q (C)">
                                <input type="number" id="pot-r" class="number-input" value="0.20" step="any" placeholder="r (m)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Potential energy U = qV</div>
                            <div class="input-row">
                                <input type="number" id="pot-test-q" class="number-input" value="1e-6" step="any" placeholder="test q (C)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElectrostatics()">Calculate V and U</button>
                        <div class="result-card">
                            <div class="result-value" id="es-potential-result">V = —, U = —</div>
                            <div>Uses V = kq/r with V(∞) = 0 and U = qV.</div>
                        </div>
                    </div>

                    <div id="panel-capacitor" class="es-panel">
                        <div class="input-section">
                            <div class="input-label">Parallel plate capacitor (A, d, κ, V)</div>
                            <div class="input-row">
                                <input type="number" id="cap-A" class="number-input" value="0.01" step="any" placeholder="A (m²)">
                                <input type="number" id="cap-d" class="number-input" value="0.001" step="any" placeholder="d (m)">
                            </div>
                            <div class="input-row" style="margin-top:0.5rem;">
                                <input type="number" id="cap-kappa" class="number-input" value="1" step="any" placeholder="κ">
                                <input type="number" id="cap-V" class="number-input" value="100" step="any" placeholder="V (volts)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElectrostatics()">Calculate C and U</button>
                        <div class="result-card">
                            <div class="result-value" id="es-capacitor-result">C = —, U = —</div>
                            <div>Uses C = κ ε₀ A / d and U = ½ C V².</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="es-sim-panel" id="es-sim-panel">
                    <div class="es-sim-header"><h3>📈 Electrostatics graph</h3></div>
                    <div class="es-chart-wrap">
                        <canvas id="es-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleEsSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="es-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="es-steps-body"></div>
                </div>

                <div class="ref-card" style="margin-bottom:1.25rem;">
                    <h3>Basic electrostatics constants & quantities</h3>
                    <table class="ref-table">
                        <thead>
                            <tr>
                                <th>Quantity</th>
                                <th>Symbol / Value</th>
                                <th>SI unit</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Electric charge</td>
                                <td class="mono">q, Q; e = 1.602×10⁻¹⁹ C</td>
                                <td>C</td>
                                <td>Charge is quantized in multiples of e</td>
                            </tr>
                            <tr>
                                <td>Coulomb’s constant</td>
                                <td class="mono">k = 1/(4πε₀) ≈ 9×10⁹</td>
                                <td>N·m²/C²</td>
                                <td>Often use k ≈ 9×10⁹ N·m²/C²</td>
                            </tr>
                            <tr>
                                <td>Permittivity of free space</td>
                                <td class="mono">ε₀ = 8.854×10⁻¹²</td>
                                <td>F/m</td>
                                <td>Relates E, D fields; k = 1/(4πε₀)</td>
                            </tr>
                            <tr>
                                <td>Electric field</td>
                                <td class="mono">E</td>
                                <td>N/C or V/m</td>
                                <td>Vector; E = F/q (test charge)</td>
                            </tr>
                            <tr>
                                <td>Electric potential</td>
                                <td class="mono">V</td>
                                <td>V (J/C)</td>
                                <td>Scalar; work per unit charge</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="ref-card">
                    <h3>Fields, Gauss’s law, potential & capacitors</h3>
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
                                <td>Coulomb’s law (magnitude)</td>
                                <td class="mono">F = k q₁ q₂ / r²</td>
                                <td>Along the line joining charges</td>
                            </tr>
                            <tr>
                                <td>Electric field (point charge)</td>
                                <td class="mono">E = k q / r²</td>
                                <td>Direction: away from +q, toward −q</td>
                            </tr>
                            <tr>
                                <td>Superposition</td>
                                <td class="mono">E_total = ΣEᵢ, V_total = ΣVᵢ</td>
                                <td>Vector sum for E, scalar sum for V</td>
                            </tr>
                            <tr>
                                <td>Gauss’s law</td>
                                <td class="mono">∮ E·dA = Q_enclosed / ε₀</td>
                                <td>Use high symmetry: sphere, cylinder, plane</td>
                            </tr>
                            <tr>
                                <td>Infinite line charge</td>
                                <td class="mono">E = λ / (2πε₀ r)</td>
                                <td>r = perpendicular distance</td>
                            </tr>
                            <tr>
                                <td>Infinite sheet</td>
                                <td class="mono">E = σ / (2ε₀)</td>
                                <td>Uniform sheet; independent of distance</td>
                            </tr>
                            <tr>
                                <td>Two sheets (±σ)</td>
                                <td class="mono">E_between = σ / ε₀</td>
                                <td>Field doubles between, cancels outside</td>
                            </tr>
                            <tr>
                                <td>Sphere (outside)</td>
                                <td class="mono">E = kQ/r², V = kQ/r</td>
                                <td>Acts like point charge at center</td>
                            </tr>
                            <tr>
                                <td>Solid sphere (inside)</td>
                                <td class="mono">E = kQr/R³</td>
                                <td>Uniform volume charge</td>
                            </tr>
                            <tr>
                                <td>Potential energy of two charges</td>
                                <td class="mono">U = k q₁ q₂ / r</td>
                                <td>Positive for like charges (repulsive)</td>
                            </tr>
                            <tr>
                                <td>Capacitance (parallel plate)</td>
                                <td class="mono">C = ε₀ A / d, with dielectric C = κ ε₀ A / d</td>
                                <td>κ &gt; 1 for dielectric</td>
                            </tr>
                            <tr>
                                <td>Energy stored in capacitor</td>
                                <td class="mono">U = ½ C V² = ½ QV = ½ Q² / C</td>
                                <td>Energy density u = ½ ε₀ E² (vacuum)</td>
                            </tr>
                            <tr>
                                <td>Series capacitors</td>
                                <td class="mono">1/C_eq = Σ (1/Cᵢ)</td>
                                <td>Same charge, voltages add</td>
                            </tr>
                            <tr>
                                <td>Parallel capacitors</td>
                                <td class="mono">C_eq = ΣCᵢ</td>
                                <td>Same voltage, charges add</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About this electrostatics tool</h2>
            <p>
                This page groups the main school/JEE/NEET electrostatics formulas in one place: force between point charges, electric field
                and potential, Gauss’s law shortcuts for symmetric distributions, and capacitor formulas including dielectrics and
                series/parallel combinations. Each calculator is paired with step-by-step reasoning so you can see which formula is used
                and how the numbers are substituted.
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
    <script src="<%=request.getContextPath()%>/physics/js/electrostatics.js?v=<%=cacheVersion%>"></script>
</body>
</html>

