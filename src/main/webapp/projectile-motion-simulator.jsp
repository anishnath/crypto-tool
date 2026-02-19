<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Projectile Motion Calculator & Simulator - Free Online" />
        <jsp:param name="toolDescription" value="Free projectile motion calculator and simulator. Find range, time of flight, max height with air resistance. 30+ presets for sports and planets. Step-by-step physics formulas and guided experiments for students." />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolUrl" value="projectile-motion-simulator.jsp" />
        <jsp:param name="toolKeywords" value="projectile motion calculator, projectile motion simulator, trajectory calculator, projectile motion formula calculator, range of projectile calculator, time of flight calculator, maximum height projectile calculator, kinematics calculator, physics projectile motion solver, projectile motion with air resistance, horizontal projectile motion calculator, parabolic motion calculator, launch angle calculator, free physics simulator online, projectile motion equations solver" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Projectile trajectory visualization,Range and time of flight calculator,Air resistance simulation with drag coefficient,30+ sports and object presets,Multi-planet gravity simulation,Real-time velocity and energy charts,Interactive canvas with draggable targets,Basketball baseball golf soccer physics,Moon and Mars gravity scenarios,Step-by-step formula reference and guided experiments" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="How do I calculate projectile motion range and time of flight?" />
        <jsp:param name="faq1a" value="Enter the initial velocity (m/s), launch angle (degrees), and starting height. Select a gravity preset (Earth, Moon, Mars, etc.) or enter custom gravity. Click Launch to calculate range, time of flight, maximum height, and final velocity. The trajectory is displayed on an interactive canvas with real-time physics simulation." />
        <jsp:param name="faq2q" value="Does this simulator include air resistance and drag?" />
        <jsp:param name="faq2a" value="Yes! Toggle the Air Resistance checkbox to enable quadratic drag simulation. Adjust air density, drag coefficient, cross-sectional area, and mass. Choose from 15+ object presets: tennis ball, baseball, basketball, soccer ball, golf ball, arrow, frisbee, feather, balloon, and more. Each preset uses real-world physics parameters." />
        <jsp:param name="faq3q" value="Can I simulate projectile motion on other planets?" />
        <jsp:param name="faq3a" value="Absolutely! Select from 17 celestial bodies: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune, Moon, Europa, Titan, Pluto, Ceres, Sun, and White Dwarf. Each has accurate surface gravity values. Try the Moon Golf scenario to see how a golf ball travels 400+ meters in lunar gravity!" />
        <jsp:param name="faq4q" value="What projectile motion formulas does this calculator use?" />
        <jsp:param name="faq4a" value="Without air resistance: Range R = v0^2 sin(2theta) / g, Time of Flight T = 2v0 sin(theta) / g, Max Height H = v0^2 sin^2(theta) / (2g). With air resistance: Euler numerical integration (dt=0.005s) solves quadratic drag F = 0.5 rho Cd A v^2. The formula reference panel shows all equations with explanations." />
        <jsp:param name="faq5q" value="How accurate is the projectile motion calculator?" />
        <jsp:param name="faq5a" value="Very accurate! Without air resistance, we use closed-form kinematics equations for exact results. With air resistance enabled, we use Euler numerical integration with small time steps (dt=0.005s) to solve the differential equations. All object presets use real-world values for mass, drag coefficient, and cross-sectional area from physics literature." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/projectile-motion.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- Math.js for equations -->
    <script data-cfasync="false" src="https://cdn.jsdelivr.net/npm/mathjs@11.8.2/lib/browser/math.js"></script>
    <!-- Chart.js for plotting -->
    <script data-cfasync="false" src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<!-- ==================== PAGE HEADER ==================== -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Projectile Motion Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/index.jsp">Physics Tools</a> /
                Projectile Motion Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">Interactive</span>
            <span class="tool-badge">30+ Presets</span>
        </div>
    </div>
</header>

<!-- ==================== DESCRIPTION ==================== -->
<section class="tool-description-section" style="background:var(--pm-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>projectile motion calculator</strong> with trajectory visualization. Calculate <strong>range, time of flight, maximum height</strong> with or without <strong>air resistance</strong>. 30+ presets for basketball, golf, baseball, Moon/Mars physics.</p>
        </div>
    </div>
</section>

