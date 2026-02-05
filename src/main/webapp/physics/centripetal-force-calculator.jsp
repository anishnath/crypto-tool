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
        <jsp:param name="toolName" value="Centripetal Force Calculator - Circular Motion (F = mv²/r)" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription"
            value="Calculate centripetal force, velocity, and radius for circular motion. Includes centripetal acceleration, angular velocity, and period calculations with animated visualization." />
        <jsp:param name="toolUrl" value="physics/centripetal-force-calculator.jsp" />
        <jsp:param name="toolKeywords"
            value="centripetal force calculator, circular motion, F=mv²/r, centripetal acceleration, angular velocity, period calculator, radius of curvature, physics calculator" />
        <jsp:param name="toolImage" value="centripetal-force-calculator.png" />
        <jsp:param name="toolFeatures"
            value="F=mv²/r calculator,Centripetal acceleration,Angular velocity,Period calculation,Circular motion animation,Step-by-step solutions,Unit conversions,Real-world examples" />
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
        :root {
            --physics-blue: #2563eb;
            --physics-purple: #7c3aed;
            --physics-green: #059669;
            --physics-orange: #f59e0b;
            --physics-teal: #14b8a6;
            --surface-1: #ffffff;
            --surface-2: #f8fafc;
            --surface-3: #f1f5f9;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-tertiary: #94a3b8;
            --border-light: #e2e8f0;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
        }

        [data-theme="dark"], .dark-mode {
            --surface-1: #1e293b;
            --surface-2: #0f172a;
            --surface-3: #334155;
            --text-primary: #f1f5f9;
            --text-secondary: #cbd5e1;
            --text-tertiary: #64748b;
            --border-light: #334155;
        }

        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }

        .tool-header {
            background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
            padding: 1.25rem 1.5rem;
            margin-top: 72px;
        }

        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }

        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 400px 1fr; gap: 2rem; } }

        .info-box { background: linear-gradient(135deg, rgba(20,184,166,0.1), rgba(13,148,136,0.1)); border-left: 4px solid var(--physics-teal); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }

        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #14b8a6, #0d9488); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }

        .solve-for-section { background: var(--surface-2); border-radius: 12px; padding: 1rem; margin-bottom: 1.25rem; border: 1px solid var(--border-light); }
        .solve-for-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.75rem; display: block; }
        .solve-for-btns { display: flex; gap: 0.5rem; flex-wrap: wrap; }
        .solve-btn { flex: 1; min-width: 70px; padding: 0.625rem 0.75rem; background: var(--surface-1); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.8rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .solve-btn:hover { border-color: var(--physics-teal); color: var(--physics-teal); }
        .solve-btn.active { background: var(--physics-teal); border-color: var(--physics-teal); color: white; }

        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--physics-teal); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }

        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #14b8a6, #0d9488); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); display: flex; align-items: center; justify-content: center; gap: 0.5rem; }
        .calc-btn:hover { transform: translateY(-2px); box-shadow: var(--shadow-lg); }

        .results-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.75rem; margin-top: 1.5rem; }
        .result-card { background: var(--surface-2); border-radius: 12px; padding: 1rem; text-align: center; border: 1px solid var(--border-light); }
        .result-card.highlight { background: linear-gradient(135deg, #14b8a6, #0d9488); color: white; border: none; grid-column: span 2; }
        .result-icon { font-size: 1.5rem; margin-bottom: 0.5rem; }
        .result-label { font-size: 0.7rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.8; margin-bottom: 0.25rem; }
        .result-value { font-size: 1.25rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; }
        .result-card:not(.highlight) .result-value { color: var(--text-primary); }

        .examples-section { margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid var(--border-light); }
        .examples-section h4 { margin: 0 0 1rem; font-size: 0.9rem; color: var(--text-primary); }
        .examples-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.75rem; }
        .example-card { background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 10px; padding: 0.75rem; cursor: pointer; transition: all 0.2s; text-align: center; }
        .example-card:hover { border-color: var(--physics-teal); transform: translateY(-2px); }
        .example-icon { font-size: 1.5rem; margin-bottom: 0.25rem; }
        .example-title { font-size: 0.8rem; font-weight: 600; color: var(--text-primary); }
        .example-desc { font-size: 0.7rem; color: var(--text-secondary); }

        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .simulation-header { background: linear-gradient(135deg, rgba(20,184,166,0.1), rgba(13,148,136,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }

        .circle-container { position: relative; width: 100%; height: 350px; background: linear-gradient(180deg, #f0fdfa 0%, #ccfbf1 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .circle-container, .dark-mode .circle-container { background: linear-gradient(180deg, #134e4a 0%, #0f172a 100%); }
        .circle-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .circle-info { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; }
        .circle-info-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-sm); }
        [data-theme="dark"] .circle-info-pill, .dark-mode .circle-info-pill { background: rgba(30,41,59,0.95); }

        .formula-section { padding: 1rem; border-top: 1px solid var(--border-light); }
        .formula-section h4 { margin: 0 0 1rem; font-size: 0.9rem; color: var(--text-primary); }
        .formula-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 0.75rem; }
        .formula-card { background: var(--surface-2); border-radius: 10px; padding: 1rem; border: 1px solid var(--border-light); }
        .formula-code { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: var(--physics-teal); margin-bottom: 0.25rem; }
        .formula-name { font-size: 0.7rem; color: var(--text-secondary); }

        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple)); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 400px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--physics-teal); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--physics-teal); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: var(--physics-blue); margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--physics-teal); font-weight: 700; }
        .step-result { background: linear-gradient(135deg, rgba(5,150,105,0.1), rgba(16,185,129,0.1)); border: 1px solid rgba(5,150,105,0.3); border-radius: 8px; padding: 0.75rem; margin-top: 0.5rem; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: var(--physics-green); font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1.1rem; font-weight: 700; color: var(--physics-green); }

        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .edu-content ul { padding-left: 1.5rem; }

        @media (max-width: 768px) {
            .tool-page-title { font-size: 1.25rem; }
            .circle-container { height: 280px; }
            .results-grid { grid-template-columns: 1fr; }
            .result-card.highlight { grid-column: span 1; }
        }
    </style>
