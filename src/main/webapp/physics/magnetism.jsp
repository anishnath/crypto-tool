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
        <jsp:param name="toolName" value="Magnetism - Magnetic Field, Force, Torque, Flux, Magnetic Moment" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Magnetism formulas: magnetic field (B = μ₀I/(2πr)), force on wire (F = ILB sin θ), torque on loop (τ = mB sin θ), magnetic flux (Φ = BA cos θ), magnetic moment, cyclotron radius. Free calculators with Matter.js magnetic field visualizations." />
        <jsp:param name="toolUrl" value="physics/magnetism.jsp" />
        <jsp:param name="toolKeywords" value="magnetism, magnetic field, magnetic force, magnetic torque, magnetic flux, magnetic moment, Ampere law, Biot-Savart, solenoid, cyclotron, physics magnetism, JEE NEET" />
        <jsp:param name="toolImage" value="magnetism.png" />
        <jsp:param name="toolFeatures" value="Magnetic field calculator,Force on wire calculator,Torque on loop calculator,Magnetic flux calculator,Magnetic moment calculator,Cyclotron calculator,Matter.js field visualizations,Step-by-step solutions,SI units (T, Wb)" />
        <jsp:param name="faq1q" value="What is magnetic field?" />
        <jsp:param name="faq1a" value="Magnetic field B (Tesla) is force per unit charge-velocity. For straight wire: B = μ₀I/(2πr). For circular loop center: B = μ₀I/(2R). For solenoid: B = μ₀nI. Units: T = N/(A·m) = Wb/m²." />
        <jsp:param name="faq2q" value="What is force on current-carrying wire?" />
        <jsp:param name="faq2a" value="Force on wire: F = ILB sin θ, where I is current, L is length vector, B is magnetic field, θ is angle. Direction: right-hand rule. Force between parallel wires: F/L = μ₀I₁I₂/(2πd)." />
        <jsp:param name="faq3q" value="What is magnetic flux?" />
        <jsp:param name="faq3a" value="Magnetic flux Φ = B·A = BA cos θ (Weber). Scalar quantity. For coil: NΦ (linked flux). Faraday's law: EMF = -dΦ/dt. Units: Wb = T·m²." />
        <jsp:param name="faq4q" value="What is magnetic moment?" />
        <jsp:param name="faq4a" value="Magnetic moment m = IA (A·m²) for current loop. Direction perpendicular to plane (right-hand rule). Torque: τ = mB sin θ. Potential energy: U = -m·B = -mB cos θ." />
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
        :root { --magnetic-purple: #9333ea; --magnetic-violet: #7c3aed; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #9333ea 0%, #7c3aed 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(147,51,234,0.1), rgba(124,58,237,0.1)); border-left: 4px solid var(--magnetic-purple); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #9333ea, #7c3aed); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .fluid-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .fluid-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .fluid-tab:hover { border-color: var(--magnetic-purple); color: var(--magnetic-purple); }
        .fluid-tab.active { background: linear-gradient(135deg, #9333ea, #7c3aed); border-color: #7c3aed; color: white; }
        .fluid-panel { display: none; }
        .fluid-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--magnetic-purple); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #9333ea, #7c3aed); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(147,51,234,0.15), rgba(124,58,237,0.1)); border: 2px solid var(--magnetic-purple); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--magnetic-purple); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #9333ea, #7c3aed); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--magnetic-purple); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(147,51,234,0.1), rgba(124,58,237,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .fluid-viz-container { position: relative; width: 100%; height: 300px; background: linear-gradient(180deg, #f3e8ff 0%, #e9d5ff 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .fluid-viz-container, .dark-mode .fluid-viz-container { background: linear-gradient(180deg, #581c87 0%, #6b21a8 100%); }
        .fluid-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .fluid-viz-pills { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; }
        .fluid-viz-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-md); }
        [data-theme="dark"] .fluid-viz-pill, .dark-mode .fluid-viz-pill { background: rgba(30,41,59,0.95); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #9333ea, #7c3aed); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--magnetic-purple); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--magnetic-purple); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #9333ea; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--magnetic-purple); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #059669; font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: #059669; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--magnetic-purple); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } .fluid-viz-container { height: 250px; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🧲</span> Magnetism</h1>
            <p class="tool-page-description">Magnetic field, force, torque, flux, magnetic moment, cyclotron</p>
            <div class="tool-badges">
                <span class="tool-badge">B = μ₀I/(2πr)</span>
                <span class="tool-badge">F = ILB</span>
                <span class="tool-badge">τ = mB</span>
                <span class="tool-badge">Φ = BA</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Magnetism</div>
            <p>Magnetism studies magnetic fields and forces. Magnetic field B (Tesla) is produced by currents. Force on wire: F = ILB sin θ. Torque on loop: τ = mB sin θ. Magnetic flux: Φ = BA cos θ. Magnetic moment: m = IA. Cyclotron: r = mv/(qB), f = qB/(2πm).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Magnetism calculators</h2>
                    <p>Field, force, torque, flux, moment, cyclotron</p>
                </div>
                <div class="panel-body">
                    <div class="fluid-tabs">
                        <button type="button" class="fluid-tab active" data-tab="field" onclick="if(window.switchMagneticTab)window.switchMagneticTab('field',this);">Field</button>
                        <button type="button" class="fluid-tab" data-tab="force" onclick="if(window.switchMagneticTab)window.switchMagneticTab('force',this);">Force</button>
                        <button type="button" class="fluid-tab" data-tab="torque" onclick="if(window.switchMagneticTab)window.switchMagneticTab('torque',this);">Torque</button>
                        <button type="button" class="fluid-tab" data-tab="flux" onclick="if(window.switchMagneticTab)window.switchMagneticTab('flux',this);">Flux</button>
                        <button type="button" class="fluid-tab" data-tab="moment" onclick="if(window.switchMagneticTab)window.switchMagneticTab('moment',this);">Moment</button>
                        <button type="button" class="fluid-tab" data-tab="cyclotron" onclick="if(window.switchMagneticTab)window.switchMagneticTab('cyclotron',this);">Cyclotron</button>
                    </div>

                    <div id="panel-field" class="fluid-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Configuration</span></div>
                            <select id="field-type" class="number-input" style="border-radius: 10px;">
                                <option value="wire">Straight Wire</option>
                                <option value="loop">Circular Loop (center)</option>
                                <option value="solenoid">Solenoid</option>
                            </select>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Current (I)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="field-i" class="number-input" value="5" min="0" step="any">
                                <select id="field-i-unit" class="unit-select">
                                    <option value="A">A</option>
                                    <option value="mA">mA</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="field-r-section">
                            <div class="input-label"><span>Distance/Radius (r or R)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="field-r" class="number-input" value="0.1" min="0" step="any">
                                <select id="field-r-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="field-n-section" style="display: none;">
                            <div class="input-label"><span>Turns per unit length (n)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="field-n" class="number-input" value="1000" min="0" step="any">
                                <select id="field-n-unit" class="unit-select">
                                    <option value="turns/m">turns/m</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMagnetism()">Calculate Magnetic Field</button>
                        <div class="result-card" id="result-field">
                            <div class="result-label">Magnetic Field</div>
                            <div class="result-value" id="field-result">1.00×10⁻⁵ T</div>
                        </div>
                    </div>

                    <div id="panel-force" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Current (I)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="force-i" class="number-input" value="2" min="0" step="any">
                                <select id="force-i-unit" class="unit-select">
                                    <option value="A">A</option>
                                    <option value="mA">mA</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Length (L)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="force-l" class="number-input" value="0.5" min="0" step="any">
                                <select id="force-l-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Magnetic Field (B)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="force-b" class="number-input" value="0.01" min="0" step="any">
                                <select id="force-b-unit" class="unit-select">
                                    <option value="T">T</option>
                                    <option value="mT">mT</option>
                                    <option value="G">G</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Angle (θ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="force-theta" class="number-input" value="90" min="0" max="180" step="any">
                                <select id="force-theta-unit" class="unit-select">
                                    <option value="deg">deg</option>
                                    <option value="rad">rad</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMagnetism()">Calculate Force</button>
                        <div class="result-card" id="result-force">
                            <div class="result-label">Force</div>
                            <div class="result-value" id="force-result">0.01 N</div>
                        </div>
                    </div>

                    <div id="panel-torque" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Current (I)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="torque-i" class="number-input" value="1" min="0" step="any">
                                <select id="torque-i-unit" class="unit-select">
                                    <option value="A">A</option>
                                    <option value="mA">mA</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area (A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="torque-a" class="number-input" value="0.01" min="0" step="any">
                                <select id="torque-a-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Magnetic Field (B)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="torque-b" class="number-input" value="0.01" min="0" step="any">
                                <select id="torque-b-unit" class="unit-select">
                                    <option value="T">T</option>
                                    <option value="mT">mT</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Angle (θ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="torque-theta" class="number-input" value="90" min="0" max="180" step="any">
                                <select id="torque-theta-unit" class="unit-select">
                                    <option value="deg">deg</option>
                                    <option value="rad">rad</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMagnetism()">Calculate Torque</button>
                        <div class="result-card" id="result-torque">
                            <div class="result-label">Torque</div>
                            <div class="result-value" id="torque-result">1.00×10⁻⁵ N·m</div>
                        </div>
                    </div>

                    <div id="panel-flux" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Magnetic Field (B)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="flux-b" class="number-input" value="0.01" min="0" step="any">
                                <select id="flux-b-unit" class="unit-select">
                                    <option value="T">T</option>
                                    <option value="mT">mT</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area (A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="flux-a" class="number-input" value="0.01" min="0" step="any">
                                <select id="flux-a-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Angle (θ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="flux-theta" class="number-input" value="0" min="0" max="180" step="any">
                                <select id="flux-theta-unit" class="unit-select">
                                    <option value="deg">deg</option>
                                    <option value="rad">rad</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Number of turns (N)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="flux-n" class="number-input" value="1" min="1" step="1">
                                <select id="flux-n-unit" class="unit-select" disabled>
                                    <option value="turns">turns</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMagnetism()">Calculate Flux</button>
                        <div class="result-card" id="result-flux">
                            <div class="result-label">Magnetic Flux</div>
                            <div class="result-value" id="flux-result">1.00×10⁻⁴ Wb</div>
                        </div>
                    </div>

                    <div id="panel-moment" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Current (I)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="moment-i" class="number-input" value="1" min="0" step="any">
                                <select id="moment-i-unit" class="unit-select">
                                    <option value="A">A</option>
                                    <option value="mA">mA</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area (A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="moment-a" class="number-input" value="0.01" min="0" step="any">
                                <select id="moment-a-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMagnetism()">Calculate Magnetic Moment</button>
                        <div class="result-card" id="result-moment">
                            <div class="result-label">Magnetic Moment</div>
                            <div class="result-value" id="moment-result">0.01 A·m²</div>
                        </div>
                    </div>

                    <div id="panel-cyclotron" class="fluid-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Calculate</span></div>
                            <select id="cyclo-type" class="number-input" style="border-radius: 10px;">
                                <option value="radius">Radius</option>
                                <option value="frequency">Frequency</option>
                            </select>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Mass (m)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cyclo-m" class="number-input" value="9.11e-31" min="0" step="any">
                                <select id="cyclo-m-unit" class="unit-select">
                                    <option value="kg">kg</option>
                                    <option value="g">g</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Charge (q)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cyclo-q" class="number-input" value="1.6e-19" min="0" step="any">
                                <select id="cyclo-q-unit" class="unit-select">
                                    <option value="C">C</option>
                                    <option value="e">e</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Magnetic Field (B)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cyclo-b" class="number-input" value="0.01" min="0" step="any">
                                <select id="cyclo-b-unit" class="unit-select">
                                    <option value="T">T</option>
                                    <option value="mT">mT</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="cyclo-v-section">
                            <div class="input-label"><span>Velocity (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cyclo-v" class="number-input" value="1e6" min="0" step="any">
                                <select id="cyclo-v-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runMagnetism()">Calculate</button>
                        <div class="result-card" id="result-cyclotron">
                            <div class="result-label" id="cyclo-result-label">Radius</div>
                            <div class="result-value" id="cyclo-result">5.69×10⁻⁴ m</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>🧲 Magnetic field visualization</h3></div>
                    <div class="fluid-viz-container" id="fluid-viz-container">
                        <canvas class="fluid-viz-canvas" id="fluid-viz-canvas"></canvas>
                        <div class="fluid-viz-pills" id="fluid-viz-pills"></div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleMagneticSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="magnetic-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="magnetic-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Magnetism formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes / Units / Conditions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Magnetic field (wire)</td>
                                <td class="form-equation">B = μ₀ I / (2 π r)</td>
                                <td class="form-desc">At perpendicular distance r</td>
                            </tr>
                            <tr>
                                <td class="form-name">Magnetic field (loop center)</td>
                                <td class="form-equation">B = μ₀ I / (2 R)</td>
                                <td class="form-desc">At center of circular loop</td>
                            </tr>
                            <tr>
                                <td class="form-name">Magnetic field (solenoid)</td>
                                <td class="form-equation">B = μ₀ n I</td>
                                <td class="form-desc">n = turns per unit length</td>
                            </tr>
                            <tr>
                                <td class="form-name">Force on wire</td>
                                <td class="form-equation">F = I L B sin θ</td>
                                <td class="form-desc">L = length vector</td>
                            </tr>
                            <tr>
                                <td class="form-name">Torque on loop</td>
                                <td class="form-equation">τ = m B sin θ</td>
                                <td class="form-desc">m = I A (magnetic moment)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Magnetic flux</td>
                                <td class="form-equation">Φ = B A cos θ</td>
                                <td class="form-desc">Weber (Wb = T·m²)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Magnetic moment</td>
                                <td class="form-equation">m = I A</td>
                                <td class="form-desc">A·m², direction by right-hand rule</td>
                            </tr>
                            <tr>
                                <td class="form-name">Cyclotron radius</td>
                                <td class="form-equation">r = m v / (q B)</td>
                                <td class="form-desc">Charged particle in B field</td>
                            </tr>
                            <tr>
                                <td class="form-name">Cyclotron frequency</td>
                                <td class="form-equation">f = q B / (2 π m)</td>
                                <td class="form-desc">Independent of velocity</td>
                            </tr>
                            <tr>
                                <td class="form-name">Force between wires</td>
                                <td class="form-equation">F/L = μ₀ I₁ I₂ / (2 π d)</td>
                                <td class="form-desc">Definition of 1 ampere</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About Magnetism</h2>
            <p>Magnetism studies magnetic fields and forces. Magnetic field B (Tesla) is produced by electric currents. Force on current-carrying wire: F = ILB sin θ. Torque on magnetic dipole: τ = mB sin θ. Magnetic flux: Φ = BA cos θ.</p>
            
            <h3>Magnetic Field</h3>
            <p><strong>Magnetic field B</strong> (Tesla = N/(A·m) = Wb/m²) is force per unit charge-velocity. For straight wire: B = μ₀I/(2πr). For circular loop center: B = μ₀I/(2R). For solenoid: B = μ₀nI, where n is turns per unit length. μ₀ = 4π × 10⁻⁷ T·m/A.</p>
            
            <h3>Force and Torque</h3>
            <p><strong>Force on wire:</strong> F = ILB sin θ, where I is current, L is length vector, B is magnetic field, θ is angle. Direction: right-hand rule. <strong>Torque on loop:</strong> τ = mB sin θ, where m = IA is magnetic moment. Tends to align with field.</p>
            
            <h3>Magnetic Flux and Moment</h3>
            <p><strong>Magnetic flux</strong> Φ = B·A = BA cos θ (Weber = T·m²). Scalar quantity. For coil: NΦ (linked flux). Faraday's law: EMF = -dΦ/dt. <strong>Magnetic moment</strong> m = IA (A·m²) for current loop. Direction perpendicular to plane (right-hand rule).</p>
            
            <h3>Cyclotron Motion</h3>
            <p><strong>Cyclotron radius:</strong> r = mv/(qB) for charged particle in magnetic field. <strong>Cyclotron frequency:</strong> f = qB/(2πm), independent of velocity. Used in particle accelerators and mass spectrometers.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/magnetism.js?v=<%=cacheVersion%>"></script>
</body>
</html>
