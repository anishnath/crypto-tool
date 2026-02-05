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
        <jsp:param name="toolName" value="X-Rays - Cut-off Wavelength, Moseley's Law, Kα Line Energy" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="X-ray formulas: cut-off wavelength λ_min = hc/(eV) = 12400/V Å, Moseley's law √ν = a(Z−b), Kα energy E = 13.6 (Z−1)² (1/1²−1/2²) eV. Free calculators with step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/xrays.jsp" />
        <jsp:param name="toolKeywords" value="X-rays, cut-off wavelength, minimum wavelength, Moseley law, K alpha line, characteristic X-rays, accelerating voltage, JEE NEET" />
        <jsp:param name="toolImage" value="xrays.png" />
        <jsp:param name="toolFeatures" value="Cut-off wavelength calculator,Moseley law frequency,Kα line energy calculator,Step-by-step solutions,Å eV Hz" />
        <jsp:param name="faq1q" value="What is X-ray cut-off wavelength?" />
        <jsp:param name="faq1a" value="Minimum wavelength λ_min = hc/(eV) = 12400/V Å, where V is the accelerating voltage in volts. The most energetic X-ray photon has energy eV, so λ_min = hc/(eV)." />
        <jsp:param name="faq2q" value="What is Moseley's law?" />
        <jsp:param name="faq2a" value="Moseley's law: √ν = a (Z − b), where ν is the frequency of characteristic X-rays, Z is atomic number, and b is a screening constant (≈ 1 for K series)." />
        <jsp:param name="faq3q" value="What is the Kα line energy?" />
        <jsp:param name="faq3a" value="Approximate energy of Kα line: E = 13.6 (Z−1)² (1/1² − 1/2²) eV = 10.2 (Z−1)² eV, with screening constant b ≈ 1." />
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
        :root { --xray-slate: #475569; --xray-blue: #0ea5e9; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #475569 0%, #0ea5e9 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(71,85,105,0.1), rgba(14,165,233,0.1)); border-left: 4px solid var(--xray-blue); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #475569, #0ea5e9); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .xray-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .xray-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .xray-tab:hover { border-color: var(--xray-blue); color: var(--xray-blue); }
        .xray-tab.active { background: linear-gradient(135deg, #475569, #0ea5e9); border-color: #0ea5e9; color: white; }
        .xray-panel { display: none; }
        .xray-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--xray-blue); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #475569, #0ea5e9); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(71,85,105,0.15), rgba(14,165,233,0.1)); border: 2px solid var(--xray-blue); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--xray-blue); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #475569, #0ea5e9); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--xray-blue); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(71,85,105,0.1), rgba(14,165,233,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); }
        .xray-viz-container { width: 100%; height: 200px; background: linear-gradient(180deg, #f0f9ff 0%, #e0f2fe 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); display: flex; align-items: center; justify-content: center; }
        .xray-viz-container .highlight { color: var(--xray-blue); font-weight: 700; }
        [data-theme="dark"] .xray-viz-container, .dark-mode .xray-viz-container { background: linear-gradient(180deg, #0c4a6e 0%, #075985 100%); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #475569, #0ea5e9); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--xray-blue); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--xray-blue); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #0ea5e9; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--xray-blue); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>📡</span> X-Rays</h1>
            <p class="tool-page-description">Cut-off wavelength, Moseley's law, Kα line energy</p>
            <div class="tool-badges">
                <span class="tool-badge">λ_min = 12400/V Å</span>
                <span class="tool-badge">√ν = a(Z−b)</span>
                <span class="tool-badge">Kα: 10.2 (Z−1)² eV</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> X-rays</div>
            <p>Cut-off (minimum) wavelength λ_min = hc/(eV) = 12400/V Å (V in volts). Moseley's law: √ν = a (Z − b) for characteristic X-ray frequency ν. Kα line energy (approx): E = 13.6 (Z−1)² (1/1² − 1/2²) eV = 10.2 (Z−1)² eV (screening constant b ≈ 1).</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>X-ray calculators</h2>
                    <p>Cut-off λ_min, Moseley frequency, Kα energy</p>
                </div>
                <div class="panel-body">
                    <div class="xray-tabs">
                        <button type="button" class="xray-tab active" data-tab="cutoff" onclick="if(window.switchXrayTab)window.switchXrayTab('cutoff',this);">Cut-off λ</button>
                        <button type="button" class="xray-tab" data-tab="moseley" onclick="if(window.switchXrayTab)window.switchXrayTab('moseley',this);">Moseley</button>
                        <button type="button" class="xray-tab" data-tab="kalpha" onclick="if(window.switchXrayTab)window.switchXrayTab('kalpha',this);">Kα energy</button>
                    </div>

                    <div id="panel-cutoff" class="xray-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Accelerating voltage (V)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="cutoff-v" class="number-input" value="50" min="0" step="any">
                                <select id="cutoff-v-unit" class="unit-select">
                                    <option value="V">V</option>
                                    <option value="kV">kV</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runXrays()">Calculate λ_min</button>
                        <div class="result-card" id="result-cutoff">
                            <div class="result-label">Cut-off wavelength</div>
                            <div class="result-value" id="cutoff-result">248 Å</div>
                        </div>
                    </div>

                    <div id="panel-moseley" class="xray-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Atomic number (Z)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="moseley-z" class="number-input" value="29" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">Z (e.g. Cu=29)</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Screening constant (b)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="moseley-b" class="number-input" value="1" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">b ≈ 1 for K</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Constant a (×10⁷ √Hz)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="moseley-a" class="number-input" value="4.96" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">a × 10⁷</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runXrays()">Calculate √ν and ν</button>
                        <div class="result-card" id="result-moseley">
                            <div class="result-label">√ν (√Hz) &amp; frequency ν (Hz)</div>
                            <div class="result-value" id="moseley-result">—</div>
                        </div>
                    </div>

                    <div id="panel-kalpha" class="xray-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Atomic number (Z)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="kalpha-z" class="number-input" value="29" min="2" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem;">Z ≥ 2</span>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runXrays()">Calculate Kα energy</button>
                        <div class="result-card" id="result-kalpha">
                            <div class="result-label">Kα line energy</div>
                            <div class="result-value" id="kalpha-result">8046 eV</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>📡 X-ray summary</h3></div>
                    <div class="xray-viz-container" id="xray-viz-container">
                        <div id="xray-viz-placeholder" style="color: var(--text-secondary); font-size: 0.9rem; text-align: center; padding: 1rem;">Run a calculation to see result.</div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleXraySteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="xray-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="xray-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="X-ray formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Cut-off / minimum wavelength</td>
                                <td class="form-equation">λ_min = hc/(eV) = 12400/V (Å)</td>
                                <td class="form-desc">V = accelerating voltage in volts</td>
                            </tr>
                            <tr>
                                <td class="form-name">Moseley's law</td>
                                <td class="form-equation">√ν = a (Z − b)</td>
                                <td class="form-desc">ν = frequency of characteristic X-rays</td>
                            </tr>
                            <tr>
                                <td class="form-name">Energy of Kα line (approx)</td>
                                <td class="form-equation">E = 13.6 (Z−1)² (1/1² − 1/2²) eV</td>
                                <td class="form-desc">Screening constant b ≈ 1; E = 10.2 (Z−1)² eV</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About X-rays</h2>
            <p>When electrons are accelerated through a voltage V and strike a target, the shortest (cut-off) X-ray wavelength is <strong>λ_min = hc/(eV) = 12400/V Å</strong> (V in volts). Characteristic X-rays follow <strong>Moseley's law √ν = a (Z − b)</strong>; for the K series b ≈ 1. The Kα line (transition n=2 → n=1) has approximate energy <strong>E = 13.6 (Z−1)² (1/1² − 1/2²) eV = 10.2 (Z−1)² eV</strong>.</p>
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
    <script src="<%=request.getContextPath()%>/physics/js/xrays.js?v=<%=cacheVersion%>"></script>
</body>
</html>
