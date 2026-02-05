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
        <jsp:param name="toolName" value="Electromagnetic Waves - Speed, Intensity & Spectrum" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Electromagnetic wave calculators for speed, field relations, intensity, energy density, spectrum band classification, displacement current and radiation pressure with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/electromagnetic-waves.jsp" />
        <jsp:param name="toolKeywords" value="electromagnetic waves, EM wave speed, intensity, Poynting vector, radiation pressure, displacement current, EM spectrum, JEE, NEET" />
        <jsp:param name="toolImage" value="electromagnetic-waves.png" />
        <jsp:param name="toolFeatures" value="Speed in vacuum & media,Field relations E, B, c,Intensity & energy density,EM spectrum bands,Displacement current & Ampere-Maxwell law,Radiation pressure & force,Step-by-step explanations" />
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
            --emw-blue: #0ea5e9;
            --emw-violet: #7c3aed;
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
            color: var(--emw-blue);
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 1rem;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .info-box {
            background: linear-gradient(135deg, rgba(14,165,233,0.1), rgba(124,58,237,0.1));
            border-left: 4px solid var(--emw-blue);
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

        .emw-tabs {
            display: flex;
            gap: 0.25rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .emw-tab {
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

        .emw-tab:hover {
            border-color: var(--emw-blue);
            color: var(--emw-blue);
        }

        .emw-tab.active {
            background: linear-gradient(135deg, #0ea5e9, #7c3aed);
            border-color: #7c3aed;
            color: white;
        }

        .emw-panel {
            display: none;
        }

        .emw-panel.active {
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
            border-color: var(--emw-blue);
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
            border: 2px solid var(--emw-blue);
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
            color: var(--emw-blue);
        }

        .emw-sim-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-light);
            margin: 1.25rem 0;
            overflow: hidden;
        }

        .emw-sim-header {
            background: linear-gradient(135deg, rgba(14,165,233,0.1), rgba(124,58,237,0.08));
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border-light);
        }

        .emw-sim-header h3 {
            margin: 0;
            font-size: 1rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .emw-chart-wrap {
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
            color: var(--emw-blue);
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
            border-left: 4px solid var(--emw-blue);
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
            background: var(--emw-blue);
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
            <h1 class="tool-page-title"><span>📡</span> Electromagnetic Waves</h1>
            <p class="tool-page-description">Speed of light, field relations, intensity, spectrum bands, displacement current and radiation pressure</p>
            <div class="tool-badges">
                <span class="tool-badge">c = 1/√(μ₀ ε₀)</span>
                <span class="tool-badge">S = (1/μ₀)(E × B)</span>
                <span class="tool-badge">I = E₀² / (2 μ₀ c)</span>
                <span class="tool-badge">P = I / c (absorber)</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title">
                <span>💡</span>
                <span>EM waves: light as an electromagnetic wave</span>
            </div>
            <p>
                Electromagnetic waves are transverse waves where electric field <strong>E</strong> and magnetic field <strong>B</strong> oscillate
                perpendicular to each other and to the direction of propagation. In vacuum, the wave speed is the speed of light
                <strong>c ≈ 3.00 × 10⁸ m/s</strong>, related to permittivity and permeability by <strong>c = 1/√(μ₀ ε₀)</strong>.
                The Poynting vector <strong>S = (1/μ₀)(E × B)</strong> describes energy flow, with average intensity
                <strong>I = E₀² / (2 μ₀ c) = c B₀² / (2 μ₀)</strong>. The full electromagnetic spectrum ranges from radio waves to gamma rays.
            </p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>EM wave calculators</h2>
                    <p>Speed, intensity, energy density, spectrum, displacement current and radiation pressure</p>
                </div>
                <div class="panel-body">
                    <div class="emw-tabs">
                        <button type="button" class="emw-tab active" data-tab="basics">Basics: c, v, E-B</button>
                        <button type="button" class="emw-tab" data-tab="intensity">Intensity &amp; energy density</button>
                        <button type="button" class="emw-tab" data-tab="spectrum">EM spectrum band</button>
                        <button type="button" class="emw-tab" data-tab="displacement">Displacement current</button>
                        <button type="button" class="emw-tab" data-tab="radiation">Radiation pressure</button>
                    </div>

                    <div id="panel-basics" class="emw-panel active">
                        <div class="input-section">
                            <div class="input-label">Speed in medium (μ, ε)</div>
                            <div class="input-row">
                                <input type="number" id="emw-mu" class="number-input" value="1.25663706212e-6" step="any" placeholder="μ (H/m)">
                                <input type="number" id="emw-eps" class="number-input" value="8.854187817e-12" step="any" placeholder="ε (F/m)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Field amplitudes</div>
                            <div class="input-row">
                                <input type="number" id="emw-E0" class="number-input" value="100" step="any" placeholder="E₀ (V/m)">
                                <input type="number" id="emw-B0" class="number-input" value="3.33e-7" step="any" placeholder="B₀ (T)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMW()">Calculate c, v &amp; E-B</button>
                        <div class="result-card">
                            <div class="result-value" id="emw-basics-result">c = —, v = —, E₀/B₀ = —</div>
                            <div>Uses c = 1/√(μ₀ ε₀), v = 1/√(μ ε), and E₀ = c B₀ in vacuum.</div>
                        </div>
                    </div>

                    <div id="panel-intensity" class="emw-panel">
                        <div class="input-section">
                            <div class="input-label">Field amplitude (choose E₀ or B₀)</div>
                            <div class="input-row">
                                <input type="number" id="int-E0" class="number-input" value="100" step="any" placeholder="E₀ (V/m)">
                                <input type="number" id="int-B0" class="number-input" value="" step="any" placeholder="B₀ (T, optional)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMW()">Calculate intensity &amp; u</button>
                        <div class="result-card">
                            <div class="result-value" id="emw-intensity-result">I = —, u_avg = —</div>
                            <div>Uses I = E₀²/(2 μ₀ c) = c B₀²/(2 μ₀) and u_avg = ε₀ E₀²/2 = B₀²/(2 μ₀) in vacuum.</div>
                        </div>
                    </div>

                    <div id="panel-spectrum" class="emw-panel">
                        <div class="input-section">
                            <div class="input-label">Wavelength or frequency</div>
                            <div class="input-row">
                                <input type="number" id="spec-lambda" class="number-input" value="550e-9" step="any" placeholder="λ (m)">
                                <input type="number" id="spec-f" class="number-input" value="" step="any" placeholder="f (Hz, optional)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMW()">Identify EM band</button>
                        <div class="result-card">
                            <div class="result-value" id="emw-spectrum-result">Band = —, f ≈ —</div>
                            <div>Classifies into radio, microwave, IR, visible, UV, X-ray or gamma from λ or f.</div>
                        </div>
                    </div>

                    <div id="panel-displacement" class="emw-panel">
                        <div class="input-section">
                            <div class="input-label">Displacement current density</div>
                            <div class="input-row">
                                <input type="number" id="disp-dEdt" class="number-input" value="1e6" step="any" placeholder="∂E/∂t (V/m·s)">
                                <input type="number" id="disp-area" class="number-input" value="0.01" step="any" placeholder="Area (m²)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMW()">Calculate J_d &amp; I_d</button>
                        <div class="result-card">
                            <div class="result-value" id="emw-displacement-result">J_d = —, I_d = —</div>
                            <div>Uses J_d = ε₀ ∂E/∂t and I_d = J_d × area = ε₀ (dΦ_E/dt).</div>
                        </div>
                    </div>

                    <div id="panel-radiation" class="emw-panel">
                        <div class="input-section">
                            <div class="input-label">Intensity, area and reflection</div>
                            <div class="input-row">
                                <input type="number" id="rad-I" class="number-input" value="1000" step="any" placeholder="I (W/m²)">
                                <input type="number" id="rad-area" class="number-input" value="0.01" step="any" placeholder="Area (m²)">
                                <select id="rad-type" class="unit-select">
                                    <option value="absorb">Perfect absorber</option>
                                    <option value="reflect">Perfect reflector</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMW()">Calculate pressure &amp; force</button>
                        <div class="result-card">
                            <div class="result-value" id="emw-radiation-result">P = —, F = —</div>
                            <div>Uses P = I/c (absorber), P = 2I/c (reflector), and F = P × area.</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="emw-sim-panel" id="emw-sim-panel">
                    <div class="emw-sim-header"><h3>📈 EM wave visualization</h3></div>
                    <div class="emw-chart-wrap">
                        <canvas id="emw-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleEMWSteps()">
                        <span>🧮</span>
                        <span>Step-by-Step Solution</span>
                        <span class="steps-toggle" id="emw-steps-toggle">▼ Show</span>
                    </div>
                    <div class="steps-body collapsed" id="emw-steps-body"></div>
                </div>

                <div class="ref-card" style="margin-bottom:1.25rem;">
                    <h3>Basic properties of electromagnetic waves</h3>
                    <table class="ref-table">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula / Value</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Speed in vacuum</td>
                                <td class="mono">c = 3.00 × 10⁸ m/s</td>
                                <td>Exact: c = 299 792 458 m/s</td>
                            </tr>
                            <tr>
                                <td>Speed in medium</td>
                                <td class="mono">v = 1/√(μ ε)</td>
                                <td>c = 1/√(μ₀ ε₀) in vacuum</td>
                            </tr>
                            <tr>
                                <td>Relation between E and B</td>
                                <td class="mono">E = c B (vacuum)</td>
                                <td>E ⟂ B ⟂ direction</td>
                            </tr>
                            <tr>
                                <td>Plane EM wave</td>
                                <td class="mono">E = E₀ sin(kx − ωt + φ)</td>
                                <td>k = 2π/λ, ω = 2πf</td>
                            </tr>
                            <tr>
                                <td>Poynting vector</td>
                                <td class="mono">S = (1/μ₀)(E × B)</td>
                                <td>Direction of energy flow</td>
                            </tr>
                            <tr>
                                <td>Average intensity</td>
                                <td class="mono">I = E₀²/(2 μ₀ c) = c B₀²/(2 μ₀)</td>
                                <td>W/m²</td>
                            </tr>
                            <tr>
                                <td>Average energy density</td>
                                <td class="mono">u_avg = ε₀ E₀²/2 = B₀²/(2 μ₀)</td>
                                <td>Electric and magnetic parts equal</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="ref-card">
                    <h3>EM spectrum and Maxwell’s correction</h3>
                    <table class="ref-table">
                        <thead>
                            <tr>
                                <th>Type / Concept</th>
                                <th>Range / Formula</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Radio waves</td>
                                <td class="mono">λ &gt; 1 m, f &lt; 300 MHz</td>
                                <td>Communication (radio, TV, mobile)</td>
                            </tr>
                            <tr>
                                <td>Microwaves</td>
                                <td class="mono">1 mm – 1 m</td>
                                <td>Radar, ovens, satellites</td>
                            </tr>
                            <tr>
                                <td>Infrared (IR)</td>
                                <td class="mono">700 nm – 1 mm</td>
                                <td>Remote control, thermal imaging</td>
                            </tr>
                            <tr>
                                <td>Visible light</td>
                                <td class="mono">400 – 700 nm</td>
                                <td>Human vision</td>
                            </tr>
                            <tr>
                                <td>Ultraviolet (UV)</td>
                                <td class="mono">10 – 400 nm</td>
                                <td>Sterilization, tanning</td>
                            </tr>
                            <tr>
                                <td>X-rays</td>
                                <td class="mono">0.01 – 10 nm</td>
                                <td>Medical imaging</td>
                            </tr>
                            <tr>
                                <td>Gamma rays</td>
                                <td class="mono">λ &lt; 0.01 nm</td>
                                <td>Nuclear and cosmic sources</td>
                            </tr>
                            <tr>
                                <td>Displacement current density</td>
                                <td class="mono">J_d = ε₀ ∂E/∂t</td>
                                <td>Added by Maxwell</td>
                            </tr>
                            <tr>
                                <td>Ampere–Maxwell law</td>
                                <td class="mono">∮ B·dl = μ₀ (I + I_d)</td>
                                <td>I_d = ε₀ dΦ_E/dt</td>
                            </tr>
                            <tr>
                                <td>Radiation pressure</td>
                                <td class="mono">P = I/c (absorb), 2I/c (reflect)</td>
                                <td>Force/area due to light</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About this electromagnetic waves tool</h2>
            <p>
                This page brings together the most important formulas for electromagnetic waves: speed in vacuum and media, relations between
                electric and magnetic fields, intensity and energy density, classification of the EM spectrum, Maxwell’s displacement current
                and radiation pressure. Use the calculators and step-by-step breakdowns to quickly solve textbook-style problems and build
                intuition for how E, B, c, I and u are connected.
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
    <script src="<%=request.getContextPath()%>/physics/js/electromagnetic-waves.js?v=<%=cacheVersion%>"></script>
</body>
</html>

