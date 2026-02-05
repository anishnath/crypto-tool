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
        <jsp:param name="toolName" value="Units and Measurement - SI Base & Derived Units, Dimensional Analysis, Significant Figures" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="SI base quantities (length, mass, time, current, temperature, mole, candela), derived units (force, pressure, energy, power), prefixes, dimensional analysis, significant figures, practical units (eV, atm, Å), order of magnitude. Free reference and calculators." />
        <jsp:param name="toolUrl" value="physics/units-measurement.jsp" />
        <jsp:param name="toolKeywords" value="SI units, base quantities, derived units, dimensional analysis, significant figures, order of magnitude, unit conversion, physics units, JEE NEET" />
        <jsp:param name="toolImage" value="units-measurement.png" />
        <jsp:param name="toolFeatures" value="SI base and derived units tables,SI prefixes,Unit converter (eV atm Å),Significant figures calculator,Order of magnitude,Dimensional analysis reference" />
        <jsp:param name="faq1q" value="What are the 7 SI base quantities?" />
        <jsp:param name="faq1a" value="Length (m), mass (kg), time (s), electric current (A), thermodynamic temperature (K), amount of substance (mol), luminous intensity (cd)." />
        <jsp:param name="faq2q" value="What is dimensional analysis?" />
        <jsp:param name="faq2a" value="Checking that both sides of an equation have the same dimensions [M], [L], [T], etc. It can verify correctness and convert units but cannot find dimensionless constants." />
        <jsp:param name="faq3q" value="What are significant figures rules?" />
        <jsp:param name="faq3a" value="Non-zero digits are significant; zeros between non-zero digits are significant; leading zeros are not; trailing zeros after decimal are. In multiplication/division use the least number of significant figures." />
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
        :root { --um-blue: #2563eb; --um-indigo: #4f46e5; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #2563eb 0%, #4f46e5 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .info-box { background: linear-gradient(135deg, rgba(37,99,235,0.1), rgba(79,70,229,0.1)); border-left: 4px solid var(--um-blue); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .um-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .um-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .um-tab:hover { border-color: var(--um-blue); color: var(--um-blue); }
        .um-tab.active { background: linear-gradient(135deg, #2563eb, #4f46e5); border-color: #4f46e5; color: white; }
        .um-panel { display: none; }
        .um-panel.active { display: block; }
        .ref-card { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 1.5rem; }
        .ref-card h3 { margin: 0; padding: 1rem 1.25rem; background: linear-gradient(135deg, rgba(37,99,235,0.1), rgba(79,70,229,0.05)); border-bottom: 1px solid var(--border-light); font-size: 1rem; color: var(--text-primary); }
        .ref-table { width: 100%; border-collapse: collapse; }
        .ref-table th, .ref-table td { padding: 0.75rem 1rem; text-align: left; border-bottom: 1px solid var(--border-light); font-size: 0.9rem; }
        .ref-table thead th { background: linear-gradient(135deg, #2563eb, #4f46e5); color: white; font-weight: 700; }
        .ref-table tbody tr:last-child td { border-bottom: none; }
        .ref-table tbody tr:hover { background: var(--surface-2); }
        .ref-table .mono { font-family: 'JetBrains Mono', monospace; font-weight: 600; color: var(--um-blue); }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .panel-header { background: linear-gradient(135deg, #2563eb, #4f46e5); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .number-input { width: 100%; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); box-sizing: border-box; }
        .number-input:focus { outline: none; border-color: var(--um-blue); }
        .unit-select { padding: 0.5rem; border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.9rem; background: var(--surface-3); color: var(--text-primary); cursor: pointer; min-width: 90px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #2563eb, #4f46e5); color: white; border: none; border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(37,99,235,0.12), rgba(79,70,229,0.08)); border: 2px solid var(--um-blue); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-value { font-size: 1.35rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--um-blue); }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .steps-section { margin-top: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #2563eb, #4f46e5); color: white; padding: 0.75rem 1rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.5rem; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 320px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--um-blue); }
        .step-formula { font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: var(--um-blue); margin: 0.5rem 0; }
        .step-calc { font-size: 0.85rem; color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--um-blue); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        .input-with-unit { display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap; }
        .input-with-unit input { flex: 1; min-width: 100px; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .edu-content ul { padding-left: 1.5rem; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .ref-table th, .ref-table td { padding: 0.5rem; font-size: 0.8rem; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>📐</span> Units and Measurement</h1>
            <p class="tool-page-description">SI base & derived units, prefixes, dimensional analysis, significant figures, practical units</p>
            <div class="tool-badges">
                <span class="tool-badge">7 base quantities</span>
                <span class="tool-badge">Dimensional analysis</span>
                <span class="tool-badge">Sig figs & order of magnitude</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title">SI system</div>
            <p>Seven base quantities: length (m), mass (kg), time (s), current (A), temperature (K), amount of substance (mol), luminous intensity (cd). Derived units (force, pressure, energy, power, etc.) and prefixes (k, M, μ, n…) for multiples and sub-multiples. Dimensional analysis checks equation correctness; significant figures and order of magnitude for reporting and estimation.</p>
        </div>

        <div class="um-tabs">
            <button type="button" class="um-tab active" data-tab="base" onclick="if(window.switchUMTab)window.switchUMTab('base',this);">Base (SI)</button>
            <button type="button" class="um-tab" data-tab="derived" onclick="if(window.switchUMTab)window.switchUMTab('derived',this);">Derived</button>
            <button type="button" class="um-tab" data-tab="prefixes" onclick="if(window.switchUMTab)window.switchUMTab('prefixes',this);">Prefixes</button>
            <button type="button" class="um-tab" data-tab="converter" onclick="if(window.switchUMTab)window.switchUMTab('converter',this);">Unit converter</button>
            <button type="button" class="um-tab" data-tab="sigfig" onclick="if(window.switchUMTab)window.switchUMTab('sigfig',this);">Significant figures</button>
            <button type="button" class="um-tab" data-tab="order" onclick="if(window.switchUMTab)window.switchUMTab('order',this);">Order of magnitude</button>
            <button type="button" class="um-tab" data-tab="practical" onclick="if(window.switchUMTab)window.switchUMTab('practical',this);">Practical units</button>
        </div>

        <div id="panel-um-base" class="um-panel active">
            <div class="ref-card">
                <h3>1. Fundamental / Base quantities (SI)</h3>
                <table class="ref-table" aria-label="SI base quantities">
                    <thead><tr><th>No.</th><th>Physical quantity</th><th>Symbol</th><th>SI unit</th><th>Unit symbol</th><th>Dimension</th></tr></thead>
                    <tbody>
                        <tr><td>1</td><td>Length</td><td class="mono">l, x</td><td>metre</td><td class="mono">m</td><td class="mono">[L]</td></tr>
                        <tr><td>2</td><td>Mass</td><td class="mono">m</td><td>kilogram</td><td class="mono">kg</td><td class="mono">[M]</td></tr>
                        <tr><td>3</td><td>Time</td><td class="mono">t</td><td>second</td><td class="mono">s</td><td class="mono">[T]</td></tr>
                        <tr><td>4</td><td>Electric current</td><td class="mono">I</td><td>ampere</td><td class="mono">A</td><td class="mono">[I]</td></tr>
                        <tr><td>5</td><td>Thermodynamic temperature</td><td class="mono">T</td><td>kelvin</td><td class="mono">K</td><td class="mono">[Θ]</td></tr>
                        <tr><td>6</td><td>Amount of substance</td><td class="mono">n</td><td>mole</td><td class="mono">mol</td><td class="mono">[N]</td></tr>
                        <tr><td>7</td><td>Luminous intensity</td><td class="mono">Iᵥ</td><td>candela</td><td class="mono">cd</td><td class="mono">[J]</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="panel-um-derived" class="um-panel">
            <div class="ref-card">
                <h3>2. Derived quantities (common)</h3>
                <table class="ref-table" aria-label="Derived quantities">
                    <thead><tr><th>Quantity</th><th>Formula</th><th>SI unit</th><th>Dimension</th></tr></thead>
                    <tbody>
                        <tr><td>Area</td><td class="mono">length × length</td><td class="mono">m²</td><td class="mono">[L²]</td></tr>
                        <tr><td>Volume</td><td class="mono">length³</td><td class="mono">m³</td><td class="mono">[L³]</td></tr>
                        <tr><td>Velocity</td><td class="mono">displacement / time</td><td class="mono">m/s</td><td class="mono">[LT⁻¹]</td></tr>
                        <tr><td>Acceleration</td><td class="mono">velocity / time</td><td class="mono">m/s²</td><td class="mono">[LT⁻²]</td></tr>
                        <tr><td>Force</td><td class="mono">mass × acceleration</td><td class="mono">N (kg·m/s²)</td><td class="mono">[MLT⁻²]</td></tr>
                        <tr><td>Pressure</td><td class="mono">force / area</td><td class="mono">Pa (N/m²)</td><td class="mono">[ML⁻¹T⁻²]</td></tr>
                        <tr><td>Work / Energy</td><td class="mono">force × distance</td><td class="mono">J (N·m)</td><td class="mono">[ML²T⁻²]</td></tr>
                        <tr><td>Power</td><td class="mono">work / time</td><td class="mono">W (J/s)</td><td class="mono">[ML²T⁻³]</td></tr>
                        <tr><td>Momentum</td><td class="mono">mass × velocity</td><td class="mono">kg·m/s</td><td class="mono">[MLT⁻¹]</td></tr>
                        <tr><td>Frequency</td><td class="mono">1 / period</td><td class="mono">Hz (s⁻¹)</td><td class="mono">[T⁻¹]</td></tr>
                        <tr><td>Electric charge</td><td class="mono">current × time</td><td class="mono">C (A·s)</td><td class="mono">[IT]</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="panel-um-prefixes" class="um-panel">
            <div class="ref-card">
                <h3>3. SI prefixes (multiples &amp; sub-multiples)</h3>
                <table class="ref-table" aria-label="SI prefixes">
                    <thead><tr><th>Prefix</th><th>Symbol</th><th>Power of 10</th><th>Example</th></tr></thead>
                    <tbody>
                        <tr><td>yotta</td><td class="mono">Y</td><td class="mono">10²⁴</td><td>—</td></tr>
                        <tr><td>zetta</td><td class="mono">Z</td><td class="mono">10²¹</td><td>—</td></tr>
                        <tr><td>exa</td><td class="mono">E</td><td class="mono">10¹⁸</td><td>—</td></tr>
                        <tr><td>peta</td><td class="mono">P</td><td class="mono">10¹⁵</td><td>—</td></tr>
                        <tr><td>tera</td><td class="mono">T</td><td class="mono">10¹²</td><td>THz</td></tr>
                        <tr><td>giga</td><td class="mono">G</td><td class="mono">10⁹</td><td>GB</td></tr>
                        <tr><td>mega</td><td class="mono">M</td><td class="mono">10⁶</td><td>MW</td></tr>
                        <tr><td>kilo</td><td class="mono">k</td><td class="mono">10³</td><td>kg</td></tr>
                        <tr><td>hecto</td><td class="mono">h</td><td class="mono">10²</td><td>—</td></tr>
                        <tr><td>deca</td><td class="mono">da</td><td class="mono">10¹</td><td>—</td></tr>
                        <tr><td>deci</td><td class="mono">d</td><td class="mono">10⁻¹</td><td>dm</td></tr>
                        <tr><td>centi</td><td class="mono">c</td><td class="mono">10⁻²</td><td>cm</td></tr>
                        <tr><td>milli</td><td class="mono">m</td><td class="mono">10⁻³</td><td>ms</td></tr>
                        <tr><td>micro</td><td class="mono">μ</td><td class="mono">10⁻⁶</td><td>μm</td></tr>
                        <tr><td>nano</td><td class="mono">n</td><td class="mono">10⁻⁹</td><td>nm</td></tr>
                        <tr><td>pico</td><td class="mono">p</td><td class="mono">10⁻¹²</td><td>ps</td></tr>
                        <tr><td>femto</td><td class="mono">f</td><td class="mono">10⁻¹⁵</td><td>fm</td></tr>
                        <tr><td>atto</td><td class="mono">a</td><td class="mono">10⁻¹⁸</td><td>—</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="panel-um-converter" class="um-panel">
            <div class="control-panel">
                <div class="panel-header"><h2>Unit converter (practical units)</h2><p>Convert between SI and common practical units</p></div>
                <div class="panel-body">
                    <div class="input-section">
                        <div class="input-label">Quantity &amp; direction</div>
                        <div class="input-with-unit" style="flex-wrap: wrap;">
                            <select id="um-conv-type" class="unit-select">
                                <option value="ev">Energy (eV ↔ J)</option>
                                <option value="length_ang">Length (Å ↔ m)</option>
                                <option value="length_fm">Length (fm ↔ m)</option>
                                <option value="pressure_atm">Pressure (atm ↔ Pa)</option>
                                <option value="pressure_torr">Pressure (mmHg ↔ Pa)</option>
                                <option value="mass_u">Mass (u ↔ kg)</option>
                            </select>
                            <select id="um-conv-dir" class="unit-select">
                                <option value="toSI">practical → SI</option>
                                <option value="toPractical">SI → practical</option>
                            </select>
                        </div>
                    </div>
                    <div class="input-section">
                        <div class="input-label">Value</div>
                        <input type="number" id="um-conv-value" class="number-input" value="1" step="any" placeholder="Value">
                    </div>
                    <button type="button" class="calc-btn" onclick="window.runUnitsMeasurement()">Convert</button>
                    <div class="result-card">
                        <div class="result-label" id="um-conv-result-label">Result</div>
                        <div class="result-value" id="um-conv-result">—</div>
                    </div>
                    <div class="steps-section">
                        <div class="steps-header" onclick="window.toggleUMSteps('conv')"><span>🧮</span> Step-by-step <span class="steps-toggle" id="um-steps-toggle">▼ Show</span></div>
                        <div class="steps-body collapsed" id="um-steps-body"></div>
                    </div>
                </div>
            </div>
        </div>

        <div id="panel-um-sigfig" class="um-panel">
            <div class="control-panel">
                <div class="panel-header"><h2>Significant figures</h2><p>Count sig figs or round to n significant figures</p></div>
                <div class="panel-body">
                    <div class="um-tabs" style="margin-bottom: 1rem;">
                        <button type="button" class="um-tab um-sigfig-mode active" data-mode="count" onclick="if(window.setSigFigMode)window.setSigFigMode('count');">Count</button>
                        <button type="button" class="um-tab um-sigfig-mode" data-mode="round" onclick="if(window.setSigFigMode)window.setSigFigMode('round');">Round to n</button>
                        <button type="button" class="um-tab um-sigfig-mode" data-mode="addsub" onclick="if(window.setSigFigMode)window.setSigFigMode('addsub');">Add/Subtract</button>
                        <button type="button" class="um-tab um-sigfig-mode" data-mode="muldiv" onclick="if(window.setSigFigMode)window.setSigFigMode('muldiv');">Multiply/Divide</button>
                    </div>
                    <div class="input-section" id="um-sigfig-input-section">
                        <div class="input-label" id="um-sigfig-label">Number (to count significant figures)</div>
                        <input type="text" id="um-sigfig-input" class="number-input" value="123.450" placeholder="e.g. 0.00250 or 1.200×10³">
                    </div>
                    <div class="input-section" id="um-sigfig-n-section" style="display:none;">
                        <div class="input-label">Number of significant figures (n)</div>
                        <input type="number" id="um-sigfig-n" class="number-input" value="3" min="1" max="15" step="1">
                    </div>
                    <div class="input-section" id="um-sigfig-addsub-section" style="display:none;">
                        <div class="input-label">A and B (result has decimal places = least of A, B)</div>
                        <div class="input-with-unit">
                            <input type="text" id="um-sigfig-a" class="number-input" value="1.23" placeholder="A">
                            <input type="text" id="um-sigfig-b" class="number-input" value="4.5" placeholder="B">
                        </div>
                    </div>
                    <div class="input-section" id="um-sigfig-muldiv-section" style="display:none;">
                        <div class="input-label">A and B (result has sig figs = least of A, B)</div>
                        <div class="input-with-unit">
                            <input type="text" id="um-sigfig-mula" class="number-input" value="12.3" placeholder="A">
                            <input type="text" id="um-sigfig-mulb" class="number-input" value="4.5" placeholder="B">
                        </div>
                    </div>
                    <button type="button" class="calc-btn" onclick="window.runUnitsMeasurement()">Calculate</button>
                    <div class="result-card">
                        <div class="result-label" id="um-sigfig-result-label">Result</div>
                        <div class="result-value" id="um-sigfig-result">—</div>
                    </div>
                    <div class="steps-section">
                        <div class="steps-header" onclick="window.toggleUMSteps('sigfig')"><span>🧮</span> Step-by-step <span class="steps-toggle" id="um-steps-toggle2">▼ Show</span></div>
                        <div class="steps-body collapsed" id="um-steps-body2"></div>
                    </div>
                    <div class="ref-card" style="margin-top: 1.5rem;">
                        <h3>5. Significant figures rules (reference)</h3>
                        <table class="ref-table" aria-label="Significant figures rules">
                            <thead><tr><th>Rule</th><th>Example</th><th>Sig figs</th></tr></thead>
                            <tbody>
                                <tr><td>All non-zero digits are significant</td><td class="mono">123.45</td><td>5</td></tr>
                                <tr><td>Zeros between non-zero digits</td><td class="mono">1002</td><td>4</td></tr>
                                <tr><td>Leading zeros are not significant</td><td class="mono">0.0025</td><td>2</td></tr>
                                <tr><td>Trailing zeros in whole number (no decimal)</td><td class="mono">1200</td><td>Ambiguous (2 or 4)</td></tr>
                                <tr><td>Trailing zeros after decimal</td><td class="mono">1200.0</td><td>5</td></tr>
                                <tr><td>Scientific notation</td><td class="mono">1.200×10³</td><td>4</td></tr>
                                <tr><td colspan="3" style="font-size:0.85rem; color: var(--text-secondary);">Add/Subtract → result has least decimal places. Multiply/Divide → result has least significant figures.</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div id="panel-um-order" class="um-panel">
            <div class="control-panel">
                <div class="panel-header"><h2>Order of magnitude &amp; estimation</h2><p>Power of 10 when expressed in scientific notation (e.g. 450 → 2, 0.0032 → −3)</p></div>
                <div class="panel-body">
                    <div class="input-section">
                        <div class="input-label">Quantity (number)</div>
                        <input type="text" id="um-order-input" class="number-input" value="450" placeholder="e.g. 450 or 0.0032">
                    </div>
                    <button type="button" class="calc-btn" onclick="window.runUnitsMeasurement()">Find order</button>
                    <div class="result-card">
                        <div class="result-label">Order of magnitude</div>
                        <div class="result-value" id="um-order-result">—</div>
                    </div>
                    <div class="steps-section">
                        <div class="steps-header" onclick="window.toggleUMSteps('order')"><span>🧮</span> Step-by-step <span class="steps-toggle" id="um-steps-toggle3">▼ Show</span></div>
                        <div class="steps-body collapsed" id="um-steps-body3"></div>
                    </div>
                </div>
            </div>
        </div>

        <div id="panel-um-practical" class="um-panel">
            <div class="ref-card">
                <h3>6. Practical units (value in SI)</h3>
                <table class="ref-table" aria-label="Practical units">
                    <thead><tr><th>Quantity</th><th>Unit</th><th>Value in SI</th><th>Use case</th></tr></thead>
                    <tbody>
                        <tr><td>Length</td><td class="mono">Ångstrom (Å)</td><td class="mono">10⁻¹⁰ m</td><td>Atomic distances</td></tr>
                        <tr><td>Length</td><td class="mono">Fermi (fm)</td><td class="mono">10⁻¹⁵ m</td><td>Nuclear physics</td></tr>
                        <tr><td>Length</td><td class="mono">Astronomical unit (AU)</td><td class="mono">≈ 1.496×10¹¹ m</td><td>Solar system</td></tr>
                        <tr><td>Length</td><td class="mono">Light-year</td><td class="mono">9.46×10¹⁵ m</td><td>Interstellar</td></tr>
                        <tr><td>Mass</td><td class="mono">Atomic mass unit (u)</td><td class="mono">1.66054×10⁻²⁷ kg</td><td>Atomic/molecular</td></tr>
                        <tr><td>Pressure</td><td class="mono">Atmosphere (atm)</td><td class="mono">1.01325×10⁵ Pa</td><td>Atmospheric</td></tr>
                        <tr><td>Pressure</td><td class="mono">mm of Hg (torr)</td><td class="mono">133.322 Pa</td><td>Blood pressure, vacuum</td></tr>
                        <tr><td>Energy</td><td class="mono">Electronvolt (eV)</td><td class="mono">1.602×10⁻¹⁹ J</td><td>Atomic &amp; particle physics</td></tr>
                    </tbody>
                </table>
            </div>
            <div class="ref-card">
                <h3>4. Dimensional analysis (summary)</h3>
                <table class="ref-table" aria-label="Dimensional analysis">
                    <thead><tr><th>Purpose</th><th>Method</th></tr></thead>
                    <tbody>
                        <tr><td>Check correctness</td><td>Both sides of equation must have same dimensions</td></tr>
                        <tr><td>Derive relation</td><td>Assume quantity ∝ product of powers of base quantities</td></tr>
                        <tr><td>Convert units</td><td>Use conversion factors (1 unit = x another)</td></tr>
                        <tr><td>Limitations</td><td>Cannot find dimensionless constants, trig or exponential</td></tr>
                    </tbody>
                </table>
                <p style="padding: 1rem; margin: 0; color: var(--text-secondary); font-size: 0.9rem;"><strong>Dimensionless:</strong> coefficient of friction (μ), Reynolds number (Re), Mach number, refractive index (n), Poisson's ratio (ν), angle (radian), strain.</p>
            </div>
        </div>

        <div class="edu-content">
            <h2>About units and measurement</h2>
            <p>The <strong>SI</strong> has seven base quantities; all others are derived. <strong>Dimensional analysis</strong> checks that equations are dimensionally consistent and helps convert units. <strong>Significant figures</strong> reflect precision: in multiplication/division use the least number of sig figs; in addition/subtraction use the least decimal places. <strong>Order of magnitude</strong> is the power of 10 when the quantity is written in scientific notation (e.g. 450 → 4.5×10² → order 2).</p>
            <h3>Sig fig rules (short)</h3>
            <p>Non-zero digits are significant; zeros between non-zero digits are significant; leading zeros are not; trailing zeros after a decimal are significant; trailing zeros in a whole number without a decimal can be ambiguous. Use scientific notation (e.g. 1.200×10³) to show four significant figures.</p>
        </div>
    </main>

    <footer class="tool-page-footer" style="background: var(--surface-1); border-top: 1px solid var(--border-light); padding: 2rem; text-align: center; margin-top: 2rem;">
        <div class="tool-page-footer-inner"><p style="color: var(--text-secondary); margin: 0;">&copy; 2025 8gwifi.org. All rights reserved.</p></div>
    </footer>
    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/physics/js/units-measurement.js?v=<%=cacheVersion%>"></script>
</body>
</html>
