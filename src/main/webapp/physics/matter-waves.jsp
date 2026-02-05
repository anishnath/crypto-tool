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
        <jsp:param name="toolName" value="Matter Waves - de Broglie Wavelength, Phase & Group Velocity, Relativistic" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Dual nature and matter waves: de Broglie wavelength λ = h/p = h/(mv), accelerated electron λ = h/√(2meV), λ(Å) ≈ 12.27/√V, relativistic λ, phase velocity v_phase = c²/v, group velocity v_group = v. Free calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/matter-waves.jsp" />
        <jsp:param name="toolKeywords" value="de Broglie wavelength, matter waves, dual nature, phase velocity, group velocity, relativistic de Broglie, electron wavelength, λ h p, physics modern, JEE NEET" />
        <jsp:param name="toolImage" value="matter-waves.png" />
        <jsp:param name="toolFeatures" value="de Broglie λ from momentum,de Broglie λ from m and v,Accelerated electron λ from V,Relativistic de Broglie λ,Phase velocity calculator,Group velocity calculator,Step-by-step solutions,SI and Å units" />
        <jsp:param name="faq1q" value="What is de Broglie wavelength?" />
        <jsp:param name="faq1a" value="de Broglie wavelength λ = h/p = h/(mv), where h is Planck's constant, p is momentum, m is mass, and v is speed. It associates a wavelength with every particle, showing wave-particle duality." />
        <jsp:param name="faq2q" value="What is the formula for electron accelerated by voltage V?" />
        <jsp:param name="faq2a" value="For an electron accelerated through potential V: λ = h/√(2 m e V). In Ångströms with V in volts: λ (Å) ≈ 12.27/√V. This is used in electron microscopes and diffraction." />
        <jsp:param name="faq3q" value="What is phase velocity vs group velocity for matter waves?" />
        <jsp:param name="faq3a" value="For de Broglie waves: phase velocity v_phase = c²/v (always &gt; c); group velocity v_group = v (the particle velocity). The group velocity carries the signal and equals the classical particle speed." />
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
        :root { --wave-amber: #d97706; --wave-orange: #ea580c; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #d97706 0%, #ea580c 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(217,119,6,0.1), rgba(234,88,12,0.1)); border-left: 4px solid var(--wave-amber); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #d97706, #ea580c); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .mw-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .mw-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .mw-tab:hover { border-color: var(--wave-amber); color: var(--wave-amber); }
        .mw-tab.active { background: linear-gradient(135deg, #d97706, #ea580c); border-color: #ea580c; color: white; }
        .mw-panel { display: none; }
        .mw-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--wave-amber); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #d97706, #ea580c); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(217,119,6,0.15), rgba(234,88,12,0.1)); border: 2px solid var(--wave-amber); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--wave-amber); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #d97706, #ea580c); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--wave-amber); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(217,119,6,0.1), rgba(234,88,12,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); }
        .mw-viz-container { width: 100%; height: 200px; background: linear-gradient(180deg, #fffbeb 0%, #fef3c7 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); display: flex; align-items: center; justify-content: center; }
        .mw-viz-container .highlight { color: var(--wave-amber); font-weight: 700; }
        [data-theme="dark"] .mw-viz-container, .dark-mode .mw-viz-container { background: linear-gradient(180deg, #78350f 0%, #92400e 100%); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #d97706, #ea580c); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--wave-amber); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--wave-amber); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #d97706; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--wave-amber); font-weight: 700; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--wave-amber); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>〰️</span> Matter Waves (de Broglie)</h1>
            <p class="tool-page-description">Dual nature, λ = h/p, accelerated electron, relativistic, phase &amp; group velocity</p>
            <div class="tool-badges">
                <span class="tool-badge">λ = h/p</span>
                <span class="tool-badge">λ ≈ 12.27/√V</span>
                <span class="tool-badge">v_phase = c²/v</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Dual nature &amp; matter waves</div>
            <p>de Broglie proposed that every particle has a wavelength λ = h/p = h/(mv). For an electron accelerated through potential V: λ = h/√(2meV); in Å with V in volts, λ ≈ 12.27/√V. Phase velocity of the matter wave is v_phase = c²/v (always &gt; c); group velocity v_group = v (particle speed).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Matter wave calculators</h2>
                    <p>λ from p or mv, accelerated electron, relativistic, phase &amp; group velocity</p>
                </div>
                <div class="panel-body">
                    <div class="mw-tabs">
                        <button type="button" class="mw-tab active" data-tab="lambda" onclick="if(window.switchMatterWaveTab)window.switchMatterWaveTab('lambda',this);">λ = h/p</button>
                        <button type="button" class="mw-tab" data-tab="accelerated" onclick="if(window.switchMatterWaveTab)window.switchMatterWaveTab('accelerated',this);">Accel. electron</button>
                        <button type="button" class="mw-tab" data-tab="relativistic" onclick="if(window.switchMatterWaveTab)window.switchMatterWaveTab('relativistic',this);">Relativistic λ</button>
                        <button type="button" class="mw-tab" data-tab="phase" onclick="if(window.switchMatterWaveTab)window.switchMatterWaveTab('phase',this);">Phase v</button>
                        <button type="button" class="mw-tab" data-tab="group" onclick="if(window.switchMatterWaveTab)window.switchMatterWaveTab('group',this);">Group v</button>
                    </div>

                    <div id="panel-lambda" class="mw-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Input</span></div>
                            <select id="lambda-input" class="number-input" style="border-radius: 10px;">
                                <option value="p">Momentum (p)</option>
                                <option value="mv">Mass (m) and speed (v)</option>
                            </select>
                        </div>
                        <div class="input-section" id="lambda-p-section">
                            <div class="input-label"><span>Momentum (p)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="lambda-p" class="number-input" value="1e-23" min="0" step="any">
                                <select id="lambda-p-unit" class="unit-select">
                                    <option value="kg·m/s">kg·m/s</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="lambda-mv-section" style="display: none;">
                            <div class="input-label"><span>Mass (m)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="lambda-m" class="number-input" value="9.11e-31" min="0" step="any">
                                <select id="lambda-m-unit" class="unit-select">
                                    <option value="kg">kg</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="lambda-v-section" style="display: none;">
                            <div class="input-label"><span>Speed (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="lambda-v" class="number-input" value="1e6" min="0" step="any">
                                <select id="lambda-v-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMatterWaves()">Calculate λ</button>
                        <div class="result-card" id="result-lambda">
                            <div class="result-label">de Broglie wavelength</div>
                            <div class="result-value" id="lambda-result">6.63 Å</div>
                        </div>
                    </div>

                    <div id="panel-accelerated" class="mw-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Accelerating voltage (V)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="accel-v" class="number-input" value="100" min="0" step="any">
                                <select id="accel-v-unit" class="unit-select">
                                    <option value="V">V</option>
                                    <option value="kV">kV</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMatterWaves()">Calculate λ</button>
                        <div class="result-card" id="result-accelerated">
                            <div class="result-label">Wavelength (electron)</div>
                            <div class="result-value" id="accel-result">1.23 Å</div>
                        </div>
                    </div>

                    <div id="panel-relativistic" class="mw-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Input</span></div>
                            <select id="rel-input" class="number-input" style="border-radius: 10px;">
                                <option value="v">Speed (v)</option>
                                <option value="gamma">Lorentz factor (γ)</option>
                            </select>
                        </div>
                        <div class="input-section" id="rel-v-section">
                            <div class="input-label"><span>Speed (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="rel-v" class="number-input" value="2e8" min="0" step="any">
                                <select id="rel-v-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                    <option value="c">c (fraction of c)</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="rel-gamma-section" style="display: none;">
                            <div class="input-label"><span>Lorentz factor (γ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="rel-gamma" class="number-input" value="1.5" min="1" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">γ ≥ 1</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Rest mass (m₀)</span></div>
                            <select id="rel-mass" class="number-input" style="border-radius: 10px;">
                                <option value="electron">Electron</option>
                                <option value="proton">Proton</option>
                            </select>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMatterWaves()">Calculate λ</button>
                        <div class="result-card" id="result-relativistic">
                            <div class="result-label">Relativistic de Broglie λ</div>
                            <div class="result-value" id="rel-result">—</div>
                        </div>
                    </div>

                    <div id="panel-phase" class="mw-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Particle speed (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="phase-v" class="number-input" value="1e6" min="0" step="any">
                                <select id="phase-v-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                    <option value="c">c (fraction)</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMatterWaves()">Calculate</button>
                        <div class="result-card" id="result-phase">
                            <div class="result-label">Phase velocity (v_phase = c²/v)</div>
                            <div class="result-value" id="phase-result">—</div>
                        </div>
                    </div>

                    <div id="panel-group" class="mw-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Particle speed (v) = group velocity</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="group-v" class="number-input" value="1e6" min="0" step="any">
                                <select id="group-v-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMatterWaves()">Calculate</button>
                        <div class="result-card" id="result-group">
                            <div class="result-label">Group velocity (v_group = v)</div>
                            <div class="result-value" id="group-result">1×10⁶ m/s</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>〰️ Matter wave summary</h3></div>
                    <div class="mw-viz-container" id="mw-viz-container">
                        <div id="mw-viz-placeholder" style="color: var(--text-secondary); font-size: 0.9rem; text-align: center; padding: 1rem;">Run a calculation to see result.</div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleMatterWaveSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="mw-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="mw-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Matter waves formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">de Broglie wavelength</td>
                                <td class="form-equation">λ = h / p = h / (m v)</td>
                                <td class="form-desc">p = momentum</td>
                            </tr>
                            <tr>
                                <td class="form-name">Accelerated electron</td>
                                <td class="form-equation">λ = h / √(2 m e V)</td>
                                <td class="form-desc">V = accelerating voltage</td>
                            </tr>
                            <tr>
                                <td class="form-name">λ (Å) for electron (V in volts)</td>
                                <td class="form-equation">λ (Å) ≈ 12.27 / √V</td>
                                <td class="form-desc">Useful numerical relation</td>
                            </tr>
                            <tr>
                                <td class="form-name">Relativistic particle</td>
                                <td class="form-equation">λ = h / √(2 m₀ c² (γ − 1))</td>
                                <td class="form-desc">γ = 1/√(1 − v²/c²)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Phase velocity</td>
                                <td class="form-equation">v_phase = c² / v</td>
                                <td class="form-desc">Always &gt; c (de Broglie waves)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Group velocity</td>
                                <td class="form-equation">v_group = v</td>
                                <td class="form-desc">Equals particle velocity</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About matter waves (de Broglie hypothesis)</h2>
            <p>de Broglie proposed that every particle with momentum p has an associated wavelength <strong>λ = h/p = h/(mv)</strong>, showing wave-particle duality. For an electron accelerated from rest through potential V, kinetic energy K = eV, so <strong>λ = h/√(2meV)</strong>. With V in volts, <strong>λ (Å) ≈ 12.27/√V</strong>.</p>
            <h3>Phase and group velocity</h3>
            <p>For de Broglie waves, the phase velocity is <strong>v_phase = c²/v</strong> (always greater than c); the group velocity is <strong>v_group = v</strong>, the particle speed. Only the group velocity carries energy and information.</p>
            <h3>Relativistic case</h3>
            <p>For relativistic particles, <strong>λ = h/√(2 m₀ c² (γ − 1))</strong>, where γ = 1/√(1 − v²/c²). This reduces to the non-relativistic form when v ≪ c.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/matter-waves.js?v=<%=cacheVersion%>"></script>
</body>
</html>
