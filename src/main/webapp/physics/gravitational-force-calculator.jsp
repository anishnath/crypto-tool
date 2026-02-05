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
        <jsp:param name="toolName" value="Gravitational Force Calculator - Newton's Law of Gravitation" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Calculate gravitational force between two masses using Newton's Universal Law of Gravitation (F = Gm₁m₂/r²). Includes orbital velocity, escape velocity calculations." />
        <jsp:param name="toolUrl" value="physics/gravitational-force-calculator.jsp" />
        <jsp:param name="toolKeywords" value="gravitational force calculator, Newton's law of gravitation, F=Gm1m2/r2, gravity calculator, orbital velocity, escape velocity, gravitational constant, physics calculator" />
        <jsp:param name="toolImage" value="gravitational-force-calculator.png" />
        <jsp:param name="toolFeatures" value="Universal gravitation,Orbital velocity,Escape velocity,Planet presets,Step-by-step solutions,Interactive visualization" />
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
        :root { --physics-blue: #2563eb; --physics-purple: #7c3aed; --physics-green: #059669; --physics-indigo: #4f46e5; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 400px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(79,70,229,0.1), rgba(124,58,237,0.1)); border-left: 4px solid var(--physics-indigo); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #4f46e5, #7c3aed); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--physics-indigo); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .presets-row { display: flex; gap: 0.5rem; flex-wrap: wrap; margin-top: 0.5rem; }
        .preset-btn { padding: 0.4rem 0.6rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 6px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .preset-btn:hover { border-color: var(--physics-indigo); color: var(--physics-indigo); }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #4f46e5, #7c3aed); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); display: flex; align-items: center; justify-content: center; gap: 0.5rem; }
        .calc-btn:hover { transform: translateY(-2px); }
        .results-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.75rem; margin-top: 1.5rem; }
        .result-card { background: var(--surface-2); border-radius: 12px; padding: 1rem; text-align: center; border: 1px solid var(--border-light); }
        .result-card.highlight { background: linear-gradient(135deg, #4f46e5, #7c3aed); color: white; border: none; grid-column: span 2; }
        .result-icon { font-size: 1.5rem; margin-bottom: 0.5rem; }
        .result-label { font-size: 0.7rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.8; margin-bottom: 0.25rem; }
        .result-value { font-size: 1.1rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; }
        .result-card:not(.highlight) .result-value { color: var(--text-primary); }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .simulation-header { background: linear-gradient(135deg, rgba(79,70,229,0.1), rgba(124,58,237,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .gravity-container { position: relative; width: 100%; height: 300px; background: linear-gradient(180deg, #0f0f23 0%, #1a1a2e 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        .gravity-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .formula-section { padding: 1rem; border-top: 1px solid var(--border-light); }
        .formula-section h4 { margin: 0 0 1rem; font-size: 0.9rem; color: var(--text-primary); }
        .formula-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 0.75rem; }
        .formula-card { background: var(--surface-2); border-radius: 10px; padding: 1rem; border: 1px solid var(--border-light); }
        .formula-code { font-family: 'JetBrains Mono', monospace; font-size: 0.95rem; font-weight: 700; color: var(--physics-indigo); margin-bottom: 0.25rem; }
        .formula-name { font-size: 0.7rem; color: var(--text-secondary); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple)); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 400px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--physics-indigo); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--physics-indigo); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: var(--physics-blue); margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--physics-indigo); font-weight: 700; }
        .step-result { background: linear-gradient(135deg, rgba(5,150,105,0.1), rgba(16,185,129,0.1)); border: 1px solid rgba(5,150,105,0.3); border-radius: 8px; padding: 0.75rem; margin-top: 0.5rem; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: var(--physics-green); font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1.1rem; font-weight: 700; color: var(--physics-green); }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .edu-content ul { padding-left: 1.5rem; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .gravity-container { height: 250px; } .results-grid { grid-template-columns: 1fr; } .result-card.highlight { grid-column: span 1; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🌌</span> Gravitational Force Calculator</h1>
            <p class="tool-page-description">Calculate gravitational attraction between masses</p>
            <div class="tool-badges">
                <span class="tool-badge">F = Gm₁m₂/r²</span>
                <span class="tool-badge">Orbital Velocity</span>
                <span class="tool-badge">Escape Velocity</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Newton's Law of Universal Gravitation</div>
            <p><strong>F = Gm₁m₂/r²</strong> — Every mass attracts every other mass with a force proportional to the product of their masses and inversely proportional to the square of the distance between them.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Gravitational Calculator</h2>
                    <p>G = 6.674 × 10⁻¹¹ N⋅m²/kg²</p>
                </div>
                <div class="panel-body">
                    <div class="input-section">
                        <div class="input-label"><span>🌍</span><span>Mass 1 (m₁)</span></div>
                        <div class="input-with-unit">
                            <input type="number" id="mass1" class="number-input" value="5.972e24" step="any">
                            <select id="mass1-unit" class="unit-select" onchange="calculate()">
                                <option value="kg" selected>kg</option>
                                <option value="earth">Earth</option>
                                <option value="sun">Sun</option>
                            </select>
                        </div>
                        <div class="presets-row">
                            <button class="preset-btn" onclick="setMass1(5.972e24, 'kg')">🌍 Earth</button>
                            <button class="preset-btn" onclick="setMass1(7.342e22, 'kg')">🌙 Moon</button>
                            <button class="preset-btn" onclick="setMass1(1.989e30, 'kg')">☀️ Sun</button>
                        </div>
                    </div>

                    <div class="input-section">
                        <div class="input-label"><span>🚀</span><span>Mass 2 (m₂)</span></div>
                        <div class="input-with-unit">
                            <input type="number" id="mass2" class="number-input" value="1000" step="any">
                            <select id="mass2-unit" class="unit-select" onchange="calculate()">
                                <option value="kg" selected>kg</option>
                            </select>
                        </div>
                        <div class="presets-row">
                            <button class="preset-btn" onclick="setMass2(70)">🧑 Human (70kg)</button>
                            <button class="preset-btn" onclick="setMass2(1000)">🛰️ Satellite</button>
                            <button class="preset-btn" onclick="setMass2(420000)">🚀 ISS</button>
                        </div>
                    </div>

                    <div class="input-section">
                        <div class="input-label"><span>📏</span><span>Distance (r)</span></div>
                        <div class="input-with-unit">
                            <input type="number" id="distance" class="number-input" value="6.371e6" step="any">
                            <select id="distance-unit" class="unit-select" onchange="calculate()">
                                <option value="m" selected>m</option>
                                <option value="km">km</option>
                                <option value="earth-r">Earth radii</option>
                            </select>
                        </div>
                        <div class="presets-row">
                            <button class="preset-btn" onclick="setDistance(6.371e6)">Surface</button>
                            <button class="preset-btn" onclick="setDistance(4.22e8)">ISS orbit</button>
                            <button class="preset-btn" onclick="setDistance(3.844e8)">Moon orbit</button>
                        </div>
                    </div>

                    <button class="calc-btn" onclick="calculate()"><span>⚡</span><span>Calculate</span></button>

                    <div class="results-grid">
                        <div class="result-card highlight">
                            <div class="result-icon">🌌</div>
                            <div class="result-label">Gravitational Force</div>
                            <div class="result-value" id="result-force">9.82 kN</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">⚡</div>
                            <div class="result-label">Surface Gravity</div>
                            <div class="result-value" id="result-gravity">9.82 m/s²</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">🛰️</div>
                            <div class="result-label">Orbital Velocity</div>
                            <div class="result-value" id="result-orbital">7.91 km/s</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">🚀</div>
                            <div class="result-label">Escape Velocity</div>
                            <div class="result-value" id="result-escape">11.2 km/s</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="simulation-panel">
                <div class="simulation-header"><h3>🌌 Gravitational Field</h3></div>
                <div class="gravity-container" id="gravity-container">
                    <canvas class="gravity-canvas" id="gravity-canvas"></canvas>
                </div>

                <div class="formula-section">
                    <h4>📝 Gravitational Formulas</h4>
                    <div class="formula-grid">
                        <div class="formula-card"><div class="formula-code">F = Gm₁m₂/r²</div><div class="formula-name">Gravitational Force</div></div>
                        <div class="formula-card"><div class="formula-code">g = GM/r²</div><div class="formula-name">Surface Gravity</div></div>
                        <div class="formula-card"><div class="formula-code">v = √(GM/r)</div><div class="formula-name">Orbital Velocity</div></div>
                        <div class="formula-card"><div class="formula-code">vₑ = √(2GM/r)</div><div class="formula-name">Escape Velocity</div></div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="toggleSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="steps-body"></div>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>Understanding Universal Gravitation</h2>
            <p>Newton's law of universal gravitation states that every particle attracts every other particle with a force directly proportional to the product of their masses and inversely proportional to the square of the distance between their centers.</p>
            <h3>The Gravitational Constant</h3>
            <p><strong>G = 6.674 × 10⁻¹¹ N⋅m²/kg²</strong> — This tiny constant explains why we only notice gravity from extremely massive objects like planets and stars.</p>
            <h3>Applications</h3>
            <ul>
                <li><strong>Orbital mechanics:</strong> Predicting satellite and planet orbits</li>
                <li><strong>Space missions:</strong> Calculating trajectories and fuel requirements</li>
                <li><strong>Tides:</strong> Moon and Sun's gravitational pull on Earth's oceans</li>
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
    <script src="<%=request.getContextPath()%>/physics/js/gravitational-force-calculator.js?v=<%=cacheVersion%>"></script>
</body>
</html>
