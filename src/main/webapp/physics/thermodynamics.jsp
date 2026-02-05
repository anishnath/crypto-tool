<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Thermodynamics - First Law, Work, Specific Heats, Processes, Entropy, Kinetic Theory" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="First law ΔU = Q − W, work in isobaric/isochoric/isothermal/adiabatic processes, specific heats C_v C_p γ, process table, second law and entropy, kinetic theory v_rms P λ. Free calculators and reference." />
        <jsp:param name="toolUrl" value="physics/thermodynamics.jsp" />
        <jsp:param name="toolKeywords" value="thermodynamics, first law, ideal gas, specific heat, entropy, kinetic theory, v_rms, heat engine, JEE NEET" />
        <jsp:param name="toolImage" value="thermodynamics.png" />
        <jsp:param name="toolFeatures" value="First law and work calculators,Specific heats and DoF table,Process table (isothermal adiabatic),Second law and entropy,Kinetic theory calculators" />
    </jsp:include>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <style>
        :root { --td-red: #b91c1c; --td-amber: #d97706; --surface-1: #fff; --surface-2: #f8fafc; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; }
        [data-theme="dark"] { --surface-1: #1e293b; --surface-2: #0f172a; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #b91c1c 0%, #d97706 100%); padding: 1.25rem 1.5rem; margin-top: 72px; color: white; }
        .tool-page-title { margin: 0; font-size: 1.5rem; font-weight: 700; }
        .edu-container { max-width: 1200px; margin: 0 auto; padding: 2rem 1rem; }
        .back-link { color: var(--td-red); font-weight: 600; text-decoration: none; margin-bottom: 1rem; display: inline-block; }
        .back-link:hover { text-decoration: underline; }
        .td-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .td-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.8rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; }
        .td-tab:hover { border-color: var(--td-red); color: var(--td-red); }
        .td-tab.active { background: linear-gradient(135deg, #b91c1c, #d97706); border-color: #d97706; color: white; }
        .td-panel { display: none; }
        .td-panel.active { display: block; }
        .ref-card { background: var(--surface-1); border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 1.25rem; }
        .ref-card h3 { margin: 0; padding: 0.75rem 1rem; background: rgba(185,28,28,0.08); border-bottom: 1px solid var(--border-light); font-size: 0.95rem; color: var(--text-primary); }
        .ref-table { width: 100%; border-collapse: collapse; font-size: 0.85rem; }
        .ref-table th, .ref-table td { padding: 0.5rem 0.75rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .ref-table thead th { background: linear-gradient(135deg, #b91c1c, #d97706); color: white; font-weight: 700; }
        .ref-table .mono { font-family: 'JetBrains Mono', monospace; font-weight: 600; color: var(--td-red); }
        .control-panel { background: var(--surface-1); border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); border: 1px solid var(--border-light); margin-bottom: 1.25rem; }
        .panel-header { background: linear-gradient(135deg, #b91c1c, #d97706); color: white; padding: 1rem 1.25rem; }
        .panel-header h2 { margin: 0; font-size: 1.1rem; }
        .panel-body { padding: 1.25rem; }
        .input-section { margin-bottom: 1rem; }
        .input-label { font-weight: 600; color: var(--text-primary); margin-bottom: 0.35rem; font-size: 0.9rem; }
        .number-input, .unit-select { padding: 0.5rem 0.75rem; border: 2px solid var(--border-light); border-radius: 8px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .unit-select { min-width: 90px; cursor: pointer; }
        .input-row { display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap; }
        .input-row input, .input-row select { flex: 1; min-width: 80px; }
        .calc-btn { width: 100%; padding: 0.75rem; background: linear-gradient(135deg, #b91c1c, #d97706); color: white; border: none; border-radius: 10px; font-weight: 700; cursor: pointer; margin-top: 0.5rem; }
        .calc-btn:hover { opacity: 0.95; }
        .result-card { background: rgba(185,28,28,0.08); border: 2px solid var(--td-red); border-radius: 10px; padding: 1rem; margin-top: 1rem; text-align: center; }
        .result-value { font-size: 1.2rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--td-red); }
        .info-box { background: rgba(185,28,28,0.08); border-left: 4px solid var(--td-red); border-radius: 8px; padding: 1rem; margin-bottom: 1.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .edu-content { background: var(--surface-1); border-radius: 12px; padding: 1.5rem; margin-top: 1.5rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 0.75rem; font-size: 1.25rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.6; }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>
    <header class="tool-header">
        <div style="max-width:1200px;margin:0 auto;">
            <h1 class="tool-page-title">📐 Thermodynamics</h1>
            <p style="margin:0.25rem 0 0; opacity:0.95; font-size:0.95rem;">First law, work, specific heats, processes, second law & entropy, kinetic theory</p>
        </div>
    </header>
    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>
        <div class="info-box">
            <p><strong>First law:</strong> ΔU = Q − W (Q = heat added to system, W = work done by system). <strong>Work:</strong> isobaric W = PΔV; isochoric W = 0; isothermal W = nRT ln(V_f/V_i); adiabatic W = (P_i V_i − P_f V_f)/(γ−1). <strong>Specific heats:</strong> C_p − C_v = R; U = n C_v T. <strong>Second law:</strong> ΔS_universe ≥ 0; ΔS = Q_rev/T. <strong>Kinetic theory:</strong> v_rms = √(3RT/M), P = (1/3)ρ v_rms².</p>
        </div>

        <div class="td-tabs">
            <button type="button" class="td-tab active" data-tab="firstlaw">First law &amp; work</button>
            <button type="button" class="td-tab" data-tab="specificheats">Specific heats</button>
            <button type="button" class="td-tab" data-tab="processes">Processes</button>
            <button type="button" class="td-tab" data-tab="secondlaw">Second law</button>
            <button type="button" class="td-tab" data-tab="kinetic">Kinetic theory</button>
        </div>

        <div id="panel-firstlaw" class="td-panel active">
            <div class="control-panel">
                <div class="panel-header"><h2>Work in thermodynamic process (ideal gas)</h2></div>
                <div class="panel-body">
                    <div class="input-section">
                        <div class="input-label">Process type</div>
                        <select id="td-work-process" class="unit-select" style="width:100%;">
                            <option value="isobaric">Isobaric (W = P ΔV)</option>
                            <option value="isochoric">Isochoric (W = 0)</option>
                            <option value="isothermal">Isothermal (W = nRT ln(V_f/V_i))</option>
                            <option value="adiabatic">Adiabatic (W = (P_i V_i − P_f V_f)/(γ−1))</option>
                        </select>
                    </div>
                    <div class="input-section" id="td-work-inputs">
                        <div class="input-label">P (Pa), ΔV (m³) or V_i, V_f (m³), n (mol), T (K), γ</div>
                        <div class="input-row">
                            <input type="number" id="td-p" class="number-input" value="101325" placeholder="P" step="any">
                            <input type="number" id="td-dv" class="number-input" value="0.001" placeholder="ΔV" step="any">
                            <input type="number" id="td-n" class="number-input" value="1" placeholder="n" step="any">
                            <input type="number" id="td-t" class="number-input" value="300" placeholder="T" step="any">
                            <input type="number" id="td-gamma" class="number-input" value="1.4" placeholder="γ" step="any">
                        </div>
                        <div class="input-row" style="margin-top:0.5rem;">
                            <input type="number" id="td-vi" class="number-input" value="0.024" placeholder="V_i" step="any">
                            <input type="number" id="td-vf" class="number-input" value="0.048" placeholder="V_f" step="any">
                        </div>
                    </div>
                    <button type="button" class="calc-btn" onclick="window.runThermo()">Calculate W</button>
                    <div class="result-card">
                        <div class="result-value" id="td-work-result">—</div>
                    </div>
                </div>
            </div>
            <div class="ref-card">
                <h3>First law &amp; work formulas</h3>
                <table class="ref-table">
                    <thead><tr><th>Concept</th><th>Formula</th></tr></thead>
                    <tbody>
                        <tr><td>First law</td><td class="mono">ΔU = Q − W</td></tr>
                        <tr><td>Isobaric</td><td class="mono">W = P ΔV</td></tr>
                        <tr><td>Isochoric</td><td class="mono">W = 0</td></tr>
                        <tr><td>Isothermal</td><td class="mono">W = nRT ln(V_f/V_i) = nRT ln(P_i/P_f)</td></tr>
                        <tr><td>Adiabatic</td><td class="mono">W = (P_i V_i − P_f V_f)/(γ−1) = n C_v (T_i − T_f)</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="panel-specificheats" class="td-panel">
            <div class="ref-card">
                <h3>Specific heats &amp; degrees of freedom</h3>
                <table class="ref-table">
                    <thead><tr><th>Gas</th><th>f</th><th>C_v (molar)</th><th>C_p (molar)</th><th>γ</th></tr></thead>
                    <tbody>
                        <tr><td>Monatomic</td><td>3</td><td class="mono">(3/2)R</td><td class="mono">(5/2)R</td><td>5/3 ≈ 1.667</td></tr>
                        <tr><td>Diatomic (room)</td><td>5</td><td class="mono">(5/2)R</td><td class="mono">(7/2)R</td><td>7/5 = 1.4</td></tr>
                        <tr><td>Diatomic (vibration)</td><td>7</td><td class="mono">(7/2)R</td><td class="mono">(9/2)R</td><td>9/7 ≈ 1.286</td></tr>
                        <tr><td>Polyatomic (non-linear)</td><td>6</td><td class="mono">3R</td><td class="mono">4R</td><td>4/3 ≈ 1.333</td></tr>
                    </tbody>
                </table>
                <p style="padding:0.75rem 1rem; margin:0; font-size:0.85rem; color: var(--text-secondary);">Mayer: C_p − C_v = R. Internal energy: U = n C_v T (ideal gas).</p>
            </div>
            <div class="control-panel">
                <div class="panel-header"><h2>Internal energy U = n C_v T</h2></div>
                <div class="panel-body">
                    <div class="input-row">
                        <input type="number" id="td-u-n" class="number-input" value="1" placeholder="n (mol)" step="any">
                        <input type="number" id="td-u-t" class="number-input" value="300" placeholder="T (K)" step="any">
                        <select id="td-u-gas" class="unit-select">
                            <option value="mono">Monatomic</option>
                            <option value="di">Diatomic</option>
                            <option value="poly">Polyatomic</option>
                        </select>
                    </div>
                    <button type="button" class="calc-btn" onclick="window.runThermo()">Calculate U</button>
                    <div class="result-card"><div class="result-value" id="td-u-result">—</div></div>
                </div>
            </div>
        </div>

        <div id="panel-processes" class="td-panel">
            <div class="ref-card">
                <h3>Ideal gas processes summary</h3>
                <table class="ref-table">
                    <thead><tr><th>Process</th><th>ΔU</th><th>Q</th><th>W</th><th>P–V / T</th></tr></thead>
                    <tbody>
                        <tr><td>Isothermal</td><td>0</td><td>W</td><td>nRT ln(V_f/V_i)</td><td>PV = const, T = const</td></tr>
                        <tr><td>Adiabatic</td><td>n C_v ΔT</td><td>0</td><td>−ΔU</td><td>PV^γ = const, TV^(γ−1) = const</td></tr>
                        <tr><td>Isochoric</td><td>n C_v ΔT</td><td>ΔU</td><td>0</td><td>V = const, P ∝ T</td></tr>
                        <tr><td>Isobaric</td><td>n C_v ΔT</td><td>n C_p ΔT</td><td>P ΔV</td><td>P = const, V ∝ T</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="panel-secondlaw" class="td-panel">
            <div class="ref-card">
                <h3>Second law &amp; entropy</h3>
                <table class="ref-table">
                    <thead><tr><th>Statement / Concept</th><th>Expression</th></tr></thead>
                    <tbody>
                        <tr><td>Kelvin–Planck</td><td>No engine converts heat fully to work</td></tr>
                        <tr><td>Clausius</td><td>Heat cannot flow cold→hot without work</td></tr>
                        <tr><td>Entropy change (reversible)</td><td class="mono">ΔS = Q_rev / T</td></tr>
                        <tr><td>Total entropy</td><td class="mono">ΔS_universe ≥ 0</td></tr>
                        <tr><td>Ideal gas</td><td class="mono">ΔS = n C_v ln(T_f/T_i) + n R ln(V_f/V_i)</td></tr>
                    </tbody>
                </table>
            </div>
            <div class="control-panel">
                <div class="panel-header"><h2>Entropy change (ideal gas)</h2></div>
                <div class="panel-body">
                    <div class="input-row">
                        <input type="number" id="td-s-n" class="number-input" value="1" placeholder="n (mol)" step="any">
                        <input type="number" id="td-s-ti" class="number-input" value="300" placeholder="T_i (K)" step="any">
                        <input type="number" id="td-s-tf" class="number-input" value="600" placeholder="T_f (K)" step="any">
                        <input type="number" id="td-s-vi" class="number-input" value="0.02" placeholder="V_i" step="any">
                        <input type="number" id="td-s-vf" class="number-input" value="0.04" placeholder="V_f" step="any">
                    </div>
                    <button type="button" class="calc-btn" onclick="window.runThermo()">Calculate ΔS</button>
                    <div class="result-card"><div class="result-value" id="td-s-result">—</div></div>
                </div>
            </div>
        </div>

        <div id="panel-kinetic" class="td-panel">
            <div class="ref-card">
                <h3>Kinetic theory formulas</h3>
                <table class="ref-table">
                    <thead><tr><th>Concept</th><th>Formula</th></tr></thead>
                    <tbody>
                        <tr><td>Pressure</td><td class="mono">P = (1/3) ρ v_rms²</td></tr>
                        <tr><td>v_rms</td><td class="mono">√(3RT / M)</td></tr>
                        <tr><td>v_avg</td><td class="mono">√(8RT / (πM))</td></tr>
                        <tr><td>v_mp</td><td class="mono">√(2RT / M)</td></tr>
                        <tr><td>Mean free path</td><td class="mono">λ = 1 / (√2 π d² N/V)</td></tr>
                        <tr><td>Internal energy</td><td class="mono">U = (f/2) n R T</td></tr>
                    </tbody>
                </table>
            </div>
            <div class="control-panel">
                <div class="panel-header"><h2>Speeds &amp; pressure (ideal gas)</h2></div>
                <div class="panel-body">
                    <div class="input-row">
                        <input type="number" id="td-kt-t" class="number-input" value="300" placeholder="T (K)" step="any">
                        <input type="number" id="td-kt-m" class="number-input" value="0.029" placeholder="M (kg/mol)" step="any">
                        <input type="number" id="td-kt-rho" class="number-input" value="1.2" placeholder="ρ (kg/m³)" step="any">
                    </div>
                    <button type="button" class="calc-btn" onclick="window.runThermo()">Calculate</button>
                    <div class="result-card">
                        <div class="result-value" id="td-kinetic-result">—</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About this page</h2>
            <p>For more on temperature scales, Zeroth law, sensible/latent heat, heat engine efficiency, and refrigerator COP, see the <a href="<%=request.getContextPath()%>/physics/thermal-energy.jsp" style="color:var(--td-red); font-weight:600;">Thermal Energy</a> tool. Here we cover first law and work in processes, specific heats and degrees of freedom, process summary, second law and entropy, and kinetic theory of gases.</p>
        </div>
    </main>
    <footer style="background: var(--surface-1); border-top: 1px solid var(--border-light); padding: 1.5rem; text-align: center; margin-top: 2rem;">
        <p style="margin:0; color: var(--text-secondary); font-size: 0.85rem;">&copy; 2025 8gwifi.org.</p>
    </footer>
    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/physics/js/thermodynamics.js?v=<%=cacheVersion%>"></script>
</body>
</html>