<!-- ==================== THREE-COLUMN LAYOUT ==================== -->
<main class="tool-page-container pm-page-container pm">

    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">

        <!-- Hidden inputs for internal logic (engine IIFE references these by ID) -->
        <div style="display:none" aria-hidden="true">
            <select id="preset">
                <option value="mercury">Mercury</option>
                <option value="venus">Venus</option>
                <option value="earth" selected>Earth</option>
                <option value="mars">Mars</option>
                <option value="jupiter">Jupiter</option>
                <option value="saturn">Saturn</option>
                <option value="uranus">Uranus</option>
                <option value="neptune">Neptune</option>
                <option value="moon">Moon</option>
                <option value="europa">Europa</option>
                <option value="titan">Titan</option>
                <option value="pluto">Pluto</option>
                <option value="ceres">Ceres</option>
                <option value="sun">Sun</option>
                <option value="whitedwarf">White Dwarf</option>
                <option value="custom">Custom</option>
            </select>
            <input id="v0" type="number" value="25">
            <input id="angle" type="number" value="45">
            <input id="y0" type="number" value="0">
            <input id="g" type="number" value="9.81">
            <input id="scale" type="number" value="4">
            <input id="dragOn" type="checkbox">
            <input id="rho" type="number" value="1.225">
            <input id="cd" type="number" value="0.47">
            <input id="area" type="number" value="0.01">
            <input id="mass" type="number" value="0.2">
            <button id="btnClear">Clear</button>
            <div id="err"></div>
        </div>

        <!-- Controls Card -->
        <div class="pm-dock">
            <h5 class="pm-dock-header">Controls</h5>
            <div class="form-group">
                <label for="dockAngle">Angle &theta; <span class="pm-tip" data-tip="Launch angle above horizontal. 0&deg; = flat, 90&deg; = straight up." title="Launch angle above horizontal. 0° = flat, 90° = straight up.">?</span></label>
                <input id="dockAngle" type="range" min="0" max="90" value="45" class="form-control-range">
            </div>
            <div class="form-group">
                <label for="dockV0">Speed v&#8320; (m/s) <span class="pm-tip" data-tip="Initial speed. Decomposed into v&#8320;cos(&theta;) horizontal and v&#8320;sin(&theta;) vertical." title="Initial speed. Decomposed into v₀cos(θ) horizontal and v₀sin(θ) vertical.">?</span></label>
                <input id="dockV0" type="range" min="1" max="100" value="25" class="form-control-range">
            </div>
            <div class="form-group">
                <label for="dockY0">Height y&#8320; (m) <span class="pm-tip" data-tip="Starting height above ground. Release height is ~2 m for a person." title="Starting height above ground. Release height is ~2 m for a person.">?</span></label>
                <input id="dockY0" type="number" min="0" step="0.1" class="form-control form-control-sm" value="0">
            </div>
            <div class="form-group">
                <label for="dockPreset">Gravity Preset <span class="pm-tip" data-tip="Surface gravity of the body. Determines fall rate." title="Surface gravity of the body. Determines fall rate.">?</span></label>
                <select id="dockPreset" class="form-control form-control-sm">
                    <optgroup label="Terrestrial Planets">
                        <option value="mercury">Mercury (3.7 m/s&sup2;)</option>
                        <option value="venus">Venus (8.87 m/s&sup2;)</option>
                        <option value="earth" selected>Earth (9.81 m/s&sup2;)</option>
                        <option value="mars">Mars (3.71 m/s&sup2;)</option>
                    </optgroup>
                    <optgroup label="Gas Giants">
                        <option value="jupiter">Jupiter (24.79 m/s&sup2;)</option>
                        <option value="saturn">Saturn (10.44 m/s&sup2;)</option>
                        <option value="uranus">Uranus (8.87 m/s&sup2;)</option>
                        <option value="neptune">Neptune (11.15 m/s&sup2;)</option>
                    </optgroup>
                    <optgroup label="Moons &amp; Dwarf Planets">
                        <option value="moon">Moon (1.62 m/s&sup2;)</option>
                        <option value="europa">Europa (1.31 m/s&sup2;)</option>
                        <option value="titan">Titan (1.35 m/s&sup2;)</option>
                        <option value="pluto">Pluto (0.62 m/s&sup2;)</option>
                        <option value="ceres">Ceres (0.27 m/s&sup2;)</option>
                    </optgroup>
                    <optgroup label="Extreme">
                        <option value="sun">Sun (274 m/s&sup2;)</option>
                        <option value="whitedwarf">White Dwarf (3&times;10&sup6; m/s&sup2;)</option>
                    </optgroup>
                    <optgroup label="Custom">
                        <option value="custom">Custom Gravity...</option>
                    </optgroup>
                </select>
            </div>
            <div class="form-group">
                <label for="dockG">g Gravity (m/s&sup2;) <span class="pm-tip" data-tip="Acceleration due to gravity. Earth = 9.81." title="Acceleration due to gravity. Earth = 9.81.">?</span></label>
                <input id="dockG" type="number" min="0" step="0.01" class="form-control form-control-sm" value="9.81" disabled>
            </div>
            <div class="form-group">
                <label for="dockScale">Scale (m&rarr;px) <span class="pm-tip" data-tip="Pixels per meter on canvas. Larger = more zoomed in." title="Pixels per meter on canvas. Larger = more zoomed in.">?</span></label>
                <input id="dockScale" type="number" min="0.1" step="0.1" class="form-control form-control-sm" value="4">
            </div>
            <div class="form-group form-check">
                <input class="form-check-input" type="checkbox" id="dockAutoScale" checked>
                <label class="form-check-label" for="dockAutoScale">Auto-adjust Scale</label>
            </div>
            <div class="form-group form-check">
                <input class="form-check-input" type="checkbox" id="dockDragOn">
                <label class="form-check-label" for="dockDragOn">Air Resistance
                    <small style="color:#94a3b8;font-weight:400">(toggle to configure)</small>
                </label>
            </div>

            <!-- Air Resistance Parameters (hidden by default) -->
            <div id="dragCfg" class="pm-adv" style="display:none">
                <small style="display:block;margin-bottom:.4rem;color:#667eea;font-weight:600;font-size:.8rem">
                    Air Resistance Parameters
                </small>
                <div class="form-group">
                    <label for="rhoRange">&rho; Air Density (kg/m&sup3;) <span class="pm-tip" data-tip="Mass of air per volume. Decreases at altitude, reducing drag." title="Mass of air per volume. Decreases at altitude, reducing drag.">?</span>: <span id="rhoValue" style="color:#667eea;font-weight:700">1.225</span></label>
                    <input id="rhoRange" type="range" min="0.1" max="2" step="0.01" value="1.225" class="form-control-range">
                    <small style="color:#94a3b8;font-size:.72rem">Sea level: 1.225 | High altitude: ~0.7</small>
                </div>
                <div class="form-group">
                    <label for="cdRange">C<sub>d</sub> Drag Coefficient <span class="pm-tip" data-tip="Shape constant. Sphere = 0.47; streamlined = lower." title="Shape constant. Sphere = 0.47; streamlined = lower.">?</span>: <span id="cdValue" style="color:#667eea;font-weight:700">0.47</span></label>
                    <input id="cdRange" type="range" min="0.04" max="2" step="0.01" value="0.47" class="form-control-range">
                    <small style="color:#94a3b8;font-size:.72rem">Sphere: 0.47 | Streamlined: 0.04 | Cube: 1.05</small>
                </div>
                <div class="form-group">
                    <label for="areaRange">A Cross-section (m&sup2;) <span class="pm-tip" data-tip="Frontal area facing airflow. Larger area = more drag." title="Frontal area facing airflow. Larger area = more drag.">?</span>: <span id="areaValue" style="color:#667eea;font-weight:700">0.01</span></label>
                    <input id="areaRange" type="range" min="0.001" max="0.1" step="0.001" value="0.01" class="form-control-range">
                    <small style="color:#94a3b8;font-size:.72rem">Tennis ball: 0.0034 | Basketball: 0.045</small>
                </div>
                <div class="form-group">
                    <label for="massRange">m Mass (kg) <span class="pm-tip" data-tip="Object mass. Heavier = less affected by drag (higher inertia)." title="Object mass. Heavier = less affected by drag (higher inertia).">?</span>: <span id="massValue" style="color:#667eea;font-weight:700">0.2</span></label>
                    <input id="massRange" type="range" min="0.01" max="500" step="0.01" value="0.2" class="form-control-range">
                    <small style="color:#94a3b8;font-size:.72rem">Tennis ball: 0.06 | Baseball: 0.145 | Basketball: 0.6</small>
                </div>

                <!-- Object Presets -->
                <div style="margin-top:.5rem;border-top:1px solid #e2e8f0;padding-top:.5rem">
                    <small style="display:block;margin-bottom:.3rem;color:#64748b;font-weight:600;font-size:.75rem">Quick Object Presets:</small>
                    <div style="display:flex;gap:.3rem;flex-wrap:wrap;margin-bottom:.4rem">
                        <button class="btn btn-sm air-preset" id="presetTennis" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Tennis</button>
                        <button class="btn btn-sm air-preset" id="presetBaseball" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Baseball</button>
                        <button class="btn btn-sm air-preset" id="presetBasketball" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Basketball</button>
                        <button class="btn btn-sm air-preset" id="presetFeather" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Feather</button>
                    </div>
                    <div style="display:flex;gap:.3rem;flex-wrap:wrap;margin-bottom:.4rem">
                        <button class="btn btn-sm air-preset" id="presetSoccer" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Soccer</button>
                        <button class="btn btn-sm air-preset" id="presetGolf" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Golf</button>
                        <button class="btn btn-sm air-preset" id="presetVolleyball" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Volleyball</button>
                        <button class="btn btn-sm air-preset" id="presetPingPong" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Ping Pong</button>
                    </div>
                    <div style="display:flex;gap:.3rem;flex-wrap:wrap;margin-bottom:.4rem">
                        <button class="btn btn-sm air-preset" id="presetArrow" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Arrow</button>
                        <button class="btn btn-sm air-preset" id="presetFrisbee" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Frisbee</button>
                        <button class="btn btn-sm air-preset" id="presetPaper" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Paper</button>
                        <button class="btn btn-sm air-preset" id="presetBalloon" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Balloon</button>
                    </div>
                    <div style="display:flex;gap:.3rem;flex-wrap:wrap">
                        <button class="btn btn-sm air-preset" id="presetCannonball" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Cannonball</button>
                        <button class="btn btn-sm air-preset" id="presetWatermelon" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Watermelon</button>
                        <button class="btn btn-sm air-preset" id="presetBeachBall" style="font-size:.7rem;padding:.2rem .4rem;background:#f1f5f9;border:1px solid #cbd5e1;color:#475569">Beach Ball</button>
                    </div>
                </div>
                <small style="display:block;margin-top:.4rem;color:#64748b;font-size:.75rem;text-align:center;font-style:italic">
                    Drag sliders or click presets
                </small>
            </div>

            <!-- Scenario Presets -->
            <div class="form-group" style="margin-top:.6rem;padding-top:.6rem;border-top:2px solid #e2e8f0">
                <label for="scenarioPreset" style="font-weight:700;color:#667eea;font-size:.85rem">Fun Scenarios</label>
                <select id="scenarioPreset" class="form-control form-control-sm">
                    <option value="">-- Select a Scenario --</option>
                    <optgroup label="Sports Challenges">
                        <option value="freethrow">Basketball Free Throw</option>
                        <option value="soccer-goal">Soccer Goal Kick</option>
                        <option value="golf-drive">Golf Perfect Drive</option>
                        <option value="homerun">Baseball Home Run</option>
                    </optgroup>
                    <optgroup label="Space Adventures">
                        <option value="moon-golf">Moon Golf Record</option>
                        <option value="mars-jump">Mars Rover Jump</option>
                        <option value="europa-iceball">Europa Ice Ball</option>
                        <option value="titan-fall">Titan Parachute Drop</option>
                    </optgroup>
                    <optgroup label="Historical">
                        <option value="trebuchet">Medieval Trebuchet</option>
                        <option value="cannon">Napoleon's Cannon</option>
                        <option value="archery">Olympic Archery</option>
                    </optgroup>
                    <optgroup label="Extreme &amp; Fun">
                        <option value="angry-birds">Angry Birds Classic</option>
                        <option value="superhero">Superhero Throw</option>
                        <option value="everest">Everest Summit Throw</option>
                        <option value="white-dwarf">White Dwarf Gravity</option>
                    </optgroup>
                </select>
                <small style="color:#94a3b8;font-size:.72rem;display:block;margin-top:.2rem">
                    Pre-configured challenges with targets
                </small>
            </div>

            <div class="form-group form-check">
                <input class="form-check-input" type="checkbox" id="dockKeep" checked>
                <label class="form-check-label" for="dockKeep">Keep Shots</label>
            </div>
            <div class="form-group form-check">
                <input class="form-check-input" type="checkbox" id="dockVectors">
                <label class="form-check-label" for="dockVectors">Show Components</label>
            </div>
            <div class="pm-mini">
                <button class="btn btn-success btn-sm" id="dockLaunch">Launch</button>
                <button class="btn btn-outline-secondary btn-sm" id="dockResetShots">Reset Shots</button>
            </div>
            <div class="pm-mini" style="margin-top:.5rem">
                <button class="btn btn-outline-secondary btn-sm" id="btnSaveImage" style="flex:1">Save Image</button>
                <button class="btn btn-outline-secondary btn-sm" id="btnShareLink" style="flex:1">Share Link</button>
            </div>
            <div class="pm-comparison-tip">
                <strong>Compare shots:</strong> Enable <em>Keep Shots</em> to overlay trajectories. Turn on <em>Overlay</em> in the toolbar to see drag vs no-drag. Use the <em>Scrubber</em> to replay any shot frame-by-frame. Drag from the cannon to set v and &theta; directly.
            </div>
        </div>

        <!-- Live State Card -->
        <div class="tool-card" style="margin-top:.75rem">
            <div class="tool-card-header" style="background:var(--pm-gradient);">Live State</div>
            <div class="tool-card-body">
                <div class="kv">
                    <div class="label">t</div><div class="value" id="hud_t">&ndash;</div>
                    <div class="label">x</div><div class="value" id="hud_x">&ndash;</div>
                    <div class="label">y</div><div class="value" id="hud_y">&ndash;</div>
                    <div class="label">v<sub>x</sub></div><div class="value" id="hud_vx">&ndash;</div>
                    <div class="label">v<sub>y</sub></div><div class="value" id="hud_vy">&ndash;</div>
                    <div class="label">|v|</div><div class="value" id="hud_v">&ndash;</div>
                    <div class="label">&theta;<sub>v</sub></div><div class="value" id="hud_th">&ndash;</div>
                </div>
            </div>
        </div>

        <!-- Results Card (annotated) -->
        <div class="tool-card" style="margin-top:.75rem">
            <div class="tool-card-header" style="background:var(--pm-gradient);">Results</div>
            <div class="tool-card-body">
                <div class="kv" id="resultsGrid">
                    <div class="label">Time of Flight</div><div class="value" id="res_t">&ndash;</div>
                    <div class="pm-learn-hint">Total airborne time, from launch to ground impact.</div>
                    <div class="label">Range</div><div class="value" id="res_r">&ndash;</div>
                    <div class="pm-learn-hint">Horizontal distance. Maximized at 45&deg; without drag.</div>
                    <div class="label">Max Height</div><div class="value" id="res_h">&ndash;</div>
                    <div class="pm-learn-hint">Highest point, where v<sub>y</sub> = 0 momentarily.</div>
                    <div class="label">Final Speed</div><div class="value" id="res_vf">&ndash;</div>
                    <div class="pm-learn-hint">Speed at impact. Without drag, equals launch speed when y&#8320; = 0 (energy conservation).</div>
                    <button class="pm-learn-toggle" id="btnToggleHints" type="button">Show explanations</button>
                </div>
            </div>
        </div>

        <!-- Formula Reference Panel -->
        <div class="pm-edu-card" id="panelFormulas">
            <button class="pm-edu-toggle" type="button" onclick="this.parentElement.classList.toggle('pm-open')">
                Formula Reference
                <svg class="pm-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="pm-edu-body">
                <div class="pm-formula-group">
                    <div class="pm-formula">
                        <div class="pm-formula-label">Range</div>
                        <code>R = v&#8320;&sup2; sin(2&theta;) / g</code>
                    </div>
                    <div class="pm-formula">
                        <div class="pm-formula-label">Time of Flight</div>
                        <code>T = 2v&#8320; sin(&theta;) / g</code>
                    </div>
                    <div class="pm-formula">
                        <div class="pm-formula-label">Max Height</div>
                        <code>H = v&#8320;&sup2; sin&sup2;(&theta;) / (2g)</code>
                    </div>
                    <div class="pm-formula">
                        <div class="pm-formula-label">Drag Force</div>
                        <code>F<sub>d</sub> = &frac12;&rho;C<sub>d</sub>Av&sup2;</code>
                        <div class="pm-formula-note">With drag, no closed-form exists &mdash; solved via Euler integration (dt = 0.005 s).</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Physics Tips Panel -->
        <div class="pm-edu-card" id="panelTips">
            <button class="pm-edu-toggle" type="button" onclick="this.parentElement.classList.toggle('pm-open')">
                Physics Tips
                <svg class="pm-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="pm-edu-body">
                <ul class="pm-tips-list">
                    <li><strong>45&deg; rule:</strong> Without drag and y&#8320; = 0, 45&deg; maximizes range. With a starting height, the optimal angle is slightly lower.</li>
                    <li><strong>Complementary angles:</strong> 30&deg; and 60&deg; give the same range (without drag). Try it!</li>
                    <li><strong>Drag shifts the optimal angle</strong> below 45&deg; &mdash; the faster you go, the more drag matters.</li>
                    <li><strong>Mass only matters with drag.</strong> In vacuum, a feather and cannonball follow the same path.</li>
                    <li><strong>Altitude reduces air density</strong> (&rho;), so there&rsquo;s less drag at high elevation (e.g., Everest Summit scenario).</li>
                    <li><strong>Energy conservation:</strong> Without drag, KE + PE stays constant. Drag dissipates energy as heat.</li>
                </ul>
            </div>
        </div>

        <!-- Guided Experiments Panel -->
        <div class="pm-edu-card" id="panelExperiments">
            <button class="pm-edu-toggle" type="button" onclick="this.parentElement.classList.toggle('pm-open')">
                Guided Experiments
                <svg class="pm-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="pm-edu-body">
                <div class="pm-experiment">
                    <div class="pm-experiment-title">1. Find the Optimal Angle</div>
                    <div class="pm-experiment-goal">Goal: Discover which angle gives maximum range.</div>
                    <ol class="pm-experiment-steps">
                        <li>Set speed to 25 m/s, drag OFF, Earth gravity.</li>
                        <li>Launch at 30&deg;, 45&deg;, and 60&deg; (keep shots on).</li>
                        <li>Compare the three ranges. Which is longest?</li>
                        <li>Now turn drag ON (Tennis preset). Repeat. Does the optimal angle change?</li>
                    </ol>
                </div>
                <div class="pm-experiment">
                    <div class="pm-experiment-title">2. Earth vs Moon</div>
                    <div class="pm-experiment-goal">Goal: See how gravity affects trajectory.</div>
                    <ol class="pm-experiment-steps">
                        <li>Launch at 45&deg;, 25 m/s on Earth. Note the range.</li>
                        <li>Switch gravity to Moon (1.62 m/s&sup2;). Launch again.</li>
                        <li>Compare: the Moon shot goes ~6&times; farther!</li>
                    </ol>
                </div>
                <div class="pm-experiment">
                    <div class="pm-experiment-title">3. Feather vs Cannonball</div>
                    <div class="pm-experiment-goal">Goal: Understand why mass matters with drag.</div>
                    <ol class="pm-experiment-steps">
                        <li>Turn drag ON. Select the Feather preset. Launch at 45&deg;.</li>
                        <li>Reset shots. Select Cannonball. Launch at same angle &amp; speed.</li>
                        <li>The cannonball goes much farther &mdash; its high mass resists drag.</li>
                    </ol>
                </div>
                <div class="pm-experiment">
                    <div class="pm-experiment-title">4. Energy Trade-off</div>
                    <div class="pm-experiment-goal">Goal: Watch KE and PE exchange in real time.</div>
                    <ol class="pm-experiment-steps">
                        <li>Click the <strong>Energy</strong> chart tab below the canvas.</li>
                        <li>Launch at 60&deg; with drag OFF. Watch KE dip at the apex as PE peaks.</li>
                        <li>Now turn drag ON and launch again. Notice energy is lost to drag.</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">

        <!-- Canvas Card -->
        <div class="tool-card pm-canvas-card">
            <div class="tool-card-header" style="background:var(--pm-gradient);">Trajectory</div>
            <div class="tool-card-body" style="padding:0;position:relative;">
                <div id="canvasWrap">
                    <div class="pm-toolbar">
                        <button class="btn btn-primary btn-sm" id="btnSim" title="Launch new simulation">Launch</button>
                        <button class="btn btn-outline-info btn-sm" id="btnPlay" title="Play/Pause animation">Play</button>
                        <label class="sr-only" for="speed">Speed</label>
                        <select id="speed" class="form-control">
                            <option value="0.25">0.25&times;</option>
                            <option value="0.5">0.5&times;</option>
                            <option value="1" selected>1&times;</option>
                            <option value="2">2&times;</option>
                            <option value="4">4&times;</option>
                        </select>
                        <div class="form-check" style="margin:0 .25rem;">
                            <input class="form-check-input" type="checkbox" id="showOverlay">
                            <label class="form-check-label" for="showOverlay">Overlay</label>
                        </div>
                        <input id="scrub" type="range" min="0" max="100" step="1" value="0" style="width:220px;">
                    </div>
                    <canvas id="traj" width="900" height="500"></canvas>
                </div>
                <div style="padding:.5rem .8rem;background:linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);border-radius:0 0 12px 12px;border-left:3px solid #667eea">
                    <small style="font-size:.88rem;line-height:1.5;color:#64748b">
                        <strong style="color:#667eea">How to use:</strong> Axes show meters. Solid line = current model; dashed = no-drag overlay (if enabled). Drag the target or cannon to interact!
                    </small>
                </div>
            </div>
        </div>

        <!-- Charts Card -->
        <div class="tool-card" style="margin-top:.75rem">
            <div class="tool-card-header" style="background:var(--pm-gradient);">Charts</div>
            <div class="tool-card-body">
                <ul class="nav nav-pills" role="tablist">
                    <li class="nav-item"><a class="nav-link active" href="#" id="tabVel">Velocity</a></li>
                    <li class="nav-item"><a class="nav-link" href="#" id="tabEnergy">Energy</a></li>
                </ul>
                <div>
                    <canvas id="velChart" height="180"></canvas>
                    <canvas id="energyChart" height="180" style="display:none"></canvas>
                </div>
            </div>
        </div>

        <!-- Energy Explainer (visible only when Energy tab active) -->
        <div class="pm-energy-explainer" id="energyExplainer" style="display:none">
            <strong>Understanding the Energy Chart:</strong>
            Kinetic Energy (KE = &frac12;mv&sup2;) is the energy of motion. Potential Energy (PE = mgy) is stored energy due to height.
            Without drag, KE + PE stays constant &mdash; energy is conserved. At the apex, KE is minimum and PE is maximum.
            With drag enabled, total energy decreases over time as drag dissipates energy as heat.
        </div>
    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="projectile-motion-simulator.jsp"/>
    <jsp:param name="keyword" value="physics"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ==================== VISIBLE FAQ SECTION ==================== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I calculate projectile motion range and time of flight?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Enter the initial velocity (m/s), launch angle (degrees), and starting height. Select a gravity preset (Earth, Moon, Mars, etc.) or enter custom gravity. Click Launch to calculate range, time of flight, maximum height, and final velocity. The trajectory is displayed on an interactive canvas with real-time physics simulation.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Does this simulator include air resistance and drag?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes! Toggle the Air Resistance checkbox to enable quadratic drag simulation. Adjust air density (&rho;), drag coefficient (C<sub>d</sub>), cross-sectional area (A), and mass (m). Choose from 15+ object presets: tennis ball, baseball, basketball, soccer ball, golf ball, arrow, frisbee, feather, balloon, and more. Each preset uses real-world physics parameters.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can I simulate projectile motion on other planets?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Absolutely! Select from 17 celestial bodies: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune, Moon, Europa, Titan, Pluto, Ceres, Sun, and White Dwarf. Each has accurate surface gravity values. Try the Moon Golf scenario to see how a golf ball travels 400+ meters in lunar gravity!</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What are the best presets for sports projectile motion?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Try these popular sports scenarios: Basketball Free Throw (7 m/s at 50&deg;), Soccer Goal Kick (20 m/s at 25&deg;), Golf Perfect Drive (70 m/s at 12&deg;), Baseball Home Run (45 m/s at 30&deg;). Each scenario includes realistic air resistance, object physics, and target placement.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How accurate is the projectile motion calculator?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Very accurate! Without air resistance, we use closed-form kinematics equations for exact results. With air resistance enabled, we use Euler numerical integration with small time steps (dt=0.005s) to solve the differential equations. All object presets use real-world values for mass, drag coefficient, and cross-sectional area from physics literature.</div>
        </div>
    </div>
