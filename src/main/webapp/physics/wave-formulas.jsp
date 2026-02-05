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
        <jsp:param name="toolName" value="Wave Formulas - v = fλ, Standing Waves, Doppler Effect, Sound & EM Waves" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription" value="Complete wave formulas: basic parameters (v = fλ), transverse waves (string speed), longitudinal waves (sound speed), standing waves (strings, pipes), interference, beats, Doppler effect, and electromagnetic waves. Free calculators with Matter.js animations." />
        <jsp:param name="toolUrl" value="physics/wave-formulas.jsp" />
        <jsp:param name="toolKeywords" value="wave formulas, v f lambda, standing waves, Doppler effect, sound waves, electromagnetic waves, interference, beats frequency, physics waves, JEE NEET waves" />
        <jsp:param name="toolImage" value="wave-formulas.png" />
        <jsp:param name="toolFeatures" value="Wave speed calculator,Standing wave calculator,Sound speed calculator,Doppler effect calculator,Interference calculator,Beats frequency calculator,EM wave calculator,Matter.js wave animations,Step-by-step solutions,Chart.js wave graphs,SI units" />
        <jsp:param name="faq1q" value="What is the fundamental wave equation?" />
        <jsp:param name="faq1a" value="Wave speed v = f λ, where f is frequency (Hz) and λ is wavelength (m). Also v = λ / T, where T is period (s). This is the core relation for all waves." />
        <jsp:param name="faq2q" value="What are standing waves?" />
        <jsp:param name="faq2a" value="Standing waves form when two waves of same frequency travel in opposite directions. For a string fixed at both ends: λ_n = 2L/n, f_n = nv/(2L), where n = 1,2,3... (fundamental and harmonics)." />
        <jsp:param name="faq3q" value="What is the Doppler effect?" />
        <jsp:param name="faq3a" value="Doppler effect: f' = f (v ± v_observer) / (v ± v_source), where v is wave speed. Source moving toward observer increases frequency; moving away decreases it." />
        <jsp:param name="faq4q" value="How do you calculate beats frequency?" />
        <jsp:param name="faq4a" value="Beats frequency f_beat = |f₁ − f₂|, the absolute difference between two frequencies. Beats occur when two waves of slightly different frequencies interfere." />
        <jsp:param name="faq5q" value="What is the speed of sound in air?" />
        <jsp:param name="faq5a" value="Speed of sound in gas v = √(γRT/M), where γ is adiabatic index (1.4 for air), R is gas constant, T is temperature (K), and M is molar mass. At room temperature (~300K), v ≈ 343 m/s." />
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
        :root { --wave-indigo: #6366f1; --wave-purple: #8b5cf6; --wave-pink: #ec4899; --surface-1: #fff; --surface-2: #f8fafc; --surface-3: #f1f5f9; --text-primary: #0f172a; --text-secondary: #475569; --border-light: #e2e8f0; --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        [data-theme="dark"], .dark-mode { --surface-1: #1e293b; --surface-2: #0f172a; --surface-3: #334155; --text-primary: #f1f5f9; --text-secondary: #cbd5e1; --border-light: #334155; }
        body { font-family: 'Inter', sans-serif; background: var(--surface-2); margin: 0; }
        .tool-header { background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%); padding: 1.25rem 1.5rem; margin-top: 72px; }
        .tool-header-container { max-width: 1400px; margin: 0 auto; }
        .tool-page-title { margin: 0; font-size: 1.75rem; font-weight: 700; color: white; display: flex; align-items: center; gap: 0.75rem; }
        .tool-page-description { color: rgba(255,255,255,0.9); margin: 0.5rem 0 0; font-size: 1rem; }
        .tool-badges { display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap; }
        .tool-badge { background: rgba(255,255,255,0.2); color: white; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .edu-container { max-width: 1400px; margin: 0 auto; padding: 2rem 1rem; }
        .edu-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
        @media (min-width: 1024px) { .edu-grid { grid-template-columns: 380px 1fr; gap: 2rem; } }
        .info-box { background: linear-gradient(135deg, rgba(99,102,241,0.1), rgba(139,92,246,0.1)); border-left: 4px solid var(--wave-indigo); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; }
        .info-box-title { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
        .info-box p { margin: 0; color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .control-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); }
        .panel-header { background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; padding: 1.25rem 1.5rem; }
        .panel-header h2 { margin: 0; font-size: 1.25rem; font-weight: 700; }
        .panel-header p { margin: 0.25rem 0 0; opacity: 0.9; font-size: 0.875rem; }
        .panel-body { padding: 1.5rem; }
        .wave-tabs { display: flex; gap: 0.25rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .wave-tab { padding: 0.5rem 0.75rem; background: var(--surface-2); border: 2px solid var(--border-light); border-radius: 8px; font-size: 0.75rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; transition: all 0.2s; }
        .wave-tab:hover { border-color: var(--wave-indigo); color: var(--wave-indigo); }
        .wave-tab.active { background: linear-gradient(135deg, #6366f1, #8b5cf6); border-color: #8b5cf6; color: white; }
        .wave-panel { display: none; }
        .wave-panel.active { display: block; }
        .input-section { margin-bottom: 1.25rem; }
        .input-label { display: flex; align-items: center; gap: 0.5rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; font-size: 0.9rem; }
        .input-with-unit { display: flex; gap: 0; }
        .number-input { flex: 1; padding: 0.75rem 1rem; border: 2px solid var(--border-light); border-radius: 10px 0 0 10px; font-size: 1rem; font-family: 'JetBrains Mono', monospace; background: var(--surface-1); color: var(--text-primary); }
        .number-input:focus { outline: none; border-color: var(--wave-indigo); }
        .unit-select { padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-left: none; border-radius: 0 10px 10px 0; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); cursor: pointer; min-width: 70px; }
        .calc-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: var(--shadow-md); }
        .calc-btn:hover { transform: translateY(-2px); }
        .result-card { background: linear-gradient(135deg, rgba(99,102,241,0.15), rgba(139,92,246,0.1)); border: 2px solid var(--wave-indigo); border-radius: 12px; padding: 1.25rem; margin-top: 1rem; text-align: center; }
        .result-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary); margin-bottom: 0.25rem; }
        .result-value { font-size: 1.5rem; font-weight: 800; font-family: 'JetBrains Mono', monospace; color: var(--wave-indigo); }
        .formula-table-wrap { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); border: 1px solid var(--border-light); overflow: hidden; margin-bottom: 2rem; }
        .formula-table { width: 100%; border-collapse: collapse; }
        .formula-table th, .formula-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid var(--border-light); }
        .formula-table thead th { background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; font-weight: 700; font-size: 0.9rem; }
        .formula-table tbody tr:last-child td { border-bottom: none; }
        .formula-table tbody tr:hover { background: var(--surface-2); }
        .formula-table .form-name { font-weight: 700; color: var(--text-primary); }
        .formula-table .form-equation { font-family: 'JetBrains Mono', monospace; font-size: 1.05rem; font-weight: 700; color: var(--wave-indigo); }
        .formula-table .form-desc { color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; }
        .simulation-panel { background: var(--surface-1); border-radius: 16px; box-shadow: var(--shadow-md); overflow: hidden; border: 1px solid var(--border-light); margin-bottom: 1.5rem; }
        .simulation-header { background: linear-gradient(135deg, rgba(99,102,241,0.1), rgba(139,92,246,0.05)); padding: 1rem 1.25rem; border-bottom: 1px solid var(--border-light); }
        .simulation-header h3 { margin: 0; font-size: 1rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem; }
        .wave-viz-container { position: relative; width: 100%; height: 300px; background: linear-gradient(180deg, #eef2ff 0%, #e0e7ff 100%); margin: 1rem; border-radius: 12px; overflow: hidden; border: 2px solid var(--border-light); }
        [data-theme="dark"] .wave-viz-container, .dark-mode .wave-viz-container { background: linear-gradient(180deg, #312e81 0%, #4c1d95 100%); }
        .wave-viz-canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .wave-viz-pills { position: absolute; bottom: 10px; left: 10px; right: 10px; display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; }
        .wave-viz-pill { background: rgba(255,255,255,0.95); padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); box-shadow: var(--shadow-md); }
        [data-theme="dark"] .wave-viz-pill, .dark-mode .wave-viz-pill { background: rgba(30,41,59,0.95); }
        .wave-chart-wrap { height: 200px; margin: 1rem; padding: 0 0.5rem; }
        .steps-section { margin: 1rem; background: var(--surface-2); border-radius: 12px; border: 1px solid var(--border-light); overflow: hidden; }
        .steps-header { background: linear-gradient(135deg, #6366f1, #7c3aed); color: white; padding: 0.75rem 1rem; font-weight: 700; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; }
        .steps-toggle { margin-left: auto; font-size: 0.8rem; opacity: 0.8; }
        .steps-body { padding: 1rem; max-height: 360px; overflow-y: auto; }
        .steps-body.collapsed { display: none; }
        .step-item { background: var(--surface-1); border-radius: 10px; padding: 1rem; margin-bottom: 0.75rem; border-left: 4px solid var(--wave-indigo); }
        .step-item:last-child { margin-bottom: 0; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; background: var(--wave-indigo); color: white; border-radius: 50%; font-size: 0.75rem; font-weight: 700; margin-right: 0.5rem; }
        .step-title { font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; display: flex; align-items: center; }
        .step-formula { background: var(--surface-2); padding: 0.75rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.9rem; color: #6366f1; margin: 0.5rem 0; }
        .step-calc { font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.8; }
        .step-calc .highlight { color: var(--wave-indigo); font-weight: 700; }
        .step-result-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; color: #059669; font-weight: 600; }
        .step-result-value { font-family: 'JetBrains Mono', monospace; font-size: 1rem; font-weight: 700; color: #059669; }
        .edu-content { background: var(--surface-1); border-radius: 16px; padding: 2rem; margin-top: 2rem; border: 1px solid var(--border-light); }
        .edu-content h2 { color: var(--text-primary); margin: 0 0 1rem; font-size: 1.5rem; }
        .edu-content h3 { color: var(--text-primary); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .edu-content p, .edu-content li { color: var(--text-secondary); line-height: 1.7; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; color: var(--wave-indigo); font-weight: 600; text-decoration: none; margin-bottom: 1rem; }
        .back-link:hover { text-decoration: underline; }
        @media (max-width: 768px) { .tool-page-title { font-size: 1.25rem; } .formula-table th, .formula-table td { padding: 0.75rem; font-size: 0.85rem; } .formula-table .form-equation { font-size: 0.9rem; } .wave-viz-container { height: 250px; } }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title"><span>🌊</span> Wave Formulas</h1>
            <p class="tool-page-description">v = fλ, standing waves, Doppler effect, sound &amp; EM waves, interference</p>
            <div class="tool-badges">
                <span class="tool-badge">v = f λ</span>
                <span class="tool-badge">Standing</span>
                <span class="tool-badge">Doppler</span>
                <span class="tool-badge">Beats</span>
            </div>
        </div>
    </header>

    <main class="edu-container">
        <a href="<%=request.getContextPath()%>/physics/index.jsp" class="back-link">← Physics Tools</a>

        <div class="info-box">
            <div class="info-box-title"><span>💡</span> Wave motion</div>
            <p>Waves transfer energy without transferring matter. Core relation: v = f λ. Standing waves form from interference. Doppler effect changes frequency due to relative motion. Beats occur from interference of slightly different frequencies.</p>
        </div>

        <div class="edu-grid">
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Wave calculators</h2>
                    <p>Basic, standing, sound, Doppler, interference, beats, EM</p>
                </div>
                <div class="panel-body">
                    <div class="wave-tabs">
                        <button type="button" class="wave-tab active" data-tab="basic" onclick="if(window.switchWaveTab)window.switchWaveTab('basic',this);">Basic</button>
                        <button type="button" class="wave-tab" data-tab="standing" onclick="if(window.switchWaveTab)window.switchWaveTab('standing',this);">Standing</button>
                        <button type="button" class="wave-tab" data-tab="sound" onclick="if(window.switchWaveTab)window.switchWaveTab('sound',this);">Sound</button>
                        <button type="button" class="wave-tab" data-tab="doppler" onclick="if(window.switchWaveTab)window.switchWaveTab('doppler',this);">Doppler</button>
                        <button type="button" class="wave-tab" data-tab="interference" onclick="if(window.switchWaveTab)window.switchWaveTab('interference',this);">Interference</button>
                        <button type="button" class="wave-tab" data-tab="beats" onclick="if(window.switchWaveTab)window.switchWaveTab('beats',this);">Beats</button>
                        <button type="button" class="wave-tab" data-tab="em" onclick="if(window.switchWaveTab)window.switchWaveTab('em',this);">EM Waves</button>
                    </div>

                    <div id="panel-basic" class="wave-panel active">
                        <div class="input-section">
                            <div class="input-label"><span>Frequency (f)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="basic-f" class="number-input" value="440" min="0" step="any">
                                <select id="basic-f-unit" class="unit-select">
                                    <option value="Hz">Hz</option>
                                    <option value="kHz">kHz</option>
                                    <option value="MHz">MHz</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Wavelength (λ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="basic-lambda" class="number-input" value="0.78" min="0" step="any">
                                <select id="basic-lambda-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                    <option value="nm">nm</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runWaveFormulas()">Calculate Speed</button>
                        <div class="result-card" id="result-basic">
                            <div class="result-label">Wave speed</div>
                            <div class="result-value" id="basic-v">343 m/s</div>
                        </div>
                    </div>

                    <div id="panel-standing" class="wave-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Length (L)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="stand-l" class="number-input" value="1" min="0" step="any">
                                <select id="stand-l-unit" class="unit-select">
                                    <option value="m">m</option>
                                    <option value="cm">cm</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Harmonic (n)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="stand-n" class="number-input" value="1" min="1" step="1">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-radius: 0 10px 10px 0; font-size: 0.85rem;">(1,2,3...)</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Wave speed (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="stand-v" class="number-input" value="343" min="0" step="any">
                                <select id="stand-v-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runWaveFormulas()">Calculate</button>
                        <div class="result-card" id="result-standing">
                            <div class="result-label">Wavelength &amp; Frequency</div>
                            <div class="result-value" id="stand-result">λ = 2.0 m, f = 171.5 Hz</div>
                        </div>
                    </div>

                    <div id="panel-sound" class="wave-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Temperature (T)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="sound-t" class="number-input" value="20" min="0" step="any">
                                <select id="sound-t-unit" class="unit-select">
                                    <option value="°C">°C</option>
                                    <option value="K">K</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runWaveFormulas()">Calculate Speed</button>
                        <div class="result-card" id="result-sound">
                            <div class="result-label">Sound speed (air)</div>
                            <div class="result-value" id="sound-v">343 m/s</div>
                        </div>
                    </div>

                    <div id="panel-doppler" class="wave-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Source frequency (f)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="dop-f" class="number-input" value="440" min="0" step="any">
                                <select id="dop-f-unit" class="unit-select">
                                    <option value="Hz">Hz</option>
                                    <option value="kHz">kHz</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Wave speed (v)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="dop-v" class="number-input" value="343" min="0" step="any">
                                <select id="dop-v-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Source speed (v_s)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="dop-vs" class="number-input" value="0" step="any">
                                <select id="dop-vs-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                    <option value="km/h">km/h</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Observer speed (v_o)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="dop-vo" class="number-input" value="0" step="any">
                                <select id="dop-vo-unit" class="unit-select">
                                    <option value="m/s">m/s</option>
                                    <option value="km/h">km/h</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Source toward observer?</span></div>
                            <select id="dop-vs-dir" class="number-input" style="border-radius: 10px;">
                                <option value="1">Yes (toward)</option>
                                <option value="-1">No (away)</option>
                            </select>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Observer toward source?</span></div>
                            <select id="dop-vo-dir" class="number-input" style="border-radius: 10px;">
                                <option value="1">Yes (toward)</option>
                                <option value="-1">No (away)</option>
                            </select>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runWaveFormulas()">Calculate</button>
                        <div class="result-card" id="result-doppler">
                            <div class="result-label">Observed frequency</div>
                            <div class="result-value" id="dop-fprime">440 Hz</div>
                        </div>
                    </div>

                    <div id="panel-interference" class="wave-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Amplitude 1 (A₁)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="int-a1" class="number-input" value="2" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-radius: 0 10px 10px 0; font-size: 0.85rem;">m</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Amplitude 2 (A₂)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="int-a2" class="number-input" value="2" min="0" step="any">
                                <span style="padding: 0.75rem; background: var(--surface-3); border: 2px solid var(--border-light); border-radius: 0 10px 10px 0; font-size: 0.85rem;">m</span>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Phase difference (δ)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="int-delta" class="number-input" value="0" step="any">
                                <select id="int-delta-unit" class="unit-select">
                                    <option value="rad">rad</option>
                                    <option value="deg">deg</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runWaveFormulas()">Calculate</button>
                        <div class="result-card" id="result-interference">
                            <div class="result-label">Resultant amplitude</div>
                            <div class="result-value" id="int-a">4.0 m</div>
                        </div>
                    </div>

                    <div id="panel-beats" class="wave-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Frequency 1 (f₁)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="beat-f1" class="number-input" value="440" min="0" step="any">
                                <select id="beat-f1-unit" class="unit-select">
                                    <option value="Hz">Hz</option>
                                    <option value="kHz">kHz</option>
                                </select>
                            </div>
                        </div>
                        <div class="input-section">
                            <div class="input-label"><span>Frequency 2 (f₂)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="beat-f2" class="number-input" value="442" min="0" step="any">
                                <select id="beat-f2-unit" class="unit-select">
                                    <option value="Hz">Hz</option>
                                    <option value="kHz">kHz</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runWaveFormulas()">Calculate</button>
                        <div class="result-card" id="result-beats">
                            <div class="result-label">Beats frequency</div>
                            <div class="result-value" id="beat-f">2 Hz</div>
                        </div>
                    </div>

                    <div id="panel-em" class="wave-panel">
                        <div class="input-section">
                            <div class="input-label"><span>Frequency (f)</span></div>
                            <div class="input-with-unit">
                                <input type="number" id="em-f" class="number-input" value="5e14" min="0" step="any">
                                <select id="em-f-unit" class="unit-select">
                                    <option value="Hz">Hz</option>
                                    <option value="THz">THz</option>
                                </select>
                            </div>
                        </div>
                        <button type="button" class="calc-btn" onclick="window.runWaveFormulas()">Calculate</button>
                        <div class="result-card" id="result-em">
                            <div class="result-label">Wavelength (vacuum)</div>
                            <div class="result-value" id="em-lambda">600 nm</div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="simulation-panel">
                    <div class="simulation-header"><h3>🌊 Wave visualization</h3></div>
                    <div class="wave-viz-container" id="wave-viz-container">
                        <canvas class="wave-viz-canvas" id="wave-viz-canvas"></canvas>
                        <div class="wave-viz-pills" id="wave-viz-pills"></div>
                    </div>
                    <div class="wave-chart-wrap" id="wave-chart-wrap" style="display:none;">
                        <canvas id="wave-chart-canvas"></canvas>
                    </div>
                </div>

                <div class="steps-section">
                    <div class="steps-header" onclick="window.toggleWaveSteps()"><span>🧮</span><span>Step-by-Step Solution</span><span class="steps-toggle" id="wave-steps-toggle">▼ Show</span></div>
                    <div class="steps-body collapsed" id="wave-steps-body"></div>
                </div>

                <div class="formula-table-wrap">
                    <table class="formula-table" aria-label="Wave formulas">
                        <thead>
                            <tr>
                                <th>Quantity</th>
                                <th>Formula / Relation</th>
                                <th>Notes / Units</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="form-name">Wave speed</td>
                                <td class="form-equation">v = f λ</td>
                                <td class="form-desc">Core relation</td>
                            </tr>
                            <tr>
                                <td class="form-name">Frequency</td>
                                <td class="form-equation">f = 1 / T</td>
                                <td class="form-desc">Hz (hertz)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Angular frequency</td>
                                <td class="form-equation">ω = 2π f</td>
                                <td class="form-desc">rad/s</td>
                            </tr>
                            <tr>
                                <td class="form-name">Wave number</td>
                                <td class="form-equation">k = 2π / λ</td>
                                <td class="form-desc">rad/m</td>
                            </tr>
                            <tr>
                                <td class="form-name">Traveling wave (right)</td>
                                <td class="form-equation">y = A sin(kx − ωt + φ₀)</td>
                                <td class="form-desc">Most common form</td>
                            </tr>
                            <tr>
                                <td class="form-name">Speed on string</td>
                                <td class="form-equation">v = √(T / μ)</td>
                                <td class="form-desc">T = tension, μ = mass/length</td>
                            </tr>
                            <tr>
                                <td class="form-name">Sound speed (gas)</td>
                                <td class="form-equation">v = √(γ R T / M)</td>
                                <td class="form-desc">γ = adiabatic index, M = molar mass</td>
                            </tr>
                            <tr>
                                <td class="form-name">Standing wave (string)</td>
                                <td class="form-equation">λₙ = 2L / n, fₙ = n v / (2L)</td>
                                <td class="form-desc">n = 1,2,3... (fundamental & harmonics)</td>
                            </tr>
                            <tr>
                                <td class="form-name">Resultant amplitude</td>
                                <td class="form-equation">A = √(A₁² + A₂² + 2 A₁ A₂ cos δ)</td>
                                <td class="form-desc">δ = phase difference</td>
                            </tr>
                            <tr>
                                <td class="form-name">Beats frequency</td>
                                <td class="form-equation">f_beat = |f₁ − f₂|</td>
                                <td class="form-desc">Absolute difference</td>
                            </tr>
                            <tr>
                                <td class="form-name">Doppler effect</td>
                                <td class="form-equation">f' = f (v ± v₀) / (v ± v_s)</td>
                                <td class="form-desc">+ if toward, − if away</td>
                            </tr>
                            <tr>
                                <td class="form-name">EM wave speed</td>
                                <td class="form-equation">c = 3 × 10⁸ m/s</td>
                                <td class="form-desc">Speed in vacuum</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="edu-content">
            <h2>About wave motion</h2>
            <p>Waves transfer energy without transferring matter. The fundamental relation is <strong>v = f λ</strong>, where v is wave speed, f is frequency, and λ is wavelength. Standing waves form when two waves of the same frequency interfere.</p>
            <h3>Standing waves</h3>
            <p>For a string fixed at both ends: <strong>λ_n = 2L/n</strong> and <strong>f_n = nv/(2L)</strong>, where n = 1,2,3... (fundamental and harmonics). Closed pipes have only odd harmonics; open pipes have all harmonics.</p>
            <h3>Doppler effect and interference</h3>
            <p>The Doppler effect changes observed frequency due to relative motion: <strong>f' = f (v ± v_observer) / (v ± v_source)</strong>. Beats occur when two waves of slightly different frequencies interfere: <strong>f_beat = |f₁ − f₂|</strong>.</p>
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/matter-js@0.19.0/build/matter.min.js" crossorigin="anonymous"></script>
    <script src="<%=request.getContextPath()%>/physics/js/wave-formulas.js?v=<%=cacheVersion%>"></script>
</body>
</html>
