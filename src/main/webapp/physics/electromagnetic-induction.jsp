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
        <jsp:param name="toolName" value="Electromagnetic Induction & AC Circuits - Faraday’s Law, Motional EMF, L, M, X_L, X_C" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Electromagnetic induction and AC circuit formulas: Faraday’s law, motional emf, self and mutual inductance, LR/LC transients, and AC reactance (X_L, X_C). Free calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/electromagnetic-induction.jsp" />
        <jsp:param name="toolKeywords" value="electromagnetic induction calculator, Faraday law, motional emf, self inductance, mutual inductance, LR circuit, LC circuit, AC reactance, X_L, X_C, JEE NEET EM induction" />
        <jsp:param name="toolImage" value="electromagnetic-induction.png" />
        <jsp:param name="toolFeatures" value="Faraday’s law calculator,Motional emf calculators,Self and mutual inductance,AC reactance (X_L, X_C),LR and LC transients,Step-by-step derivations,Reference tables" />
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
            --emi-indigo: #4f46e5;
            --emi-pink: #ec4899;
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
            background: linear-gradient(135deg, #4f46e5 0%, #ec4899 100%);
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
            color: var(--emi-indigo);
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 1rem;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .info-box {
            background: linear-gradient(135deg, rgba(79,70,229,0.1), rgba(236,72,153,0.1));
            border-left: 4px solid var(--emi-indigo);
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
            background: linear-gradient(135deg, #4f46e5, #ec4899);
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

        .emi-tabs {
            display: flex;
            gap: 0.25rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .emi-tab {
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

        .emi-tab:hover {
            border-color: var(--emi-indigo);
            color: var(--emi-indigo);
        }

        .emi-tab.active {
            background: linear-gradient(135deg, #4f46e5, #ec4899);
            border-color: #ec4899;
            color: white;
        }

        .emi-panel {
            display: none;
        }

        .emi-panel.active {
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
            border-color: var(--emi-indigo);
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
            background: linear-gradient(135deg, #4f46e5, #ec4899);
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
            background: linear-gradient(135deg, rgba(79,70,229,0.12), rgba(236,72,153,0.08));
            border: 2px solid var(--emi-indigo);
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
            color: var(--emi-indigo);
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
            background: linear-gradient(135deg, rgba(79,70,229,0.12), rgba(236,72,153,0.12));
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
            background: linear-gradient(135deg, #4f46e5, #ec4899);
            color: white;
            font-weight: 700;
        }

        .ref-table .mono {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            color: var(--emi-indigo);
        }

        .emi-sim-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-light);
            margin: 1.25rem 0;
            overflow: hidden;
        }

        .emi-sim-header {
            background: linear-gradient(135deg, rgba(79,70,229,0.1), rgba(236,72,153,0.08));
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border-light);
        }

        .emi-sim-header h3 {
            margin: 0;
            font-size: 1rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .emi-chart-wrap {
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
            background: linear-gradient(135deg, #4f46e5, #ec4899);
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
            border-left: 4px solid var(--emi-indigo);
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
            background: var(--emi-indigo);
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
            color: #4f46e5;
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
            <h1 class="tool-page-title"><span>🔄</span> Electromagnetic Induction &amp; AC Circuits</h1>
            <p class="tool-page-description">Faraday’s law, motional emf, inductance, AC reactance, LR/LC transients</p>
            <div class="tool-badges">
                <span class="tool-badge">ε = − dΦ/dt</span>
                <span class="tool-badge">ε = Bℓv</span>
                <span class="tool-badge">ε = −L dI/dt</span>
                <span class="tool-badge">ω = 1/√(LC)</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title">
                <span>💡</span>
                <span>Induction and AC at a glance</span>
            </div>
            <p>
                Changing magnetic flux <strong>Φ_B</strong> through a circuit induces emf according to <strong>Faraday’s law ε = −dΦ_B/dt</strong>; the minus sign
                (Lenz’s law) ensures the induced current opposes the change. Motional emf <strong>ε = Bℓv</strong> arises when a conductor moves in a field.
                Self-inductance <strong>L</strong> and mutual inductance <strong>M</strong> relate flux and current (ε = −L dI/dt, ε₂ = −M dI₁/dt). In AC, inductors and
                capacitors introduce reactances <strong>X_L = ωL</strong> and <strong>X_C = 1/(ωC)</strong>, while LR/LC circuits have characteristic time and
                frequency scales <strong>τ_L = L/R</strong> and <strong>ω = 1/√(LC)</strong>.
            </p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Induction &amp; AC calculators</h2>
                    <p>Faraday/flux, motional emf, inductance, AC reactance, LR/LC</p>
                </div>
                <div class="panel-body">
                    <div class="emi-tabs">
                        <button type="button" class="emi-tab active" data-tab="faraday">Faraday’s law &amp; flux</button>
                        <button type="button" class="emi-tab" data-tab="motional">Motional emf</button>
                        <button type="button" class="emi-tab" data-tab="self">Self-inductance (L)</button>
                        <button type="button" class="emi-tab" data-tab="mutual">Mutual inductance (M)</button>
                        <button type="button" class="emi-tab" data-tab="ac">AC reactance</button>
                        <button type="button" class="emi-tab" data-tab="transients">LR &amp; LC transients</button>
                    </div>

                    <div id="panel-faraday" class="emi-panel active">
                        <div class="input-section">
                            <div class="input-label">Flux through N‑turn loop (Φ_B = B A cos θ)</div>
                            <div class="input-row">
                                <input type="number" id="emi-B" class="number-input" value="0.5" step="any" placeholder="B (T)">
                                <input type="number" id="emi-A" class="number-input" value="0.01" step="any" placeholder="A (m²)">
                                <input type="number" id="emi-theta" class="number-input" value="0" step="any" placeholder="θ (deg)">
                                <input type="number" id="emi-N" class="number-input" value="10" step="1" placeholder="N (turns)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Change over time (ΔB or Δθ) for induced emf</div>
                            <div class="input-row">
                                <input type="number" id="emi-dPhi" class="number-input" value="0.001" step="any" placeholder="ΔΦ (Wb)">
                                <input type="number" id="emi-dt" class="number-input" value="0.1" step="any" placeholder="Δt (s)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMI()">Calculate Φ and ε</button>
                        <div class="result-card">
                            <div class="result-value" id="emi-faraday-result">Φ_B = —, Φ_total = —, ε = —</div>
                            <div>Uses Φ_B = B A cos θ, Φ_total = N Φ_B, and ε = −N ΔΦ/Δt.</div>
                        </div>
                    </div>

                    <div id="panel-motional" class="emi-panel">
                        <div class="input-section">
                            <div class="input-label">Sliding rod: ε = B ℓ v, I = ε / R</div>
                            <div class="input-row">
                                <input type="number" id="mot-B" class="number-input" value="0.5" step="any" placeholder="B (T)">
                                <input type="number" id="mot-l" class="number-input" value="0.2" step="any" placeholder="ℓ (m)">
                                <input type="number" id="mot-v" class="number-input" value="2" step="any" placeholder="v (m/s)">
                                <input type="number" id="mot-R" class="number-input" value="5" step="any" placeholder="R (Ω)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Rotating rod / disk: ε = ½ B ω L² or ½ B ω R²</div>
                            <div class="input-row">
                                <input type="number" id="mot-Brot" class="number-input" value="0.5" step="any" placeholder="B (T)">
                                <input type="number" id="mot-L" class="number-input" value="0.3" step="any" placeholder="L or R (m)">
                                <input type="number" id="mot-omega" class="number-input" value="10" step="any" placeholder="ω (rad/s)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMI()">Calculate motional emf</button>
                        <div class="result-card">
                            <div class="result-value" id="emi-motional-result">ε_rod = —, I = —, ε_rot = —</div>
                            <div>Sliding rod: ε = Bℓv, I = ε/R. Rotating rod/disk: ε = ½ B ω L² or ½ B ω R².</div>
                        </div>
                    </div>

                    <div id="panel-self" class="emi-panel">
                        <div class="input-section">
                            <div class="input-label">Self‑inductance and emf (ε = −L dI/dt)</div>
                            <div class="input-row">
                                <input type="number" id="self-L" class="number-input" value="0.5" step="any" placeholder="L (H)">
                                <input type="number" id="self-I" class="number-input" value="2" step="any" placeholder="I (A)">
                                <input type="number" id="self-dI" class="number-input" value="5" step="any" placeholder="dI/dt (A/s)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Solenoid: L = μ₀ n² A l</div>
                            <div class="input-row">
                                <input type="number" id="self-mu0" class="number-input" value="1.2566e-6" step="any" placeholder="μ₀ (H/m)">
                                <input type="number" id="self-n" class="number-input" value="1000" step="any" placeholder="n (turns/m)">
                                <input type="number" id="self-A" class="number-input" value="1e-4" step="any" placeholder="A (m²)">
                                <input type="number" id="self-l" class="number-input" value="0.2" step="any" placeholder="l (m)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMI()">Calculate L, ε, U</button>
                        <div class="result-card">
                            <div class="result-value" id="emi-self-result">ε = —, U = —, L_solenoid = —</div>
                            <div>Generic: ε = −L dI/dt, U = ½ L I². Solenoid: L = μ₀ n² A l.</div>
                        </div>
                    </div>

                    <div id="panel-mutual" class="emi-panel">
                        <div class="input-section">
                            <div class="input-label">Mutual inductance: M = k√(L₁L₂), ε₂ = −M dI₁/dt</div>
                            <div class="input-row">
                                <input type="number" id="mut-L1" class="number-input" value="0.5" step="any" placeholder="L₁ (H)">
                                <input type="number" id="mut-L2" class="number-input" value="0.2" step="any" placeholder="L₂ (H)">
                                <input type="number" id="mut-k" class="number-input" value="0.8" step="any" placeholder="k (0–1)">
                                <input type="number" id="mut-dI" class="number-input" value="5" step="any" placeholder="dI₁/dt (A/s)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMI()">Calculate M and ε₂</button>
                        <div class="result-card">
                            <div class="result-value" id="emi-mutual-result">M = —, ε₂ = —</div>
                            <div>For two coupled coils: M = k√(L₁L₂), ε₂ = −M dI₁/dt.</div>
                        </div>
                    </div>

                    <div id="panel-ac" class="emi-panel">
                        <div class="input-section">
                            <div class="input-label">AC reactance and impedance (R–L–C)</div>
                            <div class="input-row">
                                <input type="number" id="ac-f" class="number-input" value="50" step="any" placeholder="f (Hz)">
                                <input type="number" id="ac-R" class="number-input" value="10" step="any" placeholder="R (Ω)">
                                <input type="number" id="ac-L" class="number-input" value="0.1" step="any" placeholder="L (H)">
                                <input type="number" id="ac-C" class="number-input" value="1e-6" step="any" placeholder="C (F)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMI()">Calculate X_L, X_C, |Z|</button>
                        <div class="result-card">
                            <div class="result-value" id="emi-ac-result">X_L = —, X_C = —, |Z_RLC| = —</div>
                            <div>Uses X_L = 2πfL, X_C = 1/(2πfC), and |Z_RLC| = √(R² + (X_L − X_C)²).</div>
                        </div>
                    </div>

                    <div id="panel-transients" class="emi-panel">
                        <div class="input-section">
                            <div class="input-label">LR circuit: ε, L, R, t</div>
                            <div class="input-row">
                                <input type="number" id="lr-eps" class="number-input" value="10" step="any" placeholder="ε (V)">
                                <input type="number" id="lr-L" class="number-input" value="0.5" step="any" placeholder="L (H)">
                                <input type="number" id="lr-R" class="number-input" value="10" step="any" placeholder="R (Ω)">
                                <input type="number" id="lr-t" class="number-input" value="0.1" step="any" placeholder="t (s)">
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">LC circuit: L, C</div>
                            <div class="input-row">
                                <input type="number" id="lc-L" class="number-input" value="0.5" step="any" placeholder="L (H)">
                                <input type="number" id="lc-C" class="number-input" value="1e-6" step="any" placeholder="C (F)">
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEMI()">Analyze LR &amp; LC</button>
                        <div class="result-card">
                            <div class="result-value" id="emi-transient-result">I_LR = —, τ_L = —, ω_LC = —, T_LC = —</div>
                            <div>LR: τ_L = L/R, I(t) = (ε/R)(1 − e^{−t/τ}). LC: ω = 1/√(LC), T = 2π√(LC).</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="emi-sim-panel" id="emi-sim-panel">
                    <div class="emi-sim-header"><h3>📈 EMI &amp; AC graph</h3></div>
                    <div class="emi-chart-wrap">
                        <canvas id="emi-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleEMISteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="emi-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="emi-steps-body"></div>
                </div>

                <div class="ref-card" style="margin-bottom:1.25rem;">
                    <h3>Faraday’s law, flux &amp; motional emf</h3>
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
                                <td>Magnetic flux</td>
                                <td class="mono">Φ_B = B A cos θ</td>
                                <td>Wb (weber), θ angle between B and normal</td>
                            </tr>
                            <tr>
                                <td>Faraday’s law</td>
                                <td class="mono">ε = − dΦ_B/dt,  ε = −N dΦ_B/dt</td>
                                <td>Induced emf; minus sign = Lenz’s law</td>
                            </tr>
                            <tr>
                                <td>Motional emf (rod)</td>
                                <td class="mono">ε = B ℓ v</td>
                                <td>v ⊥ B, ℓ length in field</td>
                            </tr>
                            <tr>
                                <td>Rotating rod/disk</td>
                                <td class="mono">ε = ½ B ω L²  (rod),  ε = ½ B ω R² (disk)</td>
                                <td>Between center and rim</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="ref-card">
                    <h3>Inductance, AC reactance, LR &amp; LC</h3>
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
                                <td>Self-inductance</td>
                                <td class="mono">L = Φ/I,  ε = −L dI/dt</td>
                                <td>U = ½ L I²</td>
                            </tr>
                            <tr>
                                <td>Solenoid inductance</td>
                                <td class="mono">L = μ₀ n² A l</td>
                                <td>n = turns per unit length</td>
                            </tr>
                            <tr>
                                <td>Mutual inductance</td>
                                <td class="mono">M = Φ₂₁/I₁,  ε₂ = −M dI₁/dt,  M = k√(L₁L₂)</td>
                                <td>0 ≤ k ≤ 1 (coupling)</td>
                            </tr>
                            <tr>
                                <td>AC reactance</td>
                                <td class="mono">X_L = 2πfL,  X_C = 1/(2πfC)</td>
                                <td>Inductive: V leads I; capacitive: I leads V</td>
                            </tr>
                            <tr>
                                <td>RLC impedance</td>
                                <td class="mono">|Z| = √(R² + (X_L − X_C)²)</td>
                                <td>Series RLC</td>
                            </tr>
                            <tr>
                                <td>LR time constant</td>
                                <td class="mono">τ_L = L / R</td>
                                <td>I(t) growth: I = (ε/R)(1 − e^{−t/τ_L})</td>
                            </tr>
                            <tr>
                                <td>LC oscillator</td>
                                <td class="mono">ω = 1/√(LC),  T = 2π√(LC)</td>
                                <td>Energy oscillates between L and C</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About this induction &amp; AC tool</h2>
            <p>
                This page brings together the core electromagnetic induction formulas needed for school physics, JEE, and NEET: Faraday’s
                law and flux, motional emf for rods and rotating systems, self and mutual inductance, AC reactance for R–L–C elements,
                and LR/LC transients. Each calculator is paired with a step-by-step derivation so you can connect the equations to the
                physical picture.
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
    <script src="<%=request.getContextPath()%>/physics/js/electromagnetic-induction.js?v=<%=cacheVersion%>"></script>
</body>
</html>