</section>

<!-- ==================== EDUCATIONAL CONTENT: What is Projectile Motion? ==================== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:2rem;overflow:hidden;">
        <h2 style="font-size:1.3rem;margin-bottom:1.2rem;color:var(--pm-tool);">What is Projectile Motion?</h2>

        <!-- Animated trajectory diagram -->
        <div class="pm-edu-diagram" style="position:relative;height:220px;background:linear-gradient(180deg,#e0f2fe 0%,#f0fdf4 85%,#86efac 85%,#4ade80 100%);border-radius:12px;margin-bottom:1.5rem;overflow:hidden;">
            <style>
                @keyframes pmBall{0%{left:8%;bottom:15%;opacity:1}10%{bottom:55%}25%{bottom:78%;left:28%}40%{bottom:75%;left:40%}50%{bottom:55%;left:52%}70%{bottom:30%;left:68%}90%{bottom:15%;left:85%}100%{left:88%;bottom:15%;opacity:.6}}
                @keyframes pmDash{0%{stroke-dashoffset:600}100%{stroke-dashoffset:0}}
                @keyframes pmVx{0%,100%{opacity:.7}50%{opacity:1}}
                @keyframes pmVy{0%{opacity:.7}25%{opacity:1}50%{opacity:.3}75%{opacity:1}100%{opacity:.7}}
                @keyframes pmFadeLoop{0%,100%{opacity:.4}50%{opacity:1}}
                .pm-ball{position:absolute;width:14px;height:14px;background:var(--pm-gradient);border-radius:50%;box-shadow:0 2px 8px rgba(102,126,234,.5);animation:pmBall 4s ease-in-out infinite;z-index:5}
                .pm-edu-diagram svg{position:absolute;inset:0;width:100%;height:100%}
                .pm-edu-diagram .pm-arc{fill:none;stroke:var(--pm-tool);stroke-width:2;stroke-dasharray:600;animation:pmDash 4s linear infinite;opacity:.5}
                .pm-edu-label{position:absolute;font-size:.72rem;font-weight:600;pointer-events:none;z-index:6}
            </style>
            <!-- Parabolic path (SVG) -->
            <svg viewBox="0 0 400 200" preserveAspectRatio="none">
                <path class="pm-arc" d="M32,170 Q100,15 200,28 Q300,40 355,170"/>
            </svg>
            <!-- Animated ball -->
            <div class="pm-ball"></div>
            <!-- Labels -->
            <div class="pm-edu-label" style="left:4%;bottom:18%;color:var(--pm-tool);">&theta;</div>
            <div class="pm-edu-label" style="left:44%;top:6%;color:var(--pm-tool-dark);">Max Height (H)</div>
            <div class="pm-edu-label" style="right:4%;bottom:6%;color:#16a34a;">Range (R)</div>
            <div class="pm-edu-label" style="left:10%;bottom:2%;color:#64748b;font-size:.68rem;">v<sub>x</sub> = v&#8320;cos&theta; <span style="animation:pmVx 4s infinite;display:inline-block;">&rarr;</span></div>
            <div class="pm-edu-label" style="left:4%;bottom:38%;color:#64748b;font-size:.68rem;writing-mode:vertical-lr;transform:rotate(180deg);">v<sub>y</sub> <span style="animation:pmVy 4s infinite;display:inline-block;">&uarr;</span></div>
            <!-- Ground line -->
            <div style="position:absolute;bottom:14.5%;left:6%;right:6%;border-top:2px dashed #86efac;z-index:2;"></div>
        </div>

        <div style="display:grid;gap:1rem;font-size:.92rem;line-height:1.75;color:#475569;">
            <p>
                <strong>Projectile motion</strong> is the motion of an object thrown or projected into the air, subject only to gravity (and optionally air resistance). The object follows a curved path called a <strong>parabola</strong>. It is one of the most fundamental topics in classical mechanics, studied in physics courses from high school through university.
            </p>

            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:1rem;">
                <!-- Key Concept 1 -->
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:1rem;">
                    <h3 style="font-size:.95rem;color:var(--pm-tool);margin-bottom:.4rem;">Velocity Decomposition</h3>
                    <p style="font-size:.85rem;margin:0;">The initial velocity v&#8320; is split into two independent components: <strong>horizontal</strong> (v<sub>x</sub> = v&#8320;cos&theta;) which stays constant, and <strong>vertical</strong> (v<sub>y</sub> = v&#8320;sin&theta;) which changes due to gravity. This independence is the key insight of projectile motion.</p>
                </div>
                <!-- Key Concept 2 -->
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:1rem;">
                    <h3 style="font-size:.95rem;color:var(--pm-tool-dark);margin-bottom:.4rem;">The Three Key Equations</h3>
                    <div style="font-size:.85rem;">
                        <p style="margin:0 0 .3rem 0;"><strong>Range:</strong> R = v&#8320;&sup2; sin(2&theta;) / g</p>
                        <p style="margin:0 0 .3rem 0;"><strong>Time of Flight:</strong> T = 2v&#8320; sin(&theta;) / g</p>
                        <p style="margin:0;"><strong>Max Height:</strong> H = v&#8320;&sup2; sin&sup2;(&theta;) / (2g)</p>
                    </div>
                </div>
                <!-- Key Concept 3 -->
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:1rem;">
                    <h3 style="font-size:.95rem;color:#10b981;margin-bottom:.4rem;">The 45&deg; Rule</h3>
                    <p style="font-size:.85rem;margin:0;">Without air resistance and from ground level, a <strong>45&deg; launch angle maximizes range</strong>. Complementary angles (e.g., 30&deg; and 60&deg;) produce the same range but different trajectories. Air drag shifts the optimal angle below 45&deg;.</p>
                </div>
            </div>

            <p>
                <strong>Why does air resistance matter?</strong> In real life, the drag force F<sub>d</sub> = &frac12;&rho;C<sub>d</sub>Av&sup2; opposes motion and depends on the object&rsquo;s speed, shape, size, and the air density. Light objects (like a feather) are dramatically slowed, while dense objects (like a cannonball) are barely affected. This calculator lets you toggle drag on/off to see the difference &mdash; try the <em>Feather vs Cannonball</em> guided experiment above!
            </p>

            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:.8rem;">
                <!-- Mini fact cards with subtle animation -->
                <div style="background:linear-gradient(135deg,#f0f1ff,#f8fafc);border-radius:8px;padding:.7rem .8rem;border-left:3px solid var(--pm-tool);">
                    <div style="font-size:.78rem;font-weight:700;color:var(--pm-tool);margin-bottom:.2rem;">On the Moon</div>
                    <div style="font-size:.82rem;color:#475569;">Gravity is only 1.62 m/s&sup2; (vs Earth&rsquo;s 9.81). A ball launched at 25 m/s travels <strong>~6&times; farther</strong> on the Moon.</div>
                </div>
                <div style="background:linear-gradient(135deg,#f0fdf4,#f8fafc);border-radius:8px;padding:.7rem .8rem;border-left:3px solid #10b981;">
                    <div style="font-size:.78rem;font-weight:700;color:#10b981;margin-bottom:.2rem;">Energy Conservation</div>
                    <div style="font-size:.82rem;color:#475569;">Without drag, KE + PE stays constant. At the apex, all kinetic energy has converted to potential energy, and v<sub>y</sub> = 0.</div>
                </div>
                <div style="background:linear-gradient(135deg,#fef3c7,#f8fafc);border-radius:8px;padding:.7rem .8rem;border-left:3px solid #f59e0b;">
                    <div style="font-size:.78rem;font-weight:700;color:#d97706;margin-bottom:.2rem;">Real-World Applications</div>
                    <div style="font-size:.82rem;color:#475569;">Sports science, military ballistics, space missions, civil engineering (bridge arcs), video game physics, and forensic analysis all use projectile motion.</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- About / Methodology -->
