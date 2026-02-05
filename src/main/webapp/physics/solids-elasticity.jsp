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
        <jsp:param name="toolName" value="Solids Elasticity - Stress, Strain, Young's Modulus, Bulk & Shear Modulus" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Solids elasticity formulas: stress (σ = F/A), strain (ε = ΔL/L₀), Young's modulus (Y), bulk modulus (B), shear modulus (G), Poisson's ratio (ν), elastic potential energy. Free calculators with Matter.js spring animations." />
        <jsp:param name="toolUrl" value="physics/solids-elasticity.jsp" />
        <jsp:param name="toolKeywords" value="elasticity, stress strain, Young's modulus, bulk modulus, shear modulus, Poisson ratio, elastic potential energy, Hooke's law, physics elasticity, JEE NEET" />
        <jsp:param name="toolImage" value="solids-elasticity.png" />
        <jsp:param name="toolFeatures" value="Stress calculator,Strain calculator,Young's modulus calculator,Bulk modulus calculator,Shear modulus calculator,Poisson ratio calculator,Elastic energy calculator,Matter.js spring animations,Step-by-step solutions,SI units (Pa, N/m²)" />
        <jsp:param name="faq1q" value="What is stress and strain?" />
        <jsp:param name="faq1a" value="Stress (σ) = Force per unit area (F/A) in Pa. Strain (ε) = fractional change in length (ΔL/L₀), dimensionless. Stress causes strain in elastic materials." />
        <jsp:param name="faq2q" value="What is Young's modulus?" />
        <jsp:param name="faq2a" value="Young's modulus (Y) = stress/strain = (F/A)/(ΔL/L₀) for longitudinal deformation. It measures stiffness: higher Y means stiffer material. Units: Pa (N/m²)." />
        <jsp:param name="faq3q" value="What is Poisson's ratio?" />
        <jsp:param name="faq3a" value="Poisson's ratio (ν) = -lateral strain/longitudinal strain. When stretched, materials contract laterally. Typical range: 0.2–0.5. Rubber: ~0.5 (incompressible), cork: ~0 (no lateral contraction)." />
        <jsp:param name="faq4q" value="What is elastic potential energy?" />
        <jsp:param name="faq4a" value="Elastic potential energy U = ½ Y A (ΔL)²/L₀ = ½ stress × strain × volume. Energy stored when material is deformed elastically. Released when deformation is removed." />
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
        :root { --elastic-blue: #3b82f6; --elastic-indigo: #6366f1; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #3b82f6 0%, #6366f1 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(59,130,246,0.1), rgba(99,102,241,0.1)); border-left: 4px solid var(--elastic-blue); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #3b82f6, #6366f1); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .elastic-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .elastic-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .elastic-tab:hover { border-color: var(--elastic-blue); color: var(--elastic-blue); }
        .elastic-tab.active { background: linear-gradient(135deg, #3b82f6, #6366f1); border-color: #6366f1; color: white; }
        .elastic-panel { display: none; }
        .elastic-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--elastic-blue); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #3b82f6, #6366f1); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(59,130,246,0.15), rgba(99,102,241,0.1)); border: 2px solid var(--elastic-blue); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--elastic-blue); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #3b82f6, #6366f1); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--elastic-blue); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(59,130,246,0.1), rgba(99,102,241,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .elastic-viz-container { position: relative; width: 100%; height: 300px; background: linear-gradient(180deg, #dbeafe 0%, #bfdbfe 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .elastic-viz-container, .dark-mode .elastic-viz-container { background: linear-gradient(180deg, #1e3a8a 0%, #1e40af 100%); }
        .elastic-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .elastic-viz-pills { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; }
        .elastic-viz-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-md); }
        [data-theme="dark"] .elastic-viz-pill, .dark-mode .elastic-viz-pill { background: rgba(30,41,59,0.95); }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #3b82f6, #6366f1); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--elastic-blue); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--elastic-blue); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #3b82f6; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--elastic-blue); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #059669; font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: #059669; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--elastic-blue); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } .elastic-viz-container { height: 250px; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🔩</span> Solids – Elasticity</h1>
            <p class="tool-page-description">Stress, strain, Young's modulus, bulk modulus, shear modulus, Poisson's ratio, elastic energy</p>
            <div class="tool-badges">
                <span class="tool-badge">σ = F/A</span>
                <span class="tool-badge">Y = stress/strain</span>
                <span class="tool-badge">Poisson's ratio</span>
                <span class="tool-badge">Elastic energy</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Elasticity</div>
            <p>Elasticity describes how materials deform under stress and return to original shape when stress is removed. Stress (σ) = force per area. Strain (ε) = fractional deformation. Elastic moduli relate stress to strain. Beyond elastic limit, permanent deformation occurs.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Elasticity calculators</h2>
                    <p>Stress, strain, moduli, Poisson ratio, energy</p>
                </div>
                <div class="panel-body">
                    <div class="elastic-tabs">
                        <button type="button" class="elastic-tab active" data-tab="stress" onclick="if(window.switchElasticTab)window.switchElasticTab('stress',this);">Stress</button>
                        <button type="button" class="elastic-tab" data-tab="strain" onclick="if(window.switchElasticTab)window.switchElasticTab('strain',this);">Strain</button>
                        <button type="button" class="elastic-tab" data-tab="young" onclick="if(window.switchElasticTab)window.switchElasticTab('young',this);">Young's</button>
                        <button type="button" class="elastic-tab" data-tab="bulk" onclick="if(window.switchElasticTab)window.switchElasticTab('bulk',this);">Bulk</button>
                        <button type="button" class="elastic-tab" data-tab="shear" onclick="if(window.switchElasticTab)window.switchElasticTab('shear',this);">Shear</button>
                        <button type="button" class="elastic-tab" data-tab="poisson" onclick="if(window.switchElasticTab)window.switchElasticTab('poisson',this);">Poisson</button>
                        <button type="button" class="elastic-tab" data-tab="energy" onclick="if(window.switchElasticTab)window.switchElasticTab('energy',this);">Energy</button>
                    </div>

                    <div id="panel-stress" class="elastic-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Force (F)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="stress-f" class="number-input" value="1000" min="0" step="any">
                                <select id="stress-f-unit" class="unit-select">
                                    <option value="N">N</option>
                                    <option value="kN">kN</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area (A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="stress-a" class="number-input" value="0.001" min="0" step="any">
                                <select id="stress-a-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                    <option value="mm²">mm²</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElasticity()">Calculate Stress</button>
                        <div class="result-card" id="result-stress">
                            <div class="result-label">Stress</div>
                            <div class="result-value" id="stress-result">1.00 MPa</div>
                        </div>
                    </div>

                    <div id="panel-strain" class="elastic-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Change in length (ΔL)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="strain-dl" class="number-input" value="0.001" min="0" step="any">
                                <select id="strain-dl-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Original length (L₀)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="strain-l0" class="number-input" value="1" min="0" step="any">
                                <select id="strain-l0-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElasticity()">Calculate Strain</button>
                        <div class="result-card" id="result-strain">
                            <div class="result-label">Strain</div>
                            <div class="result-value" id="strain-result">0.001</div>
                        </div>
                    </div>

                    <div id="panel-young" class="elastic-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Force (F)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="young-f" class="number-input" value="1000" min="0" step="any">
                                <select id="young-f-unit" class="unit-select">
                                    <option value="N">N</option>
                                    <option value="kN">kN</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area (A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="young-a" class="number-input" value="0.001" min="0" step="any">
                                <select id="young-a-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Change in length (ΔL)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="young-dl" class="number-input" value="0.001" min="0" step="any">
                                <select id="young-dl-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Original length (L₀)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="young-l0" class="number-input" value="1" min="0" step="any">
                                <select id="young-l0-unit" class="unit-select">
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElasticity()">Calculate Young's Modulus</button>
                        <div class="result-card" id="result-young">
                            <div class="result-label">Young's Modulus</div>
                            <div class="result-value" id="young-result">1.00 GPa</div>
                        </div>
                    </div>

                    <div id="panel-bulk" class="elastic-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Pressure change (ΔP)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bulk-dp" class="number-input" value="100000" min="0" step="any">
                                <select id="bulk-dp-unit" class="unit-select">
                                    <option value="Pa">Pa</option>
                                    <option value="kPa">kPa</option>
                                    <option value="MPa">MPa</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Volume change (ΔV)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bulk-dv" class="number-input" value="0.0001" min="0" step="any">
                                <select id="bulk-dv-unit" class="unit-select">
                                    <option value="m³">m³</option>
                                    <option value="cm³">cm³</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Original volume (V₀)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="bulk-v0" class="number-input" value="1" min="0" step="any">
                                <select id="bulk-v0-unit" class="unit-select">
                                    <option value="m³">m³</option>
                                    <option value="cm³">cm³</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElasticity()">Calculate Bulk Modulus</button>
                        <div class="result-card" id="result-bulk">
                            <div class="result-label">Bulk Modulus</div>
                            <div class="result-value" id="bulk-result">1.00 GPa</div>
                        </div>
                    </div>

                    <div id="panel-shear" class="elastic-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Force (F)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="shear-f" class="number-input" value="1000" min="0" step="any">
                                <select id="shear-f-unit" class="unit-select">
                                    <option value="N">N</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area (A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="shear-a" class="number-input" value="0.001" min="0" step="any">
                                <select id="shear-a-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Shear displacement (Δx)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="shear-dx" class="number-input" value="0.001" min="0" step="any">
                                <select id="shear-dx-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Length (L)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="shear-l" class="number-input" value="1" min="0" step="any">
                                <select id="shear-l-unit" class="unit-select">
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElasticity()">Calculate Shear Modulus</button>
                        <div class="result-card" id="result-shear">
                            <div class="result-label">Shear Modulus</div>
                            <div class="result-value" id="shear-result">1.00 GPa</div>
                        </div>
                    </div>

                    <div id="panel-poisson" class="elastic-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Lateral change (Δd)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="poisson-dd" class="number-input" value="0.0002" min="0" step="any">
                                <select id="poisson-dd-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Original diameter (d₀)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="poisson-d0" class="number-input" value="0.01" min="0" step="any">
                                <select id="poisson-d0-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Longitudinal change (ΔL)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="poisson-dl" class="number-input" value="0.001" min="0" step="any">
                                <select id="poisson-dl-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Original length (L₀)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="poisson-l0" class="number-input" value="1" min="0" step="any">
                                <select id="poisson-l0-unit" class="unit-select">
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElasticity()">Calculate Poisson's Ratio</button>
                        <div class="result-card" id="result-poisson">
                            <div class="result-label">Poisson's Ratio</div>
                            <div class="result-value" id="poisson-result">0.20</div>
                        </div>
                    </div>

                    <div id="panel-energy" class="elastic-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Young's modulus (Y)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-y" class="number-input" value="200000000000" min="0" step="any">
                                <select id="energy-y-unit" class="unit-select">
                                    <option value="Pa">Pa</option>
                                    <option value="GPa">GPa</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Area (A)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-a" class="number-input" value="0.001" min="0" step="any">
                                <select id="energy-a-unit" class="unit-select">
                                    <option value="m²">m²</option>
                                    <option value="cm²">cm²</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Change in length (ΔL)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-dl" class="number-input" value="0.001" min="0" step="any">
                                <select id="energy-dl-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="mm">mm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Original length (L₀)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="energy-l0" class="number-input" value="1" min="0" step="any">
                                <select id="energy-l0-unit" class="unit-select">
                                    <option value="m">m</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runElasticity()">Calculate Elastic Energy</button>
                        <div class="result-card" id="result-energy">
                            <div class="result-label">Elastic Energy</div>
                            <div class="result-value" id="energy-result">0.10 J</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>🔩 Elasticity visualization</h3></div>
                    <div class="elastic-viz-container" id="elastic-viz-container">
                        <canvas class="elastic-viz-canvas" id="elastic-viz-canvas"></canvas>
                        <div class="elastic-viz-pills" id="elastic-viz-pills"></div>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleElasticSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="elastic-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="elastic-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Solids elasticity formulas">
                        <thead>
                            <tr>
                                <th>Concept</th>
                                <th>Formula</th>
                                <th>Notes / Units / Conditions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Stress</td>
                                <td class="form-equation">σ = F / A</td>
                                <td class="form-desc">N/m² or Pascal (Pa)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Strain (longitudinal)</td>
                                <td class="form-equation">ε = ΔL / L₀</td>
                                <td class="form-desc">Dimensionless</td>
                            </tr>
                            <tr>
                                <td class="form-name">Strain (volumetric)</td>
                                <td class="form-equation">ε_v = ΔV / V₀</td>
                                <td class="form-desc">Dimensionless</td>
                            </tr>
                            <tr>
                                <td class="form-name">Strain (shear)</td>
                                <td class="form-equation">γ = Δx / L or tan θ ≈ θ</td>
                                <td class="form-desc">Dimensionless (small angle)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Young's Modulus</td>
                                <td class="form-equation">Y = (F/A) / (ΔL/L₀)</td>
                                <td class="form-desc">For wires, rods (elastic)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Bulk Modulus</td>
                                <td class="form-equation">B = -P / (ΔV/V₀)</td>
                                <td class="form-desc">Negative sign → volume decrease</td>
                            </tr>
                            <tr>
                                <td class="form-name">Rigidity / Shear Modulus</td>
                                <td class="form-equation">G or η = (F/A) / γ</td>
                                <td class="form-desc">For twisting, shearing</td>
                            </tr>
                            <tr>
                                <td class="form-name">Poisson's Ratio</td>
                                <td class="form-equation">ν = - (Δd/d₀) / (ΔL/L₀)</td>
                                <td class="form-desc">Usually 0.2–0.5; negative sign for convention</td>
                            </tr>
                            <tr>
                                <td class="form-name">Elastic Potential Energy</td>
                                <td class="form-equation">U = ½ Y A (ΔL)² / L₀</td>
                                <td class="form-desc">Energy stored in deformed solid</td>
                            </tr>
                            <tr>
                                <td class="form-name">Relation between moduli</td>
                                <td class="form-equation">Y = 2G(1 + ν)<br>Y = 3B(1 − 2ν)</td>
                                <td class="form-desc">Important relations</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About Elasticity</h2>
            <p>Elasticity describes how materials deform under applied forces and return to their original shape when forces are removed. The key concepts are stress (force per unit area) and strain (fractional deformation).</p>
            
            <h3>Stress and Strain</h3>
            <p><strong>Stress (σ)</strong> = Force per unit area = F/A. Units: Pascal (Pa = N/m²). Stress causes deformation.</p>
            <p><strong>Strain (ε)</strong> = Fractional change in dimension = ΔL/L₀ (longitudinal) or ΔV/V₀ (volumetric). Strain is dimensionless.</p>
            
            <h3>Elastic Moduli</h3>
            <p><strong>Young's modulus (Y)</strong> = stress/strain for longitudinal deformation. Measures stiffness: higher Y = stiffer material. Steel: ~200 GPa, rubber: ~0.01 GPa.</p>
            <p><strong>Bulk modulus (B)</strong> = -pressure/volumetric strain. Measures resistance to volume change. Water: ~2.2 GPa, steel: ~160 GPa.</p>
            <p><strong>Shear modulus (G)</strong> = shear stress/shear strain. Measures resistance to shape change (twisting, shearing).</p>
            
            <h3>Poisson's Ratio</h3>
            <p><strong>Poisson's ratio (ν)</strong> = -lateral strain/longitudinal strain. When stretched, materials contract laterally. Typical range: 0.2–0.5. Rubber: ~0.5 (nearly incompressible), cork: ~0 (no lateral contraction).</p>
            
            <h3>Elastic Limit and Plastic Deformation</h3>
            <p>Below the elastic limit, deformation is reversible. Beyond it, permanent (plastic) deformation occurs. The stress-strain curve shows: elastic limit → yield point → ultimate stress → breaking stress.</p>
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
    <script src="https://cdn.jsdelivr.net/npm/matter-js@0.19.0/build/matter.min.js" crossorigin="anonymous"></script>
    <script src="<%=request.getContextPath()%>/physics/js/solids-elasticity.js?v=<%=cacheVersion%>"></script>
</body>
</html>
