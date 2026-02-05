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
        <jsp:param name="toolName" value="Nuclear Physics - Radius, Mass Defect, Binding Energy, Decay, Q-Value" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Nuclear physics formulas: radius R = R₀ A^(1/3), mass defect Δm, binding energy BE = Δm×931.5 MeV/u, BE per nucleon, decay constant λ = 0.693/T₁/₂, N = N₀ e^(-λt), activity A = λN, Q-value. Free calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/nuclear-physics.jsp" />
        <jsp:param name="toolKeywords" value="nuclear physics, nuclear radius, mass defect, binding energy, half-life, decay constant, activity becquerel, Q-value, nuclear reaction, JEE NEET" />
        <jsp:param name="toolImage" value="nuclear-physics.png" />
        <jsp:param name="toolFeatures" value="Nuclear radius R R0 A^(1/3),Mass defect calculator,Binding energy and BE per nucleon,Decay constant and half-life,N nuclei remaining and activity,Q-value of reaction,Step-by-step solutions,fm MeV u Bq" />
        <jsp:param name="faq1q" value="What is nuclear radius formula?" />
        <jsp:param name="faq1a" value="Nuclear radius R = R₀ A^(1/3), where A is mass number and R₀ ≈ 1.2–1.4 fm. Radius grows slowly with A (e.g. doubling A only increases R by about 26%)." />
        <jsp:param name="faq2q" value="What is binding energy?" />
        <jsp:param name="faq2a" value="Binding energy BE = Δm × c², where Δm is mass defect (sum of nucleon masses minus nucleus mass). In atomic mass units: BE ≈ Δm × 931.5 MeV/u. BE per nucleon is maximum near Fe-56 (~8.8 MeV/nucleon)." />
        <jsp:param name="faq3q" value="What is the decay law?" />
        <jsp:param name="faq3a" value="Decay constant λ = ln(2)/T₁/₂ = 0.693/T₁/₂. Number remaining N = N₀ e^(-λt). Activity A = λN = A₀ e^(-λt), in becquerels (Bq) or curie (Ci)." />
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
        :root { --nuc-rose: #be123c; --nuc-red: #e11d48; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #be123c 0%, #e11d48 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(190,18,60,0.1), rgba(225,29,72,0.1)); border-left: 4px solid var(--nuc-rose); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #be123c, #e11d48); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .nuc-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .nuc-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .nuc-tab:hover { border-color: var(--nuc-rose); color: var(--nuc-rose); }
        .nuc-tab.active { background: linear-gradient(135deg, #be123c, #e11d48); border-color: #e11d48; color: white; }
        .nuc-panel { display: none; }
        .nuc-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--nuc-rose); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #be123c, #e11d48); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(190,18,60,0.15), rgba(225,29,72,0.1)); border: 2px solid var(--nuc-rose); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--nuc-rose); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #be123c, #e11d48); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--nuc-rose); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(190,18,60,0.1), rgba(225,29,72,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); }
        .nuc-viz-container { width: 100%; height: 200px; background: linear-gradient(180deg, #fff1f2 0%, #ffe4e6 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); display: flex; align-items: center; justify-content: center; }
        .nuc-viz-container .highlight { color: var(--nuc-rose); font-weight: 700; }
        [data-theme="dark"] .nuc-viz-container, .dark-mode .nuc-viz-container { background: linear-gradient(180deg, #881337 0%, #9f1239 100%); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #be123c, #e11d48); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--nuc-rose); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--nuc-rose); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #be123c; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--nuc-rose); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>☢️</span> Nuclear Physics</h1>
            <p class="tool-page-description">Radius, mass defect, binding energy, decay, activity, Q-value</p>
            <div class="tool-badges">
                <span class="tool-badge">R = R₀ A^(1/3)</span>
                <span class="tool-badge">BE = Δm × 931.5 MeV/u</span>
                <span class="tool-badge">N = N₀ e^(-λt)</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Nuclear physics</div>
            <p>Nuclear radius R = R₀ A^(1/3) (R₀ ≈ 1.2–1.4 fm). Mass defect Δm = Z m_p + (A−Z) m_n − M_nucleus. Binding energy BE = Δm × c² ≈ Δm × 931.5 MeV/u; BE/A maximum ~8.8 MeV/nucleon. Decay: λ = 0.693/T₁/₂, N = N₀ e^(-λt), activity A = λN. Q-value = (mass reactants − mass products) c² (positive = exoergic).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Nuclear physics calculators</h2>
                    <p>Radius, mass defect, BE, decay, Q-value</p>
                </div>
                <div class="panel-body">
                    <div class="nuc-tabs">
                        <button type="button" class="nuc-tab active" data-tab="radius" onclick="if(window.switchNuclearTab)window.switchNuclearTab('radius',this);">Radius</button>
                        <button type="button" class="nuc-tab" data-tab="massdefect" onclick="if(window.switchNuclearTab)window.switchNuclearTab('massdefect',this);">Mass defect</button>
                        <button type="button" class="nuc-tab" data-tab="binding" onclick="if(window.switchNuclearTab)window.switchNuclearTab('binding',this);">Binding E</button>
                        <button type="button" class="nuc-tab" data-tab="decay" onclick="if(window.switchNuclearTab)window.switchNuclearTab('decay',this);">Decay</button>
                        <button type="button" class="nuc-tab" data-tab="qvalue" onclick="if(window.switchNuclearTab)window.switchNuclearTab('qvalue',this);">Q-value</button>
                    </div>

                    <div id="panel-radius" class="nuc-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Mass number (A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="radius-a" class="number-input" value="56" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">A</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>R₀ (fm)</span></div>
                            <select id="radius-r0" class="number-input" style="border-radius: 10px;">
                                <option value="1.2">1.2 fm</option>
                                <option value="1.3">1.3 fm</option>
                                <option value="1.4">1.4 fm</option>
                            </select>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runNuclearPhysics()">Calculate R</button>
                        <div class="result-card" id="result-radius">
                            <div class="result-label">Nuclear radius</div>
                            <div class="result-value" id="radius-result">4.6 fm</div>
                        </div>
                    </div>

                    <div id="panel-massdefect" class="nuc-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Proton number (Z)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="md-z" class="number-input" value="26" min="0" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">Z</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Mass number (A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="md-a" class="number-input" value="56" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">A</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Mass of nucleus (u)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="md-m" class="number-input" value="55.9349" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">u</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runNuclearPhysics()">Calculate Δm</button>
                        <div class="result-card" id="result-massdefect">
                            <div class="result-label">Mass defect</div>
                            <div class="result-value" id="md-result">0.528 u</div>
                        </div>
                    </div>

                    <div id="panel-binding" class="nuc-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Mass defect Δm (u)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="be-dm" class="number-input" value="0.528" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">u</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Mass number (A, for BE/A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="be-a" class="number-input" value="56" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">A</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runNuclearPhysics()">Calculate BE &amp; BE/A</button>
                        <div class="result-card" id="result-binding">
                            <div class="result-label">Binding energy &amp; per nucleon</div>
                            <div class="result-value" id="be-result">492 MeV, 8.79 MeV/nucleon</div>
                        </div>
                    </div>

                    <div id="panel-decay" class="nuc-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Half-life (T₁/₂)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="decay-t" class="number-input" value="5" min="0" step="any">
                                <select id="decay-t-unit" class="unit-select">
                                    <option value="s">s</option>
                                    <option value="min">min</option>
                                    <option value="h">h</option>
                                    <option value="d">days</option>
                                    <option value="y">years</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Initial number N₀ (optional)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="decay-n0" class="number-input" value="1e6" min="0" step="any" placeholder="e.g. 1e6">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">nuclei</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Elapsed time (t)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="decay-elapsed" class="number-input" value="10" min="0" step="any">
                                <select id="decay-elapsed-unit" class="unit-select">
                                    <option value="s">s</option>
                                    <option value="min">min</option>
                                    <option value="h">h</option>
                                    <option value="d">days</option>
                                    <option value="y">years</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runNuclearPhysics()">Calculate λ, N, A</button>
                        <div class="result-card" id="result-decay">
                            <div class="result-label">Decay constant, N remaining, Activity</div>
                            <div class="result-value" id="decay-result">—</div>
                        </div>
                    </div>

                    <div id="panel-qvalue" class="nuc-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Mass of reactants (u)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="qv-mreact" class="number-input" value="236.045" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">u</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Mass of products (u)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="qv-mprod" class="number-input" value="235.794" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">u</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runNuclearPhysics()">Calculate Q</button>
                        <div class="result-card" id="result-qvalue">
                            <div class="result-label">Q-value</div>
                            <div class="result-value" id="qv-result">233 MeV (exoergic)</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>☢️ Nuclear summary</h3></div>
                    <div class="nuc-viz-container" id="nuc-viz-container">
                        <div id="nuc-viz-placeholder" style="color: var(--text-secondary); font-size: 0.9rem; text-align: center; padding: 1rem;">Run a calculation to see result.</div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleNuclearSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="nuc-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="nuc-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Nuclear physics formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Nuclear radius</td>
                                <td class="form-equation">R = R₀ A^(1/3)</td>
                                <td class="form-desc">R₀ ≈ 1.2–1.4 fm, A = mass number</td>
                            </tr>
                            <tr>
                                <td class="form-name">Mass defect</td>
                                <td class="form-equation">Δm = Z m_p + (A−Z) m_n − M_nucleus</td>
                                <td class="form-desc">In u or kg</td>
                            </tr>
                            <tr>
                                <td class="form-name">Binding energy</td>
                                <td class="form-equation">BE = Δm × c² = Δm × 931.5 MeV/u</td>
                                <td class="form-desc">Most stable around Fe-56</td>
                            </tr>
                            <tr>
                                <td class="form-name">BE per nucleon</td>
                                <td class="form-equation">BE / A</td>
                                <td class="form-desc">Maximum ~8.8 MeV/nucleon</td>
                            </tr>
                            <tr>
                                <td class="form-name">Decay constant</td>
                                <td class="form-equation">λ = ln(2) / T₁/₂ = 0.693 / T₁/₂</td>
                                <td class="form-desc">T₁/₂ = half-life</td>
                            </tr>
                            <tr>
                                <td class="form-name">Nuclei remaining</td>
                                <td class="form-equation">N = N₀ e^(−λt)</td>
                                <td class="form-desc">Exponential decay</td>
                            </tr>
                            <tr>
                                <td class="form-name">Activity</td>
                                <td class="form-equation">A = λ N = A₀ e^(−λt)</td>
                                <td class="form-desc">Bq or Ci</td>
                            </tr>
                            <tr>
                                <td class="form-name">Q-value</td>
                                <td class="form-equation">Q = (m_reactants − m_products) c²</td>
                                <td class="form-desc">Positive → exoergic</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About nuclear physics</h2>
            <p>Nuclear radius follows <strong>R = R₀ A^(1/3)</strong> (A = mass number). Mass defect is the difference between the sum of nucleon masses and the actual nucleus mass; <strong>BE = Δm × c² ≈ Δm × 931.5 MeV/u</strong>. Binding energy per nucleon peaks near iron (Fe-56). Radioactive decay: <strong>λ = 0.693/T₁/₂</strong>, <strong>N = N₀ e^(-λt)</strong>, <strong>A = λN</strong>. Q-value of a reaction is the mass difference (reactants − products) in energy units; Q &gt; 0 means exoergic.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/nuclear-physics.js?v=<%=cacheVersion%>"></script>
</body>
</html>