</head>

<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🔄</span> Centripetal Force Calculator</h1>
            <p class="tool-page-description">Calculate forces and motion in circular paths</p>
            <div class="tool-badges">
                <span class="tool-badge">F = mv²/r</span>
                <span class="tool-badge">a = v²/r</span>
                <span class="tool-badge">ω = v/r</span>
                <span class="tool-badge">Animated</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Centripetal Force</div>
            <p><strong>F = mv²/r</strong> — The force required to keep an object moving in a circular path, always directed toward the center of the circle.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Circular Motion Calculator</h2>
                    <p>Configure motion parameters</p>
                </div>
                <div class="panel-body">
                    <div class="solve-for-section">
                        <span class="solve-for-label">Solve for:</span>
                        <div class="solve-for-btns">
                            <button class="solve-btn active" onclick="setSolveFor('force')" data-var="force">Force</button>
                            <button class="solve-btn" onclick="setSolveFor('mass')" data-var="mass">Mass</button>
                            <button class="solve-btn" onclick="setSolveFor('velocity')" data-var="velocity">Velocity</button>
                            <button class="solve-btn" onclick="setSolveFor('radius')" data-var="radius">Radius</button>
                        </div>
                    </div>

                    <div class="input-section" id="mass-section">
                        <div class="input-label"><span>⚖️</span><span>Mass (m)</span></div>
                        <div class="input-with-unit">
                            <input type="number" id="mass" class="number-input" value="1000" min="0.001" step="1">
                            <select id="mass-unit" class="unit-select" onchange="calculate()">
                                <option value="kg" selected>kg</option>
                                <option value="g">g</option>
                                <option value="lb">lb</option>
                            </select>
                        </div>
                    </div>

                    <div class="input-section" id="velocity-section">
                        <div class="input-label"><span>🚀</span><span>Velocity (v)</span></div>
                        <div class="input-with-unit">
                            <input type="number" id="velocity" class="number-input" value="20" min="0.1" step="1">
                            <select id="velocity-unit" class="unit-select" onchange="calculate()">
                                <option value="m/s" selected>m/s</option>
                                <option value="km/h">km/h</option>
                                <option value="mph">mph</option>
                            </select>
                        </div>
                    </div>

                    <div class="input-section" id="radius-section">
                        <div class="input-label"><span>⭕</span><span>Radius (r)</span></div>
                        <div class="input-with-unit">
                            <input type="number" id="radius" class="number-input" value="50" min="0.1" step="1">
                            <select id="radius-unit" class="unit-select" onchange="calculate()">
                                <option value="m" selected>m</option>
                                <option value="km">km</option>
                                <option value="ft">ft</option>
                            </select>
                        </div>
                    </div>

                    <div class="input-section" id="force-section" style="display: none;">
                        <div class="input-label"><span>💪</span><span>Centripetal Force (F)</span></div>
                        <div class="input-with-unit">
                            <input type="number" id="force" class="number-input" value="8000" min="0.1" step="1">
                            <select id="force-unit" class="unit-select" onchange="calculate()">
                                <option value="N" selected>N</option>
                                <option value="kN">kN</option>
                                <option value="lbf">lbf</option>
                            </select>
                        </div>
                    </div>

                    <button class="calc-btn" onclick="calculate()"><span>⚡</span><span>Calculate</span></button>

                    <div class="results-grid">
                        <div class="result-card highlight">
                            <div class="result-icon">🔄</div>
                            <div class="result-label">Centripetal Force</div>
                            <div class="result-value" id="result-force">8000 N</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">⚡</div>
                            <div class="result-label">Acceleration</div>
                            <div class="result-value" id="result-accel">8.00 m/s²</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">🔁</div>
                            <div class="result-label">Angular Velocity</div>
                            <div class="result-value" id="result-omega">0.40 rad/s</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">⏱️</div>
                            <div class="result-label">Period</div>
                            <div class="result-value" id="result-period">15.7 s</div>
                        </div>
                    </div>

                    <div class="examples-section">
                        <h4>📚 Try These Examples</h4>
                        <div class="examples-grid">
                            <div class="example-card" onclick="loadExample(1)">
                                <div class="example-icon">🚗</div>
                                <div class="example-title">Car Turn</div>
                                <div class="example-desc">1500kg @ 60km/h, r=30m</div>
                            </div>
                            <div class="example-card" onclick="loadExample(2)">
                                <div class="example-icon">🎢</div>
                                <div class="example-title">Roller Coaster</div>
                                <div class="example-desc">500kg @ 25m/s, r=15m</div>
                            </div>
                            <div class="example-card" onclick="loadExample(3)">
                                <div class="example-icon">🛰️</div>
                                <div class="example-title">Satellite</div>
                                <div class="example-desc">1000kg @ 7.8km/s</div>
                            </div>
                            <div class="example-card" onclick="loadExample(4)">
                                <div class="example-icon">🎯</div>
                                <div class="example-title">Ball on String</div>
                                <div class="example-desc">0.5kg @ 5m/s, r=1m</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="simulation-panel">
                <div class="simulation-header">
                    <h3>🔄 Circular Motion Animation</h3>
                    <button class="solve-btn" style="margin-left: auto;" onclick="toggleAnimation()" id="anim-btn">▶ Play</button>
                </div>

                <div class="circle-container" id="circle-container">
                    <canvas class="circle-canvas" id="circle-canvas"></canvas>
                    <div class="circle-info">
                        <div class="circle-info-pill" id="info-v">v = 20 m/s</div>
                        <div class="circle-info-pill" id="info-r">r = 50 m</div>
                        <div class="circle-info-pill" id="info-f">F = 8000 N</div>
                    </div>
                </div>

                <div class="formula-section">
                    <h4>📝 Circular Motion Formulas</h4>
                    <div class="formula-grid">
                        <div class="formula-card">
                            <div class="formula-code">F = mv²/r</div>
                            <div class="formula-name">Centripetal Force</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula-code">a = v²/r</div>
                            <div class="formula-name">Centripetal Accel</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula-code">ω = v/r</div>
                            <div class="formula-name">Angular Velocity</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula-code">T = 2πr/v</div>
                            <div class="formula-name">Period</div>
                        </div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="toggleSteps()">
                        <span>🧮</span><span>Step-by-Step Solution</span>
                        <span class="steps-toggle" id="steps-toggle">▼ Show</span>
                    </div>
                    <div class="steps-body collapsed" id="steps-body"></div>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>Understanding Centripetal Force</h2>
            <p>Centripetal force is the net force that keeps an object moving in a circular path. It's always directed toward the center of the circle, perpendicular to the velocity.</p>

            <h3>Key Concepts</h3>
            <ul>
                <li><strong>Centripetal ≠ Centrifugal:</strong> Centripetal force is real; centrifugal is a perceived "pseudo-force"</li>
                <li><strong>Direction:</strong> Always points toward the center of the circular path</li>
                <li><strong>Sources:</strong> Can be tension, friction, gravity, or any combination</li>
                <li><strong>No Work:</strong> Centripetal force does no work (perpendicular to motion)</li>
            </ul>

            <h3>Real-World Examples</h3>
            <ul>
                <li><strong>Car turning:</strong> Friction between tires and road provides centripetal force</li>
                <li><strong>Satellites:</strong> Gravity provides the centripetal force for orbital motion</li>
                <li><strong>Roller coasters:</strong> Normal force and gravity combine at loops</li>
                <li><strong>Centrifuge:</strong> Uses centripetal force to separate substances by density</li>
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

    <script src="<%=request.getContextPath()%>/physics/js/centripetal-force-calculator.js?v=<%=cacheVersion%>"></script>
</body>
</html>
