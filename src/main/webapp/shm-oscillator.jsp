<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SHM Oscillator Calculator – Spring, Damped, Driven, Pendulum</title>
  <meta name="description" content="Simple Harmonic Motion (SHM) calculator and visualizer: spring (undamped/damped/driven) and pendulum (small/large angle). Solve f/T/ω, k–m–f, L–f–T, amplitude/energy, and see phase, energy, and animation with unit-aware outputs.">
  <meta name="keywords" content="simple harmonic motion calculator, SHM calculator, damped harmonic oscillator, driven oscillator, resonance calculator, pendulum calculator, spring constant calculator, phase space, physics simulation, energy plot">
  <link rel="canonical" href="https://8gwifi.org/shm-oscillator.jsp">
  <meta name="robots" content="index,follow">
  <meta property="og:title" content="SHM Oscillator Calculator – Spring, Damped, Driven, Pendulum">
  <meta property="og:description" content="Calculate and visualize SHM: spring, damped/driven, pendulum. Solve f/T/ω, k–m–f, L–f–T, amplitude/energy with unit-aware outputs.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/shm-oscillator.jsp">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="SHM Oscillator Calculator – Spring, Damped, Driven, Pendulum">
  <meta name="twitter:description" content="Calculate and visualize SHM with phase and energy plots. Damped/driven, small/large pendulum, unit-aware calculators.">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"WebApplication",
    "name":"SHM Oscillator Calculator",
    "url":"https://8gwifi.org/shm-oscillator.jsp",
    "applicationCategory":"EducationalApplication",
    "operatingSystem":"Web",
    "description":"Calculate and visualize simple harmonic motion for spring (undamped/damped/driven) and pendulum (small/large angle). Includes unit-aware calculators and interactive plots.",
    "offers":{"@type":"Offer","price":"0","priceCurrency":"USD"},
    "keywords":["simple harmonic motion calculator","damped harmonic oscillator","driven oscillator","pendulum calculator","spring constant calculator","resonance","phase space"]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"FAQPage",
    "mainEntity":[
      {"@type":"Question","name":"How do I calculate period, frequency, and angular frequency?","acceptedAnswer":{"@type":"Answer","text":"Use the converter: enter any one of f, T, or ω and the others are computed (T=1/f, ω=2πf). Units are supported (Hz, /min, rad/s)."}},
      {"@type":"Question","name":"How do spring parameters affect SHM?","acceptedAnswer":{"@type":"Answer","text":"The natural frequency is f₀=(1/2π)√(k/m). Use the spring calculator to solve for k, m, or f. Damping c sets the decay rate via ζ=c/(2√(km))."}},
      {"@type":"Question","name":"How do I explore resonance safely?","acceptedAnswer":{"@type":"Answer","text":"Pick Driven mode, set fd near f₀ and adjust c. Watch amplitude and phase on the Time/Phase tabs. Use presets like ‘Driven (near resonance)’ to start."}},
      {"@type":"Question","name":"What does the phase‑space plot show?","acceptedAnswer":{"@type":"Answer","text":"The v vs x plot reveals the system’s state: ellipses for undamped SHM, inward spirals for damping, and steady limit cycles under periodic drive."}},
      {"@type":"Question","name":"Does amplitude change the period?","acceptedAnswer":{"@type":"Answer","text":"No, not in ideal SHM (linear region). Period depends on k and m (spring) or L and g (pendulum). Large‑angle pendulums deviate slightly (longer period)."}},
      {"@type":"Question","name":"How do I get energy and amplitude?","acceptedAnswer":{"@type":"Answer","text":"Use the Amplitude & Energy mini‑calculator to solve for A, vmax, amax, or E. For large‑angle pendulum, energy uses E = m g L (1−cosθₘₐₓ)."}},
      {"@type":"Question","name":"What is Simple Harmonic Motion (SHM)?","acceptedAnswer":{"@type":"Answer","text":"SHM is motion where the restoring force is proportional to displacement and directed toward equilibrium (F = −kx). The solution is sinusoidal, x(t) = A cos(ωt + φ), with ω determined by system parameters. Common examples are a mass–spring system and a small‑angle pendulum."}}
    ]
  }
  </script>
  <style>#oscCanvas{width:100%;height:200px;border:1px solid #e5e7eb;border-radius:6px;background:#fff}.shm .card-header{padding:.6rem .9rem;font-weight:600}.shm .card-body{padding:.7rem .9rem}
    .shm-edu-grid{display:grid;gap:.75rem;margin-bottom:.75rem}
    @media (min-width:768px){.shm-edu-grid{grid-template-columns:repeat(3,1fr)}}
    .shm-edu-card{border-radius:8px;border-left:4px solid;padding:.75rem .9rem;background:#fff;box-shadow:0 1px 3px rgba(15,23,42,0.08);color:#0f172a}
    .shm-edu-card h6{font-size:.95rem;font-weight:600;margin-bottom:.35rem}
    .shm-edu-card p{margin-bottom:.35rem;font-size:.9rem}
    .shm-edu-card ul{padding-left:1rem;margin-bottom:0;font-size:.88rem}
    .shm-edu-card ul li{margin-bottom:.25rem}
    .shm-edu-card--concept{background:#fef9c3;border-left-color:#facc15}
    .shm-edu-card--investigate{background:#ecfeff;border-left-color:#0ea5e9}
    .shm-edu-card--alert{background:#f0fdf4;border-left-color:#22c55e}
    .shm-faq-item + .shm-faq-item{margin-top:.75rem}
    .shm-faq-item strong{color:#0f172a}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 shm">
  <h1 class="mb-2">Simple Harmonic Motion Oscillator</h1>
  <p class="text-muted mb-3">Visualize SHM for a spring or a small-angle pendulum. Graphs for position and velocity over time.</p>
  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3"><h5 class="card-header">Inputs</h5><div class="card-body">
        <div class="d-flex justify-content-between align-items-center mb-2">
          <ul class="nav nav-pills" id="modeTabs">
            <li class="nav-item"><a class="nav-link active" href="#" data-mode="spring">Spring</a></li>
            <li class="nav-item"><a class="nav-link" href="#" data-mode="spring-damped">Damped</a></li>
            <li class="nav-item"><a class="nav-link" href="#" data-mode="spring-driven">Driven</a></li>
            <li class="nav-item"><a class="nav-link" href="#" data-mode="pendulum">Pendulum</a></li>
            <li class="nav-item"><a class="nav-link" href="#" data-mode="pendulum-large">Large Pendulum</a></li>
          </ul>
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" id="autoRun" checked>
            <label class="form-check-label small" for="autoRun">Auto</label>
          </div>
        </div>
        <div id="derivedChips" class="mb-2">
          <span class="badge badge-secondary mr-1">T: <span id="chip_T">–</span></span>
          <span class="badge badge-secondary mr-1">ω: <span id="chip_w">–</span></span>
          <span class="badge badge-secondary">f₀: <span id="chip_f0">–</span> Hz</span>
        </div>
        <div class="form-group"><label for="mode">Mode</label>
          <select id="mode" class="form-control">
            <option value="spring" selected>Spring (undamped)</option>
            <option value="spring-damped">Spring (damped)</option>
            <option value="spring-driven">Spring (driven)</option>
            <option value="pendulum">Pendulum (small angle)</option>
            <option value="pendulum-large">Pendulum (large angle)</option>
          </select>
        </div>
        <div class="form-group form-inline" id="grpA">
          <label for="A" class="mr-2 mb-0">Amplitude A</label>
          <input id="A" type="number" step="0.001" class="form-control mr-2" style="max-width:160px" value="0.1">
          <select id="A_unit" class="form-control d-none" style="max-width:140px">
              <option value="m" selected>m</option>
              <option value="cm">cm</option>
              <option value="mm">mm</option>
              <option value="um">µm</option>
              <option value="in">in</option>
              <option value="ft">ft</option>
            </select>
        </div>
        <div class="form-group form-inline" id="grpF">
          <label for="f" class="mr-2 mb-0">Frequency f</label>
          <input id="f" type="number" step="0.001" class="form-control mr-2" style="max-width:100px" value="1">
          <select id="f_unit" class="form-control d-none" style="max-width:180px">
              <option value="Hz" selected>Hz (1/s)</option>
              <option value="mHz">mHz</option>
              <option value="kHz">kHz</option>
              <option value="MHz">MHz</option>
              <option value="GHz">GHz</option>
              <option value="per_min">per minute</option>
              <option value="per_hour">per hour</option>
              <option value="per_day">per day</option>
              <option value="per_week">per week</option>
              <option value="per_month">per month</option>
              <option value="per_year">per year</option>
            </select>
        </div>
        <div class="form-group form-inline" id="grpM"><label for="m" class="mr-2 mb-0">Mass m (kg)</label><input id="m" type="number" step="0.001" class="form-control" style="max-width:100px" value="1"></div>
        <div class="form-group form-inline" id="grpK"><label for="k" class="mr-2 mb-0">Spring constant k (N/m)</label><input id="k" type="number" step="0.001" class="form-control" style="max-width:100px" value="4"></div>
        <div class="form-group form-inline" id="grpC"><label for="c" class="mr-2 mb-0">Damping c (N·s/m)</label><input id="c" type="number" step="0.001" class="form-control" style="max-width:100px" value="0.1"></div>
        <div class="form-group form-inline" id="grpF0"><label for="F0" class="mr-2 mb-0">Drive amplitude F₀ (N)</label><input id="F0" type="number" step="0.001" class="form-control" style="max-width:100px" value="0"></div>
        <div class="form-group form-inline" id="grpFd"><label for="fd" class="mr-2 mb-0">Drive frequency f<sub>d</sub> (Hz)</label><input id="fd" type="number" step="0.001" class="form-control" style="max-width:100px" value="1"></div>
        <div class="form-group form-inline" id="grpL"><label for="L" class="mr-2 mb-0">Pendulum length L (m)</label><input id="L" type="number" step="0.001" class="form-control" style="max-width:100px" value="1"></div>
        <div class="form-group form-inline" id="grpAang"><label for="Aang" class="mr-2 mb-0">Angular amplitude</label>
            <input id="Aang" type="number" step="0.001" class="form-control mr-2" style="max-width:160px" value="0.2">
            <select id="Aang_unit" class="form-control d-none" style="max-width:140px">
              <option value="rad" selected>rad</option>
              <option value="deg">deg</option>
            </select>
        </div>
        <div class="form-group form-inline" id="grpTUnit"><label for="t_unit" class="mr-2 mb-0">Time unit (display)</label>
          <select id="t_unit" class="form-control" style="max-width:180px">
            <option value="s" selected>seconds</option>
            <option value="min">minutes</option>
            <option value="hr">hours</option>
            <option value="day">days</option>
            <option value="week">weeks</option>
            <option value="month">months (30d)</option>
            <option value="year">years (365d)</option>
          </select>
        </div>
        <div class="form-check mb-2" id="grpUseKM"><input class="form-check-input" type="checkbox" id="useKM"><label class="form-check-label" for="useKM">Use k & m to set frequency</label></div>
        <div class="d-flex align-items-center">
          <button id="btnRun" class="btn btn-primary btn-sm mr-2">Run</button>
          <button id="btnUnits" class="btn btn-outline-secondary btn-sm mr-2" data-toggle="modal" data-target="#unitsModal">Units</button>
          <div class="dropdown mr-2">
            <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="presetBtn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Presets</button>
            <div class="dropdown-menu" aria-labelledby="presetBtn">
              <a class="dropdown-item" href="#" data-preset="spring-basic">Spring: A=0.1, f=1</a>
              <a class="dropdown-item" href="#" data-preset="damped-light">Damped: m=1, k=4, c=0.2</a>
              <a class="dropdown-item" href="#" data-preset="driven-resonance">Driven: m=1, k=4, c=0.1, fd≈f0, F0=1</a>
              <a class="dropdown-item" href="#" data-preset="damped-heavy">Damped (heavy): m=1, k=4, c=5.0</a>
              <a class="dropdown-item" href="#" data-preset="driven-near">Driven (near res.): m=1, k=4, c=0.05, fd≈f0±5%, F0=0.5</a>
              <a class="dropdown-item" href="#" data-preset="pend-small">Pendulum small: A=0.1 m, f=1</a>
              <a class="dropdown-item" href="#" data-preset="pend-large">Pendulum large: A=0.5 rad, L=1</a>
            </div>
          </div>
          <button id="btnReset" class="btn btn-outline-secondary btn-sm">Reset</button>
        </div>
        <div id="presetHint" class="small text-muted mt-2"></div>
      </div></div>
      <div class="card mb-3"><h5 class="card-header">Derived Values</h5><div class="card-body small">
        <div>Natural frequency f₀: <span id="out_f0">–</span></div>
        <div>Period T₀: <span id="out_T0">–</span></div>
        <div>Damping ratio ζ: <span id="out_zeta">–</span></div>
        <div>From f,m → k: <span id="out_k_from_f">–</span> N/m</div>
        <div>From f → L (pendulum): <span id="out_L_from_f">–</span></div>
        <div>Detuning |f<sub>d</sub> − f₀|: <span id="out_detune">–</span></div>
      </div></div>
      <div class="card mb-3"><h5 class="card-header">Formulas</h5><div class="card-body small text-muted">
        <div>x(t) = A cos(2π f t)</div>
        <div>v(t) = −A · 2π f · sin(2π f t)</div>
        <div>Period: T = 1 / f</div>
        <div>Spring mode: k = (2π f)² · m ⇔ f = (1/2π)√(k/m)</div>
        <div>Pendulum mode (small angle): L ≈ g / (4π² f²)</div>
      </div></div>
    </div>
    <div class="col-lg-8">
      <div class="card mb-3"><h5 class="card-header">Animation</h5><div class="card-body">
        <canvas id="oscCanvas" height="200"></canvas>
        <div class="mt-2">
          <button id="btnSaveOscImg" class="btn btn-outline-secondary btn-sm">Save Image</button>
        </div>
      </div></div>
      <div class="card mb-3"><h5 class="card-header d-flex justify-content-between align-items-center">Outputs</h5>
        <div class="card-body">
          <ul class="nav nav-tabs mb-2" id="outTabs">
            <li class="nav-item"><a class="nav-link active" href="#" data-pane="time">Time Series</a></li>
            <li class="nav-item"><a class="nav-link" href="#" data-pane="phase">Phase</a></li>
            <li class="nav-item"><a class="nav-link" href="#" data-pane="energy">Energy</a></li>
            <li class="nav-item"><a class="nav-link" href="#" data-pane="instant">Instant @ t</a></li>
            <li class="nav-item"><a class="nav-link" href="#" data-pane="calc">Calculator</a></li>
          </ul>
          <div id="pane_time">
            <canvas id="chartX" height="160"></canvas>
            <canvas id="chartV" height="160" class="mt-2"></canvas>
            <div class="mt-2">
              <button id="btnSaveXImg" class="btn btn-outline-secondary btn-sm">Save x(t) Image</button>
              <button id="btnSaveVImg" class="btn btn-outline-secondary btn-sm">Save v(t) Image</button>
              <button id="btnShareShm" class="btn btn-outline-secondary btn-sm">Share URL</button>
            </div>
          </div>
          <div id="pane_phase" style="display:none">
            <canvas id="chartPhase" height="200"></canvas>
          </div>
          <div id="pane_energy" style="display:none">
            <canvas id="chartEnergy" height="200"></canvas>
          </div>
          <div id="pane_instant" style="display:none">
            <div class="form-inline mb-2">
              <label class="mr-2" for="t_val">t</label>
              <input id="t_val" type="number" step="0.001" class="form-control mr-2" style="max-width:160px" value="0.5">
              <span class="text-muted">in selected time unit</span>
            </div>
            <div>ω (rad/s): <span id="out_omega">–</span> <span id="out_omega_drive" class="text-muted"></span></div>
            <div>y(t): <span id="out_y_t">–</span></div>
            <div>v(t): <span id="out_v_t">–</span></div>
            <div>a(t): <span id="out_a_t">–</span></div>
          </div>
          <div id="pane_calc" style="display:none">
            <div class="mb-2 font-weight-bold">Convert f, T, ω</div>
            <div class="form-row">
              <div class="col-6 mb-2">
                <label>f</label>
                <div class="d-flex">
                  <input id="calc_f" type="number" step="0.0001" class="form-control" placeholder="e.g. 1">
                  <select id="calc_f_u" class="form-control ml-2" style="max-width:160px">
                    <option value="Hz" selected>Hz</option>
                    <option value="mHz">mHz</option>
                    <option value="kHz">kHz</option>
                    <option value="MHz">MHz</option>
                    <option value="GHz">GHz</option>
                    <option value="per_min">per minute</option>
                    <option value="per_hour">per hour</option>
                    <option value="per_day">per day</option>
                  </select>
                </div>
              </div>
              <div class="col-6 mb-2">
                <label>T</label>
                <div class="d-flex">
                  <input id="calc_T" type="number" step="0.0001" class="form-control" placeholder="e.g. 1">
                  <select id="calc_T_u" class="form-control ml-2" style="max-width:140px">
                    <option value="s" selected>s</option>
                    <option value="min">min</option>
                    <option value="hr">hr</option>
                    <option value="day">day</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="form-group mb-2">
              <label>ω (rad/s)</label>
              <input id="calc_w" type="number" step="0.0001" class="form-control" placeholder="e.g. 6.2832">
            </div>
            <button id="btnCalcFTW" class="btn btn-outline-primary btn-sm mb-3">Solve f/T/ω</button>

            <div class="mb-2 font-weight-bold">Spring: f = (1/2π)√(k/m)</div>
            <div class="form-row">
              <div class="col-4 mb-2"><label>m (kg)</label><input id="calc_m" type="number" step="0.0001" class="form-control" placeholder="e.g. 1"></div>
              <div class="col-4 mb-2"><label>k (N/m)</label><input id="calc_k" type="number" step="0.0001" class="form-control" placeholder="e.g. 4"></div>
              <div class="col-4 mb-2">
                <label>f</label>
                <div class="d-flex">
                  <input id="calc_f2" type="number" step="0.0001" class="form-control" placeholder="">
                  <select id="calc_f2_u" class="form-control ml-2" style="max-width:120px">
                    <option value="Hz" selected>Hz</option>
                    <option value="kHz">kHz</option>
                    <option value="per_min">/min</option>
                  </select>
                </div>
              </div>
            </div>
            <button id="btnCalcSpring" class="btn btn-outline-primary btn-sm mb-3">Solve spring</button>

            <div class="mb-2 font-weight-bold">Pendulum (small angle): f ≈ (1/2π)√(g/L)</div>
            <div class="form-row">
              <div class="col-4 mb-2"><label>L (m)</label><input id="calc_L" type="number" step="0.0001" class="form-control" placeholder="e.g. 1"></div>
              <div class="col-4 mb-2"><label>f</label>
                <div class="d-flex">
                  <input id="calc_f3" type="number" step="0.0001" class="form-control" placeholder="">
                  <select id="calc_f3_u" class="form-control ml-2" style="max-width:110px">
                    <option value="Hz" selected>Hz</option>
                    <option value="per_min">/min</option>
                  </select>
                </div>
              </div>
              <div class="col-4 mb-2"><label>T</label>
                <div class="d-flex">
                  <input id="calc_T2" type="number" step="0.0001" class="form-control" placeholder="">
                  <select id="calc_T2_u" class="form-control ml-2" style="max-width:110px">
                    <option value="s" selected>s</option>
                    <option value="min">min</option>
                  </select>
                </div>
              </div>
            </div>
            <button id="btnCalcPend" class="btn btn-outline-primary btn-sm">Solve pendulum</button>

            <hr>
            <div class="mb-2 font-weight-bold">Amplitude & Energy</div>
            <div class="form-row">
              <div class="col-4 mb-2">
                <label>Mode</label>
                <select id="ae_mode" class="form-control">
                  <option value="spring" selected>Spring</option>
                  <option value="pend_small">Pendulum (small)</option>
                  <option value="pend_large">Pendulum (large)</option>
                </select>
              </div>
              <div class="col-4 mb-2"><label>A (<span id="ae_Au">unit</span>)</label><input id="ae_A" type="number" step="0.0001" class="form-control" placeholder="e.g. 0.1"></div>
              <div class="col-4 mb-2"><label>f (<span id="ae_fu">unit</span>)</label><input id="ae_f" type="number" step="0.0001" class="form-control" placeholder="e.g. 1"></div>
            </div>
            <div class="form-row">
              <div class="col-4 mb-2"><label>m (kg)</label><input id="ae_m" type="number" step="0.0001" class="form-control" placeholder="e.g. 1"></div>
              <div class="col-4 mb-2"><label>k (N/m)</label><input id="ae_k" type="number" step="0.0001" class="form-control" placeholder="e.g. 4"></div>
              <div class="col-4 mb-2" id="grpAE_L"><label>L (m)</label><input id="ae_L" type="number" step="0.0001" class="form-control" placeholder="e.g. 1"></div>
            </div>
            <div class="form-row">
              <div class="col-4 mb-2"><label>E (J)</label><input id="ae_E" type="number" step="0.0001" class="form-control" placeholder="optional"></div>
              <div class="col-4 mb-2"><label>v<sub>max</sub> (<span id="ae_vu">unit</span>)</label><input id="ae_vmax" type="number" step="0.0001" class="form-control" placeholder="optional"></div>
              <div class="col-4 mb-2"><label>a<sub>max</sub> (<span id="ae_au">unit</span>)</label><input id="ae_amax" type="number" step="0.0001" class="form-control" placeholder="optional"></div>
            </div>
            <div class="small">
              <div>ω: <span id="ae_w_o">–</span> rad/s</div>
              <div>v<sub>max</sub>: <span id="ae_vmax_o">–</span></div>
              <div>a<sub>max</sub>: <span id="ae_amax_o">–</span></div>
              <div>E: <span id="ae_E_o">–</span> J</div>
            </div>
            <div class="mt-2"><button id="btnAECopy" class="btn btn-outline-secondary btn-sm">Copy results</button></div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="card mb-3">
    <h5 class="card-header">FAQ & Teaching Notes</h5>
    <div class="card-body">
      <div class="shm-edu-grid">
        <div class="shm-edu-card shm-edu-card--concept">
          <h6>Quick Start (Students)</h6>
          <p>Use presets and watch how position, velocity, and energy change.</p>
          <ul class="mb-0">
            <li>Press Run with “Spring: A=0.1, f=1” and relate the animation to x(t), v(t).</li>
            <li>Mark when v(t)=0 and point out turnarounds in the animation.</li>
            <li>Change A: the period stays the same, peaks get taller (E ∝ A²).</li>
          </ul>
        </div>
        <div class="shm-edu-card shm-edu-card--investigate">
          <h6>Teacher Tips</h6>
          <p>Prompt predictions, then validate with the graphs and calculators.</p>
          <ul class="mb-0">
            <li>Spring: double k or m; use chips (T, ω, f₀) to predict the new period.</li>
            <li>Pendulum (small): vary L and estimate T from T≈2π√(L/g); mass cancels.</li>
            <li>Use Phase to show v leads x by ~90°; damping spirals inward.</li>
          </ul>
        </div>
        <div class="shm-edu-card shm-edu-card--alert">
          <h6>Common Misconceptions</h6>
          <p>Amplitude ≠ period; small‑angle pendulum period doesn’t depend on mass.</p>
          <ul class="mb-0">
            <li>Double A: period stays fixed; energy E grows (~A²); v(t) peaks increase.</li>
            <li>Pendulum mass change: no period change; only L and g matter (small angle).</li>
          </ul>
        </div>
      </div>
      <div class="shm-faq-item">
        <strong>Damping & Driving</strong><br>
        Damping shrinks amplitude and total energy (Energy tab) and produces inward spirals in Phase. A periodic drive sustains motion; near resonance amplitude grows and phase shifts toward 90°.
      </div>
      <div class="shm-faq-item">
        <strong>Estimating f₀ fast</strong><br>
        Spring: f₀=(1/2π)√(k/m). Pendulum (small): f₀≈(1/2π)√(g/L). Use the chips and the Derived Values card to verify against the x(t) plot.
      </div>
      <div class="shm-faq-item mb-0">
        <strong>Resonance Activity</strong><br>
        Use Driven mode and vary f<sub>d</sub> around f₀. Sketch amplitude vs f<sub>d</sub> and discuss how damping reduces the peak and broadens the curve.
      </div>
      <div class="shm-faq-item mt-2">
        <strong>What is SHM?</strong><br>
        Simple Harmonic Motion is motion under a restoring force proportional to displacement and directed toward equilibrium (F = −kx). The result is sinusoidal motion x(t)=A cos(ωt+φ), where ω depends on system parameters (e.g., ω=√(k/m) for a mass–spring, ω≈√(g/L) for a small‑angle pendulum). It conserves total mechanical energy in the ideal (undamped) case.
      </div>
    </div>
  </div>
</div>
<!-- Units Modal -->
<div class="modal fade" id="unitsModal" tabindex="-1" role="dialog" aria-labelledby="unitsModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="unitsModalLabel">Units</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label for="u_A">Length unit (A, y)</label>
          <select id="u_A" class="form-control">
            <option value="m">m</option>
            <option value="cm">cm</option>
            <option value="mm">mm</option>
            <option value="um">µm</option>
            <option value="in">in</option>
            <option value="ft">ft</option>
          </select>
        </div>
        <div class="form-group">
          <label for="u_f">Frequency unit</label>
          <select id="u_f" class="form-control">
            <option value="Hz">Hz</option>
            <option value="mHz">mHz</option>
            <option value="kHz">kHz</option>
            <option value="MHz">MHz</option>
            <option value="GHz">GHz</option>
            <option value="per_min">per minute</option>
            <option value="per_hour">per hour</option>
            <option value="per_day">per day</option>
            <option value="per_week">per week</option>
            <option value="per_month">per month</option>
            <option value="per_year">per year</option>
          </select>
        </div>
        <div class="form-group">
          <label for="u_Aang">Angle unit (Aθ)</label>
          <select id="u_Aang" class="form-control">
            <option value="rad">rad</option>
            <option value="deg">deg</option>
          </select>
        </div>
        <div class="form-group">
          <label for="u_t">Time display unit</label>
          <select id="u_t" class="form-control">
            <option value="s">seconds</option>
            <option value="min">minutes</option>
            <option value="hr">hours</option>
            <option value="day">days</option>
            <option value="week">weeks</option>
            <option value="month">months (30d)</option>
            <option value="year">years (365d)</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" id="btnUnitsSave" class="btn btn-primary">Save</button>
      </div>
    </div>
  </div>
  </div>
<script>
(function () {
  const $ = (id) => document.getElementById(id);
  const mode = $('mode');
  const AEl = $('A');
  const fEl = $('f');
  const mEl = $('m');
  const AUnit = $('A_unit');
  const FUnit = $('f_unit');
  const kEl = $('k');
  const cEl = $('c');
  const F0El = $('F0');
  const fdEl = $('fd');
  const LEl = $('L');
  const AangEl = $('Aang');
  const AangUnit = $('Aang_unit');
  const tUnit = $('t_unit');
  const useKM = $('useKM');
  const autoRun = document.getElementById('autoRun');
  const osc = $('oscCanvas');
  const octx = osc.getContext('2d');
  const cxX = document.getElementById('chartX').getContext('2d');
  const cxV = document.getElementById('chartV').getContext('2d');
  const cxPhase = document.getElementById('chartPhase').getContext('2d');
  const cxEnergy = document.getElementById('chartEnergy').getContext('2d');
  let chartX, chartV, t0 = 0, rafId = null;
  let lastA, lastF;
  let chartPhase, chartEnergy;
  // state for integrators
  let state = { x: 0, v: 0, theta: 0, omega: 0, t: 0 };
  // current parameters used by animation tick
  let params = null;
  let pending = false;

  function vis(id, show){ const el=document.getElementById(id); if(!el) return; el.style.display = show ? '' : 'none'; }
  function updateVisibility(){
    const md = mode.value;
    vis('grpA', md!=='pendulum-large');
    vis('grpF', md==='spring' || (md.startsWith('spring') && !useKM.checked) || md==='pendulum');
    vis('grpM', md.startsWith('spring') || md==='pendulum-large');
    vis('grpK', md.startsWith('spring'));
    vis('grpC', md==='spring-damped' || md==='spring-driven');
    vis('grpF0', md==='spring-driven');
    vis('grpFd', md==='spring-driven');
    vis('grpUseKM', md.startsWith('spring'));
    vis('grpL', md==='pendulum-large');
    vis('grpAang', md==='pendulum-large');
  }
  // Apply query params
  (function applyQuery(){
    const p=new URLSearchParams(window.location.search);
    if(p.has('mode')) mode.value=p.get('mode');
    if(p.has('A')) AEl.value=p.get('A');
    if(p.has('A_u')) AUnit.value=p.get('A_u');
    if(p.has('f')) fEl.value=p.get('f');
    if(p.has('f_u')) FUnit.value=p.get('f_u');
    if(p.has('m')) mEl.value=p.get('m');
    if(p.has('k')) kEl.value=p.get('k');
    if(p.has('c')) cEl.value=p.get('c');
    if(p.has('F0')) F0El.value=p.get('F0');
    if(p.has('fd')) fdEl.value=p.get('fd');
    if(p.has('L')) LEl.value=p.get('L');
    if(p.has('Aang')) AangEl.value=p.get('Aang');
    if(p.has('Aang_u')) AangUnit.value=p.get('Aang_u');
    if(p.has('t_u')) tUnit.value=p.get('t_u');
    if(p.has('useKM')) useKM.checked = (p.get('useKM')==='1' || p.get('useKM')==='true');
  })();

  function run() {
    updateVisibility();
    const md = mode.value;
    const A_in = parseFloat(AEl.value) || 0.1;
    const f_in = parseFloat(fEl.value) || 1;
    const A = toMeters(A_in, AUnit.value);
    const fIn = toHertz(f_in, FUnit.value);
    const m = parseFloat(mEl.value) || 1;
    const k = parseFloat(kEl.value) || 0;
    const c = parseFloat(cEl.value) || 0;
    const F0 = parseFloat(F0El.value) || 0;
    const fd = parseFloat(fdEl.value) || 1;
    const L = parseFloat(LEl.value) || 1;
    const Aang = toRadians(parseFloat(AangEl.value) || 0.2, AangUnit.value);
    const f = (md.startsWith('spring') && useKM.checked && k>0 && m>0) ? (Math.sqrt(k/m)/(2*Math.PI)) : fIn;
    // Reset state on Run to reflect new parameters
    state = { x: 0, v: 0, theta: 0, omega: 0, t: 0 };
    if (md.startsWith('spring')) { state.x = A; state.v = 0; }
    else if (md==='pendulum') { state.theta = A / (L||1); state.omega = 0; }
    else if (md==='pendulum-large') { state.theta = Aang; state.omega = 0; }
    t0 = 0;
    // Cache params, redraw and replot
    params = {A,f,m,k,c,F0,fd,L,Aang};
    draw(md, params);
    plot(md, params);
    showDerived(md, params);
    lastA = A; lastF = f;
  }

  function draw(md, p) {
    const w = osc.width = osc.getBoundingClientRect().width | 0;
    const h = osc.height;
    octx.clearRect(0, 0, w, h);
    // advance state for animation
    const dt = 0.016;
    if (md==='pendulum'){
      // analytic snapshot using provided A and f
      const t = t0; t0 += dt;
      const x = p.A * Math.cos(2*Math.PI*p.f*t);
      const baseX = w / 2;
      // draw rod and bob using small-angle mapping
      const pivotX = w / 2; const pivotY = 20; const Lpx = 120;
      const safeA = Math.abs(p.A) > 1e-6 ? p.A : 1;
      const theta = (x / safeA) * 0.2; // small-angle visual
      const bobX = pivotX + Lpx * Math.sin(theta);
      const bobY = pivotY + Lpx * Math.cos(theta);
      octx.strokeStyle = '#94a3b8'; octx.beginPath(); octx.moveTo(pivotX, pivotY); octx.lineTo(bobX, bobY); octx.stroke();
      octx.fillStyle = '#ef4444'; octx.beginPath(); octx.arc(bobX, bobY, 10, 0, Math.PI*2); octx.fill();
      return;
    } else {
      integrateStep(md, p, state, dt);
    }
    const x = (md.startsWith('spring')) ? state.x : (p.L * Math.sin(state.theta));
    if (md.startsWith('spring')) {
      const baseX = w / 2;
      const yMid = h / 2;
      // fixed wall
      octx.strokeStyle = '#94a3b8';
      octx.lineWidth = 2;
      octx.beginPath();
      octx.moveTo(baseX - 8, yMid - 40);
      octx.lineTo(baseX - 8, yMid + 40);
      octx.stroke();

      const massX = baseX + x * 200;
      // draw spring from wall to mass
      drawCoil(octx, baseX - 8, massX - 14, yMid, 10, 8);
      // mass block
      octx.fillStyle = '#6b7280';
      octx.fillRect(massX - 12, yMid - 12, 24, 24);
    } else {
      const pivotX = w / 2;
      const pivotY = 20;
      const Lpx = 120;
      const theta = state.theta;
      const bobX = pivotX + Lpx * Math.sin(theta);
      const bobY = pivotY + Lpx * Math.cos(theta);

      octx.strokeStyle = '#94a3b8';
      octx.beginPath();
      octx.moveTo(pivotX, pivotY);
      octx.lineTo(bobX, bobY);
      octx.stroke();

      octx.fillStyle = '#ef4444';
      octx.beginPath();
      octx.arc(bobX, bobY, 10, 0, Math.PI * 2);
      octx.fill();
    }
  }

  function plot(md, p) {
    const Tspan = 6; const dt = 0.01; const steps = Math.floor(Tspan/dt);
    const ts=[], xs=[], vs=[], ps=[], kes=[], ets=[], phasePts=[];
    // start from initial conditions
    let s = { x: 0, v: 0, theta: 0, omega: 0, t: 0 };
    if (md.startsWith('spring')) { s.x = p.A; s.v = 0; }
    else if (md==='pendulum') { /* analytic below */ }
    else if (md==='pendulum-large') { s.theta = p.Aang; s.omega = 0; }
    for(let i=0;i<=steps;i++){
      ts.push(s.t);
      if (md.startsWith('spring')){
        xs.push(s.x); vs.push(s.v);
        const KE = 0.5*(p.m||1)*s.v*s.v; const k = (p.k>0)?p.k: ( (2*Math.PI*p.f)*(2*Math.PI*p.f)*(p.m||1) );
        const PE = 0.5*k*s.x*s.x; kes.push(KE); ps.push(PE); ets.push(KE+PE);
        phasePts.push({x:s.x,y:s.v});
      } else if (md==='pendulum-large'){
        const x = p.L * Math.sin(s.theta); const v = p.L * s.omega * Math.cos(s.theta);
        xs.push(x); vs.push(v);
        const KEp = 0.5*(p.m||1)*(p.L*s.omega)*(p.L*s.omega);
        const PEp = (p.m||1)*9.81*p.L*(1-Math.cos(s.theta)); kes.push(KEp); ps.push(PEp); ets.push(KEp+PEp);
        phasePts.push({x:x,y:v});
      } else if (md==='pendulum'){
        const t = i*dt;
        const x = p.A * Math.cos(2*Math.PI*p.f*t);
        const v = -p.A * 2*Math.PI*p.f * Math.sin(2*Math.PI*p.f*t);
        xs.push(x); vs.push(v);
        const KEp = 0.5*(p.m||1)*v*v; const PEp = (p.m||1)*9.81*(p.L||1)*(1 - Math.cos((x/(p.L||1))));
        kes.push(KEp); ps.push(PEp); ets.push(KEp+PEp);
        phasePts.push({x:x,y:v});
      }
      if (md!=='pendulum') integrateStep(md, p, s, dt); else s.t += dt;
    }

    if (!chartX) {
      chartX = new Chart(cxX, {
        type: 'line',
        data: {
          labels: ts.map(convertTime),
          datasets: [
            { label: 'x(t)', data: xs, borderColor: '#0ea5e9', pointRadius: 0, tension: 0.12 }
          ]
        },
        options: {
          responsive: true,
          scales: {
            x: { title: { display: true, text: timeAxisLabel() }, ticks: { callback: (v)=> trimFloat(v) } },
            y: { title: { display: true, text: 'x (m)' } }
          },
          plugins: { legend: { display: false } }
        }
      });
    } else {
      chartX.data.labels = ts.map(convertTime);
      chartX.data.datasets[0].data = xs;
      chartX.update('none');
    }

    if (!chartV) {
      chartV = new Chart(cxV, {
        type: 'line',
        data: {
          labels: ts.map(convertTime),
          datasets: [
            { label: 'v(t)', data: vs, borderColor: '#22c55e', pointRadius: 0, tension: 0.12 }
          ]
        },
        options: {
          responsive: true,
          scales: {
            x: { title: { display: true, text: timeAxisLabel() }, ticks: { callback: (v)=> trimFloat(v) } },
            y: { title: { display: true, text: 'v (m/s)' } }
          },
          plugins: { legend: { display: false } }
        }
      });
    } else {
      chartV.data.labels = ts.map(convertTime);
      chartV.data.datasets[0].data = vs;
      chartV.update('none');
    }

    // Phase space chart
    if (!chartPhase){
      chartPhase = new Chart(cxPhase, {
        type: 'line',
        data: { datasets: [{ label: 'Phase (v vs x)', data: phasePts, borderColor: '#8b5cf6', showLine: true, pointRadius: 0 }] },
        options: { responsive:true, parsing:false, scales:{ x: { title:{display:true,text:'x (m)'}, ticks:{ callback: (v)=> trimFloat(v) } }, y:{ title:{display:true,text:'v (m/s)'}, ticks:{ callback: (v)=> trimFloat(v) } } }, plugins:{ legend:{ display:false } } }
      });
    } else {
      chartPhase.data.datasets[0].data = phasePts;
      chartPhase.update('none');
    }

    // Energy chart
    if (!chartEnergy){
      chartEnergy = new Chart(cxEnergy, {
        type: 'line',
        data: { labels: ts.map(convertTime), datasets: [
          { label:'KE', data: kes, borderColor:'#f59e0b', pointRadius:0 },
          { label:'PE', data: ps, borderColor:'#10b981', pointRadius:0 },
          { label:'E_total', data: ets, borderColor:'#64748b', pointRadius:0 }
        ] },
        options: { responsive:true, scales:{ x:{ title:{display:true,text: timeAxisLabel()}, ticks:{ callback: (v)=> trimFloat(v) } }, y:{ title:{display:true,text:'Energy (J)'}, ticks:{ callback: (v)=> trimFloat(v) } } } }
      });
    } else {
      chartEnergy.data.labels = ts.map(convertTime);
      chartEnergy.data.datasets[0].data = kes;
      chartEnergy.data.datasets[1].data = ps;
      chartEnergy.data.datasets[2].data = ets;
      chartEnergy.update('none');
    }
  }

  function toMeters(a, unit){
    const map = { m:1, cm:0.01, mm:0.001, um:1e-6, in:0.0254, ft:0.3048 };
    return a * (map[unit]||1);
  }
  function toRadians(a, unit){ return unit==='deg' ? (a*Math.PI/180) : a; }
  function toHertz(f, unit){
    const per = { per_min: 1/60, per_hour: 1/3600, per_day: 1/86400, per_week: 1/604800, per_month: 1/2592000, per_year: 1/31536000 };
    const scale = { Hz:1, mHz:1e-3, kHz:1e3, MHz:1e6, GHz:1e9 };
    if(unit in scale) return f*scale[unit];
    if(unit in per) return f*per[unit];
    return f;
  }
  function timeAxisLabel(){
    const u = tUnit.value; const map = { s:'t (s)', min:'t (min)', hr:'t (hr)', day:'t (day)', week:'t (week)', month:'t (month)', year:'t (year)' };
    return map[u]||'t (s)';
  }

  // Calculator actions
  function calcFTW(){
    const fVal = parseFloat((document.getElementById('calc_f')||{}).value);
    const fU = (document.getElementById('calc_f_u')||{}).value||'Hz';
    const TVal = parseFloat((document.getElementById('calc_T')||{}).value);
    const TU = (document.getElementById('calc_T_u')||{}).value||'s';
    const wVal = parseFloat((document.getElementById('calc_w')||{}).value);
    let fHz, Tsec, w;
    if(isFinite(wVal)){
      w = wVal; fHz = w/(2*Math.PI); Tsec = 1/fHz;
    } else if(isFinite(fVal)){
      fHz = toHertz(fVal, fU); w = 2*Math.PI*fHz; Tsec = fHz>0? 1/fHz : NaN;
    } else if(isFinite(TVal)){
      const mult = { s:1, min:60, hr:3600, day:86400 }[TU]||1;
      Tsec = TVal*mult; fHz = Tsec>0? 1/Tsec : NaN; w = 2*Math.PI*fHz;
    }
    if(isFinite(fHz)){
      (document.getElementById('calc_f').value) = (fHz).toFixed(6);
      (document.getElementById('calc_f_u').value) = 'Hz';
    }
    if(isFinite(Tsec)){
      (document.getElementById('calc_T').value) = Tsec.toFixed(6);
      (document.getElementById('calc_T_u').value) = 's';
    }
    if(isFinite(w)){
      (document.getElementById('calc_w').value) = w.toFixed(6);
    }
  }

  function calcSpring(){
    const m = parseFloat((document.getElementById('calc_m')||{}).value);
    const k = parseFloat((document.getElementById('calc_k')||{}).value);
    const fIn = parseFloat((document.getElementById('calc_f2')||{}).value);
    const fU = (document.getElementById('calc_f2_u')||{}).value||'Hz';
    let fHz = isFinite(fIn)? toHertz(fIn, fU): NaN;
    if(!isFinite(k) && isFinite(m) && isFinite(fHz)){
      const kcalc = (2*Math.PI*fHz)**2 * m; document.getElementById('calc_k').value = kcalc.toFixed(6); return;
    }
    if(!isFinite(m) && isFinite(k) && isFinite(fHz) && fHz>0){
      const mcalc = k / ((2*Math.PI*fHz)**2); document.getElementById('calc_m').value = mcalc.toFixed(6); return;
    }
    if(!isFinite(fHz) && isFinite(k) && isFinite(m) && m>0){
      const fcalc = Math.sqrt(k/m)/(2*Math.PI); document.getElementById('calc_f2').value = fcalc.toFixed(6); document.getElementById('calc_f2_u').value='Hz'; return;
    }
    // else: prefer compute f
    if(isFinite(k) && isFinite(m) && m>0){ const fcalc = Math.sqrt(k/m)/(2*Math.PI); document.getElementById('calc_f2').value = fcalc.toFixed(6); document.getElementById('calc_f2_u').value='Hz'; }
  }

  function calcPendulum(){
    const g=9.81;
    const L = parseFloat((document.getElementById('calc_L')||{}).value);
    const fIn = parseFloat((document.getElementById('calc_f3')||{}).value);
    const fU = (document.getElementById('calc_f3_u')||{}).value||'Hz';
    const TIn = parseFloat((document.getElementById('calc_T2')||{}).value);
    const TU = (document.getElementById('calc_T2_u')||{}).value||'s';
    let fHz = isFinite(fIn)? toHertz(fIn, fU) : NaN;
    let Tsec = isFinite(TIn)? TIn * ({s:1, min:60}[TU]||1) : NaN;
    if(!isFinite(L) && isFinite(fHz) && fHz>0){ const Lcalc = g/(4*Math.PI*Math.PI*fHz*fHz); document.getElementById('calc_L').value=Lcalc.toFixed(6); return; }
    if(!isFinite(fHz) && isFinite(L) && L>0){ const fcalc = (1/(2*Math.PI))*Math.sqrt(g/L); document.getElementById('calc_f3').value=fcalc.toFixed(6); document.getElementById('calc_f3_u').value='Hz'; return; }
    if(!isFinite(Tsec) && isFinite(L) && L>0){ const Tcalc = 2*Math.PI*Math.sqrt(L/g); document.getElementById('calc_T2').value=Tcalc.toFixed(6); document.getElementById('calc_T2_u').value='s'; return; }
    // default: compute f and T from L if possible
    if(isFinite(L) && L>0){ const fcalc = (1/(2*Math.PI))*Math.sqrt(g/L); const Tcalc=1/fcalc; document.getElementById('calc_f3').value=fcalc.toFixed(6); document.getElementById('calc_f3_u').value='Hz'; document.getElementById('calc_T2').value=Tcalc.toFixed(6); document.getElementById('calc_T2_u').value='s'; }
  }

  // Dynamic calculator: auto-compute missing values as user types
  let calcUpdating=false, calcFTWLast=null, calcSpringLast=null, calcPendLast=null;
  function activeId(){ return (document.activeElement && document.activeElement.id) || null; }
  function autoCalcFTW(){ if(calcUpdating) return; calcUpdating=true; try{
    const fElI = document.getElementById('calc_f'); const fU = (document.getElementById('calc_f_u')||{}).value||'Hz';
    const TElI = document.getElementById('calc_T'); const TU = (document.getElementById('calc_T_u')||{}).value||'s';
    const wElI = document.getElementById('calc_w');
    const fIn = parseFloat(fElI && fElI.value); const TIn = parseFloat(TElI && TElI.value); const wIn = parseFloat(wElI && wElI.value);
    const haveF = isFinite(fIn); const haveT = isFinite(TIn); const haveW = isFinite(wIn);
    let src = calcFTWLast;
    const aid = activeId();
    if(aid==='calc_f' || aid==='calc_f_u') src='f';
    else if(aid==='calc_T' || aid==='calc_T_u') src='T';
    else if(aid==='calc_w') src='w';
    if(!src){ if(haveW) src='w'; else if(haveF) src='f'; else if(haveT) src='T'; }
    let fHz=NaN, Tsec=NaN, w=NaN;
    if(src==='f' && haveF){ fHz = toHertz(fIn, fU); w = 2*Math.PI*fHz; Tsec = fHz>0? 1/fHz:NaN; }
    else if(src==='T' && haveT){ Tsec = TIn*({s:1,min:60,hr:3600,day:86400}[TU]||1); fHz = Tsec>0? 1/Tsec:NaN; w = 2*Math.PI*fHz; }
    else if(src==='w' && haveW){ w = wIn; fHz = w/(2*Math.PI); Tsec = fHz>0? 1/fHz:NaN; }
    else { // fallback single source
      if(haveW){ w = wIn; fHz = w/(2*Math.PI); Tsec = fHz>0?1/fHz:NaN; }
      else if(haveF){ fHz = toHertz(fIn, fU); w = 2*Math.PI*fHz; Tsec = fHz>0?1/fHz:NaN; }
      else if(haveT){ Tsec = TIn*({s:1,min:60,hr:3600,day:86400}[TU]||1); fHz = Tsec>0?1/Tsec:NaN; w = 2*Math.PI*fHz; }
    }
    // Update only non-source fields
    if(src!=='f' && fElI && isFinite(fHz)) { fElI.value = fHz.toFixed(6); (document.getElementById('calc_f_u')||{}).value='Hz'; }
    if(src!=='T' && TElI && isFinite(Tsec)) { TElI.value = Tsec.toFixed(6); (document.getElementById('calc_T_u')||{}).value='s'; }
    if(src!=='w' && wElI && isFinite(w)) { wElI.value = w.toFixed(6); }
  } finally { calcUpdating=false; } }

  function autoCalcSpring(){ if(calcUpdating) return; calcUpdating=true; try{
    const mI = document.getElementById('calc_m'); const kI=document.getElementById('calc_k'); const fI=document.getElementById('calc_f2'); const fU=(document.getElementById('calc_f2_u')||{}).value||'Hz';
    const m = parseFloat(mI&&mI.value); const k = parseFloat(kI&&kI.value); const fIn = parseFloat(fI&&fI.value); const fHz = isFinite(fIn)? toHertz(fIn, fU): NaN;
    const haveM=isFinite(m), haveK=isFinite(k), haveF=isFinite(fHz);
    let src = calcSpringLast; const aid=activeId();
    if(aid==='calc_m') src='m'; else if(aid==='calc_k') src='k'; else if(aid==='calc_f2' || aid==='calc_f2_u') src='f';
    if(!src){ if(haveM && haveK && !haveF) src='?'; else if(haveK && haveF) src='kf'; else if(haveM && haveF) src='mf'; }
    // Compute from source
    if(src==='m' && haveM && haveK){ const fcalc=Math.sqrt(k/m)/(2*Math.PI); if(fI){ fI.value=fcalc.toFixed(6); (document.getElementById('calc_f2_u')||{}).value='Hz'; } }
    else if(src==='k' && haveM && haveK){ const fcalc=Math.sqrt(k/m)/(2*Math.PI); if(fI){ fI.value=fcalc.toFixed(6); (document.getElementById('calc_f2_u')||{}).value='Hz'; } }
    else if(src==='f' && haveF && haveM){ const kcalc=(2*Math.PI*fHz)**2 * m; if(kI) kI.value=kcalc.toFixed(6); }
    else {
      // Heuristic: fill missing among three using any two
      if(haveM && haveK && !haveF){ const fcalc=Math.sqrt(k/m)/(2*Math.PI); if(fI){ fI.value=fcalc.toFixed(6); (document.getElementById('calc_f2_u')||{}).value='Hz'; } }
      if(haveK && haveF && !haveM){ const mcalc = k/((2*Math.PI*fHz)**2); if(mI) mI.value=mcalc.toFixed(6); }
      if(haveM && haveF && !haveK){ const kcalc=(2*Math.PI*fHz)**2 * m; if(kI) kI.value=kcalc.toFixed(6); }
    }
  } finally { calcUpdating=false; } }

  function autoCalcPendulum(){ if(calcUpdating) return; calcUpdating=true; try{
    const g=9.81; const LI=document.getElementById('calc_L'); const fI=document.getElementById('calc_f3'); const fU=(document.getElementById('calc_f3_u')||{}).value||'Hz'; const TI=document.getElementById('calc_T2'); const TU=(document.getElementById('calc_T2_u')||{}).value||'s';
    const L=parseFloat(LI&&LI.value); const fIn=parseFloat(fI&&fI.value); const TIn=parseFloat(TI&&TI.value);
    const fHz=isFinite(fIn)? toHertz(fIn, fU): NaN; const Tsec=isFinite(TIn)? TIn*({s:1,min:60}[TU]||1): NaN;
    const haveL=isFinite(L), haveF=isFinite(fHz), haveT=isFinite(Tsec);
    let src = calcPendLast; const aid=activeId();
    if(aid==='calc_L') src='L'; else if(aid==='calc_f3' || aid==='calc_f3_u') src='f'; else if(aid==='calc_T2' || aid==='calc_T2_u') src='T';
    if(src==='L' && haveL){ const fcalc=(1/(2*Math.PI))*Math.sqrt(g/L); if(fI){ fI.value=fcalc.toFixed(6); (document.getElementById('calc_f3_u')||{}).value='Hz'; } if(TI){ TI.value=(1/fcalc).toFixed(6); (document.getElementById('calc_T2_u')||{}).value='s'; } }
    else if(src==='f' && haveF){ const Lcalc=g/(4*Math.PI*Math.PI*fHz*fHz); if(LI) LI.value=Lcalc.toFixed(6); if(TI){ TI.value=(1/fHz).toFixed(6); (document.getElementById('calc_T2_u')||{}).value='s'; } }
    else if(src==='T' && haveT){ const fcalc=Tsec>0? 1/Tsec:NaN; if(fI){ fI.value=isFinite(fcalc)? fcalc.toFixed(6):''; (document.getElementById('calc_f3_u')||{}).value='Hz'; } if(isFinite(fcalc)){ const Lcalc=g/(4*Math.PI*Math.PI*fcalc*fcalc); if(LI) LI.value=Lcalc.toFixed(6); } }
    else {
      // fallback: fill missing using any two
      if(haveL && !haveF){ const fcalc=(1/(2*Math.PI))*Math.sqrt(g/L); if(fI){ fI.value=fcalc.toFixed(6); (document.getElementById('calc_f3_u')||{}).value='Hz'; } if(TI){ TI.value=(1/fcalc).toFixed(6); (document.getElementById('calc_T2_u')||{}).value='s'; } }
      else if(haveF && !haveL){ const Lcalc=g/(4*Math.PI*Math.PI*fHz*fHz); if(LI) LI.value=Lcalc.toFixed(6); if(TI){ TI.value=(1/fHz).toFixed(6); (document.getElementById('calc_T2_u')||{}).value='s'; } }
      else if(haveT && !haveL){ const fcalc=Tsec>0? 1/Tsec:NaN; if(isFinite(fcalc)){ const Lcalc=g/(4*Math.PI*Math.PI*fcalc*fcalc); if(LI) LI.value=Lcalc.toFixed(6); if(fI){ fI.value=fcalc.toFixed(6); (document.getElementById('calc_f3_u')||{}).value='Hz'; } }
      }
    }
  } finally { calcUpdating=false; } }

  function convertTime(tSec){
    const conv = { s:1, min:1/60, hr:1/3600, day:1/86400, week:1/604800, month:1/2592000, year:1/31536000 };
    const f = conv[tUnit.value]||1; return tSec * f;
  }
  function trimFloat(n){
    const num = Number(n);
    if(!isFinite(num)) return String(n);
    const abs = Math.abs(num);
    if(abs === 0) return '0';
    // Use scientific notation for very small values
    if(abs < 1e-3) return num.toExponential(2);
    let s;
    if(abs >= 1000) s = num.toFixed(0);
    else if(abs >= 10) s = num.toFixed(1);
    else if(abs >= 1) s = num.toFixed(2);
    else s = num.toFixed(3);
    s = s.replace(/(\.\d*?[1-9])0+$/,'$1').replace(/\.0+$/,'').replace(/\.$/,'');
    return s;
  }

  function integrateStep(md, p, s, dt){
    if (md.startsWith('spring')){
      const m = (p.m||1); const k = (p.k>0)?p.k: ( (2*Math.PI*p.f)*(2*Math.PI*p.f)*m );
      const c = (md==='spring-damped' || md==='spring-driven')? (p.c||0):0;
      const F0 = (md==='spring-driven')? (p.F0||0):0;
      const wD = 2*Math.PI*(p.fd||1);
      const deriv = (st,t)=>{
        const x=st.x, v=st.v;
        const a = (-c*v - k*x + F0*Math.cos(wD*t)) / m;
        return { xdot: v, vdot: a };
      };
      rk4_step_2d(s, deriv, dt);
    } else if (md==='pendulum' || md==='pendulum-large'){
      const L = p.L||1; const g=9.81;
      const deriv = (st)=>{
        const theta=st.theta, omega=st.omega;
        const alph = -(g/L)*Math.sin(theta); // large-angle
        return { thetadot: omega, omegadot: alph };
      };
      rk4_step_pendulum(s, deriv, dt);
    }
    s.t += dt;
  }

  function drawCoil(ctx, x1, x2, y, coils, amp){
    const len = x2 - x1;
    const pad = Math.min(12, Math.abs(len)*0.1);
    const start = x1 + pad;
    const end = x2 - pad;
    const n = Math.max(2, coils|0);
    const seg = (end - start) / n;
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(x1, y);
    let dir = 1;
    for(let i=0;i<n;i++){
      const xMid = start + i*seg + seg/2;
      const yMid = y + dir*amp;
      const xNext = start + (i+1)*seg;
      ctx.lineTo(xMid, yMid);
      ctx.lineTo(xNext, y);
      dir *= -1;
    }
    ctx.lineTo(x2, y);
    ctx.stroke();
  }

  function rk4_step_2d(s, deriv, dt){
    const k1 = deriv(s, s.t);
    const s2 = { x: s.x + 0.5*dt*k1.xdot, v: s.v + 0.5*dt*k1.vdot };
    const k2 = deriv(s2, s.t + 0.5*dt);
    const s3 = { x: s.x + 0.5*dt*k2.xdot, v: s.v + 0.5*dt*k2.vdot };
    const k3 = deriv(s3, s.t + 0.5*dt);
    const s4 = { x: s.x + dt*k3.xdot, v: s.v + dt*k3.vdot };
    const k4 = deriv(s4, s.t + dt);
    s.x += (dt/6)*(k1.xdot + 2*k2.xdot + 2*k3.xdot + k4.xdot);
    s.v += (dt/6)*(k1.vdot + 2*k2.vdot + 2*k3.vdot + k4.vdot);
  }

  function rk4_step_pendulum(s, deriv, dt){
    const k1 = deriv(s);
    const s2 = { theta: s.theta + 0.5*dt*k1.thetadot, omega: s.omega + 0.5*dt*k1.omegadot };
    const k2 = deriv(s2);
    const s3 = { theta: s.theta + 0.5*dt*k2.thetadot, omega: s.omega + 0.5*dt*k2.omegadot };
    const k3 = deriv(s3);
    const s4 = { theta: s.theta + dt*k3.thetadot, omega: s.omega + dt*k3.omegadot };
    const k4 = deriv(s4);
    s.theta += (dt/6)*(k1.thetadot + 2*k2.thetadot + 2*k3.thetadot + k4.thetadot);
    s.omega += (dt/6)*(k1.omegadot + 2*k2.omegadot + 2*k3.omegadot + k4.omegadot);
  }

  function step() {
    animateTick();
    rafId = requestAnimationFrame(step);
  }

  function animateTick(){
    if(!params) return;
    draw(mode.value, params);
  }

  function showDerived(md, p){
    const g = 9.81;
    const set = (id, val)=>{ const el=document.getElementById(id); if(el) el.textContent = (val==null||Number.isNaN(val))? '–' : (typeof val==='number'? fmt(val): String(val)); };
    const fmt = (x)=>{
      if(!isFinite(x)) return '–';
      const ax = Math.abs(x);
      if(ax>=1000) return x.toFixed(0);
      if(ax>=10) return x.toFixed(2);
      if(ax>=1) return x.toFixed(3);
      return x.toExponential(2);
    };
    let f0=null, T0=null, zeta=null, k_from_f=null, L_from_f=null, detune=null;
    if(md.startsWith('spring')){
      const m = p.m||0; const k = p.k||0; const c = p.c||0; const f = p.f||0;
      if(m>0 && k>0){ f0 = Math.sqrt(k/m)/(2*Math.PI); T0 = f0>0? 1/f0 : null; }
      else if(m>0 && f>0){ k_from_f = (2*Math.PI*f)*(2*Math.PI*f)*m; f0 = f; T0 = 1/f; }
      if(m>0 && k>0 && c>0){ zeta = c / (2*Math.sqrt(k*m)); }
      if(md==='spring-driven' && f0!=null && p.fd){ detune = Math.abs(p.fd - f0); }
    } else if(md==='pendulum'){
      const f = p.f||0; if(f>0){ f0 = f; T0 = 1/f; L_from_f = g/(4*Math.PI*Math.PI*f*f); }
    } else if(md==='pendulum-large'){
      const L = p.L||0; if(L>0){ f0 = Math.sqrt(g/L)/(2*Math.PI); T0 = 1/f0; }
    }
    // format with selected units
    const f0Str = isFinite(f0)? formatFreqWithUnit(f0) : '–';
    const T0Str = isFinite(T0)? formatTimeWithUnit(T0) : '–';
    const Lstr = isFinite(L_from_f)? (toDisplayLen(L_from_f)+' '+AUnit.value) : '–';
    const detStr = isFinite(detune)? formatFreqWithUnit(detune) : '–';
    const zetaStr = (zeta!=null && isFinite(zeta))? zeta.toFixed(3) : '–';
    set('out_f0', f0Str);
    set('out_T0', T0Str);
    set('out_zeta', zeta);
    set('out_k_from_f', k_from_f);
    set('out_L_from_f', Lstr);
    set('out_detune', detStr);
    // Angular frequency outputs
    const omegaSpan = document.getElementById('out_omega');
    const omegaDriveSpan = document.getElementById('out_omega_drive');
    if(omegaSpan){
      let omega = null, omegaDrive = null;
      if(md.startsWith('spring')){
        if(p.m>0 && p.k>0) omega = Math.sqrt(p.k/p.m);
        else if(p.f>0) omega = 2*Math.PI*p.f;
        if(md==='spring-driven' && p.fd>0) omegaDrive = 2*Math.PI*p.fd;
      } else if(md==='pendulum'){
        if(p.f>0) omega = 2*Math.PI*p.f;
      } else if(md==='pendulum-large'){
        if(p.L>0) omega = Math.sqrt(9.81/p.L);
      }
      omegaSpan.textContent = (omega!=null && isFinite(omega))? omega.toFixed(4) : '–';
      if(omegaDriveSpan) omegaDriveSpan.textContent = (omegaDrive!=null)? `(drive ωd = ${omegaDrive.toFixed(4)} rad/s)` : '';
    }
    showInstant(md, p);
  }

  function fromHertzToUnit(fHz, unit){
    const to = { Hz:1, mHz:1e3, kHz:1e-3, MHz:1e-6, GHz:1e-9 };
    const toPer = { per_min:60, per_hour:3600, per_day:86400, per_week:604800, per_month:2592000, per_year:31536000 };
    if(unit in to) return fHz*(to[unit]);
    if(unit in toPer) return fHz*(toPer[unit]);
    return fHz;
  }
  function freqUnitLabel(u){
    const map={ Hz:'Hz', mHz:'mHz', kHz:'kHz', MHz:'MHz', GHz:'GHz', per_min:'/min', per_hour:'/hr', per_day:'/day', per_week:'/week', per_month:'/month', per_year:'/year' };
    return map[u]||'Hz';
  }
  function formatFreqWithUnit(fHz){
    const u = FUnit.value; const v = fromHertzToUnit(fHz, u);
    const s = (Math.abs(v)>=1? v.toFixed(3): v.toExponential(2));
    return s+' '+freqUnitLabel(u);
  }
  function formatTimeWithUnit(tSec){
    const v = convertTime(tSec); return (Math.abs(v)>=1? v.toFixed(3): v.toExponential(2)) + ' ' + timeUnitLabelShort();
  }

  // Amplitude & Energy mini-calculator
  function updateAEUnitLabels(){
    const au=document.getElementById('ae_Au'); if(au) au.textContent=AUnit.value;
    const fu=document.getElementById('ae_fu'); if(fu) fu.textContent=freqUnitLabel(FUnit.value);
    const vu=document.getElementById('ae_vu'); if(vu) vu.textContent = AUnit.value + '/' + timeUnitLabelShort();
    const au2=document.getElementById('ae_au'); if(au2) au2.textContent = AUnit.value + '/' + timeUnitLabelShort() + '²';
  }
  function autoCalcAE(){ if(calcUpdating) return; calcUpdating=true; try{
    const modeAE = (document.getElementById('ae_mode')||{}).value || 'spring';
    const A_in = parseFloat((document.getElementById('ae_A')||{}).value);
    const f_in = parseFloat((document.getElementById('ae_f')||{}).value);
    const m = parseFloat((document.getElementById('ae_m')||{}).value);
    const k = parseFloat((document.getElementById('ae_k')||{}).value);
    const L = parseFloat((document.getElementById('ae_L')||{}).value);
    const E_in = parseFloat((document.getElementById('ae_E')||{}).value);
    const vmax_in = parseFloat((document.getElementById('ae_vmax')||{}).value);
    const amax_in = parseFloat((document.getElementById('ae_amax')||{}).value);
    const aid = activeId();
    // Convert inputs
    let A = isFinite(A_in)? toMeters(A_in, AUnit.value) : NaN;
    let fHz = isFinite(f_in)? toHertz(f_in, FUnit.value) : NaN;
    const E = isFinite(E_in)? E_in : NaN;
    const vmax = isFinite(vmax_in)? (toMeters(vmax_in, AUnit.value) / secondsPerDisplayUnit()) : NaN;
    const amax = isFinite(amax_in)? (toMeters(amax_in, AUnit.value) / (secondsPerDisplayUnit()*secondsPerDisplayUnit())) : NaN;
    const g=9.81;
    // Determine omega
    let w = NaN;
    if(isFinite(fHz)) w = 2*Math.PI*fHz;
    else if(modeAE==='spring' && isFinite(k) && isFinite(m) && m>0) w = Math.sqrt(k/m);
    else if(modeAE==='pend_small' && isFinite(L) && L>0) w = Math.sqrt(g/L);
    // Solve A from E/vmax/amax if needed
    if(!isFinite(A)){
      if(isFinite(E)){
        if(modeAE==='spring'){
          if(isFinite(k)) A = Math.sqrt(2*E/k);
          else if(isFinite(m) && isFinite(w) && w>0) A = Math.sqrt(2*E/(m*w*w));
        } else if(modeAE==='pend_small'){
          if(isFinite(m) && isFinite(w) && w>0) A = Math.sqrt(2*E/(m*w*w));
          else if(isFinite(m) && isFinite(L) && L>0) A = Math.sqrt((2*E*L)/(m*g)); // using E≈1/2 m (g/L) A^2
        } else if(modeAE==='pend_large'){
          if(isFinite(m) && isFinite(L) && L>0){
            const cosT = 1 - (E/(m*g*L));
            const theta = Math.acos(Math.max(-1, Math.min(1, cosT)));
            A = L * theta;
          }
        }
      } else if(isFinite(vmax) && isFinite(w)){
        // From vmax and omega
        A = vmax / w;
      } else if(isFinite(amax) && isFinite(w)){
        A = amax / (w*w);
      }
    }
    // Compute vmax, amax, energy
    let Ecalc=E; let vmaxCalc=NaN, amaxCalc=NaN;
    if(isFinite(A)){
      vmaxCalc=NaN; amaxCalc=NaN;
      if(isFinite(w)) { vmaxCalc = A*w; amaxCalc = w*w*A; }
      if(modeAE==='spring'){
        if(isFinite(k)) Ecalc = 0.5*k*A*A;
        else if(isFinite(m)) Ecalc = 0.5*m*w*w*A*A;
      } else if(modeAE==='pend_small'){
        if(isFinite(m)){
          if(isFinite(w)) Ecalc = 0.5*m*w*w*A*A;
          else if(isFinite(L) && L>0) Ecalc = 0.5*m*(g/L)*A*A;
        }
      } else if(modeAE==='pend_large'){
        if(isFinite(m) && isFinite(L) && L>0){
          const theta = A / L;
          Ecalc = m*g*L*(1 - Math.cos(theta));
          // Use energy to get vmax tangential if w unknown
          const v_from_E = Math.sqrt(Math.max(0, 2*g*L*(1 - Math.cos(theta))));
          if(!isFinite(vmax)) vmaxCalc = v_from_E;
          // amax tangential at max angle: g*sin(theta)
          const a_from_theta = g * Math.sin(theta);
          if(!isFinite(amax)) amaxCalc = a_from_theta;
        }
      }
      // If computed, write back vmax/amax inputs in display units
      if(aid!=='ae_vmax' && isFinite(vmaxCalc)) (document.getElementById('ae_vmax')||{}).value = (toDisplayLen(vmaxCalc)*secondsPerDisplayUnit()).toFixed(6);
      if(aid!=='ae_amax' && isFinite(amaxCalc)) (document.getElementById('ae_amax')||{}).value = (toDisplayLen(amaxCalc)*secondsPerDisplayUnit()*secondsPerDisplayUnit()).toFixed(6);
    }
    // Write outputs (respect active field)
    const setIf = (id, val, srcId)=>{ const el=document.getElementById(id); if(!el) return; if(aid===srcId) return; if(isFinite(val)) el.value = String(val); };
    const writeA = isFinite(A)? toDisplayLen(A) : NaN;
    const writeF = isFinite(fHz)? fromHertzToUnit(fHz, FUnit.value) : NaN;
    if(aid!=='ae_A' && isFinite(writeA)) (document.getElementById('ae_A')||{}).value = writeA.toFixed(6);
    if(aid!=='ae_f' && isFinite(writeF)) (document.getElementById('ae_f')||{}).value = writeF.toFixed(6);
    if(aid!=='ae_E' && isFinite(Ecalc)) (document.getElementById('ae_E')||{}).value = Ecalc.toFixed(6);
    // Output spans
    const setSpan=(id, text)=>{ const el=document.getElementById(id); if(el) el.textContent = text; };
    setSpan('ae_w_o', isFinite(w)? w.toFixed(4): '–');
    const v_out = isFinite(vmax)? vmax : (typeof vmaxCalc!=='undefined'? vmaxCalc: NaN);
    if(isFinite(v_out)){
      const vdisp = toDisplayLen(v_out) * secondsPerDisplayUnit();
      setSpan('ae_vmax_o', trimFloat(vdisp)+' '+AUnit.value+'/'+timeUnitLabelShort());
    } else setSpan('ae_vmax_o','–');
    const a_out = isFinite(amax)? amax : (typeof amaxCalc!=='undefined'? amaxCalc: NaN);
    if(isFinite(a_out)){
      const adisp = toDisplayLen(a_out) * secondsPerDisplayUnit() * secondsPerDisplayUnit();
      setSpan('ae_amax_o', trimFloat(adisp)+' '+AUnit.value+'/'+timeUnitLabelShort()+'²');
    } else setSpan('ae_amax_o','–');
    setSpan('ae_E_o', isFinite(Ecalc)? trimFloat(Ecalc) : '–');
    // Show/hide L
    const grpL = document.getElementById('grpAE_L'); if(grpL) grpL.style.display = (modeAE==='pend_small' || modeAE==='pend_large')? '' : 'none';
  } finally { calcUpdating=false; } }

  function showInstant(md, p){
    // compute at user-specified t in selected time unit
    const tInput = parseFloat((document.getElementById('t_val')||{}).value)||0;
    const tSec = fromDisplayTime(tInput);
    let y=NaN, v=NaN, a=NaN;
    if(md==='spring'){
      const w = 2*Math.PI*p.f;
      y = p.A*Math.cos(w*tSec);
      v = -p.A*w*Math.sin(w*tSec);
      a = -w*w*y;
    } else if(md==='pendulum'){
      const w = 2*Math.PI*p.f;
      y = p.A*Math.cos(w*tSec);
      v = -p.A*w*Math.sin(w*tSec);
      a = -w*w*y;
    } else if(md==='spring-damped' || md==='spring-driven' || md==='pendulum-large'){
      const st = stateAt(md, p, tSec);
      if(md.startsWith('spring')){
        y = st.x; v = st.v;
        const m=p.m||1, k=(p.k>0)?p.k:((2*Math.PI*(p.f||0))**2*(p.m||1));
        const c=(md!=='spring')?(p.c||0):0; const F0=(md==='spring-driven')?(p.F0||0):0; const wD = 2*Math.PI*(p.fd||0);
        a = (-c*v - k*y + F0*Math.cos(wD*tSec))/m;
      } else { // pendulum-large
        const theta=st.theta, omega=st.omega; y = p.L*Math.sin(theta); v = p.L*omega*Math.cos(theta);
        a = -9.81*Math.sin(theta); // angular acceleration * L cos? report along arc approx: use horizontal small-angle approx
        // convert a to linear along small-angle x-axis: a_x ≈ - (g/L) y
        a = -(9.81/(p.L||1))*y;
      }
    }
    const lenFmt = (m)=> toDisplayLen(m) + ' ' + AUnit.value;
    const vFmt = (mps)=> toDisplayLen(mps)*secondsPerDisplayUnit() + ' ' + AUnit.value + '/' + timeUnitLabelShort();
    const aFmt = (mps2)=> toDisplayLen(mps2)*secondsPerDisplayUnit()*secondsPerDisplayUnit() + ' ' + AUnit.value + '/' + timeUnitLabelShort() + '²';
    const setText=(id,val,fmt)=>{ const el=document.getElementById(id); if(!el) return; el.textContent = (val==null||!isFinite(val))? '–' : fmt(val).toString(); };
    setText('out_y_t', y, lenFmt);
    setText('out_v_t', v, vFmt);
    setText('out_a_t', a, aFmt);
  }

  function secondsPerDisplayUnit(){
    const conv = { s:1, min:60, hr:3600, day:86400, week:604800, month:2592000, year:31536000 };
    return conv[tUnit.value]||1;
  }
  function timeUnitLabelShort(){
    const map = { s:'s', min:'min', hr:'hr', day:'day', week:'week', month:'month', year:'year' };
    return map[tUnit.value]||'s';
  }
  function toDisplayLen(m){
    // convert meters to selected AUnit
    const map = { m:1, cm:100, mm:1000, um:1e6, in:39.37007874, ft:3.280839895 };
    return m * (map[AUnit.value]||1);
  }
  function fromDisplayTime(tDisplay){
    // convert from selected unit to seconds
    return tDisplay * secondsPerDisplayUnit();
  }

  function startLoop() {
    if (rafId == null) {
      rafId = requestAnimationFrame(step);
    }
  }

  $('btnRun').addEventListener('click', run);
  ['input', 'change'].forEach((ev) => {
    [mode, AEl, AUnit, fEl, FUnit, mEl, kEl, cEl, F0El, fdEl, LEl, AangEl, AangUnit, tUnit, useKM].forEach((el) => el.addEventListener(ev, ()=>{ if(autoRun && autoRun.checked){ run(); } else { pending=true; } }));
    const tVal = document.getElementById('t_val');
    if(tVal) tVal.addEventListener(ev, ()=> params && showInstant(mode.value, params));
  });

  // Mode tabs
  document.querySelectorAll('#modeTabs a.nav-link').forEach(a=>{
    a.addEventListener('click', (e)=>{ e.preventDefault(); document.querySelectorAll('#modeTabs a').forEach(x=>x.classList.remove('active')); a.classList.add('active'); mode.value=a.getAttribute('data-mode'); if(autoRun && autoRun.checked){ run(); } else { pending=true; updateVisibility(); } });
  });

  // Output tabs
  document.querySelectorAll('#outTabs a.nav-link').forEach(a=>{
    a.addEventListener('click', (e)=>{
      e.preventDefault(); document.querySelectorAll('#outTabs a').forEach(x=>x.classList.remove('active')); a.classList.add('active');
      const pane=a.getAttribute('data-pane');
      ['time','phase','energy','instant','calc'].forEach(p=>{ const el=document.getElementById('pane_'+p); if(el) el.style.display = (p===pane)? '' : 'none'; });
    });
  });

  // Presets
  document.querySelectorAll('#presetBtn ~ .dropdown-menu a[data-preset]').forEach(item=>{
    item.addEventListener('click', (e)=>{
      e.preventDefault(); const p=item.getAttribute('data-preset');
      const hint = document.getElementById('presetHint');
      if(p==='spring-basic'){ mode.value='spring'; AEl.value='0.1'; fEl.value='1'; useKM.checked=false; if(hint) hint.textContent='Basic undamped spring: A=0.1 m, f=1 Hz.'; }
      if(p==='damped-light'){ mode.value='spring-damped'; mEl.value='1'; kEl.value='4'; cEl.value='0.2'; AEl.value='0.1'; useKM.checked=true; if(hint) hint.textContent='Light damping (ζ≈0.05): slow decay, clear sinusoid.'; }
      if(p==='damped-heavy'){ mode.value='spring-damped'; mEl.value='1'; kEl.value='4'; cEl.value='5.0'; AEl.value='0.1'; useKM.checked=true; if(hint) hint.textContent='Heavy damping (overdamped): no oscillations, slow return.'; }
      if(p==='driven-resonance'){ mode.value='spring-driven'; mEl.value='1'; kEl.value='4'; cEl.value='0.1'; AEl.value='0.05'; useKM.checked=true; const f0=Math.sqrt(4/1)/(2*Math.PI); fdEl.value=f0.toFixed(3); F0El.value='1'; if(hint) hint.textContent='Driven at resonance (fd≈f0): large steady amplitude, 90° phase shift.'; }
      if(p==='driven-near'){ mode.value='spring-driven'; mEl.value='1'; kEl.value='4'; cEl.value='0.05'; AEl.value='0.05'; useKM.checked=true; const f0=Math.sqrt(4/1)/(2*Math.PI); fdEl.value=(f0*1.05).toFixed(3); F0El.value='0.5'; if(hint) hint.textContent='Near resonance (fd≈f0±5%): noticeable amplitude with beats during transient.'; }
      if(p==='pend-small'){ mode.value='pendulum'; AEl.value='0.1'; fEl.value='1'; if(hint) hint.textContent='Small-angle pendulum: period set by f; mass independent.'; }
      if(p==='pend-large'){ mode.value='pendulum-large'; AangEl.value='0.5'; LEl.value='1'; if(hint) hint.textContent='Large-angle pendulum (nonlinear): period depends on amplitude.'; }
      if(autoRun && autoRun.checked) run(); else { updateVisibility(); }
    });
  });

  // Reset
  const resetBtn = document.getElementById('btnReset');
  if(resetBtn){ resetBtn.addEventListener('click', ()=>{ location.href = location.pathname; }); }

  // Units modal wiring
  // Modal markup is defined below; copy values on open and save back on confirm
  if (window.jQuery) {
    window.jQuery('#unitsModal').on('show.bs.modal', function(){
      window.jQuery('#u_A').val(AUnit.value);
      window.jQuery('#u_f').val(FUnit.value);
      window.jQuery('#u_Aang').val(AangUnit.value);
      window.jQuery('#u_t').val(tUnit.value);
    });
  }
  document.getElementById('btnUnitsSave').addEventListener('click', function(){
    AUnit.value = document.getElementById('u_A').value;
    FUnit.value = document.getElementById('u_f').value;
    AangUnit.value = document.getElementById('u_Aang').value;
    tUnit.value = document.getElementById('u_t').value;
    if (window.jQuery && window.jQuery.fn && window.jQuery.fn.modal) {
      window.jQuery('#unitsModal').modal('hide');
    }
    if(autoRun && autoRun.checked){ run(); } else { computeDerivedChips(); showInstant(mode.value, params||{}); }
  });

  function computeDerivedChips(){
    // lightweight chips for T, ω, f0
    const md = mode.value;
    const A_in = parseFloat(AEl.value)||0; const f_in = parseFloat(fEl.value)||0;
    const A = toMeters(A_in, AUnit.value); // currently unused in chips
    const f = toHertz(f_in, FUnit.value);
    const m = parseFloat(mEl.value)||NaN; const k = parseFloat(kEl.value)||NaN;
    const L = parseFloat(LEl.value)||NaN; const g=9.81;
    let T = isFinite(f)&&f>0? (1/f): NaN;
    let w = isFinite(f)? 2*Math.PI*f : NaN;
    let f0 = NaN;
    if(md.startsWith('spring')){
      if(isFinite(k)&&isFinite(m)&&m>0){ f0 = Math.sqrt(k/m)/(2*Math.PI); }
      else if(isFinite(f)){ f0 = f; }
    } else if(md==='pendulum'){
      if(isFinite(f)) f0=f;
    } else if(md==='pendulum-large'){
      if(isFinite(L)&&L>0) f0 = Math.sqrt(g/L)/(2*Math.PI);
    }
    // display with selected time unit
    const fmtT = (sec)=>{ if(!isFinite(sec)) return '–'; const disp = convertTime(sec); return (Math.abs(disp)>=1? disp.toFixed(3): disp.toExponential(2)) + ' ' + timeUnitLabelShort(); };
    const fmtNum = (x)=> !isFinite(x)? '–' : (Math.abs(x)>=1? x.toFixed(3): x.toExponential(2));
    const chipT = document.getElementById('chip_T'); if(chipT) chipT.textContent = fmtT(T||NaN);
    const chipW = document.getElementById('chip_w'); if(chipW) chipW.textContent = fmtNum(w||NaN);
    const chipF0 = document.getElementById('chip_f0'); if(chipF0) chipF0.textContent = fmtNum(f0||NaN);
  }

  // Update chips on input changes even if Auto is off
  [AEl, fEl, mEl, kEl, LEl].forEach(el=> el&&el.addEventListener('input', computeDerivedChips));
  computeDerivedChips();
  // Save images and share URL
  $('btnSaveOscImg').addEventListener('click', ()=>{
    try{
      const url = osc.toDataURL('image/png');
      const a=document.createElement('a'); a.href=url; a.download='shm-animation.png'; a.click();
    }catch(e){ alert('Unable to save image.'); }
  });
  $('btnSaveXImg').addEventListener('click', ()=>{
    try{
      const canvas = document.getElementById('chartX');
      const url = canvas.toDataURL('image/png');
      const a=document.createElement('a'); a.href=url; a.download='shm-x.png'; a.click();
    }catch(e){ alert('Unable to save image.'); }
  });
  $('btnSaveVImg').addEventListener('click', ()=>{
    try{
      const canvas = document.getElementById('chartV');
      const url = canvas.toDataURL('image/png');
      const a=document.createElement('a'); a.href=url; a.download='shm-v.png'; a.click();
    }catch(e){ alert('Unable to save image.'); }
  });
  $('btnShareShm').addEventListener('click', async ()=>{
    const params=new URLSearchParams({ mode: mode.value, A: AEl.value, A_u: AUnit.value, f: fEl.value, f_u: FUnit.value, m: mEl.value, k: kEl.value, c: cEl.value, F0: F0El.value, fd: fdEl.value, L: LEl.value, Aang: AangEl.value, Aang_u: AangUnit.value, t_u: tUnit.value, useKM: useKM.checked? '1':'0' });
    const shareUrl = `${location.origin}${location.pathname}?${params.toString()}`;
    try{ await navigator.clipboard.writeText(shareUrl); alert('Share URL copied to clipboard'); }
    catch(e){ prompt('Copy this URL', shareUrl); }
  });

  try {
    updateVisibility();
    // reset state
    state = { x: 0, v: 0, theta: 0, omega: 0, t: 0 };
    run();
    startLoop();
    // calculator buttons
    const b1=document.getElementById('btnCalcFTW'); if(b1) b1.addEventListener('click', calcFTW);
    const b2=document.getElementById('btnCalcSpring'); if(b2) b2.addEventListener('click', calcSpring);
    const b3=document.getElementById('btnCalcPend'); if(b3) b3.addEventListener('click', calcPendulum);

    // Dynamic calculator listeners
    const cf=document.getElementById('calc_f'), cfu=document.getElementById('calc_f_u'), cT=document.getElementById('calc_T'), cTu=document.getElementById('calc_T_u'), cw=document.getElementById('calc_w');
    if(cf){ cf.addEventListener('input', ()=>{ calcFTWLast='f'; autoCalcFTW(); }); }
    if(cfu){ cfu.addEventListener('change', ()=>{ calcFTWLast='f'; autoCalcFTW(); }); }
    if(cT){ cT.addEventListener('input', ()=>{ calcFTWLast='T'; autoCalcFTW(); }); }
    if(cTu){ cTu.addEventListener('change', ()=>{ calcFTWLast='T'; autoCalcFTW(); }); }
    if(cw){ cw.addEventListener('input', ()=>{ calcFTWLast='w'; autoCalcFTW(); }); }

    const cm=document.getElementById('calc_m'), ck=document.getElementById('calc_k'), cf2=document.getElementById('calc_f2'), cf2u=document.getElementById('calc_f2_u');
    if(cm){ cm.addEventListener('input', ()=>{ calcSpringLast='m'; autoCalcSpring(); }); }
    if(ck){ ck.addEventListener('input', ()=>{ calcSpringLast='k'; autoCalcSpring(); }); }
    if(cf2){ cf2.addEventListener('input', ()=>{ calcSpringLast='f'; autoCalcSpring(); }); }
    if(cf2u){ cf2u.addEventListener('change', ()=>{ calcSpringLast='f'; autoCalcSpring(); }); }

    const cL=document.getElementById('calc_L'), cf3=document.getElementById('calc_f3'), cf3u=document.getElementById('calc_f3_u'), cT2=document.getElementById('calc_T2'), cT2u=document.getElementById('calc_T2_u');
    if(cL){ cL.addEventListener('input', ()=>{ calcPendLast='L'; autoCalcPendulum(); }); }
    if(cf3){ cf3.addEventListener('input', ()=>{ calcPendLast='f'; autoCalcPendulum(); }); }
    if(cf3u){ cf3u.addEventListener('change', ()=>{ calcPendLast='f'; autoCalcPendulum(); }); }
    if(cT2){ cT2.addEventListener('input', ()=>{ calcPendLast='T'; autoCalcPendulum(); }); }
    if(cT2u){ cT2u.addEventListener('change', ()=>{ calcPendLast='T'; autoCalcPendulum(); }); }

    // Amplitude & Energy listeners
    updateAEUnitLabels();
    const ae = (id)=> document.getElementById(id);
    ['ae_mode','ae_A','ae_f','ae_m','ae_k','ae_L','ae_E','ae_vmax','ae_amax'].forEach(id=>{ const el=ae(id); if(el){ const ev = (id==='ae_mode')? 'change':'input'; el.addEventListener(ev, autoCalcAE); }});
    // Recompute when global units change
    [AUnit, FUnit, tUnit].forEach(el=> el && el.addEventListener('change', ()=>{ updateAEUnitLabels(); autoCalcAE(); }));
    autoCalcAE();

    const btnCopy = document.getElementById('btnAECopy');
    if(btnCopy){ btnCopy.addEventListener('click', async ()=>{
      const Au=AUnit.value, fu=freqUnitLabel(FUnit.value), tu=timeUnitLabelShort();
      const A=document.getElementById('ae_A')?.value||'';
      const f=document.getElementById('ae_f')?.value||'';
      const w=document.getElementById('ae_w_o')?.textContent||'';
      const vmax=document.getElementById('ae_vmax_o')?.textContent||'';
      const amax=document.getElementById('ae_amax_o')?.textContent||'';
      const E=document.getElementById('ae_E_o')?.textContent||'';
      const lines=[
        `A: ${A} ${Au}`,
        `f: ${f} ${fu}`,
        `ω: ${w} rad/s`,
        `vmax: ${vmax}`,
        `amax: ${amax}`,
        `E: ${E} J`
      ];
      const text=lines.join('\n');
      try{ await navigator.clipboard.writeText(text); alert('Copied results to clipboard'); }
      catch(e){ prompt('Copy results', text); }
    }); }
  } catch (e) {
    console.error('SHM oscillator init error', e);
  }
})();
</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<!-- E-E-A-T: About & Learning Outcomes (Physics) -->
<section class="container my-4"><div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
  <h2 class="h6 mb-2">About This Tool & Methodology</h2>
  <p>Models simple harmonic motion (mass–spring or pendulum approximations) using SI units to compute period, frequency, displacement, velocity, and acceleration as functions of time.</p>
  <h3 class="h6 mt-2">Learning Outcomes</h3>
  <ul class="mb-2"><li>Relate period/frequency to system parameters (m, k, L, g).</li><li>Understand phase relationships among x, v, a.</li><li>Practice units and small‑angle approximations where relevant.</li></ul>
  <div class="row mt-2"><div class="col-md-6"><h4 class="h6">Authorship</h4><ul><li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">Anish Nath</a> — Follow on X</li><li><strong>Last updated:</strong> 2025-11-19</li></ul></div><div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul><li>Runs locally in your browser.</li></ul></div></div>
</div></div></div></div></section>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"WebPage","name":"SHM Oscillator","url":"https://8gwifi.org/shm-oscillator.jsp","dateModified":"2025-11-19","author":{"@type":"Person","name":"Anish Nath","url":"https://x.com/anish2good"},"publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"SHM Oscillator","item":"https://8gwifi.org/shm-oscillator.jsp"}]}
</script>
<%@ include file="addcomments.jsp"%>

</div>
<%@ include file="body-close.jsp"%>
