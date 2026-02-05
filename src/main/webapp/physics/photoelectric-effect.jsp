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
        <jsp:param name="toolName" value="Photoelectric Effect - Einstein Equation, K_max, Work Function, Stopping Potential" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Photoelectric effect formulas: hν = φ + K_max, K_max = e V₀ = hν − φ, work function φ = hν₀ = hc/λ₀, photon energy E = hν = hc/λ, cut-off wavelength λ₀ = 12400/φ (eV) in Å, de Broglie wavelength. Free calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/photoelectric-effect.jsp" />
        <jsp:param name="toolKeywords" value="photoelectric effect, Einstein photoelectric equation, work function, stopping potential, K max, threshold frequency, cut-off wavelength, de Broglie wavelength, Planck constant, physics modern, JEE NEET" />
        <jsp:param name="toolImage" value="photoelectric-effect.png" />
        <jsp:param name="toolFeatures" value="K_max calculator,Stopping potential calculator,Work function calculator,Photon energy calculator,Cut-off wavelength calculator,de Broglie photoelectron calculator,Step-by-step solutions,eV and SI units" />
        <jsp:param name="faq1q" value="What is Einstein's photoelectric equation?" />
        <jsp:param name="faq1a" value="Einstein's equation: hν = φ + K_max, where h is Planck's constant, ν is photon frequency, φ is work function, and K_max is maximum kinetic energy of ejected electron. Also K_max = e V₀, where V₀ is stopping potential." />
        <jsp:param name="faq2q" value="What is work function?" />
        <jsp:param name="faq2a" value="Work function φ is minimum energy needed to eject an electron. φ = h ν₀ = hc/λ₀, where ν₀ is threshold frequency and λ₀ is threshold (cut-off) wavelength. Units: J or eV." />
        <jsp:param name="faq3q" value="What is the cut-off wavelength formula?" />
        <jsp:param name="faq3a" value="When work function is in eV: λ₀ (in Ångströms) = 12400 / φ (eV). This comes from hc ≈ 12400 eV·Å. Light with wavelength longer than λ₀ cannot eject electrons." />
        <jsp:param name="faq4q" value="What is de Broglie wavelength of photoelectron?" />
        <jsp:param name="faq4a" value="λ = h / √(2m K_max), where m is electron mass and K_max is maximum kinetic energy. This gives the wavelength associated with the ejected electron as a matter wave." />
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
        :root { --photo-teal: #0d9488; --photo-cyan: #0891b2; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #0d9488 0%, #0891b2 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(13,148,136,0.1), rgba(8,145,178,0.1)); border-left: 4px solid var(--photo-teal); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #0d9488, #0891b2); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .photo-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .photo-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .photo-tab:hover { border-color: var(--photo-teal); color: var(--photo-teal); }
        .photo-tab.active { background: linear-gradient(135deg, #0d9488, #0891b2); border-color: #0891b2; color: white; }
        .photo-panel { display: none; }
        .photo-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--photo-teal); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #0d9488, #0891b2); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(13,148,136,0.15), rgba(8,145,178,0.1)); border: 2px solid var(--photo-teal); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--photo-teal); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #0d9488, #0891b2); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--photo-teal); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(13,148,136,0.1), rgba(8,145,178,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); }
        .photo-viz-container { width: 100%; height: 220px; background: linear-gradient(180deg, #ccfbf1 0%, #99f6e4 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); display: flex; align-items: center; justify-content: center; }
        .photo-viz-container .highlight { color: var(--photo-teal); font-weight: 700; }
        [data-theme="dark"] .photo-viz-container, .dark-mode .photo-viz-container { background: linear-gradient(180deg, #134e4a 0%, #0f766e 100%); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #0d9488, #0891b2); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--photo-teal); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--photo-teal); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #0d9488; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--photo-teal); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #059669; font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: #059669; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--photo-teal); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>☀️</span> Photoelectric Effect</h1>
            <p class="tool-page-description">Einstein equation, K_max, work function, stopping potential, cut-off wavelength, de Broglie</p>
            <div class="tool-badges">
                <span class="tool-badge">hν = φ + K_max</span>
                <span class="tool-badge">K_max = e V₀</span>
                <span class="tool-badge">λ₀ = 12400/φ</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Photoelectric effect</div>
            <p>Light ejects electrons from a metal when photon energy hν exceeds the work function φ. Einstein's equation: hν = φ + K_max. Maximum kinetic energy K_max = e V₀ (V₀ = stopping potential). Work function φ = hν₀ = hc/λ₀. Cut-off wavelength λ₀ (Å) = 12400/φ (eV). de Broglie wavelength of photoelectron: λ = h/√(2m K_max).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Photoelectric calculators</h2>
                    <p>K_max, V₀, work function, photon energy, λ₀, de Broglie</p>
                </div>
                <div class="panel-body">
                    <div class="photo-tabs">
                        <button type="button" class="photo-tab active" data-tab="kmax" onclick="if(window.switchPhotoTab)window.switchPhotoTab('kmax',this);">K_max</button>
                        <button type="button" class="photo-tab" data-tab="v0" onclick="if(window.switchPhotoTab)window.switchPhotoTab('v0',this);">V₀</button>
                        <button type="button" class="photo-tab" data-tab="workfn" onclick="if(window.switchPhotoTab)window.switchPhotoTab('workfn',this);">Work function</button>
                        <button type="button" class="photo-tab" data-tab="photon" onclick="if(window.switchPhotoTab)window.switchPhotoTab('photon',this);">Photon E</button>
                        <button type="button" class="photo-tab" data-tab="cutoff" onclick="if(window.switchPhotoTab)window.switchPhotoTab('cutoff',this);">λ₀ cut-off</button>
                        <button type="button" class="photo-tab" data-tab="debrog" onclick="if(window.switchPhotoTab)window.switchPhotoTab('debrog',this);">de Broglie</button>
                    </div>

                    <div id="panel-kmax" class="photo-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Photon frequency (ν)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="kmax-nu" class="number-input" value="1.2e15" min="0" step="any">
                                <select id="kmax-nu-unit" class="unit-select">
                                    <option value="Hz">Hz</option>
                                    <option value="THz">THz</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Work function (φ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="kmax-phi" class="number-input" value="2.5" min="0" step="any">
                                <select id="kmax-phi-unit" class="unit-select">
                                    <option value="eV">eV</option>
                                    <option value="J">J</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runPhotoelectric()">Calculate K_max</button>
                        <div class="result-card" id="result-kmax">
                            <div class="result-label">Maximum kinetic energy</div>
                            <div class="result-value" id="kmax-result">2.46 eV</div>
                        </div>
                    </div>

                    <div id="panel-v0" class="photo-panel">
                        <div class="input-section">
                            <div class="input-label"><span>K_max (max kinetic energy)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="v0-kmax" class="number-input" value="2" min="0" step="any">
                                <select id="v0-kmax-unit" class="unit-select">
                                    <option value="eV">eV</option>
                                    <option value="J">J</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runPhotoelectric()">Calculate V₀</button>
                        <div class="result-card" id="result-v0">
                            <div class="result-label">Stopping potential</div>
                            <div class="result-value" id="v0-result">2.00 V</div>
                        </div>
                    </div>

                    <div id="panel-workfn" class="photo-panel">
                        <div class="input-section">
                            <div class="input-label"><span>From</span></div>
                            <select id="workfn-from" class="number-input" style="border-radius: 10px;">
                                <option value="nu0">Threshold frequency (ν₀)</option>
                                <option value="lambda0">Threshold wavelength (λ₀)</option>
                            </select>
                        </div>
                        <div class="input-section" id="workfn-nu-section">
                            <div class="input-label"><span>Threshold frequency (ν₀)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="workfn-nu0" class="number-input" value="6e14" min="0" step="any">
                                <select id="workfn-nu0-unit" class="unit-select">
                                    <option value="Hz">Hz</option>
                                    <option value="THz">THz</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="workfn-lambda-section" style="display: none;">
                            <div class="input-label"><span>Threshold wavelength (λ₀)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="workfn-lambda0" class="number-input" value="500" min="0" step="any">
                                <select id="workfn-lambda0-unit" class="unit-select">
                                    <option value="nm">nm</option>
                                    <option value="Ang">Å</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runPhotoelectric()">Calculate φ</button>
                        <div class="result-card" id="result-workfn">
                            <div class="result-label">Work function</div>
                            <div class="result-value" id="workfn-result">2.48 eV</div>
                        </div>
                    </div>

                    <div id="panel-photon" class="photo-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Input</span></div>
                            <select id="photon-input-type" class="number-input" style="border-radius: 10px;">
                                <option value="nu">Frequency (ν)</option>
                                <option value="lambda">Wavelength (λ)</option>
                            </select>
                        </div>
                        <div class="input-section" id="photon-nu-section">
                            <div class="input-label"><span>Frequency (ν)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="photon-nu" class="number-input" value="5e14" min="0" step="any">
                                <select id="photon-nu-unit" class="unit-select">
                                    <option value="Hz">Hz</option>
                                    <option value="THz">THz</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="photon-lambda-section" style="display: none;">
                            <div class="input-label"><span>Wavelength (λ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="photon-lambda" class="number-input" value="600" min="0" step="any">
                                <select id="photon-lambda-unit" class="unit-select">
                                    <option value="nm">nm</option>
                                    <option value="Ang">Å</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runPhotoelectric()">Calculate E</button>
                        <div class="result-card" id="result-photon">
                            <div class="result-label">Photon energy</div>
                            <div class="result-value" id="photon-result">2.07 eV</div>
                        </div>
                    </div>

                    <div id="panel-cutoff" class="photo-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Work function (φ) in eV</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cutoff-phi" class="number-input" value="2.5" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">eV</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runPhotoelectric()">Calculate λ₀</button>
                        <div class="result-card" id="result-cutoff">
                            <div class="result-label">Cut-off wavelength</div>
                            <div class="result-value" id="cutoff-result">4960 Å</div>
                        </div>
                    </div>

                    <div id="panel-debrog" class="photo-panel">
                        <div class="input-section">
                            <div class="input-label"><span>K_max (max kinetic energy)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="debrog-kmax" class="number-input" value="2" min="0" step="any">
                                <select id="debrog-kmax-unit" class="unit-select">
                                    <option value="eV">eV</option>
                                    <option value="J">J</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runPhotoelectric()">Calculate λ</button>
                        <div class="result-card" id="result-debrog">
                            <div class="result-label">de Broglie wavelength (electron)</div>
                            <div class="result-value" id="debrog-result">8.68 Å</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>☀️ Photoelectric energy diagram</h3></div>
                    <div class="photo-viz-container" id="photo-viz-container">
                        <div id="photo-viz-placeholder" style="color: var(--text-secondary); font-size: 0.9rem; text-align: center; padding: 1rem;">Run a calculation to see energy levels.</div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.togglePhotoSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="photo-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="photo-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Photoelectric effect formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes / Units</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Einstein's photoelectric equation</td>
                                <td class="form-equation">hν = φ + K_max</td>
                                <td class="form-desc">ν = frequency, φ = work function</td>
                            </tr>
                            <tr>
                                <td class="form-name">Maximum kinetic energy</td>
                                <td class="form-equation">K_max = e V₀ = hν − φ</td>
                                <td class="form-desc">V₀ = stopping potential</td>
                            </tr>
                            <tr>
                                <td class="form-name">Work function</td>
                                <td class="form-equation">φ = h ν₀ = hc / λ₀</td>
                                <td class="form-desc">ν₀ = threshold frequency, λ₀ = threshold wavelength</td>
                            </tr>
                            <tr>
                                <td class="form-name">Energy of photon</td>
                                <td class="form-equation">E = hν = hc / λ</td>
                                <td class="form-desc">h = 6.626×10⁻³⁴ J·s</td>
                            </tr>
                            <tr>
                                <td class="form-name">Cut-off wavelength (φ in eV)</td>
                                <td class="form-equation">λ₀ (Å) = 12400 / φ (eV)</td>
                                <td class="form-desc">Useful numerical relation</td>
                            </tr>
                            <tr>
                                <td class="form-name">de Broglie wavelength (photoelectron)</td>
                                <td class="form-equation">λ = h / √(2m K_max)</td>
                                <td class="form-desc">m = electron mass</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About the photoelectric effect</h2>
            <p>When light of frequency ν strikes a metal surface, electrons can be ejected if the photon energy hν exceeds the work function φ. Einstein's equation <strong>hν = φ + K_max</strong> states that photon energy goes into overcoming the work function plus the maximum kinetic energy of the ejected electron. The stopping potential V₀ is the voltage that stops the most energetic electrons: <strong>K_max = e V₀</strong>.</p>
            <h3>Work function and threshold</h3>
            <p>The work function φ = hν₀ = hc/λ₀, where ν₀ is the threshold frequency and λ₀ the threshold (cut-off) wavelength. For φ in eV, <strong>λ₀ (in Ångströms) = 12400 / φ (eV)</strong>. Light with wavelength longer than λ₀ cannot eject electrons.</p>
            <h3>de Broglie wavelength</h3>
            <p>The ejected electron has a matter wavelength given by <strong>λ = h / √(2m K_max)</strong>, where m is the electron mass. This is the de Broglie wavelength of the photoelectron.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/photoelectric-effect.js?v=<%=cacheVersion%>"></script>
</body>
</html>
