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
        <jsp:param name="toolName" value="Energy Calculator - KE, PE, Formulas & Storage (Fundamental Energy Types)" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Fundamental energy types and storage formulas: kinetic energy (KE = ½mv²), gravitational PE (mgh), elastic PE (½kx²), internal energy (ΔU = Q − W), and mechanical energy conservation. Free calculators and reference." />
        <jsp:param name="toolUrl" value="physics/energy-calculator.jsp" />
        <jsp:param name="toolKeywords" value="energy calculator, kinetic energy formula, potential energy formula, KE = 1/2 mv^2, mgh, elastic potential energy, mechanical energy conservation, thermodynamics internal energy, physics formulas" />
        <jsp:param name="toolImage" value="energy-calculator.png" />
        <jsp:param name="toolFeatures" value="Kinetic energy calculator,Gravitational PE calculator,Elastic PE calculator,Energy formulas reference,Interactive visualization,Step-by-step solutions,Multiple units (J kJ cal)" />
        <jsp:param name="faq1q" value="What is kinetic energy?" />
        <jsp:param name="faq1a" value="Kinetic energy (KE) is energy due to motion: KE = ½ m v², where m is mass (kg) and v is speed (m/s). SI unit: joule (J)." />
        <jsp:param name="faq2q" value="What is gravitational potential energy?" />
        <jsp:param name="faq2a" value="Gravitational potential energy (PE_g) is energy due to position in a gravitational field: PE_g = m g h, with m = mass (kg), g = 9.8 m/s², h = height (m). Unit: joule (J)." />
        <jsp:param name="faq3q" value="What is elastic potential energy?" />
        <jsp:param name="faq3a" value="Elastic potential energy is energy stored in springs or deformed objects: PE_elastic = ½ k x², where k = spring constant (N/m) and x = displacement (m)." />
        <jsp:param name="faq4q" value="What is the first law of thermodynamics (internal energy)?" />
        <jsp:param name="faq4a" value="Change in internal energy ΔU = Q − W: heat added to the system (Q) minus work done by the system (W). Both Q and W in joules (J)." />
        <jsp:param name="faq5q" value="When is total mechanical energy conserved?" />
        <jsp:param name="faq5a" value="In isolated systems with only conservative forces (e.g. gravity, ideal springs), E_total = KE + PE = constant. Friction and air resistance break conservation." />
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
        :root { --physics-blue: #2563eb; --physics-purple: #7c3aed; --physics-green: #059669; --physics-amber: #d97706; --physics-cyan: #0891b2; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #d97706 0%, #b45309 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(217,119,6,0.1), rgba(180,83,9,0.1)); border-left: 4px solid var(--physics-amber); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #d97706, #b45309); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--physics-amber); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #d97706, #b45309); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .energy-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .energy-tab { padding: 0.5rem 1rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .energy-tab:hover { border-color: var(--physics-amber); color: var(--physics-amber); }
        .energy-tab.active { background: linear-gradient(135deg, #d97706, #b45309); border-color: #b45309; color: white; }
        .energy-panel { display: none; }
        .energy-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--physics-amber); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #d97706, #b45309); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(217,119,6,0.15), rgba(180,83,9,0.1)); border: 2px solid var(--physics-amber); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--physics-amber); }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .edu-content ul { padding-left: 1.5rem; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--physics-amber); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .simulation-header { background: linear-gradient(135deg, rgba(217,119,6,0.1), rgba(180,83,9,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .energy-viz-container { position: relative; width: 100%; height: 280px; background: linear-gradient(180deg, #fffbeb 0%, #fef3c7 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .energy-viz-container, .dark-mode .energy-viz-container { background: linear-gradient(180deg, #1c1917 0%, #292524 100%); }
        .energy-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .energy-viz-pills { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; }
        .energy-viz-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-md); }
        [data-theme="dark"] .energy-viz-pill, .dark-mode .energy-viz-pill { background: rgba(30,41,59,0.95); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple)); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 380px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--physics-amber); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--physics-amber); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: var(--physics-blue); margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--physics-amber); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: var(--physics-green); font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: var(--physics-green); }
        .result-unit-row { margin-top: 0.5rem; }
        .result-unit-row select { margin-left: 0.5rem; padding: 0.25rem 0.5rem; border-radius: 6px; border: 1px solid var(--border-light); font-size: 0.85rem; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } .energy-viz-container { height: 220px; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🔋</span> Fundamental Energy Types & Storage Formulas</h1>
            <p class="tool-page-description">KE, gravitational PE, elastic PE, internal energy, and mechanical energy conservation</p>
            <div class="tool-badges">
                <span class="tool-badge">KE = ½mv²</span>
                <span class="tool-badge">PE_g = mgh</span>
                <span class="tool-badge">PE = ½kx²</span>
                <span class="tool-badge">ΔU = Q − W</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Energy in physics</div>
            <p>Energy can be stored or transferred. Kinetic energy (KE) is due to motion; potential energies (PE) are due to position or configuration. Internal energy (thermodynamics) changes with heat and work. In conservative systems, total mechanical energy E = KE + PE is constant.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Quick energy calculators</h2>
                    <p>Enter values — result in J, kJ, or cal (choose below)</p>
                </div>
                <div class="panel-body">
                    <div class="energy-tabs">
                        <button type="button" class="energy-tab active" data-tab="ke">KE</button>
                        <button type="button" class="energy-tab" data-tab="pe-g">PE_g</button>
                        <button type="button" class="energy-tab" data-tab="pe-elastic">PE_elastic</button>
                    </div>

                    <div id="panel-ke" class="energy-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>⚖️</span> Mass (m)</div>
                            <div class="input-with-unit">
                                <input type="number" id="ke-mass" class="number-input" value="10" min="0" step="any">
                                <select id="ke-mass-unit" class="unit-select">
                                    <option value="kg">kg</option>
                                    <option value="g">g</option>
                                    <option value="lb">lb</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>⚡</span> Speed (v)</div>
                            <div class="input-with-unit">
                                <input type="number" id="ke-velocity" class="number-input" value="5" min="0" step="any">
                                <select id="ke-velocity-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                    <option value="km/h">km/h</option>
                                    <option value="mph">mph</option>
                                    <option value="ft/s">ft/s</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="runAll()">Calculate KE</button>
                        <div class="result-card" id="result-ke">
                            <div class="result-label">Kinetic energy</div>
                            <div class="result-value" id="ke-value">125 J</div>
                            <div class="result-unit-row">Show in: <select id="out-unit-ke" onchange="runAll()"><option value="J">J</option><option value="kJ">kJ</option><option value="cal">cal</option></select></div>
                        </div>
                    </div>

                    <div id="panel-pe-g" class="energy-panel">
                        <div class="input-section">
                            <div class="input-label"><span>⚖️</span> Mass (m)</div>
                            <div class="input-with-unit">
                                <input type="number" id="peg-mass" class="number-input" value="2" min="0" step="any">
                                <select id="peg-mass-unit" class="unit-select">
                                    <option value="kg">kg</option>
                                    <option value="g">g</option>
                                    <option value="lb">lb</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>📏</span> Height (h)</div>
                            <div class="input-with-unit">
                                <input type="number" id="peg-height" class="number-input" value="10" min="0" step="any">
                                <select id="peg-height-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                    <option value="ft">ft</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>🌍</span> g (optional)</div>
                            <div class="input-with-unit">
                                <input type="number" id="peg-g" class="number-input" value="9.8" step="0.1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-radius: 0 10px 10px 0; font-size: 0.85rem;">m/s²</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="runAll()">Calculate PE_g</button>
                        <div class="result-card" id="result-peg">
                            <div class="result-label">Gravitational potential energy</div>
                            <div class="result-value" id="peg-value">196 J</div>
                            <div class="result-unit-row">Show in: <select id="out-unit-peg" onchange="runAll()"><option value="J">J</option><option value="kJ">kJ</option><option value="cal">cal</option></select></div>
                        </div>
                    </div>

                    <div id="panel-pe-elastic" class="energy-panel">
                        <div class="input-section">
                            <div class="input-label"><span>🌀</span> Spring constant (k)</div>
                            <div class="input-with-unit">
                                <input type="number" id="pel-k" class="number-input" value="100" min="0" step="any">
                                <select id="pel-k-unit" class="unit-select">
                                    <option value="N/m">N/m</option>
                                    <option value="kN/m">kN/m</option>
                                    <option value="lbf/in">lbf/in</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>📏</span> Displacement (x)</div>
                            <div class="input-with-unit">
                                <input type="number" id="pel-x" class="number-input" value="0.5" min="0" step="any">
                                <select id="pel-x-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="runAll()">Calculate PE_elastic</button>
                        <div class="result-card" id="result-pel">
                            <div class="result-label">Elastic potential energy</div>
                            <div class="result-value" id="pel-value">12.5 J</div>
                            <div class="result-unit-row">Show in: <select id="out-unit-pel" onchange="runAll()"><option value="J">J</option><option value="kJ">kJ</option><option value="cal">cal</option></select></div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>🔋 Energy visualization</h3></div>
                    <div class="energy-viz-container" id="energy-viz-container">
                        <canvas class="energy-viz-canvas" id="energy-viz-canvas"></canvas>
                        <div class="energy-viz-pills" id="energy-viz-pills"></div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="toggleSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Fundamental energy types and formulas">
                        <thead>
                            <tr>
                                <th>Energy form</th>
                                <th>Formula</th>
                                <th>Description / Units (SI)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Kinetic Energy (KE)</td>
                                <td class="form-equation">KE = ½ m v²</td>
                                <td class="form-desc">Energy due to motion. m = mass (kg), v = speed (m/s). Unit: joule (J).</td>
                            </tr>
                            <tr>
                                <td class="form-name">Gravitational Potential Energy (PE<sub>g</sub>)</td>
                                <td class="form-equation">PE<sub>g</sub> = m g h</td>
                                <td class="form-desc">Energy due to position in a gravitational field. m = mass (kg), g = 9.8 m/s², h = height (m). Unit: joule (J).</td>
                            </tr>
                            <tr>
                                <td class="form-name">Elastic Potential Energy (PE<sub>elastic</sub>)</td>
                                <td class="form-equation">PE<sub>elastic</sub> = ½ k x²</td>
                                <td class="form-desc">Energy stored in springs or deformed elastic objects. k = spring constant (N/m), x = displacement from equilibrium (m). Unit: joule (J).</td>
                            </tr>
                            <tr>
                                <td class="form-name">Internal Energy (thermodynamics)</td>
                                <td class="form-equation">ΔU = Q − W</td>
                                <td class="form-desc">Change in internal energy = heat added to system (Q) − work done by system (W). First law of thermodynamics. Units: J.</td>
                            </tr>
                            <tr>
                                <td class="form-name">Total Mechanical Energy (conserved if no non-conservative forces)</td>
                                <td class="form-equation">E<sub>total</sub> = KE + PE = constant</td>
                                <td class="form-desc">In isolated conservative systems (no friction, air resistance, etc.), total mechanical energy is constant. Unit: joule (J).</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About these energy formulas</h2>
            <p>These five expressions are among the most used in introductory physics and thermodynamics. Kinetic and potential energies are forms of mechanical energy; internal energy belongs to thermodynamics.</p>
            <h3>SI units</h3>
            <p>All energies are in <strong>joules (J)</strong>: 1 J = 1 N⋅m = 1 kg⋅m²/s². Mass in kg, speed in m/s, height and displacement in m, spring constant in N/m.</p>
            <h3>Conservation of energy</h3>
            <p>When only conservative forces (e.g. gravity, ideal spring) act, <strong>E_total = KE + PE</strong> stays constant. Non-conservative forces (friction, drag) convert mechanical energy into heat, so E_total is not conserved.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/energy-calculator.js?v=<%=cacheVersion%>"></script>
</body>
</html>
