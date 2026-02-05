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
        <jsp:param name="toolName" value="Torque Calculator - Rotational Force (τ = rF sin θ)" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Calculate torque (moment of force) using τ = rF sin θ. Includes angular acceleration, moment of inertia calculations with interactive lever arm visualization." />
        <jsp:param name="toolUrl" value="physics/torque-calculator.jsp" />
        <jsp:param name="toolKeywords" value="torque calculator, moment of force, τ=rF sinθ, rotational force, lever arm, angular acceleration, moment of inertia, physics calculator, wrench torque" />
        <jsp:param name="toolImage" value="torque-calculator.png" />
        <jsp:param name="toolFeatures" value="τ=rF sinθ calculator,Angular acceleration,Moment of inertia,Lever arm visualization,Step-by-step solutions,Unit conversions" />
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
        :root { --physics-blue: #2563eb; --physics-purple: #7c3aed; --physics-green: #059669; --physics-amber: #d97706; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
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
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 400px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(217,119,6,0.1), rgba(180,83,9,0.1)); border-left: 4px solid var(--physics-amber); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #d97706, #b45309); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .solve-for-section { background: var(--surface-2); border-radius: 12px; padding: 1rem; margin-bottom: 1.25rem; border: 1px solid var(--border-light); }
        .solve-for-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.75rem; display: block; }
        .solve-for-btns { display: flex; gap: 0.5rem; flex-wrap: wrap; }
        .solve-btn { flex: 1; min-width: 70px; padding: 0.625rem 0.75rem; background: var(--surface-1); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.8rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .solve-btn:hover { border-color: var(--physics-amber); color: var(--physics-amber); }
        .solve-btn.active { background: var(--physics-amber); border-color: var(--physics-amber); color: white; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--physics-amber); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .angle-section { margin-bottom: 1.25rem; }
        .angle-display { font-size: 1.5rem; font-weight: 800; color: var(--physics-amber); font-family: 'JetBrains Mono', monospace; text-align: center; margin-bottom: 0.5rem; }
        .angle-slider { width: 100%; height: 8px; -webkit-appearance: none; background: linear-gradient(to right, #d97706, #b45309); border-radius: 4px; }
        .angle-slider::-webkit-slider-thumb { -webkit-appearance: none; width: 20px; height: 20px; background: white; border: 3px solid #d97706; border-radius: 50%; cursor: pointer; }
        .angle-presets { display: flex; gap: 0.5rem; margin-top: 0.75rem; flex-wrap: wrap; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #d97706, #b45309); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); display: flex; align-items: center; justify-content: center; gap: 0.5rem; }
        .calc-btn:hover { transform: translateY(-2px); }
        .results-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.75rem; margin-top: 1.5rem; }
        .result-card { background: var(--surface-2); border-radius: 12px; padding: 1rem; text-align: center; border: 1px solid var(--border-light); }
        .result-card.highlight { background: linear-gradient(135deg, #d97706, #b45309); color: white; border: none; grid-column: span 2; }
        .result-icon { font-size: 1.5rem; margin-bottom: 0.5rem; }
        .result-label { font-size: 0.7rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.8; margin-bottom: 0.25rem; }
        .result-value { font-size: 1.1rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; }
        .result-card:not(.highlight) .result-value { color: var(--text-primary); }
        .examples-section { margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid var(--border-light); }
        .examples-section h4 { margin: 0 0 1rem; font-size: 0.9rem; color: var(--text-primary); }
        .examples-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.75rem; }
        .example-card { background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 10px; padding: 0.75rem; cursor: pointer; transition: all 0.2s; text-align: center; }
        .example-card:hover { border-color: var(--physics-amber); transform: translateY(-2px); }
        .example-icon { font-size: 1.5rem; margin-bottom: 0.25rem; }
        .example-title { font-size: 0.8rem; font-weight: 600; color: var(--text-primary); }
        .example-desc { font-size: 0.7rem; color: var(--text-secondary); }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .simulation-header { background: linear-gradient(135deg, rgba(217,119,6,0.1), rgba(180,83,9,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .torque-container { position: relative; width: 100%; height: 320px; background: linear-gradient(180deg, #fffbeb 0%, #fef3c7 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .torque-container, .dark-mode .torque-container { background: linear-gradient(180deg, #451a03 0%, #0f172a 100%); }
        .torque-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .torque-info { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; }
        .torque-info-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: 0 1px 2px rgba(0,0,0,0.1); }
        [data-theme="dark"] .torque-info-pill, .dark-mode .torque-info-pill { background: rgba(30,41,59,0.95); }
        .formula-section { padding: 1rem; border-top: 1px solid var(--border-light); }
        .formula-section h4 { margin: 0 0 1rem; font-size: 0.9rem; color: var(--text-primary); }
        .formula-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 0.75rem; }
        .formula-card { background: var(--surface-2); border-radius: 10px; padding: 1rem; border: 1px solid var(--border-light); }
        .formula-code { font-family: 'JetBrains Mono', monospace; font-size: 0.95rem; font-weight: 700; color: var(--physics-amber); margin-bottom: 0.25rem; }
        .formula-name { font-size: 0.7rem; color: var(--text-secondary); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple)); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 400px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--physics-amber); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--physics-amber); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: var(--physics-blue); margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--physics-amber); font-weight: 700; }
        .step-result { background: linear-gradient(135deg, rgba(5,150,105,0.1), rgba(16,185,129,0.1)); border: 1px solid rgba(5,150,105,0.3); border-radius: 8px; padding: 0.75rem; margin-top: 0.5rem; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: var(--physics-green); font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1.1rem; font-weight: 700; color: var(--physics-green); }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .edu-content ul { padding-left: 1.5rem; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .torque-container { height: 260px; } .results-grid { grid-template-columns: 1fr; } .result-card.highlight { grid-column: span 1; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🔧</span> Torque Calculator</h1>
            <p class="tool-page-description">Calculate rotational force and moment of force</p>
            <div class="tool-badges">
                <span class="tool-badge">τ = rF sin θ</span>
                <span class="tool-badge">τ = Iα</span>
                <span class="tool-badge">Lever Arm</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Torque (Moment of Force)</div>
            <p><strong>τ = rF sin θ</strong> — Torque is the rotational equivalent of force. It depends on the force magnitude, the distance from the pivot point, and the angle at which the force is applied.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Torque Calculator</h2>
                    <p>Configure lever arm and force</p>
                </div>
                <div class="panel-body">
                    <div class="solve-for-section">
                        <span class="solve-for-label">Solve for:</span>
                        <div class="solve-for-btns">
                            <button class="solve-btn active" onclick="setSolveFor('torque')" data-var="torque">Torque (τ)</button>
                            <button class="solve-btn" onclick="setSolveFor('force')" data-var="force">Force (F)</button>
                            <button class="solve-btn" onclick="setSolveFor('radius')" data-var="radius">Distance (r)</button>
                        </div>
                    </div>

                    <div class="input-section" id="radius-section">
                        <div class="input-label"><span>📏</span><span>Lever Arm Distance (r)</span></div>
                        <div class="input-with-unit">
                            <input type="number" id="radius" class="number-input" value="0.3" min="0.001" step="0.01">
                            <select id="radius-unit" class="unit-select" onchange="calculate()">
                                <option value="m" selected>m</option>
                                <option value="cm">cm</option>
                                <option value="in">in</option>
                                <option value="ft">ft</option>
                            </select>
                        </div>
                    </div>

                    <div class="input-section" id="force-section">
                        <div class="input-label"><span>💪</span><span>Applied Force (F)</span></div>
                        <div class="input-with-unit">
                            <input type="number" id="force" class="number-input" value="100" min="0.1" step="1">
                            <select id="force-unit" class="unit-select" onchange="calculate()">
                                <option value="N" selected>N</option>
                                <option value="kN">kN</option>
                                <option value="lbf">lbf</option>
                            </select>
                        </div>
                    </div>

                    <div class="input-section" id="torque-section" style="display: none;">
                        <div class="input-label"><span>🔧</span><span>Torque (τ)</span></div>
                        <div class="input-with-unit">
                            <input type="number" id="torque" class="number-input" value="30" min="0.1" step="1">
                            <select id="torque-unit" class="unit-select" onchange="calculate()">
                                <option value="N·m" selected>N·m</option>
                                <option value="lb·ft">lb·ft</option>
                                <option value="lb·in">lb·in</option>
                            </select>
                        </div>
                    </div>

                    <div class="angle-section">
                        <div class="input-label"><span>📐</span><span>Angle (θ)</span></div>
                        <div class="angle-display" id="angle-display">90°</div>
                        <input type="range" id="angle" class="angle-slider" min="0" max="180" value="90" oninput="updateAngle()">
                        <div class="angle-presets">
                            <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.75rem;" onclick="setAngle(30)">30°</button>
                            <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.75rem;" onclick="setAngle(45)">45°</button>
                            <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.75rem;" onclick="setAngle(90)">90° ⭐</button>
                            <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.75rem;" onclick="setAngle(135)">135°</button>
                        </div>
                    </div>

                    <button class="calc-btn" onclick="calculate()"><span>⚡</span><span>Calculate</span></button>

                    <div class="results-grid">
                        <div class="result-card highlight">
                            <div class="result-icon">🔧</div>
                            <div class="result-label">Torque</div>
                            <div class="result-value" id="result-torque">30.00 N·m</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">📏</div>
                            <div class="result-label">Lever Arm</div>
                            <div class="result-value" id="result-lever">0.30 m</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">💪</div>
                            <div class="result-label">Effective Force</div>
                            <div class="result-value" id="result-eff-force">100.0 N</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">📐</div>
                            <div class="result-label">sin(θ)</div>
                            <div class="result-value" id="result-sin">1.000</div>
                        </div>
                    </div>

                    <div class="examples-section">
                        <h4>📚 Try These Examples</h4>
                        <div class="examples-grid">
                            <div class="example-card" onclick="loadExample(1)">
                                <div class="example-icon">🔩</div>
                                <div class="example-title">Wrench Bolt</div>
                                <div class="example-desc">25cm, 150N @ 90°</div>
                            </div>
                            <div class="example-card" onclick="loadExample(2)">
                                <div class="example-icon">🚪</div>
                                <div class="example-title">Door Handle</div>
                                <div class="example-desc">80cm, 20N @ 90°</div>
                            </div>
                            <div class="example-card" onclick="loadExample(3)">
                                <div class="example-icon">🚗</div>
                                <div class="example-title">Lug Nut</div>
                                <div class="example-desc">45cm, 220N @ 90°</div>
                            </div>
                            <div class="example-card" onclick="loadExample(4)">
                                <div class="example-icon">🔨</div>
                                <div class="example-title">Hammer Pull</div>
                                <div class="example-desc">30cm, 50N @ 60°</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="simulation-panel">
                <div class="simulation-header"><h3>🔧 Lever Arm Visualization</h3></div>
                <div class="torque-container" id="torque-container">
                    <canvas class="torque-canvas" id="torque-canvas"></canvas>
                    <div class="torque-info">
                        <div class="torque-info-pill" id="info-r">r = 0.30 m</div>
                        <div class="torque-info-pill" id="info-f">F = 100 N</div>
                        <div class="torque-info-pill" id="info-tau">τ = 30 N·m</div>
                    </div>
                </div>

                <div class="formula-section">
                    <h4>📝 Torque Formulas</h4>
                    <div class="formula-grid">
                        <div class="formula-card"><div class="formula-code">τ = rF sin θ</div><div class="formula-name">Torque</div></div>
                        <div class="formula-card"><div class="formula-code">τ = r × F</div><div class="formula-name">Cross Product</div></div>
                        <div class="formula-card"><div class="formula-code">τ_net = Iα</div><div class="formula-name">Rotational Newton's 2nd</div></div>
                        <div class="formula-card"><div class="formula-code">W = τθ</div><div class="formula-name">Rotational Work</div></div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="toggleSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="steps-body"></div>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>Understanding Torque</h2>
            <p>Torque is the measure of the force that causes an object to rotate. Just as force causes linear acceleration, torque causes angular acceleration.</p>
            <h3>Key Factors</h3>
            <ul>
                <li><strong>Force Magnitude:</strong> Greater force = greater torque</li>
                <li><strong>Lever Arm:</strong> Greater distance from pivot = greater torque</li>
                <li><strong>Angle:</strong> 90° gives maximum torque (sin 90° = 1)</li>
            </ul>
            <h3>Real-World Applications</h3>
            <ul>
                <li><strong>Wrenches:</strong> Longer handle = easier to turn bolts</li>
                <li><strong>Door hinges:</strong> Handle placed far from hinge for leverage</li>
                <li><strong>Engines:</strong> Torque determines pulling/acceleration power</li>
                <li><strong>Seesaws:</strong> Balance achieved when torques are equal</li>
            </ul>
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
    <script src="<%=request.getContextPath()%>/physics/js/torque-calculator.js?v=<%=cacheVersion%>"></script>
</body>
</html>
