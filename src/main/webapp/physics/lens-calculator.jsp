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
        <jsp:param name="toolName" value="Lens Calculator - Thin Lens, Magnification & Ray Diagrams" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Calculate image position, magnification, and focal length using thin lens formula (1/f = 1/v - 1/u). Includes lens maker formula, power calculation, and interactive ray diagrams." />
        <jsp:param name="toolUrl" value="physics/lens-calculator.jsp" />
        <jsp:param name="toolKeywords" value="lens calculator, thin lens formula, magnification calculator, ray diagram, optics calculator, focal length, lens maker formula, diopters, converging lens, diverging lens" />
        <jsp:param name="toolImage" value="lens-calculator.png" />
        <jsp:param name="toolFeatures" value="Thin lens formula,Lens maker formula,Ray diagrams,Magnification,Power in diopters,Combined lenses,Step-by-step solutions" />
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
            --physics-cyan: #0891b2;
            --physics-indigo: #4f46e5;
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
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
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

        .info-box {
            background: linear-gradient(135deg, rgba(79,70,229,0.1), rgba(124,58,237,0.1));
            border-left: 4px solid var(--physics-indigo);
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
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: white;
            padding: 1.25rem 1.5rem;
        }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }

        .mode-tabs { display: flex; gap: 0.5rem; margin-bottom: 1.5rem; flex-wrap: wrap; }
        .mode-tab {
            flex: 1;
            min-width: 100px;
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
        .mode-tab:hover { border-color: var(--physics-indigo); color: var(--physics-indigo); }
        .mode-tab.active { background: linear-gradient(135deg, #4f46e5, #7c3aed); border-color: transparent; color: white; }

        .lens-type-section {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1.25rem;
            border: 1px solid var(--border-light);
        }
        .lens-type-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.75rem; display: block; }
        .lens-types { display: flex; gap: 0.5rem; }
        .lens-type-btn {
            flex: 1;
            padding: 0.75rem;
            background: var(--surface-1);
            border: 2px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }
        .lens-type-btn:hover { border-color: var(--physics-indigo); }
        .lens-type-btn.active { background: var(--physics-indigo); border-color: var(--physics-indigo); color: white; }
        .lens-type-btn .lens-icon { font-size: 1.5rem; display: block; margin-bottom: 0.25rem; }

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
        .number-input:focus { outline: none; border-color: var(--physics-indigo); }
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
            min-width: 60px;
        }

        .solve-for-section { background: var(--surface-2); border-radius: 12px; padding: 1rem; margin-bottom: 1.25rem; border: 1px solid var(--border-light); }
        .solve-for-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.75rem; display: block; }
        .solve-for-btns { display: flex; gap: 0.5rem; flex-wrap: wrap; }
        .solve-btn {
            flex: 1;
            min-width: 70px;
            padding: 0.625rem 0.5rem;
            background: var(--surface-1);
            border: 2px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
        }
        .solve-btn:hover { border-color: var(--physics-indigo); color: var(--physics-indigo); }
        .solve-btn.active { background: var(--physics-indigo); border-color: var(--physics-indigo); color: white; }

        .calc-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
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
        }
        .calc-btn:hover { transform: translateY(-2px); }

        .results-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.75rem; margin-top: 1.5rem; }
        .result-card {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            border: 1px solid var(--border-light);
        }
        .result-card.highlight {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: white;
            border: none;
            grid-column: span 2;
        }
        .result-icon { font-size: 1.5rem; margin-bottom: 0.5rem; }
        .result-label { font-size: 0.7rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.8; margin-bottom: 0.25rem; }
        .result-value { font-size: 1.1rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; }
        .result-card:not(.highlight) .result-value { color: var(--text-primary); }
        .result-card .result-note { font-size: 0.7rem; margin-top: 0.25rem; opacity: 0.8; }

        .simulation-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            border: 1px solid var(--border-light);
        }
        .simulation-header {
            background: linear-gradient(135deg, rgba(79,70,229,0.1), rgba(124,58,237,0.05));
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border-light);
        }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }

        .ray-diagram-container {
            position: relative;
            width: 100%;
            height: 320px;
            background: linear-gradient(180deg, #eef2ff 0%, #e0e7ff 100%);
            margin: 1rem;
            border-radius: 12px;
            overflow: hidden;
            border: 2px solid var(--border-light);
        }
        [data-theme="dark"] .ray-diagram-container, .dark-mode .ray-diagram-container {
            background: linear-gradient(180deg, #1e1b4b 0%, #0f172a 100%);
        }
        .ray-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .ray-info {
            position: absolute;
            bottom: 10px;
            left: 10px;
            right: 10px;
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        .ray-info-pill {
            background: rgba(255,255,255,0.95);
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-primary);
            box-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }
        [data-theme="dark"] .ray-info-pill, .dark-mode .ray-info-pill { background: rgba(30,41,59,0.95); }

        .image-properties {
            display: flex;
            gap: 1rem;
            padding: 1rem;
            background: var(--surface-2);
            border-top: 1px solid var(--border-light);
            flex-wrap: wrap;
        }
        .property-badge {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .property-badge.real { background: rgba(5,150,105,0.1); color: #059669; border: 1px solid rgba(5,150,105,0.3); }
        .property-badge.virtual { background: rgba(234,88,12,0.1); color: #ea580c; border: 1px solid rgba(234,88,12,0.3); }
        .property-badge.inverted { background: rgba(220,38,38,0.1); color: #dc2626; border: 1px solid rgba(220,38,38,0.3); }
        .property-badge.erect { background: rgba(37,99,235,0.1); color: #2563eb; border: 1px solid rgba(37,99,235,0.3); }
        .property-badge.magnified { background: rgba(124,58,237,0.1); color: #7c3aed; border: 1px solid rgba(124,58,237,0.3); }
        .property-badge.diminished { background: rgba(100,116,139,0.1); color: #64748b; border: 1px solid rgba(100,116,139,0.3); }

        .formula-section { padding: 1rem; border-top: 1px solid var(--border-light); }
        .formula-section h4 { margin: 0 0 1rem; font-size: 0.9rem; color: var(--text-primary); }
        .formula-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 0.75rem; }
        .formula-card { background: var(--surface-2); border-radius: 10px; padding: 1rem; border: 1px solid var(--border-light); }
        .formula-code { font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; font-weight: 700; color: var(--physics-indigo); margin-bottom: 0.25rem; }
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

        .examples-section { margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid var(--border-light); }
        .examples-section h4 { margin: 0 0 1rem; font-size: 0.9rem; color: var(--text-primary); }
        .examples-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.75rem; }
        .example-card { background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 10px; padding: 0.75rem; cursor: pointer; transition: all 0.2s; text-align: center; }
        .example-card:hover { border-color: var(--physics-indigo); transform: translateY(-2px); }
        .example-icon { font-size: 1.5rem; margin-bottom: 0.25rem; }
        .example-title { font-size: 0.8rem; font-weight: 600; color: var(--text-primary); }
        .example-desc { font-size: 0.7rem; color: var(--text-secondary); }

        @media (max-width: 768px) {
            .tool-page-title { font-size: 1.25rem; }
            .ray-diagram-container { height: 260px; }
            .results-grid { grid-template-columns: 1fr; }
            .result-card.highlight { grid-column: span 1; }
            .lens-types { flex-direction: column; }
        }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🔬</span> Lens Calculator</h1>
            <p class="tool-page-description">Thin lens formula, magnification, and ray diagrams</p>
            <div class="tool-badges">
                <span class="tool-badge">1/f = 1/v - 1/u</span>
                <span class="tool-badge">m = v/u</span>
                <span class="tool-badge">Ray Diagrams</span>
                <span class="tool-badge">P = 1/f</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Thin Lens Formula</div>
            <p><strong>1/f = 1/v - 1/u</strong> — Where f is focal length, v is image distance, and u is object distance. Sign convention: distances measured from optical center, real is positive.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Lens Calculator</h2>
                    <p>Configure lens parameters</p>
                </div>
                <div class="panel-body">
                    <!-- Mode Tabs -->
                    <div class="mode-tabs">
                        <button class="mode-tab active" onclick="setMode('thinlens')" data-mode="thinlens">Thin Lens</button>
                        <button class="mode-tab" onclick="setMode('lensmaker')" data-mode="lensmaker">Lens Maker</button>
                        <button class="mode-tab" onclick="setMode('combined')" data-mode="combined">Combined</button>
                    </div>

                    <!-- Lens Type Selection -->
                    <div class="lens-type-section">
                        <span class="lens-type-label">Lens Type:</span>
                        <div class="lens-types">
                            <button class="lens-type-btn active" onclick="setLensType('converging')" data-type="converging">
                                <span class="lens-icon">🔍</span>
                                Converging (+)
                            </button>
                            <button class="lens-type-btn" onclick="setLensType('diverging')" data-type="diverging">
                                <span class="lens-icon">🔎</span>
                                Diverging (-)
                            </button>
                        </div>
                    </div>

                    <!-- Thin Lens Inputs -->
                    <div id="thinlens-inputs">
                        <div class="solve-for-section">
                            <span class="solve-for-label">Solve for:</span>
                            <div class="solve-for-btns">
                                <button class="solve-btn active" onclick="setSolveFor('v')" data-var="v">Image (v)</button>
                                <button class="solve-btn" onclick="setSolveFor('u')" data-var="u">Object (u)</button>
                                <button class="solve-btn" onclick="setSolveFor('f')" data-var="f">Focal (f)</button>
                            </div>
                        </div>

                        <div class="input-section" id="focal-section">
                            <div class="input-label"><span>🎯</span><span>Focal Length (f)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="focal-length" class="number-input" value="10" min="0.1" step="0.1">
                                <select id="focal-unit" class="unit-select" onchange="calculate()">
                                    <option value="cm" selected>cm</option>
                                    <option value="m">m</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>

                        <div class="input-section" id="object-section">
                            <div class="input-label"><span>📍</span><span>Object Distance (u)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="object-dist" class="number-input" value="25" min="0.1" step="0.1">
                                <select id="object-unit" class="unit-select" onchange="calculate()">
                                    <option value="cm" selected>cm</option>
                                    <option value="m">m</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>

                        <div class="input-section" id="image-section" style="display: none;">
                            <div class="input-label"><span>🖼️</span><span>Image Distance (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="image-dist" class="number-input" value="16.67" step="0.1">
                                <select id="image-unit" class="unit-select" onchange="calculate()">
                                    <option value="cm" selected>cm</option>
                                    <option value="m">m</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>

                        <div class="input-section">
                            <div class="input-label"><span>📏</span><span>Object Height (optional)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="object-height" class="number-input" value="5" min="0.1" step="0.1">
                                <span class="unit-select" style="background: var(--surface-3);">cm</span>
                            </div>
                        </div>
                    </div>

                    <!-- Lens Maker Inputs -->
                    <div id="lensmaker-inputs" style="display: none;">
                        <div class="input-section">
                            <div class="input-label"><span>💎</span><span>Refractive Index (μ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="refractive-index" class="number-input" value="1.5" min="1" max="3" step="0.01">
                                <span class="unit-select" style="background: var(--surface-3);">n</span>
                            </div>
                            <div style="display: flex; gap: 0.5rem; margin-top: 0.5rem; flex-wrap: wrap;">
                                <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.7rem;" onclick="setRefractiveIndex(1.5)">Glass 1.5</button>
                                <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.7rem;" onclick="setRefractiveIndex(1.52)">Crown 1.52</button>
                                <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.7rem;" onclick="setRefractiveIndex(1.62)">Flint 1.62</button>
                                <button class="solve-btn" style="flex: none; padding: 0.4rem 0.6rem; font-size: 0.7rem;" onclick="setRefractiveIndex(2.42)">Diamond 2.42</button>
                            </div>
                        </div>

                        <div class="input-section">
                            <div class="input-label"><span>⭕</span><span>Radius of Curvature R₁</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="radius1" class="number-input" value="20" step="0.1">
                                <span class="unit-select" style="background: var(--surface-3);">cm</span>
                            </div>
                        </div>

                        <div class="input-section">
                            <div class="input-label"><span>⭕</span><span>Radius of Curvature R₂</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="radius2" class="number-input" value="-20" step="0.1">
                                <span class="unit-select" style="background: var(--surface-3);">cm</span>
                            </div>
                        </div>
                    </div>

                    <!-- Combined Lenses Inputs -->
                    <div id="combined-inputs" style="display: none;">
                        <div class="input-section">
                            <div class="input-label"><span>🔍</span><span>Focal Length f₁</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="f1" class="number-input" value="10" step="0.1">
                                <span class="unit-select" style="background: var(--surface-3);">cm</span>
                            </div>
                        </div>

                        <div class="input-section">
                            <div class="input-label"><span>🔎</span><span>Focal Length f₂</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="f2" class="number-input" value="15" step="0.1">
                                <span class="unit-select" style="background: var(--surface-3);">cm</span>
                            </div>
                        </div>

                        <div class="input-section">
                            <div class="input-label"><span>↔️</span><span>Separation Distance (d)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="separation" class="number-input" value="0" min="0" step="0.1">
                                <span class="unit-select" style="background: var(--surface-3);">cm</span>
                            </div>
                            <div style="font-size: 0.75rem; color: var(--text-secondary); margin-top: 0.25rem;">
                                d = 0 for lenses in contact
                            </div>
                        </div>
                    </div>

                    <button class="calc-btn" onclick="calculate()"><span>⚡</span><span>Calculate</span></button>

                    <!-- Results -->
                    <div id="results-grid" class="results-grid">
                        <div class="result-card highlight">
                            <div class="result-icon">🖼️</div>
                            <div class="result-label">Image Distance</div>
                            <div class="result-value" id="result-image">16.67 cm</div>
                            <div class="result-note" id="result-image-note">Real image</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">🔍</div>
                            <div class="result-label">Magnification</div>
                            <div class="result-value" id="result-mag">-0.67×</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">📏</div>
                            <div class="result-label">Image Height</div>
                            <div class="result-value" id="result-height">-3.33 cm</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">👓</div>
                            <div class="result-label">Power</div>
                            <div class="result-value" id="result-power">+10.0 D</div>
                        </div>
                    </div>

                    <!-- Examples -->
                    <div class="examples-section">
                        <h4>📚 Try These Examples</h4>
                        <div class="examples-grid">
                            <div class="example-card" onclick="loadExample(1)">
                                <div class="example-icon">🔬</div>
                                <div class="example-title">Microscope</div>
                                <div class="example-desc">f=2cm, u=2.5cm</div>
                            </div>
                            <div class="example-card" onclick="loadExample(2)">
                                <div class="example-icon">📷</div>
                                <div class="example-title">Camera</div>
                                <div class="example-desc">f=50mm, u=2m</div>
                            </div>
                            <div class="example-card" onclick="loadExample(3)">
                                <div class="example-icon">👓</div>
                                <div class="example-title">Reading Glasses</div>
                                <div class="example-desc">+2.5 Diopters</div>
                            </div>
                            <div class="example-card" onclick="loadExample(4)">
                                <div class="example-icon">🔭</div>
                                <div class="example-title">Telescope</div>
                                <div class="example-desc">Combined lenses</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Simulation Panel -->
            <div class="simulation-panel">
                <div class="simulation-header"><h3>🔬 Ray Diagram</h3></div>

                <div class="ray-diagram-container" id="ray-container">
                    <canvas class="ray-canvas" id="ray-canvas"></canvas>
                    <div class="ray-info">
                        <div class="ray-info-pill" id="info-u">u = 25 cm</div>
                        <div class="ray-info-pill" id="info-v">v = 16.67 cm</div>
                        <div class="ray-info-pill" id="info-f">f = 10 cm</div>
                    </div>
                </div>

                <!-- Image Properties -->
                <div class="image-properties" id="image-properties">
                    <span class="property-badge real" id="prop-real">Real Image</span>
                    <span class="property-badge inverted" id="prop-orientation">Inverted</span>
                    <span class="property-badge diminished" id="prop-size">Diminished</span>
                </div>

                <!-- Formulas -->
                <div class="formula-section">
                    <h4>📝 Lens Formulas</h4>
                    <div class="formula-grid">
                        <div class="formula-card"><div class="formula-code">1/f = 1/v - 1/u</div><div class="formula-name">Thin Lens</div></div>
                        <div class="formula-card"><div class="formula-code">m = v/u = hᵢ/hₒ</div><div class="formula-name">Magnification</div></div>
                        <div class="formula-card"><div class="formula-code">P = 1/f (D)</div><div class="formula-name">Power</div></div>
                        <div class="formula-card"><div class="formula-code">1/f = (μ-1)(1/R₁-1/R₂)</div><div class="formula-name">Lens Maker</div></div>
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
            <h2>Understanding Lenses and Optics</h2>
            <p>Lenses refract light to form images. The thin lens equation relates the focal length to object and image distances, allowing us to predict where images will form and their characteristics.</p>

            <h3>Sign Convention (Real is Positive)</h3>
            <ul>
                <li><strong>Object distance (u):</strong> Always positive for real objects</li>
                <li><strong>Image distance (v):</strong> Positive for real images, negative for virtual</li>
                <li><strong>Focal length (f):</strong> Positive for converging, negative for diverging</li>
                <li><strong>Magnification (m):</strong> Negative means inverted, positive means erect</li>
            </ul>

            <h3>Image Characteristics</h3>
            <ul>
                <li><strong>Real vs Virtual:</strong> Real images can be projected (v > 0); virtual cannot (v < 0)</li>
                <li><strong>Magnification:</strong> |m| > 1 means magnified, |m| < 1 means diminished</li>
                <li><strong>Orientation:</strong> m < 0 means inverted, m > 0 means erect</li>
            </ul>

            <h3>Special Cases</h3>
            <ul>
                <li><strong>Object at infinity:</strong> Image forms at focal point (v = f)</li>
                <li><strong>Object at focus:</strong> Image at infinity (parallel rays emerge)</li>
                <li><strong>Object at 2f:</strong> Image at 2f, same size, inverted (m = -1)</li>
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
    <script src="<%=request.getContextPath()%>/physics/js/lens-calculator.js?v=<%=cacheVersion%>"></script>
</body>
</html>
