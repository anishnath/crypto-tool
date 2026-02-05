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
        <jsp:param name="toolName" value="Momentum Calculator - Collisions, Impulse & Conservation" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Calculate momentum, impulse, and collision outcomes. Supports elastic, inelastic, and perfectly inelastic collisions with animated visualizations and step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/momentum-calculator.jsp" />
        <jsp:param name="toolKeywords" value="momentum calculator, collision calculator, impulse calculator, elastic collision, inelastic collision, conservation of momentum, physics calculator, p=mv" />
        <jsp:param name="toolImage" value="momentum-calculator.png" />
        <jsp:param name="toolFeatures" value="p=mv calculator,Impulse J=FΔt,Elastic collisions,Inelastic collisions,Collision animation,Step-by-step solutions,Conservation of momentum" />
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
            --physics-orange: #ea580c;
            --physics-red: #dc2626;
            --physics-cyan: #0891b2;
            --physics-pink: #db2777;
            --surface-1: #ffffff;
            --surface-2: #f8fafc;
            --surface-3: #f1f5f9;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --border-light: #e2e8f0;
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
        }

        [data-theme="dark"], .dark-mode {
            --surface-1: #1e293b;
            --surface-2: #0f172a;
            --surface-3: #334155;
            --text-primary: #f1f5f9;
            --text-secondary: #cbd5e1;
            --border-light: #334155;
        }

        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }

        .tool-header {
            background: linear-gradient(135deg, #db2777 0%, #9333ea 100%);
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
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 420px 1fr; gap: 2rem; } }

        .info-box {
            background: linear-gradient(135deg, rgba(219,39,119,0.1), rgba(147,51,234,0.1));
            border-left: 4px solid var(--physics-pink);
            border-radius: 12px;
            padding: 1rem 1.25rem;
            margin-bottom: 2rem;
        }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }

        .control-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            border: 1px solid var(--border-light);
        }
        .panel-header {
            background: linear-gradient(135deg, #db2777, #9333ea);
            color: white;
            padding: 1.25rem 1.5rem;
        }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }

        .mode-tabs { display: flex; gap: 0.5rem; margin-bottom: 1.5rem; flex-wrap: wrap; }
        .mode-tab {
            flex: 1;
            min-width: 90px;
            padding: 0.75rem 0.5rem;
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }
        .mode-tab:hover { border-color: var(--physics-pink); color: var(--physics-pink); }
        .mode-tab.active { background: linear-gradient(135deg, #db2777, #9333ea); border-color: transparent; color: white; }

        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border-light);
            border-radius: 10px 0 0 10px;
            font-size: 1rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--surface-1);
            color: var(--text-primary);
        }
        .number-input:focus { outline: none; border-color: var(--physics-pink); }
        .unit-select {
            padding: 0.75rem;
            background: var(--surface-3);
            border: 2px solid var(--border-light);
            border-left: none;
            border-radius: 0 10px 10px 0;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            min-width: 70px;
        }

        .object-inputs {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border-light);
        }
        .object-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.75rem;
            font-size: 0.9rem;
        }
        .object-color { width: 12px; height: 12px; border-radius: 50%; }
        .object-1 .object-color { background: #3b82f6; }
        .object-2 .object-color { background: #f59e0b; }

        .collision-type-section {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1.25rem;
            border: 1px solid var(--border-light);
        }
        .collision-type-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.75rem; display: block; }
        .collision-types { display: flex; gap: 0.5rem; flex-wrap: wrap; }
        .collision-type-btn {
            flex: 1;
            min-width: 100px;
            padding: 0.625rem 0.75rem;
            background: var(--surface-1);
            border: 2px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
        }
        .collision-type-btn:hover { border-color: var(--physics-pink); color: var(--physics-pink); }
        .collision-type-btn.active { background: var(--physics-pink); border-color: var(--physics-pink); color: white; }

        .restitution-section { margin-top: 0.75rem; display: none; }
        .restitution-section.show { display: block; }
        .restitution-slider { width: 100%; height: 8px; -webkit-appearance: none; background: linear-gradient(to right, #db2777, #9333ea); border-radius: 4px; margin-top: 0.5rem; }
        .restitution-slider::-webkit-slider-thumb { -webkit-appearance: none; width: 20px; height: 20px; background: white; border: 3px solid #db2777; border-radius: 50%; cursor: pointer; }
        .restitution-value { font-family: 'JetBrains Mono', monospace; font-weight: 700; color: var(--physics-pink); }

        .calc-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, #db2777, #9333ea);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: var(--shadow-md);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
        }
        .calc-btn:hover { transform: translateY(-2px); }

        .animate-btn {
            width: 100%;
            padding: 0.875rem;
            background: linear-gradient(135deg, #059669, #047857);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        .animate-btn:hover { transform: translateY(-2px); }
        .animate-btn.stop { background: linear-gradient(135deg, #dc2626, #b91c1c); }

        .results-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.75rem; margin-top: 1.5rem; }
        .result-card {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            border: 1px solid var(--border-light);
        }
        .result-card.highlight {
            background: linear-gradient(135deg, #db2777, #9333ea);
            color: white;
            border: none;
            grid-column: span 2;
        }
        .result-icon { font-size: 1.5rem; margin-bottom: 0.5rem; }
        .result-label { font-size: 0.7rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.8; margin-bottom: 0.25rem; }
        .result-value { font-size: 1.1rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; }
        .result-card:not(.highlight) .result-value { color: var(--text-primary); }

        .simulation-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            border: 1px solid var(--border-light);
        }
        .simulation-header {
            background: linear-gradient(135deg, rgba(219,39,119,0.1), rgba(147,51,234,0.05));
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border-light);
        }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }

        .collision-container {
            position: relative;
            width: 100%;
            height: 280px;
            background: linear-gradient(180deg, #fdf4ff 0%, #fae8ff 100%);
            margin: 1rem;
            border-radius: 12px;
            overflow: hidden;
            border: 2px solid var(--border-light);
        }
        [data-theme="dark"] .collision-container, .dark-mode .collision-container {
            background: linear-gradient(180deg, #4a044e 0%, #0f172a 100%);
        }
        .collision-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .collision-info {
            position: absolute;
            bottom: 10px;
            left: 10px;
            right: 10px;
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        .collision-info-pill {
            background: rgba(255,255,255,0.95);
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-primary);
            box-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }
        [data-theme="dark"] .collision-info-pill, .dark-mode .collision-info-pill { background: rgba(30,41,59,0.95); }

        .momentum-bars {
            display: flex;
            gap: 1rem;
            padding: 1rem;
            background: var(--surface-2);
            border-top: 1px solid var(--border-light);
        }
        .momentum-bar-group { flex: 1; }
        .momentum-bar-label { font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); margin-bottom: 0.5rem; text-transform: uppercase; }
        .momentum-bar-container { height: 30px; background: var(--surface-3); border-radius: 6px; overflow: hidden; display: flex; }
        .momentum-bar {
            height: 100%;
            transition: width 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: 700;
            color: white;
        }
        .momentum-bar.obj1 { background: linear-gradient(90deg, #3b82f6, #2563eb); }
        .momentum-bar.obj2 { background: linear-gradient(90deg, #f59e0b, #d97706); }

        .formula-section { padding: 1rem; border-top: 1px solid var(--border-light); }
        .formula-section h4 { margin: 0 0 1rem; font-size: 0.9rem; color: var(--text-primary); }
        .formula-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 0.75rem; }
        .formula-card { background: var(--surface-2); border-radius: 10px; padding: 1rem; border: 1px solid var(--border-light); }
        .formula-code { font-family: 'JetBrains Mono', monospace; font-size: 0.95rem; font-weight: 700; color: var(--physics-pink); margin-bottom: 0.25rem; }
        .formula-name { font-size: 0.7rem; color: var(--text-secondary); }

        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple)); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 400px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--physics-pink); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--physics-pink); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: var(--physics-blue); margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--physics-pink); font-weight: 700; }
        .step-result { background: linear-gradient(135deg, rgba(5,150,105,0.1), rgba(16,185,129,0.1)); border: 1px solid rgba(5,150,105,0.3); border-radius: 8px; padding: 0.75rem; margin-top: 0.5rem; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: var(--physics-green); font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1.1rem; font-weight: 700; color: var(--physics-green); }

        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .edu-content ul { padding-left: 1.5rem; }

        .examples-section { margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid var(--border-light); }
        .examples-section h4 { margin: 0 0 1rem; font-size: 0.9rem; color: var(--text-primary); }
        .examples-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.75rem; }
        .example-card { background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 10px; padding: 0.75rem; cursor: pointer; transition: all 0.2s; text-align: center; }
        .example-card:hover { border-color: var(--physics-pink); transform: translateY(-2px); }
        .example-icon { font-size: 1.5rem; margin-bottom: 0.25rem; }
        .example-title { font-size: 0.8rem; font-weight: 600; color: var(--text-primary); }
        .example-desc { font-size: 0.7rem; color: var(--text-secondary); }

        @media (max-width: 768px) {
            .tool-page-title { font-size: 1.25rem; }
            .collision-container { height: 220px; }
            .results-grid { grid-template-columns: 1fr; }
            .result-card.highlight { grid-column: span 1; }
            .mode-tabs { flex-direction: column; }
        }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>💥</span> Momentum Calculator</h1>
            <p class="tool-page-description">Calculate momentum, impulse, and collision outcomes</p>
            <div class="tool-badges">
                <span class="tool-badge">p = mv</span>
                <span class="tool-badge">J = FΔt</span>
                <span class="tool-badge">Collisions</span>
                <span class="tool-badge">Animated</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Conservation of Momentum</div>
            <p><strong>p = mv</strong> — In an isolated system with no external forces, total momentum before collision equals total momentum after: <strong>m₁u₁ + m₂u₂ = m₁v₁ + m₂v₂</strong></p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Momentum Calculator</h2>
                    <p>Configure collision parameters</p>
                </div>
                <div class="panel-body">
                    <!-- Mode Tabs -->
                    <div class="mode-tabs">
                        <button class="mode-tab active" onclick="setMode('basic')" data-mode="basic">Basic p=mv</button>
                        <button class="mode-tab" onclick="setMode('impulse')" data-mode="impulse">Impulse</button>
                        <button class="mode-tab" onclick="setMode('collision')" data-mode="collision">Collision</button>
                    </div>

                    <!-- Basic Mode Inputs -->
                    <div id="basic-inputs">
                        <div class="input-section">
                            <div class="input-label"><span>⚖️</span><span>Mass (m)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="mass-basic" class="number-input" value="10" min="0.001" step="0.1">
                                <select id="mass-basic-unit" class="unit-select" onchange="calculate()">
                                    <option value="kg" selected>kg</option>
                                    <option value="g">g</option>
                                    <option value="lb">lb</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>🚀</span><span>Velocity (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="vel-basic" class="number-input" value="5" step="0.1">
                                <select id="vel-basic-unit" class="unit-select" onchange="calculate()">
                                    <option value="m/s" selected>m/s</option>
                                    <option value="km/h">km/h</option>
                                    <option value="mph">mph</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Impulse Mode Inputs -->
                    <div id="impulse-inputs" style="display: none;">
                        <div class="input-section">
                            <div class="input-label"><span>💪</span><span>Force (F)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="force-impulse" class="number-input" value="100" min="0" step="1">
                                <select id="force-impulse-unit" class="unit-select" onchange="calculate()">
                                    <option value="N" selected>N</option>
                                    <option value="kN">kN</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>⏱️</span><span>Time Duration (Δt)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="time-impulse" class="number-input" value="0.5" min="0.001" step="0.01">
                                <select id="time-impulse-unit" class="unit-select" onchange="calculate()">
                                    <option value="s" selected>s</option>
                                    <option value="ms">ms</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>⚖️</span><span>Object Mass (optional)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="mass-impulse" class="number-input" value="10" min="0.001" step="0.1">
                                <span class="unit-select" style="background: var(--surface-3);">kg</span>
                            </div>
                        </div>
                    </div>

                    <!-- Collision Mode Inputs -->
                    <div id="collision-inputs" style="display: none;">
                        <div class="object-inputs object-1">
                            <div class="object-header"><span class="object-color"></span> Object 1 (Blue)</div>
                            <div class="input-section" style="margin-bottom: 0.75rem;">
                                <div class="input-label" style="font-size: 0.8rem;"><span>⚖️</span><span>Mass m₁</span></div>
                                <div class="input-with-unit">
                                    <input type="number" id="m1" class="number-input" value="5" min="0.001" step="0.1">
                                    <span class="unit-select" style="background: var(--surface-3);">kg</span>
                                </div>
                            </div>
                            <div class="input-section" style="margin-bottom: 0;">
                                <div class="input-label" style="font-size: 0.8rem;"><span>🚀</span><span>Velocity u₁</span></div>
                                <div class="input-with-unit">
                                    <input type="number" id="u1" class="number-input" value="10" step="0.1">
                                    <span class="unit-select" style="background: var(--surface-3);">m/s</span>
                                </div>
                            </div>
                        </div>

                        <div class="object-inputs object-2">
                            <div class="object-header"><span class="object-color"></span> Object 2 (Orange)</div>
                            <div class="input-section" style="margin-bottom: 0.75rem;">
                                <div class="input-label" style="font-size: 0.8rem;"><span>⚖️</span><span>Mass m₂</span></div>
                                <div class="input-with-unit">
                                    <input type="number" id="m2" class="number-input" value="3" min="0.001" step="0.1">
                                    <span class="unit-select" style="background: var(--surface-3);">kg</span>
                                </div>
                            </div>
                            <div class="input-section" style="margin-bottom: 0;">
                                <div class="input-label" style="font-size: 0.8rem;"><span>🚀</span><span>Velocity u₂</span></div>
                                <div class="input-with-unit">
                                    <input type="number" id="u2" class="number-input" value="-5" step="0.1">
                                    <span class="unit-select" style="background: var(--surface-3);">m/s</span>
                                </div>
                            </div>
                        </div>

                        <div class="collision-type-section">
                            <span class="collision-type-label">Collision Type:</span>
                            <div class="collision-types">
                                <button class="collision-type-btn active" onclick="setCollisionType('elastic')" data-type="elastic">Elastic</button>
                                <button class="collision-type-btn" onclick="setCollisionType('inelastic')" data-type="inelastic">Inelastic</button>
                                <button class="collision-type-btn" onclick="setCollisionType('perfect')" data-type="perfect">Perfectly Inelastic</button>
                            </div>
                            <div class="restitution-section" id="restitution-section">
                                <div class="input-label" style="font-size: 0.8rem;"><span>📊</span><span>Coefficient of Restitution (e): <span class="restitution-value" id="restitution-value">0.5</span></span></div>
                                <input type="range" id="restitution" class="restitution-slider" min="0" max="1" step="0.01" value="0.5" oninput="updateRestitution()">
                                <div style="display: flex; justify-content: space-between; font-size: 0.7rem; color: var(--text-secondary); margin-top: 0.25rem;">
                                    <span>0 (Perfectly Inelastic)</span>
                                    <span>1 (Elastic)</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <button class="calc-btn" onclick="calculate()"><span>⚡</span><span>Calculate</span></button>
                    <button class="animate-btn" id="animate-btn" onclick="toggleAnimation()"><span>▶️</span><span>Animate Collision</span></button>

                    <!-- Results -->
                    <div class="results-grid" id="results-grid">
                        <div class="result-card highlight">
                            <div class="result-icon">💥</div>
                            <div class="result-label">Momentum</div>
                            <div class="result-value" id="result-momentum">50.00 kg·m/s</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">📊</div>
                            <div class="result-label">Total Before</div>
                            <div class="result-value" id="result-before">50.00 kg·m/s</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">📈</div>
                            <div class="result-label">Total After</div>
                            <div class="result-value" id="result-after">50.00 kg·m/s</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">⚡</div>
                            <div class="result-label">KE Lost</div>
                            <div class="result-value" id="result-ke-lost">0.00 J</div>
                        </div>
                    </div>

                    <!-- Examples -->
                    <div class="examples-section">
                        <h4>📚 Try These Examples</h4>
                        <div class="examples-grid">
                            <div class="example-card" onclick="loadExample(1)">
                                <div class="example-icon">🚗</div>
                                <div class="example-title">Car Crash</div>
                                <div class="example-desc">1000kg + 800kg</div>
                            </div>
                            <div class="example-card" onclick="loadExample(2)">
                                <div class="example-icon">🎱</div>
                                <div class="example-title">Billiard Balls</div>
                                <div class="example-desc">Elastic collision</div>
                            </div>
                            <div class="example-card" onclick="loadExample(3)">
                                <div class="example-icon">🏀</div>
                                <div class="example-title">Bouncing Ball</div>
                                <div class="example-desc">e = 0.8</div>
                            </div>
                            <div class="example-card" onclick="loadExample(4)">
                                <div class="example-icon">🚂</div>
                                <div class="example-title">Train Coupling</div>
                                <div class="example-desc">Perfectly inelastic</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Simulation Panel -->
            <div class="simulation-panel">
                <div class="simulation-header"><h3>💥 Collision Visualization</h3></div>

                <div class="collision-container" id="collision-container">
                    <canvas class="collision-canvas" id="collision-canvas"></canvas>
                    <div class="collision-info">
                        <div class="collision-info-pill" id="info-p1">p₁ = 50 kg·m/s</div>
                        <div class="collision-info-pill" id="info-p2">p₂ = -15 kg·m/s</div>
                        <div class="collision-info-pill" id="info-total">Σp = 35 kg·m/s</div>
                    </div>
                </div>

                <!-- Momentum Bars (only for collision mode) -->
                <div class="momentum-bars" id="momentum-bars" style="display: none;">
                    <div class="momentum-bar-group">
                        <div class="momentum-bar-label">Before Collision</div>
                        <div class="momentum-bar-container">
                            <div class="momentum-bar obj1" id="bar-before-1" style="width: 60%;">p₁</div>
                            <div class="momentum-bar obj2" id="bar-before-2" style="width: 20%;">p₂</div>
                        </div>
                    </div>
                    <div class="momentum-bar-group">
                        <div class="momentum-bar-label">After Collision</div>
                        <div class="momentum-bar-container">
                            <div class="momentum-bar obj1" id="bar-after-1" style="width: 30%;">p₁'</div>
                            <div class="momentum-bar obj2" id="bar-after-2" style="width: 50%;">p₂'</div>
                        </div>
                    </div>
                </div>

                <!-- Formulas -->
                <div class="formula-section">
                    <h4>📝 Momentum Formulas</h4>
                    <div class="formula-grid">
                        <div class="formula-card"><div class="formula-code">p = mv</div><div class="formula-name">Momentum</div></div>
                        <div class="formula-card"><div class="formula-code">J = FΔt = Δp</div><div class="formula-name">Impulse</div></div>
                        <div class="formula-card"><div class="formula-code">Σp = const</div><div class="formula-name">Conservation</div></div>
                        <div class="formula-card"><div class="formula-code">e = -(v₂-v₁)/(u₂-u₁)</div><div class="formula-name">Restitution</div></div>
                    </div>
                </div>

                <!-- Steps -->
                <div class="steps-section">
                    <div class="steps-header" onclick="toggleSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="steps-body"></div>
                </div>
            </div>
        </div>

        <!-- Educational Content -->
        <div class="edu-content">
            <h2>Understanding Momentum and Collisions</h2>
            <p>Momentum is the product of an object's mass and velocity. It's a vector quantity, meaning it has both magnitude and direction. The law of conservation of momentum states that in an isolated system, the total momentum remains constant.</p>

            <h3>Types of Collisions</h3>
            <ul>
                <li><strong>Elastic Collision (e = 1):</strong> Both momentum AND kinetic energy are conserved. Objects bounce off each other (billiard balls).</li>
                <li><strong>Inelastic Collision (0 < e < 1):</strong> Momentum is conserved but some kinetic energy is lost (most real-world collisions).</li>
                <li><strong>Perfectly Inelastic (e = 0):</strong> Objects stick together after collision. Maximum kinetic energy loss while momentum is still conserved.</li>
            </ul>

            <h3>Impulse-Momentum Theorem</h3>
            <p>Impulse (J) equals the change in momentum: <strong>J = FΔt = Δp = m(v - u)</strong>. This explains why airbags work — they increase collision time, reducing the force on passengers.</p>

            <h3>Real-World Applications</h3>
            <ul>
                <li><strong>Vehicle Safety:</strong> Crumple zones and airbags extend collision time</li>
                <li><strong>Sports:</strong> Follow-through in golf, tennis, and baseball maximizes impulse</li>
                <li><strong>Rockets:</strong> Propulsion based on conservation of momentum</li>
                <li><strong>Ballistics:</strong> Bullet and recoil momentum analysis</li>
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
    <!-- Matter.js Physics Engine -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/matter-js/0.19.0/matter.min.js"></script>
    <script src="<%=request.getContextPath()%>/physics/js/momentum-calculator.js?v=<%=cacheVersion%>"></script>
</body>
</html>
