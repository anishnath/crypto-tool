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
        <jsp:param name="toolName" value="Prism & Dispersion - Angle of Deviation, Minimum Deviation, Refractive Index, Dispersive Power Calculator" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Prism and dispersion: angle of deviation δ = i + e − A, minimum deviation δ_m = 2i − A, refractive index n = sin((A+δ_m)/2)/sin(A/2), angular dispersion (n_v−n_r)A, dispersive power ω = (n_v−n_r)/(n−1), achromatic combination ω₁/f₁ + ω₂/f₂ = 0. Free calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/prism-dispersion.jsp" />
        <jsp:param name="toolKeywords" value="prism, dispersion, angle of deviation, minimum deviation, refractive index prism, dispersive power, achromatic combination, optics, JEE NEET" />
        <jsp:param name="toolImage" value="prism-dispersion.png" />
        <jsp:param name="toolFeatures" value="Angle of deviation calculator,Minimum deviation calculator,Refractive index from prism,Dispersion calculator,Dispersive power calculator,Achromatic combination,Step-by-step solutions,Canvas diagrams" />
        <jsp:param name="faq1q" value="What is the angle of deviation for a prism?" />
        <jsp:param name="faq1a" value="Angle of deviation δ = i + e − A, where i is angle of incidence, e is angle of emergence, and A is the prism angle. At minimum deviation, i = e and δ_m = 2i − A." />
        <jsp:param name="faq2q" value="How do you find refractive index from a prism?" />
        <jsp:param name="faq2a" value="At minimum deviation: n = sin((A + δ_m)/2) / sin(A/2), where A is prism angle and δ_m is minimum angle of deviation." />
        <jsp:param name="faq3q" value="What is dispersive power?" />
        <jsp:param name="faq3a" value="Dispersive power ω = (n_v − n_r) / (n − 1), where n_v and n_r are refractive indices for violet and red, and n is mean refractive index. Achromatic combination: ω₁/f₁ + ω₂/f₂ = 0." />
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
        :root { --prism-violet: #7c3aed; --prism-purple: #9333ea; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #7c3aed 0%, #9333ea 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(124,58,237,0.1), rgba(147,51,234,0.1)); border-left: 4px solid var(--prism-violet); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #7c3aed, #9333ea); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .prism-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .prism-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.7rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .prism-tab:hover { border-color: var(--prism-violet); color: var(--prism-violet); }
        .prism-tab.active { background: linear-gradient(135deg, #7c3aed, #9333ea); border-color: #9333ea; color: white; }
        .prism-panel { display: none; }
        .prism-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .number-input { width: 100%; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--prism-violet); }
        .result-card { background: linear-gradient(135deg, rgba(124,58,237,0.15), rgba(147,51,234,0.1)); border: 2px solid var(--prism-violet); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.25rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--prism-violet); }
        .prism-solve-btn { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.8rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; margin-right: 0.25rem; margin-bottom: 0.25rem; }
        .prism-solve-btn.active { background: linear-gradient(135deg, #7c3aed, #9333ea); border-color: #9333ea; color: white; }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #7c3aed, #9333ea); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-weight: 700; color: var(--prism-violet); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #7c3aed, #9333ea); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--prism-violet); }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--prism-violet); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #7c3aed; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(124,58,237,0.1), rgba(147,51,234,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .prism-viz-container { position: relative; width: 100%; height: 240px; background: linear-gradient(180deg, #f5f3ff 0%, #ede9fe 100%); overflow: hidden; }
        .prism-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: block; }
        .prism-viz-placeholder { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: var(--text-secondary); font-size: 0.9rem; }
        [data-theme="dark"] .prism-viz-container { background: linear-gradient(180deg, #4c1d95 0%, #5b21b6 100%); }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--prism-violet); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🔺</span> Prism &amp; Dispersion</h1>
            <p class="tool-page-description">Angle of deviation, minimum deviation, n from prism, dispersion, dispersive power, achromatic</p>
            <div class="tool-badges">
                <span class="tool-badge">δ = i + e − A</span>
                <span class="tool-badge">n = sin((A+δ_m)/2)/sin(A/2)</span>
                <span class="tool-badge">ω₁/f₁ + ω₂/f₂ = 0</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Prism &amp; dispersion</div>
            <p><strong>Angle of deviation</strong> δ = i + e − A. At <strong>minimum deviation</strong> i = e, δ_m = 2i − A and <strong>n = sin((A+δ_m)/2)/sin(A/2)</strong>. <strong>Angular dispersion</strong> δ_v − δ_r = (n_v − n_r)A. <strong>Dispersive power</strong> ω = (n_v − n_r)/(n−1). <strong>Achromatic combination</strong>: ω₁/f₁ + ω₂/f₂ = 0.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Prism calculators</h2>
                    <p>Deviation, minimum deviation, n, dispersion, ω, achromatic</p>
                </div>
                <div class="panel-body">
                    <div class="prism-tabs">
                        <button type="button" class="prism-tab active" data-tab="deviation" onclick="if(window.switchPrismTab)window.switchPrismTab('deviation',this);">δ</button>
                        <button type="button" class="prism-tab" data-tab="mindeviation" onclick="if(window.switchPrismTab)window.switchPrismTab('mindeviation',this);">δ_m</button>
                        <button type="button" class="prism-tab" data-tab="nfromprism" onclick="if(window.switchPrismTab)window.switchPrismTab('nfromprism',this);">n from prism</button>
                        <button type="button" class="prism-tab" data-tab="dispersion" onclick="if(window.switchPrismTab)window.switchPrismTab('dispersion',this);">Dispersion</button>
                        <button type="button" class="prism-tab" data-tab="dispersivepower" onclick="if(window.switchPrismTab)window.switchPrismTab('dispersivepower',this);">ω</button>
                        <button type="button" class="prism-tab" data-tab="achromatic" onclick="if(window.switchPrismTab)window.switchPrismTab('achromatic',this);">Achromatic</button>
                    </div>

                    <div id="panel-prism-deviation" class="prism-panel active">
                        <div class="input-section">
                            <div class="input-label">Angle of incidence i (°)</div>
                            <input type="number" id="prism-i" class="number-input prism-number-input" value="45" min="0" max="90" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Angle of emergence e (°)</div>
                            <input type="number" id="prism-e" class="number-input prism-number-input" value="45" min="0" max="90" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Prism angle A (°)</div>
                            <input type="number" id="prism-A" class="number-input prism-number-input" value="60" min="0" max="180" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">δ = i + e − A</div>
                            <div class="result-value" id="prism-deviation-result">—</div>
                        </div>
                    </div>

                    <div id="panel-prism-mindeviation" class="prism-panel">
                        <div class="input-section">
                            <div class="input-label">Angle of incidence i (°) = e at min deviation</div>
                            <input type="number" id="prism-i-min" class="number-input prism-number-input" value="45" min="0" max="90" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Prism angle A (°)</div>
                            <input type="number" id="prism-A-min" class="number-input prism-number-input" value="60" min="0" max="180" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">δ_m = 2i − A</div>
                            <div class="result-value" id="prism-mindeviation-result">—</div>
                        </div>
                    </div>

                    <div id="panel-prism-nfromprism" class="prism-panel">
                        <div class="input-section">
                            <div class="input-label">Prism angle A (°)</div>
                            <input type="number" id="prism-A-n" class="number-input prism-number-input" value="60" min="0" max="180" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Minimum deviation δ_m (°)</div>
                            <input type="number" id="prism-deltaM" class="number-input prism-number-input" value="30" min="0" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">n = sin((A+δ_m)/2)/sin(A/2)</div>
                            <div class="result-value" id="prism-nfromprism-result">—</div>
                        </div>
                    </div>

                    <div id="panel-prism-dispersion" class="prism-panel">
                        <div class="input-section">
                            <div class="input-label">n_v (violet)</div>
                            <input type="number" id="prism-nv" class="number-input prism-number-input" value="1.532" min="1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">n_r (red)</div>
                            <input type="number" id="prism-nr" class="number-input prism-number-input" value="1.514" min="1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Prism angle A (°)</div>
                            <input type="number" id="prism-A-disp" class="number-input prism-number-input" value="60" min="0" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">δ_v − δ_r = (n_v − n_r)A</div>
                            <div class="result-value" id="prism-dispersion-result">—</div>
                        </div>
                    </div>

                    <div id="panel-prism-dispersivepower" class="prism-panel">
                        <div class="input-section">
                            <div class="input-label">n_v (violet)</div>
                            <input type="number" id="prism-nv-om" class="number-input prism-number-input" value="1.532" min="1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">n_r (red)</div>
                            <input type="number" id="prism-nr-om" class="number-input prism-number-input" value="1.514" min="1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Mean n (optional; default (n_v+n_r)/2)</div>
                            <input type="number" id="prism-n-mean" class="number-input prism-number-input" value="" placeholder="e.g. 1.523" min="1" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">ω = (n_v − n_r)/(n − 1)</div>
                            <div class="result-value" id="prism-omega-result">—</div>
                        </div>
                    </div>

                    <div id="panel-prism-achromatic" class="prism-panel">
                        <div class="input-section">
                            <div class="input-label">Solve for</div>
                            <button type="button" class="prism-solve-btn active" data-var="f2" onclick="window.setPrismSolveFor('f2')">f₂</button>
                            <button type="button" class="prism-solve-btn" data-var="f1" onclick="window.setPrismSolveFor('f1')">f₁</button>
                        </div>
                        <div class="input-section">
                            <div class="input-label">ω₁</div>
                            <input type="number" id="prism-om1" class="number-input prism-number-input" value="0.03" step="any">
                        </div>
                        <div class="input-section" id="prism-f1-section">
                            <div class="input-label">f₁ (cm)</div>
                            <input type="number" id="prism-f1" class="number-input prism-number-input" value="20" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">ω₂</div>
                            <input type="number" id="prism-om2" class="number-input prism-number-input" value="-0.04" step="any">
                        </div>
                        <div class="input-section" id="prism-f2-section">
                            <div class="input-label">f₂ (cm)</div>
                            <input type="number" id="prism-f2" class="number-input prism-number-input" value="-15" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">ω₁/f₁ + ω₂/f₂ = 0</div>
                            <div class="result-value" id="prism-achromatic-result">—</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>🔺 Prism diagram</h3></div>
                    <div class="prism-viz-container" id="prism-viz-container">
                        <canvas id="prism-viz-canvas" class="prism-viz-canvas" width="600" height="240"></canvas>
                        <div id="prism-viz-placeholder" class="prism-viz-placeholder" style="display: none;">Run a calculation to see diagram.</div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.togglePrismSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="prism-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="prism-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Prism and dispersion formulas">
                        <thead>
                            <tr><th>Concept</th><th>Formula</th><th>Notes</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Angle of deviation</td>
                                <td class="form-equation">δ = i + e − A</td>
                                <td class="form-desc">i = incidence, e = emergence, A = prism angle</td>
                            </tr>
                            <tr>
                                <td class="form-name">Minimum deviation</td>
                                <td class="form-equation">δ_m = 2i − A</td>
                                <td class="form-desc">At minimum deviation i = e</td>
                            </tr>
                            <tr>
                                <td class="form-name">Refractive index (min deviation)</td>
                                <td class="form-equation">n = sin((A+δ_m)/2) / sin(A/2)</td>
                                <td class="form-desc">—</td>
                            </tr>
                            <tr>
                                <td class="form-name">Angular dispersion</td>
                                <td class="form-equation">δ_v − δ_r = (n_v − n_r) A</td>
                                <td class="form-desc">—</td>
                            </tr>
                            <tr>
                                <td class="form-name">Dispersive power</td>
                                <td class="form-equation">ω = (n_v − n_r) / (n − 1)</td>
                                <td class="form-desc">n = mean refractive index</td>
                            </tr>
                            <tr>
                                <td class="form-name">Achromatic combination</td>
                                <td class="form-equation">ω₁/f₁ + ω₂/f₂ = 0</td>
                                <td class="form-desc">Usually f₁ = −f₂ (convex + concave)</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="edu-content">
                    <h2>About prism and dispersion</h2>
                    <p><strong>Angle of deviation</strong> δ = i + e − A. For a given prism, deviation is minimum when i = e; then <strong>δ_m = 2i − A</strong> and the <strong>refractive index</strong> is <strong>n = sin((A+δ_m)/2)/sin(A/2)</strong>. Different wavelengths have different n, causing <strong>dispersion</strong>: angular dispersion δ_v − δ_r = (n_v − n_r)A. <strong>Dispersive power</strong> ω = (n_v − n_r)/(n−1). Two prisms (or lenses) can be combined so that <strong>ω₁/f₁ + ω₂/f₂ = 0</strong> for an achromatic combination (no net dispersion).</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/prism-dispersion.js?v=<%=cacheVersion%>"></script>
</body>
</html>
