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
        <jsp:param name="toolName" value="Refraction of Light - Snell's Law, Apparent Depth, Slab Shift, Critical Angle Calculator" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Refraction of light: Snell's law n₁ sin i = n₂ sin r, apparent depth d' = d/n, shift due to slab t(1−1/n), lateral shift t sin(i−r)/cos r, critical angle sin C = 1/n, total internal reflection. Free calculators with step-by-step solutions and ray diagrams." />
        <jsp:param name="toolUrl" value="physics/refraction.jsp" />
        <jsp:param name="toolKeywords" value="refraction of light, Snell law, apparent depth, critical angle, total internal reflection, slab shift, lateral shift, refractive index, optics, JEE NEET" />
        <jsp:param name="toolImage" value="refraction-optics.png" />
        <jsp:param name="toolFeatures" value="Snell law calculator,Apparent depth calculator,Slab shift calculator,Lateral shift calculator,Critical angle calculator,Canvas ray diagrams,Step-by-step solutions" />
        <jsp:param name="faq1q" value="What is Snell's law?" />
        <jsp:param name="faq1a" value="Snell's law: n₁ sin i = n₂ sin r, where n₁, n₂ are refractive indices and i, r are angles of incidence and refraction. Also sin i / sin r = n₂/n₁." />
        <jsp:param name="faq2q" value="What is apparent depth?" />
        <jsp:param name="faq2a" value="When an object in a denser medium (refractive index n) is viewed from a rarer medium (e.g. air), apparent depth d' = d/n, where d is real depth." />
        <jsp:param name="faq3q" value="What is the critical angle?" />
        <jsp:param name="faq3a" value="Critical angle C is the angle of incidence in the denser medium for which the angle of refraction in rarer medium is 90°. sin C = 1/n when light goes from medium of index n to air. For i &gt; C, total internal reflection occurs." />
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
        :root { --refr-cyan: #0891b2; --refr-teal: #0d9488; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
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
        .info-box { background: linear-gradient(135deg, rgba(8,145,178,0.1), rgba(13,148,136,0.1)); border-left: 4px solid var(--refr-cyan); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #0891b2, #0d9488); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .refr-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .refr-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .refr-tab:hover { border-color: var(--refr-cyan); color: var(--refr-cyan); }
        .refr-tab.active { background: linear-gradient(135deg, #0891b2, #0d9488); border-color: #0d9488; color: white; }
        .refr-panel { display: none; }
        .refr-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--refr-cyan); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .result-card { background: linear-gradient(135deg, rgba(8,145,178,0.15), rgba(13,148,136,0.1)); border: 2px solid var(--refr-cyan); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.25rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--refr-cyan); }
        .solve-for-btns { display: flex; gap: 0.25rem; flex-wrap: wrap; }
        .refr-solve-btn { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.8rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; }
        .refr-solve-btn:hover { border-color: var(--refr-cyan); color: var(--refr-cyan); }
        .refr-solve-btn.active { background: linear-gradient(135deg, #0891b2, #0d9488); border-color: #0d9488; color: white; }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #0891b2, #0d9488); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-weight: 700; color: var(--refr-cyan); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #0891b2, #0d9488); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--refr-cyan); }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--refr-cyan); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #0891b2; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(8,145,178,0.1), rgba(13,148,136,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); }
        .refr-viz-container { position: relative; width: 100%; height: 260px; background: linear-gradient(180deg, #ecfeff 0%, #cffafe 100%); overflow: hidden; }
        .refr-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: block; }
        .refr-viz-placeholder { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: var(--text-secondary); font-size: 0.9rem; }
        [data-theme="dark"] .refr-viz-container { background: linear-gradient(180deg, #164e63 0%, #0e7490 100%); }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--refr-cyan); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>💧</span> Refraction of Light</h1>
            <p class="tool-page-description">Snell's law, apparent depth, slab shift, lateral shift, critical angle &amp; TIR</p>
            <div class="tool-badges">
                <span class="tool-badge">n₁ sin i = n₂ sin r</span>
                <span class="tool-badge">d' = d/n</span>
                <span class="tool-badge">sin C = 1/n</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Refraction</div>
            <p><strong>Snell's law:</strong> n₁ sin i = n₂ sin r. <strong>Apparent depth</strong> (object in denser medium): d' = d/n. <strong>Shift due to slab:</strong> t(1 − 1/n). <strong>Lateral shift:</strong> t sin(i−r)/cos r. <strong>Critical angle</strong> (denser → rarer): sin C = 1/n; for i &gt; C, total internal reflection (TIR).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Refraction calculators</h2>
                    <p>Snell, apparent depth, slab, lateral shift, critical angle</p>
                </div>
                <div class="panel-body">
                    <div class="refr-tabs">
                        <button type="button" class="refr-tab active" data-tab="snell" onclick="if(window.switchRefrTab)window.switchRefrTab('snell',this);">Snell</button>
                        <button type="button" class="refr-tab" data-tab="apparent" onclick="if(window.switchRefrTab)window.switchRefrTab('apparent',this);">Apparent depth</button>
                        <button type="button" class="refr-tab" data-tab="slab" onclick="if(window.switchRefrTab)window.switchRefrTab('slab',this);">Slab shift</button>
                        <button type="button" class="refr-tab" data-tab="lateral" onclick="if(window.switchRefrTab)window.switchRefrTab('lateral',this);">Lateral shift</button>
                        <button type="button" class="refr-tab" data-tab="critical" onclick="if(window.switchRefrTab)window.switchRefrTab('critical',this);">Critical angle</button>
                    </div>

                    <div id="panel-refr-snell" class="refr-panel active">
                        <div class="input-section">
                            <div class="input-label">Solve for</div>
                            <div class="solve-for-btns">
                                <button type="button" class="refr-solve-btn active" data-var="r" onclick="window.setRefrSolveFor('r')">Angle r</button>
                                <button type="button" class="refr-solve-btn" data-var="i" onclick="window.setRefrSolveFor('i')">Angle i</button>
                                <button type="button" class="refr-solve-btn" data-var="n2" onclick="window.setRefrSolveFor('n2')">n₂</button>
                            </div>
                        </div>
                        <div class="input-section" id="refr-n2-section">
                            <div class="input-label">n₂ (refractive index 2)</div>
                            <input type="number" id="refr-n2" class="number-input refr-number-input" value="1.33" min="0.1" step="any">
                        </div>
                        <div class="input-section" id="refr-i-section">
                            <div class="input-label">Angle of incidence i (°)</div>
                            <input type="number" id="refr-i" class="number-input refr-number-input" value="30" min="0" max="90" step="any">
                        </div>
                        <div class="input-section" id="refr-r-section" style="display: none;">
                            <div class="input-label">Angle of refraction r (°)</div>
                            <input type="number" id="refr-r" class="number-input refr-number-input" value="22" min="0" max="90" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">n₁ (refractive index 1)</div>
                            <input type="number" id="refr-n1" class="number-input refr-number-input" value="1" min="0.1" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">Result</div>
                            <div class="result-value" id="refr-snell-result">—</div>
                        </div>
                    </div>

                    <div id="panel-refr-apparent" class="refr-panel">
                        <div class="input-section">
                            <div class="input-label">Real depth d</div>
                            <div class="input-with-unit">
                                <input type="number" id="refr-d" class="number-input refr-number-input" value="10" min="0" step="any">
                                <select id="refr-depth-unit" class="unit-select refr-unit-select">
                                    <option value="cm">cm</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Refractive index n (denser medium)</div>
                            <input type="number" id="refr-n-depth" class="number-input refr-number-input" value="1.33" min="1" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">Apparent depth d' = d/n</div>
                            <div class="result-value" id="refr-apparent-result">—</div>
                        </div>
                    </div>

                    <div id="panel-refr-slab" class="refr-panel">
                        <div class="input-section">
                            <div class="input-label">Thickness t</div>
                            <div class="input-with-unit">
                                <input type="number" id="refr-t" class="number-input refr-number-input" value="5" min="0" step="any">
                                <select class="unit-select refr-unit-select">
                                    <option value="cm">cm</option>
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Refractive index n</div>
                            <input type="number" id="refr-n-slab" class="number-input refr-number-input" value="1.5" min="1" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">Shift = t(1 − 1/n)</div>
                            <div class="result-value" id="refr-slab-result">—</div>
                        </div>
                    </div>

                    <div id="panel-refr-lateral" class="refr-panel">
                        <div class="input-section">
                            <div class="input-label">Thickness t</div>
                            <div class="input-with-unit">
                                <input type="number" id="refr-t-lat" class="number-input refr-number-input" value="4" min="0" step="any">
                                <span class="unit-select" style="background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; padding: 0.75rem; font-size: 0.85rem;">cm</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Angle of incidence i (°)</div>
                            <input type="number" id="refr-i-lat" class="number-input refr-number-input" value="45" min="0" max="90" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Refractive index n</div>
                            <input type="number" id="refr-n-lat" class="number-input refr-number-input" value="1.5" min="1" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">Lateral shift</div>
                            <div class="result-value" id="refr-lateral-result">—</div>
                        </div>
                    </div>

                    <div id="panel-refr-critical" class="refr-panel">
                        <div class="input-section">
                            <div class="input-label">Refractive index n (denser medium)</div>
                            <input type="number" id="refr-n-crit" class="number-input refr-number-input" value="1.5" min="1" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">Critical angle C (denser → air)</div>
                            <div class="result-value" id="refr-critical-result">—</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>💧 Ray diagram</h3></div>
                    <div class="refr-viz-container" id="refr-viz-container">
                        <canvas id="refr-viz-canvas" class="refr-viz-canvas" width="600" height="260"></canvas>
                        <div id="refr-viz-placeholder" class="refr-viz-placeholder" style="display: none;">Run a calculation to see diagram.</div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleRefrSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="refr-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="refr-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Refraction formulas">
                        <thead>
                            <tr><th>Concept</th><th>Formula</th><th>Notes</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Snell's law</td>
                                <td class="form-equation">n₁ sin i = n₂ sin r</td>
                                <td class="form-desc">sin i / sin r = n₂/n₁</td>
                            </tr>
                            <tr>
                                <td class="form-name">Absolute refractive index</td>
                                <td class="form-equation">n = c / v</td>
                                <td class="form-desc">c = speed in vacuum</td>
                            </tr>
                            <tr>
                                <td class="form-name">Apparent depth</td>
                                <td class="form-equation">d' = d / n</td>
                                <td class="form-desc">Object in denser medium viewed from rarer</td>
                            </tr>
                            <tr>
                                <td class="form-name">Shift due to slab</td>
                                <td class="form-equation">Shift = t (1 − 1/n)</td>
                                <td class="form-desc">t = thickness</td>
                            </tr>
                            <tr>
                                <td class="form-name">Lateral shift</td>
                                <td class="form-equation">d = t sin(i − r) / cos r</td>
                                <td class="form-desc">—</td>
                            </tr>
                            <tr>
                                <td class="form-name">Critical angle</td>
                                <td class="form-equation">sin C = 1/n</td>
                                <td class="form-desc">Denser to rarer (n₂ = 1). TIR when i &gt; C</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="edu-content">
                    <h2>About refraction</h2>
                    <p><strong>Snell's law</strong> n₁ sin i = n₂ sin r relates angles of incidence and refraction at an interface. <strong>Apparent depth</strong> d' = d/n when viewing an object in a denser medium from air. A <strong>parallel slab</strong> shifts the ray by t(1 − 1/n) (normal shift) or laterally by t sin(i−r)/cos r. When light travels from denser to rarer medium, the <strong>critical angle</strong> satisfies sin C = 1/n; for angles of incidence greater than C, <strong>total internal reflection</strong> (TIR) occurs.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/refraction.js?v=<%=cacheVersion%>"></script>
</body>
</html>
