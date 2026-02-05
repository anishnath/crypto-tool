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
        <jsp:param name="toolName" value="Electrical Energy Conversions - E = VIt, P = VI, Capacitor & Inductor Energy" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Electrical energy and power formulas: E = V I t, P = V I = I²R = V²/R, Joule heating (I²Rt), capacitor energy (½CV²), inductor energy (½LI²). Free calculators and reference." />
        <jsp:param name="toolUrl" value="physics/electrical-energy.jsp" />
        <jsp:param name="toolKeywords" value="electrical energy formula, electrical power formula, E VIt, P VI, capacitor energy, inductor energy, Joule heating, I squared R t, physics electricity" />
        <jsp:param name="toolImage" value="electrical-energy.png" />
        <jsp:param name="toolFeatures" value="Electrical energy calculator,Electrical power calculator,Capacitor energy calculator,Inductor energy calculator,Joule heating calculator,Interactive visualization,Step-by-step solutions,Chart.js power vs time,SI units (J, W, V, A)" />
        <jsp:param name="faq1q" value="What is the formula for electrical energy?" />
        <jsp:param name="faq1a" value="Electrical energy E = V I t, where V is voltage (V), I is current (A), and t is time (s). Unit: joule (J)." />
        <jsp:param name="faq2q" value="What is electrical power?" />
        <jsp:param name="faq2a" value="Electrical power P = V I = I² R = V² / R. It represents the rate of energy transfer. SI unit: watt (W)." />
        <jsp:param name="faq3q" value="How is energy stored in a capacitor?" />
        <jsp:param name="faq3a" value="Energy stored in a capacitor is E = ½ C V², where C is capacitance (F) and V is voltage (V). This energy is stored in the electric field." />
        <jsp:param name="faq4q" value="What is Joule heating?" />
        <jsp:param name="faq4a" value="Joule heating is energy dissipated as heat in a resistor: E = I² R t, where I is current (A), R is resistance (Ω), and t is time (s)." />
        <jsp:param name="faq5q" value="How is energy stored in an inductor?" />
        <jsp:param name="faq5a" value="Energy stored in an inductor is E = ½ L I², where L is inductance (H) and I is current (A). This energy is stored in the magnetic field." />
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
        :root { --elec-blue: #2563eb; --elec-yellow: #eab308; --elec-purple: #9333ea; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #2563eb 0%, #9333ea 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(37,99,235,0.1), rgba(147,51,234,0.1)); border-left: 4px solid var(--elec-blue); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #2563eb, #9333ea); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .elec-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .elec-tab { padding: 0.5rem 1rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .elec-tab:hover { border-color: var(--elec-blue); color: var(--elec-blue); }
        .elec-tab.active { background: linear-gradient(135deg, #2563eb, #9333ea); border-color: #9333ea; color: white; }
        .elec-panel { display: none; }
        .elec-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--elec-blue); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #2563eb, #9333ea); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(37,99,235,0.15), rgba(147,51,234,0.1)); border: 2px solid var(--elec-blue); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--elec-blue); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #2563eb, #9333ea); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--elec-blue); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(37,99,235,0.1), rgba(147,51,234,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .elec-viz-container { position: relative; width: 100%; height: 260px; background: linear-gradient(180deg, #eff6ff 0%, #dbeafe 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .elec-viz-container, .dark-mode .elec-viz-container { background: linear-gradient(180deg, #1e3a8a 0%, #312e81 100%); }
        .elec-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .elec-viz-pills { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; }
        .elec-viz-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-md); }
        [data-theme="dark"] .elec-viz-pill, .dark-mode .elec-viz-pill { background: rgba(30,41,59,0.95); }
        .elec-chart-wrap { height: 200px; margin: 1rem; padding: 0 0.5rem; }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #2563eb, #7c3aed); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--elec-blue); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--elec-blue); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #2563eb; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--elec-blue); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #059669; font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: #059669; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--elec-blue); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } .elec-viz-container { height: 220px; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>⚡</span> Electrical Energy Conversions</h1>
            <p class="tool-page-description">E = VIt, P = VI, capacitor &amp; inductor energy, Joule heating</p>
            <div class="tool-badges">
                <span class="tool-badge">E = V I t</span>
                <span class="tool-badge">P = V I</span>
                <span class="tool-badge">E = ½CV²</span>
                <span class="tool-badge">E = ½LI²</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Electrical energy and power</div>
            <p>Electrical energy E = V I t is energy transferred by voltage and current over time. Power P = V I is the rate of energy transfer. Energy can be stored in capacitors (electric field) and inductors (magnetic field).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Electrical calculators</h2>
                    <p>E = VIt, P = VI, capacitor, inductor, Joule heating</p>
                </div>
                <div class="panel-body">
                    <div class="elec-tabs">
                        <button type="button" class="elec-tab active" data-tab="energy">E = VIt</button>
                        <button type="button" class="elec-tab" data-tab="power">P = VI</button>
                        <button type="button" class="elec-tab" data-tab="capacitor">Capacitor</button>
                        <button type="button" class="elec-tab" data-tab="inductor">Inductor</button>
                        <button type="button" class="elec-tab" data-tab="joule">Joule</button>
                    </div>

                    <div id="panel-energy" class="elec-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Voltage (V)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-v" class="number-input" value="12" min="0" step="any">
                                <select id="energy-v-unit" class="unit-select">
                                    <option value="V">V</option>
                                    <option value="kV">kV</option>
                                    <option value="mV">mV</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Current (I)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-i" class="number-input" value="2" min="0" step="any">
                                <select id="energy-i-unit" class="unit-select">
                                    <option value="A">A</option>
                                    <option value="mA">mA</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Time (t)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-t" class="number-input" value="10" min="0" step="any">
                                <select id="energy-t-unit" class="unit-select">
                                    <option value="s">s</option>
                                    <option value="min">min</option>
                                    <option value="h">h</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElecEnergy()">Calculate Energy</button>
                        <div class="result-card" id="result-energy">
                            <div class="result-label">Electrical energy</div>
                            <div class="result-value" id="energy-value">240 J</div>
                        </div>
                    </div>

                    <div id="panel-power" class="elec-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Voltage (V)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="power-v" class="number-input" value="12" min="0" step="any">
                                <select id="power-v-unit" class="unit-select">
                                    <option value="V">V</option>
                                    <option value="kV">kV</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Current (I)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="power-i" class="number-input" value="2" min="0" step="any">
                                <select id="power-i-unit" class="unit-select">
                                    <option value="A">A</option>
                                    <option value="mA">mA</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElecEnergy()">Calculate Power</button>
                        <div class="result-card" id="result-power">
                            <div class="result-label">Electrical power</div>
                            <div class="result-value" id="power-value">24 W</div>
                        </div>
                    </div>

                    <div id="panel-capacitor" class="elec-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Capacitance (C)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cap-c" class="number-input" value="100" min="0" step="any">
                                <select id="cap-c-unit" class="unit-select">
                                    <option value="F">F</option>
                                    <option value="mF">mF</option>
                                    <option value="μF">μF</option>
                                    <option value="nF">nF</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Voltage (V)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cap-v" class="number-input" value="12" min="0" step="any">
                                <select id="cap-v-unit" class="unit-select">
                                    <option value="V">V</option>
                                    <option value="kV">kV</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElecEnergy()">Calculate Energy</button>
                        <div class="result-card" id="result-capacitor">
                            <div class="result-label">Capacitor energy</div>
                            <div class="result-value" id="cap-value">7.2 mJ</div>
                        </div>
                    </div>

                    <div id="panel-inductor" class="elec-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Inductance (L)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="ind-l" class="number-input" value="0.1" min="0" step="any">
                                <select id="ind-l-unit" class="unit-select">
                                    <option value="H">H</option>
                                    <option value="mH">mH</option>
                                    <option value="μH">μH</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Current (I)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="ind-i" class="number-input" value="2" min="0" step="any">
                                <select id="ind-i-unit" class="unit-select">
                                    <option value="A">A</option>
                                    <option value="mA">mA</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElecEnergy()">Calculate Energy</button>
                        <div class="result-card" id="result-inductor">
                            <div class="result-label">Inductor energy</div>
                            <div class="result-value" id="ind-value">0.2 J</div>
                        </div>
                    </div>

                    <div id="panel-joule" class="elec-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Current (I)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="joule-i" class="number-input" value="2" min="0" step="any">
                                <select id="joule-i-unit" class="unit-select">
                                    <option value="A">A</option>
                                    <option value="mA">mA</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Resistance (R)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="joule-r" class="number-input" value="10" min="0" step="any">
                                <select id="joule-r-unit" class="unit-select">
                                    <option value="Ω">Ω</option>
                                    <option value="kΩ">kΩ</option>
                                    <option value="MΩ">MΩ</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Time (t)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="joule-t" class="number-input" value="10" min="0" step="any">
                                <select id="joule-t-unit" class="unit-select">
                                    <option value="s">s</option>
                                    <option value="min">min</option>
                                    <option value="h">h</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElecEnergy()">Calculate Heat</button>
                        <div class="result-card" id="result-joule">
                            <div class="result-label">Joule heating</div>
                            <div class="result-value" id="joule-value">400 J</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>⚡ Electrical visualization</h3></div>
                    <div class="elec-viz-container" id="elec-viz-container">
                        <canvas class="elec-viz-canvas" id="elec-viz-canvas"></canvas>
                        <div class="elec-viz-pills" id="elec-viz-pills"></div>
                    </div>
                    <div class="elec-chart-wrap" id="elec-chart-wrap" style="display:none;">
                        <canvas id="elec-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleElecSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="elec-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="elec-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Electrical energy conversion formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Typical Use</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Electrical energy</td>
                                <td class="form-equation">E = V I t</td>
                                <td class="form-desc">Energy = voltage × current × time</td>
                            </tr>
                            <tr>
                                <td class="form-name">Electrical power</td>
                                <td class="form-equation">P = V I = I² R = V² / R</td>
                                <td class="form-desc">Joule heating / power dissipation</td>
                            </tr>
                            <tr>
                                <td class="form-name">Energy dissipated as heat in resistor</td>
                                <td class="form-equation">E = I² R t</td>
                                <td class="form-desc">Joule's law</td>
                            </tr>
                            <tr>
                                <td class="form-name">Energy in capacitor</td>
                                <td class="form-equation">E = ½ C V²</td>
                                <td class="form-desc">Stored in electric field</td>
                            </tr>
                            <tr>
                                <td class="form-name">Energy in inductor</td>
                                <td class="form-equation">E = ½ L I²</td>
                                <td class="form-desc">Stored in magnetic field</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About electrical energy</h2>
            <p>Electrical energy E = V I t represents energy transferred by voltage and current over time. Power P = V I is the instantaneous rate of energy transfer. In resistors, energy is dissipated as heat (Joule heating: E = I² R t).</p>
            <h3>Energy storage</h3>
            <p>Capacitors store energy in electric fields: <strong>E = ½ C V²</strong>. Inductors store energy in magnetic fields: <strong>E = ½ L I²</strong>. Both can release this stored energy back into circuits.</p>
            <h3>SI units</h3>
            <p>Energy: joule (J). Power: watt (W) = J/s. Voltage: volt (V). Current: ampere (A). Resistance: ohm (Ω). Capacitance: farad (F). Inductance: henry (H).</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/electrical-energy.js?v=<%=cacheVersion%>"></script>
</body>
</html>
