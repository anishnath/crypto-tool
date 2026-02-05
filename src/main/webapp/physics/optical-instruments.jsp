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
        <jsp:param name="toolName" value="Optical Instruments - Microscope, Telescope Magnification & Resolving Power Calculator" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Optical instruments: simple microscope m = 1+D/f or D/f, compound microscope m = m_o×m_e with m_o = L/f_o, m_e = 1+D/f_e, astronomical and Galilean telescope m = f_o/f_e, resolving power telescope D/(1.22λ), microscope 2n sin θ/λ. Free calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/optical-instruments.jsp" />
        <jsp:param name="toolKeywords" value="optical instruments, simple microscope, compound microscope, telescope magnification, resolving power, astronomical telescope, Galilean telescope, optics, JEE NEET" />
        <jsp:param name="toolImage" value="optical-instruments.png" />
        <jsp:param name="toolFeatures" value="Simple microscope calculator,Compound microscope calculator,Astronomical telescope calculator,Galilean telescope calculator,Resolving power telescope,Resolving power microscope,Step-by-step solutions" />
        <jsp:param name="faq1q" value="What is the magnification of a simple microscope?" />
        <jsp:param name="faq1a" value="When image is at least distance of distinct vision D (25 cm): m = 1 + D/f. When image is at infinity: m = D/f. f is focal length of the convex lens." />
        <jsp:param name="faq2q" value="What is the magnification of a compound microscope?" />
        <jsp:param name="faq2a" value="Total magnification m = m_o × m_e, where m_o = L/f_o (objective) and m_e = 1 + D/f_e (eyepiece). L = tube length, D = 25 cm, f_o and f_e are focal lengths." />
        <jsp:param name="faq3q" value="What is the resolving power of a telescope?" />
        <jsp:param name="faq3a" value="RP = D / (1.22 λ), where D is diameter of objective and λ is wavelength of light. Minimum angular separation resolvable is θ_min = 1.22 λ/D." />
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
        :root { --optinst-emerald: #059669; --optinst-teal: #0d9488; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #059669 0%, #0d9488 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(5,150,105,0.1), rgba(13,148,136,0.1)); border-left: 4px solid var(--optinst-emerald); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #059669, #0d9488); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .optinst-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .optinst-tab { padding: 0.5rem 0.6rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.7rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .optinst-tab:hover { border-color: var(--optinst-emerald); color: var(--optinst-emerald); }
        .optinst-tab.active { background: linear-gradient(135deg, #059669, #0d9488); border-color: #0d9488; color: white; }
        .optinst-panel { display: none; }
        .optinst-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .number-input { width: 100%; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--optinst-emerald); }
        .input-with-unit { display: flex; gap: 0; }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; min-width: 60px; }
        .result-card { background: linear-gradient(135deg, rgba(5,150,105,0.15), rgba(13,148,136,0.1)); border: 2px solid var(--optinst-emerald); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.25rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--optinst-emerald); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #059669, #0d9488); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-weight: 700; color: var(--optinst-emerald); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #059669, #0d9488); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--optinst-emerald); }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--optinst-emerald); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #059669; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--optinst-emerald); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        .radio-group { display: flex; gap: 1rem; margin-top: 0.5rem; }
        .radio-group label { display: flex; align-items: center; gap: 0.5rem; cursor: pointer; font-size: 0.9rem; color: var(--text-secondary); }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🔭</span> Optical Instruments</h1>
            <p class="tool-page-description">Simple &amp; compound microscope, astronomical &amp; Galilean telescope, resolving power</p>
            <div class="tool-badges">
                <span class="tool-badge">m = 1 + D/f</span>
                <span class="tool-badge">m = f_o/f_e</span>
                <span class="tool-badge">RP = D/(1.22λ)</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Optical instruments</div>
            <p><strong>Simple microscope:</strong> m = 1 + D/f (image at D) or m = D/f (image at ∞). <strong>Compound:</strong> m = m_o×m_e, m_o = L/f_o, m_e = 1+D/f_e. <strong>Astronomical telescope:</strong> m = f_o/f_e (inverted). <strong>Galilean:</strong> m = f_o/|f_e| (erect). <strong>Resolving power:</strong> telescope RP = D/(1.22λ); microscope RP = 2n sin θ/λ. D = 25 cm (least distance of distinct vision).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Instrument calculators</h2>
                    <p>Microscope, telescope, resolving power</p>
                </div>
                <div class="panel-body">
                    <div class="optinst-tabs">
                        <button type="button" class="optinst-tab active" data-tab="simple" onclick="if(window.switchOptInstTab)window.switchOptInstTab('simple',this);">Simple μ</button>
                        <button type="button" class="optinst-tab" data-tab="compound" onclick="if(window.switchOptInstTab)window.switchOptInstTab('compound',this);">Compound μ</button>
                        <button type="button" class="optinst-tab" data-tab="astronomical" onclick="if(window.switchOptInstTab)window.switchOptInstTab('astronomical',this);">Astro scope</button>
                        <button type="button" class="optinst-tab" data-tab="galilean" onclick="if(window.switchOptInstTab)window.switchOptInstTab('galilean',this);">Galilean</button>
                        <button type="button" class="optinst-tab" data-tab="rp-telescope" onclick="if(window.switchOptInstTab)window.switchOptInstTab('rp-telescope',this);">RP scope</button>
                        <button type="button" class="optinst-tab" data-tab="rp-microscope" onclick="if(window.switchOptInstTab)window.switchOptInstTab('rp-microscope',this);">RP μ</button>
                    </div>

                    <div id="panel-optinst-simple" class="optinst-panel active">
                        <div class="input-section">
                            <div class="input-label">Least distance of distinct vision D (cm)</div>
                            <input type="number" id="optinst-D" class="number-input optinst-number-input" value="25" min="1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Focal length f (cm)</div>
                            <input type="number" id="optinst-f-simple" class="number-input optinst-number-input" value="5" min="0.1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Mode</div>
                            <div class="radio-group">
                                <label><input type="radio" name="optinst-mode-simple" class="optinst-mode-simple" value="normal" checked> Normal (m = 1 + D/f)</label>
                                <label><input type="radio" name="optinst-mode-simple" class="optinst-mode-simple" value="infinity"> Image at ∞ (m = D/f)</label>
                            </div>
                        </div>
                        <div class="result-card">
                            <div class="result-label">Magnification</div>
                            <div class="result-value" id="optinst-simple-result">—</div>
                        </div>
                    </div>

                    <div id="panel-optinst-compound" class="optinst-panel">
                        <div class="input-section">
                            <div class="input-label">Tube length L (cm)</div>
                            <input type="number" id="optinst-L" class="number-input optinst-number-input" value="20" min="0.1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Objective focal length f_o (cm)</div>
                            <input type="number" id="optinst-fo" class="number-input optinst-number-input" value="2" min="0.1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Eyepiece focal length f_e (cm)</div>
                            <input type="number" id="optinst-fe" class="number-input optinst-number-input" value="5" min="0.1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">D (cm)</div>
                            <input type="number" id="optinst-D-comp" class="number-input optinst-number-input" value="25" min="1" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">Total magnification m = m_o × m_e</div>
                            <div class="result-value" id="optinst-compound-result">—</div>
                        </div>
                    </div>

                    <div id="panel-optinst-astronomical" class="optinst-panel">
                        <div class="input-section">
                            <div class="input-label">Objective focal length f_o (cm)</div>
                            <input type="number" id="optinst-fo-ast" class="number-input optinst-number-input" value="100" min="0.1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Eyepiece focal length f_e (cm)</div>
                            <input type="number" id="optinst-fe-ast" class="number-input optinst-number-input" value="5" min="0.1" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">m = f_o / f_e (image inverted)</div>
                            <div class="result-value" id="optinst-astronomical-result">—</div>
                        </div>
                    </div>

                    <div id="panel-optinst-galilean" class="optinst-panel">
                        <div class="input-section">
                            <div class="input-label">Objective focal length f_o (cm)</div>
                            <input type="number" id="optinst-fo-gal" class="number-input optinst-number-input" value="30" min="0.1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Eyepiece focal length f_e (cm, negative for diverging)</div>
                            <input type="number" id="optinst-fe-gal" class="number-input optinst-number-input" value="-5" step="any">
                        </div>
                        <div class="result-card">
                            <div class="result-label">m = f_o / |f_e| (erect)</div>
                            <div class="result-value" id="optinst-galilean-result">—</div>
                        </div>
                    </div>

                    <div id="panel-optinst-rp-telescope" class="optinst-panel">
                        <div class="input-section">
                            <div class="input-label">Diameter of objective D</div>
                            <div class="input-with-unit">
                                <input type="number" id="optinst-D-rp" class="number-input optinst-number-input" value="1" min="0.01" step="any">
                                <select id="optinst-D-unit-rp" class="unit-select optinst-unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label">Wavelength λ</div>
                            <div class="input-with-unit">
                                <input type="number" id="optinst-lambda-rp" class="number-input optinst-number-input" value="550" min="1" step="any">
                                <select id="optinst-lambda-unit-rp" class="unit-select optinst-unit-select">
                                    <option value="nm">nm</option>
                                    <option value="m">m</option>
                                    <option value="Å">Å</option>
                                </select>
                            </div>
                        </div>
                        <div class="result-card">
                            <div class="result-label">RP = D / (1.22 λ)</div>
                            <div class="result-value" id="optinst-rp-telescope-result">—</div>
                        </div>
                    </div>

                    <div id="panel-optinst-rp-microscope" class="optinst-panel">
                        <div class="input-section">
                            <div class="input-label">Refractive index n</div>
                            <input type="number" id="optinst-n-rp" class="number-input optinst-number-input" value="1.5" min="1" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Half-angle θ (°)</div>
                            <input type="number" id="optinst-theta-rp" class="number-input optinst-number-input" value="60" min="0" max="90" step="any">
                        </div>
                        <div class="input-section">
                            <div class="input-label">Wavelength λ</div>
                            <div class="input-with-unit">
                                <input type="number" id="optinst-lambda-mic" class="number-input optinst-number-input" value="550" min="1" step="any">
                                <select id="optinst-lambda-unit-mic" class="unit-select optinst-unit-select">
                                    <option value="nm">nm</option>
                                    <option value="m">m</option>
                                    <option value="Å">Å</option>
                                </select>
                            </div>
                        </div>
                        <div class="result-card">
                            <div class="result-label">RP = 2n sin θ / λ</div>
                            <div class="result-value" id="optinst-rp-microscope-result">—</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleOptInstSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="optinst-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="optinst-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Optical instruments formulas">
                        <thead>
                            <tr><th>Instrument</th><th>Formula</th><th>Notes</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Simple microscope</td>
                                <td class="form-equation">m = 1 + D/f or m = D/f</td>
                                <td class="form-desc">D = 25 cm (normal / image at ∞)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Compound microscope</td>
                                <td class="form-equation">m = m_o × m_e, m_o = L/f_o, m_e = 1 + D/f_e</td>
                                <td class="form-desc">L = tube length</td>
                            </tr>
                            <tr>
                                <td class="form-name">Astronomical telescope</td>
                                <td class="form-equation">m = f_o / f_e</td>
                                <td class="form-desc">Image inverted</td>
                            </tr>
                            <tr>
                                <td class="form-name">Galilean telescope</td>
                                <td class="form-equation">m = f_o / f_e</td>
                                <td class="form-desc">Erect image, diverging eyepiece</td>
                            </tr>
                            <tr>
                                <td class="form-name">RP (telescope)</td>
                                <td class="form-equation">RP = D / (1.22 λ)</td>
                                <td class="form-desc">D = diameter of objective</td>
                            </tr>
                            <tr>
                                <td class="form-name">RP (microscope)</td>
                                <td class="form-equation">RP = 2n sin θ / λ</td>
                                <td class="form-desc">NA = n sin θ (numerical aperture)</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="edu-content">
                    <h2>About optical instruments</h2>
                    <p>A <strong>simple microscope</strong> is a single convex lens: m = 1 + D/f when the image is at the least distance of distinct vision D (typically 25 cm), or m = D/f when the image is at infinity. A <strong>compound microscope</strong> has an objective and an eyepiece: total magnification m = m_o × m_e with m_o = L/f_o and m_e = 1 + D/f_e. An <strong>astronomical telescope</strong> uses two converging lenses: m = f_o/f_e (inverted image). A <strong>Galilean telescope</strong> uses a diverging eyepiece for an erect image with m = f_o/|f_e|. <strong>Resolving power</strong> of a telescope: RP = D/(1.22λ). For a microscope: RP = 2n sin θ/λ.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/optical-instruments.js?v=<%=cacheVersion%>"></script>
</body>
</html>
