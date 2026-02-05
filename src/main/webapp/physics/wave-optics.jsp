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
        <jsp:param name="toolName" value="Wave Optics - Young's Double Slit, Diffraction Grating, Single Slit Calculator" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Wave optics: Young's double slit fringe width β = λD/d, position of bright/dark fringes, diffraction grating d sin θ = n λ, single slit angular width 2λ/a. Free calculators with step-by-step solutions and diagrams." />
        <jsp:param name="toolUrl" value="physics/wave-optics.jsp" />
        <jsp:param name="toolKeywords" value="wave optics, Young double slit, fringe width, diffraction grating, single slit, interference, diffraction, optics, JEE NEET" />
        <jsp:param name="toolImage" value="wave-optics.png" />
        <jsp:param name="toolFeatures" value="Young double slit calculator,Fringe width calculator,Diffraction grating calculator,Single slit calculator,Step-by-step solutions,Canvas diagrams" />
        <jsp:param name="faq1q" value="What is the fringe width in Young's double slit?" />
        <jsp:param name="faq1a" value="Fringe width β = λD/d, where λ is wavelength, D is distance from slits to screen, and d is slit separation. Distance between consecutive bright (or dark) fringes." />
        <jsp:param name="faq2q" value="What is the diffraction grating formula?" />
        <jsp:param name="faq2a" value="d sin θ = n λ, where d is grating element (slit spacing), θ is angle of the nth maximum, n is order, and λ is wavelength." />
        <jsp:param name="faq3q" value="What is the angular width of the central maximum in single slit?" />
        <jsp:param name="faq3a" value="Angular width of the central maximum (between first minima on each side) is approximately 2λ/a, where a is slit width and λ is wavelength." />
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
        :root { --wo-indigo: #6366f1; --wo-violet: #8b5cf6; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(99,102,241,0.1), rgba(139,92,246,0.1)); border-left: 4px solid var(--wo-indigo); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .wo-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .wo-tab { padding: 0.5rem 0.6rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.7rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .wo-tab:hover { border-color: var(--wo-indigo); color: var(--wo-indigo); }
        .wo-tab.active { background: linear-gradient(135deg, #6366f1, #8b5cf6); border-color: #8b5cf6; color: white; }
        .wo-panel { display: none; }
        .wo-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .number-input { width: 100%; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--wo-indigo); }
        .input-with-unit { display: flex; gap: 0; }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; min-width: 65px; }
        .result-card { background: linear-gradient(135deg, rgba(99,102,241,0.15), rgba(139,92,246,0.1)); border: 2px solid var(--wo-indigo); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.25rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--wo-indigo); }
        .wo-grating-solve { padding: 0.4rem 0.6rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; margin-right: 0.25rem; margin-bottom: 0.25rem; }
        .wo-grating-solve.active { background: linear-gradient(135deg, #6366f1, #8b5cf6); border-color: #8b5cf6; color: white; }
        .radio-group { display: flex; gap: 1rem; margin-top: 0.5rem; }
        .radio-group label { display: flex; align-items: center; gap: 0.5rem; cursor: pointer; font-size: 0.9rem; color: var(--text-secondary); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-weight: 700; color: var(--wo-indigo); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--wo-indigo); }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--wo-indigo); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #6366f1; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(99,102,241,0.1), rgba(139,92,246,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .wo-viz-container { position: relative; width: 100%; height: 220px; background: linear-gradient(180deg, #eef2ff 0%, #e0e7ff 100%); overflow: hidden; }
        .wo-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: block; }
        .wo-viz-placeholder { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: var(--text-secondary); font-size: 0.9rem; }
        [data-theme="dark"] .wo-viz-container { background: linear-gradient(180deg, #312e81 0%, #4c1d95 100%); }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--wo-indigo); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>〰️</span> Wave Optics</h1>
            <p class="tool-page-description">Young's double slit, diffraction grating, single slit</p>
            <div class="tool-badges">
                <span class="tool-badge">β = λD/d</span>
                <span class="tool-badge">d sin θ = n λ</span>
                <span class="tool-badge">2λ/a</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Interference &amp; diffraction</div>
            <p><strong>Young's double slit:</strong> Fringe width β = λD/d. Bright fringe position y_n = nλD/d; dark y_n = (2n−1)λD/(2d). <strong>Diffraction grating:</strong> d sin θ = n λ (d = grating spacing). <strong>Single slit:</strong> Angular width of central maximum ≈ 2λ/a (a = slit width).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Wave optics calculators</h2>
                    <p>Young, grating, single slit</p>
                </div>
                <div class="panel-body">
                    <div class="wo-tabs">
                        <button type="button" class="wo-tab active" data-tab="young" onclick="if(window.switchWOTab)window.switchWOTab('young',this);">Young β</button>
                        <button type="button" class="wo-tab" data-tab="youngpos" onclick="if(window.switchWOTab)window.switchWOTab('youngpos',this);">Fringe pos</button>
                        <button type="button" class="wo-tab" data-tab="grating" onclick="if(window.switchWOTab)window.switchWOTab('grating',this);">Grating</button>
                        <button type="button" class="wo-tab" data-tab="singleslit" onclick="if(window.switchWOTab)window.switchWOTab('singleslit',this);">Single slit</button>
                    </div>

                    <div id="panel-wo-young" class="wo-panel active">
                        <div class="input-section">
                            <div class="input-label">Wavelength λ</div>
                            <div class="input-with-unit">
                                <input type="number" id="wo-lambda" class="number-input wo-number-input" value="600" min="0" step="any">
                                <select id="wo-lambda-unit" class="unit-select wo-unit-select">
                                    <option value="nm">nm</option>
                                    <option value="Å">Å</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Screen distance D</div>
                            <div class="input-with-unit">
                                <input type="number" id="wo-D" class="number-input wo-number-input" value="1" min="0" step="any">
                                <select id="wo-D-unit" class="unit-select wo-unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Slit separation d</div>
                            <div class="input-with-unit">
                                <input type="number" id="wo-d" class="number-input wo-number-input" value="0.5" min="0" step="any">
                                <select id="wo-d-unit" class="unit-select wo-unit-select">
                                    <option value="mm">mm</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="result-card">
                            <div class="result-label">Fringe width β = λD/d</div>
                            <div class="result-value" id="wo-young-result">—</div>
                        </div>
                    </div>

                    <div id="panel-wo-youngpos" class="wo-panel">
                        <div class="input-section">
                            <div class="input-label">Wavelength λ</div>
                            <div class="input-with-unit">
                                <input type="number" id="wo-lambda-pos" class="number-input wo-number-input" value="600" min="0" step="any">
                                <select id="wo-lambda-pos-unit" class="unit-select wo-unit-select">
                                    <option value="nm">nm</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">D</div>
                            <div class="input-with-unit">
                                <input type="number" id="wo-D-pos" class="number-input wo-number-input" value="1" min="0" step="any">
                                <select id="wo-D-pos-unit" class="unit-select wo-unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Slit separation d</div>
                            <div class="input-with-unit">
                                <input type="number" id="wo-d-pos" class="number-input wo-number-input" value="0.5" min="0" step="any">
                                <select id="wo-d-pos-unit" class="unit-select wo-unit-select">
                                    <option value="mm">mm</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Fringe order n</div>
                            <input type="number" id="wo-n-fringe" class="number-input wo-number-input" value="1" min="0" step="1">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Type</div>
                            <div class="radio-group">
                                <label><input type="radio" name="wo-fringe-type" class="wo-fringe-type" value="bright" checked> Bright</label>
                                <label><input type="radio" name="wo-fringe-type" class="wo-fringe-type" value="dark"> Dark</label>
                            </div>
                        </div>
                        <div class="result-card">
                            <div class="result-label">Position y from centre</div>
                            <div class="result-value" id="wo-youngpos-result">—</div>
                        </div>
                    </div>

                    <div id="panel-wo-grating" class="wo-panel">
                        <div class="input-section">
                            <div class="input-label">Solve for</div>
                            <button type="button" class="wo-grating-solve active" data-var="theta" onclick="window.setGratingSolve('theta')">θ</button>
                            <button type="button" class="wo-grating-solve" data-var="lambda" onclick="window.setGratingSolve('lambda')">λ</button>
                            <button type="button" class="wo-grating-solve" data-var="n" onclick="window.setGratingSolve('n')">n</button>
                            <button type="button" class="wo-grating-solve" data-var="d" onclick="window.setGratingSolve('d')">d</button>
                        </div>
                        <div class="input-section" id="wo-grating-section-d">
                            <div class="input-label">Grating element d</div>
                            <div class="input-with-unit">
                                <input type="number" id="wo-grating-d" class="number-input wo-number-input" value="2" min="0" step="any">
                                <select id="wo-grating-d-unit" class="unit-select wo-unit-select">
                                    <option value="μm">μm</option>
                                    <option value="nm">nm</option>
                                    <option value="mm">mm</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="wo-grating-section-n">
                            <div class="input-label">Order n</div>
                            <input type="number" id="wo-grating-n" class="number-input wo-number-input" value="1" min="0" step="1">
                        </div>
                        <div class="input-section" id="wo-grating-section-lambda">
                            <div class="input-label">Wavelength λ</div>
                            <div class="input-with-unit">
                                <input type="number" id="wo-grating-lambda" class="number-input wo-number-input" value="600" min="0" step="any">
                                <select id="wo-grating-lambda-unit" class="unit-select wo-unit-select">
                                    <option value="nm">nm</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="wo-grating-section-theta">
                            <div class="input-label">Angle θ (°)</div>
                            <input type="number" id="wo-grating-theta" class="number-input wo-number-input" value="10" min="-90" max="90" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">d sin θ = n λ</div>
                            <div class="result-value" id="wo-grating-result">—</div>
                        </div>
                    </div>

                    <div id="panel-wo-singleslit" class="wo-panel">
                        <div class="input-section">
                            <div class="input-label">Wavelength λ</div>
                            <div class="input-with-unit">
                                <input type="number" id="wo-slit-lambda" class="number-input wo-number-input" value="600" min="0" step="any">
                                <select id="wo-slit-lambda-unit" class="unit-select wo-unit-select">
                                    <option value="nm">nm</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Slit width a</div>
                            <div class="input-with-unit">
                                <input type="number" id="wo-slit-a" class="number-input wo-number-input" value="0.1" min="0" step="any">
                                <select id="wo-slit-a-unit" class="unit-select wo-unit-select">
                                    <option value="mm">mm</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="result-card">
                            <div class="result-label">Angular width ≈ 2λ/a</div>
                            <div class="result-value" id="wo-singleslit-result">—</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>〰️ Diagram</h3></div>
                    <div class="wo-viz-container" id="wo-viz-container">
                        <canvas id="wo-viz-canvas" class="wo-viz-canvas" width="600" height="220"></canvas>
                        <div id="wo-viz-placeholder" class="wo-viz-placeholder" style="display: none;">Run a calculation to see diagram.</div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleWOSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="wo-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="wo-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Wave optics formulas">
                        <thead>
                            <tr><th>Concept</th><th>Formula</th><th>Notes</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Path difference (bright)</td>
                                <td class="form-equation">Δx = n λ</td>
                                <td class="form-desc">Constructive</td>
                            </tr>
                            <tr>
                                <td class="form-name">Path difference (dark)</td>
                                <td class="form-equation">Δx = (2n+1) λ/2</td>
                                <td class="form-desc">Destructive</td>
                            </tr>
                            <tr>
                                <td class="form-name">Fringe width (Young)</td>
                                <td class="form-equation">β = λ D / d</td>
                                <td class="form-desc">D = screen distance, d = slit separation</td>
                            </tr>
                            <tr>
                                <td class="form-name">Diffraction grating</td>
                                <td class="form-equation">d sin θ = n λ</td>
                                <td class="form-desc">d = grating element</td>
                            </tr>
                            <tr>
                                <td class="form-name">Single slit (angular width)</td>
                                <td class="form-equation">≈ 2λ/a</td>
                                <td class="form-desc">a = slit width</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="edu-content">
                    <h2>About wave optics</h2>
                    <p>In <strong>Young's double slit</strong>, constructive interference occurs when path difference Δx = nλ, giving bright fringes. Fringe width <strong>β = λD/d</strong>. Position of nth bright fringe from centre: <strong>y_n = nλD/d</strong>; nth dark: <strong>y_n = (2n−1)λD/(2d)</strong>. A <strong>diffraction grating</strong> with slit spacing d gives maxima at <strong>d sin θ = n λ</strong>. For a <strong>single slit</strong> of width a, the angular width of the central maximum (between first minima) is approximately <strong>2λ/a</strong>.</p>
                </div>
            </div>
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
    <script src="<%=request.getContextPath()%>/physics/js/wave-optics.js?v=<%=cacheVersion%>"></script>
</body>
</html>
