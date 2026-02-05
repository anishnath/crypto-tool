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
        <jsp:param name="toolName" value="Thermal & Heat-Related Conversions - Q = mcΔT, Latent Heat, Heat Engine Efficiency" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Thermal and heat formulas: sensible heat (Q = m c ΔT), latent heat (Q = m L), heat engine efficiency (η = W/Q_in), and Carnot efficiency (η = 1 - T_cold/T_hot). Free calculators and reference." />
        <jsp:param name="toolUrl" value="physics/thermal-energy.jsp" />
        <jsp:param name="toolKeywords" value="thermal energy formula, heat formula, Q mc delta T, latent heat, heat engine efficiency, Carnot efficiency, specific heat capacity, thermodynamics" />
        <jsp:param name="toolImage" value="thermal-energy.png" />
        <jsp:param name="toolFeatures" value="Sensible heat calculator,Latent heat calculator,Heat engine efficiency calculator,Carnot efficiency calculator,Interactive visualization,Step-by-step solutions,Chart.js efficiency vs temperature,SI units (J, K, °C)" />
        <jsp:param name="faq1q" value="What is sensible heat?" />
        <jsp:param name="faq1a" value="Sensible heat is Q = m c ΔT, where m is mass (kg), c is specific heat capacity (J/(kg·K)), and ΔT is temperature change (K). This causes temperature change." />
        <jsp:param name="faq2q" value="What is latent heat?" />
        <jsp:param name="faq2a" value="Latent heat Q = m L is energy for phase change (melting, vaporization) without temperature change. L is latent heat of fusion or vaporization (J/kg)." />
        <jsp:param name="faq3q" value="What is heat engine efficiency?" />
        <jsp:param name="faq3a" value="Heat engine efficiency η = W / Q_in = 1 − (Q_out / Q_in), where W is useful work output, Q_in is heat input, and Q_out is waste heat. Unit: dimensionless (0 to 1)." />
        <jsp:param name="faq4q" value="What is Carnot efficiency?" />
        <jsp:param name="faq4a" value="Carnot efficiency η_Carnot = 1 − (T_cold / T_hot) is the maximum possible efficiency for a reversible heat engine operating between hot (T_hot) and cold (T_cold) reservoirs in kelvin." />
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
        :root { --thermal-red: #dc2626; --thermal-orange: #ea580c; --thermal-yellow: #f59e0b; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #dc2626 0%, #ea580c 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(220,38,38,0.1), rgba(234,88,12,0.1)); border-left: 4px solid var(--thermal-red); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #dc2626, #ea580c); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .thermal-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .thermal-tab { padding: 0.5rem 1rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .thermal-tab:hover { border-color: var(--thermal-red); color: var(--thermal-red); }
        .thermal-tab.active { background: linear-gradient(135deg, #dc2626, #ea580c); border-color: #ea580c; color: white; }
        .thermal-panel { display: none; }
        .thermal-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--thermal-red); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #dc2626, #ea580c); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(220,38,38,0.15), rgba(234,88,12,0.1)); border: 2px solid var(--thermal-red); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--thermal-red); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #dc2626, #ea580c); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--thermal-red); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(220,38,38,0.1), rgba(234,88,12,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .thermal-viz-container { position: relative; width: 100%; height: 260px; background: linear-gradient(180deg, #fef2f2 0%, #fee2e2 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .thermal-viz-container, .dark-mode .thermal-viz-container { background: linear-gradient(180deg, #7f1d1d 0%, #991b1b 100%); }
        .thermal-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .thermal-viz-pills { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; }
        .thermal-viz-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-md); }
        [data-theme="dark"] .thermal-viz-pill, .dark-mode .thermal-viz-pill { background: rgba(30,41,59,0.95); }
        .thermal-chart-wrap { height: 200px; margin: 1rem; padding: 0 0.5rem; }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #dc2626, #7c3aed); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--thermal-red); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--thermal-red); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #dc2626; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--thermal-red); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #059669; font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: #059669; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--thermal-red); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } .thermal-viz-container { height: 220px; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🔥</span> Thermal &amp; Heat-Related Conversions</h1>
            <p class="tool-page-description">Q = mcΔT, latent heat, heat engine efficiency, Carnot efficiency</p>
            <div class="tool-badges">
                <span class="tool-badge">Q = m c ΔT</span>
                <span class="tool-badge">Q = m L</span>
                <span class="tool-badge">η = W/Q_in</span>
                <span class="tool-badge">η_Carnot</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Thermal energy, temperature &amp; heat devices</div>
            <p><strong>Zeroth law:</strong> If A is in thermal equilibrium with B, and B with C, then A is in thermal equilibrium with C — basis for temperature. <strong>Temperature scales:</strong> K = °C + 273.15, °F = (9/5)°C + 32. Sensible heat Q = m c ΔT causes temperature change; latent heat Q = m L causes phase change. Heat engine η = W/Q_in; refrigerator COP = Q_C/W = T_C/(T_H − T_C) for Carnot.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Thermal calculators</h2>
                    <p>Temperature, Q = mcΔT, latent heat, engine η, Carnot, refrigerator COP</p>
                </div>
                <div class="panel-body">
                    <div class="thermal-tabs">
                        <button type="button" class="thermal-tab active" data-tab="sensible">Q = mcΔT</button>
                        <button type="button" class="thermal-tab" data-tab="latent">Latent</button>
                        <button type="button" class="thermal-tab" data-tab="temp">Temp (K/°C/°F)</button>
                        <button type="button" class="thermal-tab" data-tab="efficiency">Engine η</button>
                        <button type="button" class="thermal-tab" data-tab="carnot">Carnot η</button>
                        <button type="button" class="thermal-tab" data-tab="cop">Refrigerator COP</button>
                    </div>

                    <div id="panel-sensible" class="thermal-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Mass (m)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="sens-m" class="number-input" value="1" min="0" step="any">
                                <select id="sens-m-unit" class="unit-select">
                                    <option value="kg">kg</option>
                                    <option value="g">g</option>
                                    <option value="lb">lb</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Specific heat (c)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="sens-c" class="number-input" value="4186" min="0" step="any">
                                <select id="sens-c-unit" class="unit-select">
                                    <option value="J/(kg·K)">J/(kg·K)</option>
                                    <option value="J/(kg·°C)">J/(kg·°C)</option>
                                    <option value="cal/(g·°C)">cal/(g·°C)</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Temperature change (ΔT)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="sens-dt" class="number-input" value="10" step="any">
                                <select id="sens-dt-unit" class="unit-select">
                                    <option value="K">K</option>
                                    <option value="°C">°C</option>
                                    <option value="°F">°F</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runThermal()">Calculate Heat</button>
                        <div class="result-card" id="result-sensible">
                            <div class="result-label">Sensible heat</div>
                            <div class="result-value" id="sens-value">41.86 kJ</div>
                        </div>
                    </div>

                    <div id="panel-latent" class="thermal-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Mass (m)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="lat-m" class="number-input" value="1" min="0" step="any">
                                <select id="lat-m-unit" class="unit-select">
                                    <option value="kg">kg</option>
                                    <option value="g">g</option>
                                    <option value="lb">lb</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Latent heat (L)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="lat-l" class="number-input" value="334000" min="0" step="any">
                                <select id="lat-l-unit" class="unit-select">
                                    <option value="J/kg">J/kg</option>
                                    <option value="kJ/kg">kJ/kg</option>
                                    <option value="cal/g">cal/g</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runThermal()">Calculate Heat</button>
                        <div class="result-card" id="result-latent">
                            <div class="result-label">Latent heat</div>
                            <div class="result-value" id="lat-value">334 kJ</div>
                        </div>
                    </div>

                    <div id="panel-temp" class="thermal-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Temperature (from)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="temp-value-in" class="number-input" value="298.15" step="any">
                                <select id="temp-unit" class="unit-select">
                                    <option value="K">K</option>
                                    <option value="C">°C</option>
                                    <option value="F">°F</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runThermal()">Convert</button>
                        <div class="result-card" id="result-temp">
                            <div class="result-label">Equivalent temperatures</div>
                            <div class="result-value" id="temp-value">—</div>
                        </div>
                    </div>

                    <div id="panel-efficiency" class="thermal-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Work output (W)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="eff-w" class="number-input" value="1000" min="0" step="any">
                                <select id="eff-w-unit" class="unit-select">
                                    <option value="J">J</option>
                                    <option value="kJ">kJ</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Heat input (Q_in)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="eff-qin" class="number-input" value="5000" min="0" step="any">
                                <select id="eff-qin-unit" class="unit-select">
                                    <option value="J">J</option>
                                    <option value="kJ">kJ</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runThermal()">Calculate Efficiency</button>
                        <div class="result-card" id="result-efficiency">
                            <div class="result-label">Efficiency</div>
                            <div class="result-value" id="eff-value">20.0%</div>
                        </div>
                    </div>

                    <div id="panel-carnot" class="thermal-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Hot reservoir (T_hot)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="car-thot" class="number-input" value="500" min="0" step="any">
                                <select id="car-thot-unit" class="unit-select">
                                    <option value="K">K</option>
                                    <option value="°C">°C</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Cold reservoir (T_cold)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="car-tcold" class="number-input" value="300" min="0" step="any">
                                <select id="car-tcold-unit" class="unit-select">
                                    <option value="K">K</option>
                                    <option value="°C">°C</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runThermal()">Calculate Efficiency</button>
                        <div class="result-card" id="result-carnot">
                            <div class="result-label">Carnot efficiency</div>
                            <div class="result-value" id="car-value">40.0%</div>
                        </div>
                    </div>

                    <div id="panel-cop" class="thermal-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Hot reservoir T_H (outside)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cop-thot" class="number-input" value="300" min="0" step="any">
                                <select id="cop-thot-unit" class="unit-select">
                                    <option value="K">K</option>
                                    <option value="C">°C</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Cold reservoir T_C (inside)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cop-tcold" class="number-input" value="273" min="0" step="any">
                                <select id="cop-tcold-unit" class="unit-select">
                                    <option value="K">K</option>
                                    <option value="C">°C</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runThermal()">Calculate COP</button>
                        <div class="result-card" id="result-cop">
                            <div class="result-label">COP_Carnot (refrigerator)</div>
                            <div class="result-value" id="cop-value">—</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>🔥 Thermal visualization</h3></div>
                    <div class="thermal-viz-container" id="thermal-viz-container">
                        <canvas class="thermal-viz-canvas" id="thermal-viz-canvas"></canvas>
                        <div class="thermal-viz-pills" id="thermal-viz-pills"></div>
                    </div>
                    <div class="thermal-chart-wrap" id="thermal-chart-wrap" style="display:none;">
                        <canvas id="thermal-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleThermalSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="thermal-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="thermal-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Thermal and heat-related conversion formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Heat energy (sensible heat)</td>
                                <td class="form-equation">Q = m c ΔT</td>
                                <td class="form-desc">Specific heat capacity</td>
                            </tr>
                            <tr>
                                <td class="form-name">Latent heat</td>
                                <td class="form-equation">Q = m L</td>
                                <td class="form-desc">Phase change (no temperature change)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Efficiency of heat engine</td>
                                <td class="form-equation">η = W / Q<sub>in</sub> = 1 − (Q<sub>out</sub> / Q<sub>in</sub>)</td>
                                <td class="form-desc">Fraction of heat converted to useful work</td>
                            </tr>
                            <tr>
                                <td class="form-name">Carnot efficiency (maximum possible)</td>
                                <td class="form-equation">η<sub>Carnot</sub> = 1 − (T<sub>cold</sub> / T<sub>hot</sub>)</td>
                                <td class="form-desc">Ideal reversible engine</td>
                            </tr>
                            <tr>
                                <td class="form-name">Temperature scales</td>
                                <td class="form-equation">K = °C + 273.15, °F = (9/5)°C + 32</td>
                                <td class="form-desc">Zeroth law: thermal equilibrium defines temperature</td>
                            </tr>
                            <tr>
                                <td class="form-name">Refrigerator / heat pump (Carnot COP)</td>
                                <td class="form-equation">COP = Q<sub>C</sub> / W = T<sub>C</sub> / (T<sub>H</sub> − T<sub>C</sub>)</td>
                                <td class="form-desc">Heat removed from cold per unit work (T in K)</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About thermal energy</h2>
            <p>Sensible heat <strong>Q = m c ΔT</strong> causes temperature change, where c is specific heat capacity. Latent heat <strong>Q = m L</strong> causes phase change (melting, vaporization) without temperature change.</p>
            <h3>Heat engines</h3>
            <p>Heat engine efficiency <strong>η = W / Q_in</strong> measures the fraction of heat input converted to useful work. The Carnot efficiency <strong>η_Carnot = 1 − (T_cold / T_hot)</strong> is the theoretical maximum for a reversible engine operating between two reservoirs.</p>
            <h3>SI units</h3>
            <p>Heat/Energy: joule (J). Mass: kilogram (kg). Specific heat: J/(kg·K). Latent heat: J/kg. Temperature: kelvin (K). Efficiency: dimensionless (0 to 1, or 0% to 100%).</p>
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js" crossorigin="anonymous"></script>
    <script src="<%=request.getContextPath()%>/physics/js/thermal-energy.js?v=<%=cacheVersion%>"></script>
</body>
</html>
