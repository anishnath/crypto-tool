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
        <jsp:param name="toolName" value="Heisenberg Uncertainty Principle - Position-Momentum, Energy-Time" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Heisenberg uncertainty principle: Δx·Δp ≥ ℏ/2 (position-momentum), ΔE·Δt ≥ ℏ/2 (energy-time). Minimum uncertainty calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/uncertainty-principle.jsp" />
        <jsp:param name="toolKeywords" value="Heisenberg uncertainty principle, position momentum uncertainty, energy time uncertainty, quantum mechanics, delta x delta p, JEE NEET" />
        <jsp:param name="toolImage" value="uncertainty-principle.png" />
        <jsp:param name="toolFeatures" value="Position-momentum uncertainty,Energy-time uncertainty,Minimum Δp from Δx,Minimum Δx from Δp,Minimum ΔE from Δt,Step-by-step solutions,SI units" />
        <jsp:param name="faq1q" value="What is the position-momentum uncertainty relation?" />
        <jsp:param name="faq1a" value="Δx · Δp ≥ ℏ/2 (or h/(4π)), where ℏ = h/(2π). So minimum Δp = ℏ/(2Δx) for given Δx, and minimum Δx = ℏ/(2Δp) for given Δp." />
        <jsp:param name="faq2q" value="What is the energy-time uncertainty relation?" />
        <jsp:param name="faq2a" value="ΔE · Δt ≥ ℏ/2. Used for lifetime of excited states: shorter lifetime implies larger energy spread. Minimum ΔE = ℏ/(2Δt), minimum Δt = ℏ/(2ΔE)." />
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
        :root { --unc-violet: #6d28d9; --unc-purple: #7c3aed; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #6d28d9 0%, #7c3aed 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(109,40,217,0.1), rgba(124,58,237,0.1)); border-left: 4px solid var(--unc-violet); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #6d28d9, #7c3aed); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .unc-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .unc-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .unc-tab:hover { border-color: var(--unc-violet); color: var(--unc-violet); }
        .unc-tab.active { background: linear-gradient(135deg, #6d28d9, #7c3aed); border-color: #7c3aed; color: white; }
        .unc-panel { display: none; }
        .unc-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--unc-violet); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 80px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #6d28d9, #7c3aed); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(109,40,217,0.15), rgba(124,58,237,0.1)); border: 2px solid var(--unc-violet); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--unc-violet); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #6d28d9, #7c3aed); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--unc-violet); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(109,40,217,0.1), rgba(124,58,237,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); }
        .unc-viz-container { width: 100%; height: 200px; background: linear-gradient(180deg, #f5f3ff 0%, #ede9fe 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); display: flex; align-items: center; justify-content: center; }
        .unc-viz-container .highlight { color: var(--unc-violet); font-weight: 700; }
        [data-theme="dark"] .unc-viz-container, .dark-mode .unc-viz-container { background: linear-gradient(180deg, #4c1d95 0%, #5b21b6 100%); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #6d28d9, #7c3aed); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--unc-violet); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--unc-violet); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #6d28d9; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content p { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--unc-violet); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>⚛️</span> Heisenberg Uncertainty Principle</h1>
            <p class="tool-page-description">Position-momentum (Δx·Δp ≥ ℏ/2) and energy-time (ΔE·Δt ≥ ℏ/2)</p>
            <div class="tool-badges">
                <span class="tool-badge">Δx · Δp ≥ ℏ/2</span>
                <span class="tool-badge">ΔE · Δt ≥ ℏ/2</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Uncertainty principle</div>
            <p>Heisenberg's uncertainty principle: <strong>Δx · Δp ≥ ℏ/2</strong> (position-momentum) and <strong>ΔE · Δt ≥ ℏ/2</strong> (energy-time), where ℏ = h/(2π). So minimum Δp = ℏ/(2Δx), minimum Δx = ℏ/(2Δp); minimum ΔE = ℏ/(2Δt), minimum Δt = ℏ/(2ΔE). The energy-time form applies to the lifetime of excited states.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Uncertainty calculators</h2>
                    <p>Position-momentum and energy-time</p>
                </div>
                <div class="panel-body">
                    <div class="unc-tabs">
                        <button type="button" class="unc-tab active" data-tab="xp" onclick="if(window.switchUncertaintyTab)window.switchUncertaintyTab('xp',this);">Δx–Δp</button>
                        <button type="button" class="unc-tab" data-tab="et" onclick="if(window.switchUncertaintyTab)window.switchUncertaintyTab('et',this);">ΔE–Δt</button>
                    </div>

                    <div id="panel-xp" class="unc-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Find minimum</span></div>
                            <select id="xp-solve" class="number-input" style="border-radius: 10px;">
                                <option value="dp">Δp from Δx</option>
                                <option value="dx">Δx from Δp</option>
                            </select>
                        </div>
                        <div class="input-section" id="xp-dx-section">
                            <div class="input-label"><span>Uncertainty in position (Δx)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="xp-dx" class="number-input" value="1e-10" min="0" step="any">
                                <select id="xp-dx-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="nm">nm</option>
                                    <option value="pm">pm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="xp-dp-section" style="display: none;">
                            <div class="input-label"><span>Uncertainty in momentum (Δp)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="xp-dp" class="number-input" value="1e-23" min="0" step="any">
                                <select id="xp-dp-unit" class="unit-select">
                                    <option value="kg·m/s">kg·m/s</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runUncertainty()">Calculate</button>
                        <div class="result-card" id="result-xp">
                            <div class="result-label">Minimum uncertainty</div>
                            <div class="result-value" id="xp-result">—</div>
                        </div>
                    </div>

                    <div id="panel-et" class="unc-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Find minimum</span></div>
                            <select id="et-solve" class="number-input" style="border-radius: 10px;">
                                <option value="de">ΔE from Δt</option>
                                <option value="dt">Δt from ΔE</option>
                            </select>
                        </div>
                        <div class="input-section" id="et-dt-section">
                            <div class="input-label"><span>Uncertainty in time (Δt)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="et-dt" class="number-input" value="1e-8" min="0" step="any">
                                <select id="et-dt-unit" class="unit-select">
                                    <option value="s">s</option>
                                    <option value="ms">ms</option>
                                    <option value="ns">ns</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section" id="et-de-section" style="display: none;">
                            <div class="input-label"><span>Uncertainty in energy (ΔE)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="et-de" class="number-input" value="1e-26" min="0" step="any">
                                <select id="et-de-unit" class="unit-select">
                                    <option value="J">J</option>
                                    <option value="eV">eV</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runUncertainty()">Calculate</button>
                        <div class="result-card" id="result-et">
                            <div class="result-label">Minimum uncertainty</div>
                            <div class="result-value" id="et-result">—</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>⚛️ Uncertainty summary</h3></div>
                    <div class="unc-viz-container" id="unc-viz-container">
                        <div id="unc-viz-placeholder" style="color: var(--text-secondary); font-size: 0.9rem; text-align: center; padding: 1rem;">Run a calculation to see result.</div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleUncertaintySteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="unc-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="unc-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Uncertainty principle formulas">
                        <thead>
                            <tr>
                                <th>Form</th>
                                <th>Formula</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Position-momentum</td>
                                <td class="form-equation">Δx · Δp ≥ h/(4π) = ℏ/2</td>
                                <td class="form-desc">ℏ = h/(2π)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Energy-time</td>
                                <td class="form-equation">ΔE · Δt ≥ h/(4π) = ℏ/2</td>
                                <td class="form-desc">Lifetime of excited state</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About Heisenberg's uncertainty principle</h2>
            <p><strong>Position-momentum:</strong> Δx · Δp ≥ ℏ/2. You cannot simultaneously know position and momentum to arbitrary precision; the product of their uncertainties has a minimum. So Δp_min = ℏ/(2Δx) and Δx_min = ℏ/(2Δp).</p>
            <p><strong>Energy-time:</strong> ΔE · Δt ≥ ℏ/2. For an excited state with lifetime Δt, the energy spread is at least ΔE ≈ ℏ/(2Δt). Shorter-lived states have broader energy (e.g. natural line width).</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/uncertainty-principle.js?v=<%=cacheVersion%>"></script>
</body>
</html>
