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
        <jsp:param name="toolName" value="Work & Energy Transfer Formulas - W = Fd cos θ, Power P = W/t" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Work and energy transfer formulas: work by constant force (W = F d cos θ), variable force (W = ∫ F dx), work-energy theorem (W_net = ΔKE), power (P = W/t), and instantaneous power (P = Fv). Free reference." />
        <jsp:param name="toolUrl" value="physics/work-power.jsp" />
        <jsp:param name="toolKeywords" value="work formula, power formula, W Fd cos theta, work-energy theorem, power P W t, instantaneous power Fv, physics work and energy, joules" />
        <jsp:param name="toolImage" value="work-power.png" />
        <jsp:param name="toolFeatures" value="Work formula reference,Power formula reference,Work-energy theorem,Work and power calculators,Interactive visualization,Step-by-step solutions,Chart.js W vs angle,SI units (J, W)" />
        <jsp:param name="faq1q" value="What is the formula for work done by a constant force?" />
        <jsp:param name="faq1a" value="Work done by a constant force is W = F d cos θ, where F is force (N), d is displacement (m), and θ is the angle between force and displacement. Unit: joule (J)." />
        <jsp:param name="faq2q" value="What is the work-energy theorem?" />
        <jsp:param name="faq2a" value="The work-energy theorem states that net work done on an object equals the change in its kinetic energy: W_net = ΔKE = ½ m v_f² − ½ m v_i²." />
        <jsp:param name="faq3q" value="How is power related to work?" />
        <jsp:param name="faq3a" value="Power is the rate of doing work: P = W/t (average power) or P = dW/dt (instantaneous). When force and velocity are parallel, P = F v. SI unit: watt (W)." />
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
        :root { --wp-cyan: #0891b2; --wp-teal: #0d9488; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(8,145,178,0.1), rgba(13,148,136,0.1)); border-left: 4px solid var(--wp-cyan); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #0891b2, #0d9488); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .wp-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .wp-tab { padding: 0.5rem 1rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .wp-tab:hover { border-color: var(--wp-cyan); color: var(--wp-cyan); }
        .wp-tab.active { background: linear-gradient(135deg, #0891b2, #0d9488); border-color: #0d9488; color: white; }
        .wp-panel { display: none; }
        .wp-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--wp-cyan); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #0891b2, #0d9488); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(8,145,178,0.15), rgba(13,148,136,0.1)); border: 2px solid var(--wp-cyan); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--wp-cyan); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #0891b2, #0d9488); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--wp-cyan); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(8,145,178,0.1), rgba(13,148,136,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .wp-viz-container { position: relative; width: 100%; height: 260px; background: linear-gradient(180deg, #ecfeff 0%, #cffafe 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .wp-viz-container, .dark-mode .wp-viz-container { background: linear-gradient(180deg, #164e63 0%, #0e7490 100%); }
        .wp-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .wp-viz-pills { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; }
        .wp-viz-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-md); }
        [data-theme="dark"] .wp-viz-pill, .dark-mode .wp-viz-pill { background: rgba(30,41,59,0.95); }
        .wp-chart-wrap { height: 200px; margin: 1rem; padding: 0 0.5rem; }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #2563eb, #7c3aed); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--wp-cyan); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--wp-cyan); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #2563eb; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--wp-cyan); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #059669; font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: #059669; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--wp-cyan); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } .wp-viz-container { height: 220px; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🏋️</span> Work & Energy Transfer Formulas</h1>
            <p class="tool-page-description">Work by constant and variable force, work-energy theorem, and power</p>
            <div class="tool-badges">
                <span class="tool-badge">W = F d cos θ</span>
                <span class="tool-badge">W_net = ΔKE</span>
                <span class="tool-badge">P = W/t</span>
                <span class="tool-badge">P = F v</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Work and power</div>
            <p>Work is energy transferred by a force acting over a displacement. Power is the rate at which work is done (or energy is transferred). SI units: joule (J) for work and energy, watt (W) for power.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Work &amp; Power calculators</h2>
                    <p>W = F d cos θ · P = W/t or P = F v</p>
                </div>
                <div class="panel-body">
                    <div class="wp-tabs">
                        <button type="button" class="wp-tab active" data-tab="work">Work (W)</button>
                        <button type="button" class="wp-tab" data-tab="power">Power (P)</button>
                    </div>

                    <div id="panel-work" class="wp-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Force (F)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="work-f" class="number-input" value="10" min="0" step="any">
                                <select id="work-f-unit" class="unit-select">
                                    <option value="N">N</option>
                                    <option value="kN">kN</option>
                                    <option value="lbf">lbf</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Displacement (d)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="work-d" class="number-input" value="5" min="0" step="any">
                                <select id="work-d-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                    <option value="ft">ft</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Angle θ (deg, from displacement)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="work-theta" class="number-input" value="0" min="-180" max="180" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-radius: 0 10px 10px 0; font-size: 0.85rem;">deg</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runWorkPower()">Calculate Work</button>
                        <div class="result-card" id="result-work">
                            <div class="result-label">Work done</div>
                            <div class="result-value" id="work-value">50 J</div>
                        </div>
                    </div>

                    <div id="panel-power" class="wp-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Work (W)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="power-w" class="number-input" value="100" min="0" step="any">
                                <select id="power-w-unit" class="unit-select">
                                    <option value="J">J</option>
                                    <option value="kJ">kJ</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Time (t)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="power-t" class="number-input" value="10" min="0.001" step="any">
                                <select id="power-t-unit" class="unit-select">
                                    <option value="s">s</option>
                                    <option value="min">min</option>
                                    <option value="h">h</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runWorkPower()">Calculate Power</button>
                        <div class="result-card" id="result-power">
                            <div class="result-label">Average power</div>
                            <div class="result-value" id="power-value">10 W</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>🏋️ Work &amp; Power visualization</h3></div>
                    <div class="wp-viz-container" id="wp-viz-container">
                        <canvas class="wp-viz-canvas" id="wp-viz-canvas"></canvas>
                        <div class="wp-viz-pills" id="wp-viz-pills"></div>
                    </div>
                    <div class="wp-chart-wrap" id="wp-chart-wrap" style="display:none;">
                        <canvas id="wp-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleWorkPowerSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="wp-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="wp-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Work and energy transfer formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Meaning</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Work done by constant force</td>
                                <td class="form-equation">W = F d cos θ</td>
                                <td class="form-desc">Work = force × displacement × cos(angle)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Work done by variable force</td>
                                <td class="form-equation">W = ∫ F dx</td>
                                <td class="form-desc">Area under force-displacement graph</td>
                            </tr>
                            <tr>
                                <td class="form-name">Work-Energy Theorem</td>
                                <td class="form-equation">W<sub>net</sub> = ΔKE = ½ m v<sub>f</sub>² − ½ m v<sub>i</sub>²</td>
                                <td class="form-desc">Net work = change in kinetic energy</td>
                            </tr>
                            <tr>
                                <td class="form-name">Power (rate of energy transfer)</td>
                                <td class="form-equation">P = W / t = dW/dt</td>
                                <td class="form-desc">Power = work per unit time</td>
                            </tr>
                            <tr>
                                <td class="form-name">Instantaneous power</td>
                                <td class="form-equation">P = F v</td>
                                <td class="form-desc">When force and velocity are parallel</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About work and power</h2>
            <p>Work is done when a force causes a displacement. For a constant force at angle θ to the displacement, <strong>W = F d cos θ</strong>. For a variable force, work is the integral <strong>W = ∫ F dx</strong> (area under the F–x graph).</p>
            <h3>Work-Energy Theorem</h3>
            <p>The net work done on an object equals its change in kinetic energy: <strong>W_net = ΔKE</strong>. This links forces and motion via energy.</p>
            <h3>Power</h3>
            <p>Power <strong>P = W/t</strong> (average) or <strong>P = dW/dt</strong> (instantaneous). When force and velocity are in the same direction, <strong>P = F v</strong>. SI unit of power is the watt (W): 1 W = 1 J/s.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/work-power.js?v=<%=cacheVersion%>"></script>
</body>
</html>
