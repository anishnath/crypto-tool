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
        <jsp:param name="toolName" value="Special Relativity Calculator - Lorentz Factor, Time Dilation, Length Contraction" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Special relativity formulas: Lorentz factor γ = 1/√(1−v²/c²), length contraction L = L₀/γ, time dilation Δt = γ Δt₀, relativistic momentum p = γ m₀ v, kinetic energy KE = (γ−1)m₀c², E = γ m₀ c², velocity addition w = (u+v)/(1+uv/c²). Free calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/special-relativity.jsp" />
        <jsp:param name="toolKeywords" value="special relativity, Lorentz factor, time dilation, length contraction, relativistic momentum, relativistic energy, velocity addition, E mc squared, physics modern, JEE NEET" />
        <jsp:param name="toolImage" value="special-relativity.png" />
        <jsp:param name="toolFeatures" value="Lorentz factor calculator,Length contraction calculator,Time dilation calculator,Relativistic momentum calculator,Relativistic energy calculator,Velocity addition calculator,Step-by-step solutions,SI and c units" />
        <jsp:param name="faq1q" value="What is the Lorentz factor?" />
        <jsp:param name="faq1a" value="γ = 1/√(1 − v²/c²), where v is speed and c is speed of light. It appears in time dilation (Δt = γ Δt₀), length contraction (L = L₀/γ), and relativistic momentum and energy." />
        <jsp:param name="faq2q" value="What is time dilation?" />
        <jsp:param name="faq2a" value="A moving clock runs slow: Δt = γ Δt₀, where Δt₀ is proper time (in the rest frame of the clock) and Δt is the time interval measured in the lab frame." />
        <jsp:param name="faq3q" value="What is length contraction?" />
        <jsp:param name="faq3a" value="Lengths along the direction of motion shorten: L = L₀/γ, where L₀ is proper length (in the rest frame of the object) and L is the length measured in the lab frame." />
        <jsp:param name="faq4q" value="How do you add velocities in special relativity?" />
        <jsp:param name="faq4a" value="w = (u + v) / (1 + u v / c²). When u and v are small compared to c, this approximates the classical sum u + v." />
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
        :root { --rel-violet: #6d28d9; --rel-indigo: #4f46e5; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #6d28d9 0%, #4f46e5 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(109,40,217,0.1), rgba(79,70,229,0.1)); border-left: 4px solid var(--rel-violet); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #6d28d9, #4f46e5); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .rel-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .rel-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .rel-tab:hover { border-color: var(--rel-violet); color: var(--rel-violet); }
        .rel-tab.active { background: linear-gradient(135deg, #6d28d9, #4f46e5); border-color: #4f46e5; color: white; }
        .rel-panel { display: none; }
        .rel-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--rel-violet); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #6d28d9, #4f46e5); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(109,40,217,0.15), rgba(79,70,229,0.1)); border: 2px solid var(--rel-violet); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--rel-violet); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #6d28d9, #4f46e5); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--rel-violet); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(109,40,217,0.1), rgba(79,70,229,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); }
        .rel-viz-container { width: 100%; height: 220px; background: linear-gradient(180deg, #ede9fe 0%, #ddd6fe 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); display: flex; align-items: center; justify-content: center; }
        .rel-viz-container .highlight { color: var(--rel-violet); font-weight: 700; }
        [data-theme="dark"] .rel-viz-container, .dark-mode .rel-viz-container { background: linear-gradient(180deg, #312e81 0%, #3730a3 100%); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #6d28d9, #4f46e5); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--rel-violet); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--rel-violet); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #6d28d9; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--rel-violet); font-weight: 700; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--rel-violet); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>⚡</span> Special Relativity (Basic)</h1>
            <p class="tool-page-description">Lorentz factor, length contraction, time dilation, relativistic momentum & energy, velocity addition</p>
            <div class="tool-badges">
                <span class="tool-badge">γ = 1/√(1−v²/c²)</span>
                <span class="tool-badge">Δt = γ Δt₀</span>
                <span class="tool-badge">E = γ m₀ c²</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Special relativity</div>
            <p>At speeds comparable to the speed of light c, time dilates (Δt = γ Δt₀), lengths contract (L = L₀/γ), and momentum and energy become relativistic: p = γ m₀ v, KE = (γ−1) m₀ c², E = γ m₀ c². Velocities add as w = (u+v)/(1+uv/c²). Classical limit when v ≪ c.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Relativity calculators</h2>
                    <p>γ, length, time, momentum, energy, velocity addition</p>
                </div>
                <div class="panel-body">
                    <div class="rel-tabs">
                        <button type="button" class="rel-tab active" data-tab="gamma" onclick="if(window.switchRelativityTab)window.switchRelativityTab('gamma',this);">γ</button>
                        <button type="button" class="rel-tab" data-tab="length" onclick="if(window.switchRelativityTab)window.switchRelativityTab('length',this);">Length</button>
                        <button type="button" class="rel-tab" data-tab="time" onclick="if(window.switchRelativityTab)window.switchRelativityTab('time',this);">Time</button>
                        <button type="button" class="rel-tab" data-tab="momentum" onclick="if(window.switchRelativityTab)window.switchRelativityTab('momentum',this);">Momentum</button>
                        <button type="button" class="rel-tab" data-tab="energy" onclick="if(window.switchRelativityTab)window.switchRelativityTab('energy',this);">Energy</button>
                        <button type="button" class="rel-tab" data-tab="velocity" onclick="if(window.switchRelativityTab)window.switchRelativityTab('velocity',this);">Velocity add</button>
                    </div>

                    <div id="panel-gamma" class="rel-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Speed (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="gamma-v" class="number-input" value="0.5" min="0" step="any">
                                <select id="gamma-v-unit" class="unit-select">
                                    <option value="c">c (fraction)</option>
                                    <option value="ms">m/s</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runRelativity()">Calculate γ</button>
                        <div class="result-card" id="result-gamma">
                            <div class="result-label">Lorentz factor</div>
                            <div class="result-value" id="gamma-result">1.15</div>
                        </div>
                    </div>

                    <div id="panel-length" class="rel-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Proper length L₀ (m)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="length-l0" class="number-input" value="10" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">m</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Speed v/c (fraction, 0 to &lt;1)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="length-v" class="number-input" value="0.6" min="0" max="1" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">c</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runRelativity()">Calculate L</button>
                        <div class="result-card" id="result-length">
                            <div class="result-label">Contracted length L</div>
                            <div class="result-value" id="length-result">8 m</div>
                        </div>
                    </div>

                    <div id="panel-time" class="rel-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Proper time Δt₀ (s)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="time-t0" class="number-input" value="1" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">s</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Speed v/c (fraction)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="time-v" class="number-input" value="0.6" min="0" max="1" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">c</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runRelativity()">Calculate Δt</button>
                        <div class="result-card" id="result-time">
                            <div class="result-label">Dilated time Δt</div>
                            <div class="result-value" id="time-result">1.25 s</div>
                        </div>
                    </div>

                    <div id="panel-momentum" class="rel-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Rest mass m₀ (kg)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="mom-m0" class="number-input" value="1" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">kg</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Speed v</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="mom-v" class="number-input" value="0.5" min="0" step="any">
                                <select id="mom-v-unit" class="unit-select">
                                    <option value="c">c (fraction)</option>
                                    <option value="ms">m/s</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runRelativity()">Calculate p</button>
                        <div class="result-card" id="result-momentum">
                            <div class="result-label">Relativistic momentum p</div>
                            <div class="result-value" id="mom-result">— kg·m/s</div>
                        </div>
                    </div>

                    <div id="panel-energy" class="rel-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Rest mass m₀ (kg)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-m0" class="number-input" value="1" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">kg</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Speed v/c (fraction)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-v" class="number-input" value="0.5" min="0" max="1" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">c</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runRelativity()">Calculate KE & E</button>
                        <div class="result-card" id="result-energy">
                            <div class="result-label">Kinetic energy & total energy</div>
                            <div class="result-value" id="energy-result">—</div>
                        </div>
                    </div>

                    <div id="panel-velocity" class="rel-panel">
                        <div class="input-section">
                            <div class="input-label"><span>u/c (fraction)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="vel-u" class="number-input" value="0.5" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">c</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>v/c (fraction)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="vel-v" class="number-input" value="0.3" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">c</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runRelativity()">Calculate w</button>
                        <div class="result-card" id="result-velocity">
                            <div class="result-label">Resulting speed w/c</div>
                            <div class="result-value" id="vel-result">— c</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>⚡ Relativity result</h3></div>
                    <div class="rel-viz-container" id="rel-viz-container">
                        <div id="rel-viz-placeholder" style="color: var(--text-secondary); font-size: 0.9rem; text-align: center; padding: 1rem;">Run a calculation to see result.</div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleRelativitySteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="rel-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="rel-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Special relativity formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Lorentz factor</td>
                                <td class="form-equation">γ = 1 / √(1 − v²/c²)</td>
                                <td class="form-desc">—</td>
                            </tr>
                            <tr>
                                <td class="form-name">Length contraction</td>
                                <td class="form-equation">L = L₀ / γ</td>
                                <td class="form-desc">L₀ = proper length</td>
                            </tr>
                            <tr>
                                <td class="form-name">Time dilation</td>
                                <td class="form-equation">Δt = γ Δt₀</td>
                                <td class="form-desc">Δt₀ = proper time</td>
                            </tr>
                            <tr>
                                <td class="form-name">Relativistic momentum</td>
                                <td class="form-equation">p = γ m₀ v</td>
                                <td class="form-desc">m₀ = rest mass</td>
                            </tr>
                            <tr>
                                <td class="form-name">Relativistic kinetic energy</td>
                                <td class="form-equation">KE = (γ − 1) m₀ c²</td>
                                <td class="form-desc">—</td>
                            </tr>
                            <tr>
                                <td class="form-name">Total energy</td>
                                <td class="form-equation">E = γ m₀ c²</td>
                                <td class="form-desc">Rest energy = m₀ c²</td>
                            </tr>
                            <tr>
                                <td class="form-name">Mass-energy equivalence</td>
                                <td class="form-equation">E = m c²</td>
                                <td class="form-desc">—</td>
                            </tr>
                            <tr>
                                <td class="form-name">Velocity addition</td>
                                <td class="form-equation">w = (u + v) / (1 + u v / c²)</td>
                                <td class="form-desc">Classical limit when v ≪ c</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About special relativity</h2>
            <p>Special relativity describes how space and time behave at speeds comparable to the speed of light c. The <strong>Lorentz factor</strong> γ = 1/√(1−v²/c²) appears in all key relations: <strong>length contraction</strong> L = L₀/γ (moving lengths shorten along the direction of motion), <strong>time dilation</strong> Δt = γ Δt₀ (moving clocks run slow), <strong>relativistic momentum</strong> p = γ m₀ v, and <strong>total energy</strong> E = γ m₀ c² with <strong>kinetic energy</strong> KE = (γ−1) m₀ c².</p>
            <h3>Velocity addition</h3>
            <p>Velocities do not add linearly. If a frame moves at v relative to the lab and an object moves at u in that frame, its speed in the lab is <strong>w = (u + v) / (1 + u v / c²)</strong>. When u, v ≪ c, w ≈ u + v (classical).</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/special-relativity.js?v=<%=cacheVersion%>"></script>
</body>
</html>
