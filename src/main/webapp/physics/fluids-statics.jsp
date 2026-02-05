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
        <jsp:param name="toolName" value="Fluids Statics - Pressure, Buoyancy, Archimedes Principle, Pascal's Law" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Fluid statics (hydrostatics) formulas: pressure (P = F/A), hydrostatic pressure (P = P₀ + ρgh), Archimedes' principle (buoyant force F_b = ρVg), apparent weight, Pascal's law. Free calculators with Matter.js floating object animations." />
        <jsp:param name="toolUrl" value="physics/fluids-statics.jsp" />
        <jsp:param name="toolKeywords" value="fluid statics, hydrostatics, pressure formula, buoyant force, Archimedes principle, Pascal law, hydrostatic pressure, apparent weight, physics fluids, JEE NEET" />
        <jsp:param name="toolImage" value="fluids-statics.png" />
        <jsp:param name="toolFeatures" value="Pressure calculator,Hydrostatic pressure calculator,Buoyant force calculator,Apparent weight calculator,Pascal law calculator,Matter.js floating objects,Step-by-step solutions,SI units (Pa, N)" />
        <jsp:param name="faq1q" value="What is hydrostatic pressure?" />
        <jsp:param name="faq1a" value="Hydrostatic pressure P = P₀ + ρgh, where P₀ is atmospheric pressure, ρ is fluid density (kg/m³), g = 9.8 m/s², and h is depth (m). Pressure increases linearly with depth." />
        <jsp:param name="faq2q" value="What is Archimedes' principle?" />
        <jsp:param name="faq2a" value="Archimedes' principle: Buoyant force F_b = ρ_fluid V_sub g, where V_sub is volume of fluid displaced. The buoyant force equals the weight of displaced fluid. Objects float if ρ_object ≤ ρ_fluid." />
        <jsp:param name="faq3q" value="What is Pascal's law?" />
        <jsp:param name="faq3a" value="Pascal's law: Pressure applied to a confined fluid is transmitted undiminished in all directions. Hydraulic lift: F₂/F₁ = A₂/A₁. Small force on small area creates large force on large area." />
        <jsp:param name="faq4q" value="What is apparent weight in a fluid?" />
        <jsp:param name="faq4a" value="Apparent weight W_app = mg − F_b = mg − ρ_fluid V g, where m is mass, g is gravity, F_b is buoyant force, ρ_fluid is fluid density, and V is object volume. Weight appears reduced due to buoyancy." />
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
        :root { --fluid-blue: #0ea5e9; --fluid-cyan: #06b6d4; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #0ea5e9 0%, #06b6d4 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(14,165,233,0.1), rgba(6,182,212,0.1)); border-left: 4px solid var(--fluid-blue); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #0ea5e9, #06b6d4); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .fluid-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .fluid-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .fluid-tab:hover { border-color: var(--fluid-blue); color: var(--fluid-blue); }
        .fluid-tab.active { background: linear-gradient(135deg, #0ea5e9, #06b6d4); border-color: #06b6d4; color: white; }
        .fluid-panel { display: none; }
        .fluid-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--fluid-blue); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #0ea5e9, #06b6d4); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(14,165,233,0.15), rgba(6,182,212,0.1)); border: 2px solid var(--fluid-blue); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--fluid-blue); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #0ea5e9, #06b6d4); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--fluid-blue); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(14,165,233,0.1), rgba(6,182,212,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .fluid-viz-container { position: relative; width: 100%; height: 300px; background: linear-gradient(180deg, #e0f2fe 0%, #bae6fd 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .fluid-viz-container, .dark-mode .fluid-viz-container { background: linear-gradient(180deg, #0c4a6e 0%, #075985 100%); }
        .fluid-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .fluid-viz-pills { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; }
        .fluid-viz-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-md); }
        [data-theme="dark"] .fluid-viz-pill, .dark-mode .fluid-viz-pill { background: rgba(30,41,59,0.95); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #0ea5e9, #06b6d4); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--fluid-blue); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--fluid-blue); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #0ea5e9; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--fluid-blue); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #059669; font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: #059669; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--fluid-blue); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } .fluid-viz-container { height: 250px; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>💧</span> Fluids – Statics (Hydrostatics)</h1>
            <p class="tool-page-description">Pressure, hydrostatic pressure, buoyancy, Archimedes' principle, Pascal's law</p>
            <div class="tool-badges">
                <span class="tool-badge">P = F/A</span>
                <span class="tool-badge">P = P₀ + ρgh</span>
                <span class="tool-badge">F_b = ρVg</span>
                <span class="tool-badge">Pascal's law</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Fluid statics</div>
            <p>Fluid statics (hydrostatics) studies fluids at rest. Pressure increases with depth due to weight of fluid above. Buoyant force equals weight of displaced fluid (Archimedes' principle). Pascal's law: pressure is transmitted undiminished in confined fluids.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Fluid statics calculators</h2>
                    <p>Pressure, buoyancy, Archimedes, Pascal</p>
                </div>
                <div class="panel-body">
                    <div class="fluid-tabs">
                        <button type="button" class="fluid-tab active" data-tab="pressure" onclick="if(window.switchFluidTab)window.switchFluidTab('pressure',this);">Pressure</button>
                        <button type="button" class="fluid-tab" data-tab="hydrostatic" onclick="if(window.switchFluidTab)window.switchFluidTab('hydrostatic',this);">Hydrostatic</button>
                        <button type="button" class="fluid-tab" data-tab="buoyant" onclick="if(window.switchFluidTab)window.switchFluidTab('buoyant',this);">Buoyant</button>
                        <button type="button" class="fluid-tab" data-tab="apparent" onclick="if(window.switchFluidTab)window.switchFluidTab('apparent',this);">Apparent</button>
                        <button type="button" class="fluid-tab" data-tab="pascal" onclick="if(window.switchFluidTab)window.switchFluidTab('pascal',this);">Pascal</button>
                    </div>

                    <div id="panel-pressure" class="fluid-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Force (F)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="press-f" class="number-input" value="1000" min="0" step="any">
                                <select id="press-f-unit" class="unit-select">
                                    <option value="N">N</option>
                                    <option value="kN">kN</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area (A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="press-a" class="number-input" value="0.01" min="0" step="any">
                                <select id="press-a-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runFluidStatics()">Calculate Pressure</button>
                        <div class="result-card" id="result-pressure">
                            <div class="result-label">Pressure</div>
                            <div class="result-value" id="press-result">100 kPa</div>
                        </div>
                    </div>

                    <div id="panel-hydrostatic" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Atmospheric pressure (P₀)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="hydro-p0" class="number-input" value="101325" min="0" step="any">
                                <select id="hydro-p0-unit" class="unit-select">
                                    <option value="Pa">Pa</option>
                                    <option value="kPa">kPa</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Density (ρ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="hydro-rho" class="number-input" value="1000" min="0" step="any">
                                <select id="hydro-rho-unit" class="unit-select">
                                    <option value="kg/m³">kg/m³</option>
                                    <option value="g/cm³">g/cm³</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Depth (h)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="hydro-h" class="number-input" value="10" min="0" step="any">
                                <select id="hydro-h-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runFluidStatics()">Calculate Pressure</button>
                        <div class="result-card" id="result-hydrostatic">
                            <div class="result-label">Hydrostatic Pressure</div>
                            <div class="result-value" id="hydro-result">199.3 kPa</div>
                        </div>
                    </div>

                    <div id="panel-buoyant" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Fluid density (ρ_fluid)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="buoy-rho" class="number-input" value="1000" min="0" step="any">
                                <select id="buoy-rho-unit" class="unit-select">
                                    <option value="kg/m³">kg/m³</option>
                                    <option value="g/cm³">g/cm³</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Submerged volume (V_sub)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="buoy-v" class="number-input" value="0.001" min="0" step="any">
                                <select id="buoy-v-unit" class="unit-select">
                                    <option value="m³">m³</option>
                                    <option value="cm³">cm³</option>
                                    <option value="L">L</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runFluidStatics()">Calculate Buoyant Force</button>
                        <div class="result-card" id="result-buoyant">
                            <div class="result-label">Buoyant Force</div>
                            <div class="result-value" id="buoy-result">9.81 N</div>
                        </div>
                    </div>

                    <div id="panel-apparent" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Mass (m)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="app-m" class="number-input" value="1" min="0" step="any">
                                <select id="app-m-unit" class="unit-select">
                                    <option value="kg">kg</option>
                                    <option value="g">g</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Fluid density (ρ_fluid)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="app-rho" class="number-input" value="1000" min="0" step="any">
                                <select id="app-rho-unit" class="unit-select">
                                    <option value="kg/m³">kg/m³</option>
                                    <option value="g/cm³">g/cm³</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Object volume (V)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="app-v" class="number-input" value="0.001" min="0" step="any">
                                <select id="app-v-unit" class="unit-select">
                                    <option value="m³">m³</option>
                                    <option value="cm³">cm³</option>
                                    <option value="L">L</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runFluidStatics()">Calculate Apparent Weight</button>
                        <div class="result-card" id="result-apparent">
                            <div class="result-label">Apparent Weight</div>
                            <div class="result-value" id="app-result">0.00 N</div>
                        </div>
                    </div>

                    <div id="panel-pascal" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Force 1 (F₁)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="pascal-f1" class="number-input" value="100" min="0" step="any">
                                <select id="pascal-f1-unit" class="unit-select">
                                    <option value="N">N</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area 1 (A₁)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="pascal-a1" class="number-input" value="0.001" min="0" step="any">
                                <select id="pascal-a1-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area 2 (A₂)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="pascal-a2" class="number-input" value="0.1" min="0" step="any">
                                <select id="pascal-a2-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runFluidStatics()">Calculate Force 2</button>
                        <div class="result-card" id="result-pascal">
                            <div class="result-label">Force 2 (F₂)</div>
                            <div class="result-value" id="pascal-result">10.0 kN</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>💧 Fluid statics visualization</h3></div>
                    <div class="fluid-viz-container" id="fluid-viz-container">
                        <canvas class="fluid-viz-canvas" id="fluid-viz-canvas"></canvas>
                        <div class="fluid-viz-pills" id="fluid-viz-pills"></div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleFluidSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="fluid-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="fluid-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Fluid statics formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes / Units / Conditions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Pressure definition</td>
                                <td class="form-equation">P = F / A</td>
                                <td class="form-desc">Pascal (Pa = N/m²)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Hydrostatic pressure</td>
                                <td class="form-equation">P = P₀ + ρ g h</td>
                                <td class="form-desc">Pressure increases with depth</td>
                            </tr>
                            <tr>
                                <td class="form-name">Pressure difference</td>
                                <td class="form-equation">ΔP = ρ g Δh</td>
                                <td class="form-desc">Independent of shape of container</td>
                            </tr>
                            <tr>
                                <td class="form-name">Archimedes' Principle</td>
                                <td class="form-equation">F_b = ρ_fluid V_sub g</td>
                                <td class="form-desc">Upthrust = weight of displaced fluid</td>
                            </tr>
                            <tr>
                                <td class="form-name">Apparent weight in fluid</td>
                                <td class="form-equation">W_app = mg − ρ_fluid V g</td>
                                <td class="form-desc">V = volume of object</td>
                            </tr>
                            <tr>
                                <td class="form-name">Condition for floating</td>
                                <td class="form-equation">ρ_object ≤ ρ_fluid</td>
                                <td class="form-desc">Weight = buoyant force</td>
                            </tr>
                            <tr>
                                <td class="form-name">Pascal's Law</td>
                                <td class="form-equation">F₂ / F₁ = A₂ / A₁</td>
                                <td class="form-desc">Hydraulic lift</td>
                            </tr>
                            <tr>
                                <td class="form-name">Density by U-tube</td>
                                <td class="form-equation">ρ₂ / ρ₁ = h₁ / h₂</td>
                                <td class="form-desc">Manometer / U-tube manometer</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About Fluid Statics</h2>
            <p>Fluid statics (hydrostatics) studies fluids at rest. Pressure is force per unit area. Pressure increases with depth due to the weight of fluid above.</p>
            
            <h3>Pressure and Hydrostatic Pressure</h3>
            <p><strong>Pressure (P)</strong> = Force per unit area = F/A. Units: Pascal (Pa = N/m²).</p>
            <p><strong>Hydrostatic pressure</strong> P = P₀ + ρgh, where P₀ is atmospheric pressure, ρ is fluid density, g = 9.8 m/s², and h is depth. Pressure increases linearly with depth, independent of container shape.</p>
            
            <h3>Archimedes' Principle</h3>
            <p><strong>Buoyant force F_b</strong> = ρ_fluid V_sub g, where V_sub is volume of fluid displaced. The buoyant force equals the weight of displaced fluid. Objects float if ρ_object ≤ ρ_fluid.</p>
            
            <h3>Pascal's Law</h3>
            <p><strong>Pascal's law:</strong> Pressure applied to a confined fluid is transmitted undiminished in all directions. Hydraulic lift: F₂/F₁ = A₂/A₁. Small force on small area creates large force on large area.</p>
            
            <h3>Apparent Weight</h3>
            <p><strong>Apparent weight</strong> W_app = mg − F_b = mg − ρ_fluid V g. Weight appears reduced in fluid due to buoyant force. If ρ_object < ρ_fluid, object floats; if ρ_object > ρ_fluid, object sinks.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/fluids-statics.js?v=<%=cacheVersion%>"></script>
</body>
</html>