<section class="tool-expertise-section" style="max-width:1200px;margin:0 auto 2rem;padding:0 1rem;">
    <div class="tool-card" style="padding:2rem;">
        <h2 style="font-size:1.15rem;margin-bottom:.8rem;">About This Projectile Motion Calculator</h2>
        <div style="display:grid;gap:.6rem;font-size:.9rem;line-height:1.7;color:#475569">
            <p><strong style="color:var(--pm-tool);">Without Air Resistance:</strong> Uses closed-form kinematics equations (SUVAT formulas). Range: R = (v&#8320;&sup2; &times; sin(2&theta;)) / g. Time of Flight: T = (2v&#8320; &times; sin(&theta;)) / g. Max Height: H = (v&#8320;&sup2; &times; sin&sup2;(&theta;)) / (2g).</p>
            <p><strong style="color:var(--pm-tool-dark);">With Air Resistance:</strong> Euler numerical integration (dt=0.005s) solves quadratic drag: F<sub>drag</sub> = 0.5&middot;&rho;&middot;C<sub>d</sub>&middot;A&middot;v&sup2;. Each object preset uses real-world values for mass, drag coefficient, and cross-sectional area.</p>
            <p><strong style="color:#10b981;">Privacy:</strong> All calculations run 100% locally in your browser. No server uploads, no data collection, no registration required.</p>
        </div>
        <div style="margin-top:1rem;font-size:.85rem;color:#64748b;">
            <strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--pm-tool);">Anish Nath</a> |
            <strong>Last updated:</strong> 2025-11-19
        </div>
    </div>
