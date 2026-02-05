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
        <jsp:param name="toolName" value="Bohr Model - Atomic Structure, Radius, Energy, Rydberg, Spectral Series" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Bohr model formulas: radius rₙ = 0.529 n² Å (H), velocity vₙ = 2.19×10⁶/n m/s, energy Eₙ = −13.6 Z²/n² eV, Rydberg 1/λ = R Z²(1/n₁²−1/n₂²), Lyman Balmer Paschen series. Free calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/bohr-model.jsp" />
        <jsp:param name="toolKeywords" value="Bohr model, atomic structure, hydrogen atom, Rydberg formula, Lyman series, Balmer series, Paschen series, energy levels, Bohr radius, spectral lines, JEE NEET" />
        <jsp:param name="toolImage" value="bohr-model.png" />
        <jsp:param name="toolFeatures" value="Radius of nth orbit,Velocity of electron,Energy of nth orbit,Transition ΔE and wavelength,Rydberg wavenumber,Angular momentum L,Step-by-step solutions,Hydrogen-like atoms Z" />
        <jsp:param name="faq1q" value="What is the Bohr radius?" />
        <jsp:param name="faq1a" value="For hydrogen (Z=1), radius of nth orbit rₙ = 0.529 n² Å. For hydrogen-like atoms rₙ ∝ n²/Z. The first Bohr radius (n=1) is about 0.529 Å = 5.29×10⁻¹¹ m." />
        <jsp:param name="faq2q" value="What is the energy of nth orbit in Bohr model?" />
        <jsp:param name="faq2a" value="Eₙ = −(13.6 Z²/n²) eV. For hydrogen (Z=1), Eₙ = −13.6/n² eV. Ground state (n=1) is −13.6 eV. Transition energy ΔE = 13.6 Z²(1/n₁² − 1/n₂²) eV (emission when n₂ &gt; n₁)." />
        <jsp:param name="faq3q" value="What is the Rydberg formula?" />
        <jsp:param name="faq3a" value="Wavenumber 1/λ = R Z²(1/n₁² − 1/n₂²), where R ≈ 1.097×10⁷ m⁻¹. Lyman series: n₁=1 (UV); Balmer: n₁=2 (visible); Paschen: n₁=3 (IR)." />
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
        :root { --bohr-green: #059669; --bohr-emerald: #10b981; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #059669 0%, #10b981 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(5,150,105,0.1), rgba(16,185,129,0.1)); border-left: 4px solid var(--bohr-green); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #059669, #10b981); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .bohr-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .bohr-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .bohr-tab:hover { border-color: var(--bohr-green); color: var(--bohr-green); }
        .bohr-tab.active { background: linear-gradient(135deg, #059669, #10b981); border-color: #10b981; color: white; }
        .bohr-panel { display: none; }
        .bohr-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--bohr-green); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #059669, #10b981); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(5,150,105,0.15), rgba(16,185,129,0.1)); border: 2px solid var(--bohr-green); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--bohr-green); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #059669, #10b981); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--bohr-green); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(5,150,105,0.1), rgba(16,185,129,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); }
        .bohr-viz-wrapper { padding: 1rem; }
        .bohr-viz-container { width: 100%; height: 280px; background: linear-gradient(180deg, #ecfdf5 0%, #d1fae5 100%); border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); position: relative; box-sizing: border-box; }
        .bohr-viz-container #bohr-viz-canvas { position: absolute; left: 0; top: 0; right: 0; bottom: 0; width: 100% !important; height: 100% !important; display: block; z-index: 1; }
        .bohr-viz-container #bohr-viz-placeholder { position: absolute; left: 0; top: 0; right: 0; bottom: 0; display: flex; align-items: center; justify-content: center; z-index: 2; color: var(--text-secondary); font-size: 0.9rem; text-align: center; padding: 1rem; box-sizing: border-box; }
        .bohr-viz-container .highlight { color: var(--bohr-green); font-weight: 700; }
        [data-theme="dark"] .bohr-viz-container, .dark-mode .bohr-viz-container { background: linear-gradient(180deg, #064e3b 0%, #065f46 100%); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #059669, #10b981); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--bohr-green); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--bohr-green); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #059669; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--bohr-green); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>⚛️</span> Bohr Model (Atomic Structure)</h1>
            <p class="tool-page-description">Radius, velocity, energy, Rydberg formula, Lyman / Balmer / Paschen series</p>
            <div class="tool-badges">
                <span class="tool-badge">rₙ = 0.529 n² Å</span>
                <span class="tool-badge">Eₙ = −13.6 Z²/n² eV</span>
                <span class="tool-badge">1/λ = R Z²(1/n₁²−1/n₂²)</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Bohr model</div>
            <p>In the Bohr model, the electron orbits the nucleus in quantized orbits. Radius rₙ = 0.529 n² Å (H); velocity vₙ = 2.19×10⁶/n m/s; energy Eₙ = −13.6 Z²/n² eV. Transitions: ΔE = 13.6 Z²(1/n₁² − 1/n₂²) eV. Rydberg: 1/λ = R Z²(1/n₁² − 1/n₂²). Angular momentum L = n ℏ. Series: Lyman (n₁=1), Balmer (n₁=2), Paschen (n₁=3).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Bohr model calculators</h2>
                    <p>Radius, velocity, energy, transition, Rydberg, angular momentum</p>
                </div>
                <div class="panel-body">
                    <div class="bohr-tabs">
                        <button type="button" class="bohr-tab active" data-tab="radius" onclick="if(window.switchBohrTab)window.switchBohrTab('radius',this);">Radius</button>
                        <button type="button" class="bohr-tab" data-tab="velocity" onclick="if(window.switchBohrTab)window.switchBohrTab('velocity',this);">Velocity</button>
                        <button type="button" class="bohr-tab" data-tab="energy" onclick="if(window.switchBohrTab)window.switchBohrTab('energy',this);">Energy</button>
                        <button type="button" class="bohr-tab" data-tab="transition" onclick="if(window.switchBohrTab)window.switchBohrTab('transition',this);">Transition</button>
                        <button type="button" class="bohr-tab" data-tab="rydberg" onclick="if(window.switchBohrTab)window.switchBohrTab('rydberg',this);">Rydberg</button>
                        <button type="button" class="bohr-tab" data-tab="angular" onclick="if(window.switchBohrTab)window.switchBohrTab('angular',this);">L = nℏ</button>
                    </div>

                    <div id="panel-radius" class="bohr-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Principal quantum number (n)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="radius-n" class="number-input" value="1" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">n = 1,2,3...</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Atomic number (Z)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="radius-z" class="number-input" value="1" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">H=1, He⁺=2</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runBohrModel()">Calculate rₙ</button>
                        <div class="result-card" id="result-radius">
                            <div class="result-label">Radius of nth orbit</div>
                            <div class="result-value" id="radius-result">0.529 Å</div>
                        </div>
                    </div>

                    <div id="panel-velocity" class="bohr-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Principal quantum number (n)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="velocity-n" class="number-input" value="1" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">n = 1,2,3...</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Atomic number (Z)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="velocity-z" class="number-input" value="1" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">Z</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runBohrModel()">Calculate vₙ</button>
                        <div class="result-card" id="result-velocity">
                            <div class="result-label">Velocity of electron</div>
                            <div class="result-value" id="velocity-result">2.19×10⁶ m/s</div>
                        </div>
                    </div>

                    <div id="panel-energy" class="bohr-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Principal quantum number (n)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-n" class="number-input" value="1" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">n</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Atomic number (Z)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-z" class="number-input" value="1" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">Z</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runBohrModel()">Calculate Eₙ</button>
                        <div class="result-card" id="result-energy">
                            <div class="result-label">Energy of nth orbit</div>
                            <div class="result-value" id="energy-result">−13.6 eV</div>
                        </div>
                    </div>

                    <div id="panel-transition" class="bohr-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Initial orbit (n₂, higher)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="trans-n2" class="number-input" value="3" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">n₂</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Final orbit (n₁, lower)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="trans-n1" class="number-input" value="2" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">n₁ (emission n₂→n₁)</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Atomic number (Z)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="trans-z" class="number-input" value="1" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">Z</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runBohrModel()">Calculate ΔE, λ, ν</button>
                        <div class="result-card" id="result-transition">
                            <div class="result-label">ΔE, wavelength, frequency</div>
                            <div class="result-value" id="trans-result">—</div>
                        </div>
                    </div>

                    <div id="panel-rydberg" class="bohr-panel">
                        <div class="input-section">
                            <div class="input-label"><span>n₁ (lower, final)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="ryd-n1" class="number-input" value="2" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">Lyman=1, Balmer=2, Paschen=3</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>n₂ (higher, initial)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="ryd-n2" class="number-input" value="4" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">n₂ &gt; n₁</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Atomic number (Z)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="ryd-z" class="number-input" value="1" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">Z</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runBohrModel()">Calculate 1/λ, λ</button>
                        <div class="result-card" id="result-rydberg">
                            <div class="result-label">Wavenumber &amp; wavelength</div>
                            <div class="result-value" id="ryd-result">—</div>
                        </div>
                    </div>

                    <div id="panel-angular" class="bohr-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Principal quantum number (n)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="angular-n" class="number-input" value="1" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">n = 1,2,3...</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runBohrModel()">Calculate L</button>
                        <div class="result-card" id="result-angular">
                            <div class="result-label">Angular momentum (L = n ℏ)</div>
                            <div class="result-value" id="angular-result">1.05×10⁻³⁴ J·s</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>⚛️ Bohr model summary</h3></div>
                    <div class="bohr-viz-wrapper">
                        <div class="bohr-viz-container" id="bohr-viz-container">
                            <canvas id="bohr-viz-canvas"></canvas>
                            <div id="bohr-viz-placeholder">Run a calculation to see result.</div>
                        </div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleBohrSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="bohr-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="bohr-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Bohr model formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Radius of nth orbit</td>
                                <td class="form-equation">rₙ = 0.529 n² Å (H), rₙ ∝ n²/Z</td>
                                <td class="form-desc">Hydrogen-like atoms</td>
                            </tr>
                            <tr>
                                <td class="form-name">Velocity of electron</td>
                                <td class="form-equation">vₙ = (2.19×10⁶ / n) m/s (H), vₙ ∝ Z/n</td>
                                <td class="form-desc">vₙ ∝ 1/n for fixed Z</td>
                            </tr>
                            <tr>
                                <td class="form-name">Angular momentum</td>
                                <td class="form-equation">L = n ℏ = n h / (2π)</td>
                                <td class="form-desc">n = 1,2,3,...</td>
                            </tr>
                            <tr>
                                <td class="form-name">Energy of nth orbit</td>
                                <td class="form-equation">Eₙ = −(13.6 Z² / n²) eV</td>
                                <td class="form-desc">Hydrogen (Z=1): −13.6/n² eV</td>
                            </tr>
                            <tr>
                                <td class="form-name">Energy difference (transition)</td>
                                <td class="form-equation">ΔE = 13.6 Z² (1/n₁² − 1/n₂²) eV</td>
                                <td class="form-desc">Emission when n₂ &gt; n₁</td>
                            </tr>
                            <tr>
                                <td class="form-name">Wavenumber (Rydberg)</td>
                                <td class="form-equation">1/λ = R Z² (1/n₁² − 1/n₂²)</td>
                                <td class="form-desc">R ≈ 1.097×10⁷ m⁻¹</td>
                            </tr>
                            <tr>
                                <td class="form-name">Frequency of photon</td>
                                <td class="form-equation">ν = c/λ = ΔE/h</td>
                                <td class="form-desc">—</td>
                            </tr>
                            <tr>
                                <td class="form-name">Series limits</td>
                                <td class="form-equation">Lyman (n₁=1), Balmer (n₁=2), Paschen (n₁=3)</td>
                                <td class="form-desc">UV, visible, IR</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About the Bohr model</h2>
            <p>In the Bohr model, the electron moves in circular orbits with quantized angular momentum <strong>L = n ℏ</strong>. For hydrogen-like atoms (nucleus charge Ze): radius <strong>rₙ = 0.529 n²/Z Å</strong>, velocity <strong>vₙ ∝ Z/n</strong>, and energy <strong>Eₙ = −(13.6 Z²/n²) eV</strong>. Transitions between orbits give spectral lines: <strong>ΔE = 13.6 Z²(1/n₁² − 1/n₂²) eV</strong> and <strong>1/λ = R Z²(1/n₁² − 1/n₂²)</strong> (Rydberg formula).</p>
            <h3>Spectral series</h3>
            <p><strong>Lyman</strong> (n₁=1, UV), <strong>Balmer</strong> (n₁=2, visible), <strong>Paschen</strong> (n₁=3, IR), Brackett (n₁=4), Pfund (n₁=5).</p>
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
    <script src="https://cdn.jsdelivr.net/npm/matter-js@0.19.0/build/matter.min.js" crossorigin="anonymous"></script>
    <script src="<%=request.getContextPath()%>/physics/js/bohr-model.js?v=<%=cacheVersion%>"></script>
</body>
</html>
