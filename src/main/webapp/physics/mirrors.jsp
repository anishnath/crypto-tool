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
        <jsp:param name="toolName" value="Reflection of Light - Spherical Mirror Formula, Focal Length, Magnification Calculator" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Reflection of light: mirror formula 1/f = 1/v + 1/u for spherical mirrors, f = R/2, magnification m = -v/u, number of images between two mirrors at angle θ. New Cartesian sign convention. Free calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/mirrors.jsp" />
        <jsp:param name="toolKeywords" value="reflection of light, spherical mirror formula, mirror calculator, concave mirror, convex mirror, focal length, magnification, number of images, optics, JEE NEET" />
        <jsp:param name="toolImage" value="mirrors-optics.png" />
        <jsp:param name="toolFeatures" value="Mirror formula calculator,Focal length from radius,Magnification calculator,Number of images two mirrors,Step-by-step solutions,New Cartesian sign convention" />
        <jsp:param name="faq1q" value="What is the mirror formula for spherical mirrors?" />
        <jsp:param name="faq1a" value="For spherical mirrors: 1/f = 1/v + 1/u, where f is focal length, v is image distance, u is object distance. Focal length and radius: f = R/2. Sign convention: u negative for real object, v positive for real image, f negative for concave." />
        <jsp:param name="faq2q" value="What is magnification for mirrors?" />
        <jsp:param name="faq2a" value="Magnification m = hᵢ/hₒ = -v/u. m &lt; 0 means inverted image, m &gt; 0 means erect. |m| &gt; 1 means magnified." />
        <jsp:param name="faq3q" value="How many images form between two mirrors at angle θ?" />
        <jsp:param name="faq3a" value="When 360°/θ is an integer, number of images n = 360°/θ − 1. For other angles, the number depends on object position; commonly n = floor(360°/θ)." />
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
        :root { --mirror-amber: #d97706; --mirror-orange: #ea580c; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #d97706 0%, #ea580c 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(217,119,6,0.1), rgba(234,88,12,0.1)); border-left: 4px solid var(--mirror-amber); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #d97706, #ea580c); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .mirror-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .mirror-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .mirror-tab:hover { border-color: var(--mirror-amber); color: var(--mirror-amber); }
        .mirror-tab.active { background: linear-gradient(135deg, #d97706, #ea580c); border-color: #ea580c; color: white; }
        .mirror-panel { display: none; }
        .mirror-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--mirror-amber); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .result-card { background: linear-gradient(135deg, rgba(217,119,6,0.15), rgba(234,88,12,0.1)); border: 2px solid var(--mirror-amber); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.25rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--mirror-amber); }
        .solve-for-btns { display: flex; gap: 0.25rem; flex-wrap: wrap; }
        .mirror-solve-btn { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.8rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; }
        .mirror-solve-btn:hover { border-color: var(--mirror-amber); color: var(--mirror-amber); }
        .mirror-solve-btn.active { background: linear-gradient(135deg, #d97706, #ea580c); border-color: #ea580c; color: white; }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #d97706, #ea580c); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--mirror-amber); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #d97706, #ea580c); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--mirror-amber); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--mirror-amber); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #d97706; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2, .edu-content h3 { color: var(--text-primary); }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--mirror-amber); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(217,119,6,0.1), rgba(234,88,12,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); }
        .mirror-viz-container { position: relative; width: 100%; height: 280px; background: linear-gradient(180deg, #fffbeb 0%, #fef3c7 100%); margin: 0; border-radius: 0 0 12px 12px; overflow: hidden; }
        .mirror-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: block; }
        .mirror-viz-placeholder { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: var(--text-secondary); font-size: 0.9rem; }
        [data-theme="dark"] .mirror-viz-container, .dark-mode .mirror-viz-container { background: linear-gradient(180deg, #422006 0%, #78350f 100%); }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🪞</span> Reflection of Light (Mirrors)</h1>
            <p class="tool-page-description">Spherical mirror formula 1/f = 1/v + 1/u, f = R/2, magnification, number of images</p>
            <div class="tool-badges">
                <span class="tool-badge">1/f = 1/v + 1/u</span>
                <span class="tool-badge">f = R/2</span>
                <span class="tool-badge">m = −v/u</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Sign convention (New Cartesian)</div>
            <p>Object distance u → negative for real object. Image distance v → positive for real image, negative for virtual. Focal length f → negative for concave mirror, positive for convex. Mirror formula: <strong>1/f = 1/v + 1/u</strong>. Focal length and radius: <strong>f = R/2</strong>.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Mirror calculators</h2>
                    <p>Formula, f = R/2, magnification, number of images</p>
                </div>
                <div class="panel-body">
                    <div class="mirror-tabs">
                        <button type="button" class="mirror-tab active" data-tab="formula" onclick="if(window.switchMirrorTab)window.switchMirrorTab('formula',this);">Formula</button>
                        <button type="button" class="mirror-tab" data-tab="radius" onclick="if(window.switchMirrorTab)window.switchMirrorTab('radius',this);">f = R/2</button>
                        <button type="button" class="mirror-tab" data-tab="magnification" onclick="if(window.switchMirrorTab)window.switchMirrorTab('magnification',this);">Magnification</button>
                        <button type="button" class="mirror-tab" data-tab="numimages" onclick="if(window.switchMirrorTab)window.switchMirrorTab('numimages',this);">No. images</button>
                    </div>

                    <div id="panel-mirror-formula" class="mirror-panel active">
                        <div class="input-section">
                            <div class="input-label">Solve for</div>
                            <div class="solve-for-btns">
                                <button type="button" class="mirror-solve-btn active" data-var="v" onclick="window.setMirrorSolveFor('v')">Image (v)</button>
                                <button type="button" class="mirror-solve-btn" data-var="u" onclick="window.setMirrorSolveFor('u')">Object (u)</button>
                                <button type="button" class="mirror-solve-btn" data-var="f" onclick="window.setMirrorSolveFor('f')">Focal (f)</button>
                            </div>
                        </div>
                        <div class="input-section" id="mirror-focal-section">
                            <div class="input-label">Focal length (f)</div>
                            <div class="input-with-unit">
                                <input type="number" id="mirror-f" class="number-input mirror-number-input" value="-15" step="any">
                                <select id="mirror-unit" class="unit-select mirror-unit-select">
                                    <option value="cm">cm</option>
                                    <option value="m">m</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="mirror-object-section">
                            <div class="input-label">Object distance (u)</div>
                            <div class="input-with-unit">
                                <input type="number" id="mirror-u" class="number-input mirror-number-input" value="-30" step="any">
                                <span class="unit-select" style="background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; padding: 0.75rem; font-size: 0.85rem;">same unit</span>
                            </div>
                        </div>
                        <div class="input-section" id="mirror-image-section" style="display: none;">
                            <div class="input-label">Image distance (v)</div>
                            <div class="input-with-unit">
                                <input type="number" id="mirror-v" class="number-input mirror-number-input" value="-30" step="any">
                                <span class="unit-select" style="background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; padding: 0.75rem; font-size: 0.85rem;">same unit</span>
                            </div>
                        </div>
                        <div class="result-card">
                            <div class="result-label">Result</div>
                            <div class="result-value" id="mirror-formula-result">—</div>
                        </div>
                    </div>

                    <div id="panel-mirror-radius" class="mirror-panel">
                        <div class="input-section">
                            <div class="input-label">Radius of curvature (R)</div>
                            <div class="input-with-unit">
                                <input type="number" id="mirror-R" class="number-input mirror-number-input" value="-30" step="any">
                                <select id="mirror-R-unit" class="unit-select mirror-unit-select">
                                    <option value="cm">cm</option>
                                    <option value="m">m</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>
                        <div class="result-card">
                            <div class="result-label">Focal length f = R/2</div>
                            <div class="result-value" id="mirror-radius-result">—</div>
                        </div>
                    </div>

                    <div id="panel-mirror-magnification" class="mirror-panel">
                        <div class="input-section">
                            <div class="input-label">Image distance (v)</div>
                            <div class="input-with-unit">
                                <input type="number" id="mirror-m-v" class="number-input mirror-number-input" value="-30" step="any">
                                <select id="mirror-m-unit" class="unit-select mirror-unit-select">
                                    <option value="cm">cm</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Object distance (u)</div>
                            <div class="input-with-unit">
                                <input type="number" id="mirror-m-u" class="number-input mirror-number-input" value="-30" step="any">
                                <span class="unit-select" style="background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; padding: 0.75rem; font-size: 0.85rem;">same unit</span>
                            </div>
                        </div>
                        <div class="result-card">
                            <div class="result-label">Magnification m = −v/u</div>
                            <div class="result-value" id="mirror-mag-result">—</div>
                        </div>
                    </div>

                    <div id="panel-mirror-numimages" class="mirror-panel">
                        <div class="input-section">
                            <div class="input-label">Angle between mirrors θ (°)</div>
                            <div class="input-with-unit">
                                <input type="number" id="mirror-theta" class="number-input mirror-number-input" value="90" min="0.1" max="360" step="any">
                                <span class="unit-select" style="background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; padding: 0.75rem; font-size: 0.85rem;">degrees</span>
                            </div>
                        </div>
                        <div class="result-card">
                            <div class="result-label">Number of images (n = 360°/θ − 1 when integer)</div>
                            <div class="result-value" id="mirror-numimages-result">—</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>🪞 Ray diagram</h3></div>
                    <div class="mirror-viz-container" id="mirror-viz-container">
                        <canvas id="mirror-viz-canvas" class="mirror-viz-canvas" width="600" height="280"></canvas>
                        <div id="mirror-viz-placeholder" class="mirror-viz-placeholder" style="display: none;">Run a calculation to see diagram.</div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleMirrorSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="mirror-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="mirror-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Reflection of light formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes / Sign convention</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Laws of reflection</td>
                                <td class="form-equation">i = r</td>
                                <td class="form-desc">Incident ray, reflected ray, normal in same plane</td>
                            </tr>
                            <tr>
                                <td class="form-name">Mirror formula (spherical)</td>
                                <td class="form-equation">1/f = 1/v + 1/u</td>
                                <td class="form-desc">Cartesian sign convention</td>
                            </tr>
                            <tr>
                                <td class="form-name">Focal length &amp; radius</td>
                                <td class="form-equation">f = R/2</td>
                                <td class="form-desc">R = radius of curvature</td>
                            </tr>
                            <tr>
                                <td class="form-name">Magnification</td>
                                <td class="form-equation">m = hᵢ/hₒ = −v/u</td>
                                <td class="form-desc">m &lt; 0 → inverted, m &gt; 0 → erect</td>
                            </tr>
                            <tr>
                                <td class="form-name">Number of images (two mirrors at θ)</td>
                                <td class="form-equation">n = 360°/θ − 1</td>
                                <td class="form-desc">When 360/θ is integer</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="edu-content">
                    <h2>About reflection and mirrors</h2>
                    <p>For spherical mirrors the mirror formula is <strong>1/f = 1/v + 1/u</strong>. Focal length is half the radius of curvature: <strong>f = R/2</strong>. Magnification <strong>m = −v/u</strong>; m &lt; 0 means inverted, m &gt; 0 erect. For two plane mirrors inclined at angle θ, when 360°/θ is an integer the number of images is <strong>n = 360°/θ − 1</strong>.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/mirrors.js?v=<%=cacheVersion%>"></script>
</body>
</html>
