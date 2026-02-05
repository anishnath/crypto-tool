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
        <jsp:param name="toolName" value="Energy Conversion Formulas - Chemical, Electrical, Mechanical, Nuclear, Solar" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Energy conversion formulas for common devices: chemical→electrical (battery), electrical→mechanical (motor), mechanical→electrical (generator), gravitational→electrical (hydroelectric), chemical→thermal (combustion), nuclear→thermal (E=mc²), light→electrical (solar), electrical→light (LED). Free calculators." />
        <jsp:param name="toolUrl" value="physics/energy-conversions.jsp" />
        <jsp:param name="toolKeywords" value="energy conversion formulas, battery energy, electric motor power, generator energy, hydroelectric energy, nuclear energy E mc squared, solar cell efficiency, LED efficiency, physics energy conversion" />
        <jsp:param name="toolImage" value="energy-conversions.png" />
        <jsp:param name="toolFeatures" value="Battery energy calculator,Electric motor power calculator,Generator energy calculator,Hydroelectric energy calculator,Combustion heat calculator,Nuclear energy calculator,Solar efficiency calculator,LED efficiency calculator,Interactive visualization,Step-by-step solutions,Chart.js conversion efficiency,SI units" />
        <jsp:param name="faq1q" value="How is chemical energy converted to electrical energy in a battery?" />
        <jsp:param name="faq1a" value="Battery energy E = n F E° (simplified), where n is number of electrons, F is Faraday constant (96485 C/mol), and E° is standard cell potential (V). This represents Gibbs free energy." />
        <jsp:param name="faq2q" value="What is the power output of an electric motor?" />
        <jsp:param name="faq2a" value="Electric motor power P = τ ω, where τ is torque (N·m) and ω is angular speed (rad/s). This converts electrical energy to mechanical work." />
        <jsp:param name="faq3q" value="How does a generator convert mechanical to electrical energy?" />
        <jsp:param name="faq3a" value="Generator converts kinetic energy E = ½ m v² (or rotational KE) to electrical energy. In hydroelectric systems, gravitational PE (mgh) converts to KE, then to electrical." />
        <jsp:param name="faq4q" value="What is nuclear energy conversion?" />
        <jsp:param name="faq4a" value="Nuclear energy E = Δm c², where Δm is mass defect (kg) and c is speed of light (3×10⁸ m/s). This converts mass to thermal energy in fission/fusion reactions." />
        <jsp:param name="faq5q" value="How efficient are solar cells?" />
        <jsp:param name="faq5a" value="Solar cell efficiency η = P_out / P_in, where P_out is electrical power output and P_in is incident light power. Typical efficiencies range from 15-25% for silicon cells." />
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
        :root { --conv-green: #059669; --conv-blue: #0284c7; --conv-purple: #7c3aed; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #059669 0%, #0284c7 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(5,150,105,0.1), rgba(2,132,199,0.1)); border-left: 4px solid var(--conv-green); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #059669, #0284c7); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .conv-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .conv-tab { padding: 0.5rem 1rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .conv-tab:hover { border-color: var(--conv-green); color: var(--conv-green); }
        .conv-tab.active { background: linear-gradient(135deg, #059669, #0284c7); border-color: #0284c7; color: white; }
        .conv-panel { display: none; }
        .conv-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--conv-green); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #059669, #0284c7); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(5,150,105,0.15), rgba(2,132,199,0.1)); border: 2px solid var(--conv-green); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--conv-green); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #059669, #0284c7); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--conv-green); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(5,150,105,0.1), rgba(2,132,199,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .conv-viz-container { position: relative; width: 100%; height: 260px; background: linear-gradient(180deg, #ecfdf5 0%, #d1fae5 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .conv-viz-container, .dark-mode .conv-viz-container { background: linear-gradient(180deg, #064e3b 0%, #065f46 100%); }
        .conv-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .conv-viz-pills { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; }
        .conv-viz-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-md); }
        [data-theme="dark"] .conv-viz-pill, .dark-mode .conv-viz-pill { background: rgba(30,41,59,0.95); }
        .conv-chart-wrap { height: 200px; margin: 1rem; padding: 0 0.5rem; }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #059669, #7c3aed); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--conv-green); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--conv-green); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #059669; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--conv-green); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #059669; font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: #059669; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--conv-green); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } .conv-viz-container { height: 220px; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>⚙️</span> Specific Energy Conversion Formulas</h1>
            <p class="tool-page-description">Common devices &amp; processes: battery, motor, generator, hydroelectric, combustion, nuclear, solar, LED</p>
            <div class="tool-badges">
                <span class="tool-badge">E = nFE°</span>
                <span class="tool-badge">P = τω</span>
                <span class="tool-badge">E = ½mv²</span>
                <span class="tool-badge">E = Δmc²</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Energy conversions</div>
            <p>Energy can be converted between forms: chemical→electrical (batteries), electrical→mechanical (motors), mechanical→electrical (generators), gravitational→electrical (hydroelectric), chemical→thermal (combustion), nuclear→thermal (E=mc²), light→electrical (solar), electrical→light (LEDs).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Conversion calculators</h2>
                    <p>Battery, motor, generator, hydro, combustion, nuclear, solar, LED</p>
                </div>
                <div class="panel-body">
                    <div class="conv-tabs">
                        <button type="button" class="conv-tab active" data-tab="battery">Battery</button>
                        <button type="button" class="conv-tab" data-tab="motor">Motor</button>
                        <button type="button" class="conv-tab" data-tab="generator">Generator</button>
                        <button type="button" class="conv-tab" data-tab="hydro">Hydro</button>
                        <button type="button" class="conv-tab" data-tab="combustion">Combustion</button>
                        <button type="button" class="conv-tab" data-tab="nuclear">Nuclear</button>
                        <button type="button" class="conv-tab" data-tab="solar">Solar</button>
                        <button type="button" class="conv-tab" data-tab="led">LED</button>
                    </div>

                    <div id="panel-battery" class="conv-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Moles of electrons (n)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bat-n" class="number-input" value="2" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-radius: 0 10px 10px 0; font-size: 0.85rem;">mol</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Cell potential (E°)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bat-e0" class="number-input" value="1.5" min="0" step="any">
                                <select id="bat-e0-unit" class="unit-select">
                                    <option value="V">V</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEnergyConv()">Calculate Energy</button>
                        <div class="result-card" id="result-battery">
                            <div class="result-label">Battery energy</div>
                            <div class="result-value" id="bat-value">289.5 kJ</div>
                        </div>
                    </div>

                    <div id="panel-motor" class="conv-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Torque (τ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="mot-tau" class="number-input" value="10" min="0" step="any">
                                <select id="mot-tau-unit" class="unit-select">
                                    <option value="N·m">N·m</option>
                                    <option value="lb·ft">lb·ft</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Angular speed (ω)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="mot-omega" class="number-input" value="100" min="0" step="any">
                                <select id="mot-omega-unit" class="unit-select">
                                    <option value="rad/s">rad/s</option>
                                    <option value="rpm">rpm</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEnergyConv()">Calculate Power</button>
                        <div class="result-card" id="result-motor">
                            <div class="result-label">Motor power</div>
                            <div class="result-value" id="mot-value">1.0 kW</div>
                        </div>
                    </div>

                    <div id="panel-generator" class="conv-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Mass (m)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="gen-m" class="number-input" value="1000" min="0" step="any">
                                <select id="gen-m-unit" class="unit-select">
                                    <option value="kg">kg</option>
                                    <option value="g">g</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Speed (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="gen-v" class="number-input" value="10" min="0" step="any">
                                <select id="gen-v-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                    <option value="km/h">km/h</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEnergyConv()">Calculate Energy</button>
                        <div class="result-card" id="result-generator">
                            <div class="result-label">Kinetic energy</div>
                            <div class="result-value" id="gen-value">50 kJ</div>
                        </div>
                    </div>

                    <div id="panel-hydro" class="conv-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Mass (m)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="hyd-m" class="number-input" value="1000" min="0" step="any">
                                <select id="hyd-m-unit" class="unit-select">
                                    <option value="kg">kg</option>
                                    <option value="g">g</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Height (h)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="hyd-h" class="number-input" value="100" min="0" step="any">
                                <select id="hyd-h-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="ft">ft</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEnergyConv()">Calculate Energy</button>
                        <div class="result-card" id="result-hydro">
                            <div class="result-label">Gravitational PE</div>
                            <div class="result-value" id="hyd-value">980 kJ</div>
                        </div>
                    </div>

                    <div id="panel-combustion" class="conv-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Enthalpy change (ΔH)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="comb-dh" class="number-input" value="286" min="0" step="any">
                                <select id="comb-dh-unit" class="unit-select">
                                    <option value="kJ/mol">kJ/mol</option>
                                    <option value="J/mol">J/mol</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Moles (n)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="comb-n" class="number-input" value="1" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-radius: 0 10px 10px 0; font-size: 0.85rem;">mol</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEnergyConv()">Calculate Heat</button>
                        <div class="result-card" id="result-combustion">
                            <div class="result-label">Heat released</div>
                            <div class="result-value" id="comb-value">286 kJ</div>
                        </div>
                    </div>

                    <div id="panel-nuclear" class="conv-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Mass defect (Δm)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="nuc-dm" class="number-input" value="0.001" min="0" step="any">
                                <select id="nuc-dm-unit" class="unit-select">
                                    <option value="kg">kg</option>
                                    <option value="g">g</option>
                                    <option value="u">u</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEnergyConv()">Calculate Energy</button>
                        <div class="result-card" id="result-nuclear">
                            <div class="result-label">Nuclear energy</div>
                            <div class="result-value" id="nuc-value">89.9 TJ</div>
                        </div>
                    </div>

                    <div id="panel-solar" class="conv-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Power output (P_out)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="sol-pout" class="number-input" value="100" min="0" step="any">
                                <select id="sol-pout-unit" class="unit-select">
                                    <option value="W">W</option>
                                    <option value="kW">kW</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Power input (P_in)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="sol-pin" class="number-input" value="1000" min="0" step="any">
                                <select id="sol-pin-unit" class="unit-select">
                                    <option value="W">W</option>
                                    <option value="kW">kW</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEnergyConv()">Calculate Efficiency</button>
                        <div class="result-card" id="result-solar">
                            <div class="result-label">Solar efficiency</div>
                            <div class="result-value" id="sol-value">10.0%</div>
                        </div>
                    </div>

                    <div id="panel-led" class="conv-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Electrical power (P_elec)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="led-p" class="number-input" value="10" min="0" step="any">
                                <select id="led-p-unit" class="unit-select">
                                    <option value="W">W</option>
                                    <option value="mW">mW</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Luminous efficacy (lm/W)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="led-eff" class="number-input" value="100" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-radius: 0 10px 10px 0; font-size: 0.85rem;">lm/W</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runEnergyConv()">Calculate Light</button>
                        <div class="result-card" id="result-led">
                            <div class="result-label">Luminous flux</div>
                            <div class="result-value" id="led-value">1000 lm</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>⚙️ Conversion visualization</h3></div>
                    <div class="conv-viz-container" id="conv-viz-container">
                        <canvas class="conv-viz-canvas" id="conv-viz-canvas"></canvas>
                        <div class="conv-viz-pills" id="conv-viz-pills"></div>
                    </div>
                    <div class="conv-chart-wrap" id="conv-chart-wrap" style="display:none;">
                        <canvas id="conv-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleConvSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="conv-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="conv-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Energy conversion formulas for common devices">
                        <thead>
                            <tr>
                                <th>Conversion Type</th>
                                <th>Key Formula(s)</th>
                                <th>Example / Device</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Chemical → Electrical</td>
                                <td class="form-equation">E = n F E°</td>
                                <td class="form-desc">Battery (simplified)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Electrical → Mechanical</td>
                                <td class="form-equation">P = τ ω</td>
                                <td class="form-desc">Electric motor (torque × angular speed)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Mechanical → Electrical</td>
                                <td class="form-equation">E = ½ m v² → electrical</td>
                                <td class="form-desc">Hydroelectric / wind turbine</td>
                            </tr>
                            <tr>
                                <td class="form-name">Gravitational PE → Kinetic → Electrical</td>
                                <td class="form-equation">m g h → ½ m v² → electrical energy</td>
                                <td class="form-desc">Falling water in dam</td>
                            </tr>
                            <tr>
                                <td class="form-name">Chemical → Thermal</td>
                                <td class="form-equation">Q = ΔH</td>
                                <td class="form-desc">Combustion / burning fuel</td>
                            </tr>
                            <tr>
                                <td class="form-name">Nuclear → Thermal</td>
                                <td class="form-equation">E = Δm c²</td>
                                <td class="form-desc">Mass defect in fission/fusion</td>
                            </tr>
                            <tr>
                                <td class="form-name">Light → Electrical</td>
                                <td class="form-equation">Efficiency η = P_out / P_in</td>
                                <td class="form-desc">Solar cell / photovoltaic</td>
                            </tr>
                            <tr>
                                <td class="form-name">Electrical → Light</td>
                                <td class="form-equation">P = luminous efficacy × electrical power</td>
                                <td class="form-desc">LED / bulb (very approximate)</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About energy conversions</h2>
            <p>Energy conversions occur in everyday devices. Batteries convert chemical energy to electrical (E = n F E°). Motors convert electrical to mechanical (P = τ ω). Generators do the reverse, converting mechanical (KE = ½mv²) to electrical.</p>
            <h3>Renewable energy</h3>
            <p>Hydroelectric systems convert gravitational PE (mgh) to kinetic energy (½mv²), then to electrical. Wind turbines similarly convert wind KE to electrical energy.</p>
            <h3>Nuclear and solar</h3>
            <p>Nuclear reactions convert mass to energy via <strong>E = Δm c²</strong>. Solar cells convert light to electrical with efficiency <strong>η = P_out / P_in</strong>. LEDs convert electrical power to light with luminous efficacy (lm/W).</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/energy-conversions.js?v=<%=cacheVersion%>"></script>
</body>
</html>
