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
        <jsp:param name="toolName" value="Fluids Dynamics - Continuity, Bernoulli, Viscosity, Flow Rate, Reynolds Number" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Fluid dynamics (hydrodynamics) formulas: continuity equation (A₁v₁ = A₂v₂), Bernoulli's equation (P + ½ρv² + ρgh = constant), viscosity (Stokes' law), flow rate (Poiseuille's law), Reynolds number. Free calculators with Matter.js fluid flow animations." />
        <jsp:param name="toolUrl" value="physics/fluids-dynamics.jsp" />
        <jsp:param name="toolKeywords" value="fluid dynamics, hydrodynamics, continuity equation, Bernoulli equation, viscosity, flow rate, Poiseuille law, Reynolds number, Venturi effect, physics fluids, JEE NEET" />
        <jsp:param name="toolImage" value="fluids-dynamics.png" />
        <jsp:param name="toolFeatures" value="Continuity calculator,Bernoulli calculator,Viscosity calculator,Flow rate calculator,Reynolds number calculator,Matter.js fluid flow particles,Step-by-step solutions,SI units" />
        <jsp:param name="faq1q" value="What is the continuity equation?" />
        <jsp:param name="faq1a" value="Continuity equation: A₁v₁ = A₂v₂ for incompressible fluids. Mass conservation: flow rate is constant. Narrow pipe → faster flow; wide pipe → slower flow." />
        <jsp:param name="faq2q" value="What is Bernoulli's equation?" />
        <jsp:param name="faq2a" value="Bernoulli's equation: P + ½ρv² + ρgh = constant along a streamline. High speed → low pressure (Venturi effect). Used for lift, flow measurement, and pressure calculations." />
        <jsp:param name="faq3q" value="What is viscosity?" />
        <jsp:param name="faq3a" value="Viscosity (η) measures fluid resistance to flow. Stokes' law: F_d = 6πηrv for drag on sphere. Poiseuille's law: Q = (πr⁴ΔP)/(8ηL) for flow through tube. Units: Pa·s." />
        <jsp:param name="faq4q" value="What is Reynolds number?" />
        <jsp:param name="faq4a" value="Reynolds number Re = ρvD/η determines flow type. Re < 2000 → laminar (smooth), Re > 4000 → turbulent (chaotic). Dimensionless parameter for flow characterization." />
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
        :root { --fluid-green: #10b981; --fluid-emerald: #059669; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #10b981 0%, #059669 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(16,185,129,0.1), rgba(5,150,105,0.1)); border-left: 4px solid var(--fluid-green); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #10b981, #059669); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .fluid-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .fluid-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .fluid-tab:hover { border-color: var(--fluid-green); color: var(--fluid-green); }
        .fluid-tab.active { background: linear-gradient(135deg, #10b981, #059669); border-color: #059669; color: white; }
        .fluid-panel { display: none; }
        .fluid-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--fluid-green); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #10b981, #059669); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(16,185,129,0.15), rgba(5,150,105,0.1)); border: 2px solid var(--fluid-green); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--fluid-green); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #10b981, #059669); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--fluid-green); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(16,185,129,0.1), rgba(5,150,105,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .fluid-viz-container { position: relative; width: 100%; height: 300px; background: linear-gradient(180deg, #d1fae5 0%, #a7f3d0 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .fluid-viz-container, .dark-mode .fluid-viz-container { background: linear-gradient(180deg, #064e3b 0%, #065f46 100%); }
        .fluid-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .fluid-viz-pills { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; }
        .fluid-viz-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-md); }
        [data-theme="dark"] .fluid-viz-pill, .dark-mode .fluid-viz-pill { background: rgba(30,41,59,0.95); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #10b981, #059669); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--fluid-green); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--fluid-green); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #10b981; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--fluid-green); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #059669; font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: #059669; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--fluid-green); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } .fluid-viz-container { height: 250px; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🌊</span> Fluids – Dynamics (Hydrodynamics)</h1>
            <p class="tool-page-description">Continuity, Bernoulli, viscosity, flow rate, Reynolds number</p>
            <div class="tool-badges">
                <span class="tool-badge">A₁v₁ = A₂v₂</span>
                <span class="tool-badge">Bernoulli</span>
                <span class="tool-badge">Viscosity</span>
                <span class="tool-badge">Reynolds</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Fluid dynamics</div>
            <p>Fluid dynamics (hydrodynamics) studies fluids in motion. Continuity equation: mass conservation (A₁v₁ = A₂v₂). Bernoulli's equation: energy conservation (P + ½ρv² + ρgh = constant). Viscosity resists flow. Reynolds number determines flow type (laminar vs turbulent).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Fluid dynamics calculators</h2>
                    <p>Continuity, Bernoulli, viscosity, flow, Reynolds</p>
                </div>
                <div class="panel-body">
                    <div class="fluid-tabs">
                        <button type="button" class="fluid-tab active" data-tab="continuity" onclick="if(window.switchFluidDynTab)window.switchFluidDynTab('continuity',this);">Continuity</button>
                        <button type="button" class="fluid-tab" data-tab="bernoulli" onclick="if(window.switchFluidDynTab)window.switchFluidDynTab('bernoulli',this);">Bernoulli</button>
                        <button type="button" class="fluid-tab" data-tab="viscosity" onclick="if(window.switchFluidDynTab)window.switchFluidDynTab('viscosity',this);">Viscosity</button>
                        <button type="button" class="fluid-tab" data-tab="flowrate" onclick="if(window.switchFluidDynTab)window.switchFluidDynTab('flowrate',this);">Flow Rate</button>
                        <button type="button" class="fluid-tab" data-tab="reynolds" onclick="if(window.switchFluidDynTab)window.switchFluidDynTab('reynolds',this);">Reynolds</button>
                    </div>

                    <div id="panel-continuity" class="fluid-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Area 1 (A₁)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cont-a1" class="number-input" value="0.01" min="0" step="any">
                                <select id="cont-a1-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Velocity 1 (v₁)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cont-v1" class="number-input" value="2" min="0" step="any">
                                <select id="cont-v1-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                    <option value="cm/s">cm/s</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area 2 (A₂)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cont-a2" class="number-input" value="0.005" min="0" step="any">
                                <select id="cont-a2-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runFluidDynamics()">Calculate Velocity 2</button>
                        <div class="result-card" id="result-continuity">
                            <div class="result-label">Velocity 2</div>
                            <div class="result-value" id="cont-result">4.00 m/s</div>
                        </div>
                    </div>

                    <div id="panel-bernoulli" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Pressure 1 (P₁)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bern-p1" class="number-input" value="101325" min="0" step="any">
                                <select id="bern-p1-unit" class="unit-select">
                                    <option value="Pa">Pa</option>
                                    <option value="kPa">kPa</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Velocity 1 (v₁)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bern-v1" class="number-input" value="0" min="0" step="any">
                                <select id="bern-v1-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Height 1 (h₁)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bern-h1" class="number-input" value="10" min="0" step="any">
                                <select id="bern-h1-unit" class="unit-select">
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Velocity 2 (v₂)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bern-v2" class="number-input" value="5" min="0" step="any">
                                <select id="bern-v2-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Height 2 (h₂)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bern-h2" class="number-input" value="0" min="0" step="any">
                                <select id="bern-h2-unit" class="unit-select">
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Density (ρ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bern-rho" class="number-input" value="1000" min="0" step="any">
                                <select id="bern-rho-unit" class="unit-select">
                                    <option value="kg/m³">kg/m³</option>
                                    <option value="g/cm³">g/cm³</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runFluidDynamics()">Calculate Pressure 2</button>
                        <div class="result-card" id="result-bernoulli">
                            <div class="result-label">Pressure 2</div>
                            <div class="result-value" id="bern-result">87.4 kPa</div>
                        </div>
                    </div>

                    <div id="panel-viscosity" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Viscosity (η)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="vis-eta" class="number-input" value="0.001" min="0" step="any">
                                <select id="vis-eta-unit" class="unit-select">
                                    <option value="Pa·s">Pa·s</option>
                                    <option value="cP">cP</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Radius (r)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="vis-r" class="number-input" value="0.01" min="0" step="any">
                                <select id="vis-r-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Velocity (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="vis-v" class="number-input" value="0.1" min="0" step="any">
                                <select id="vis-v-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                    <option value="cm/s">cm/s</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runFluidDynamics()">Calculate Drag Force</button>
                        <div class="result-card" id="result-viscosity">
                            <div class="result-label">Drag Force (Stokes)</div>
                            <div class="result-value" id="vis-result">1.88×10⁻⁵ N</div>
                        </div>
                    </div>

                    <div id="panel-flowrate" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Radius (r)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="flow-r" class="number-input" value="0.01" min="0" step="any">
                                <select id="flow-r-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Pressure difference (ΔP)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="flow-dp" class="number-input" value="1000" min="0" step="any">
                                <select id="flow-dp-unit" class="unit-select">
                                    <option value="Pa">Pa</option>
                                    <option value="kPa">kPa</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Viscosity (η)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="flow-eta" class="number-input" value="0.001" min="0" step="any">
                                <select id="flow-eta-unit" class="unit-select">
                                    <option value="Pa·s">Pa·s</option>
                                    <option value="cP">cP</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Length (L)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="flow-l" class="number-input" value="1" min="0" step="any">
                                <select id="flow-l-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runFluidDynamics()">Calculate Flow Rate</button>
                        <div class="result-card" id="result-flowrate">
                            <div class="result-label">Flow Rate (Q)</div>
                            <div class="result-value" id="flow-result">3.93×10⁻⁶ m³/s</div>
                        </div>
                    </div>

                    <div id="panel-reynolds" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Density (ρ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="reyn-rho" class="number-input" value="1000" min="0" step="any">
                                <select id="reyn-rho-unit" class="unit-select">
                                    <option value="kg/m³">kg/m³</option>
                                    <option value="g/cm³">g/cm³</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Velocity (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="reyn-v" class="number-input" value="1" min="0" step="any">
                                <select id="reyn-v-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                    <option value="cm/s">cm/s</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Diameter (D)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="reyn-d" class="number-input" value="0.02" min="0" step="any">
                                <select id="reyn-d-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Viscosity (η)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="reyn-eta" class="number-input" value="0.001" min="0" step="any">
                                <select id="reyn-eta-unit" class="unit-select">
                                    <option value="Pa·s">Pa·s</option>
                                    <option value="cP">cP</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runFluidDynamics()">Calculate Reynolds Number</button>
                        <div class="result-card" id="result-reynolds">
                            <div class="result-label">Reynolds Number</div>
                            <div class="result-value" id="reyn-result">20000</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>🌊 Fluid dynamics visualization</h3></div>
                    <div class="fluid-viz-container" id="fluid-viz-container">
                        <canvas class="fluid-viz-canvas" id="fluid-viz-canvas"></canvas>
                        <div class="fluid-viz-pills" id="fluid-viz-pills"></div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleFluidDynSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="fluid-dyn-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="fluid-dyn-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Fluid dynamics formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes / Units / Conditions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Continuity Equation</td>
                                <td class="form-equation">A₁ v₁ = A₂ v₂</td>
                                <td class="form-desc">Incompressible fluid → A v = constant</td>
                            </tr>
                            <tr>
                                <td class="form-name">Bernoulli's Equation</td>
                                <td class="form-equation">P + ½ ρ v² + ρ g h = constant</td>
                                <td class="form-desc">Along a streamline; ideal fluid (no viscosity)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Torricelli's theorem</td>
                                <td class="form-equation">v = √(2 g h)</td>
                                <td class="form-desc">Speed of efflux from hole at depth h</td>
                            </tr>
                            <tr>
                                <td class="form-name">Viscosity (Newtonian)</td>
                                <td class="form-equation">F = η A (dv/dx)</td>
                                <td class="form-desc">η = coefficient of viscosity (Pa·s)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Stokes' Law</td>
                                <td class="form-equation">F_d = 6πη r v</td>
                                <td class="form-desc">Laminar flow, small sphere</td>
                            </tr>
                            <tr>
                                <td class="form-name">Poiseuille's Law</td>
                                <td class="form-equation">Q = (π r⁴ ΔP) / (8 η L)</td>
                                <td class="form-desc">Volume flow rate; laminar flow</td>
                            </tr>
                            <tr>
                                <td class="form-name">Reynolds number</td>
                                <td class="form-equation">Re = ρ v D / η</td>
                                <td class="form-desc">Re < 2000 → laminar; Re > 4000 → turbulent</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About Fluid Dynamics</h2>
            <p>Fluid dynamics (hydrodynamics) studies fluids in motion. Key principles include mass conservation (continuity), energy conservation (Bernoulli), and flow resistance (viscosity).</p>
            
            <h3>Continuity Equation</h3>
            <p><strong>Continuity equation:</strong> A₁v₁ = A₂v₂ for incompressible fluids. Mass conservation: flow rate is constant. Narrow pipe → faster flow; wide pipe → slower flow.</p>
            
            <h3>Bernoulli's Equation</h3>
            <p><strong>Bernoulli's equation:</strong> P + ½ρv² + ρgh = constant along a streamline. High speed → low pressure (Venturi effect). Used for lift, flow measurement, and pressure calculations.</p>
            
            <h3>Viscosity and Flow</h3>
            <p><strong>Viscosity (η)</strong> measures fluid resistance to flow. Stokes' law: F_d = 6πηrv for drag on sphere. Poiseuille's law: Q = (πr⁴ΔP)/(8ηL) for flow through tube.</p>
            
            <h3>Reynolds Number</h3>
            <p><strong>Reynolds number</strong> Re = ρvD/η determines flow type. Re < 2000 → laminar (smooth), Re > 4000 → turbulent (chaotic). Dimensionless parameter for flow characterization.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/fluids-dynamics.js?v=<%=cacheVersion%>"></script>
</body>
</html>