</section>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>

<!-- Educational scaffolding interactions -->
<script>
document.addEventListener('DOMContentLoaded', function(){
  // Results hint toggle
  var btnHints = document.getElementById('btnToggleHints');
  var grid = document.getElementById('resultsGrid');
  if (btnHints && grid) {
    btnHints.addEventListener('click', function(){
      grid.classList.toggle('pm-show-hints');
      btnHints.textContent = grid.classList.contains('pm-show-hints') ? 'Hide explanations' : 'Show explanations';
    });
  }
  // Energy explainer visibility
  var tabVel = document.getElementById('tabVel');
  var tabEnergy = document.getElementById('tabEnergy');
  var explainer = document.getElementById('energyExplainer');
  if (tabVel && tabEnergy && explainer) {
    tabEnergy.addEventListener('click', function(){ explainer.style.display = ''; });
    tabVel.addEventListener('click', function(){ explainer.style.display = 'none'; });
  }
});
</script>

<!-- Dark mode bridge -->
<script>
(function(){
  function syncDark(){
    var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    window.PM_DARK = isDark;
  }
  new MutationObserver(syncDark).observe(document.documentElement, {attributes:true, attributeFilter:['data-theme']});
  document.addEventListener('DOMContentLoaded', syncDark);
})();
</script>

<!-- Library load check -->
<script>
document.addEventListener('DOMContentLoaded', function(){
  if (typeof Chart === 'undefined'){
    var w = document.createElement('div');
    w.className = 'tool-alert tool-alert-error';
    w.style.margin = '1rem';
    w.innerHTML = 'Required libraries failed to load. If you use script optimizers (e.g., Rocket Loader), disable them for this page.';
    var main = document.querySelector('.pm-page-container');
    if (main) main.parentNode.insertBefore(w, main);
  }
});
</script>

<!-- Engine (synchronous, after DOM) -->
<script data-cfasync="false" src="<%=request.getContextPath()%>/js/projectile-motion-engine.js?v=<%=cacheVersion%>"></script>

<!-- Canvas auto-resize -->
<script>
(function(){
  var c = document.getElementById('traj');
  if (c && typeof ResizeObserver !== 'undefined') {
    new ResizeObserver(function(){
      var w = c.parentElement.clientWidth;
      if (w > 0 && w !== c.width) {
        c.width = w;
        try { c.dispatchEvent(new Event('resize')); } catch(_){}
      }
    }).observe(c.parentElement);
  }
})();
</script>

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
