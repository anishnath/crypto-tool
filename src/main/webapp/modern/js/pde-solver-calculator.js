/**
 * PDE Solver Calculator - Heat, Wave, Laplace, Poisson, Transport, Schrodinger
 * Step-by-step solutions, 3D surfaces, contour plots, time animation
 * Dirichlet, Neumann, Robin, Periodic boundary conditions
 * Export: Copy LaTeX, PDF, Worksheet, Share
 */
(function() {
    'use strict';

    // ===== DOM References =====
    var heatK = document.getElementById('pde-heat-k');
    var heatL = document.getElementById('pde-heat-L');
    var heatTmax = document.getElementById('pde-heat-tmax');
    var heatIC = document.getElementById('pde-heat-ic');
    var heatBC = document.getElementById('pde-heat-bc');
    var waveC = document.getElementById('pde-wave-c');
    var waveL = document.getElementById('pde-wave-L');
    var waveTmax = document.getElementById('pde-wave-tmax');
    var waveIC = document.getElementById('pde-wave-ic');
    var waveBC = document.getElementById('pde-wave-bc');
    var laplaceNx = document.getElementById('pde-laplace-nx');
    var laplaceNy = document.getElementById('pde-laplace-ny');
    var laplaceBC = document.getElementById('pde-laplace-bc');
    var poissonNx = document.getElementById('pde-poisson-nx');
    var poissonNy = document.getElementById('pde-poisson-ny');
    var poissonSource = document.getElementById('pde-poisson-source');
    var poissonBC = document.getElementById('pde-poisson-bc');
    var transportC = document.getElementById('pde-transport-c');
    var transportL = document.getElementById('pde-transport-L');
    var transportTmax = document.getElementById('pde-transport-tmax');
    var transportIC = document.getElementById('pde-transport-ic');
    var transportScheme = document.getElementById('pde-transport-scheme');
    var schrodingerL = document.getElementById('pde-schrodinger-L');
    var schrodingerPotential = document.getElementById('pde-schrodinger-potential');
    var schrodingerNstates = document.getElementById('pde-schrodinger-nstates');
    var linear1A = document.getElementById('pde-linear1-a');
    var linear1B = document.getElementById('pde-linear1-b');
    var linear1C = document.getElementById('pde-linear1-c');
    var linear1G = document.getElementById('pde-linear1-g');
    var previewEl = document.getElementById('pde-preview');
    var computeBtn = document.getElementById('pde-compute-btn');
    var resultContent = document.getElementById('pde-result-content');
    var emptyState = document.getElementById('pde-empty-state');
    var graphHint = document.getElementById('pde-graph-hint');
    var contourHint = document.getElementById('pde-contour-hint');
    var animateHint = document.getElementById('pde-animate-hint');
    var exportRow = document.getElementById('pde-export-row');

    var currentMode = 'heat';
    var pendingGraph = null;
    var pendingFrames = null;
    var compilerLoaded = false;
    var lastResultLatex = '';
    var lastResultText = '';
    var lastStepsData = null;
    var animInterval = null;
    var animFrame = 0;

    // ===== Utility =====
    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(String(str)));
        return div.innerHTML;
    }

    function parseNum(val, def) {
        var n = parseFloat(String(val).trim());
        return isNaN(n) ? def : n;
    }

    // ===== Mode toggle =====
    var allWraps = {
        heat: document.getElementById('pde-heat-wrap'),
        wave: document.getElementById('pde-wave-wrap'),
        laplace: document.getElementById('pde-laplace-wrap'),
        poisson: document.getElementById('pde-poisson-wrap'),
        transport: document.getElementById('pde-transport-wrap'),
        schrodinger: document.getElementById('pde-schrodinger-wrap'),
        linear1: document.getElementById('pde-linear1-wrap')
    };

    document.querySelectorAll('.pde-mode-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;
            currentMode = mode;
            document.querySelectorAll('.pde-mode-btn').forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            Object.keys(allWraps).forEach(function(k) {
                if (allWraps[k]) allWraps[k].style.display = k === mode ? '' : 'none';
            });
            updatePreview();
            updateExamples();
        });
    });

    // ===== Preview =====
    function updatePreview() {
        if (!previewEl) return;
        var latexMap = {
            heat: 'u_t = k \\, u_{xx} \\quad \\text{(Heat/Diffusion)}',
            wave: 'u_{tt} = c^2 \\, u_{xx} \\quad \\text{(Wave)}',
            laplace: '\\nabla^2 u = u_{xx} + u_{yy} = 0 \\quad \\text{(Laplace)}',
            poisson: '\\nabla^2 u = f(x,y) \\quad \\text{(Poisson)}',
            transport: 'u_t + c \\, u_x = 0 \\quad \\text{(Transport/Advection)}',
            schrodinger: '-\\frac{\\hbar^2}{2m} \\psi\'\'(x) + V(x)\\psi = E\\psi \\quad \\text{(Schr\\"{o}dinger)}',
            linear1: 'a\\,u_x + b\\,u_y + c\\,u = G(x,y) \\quad \\text{(1st-order linear)}'
        };
        try {
            if (typeof katex !== 'undefined') {
                katex.render(latexMap[currentMode] || 'PDE', previewEl, { displayMode: true, throwOnError: false });
            } else {
                var fb = { heat:'u_t = k u_xx', wave:'u_tt = c^2 u_xx', laplace:'u_xx + u_yy = 0', poisson:'nabla^2 u = f', transport:'u_t + c u_x = 0', schrodinger:'-h^2/2m psi\'\' + V psi = E psi', linear1:'a u_x + b u_y + c u = G' };
                previewEl.textContent = fb[currentMode] || 'PDE';
            }
        } catch(e) { previewEl.textContent = 'PDE preview'; }
    }

    // ===== Code Generators (shared PDECalculatorCore) =====

    function buildParamsSnapshot() {
        switch (currentMode) {
            case 'heat':
                return {
                    k: heatK && heatK.value,
                    L: heatL && heatL.value,
                    tmax: heatTmax && heatTmax.value,
                    ic: heatIC && heatIC.value,
                    bc: heatBC && heatBC.value
                };
            case 'wave':
                return {
                    c: waveC && waveC.value,
                    L: waveL && waveL.value,
                    tmax: waveTmax && waveTmax.value,
                    ic: waveIC && waveIC.value,
                    bc: waveBC && waveBC.value
                };
            case 'laplace':
                return {
                    nx: laplaceNx && laplaceNx.value,
                    ny: laplaceNy && laplaceNy.value,
                    bc: laplaceBC && laplaceBC.value
                };
            case 'poisson':
                return {
                    nx: poissonNx && poissonNx.value,
                    ny: poissonNy && poissonNy.value,
                    source: poissonSource && poissonSource.value,
                    bc: poissonBC && poissonBC.value
                };
            case 'transport':
                return {
                    c: transportC && transportC.value,
                    L: transportL && transportL.value,
                    tmax: transportTmax && transportTmax.value,
                    ic: transportIC && transportIC.value,
                    scheme: transportScheme && transportScheme.value
                };
            case 'schrodinger':
                return {
                    L: schrodingerL && schrodingerL.value,
                    potential: schrodingerPotential && schrodingerPotential.value,
                    nstates: schrodingerNstates && schrodingerNstates.value
                };
            case 'linear1':
                return {
                    a: linear1A && linear1A.value,
                    b: linear1B && linear1B.value,
                    c: linear1C && linear1C.value,
                    g: linear1G && linear1G.value
                };
            default:
                return {};
        }
    }

    function buildCode() {
        var core = typeof PDECalculatorCore !== 'undefined' ? PDECalculatorCore : window.PDECalculatorCore;
        if (core && core.buildCode) {
            return core.buildCode({ mode: currentMode, params: buildParamsSnapshot() });
        }
        return '';
    }


    // ===== Examples =====
    var heatExamples = [
        { label: 'k=1, sin, Dirichlet', k:'1', L:'1', tmax:'0.5', ic:'sin', bc:'dirichlet' },
        { label: 'Gaussian, Neumann', k:'1', L:'1', tmax:'0.3', ic:'gauss', bc:'neumann' },
        { label: 'Step, Robin BC', k:'0.5', L:'2', tmax:'1', ic:'step', bc:'robin' },
        { label: 'Periodic BC', k:'1', L:'2', tmax:'0.5', ic:'gauss', bc:'periodic' }
    ];
    var waveExamples = [
        { label: 'c=1, sin, fixed', c:'1', L:'1', tmax:'2', ic:'sin', bc:'dirichlet' },
        { label: 'Gaussian, free ends', c:'1', L:'1', tmax:'1.5', ic:'gauss', bc:'neumann' },
        { label: 'Bump, fixed-free', c:'2', L:'2', tmax:'2', ic:'bump', bc:'mixed' }
    ];
    var laplaceExamples = [
        { label: '20x20 Dirichlet', nx:'20', ny:'20', bc:'dirichlet' },
        { label: '30x30 Mixed', nx:'30', ny:'30', bc:'mixed' },
        { label: 'Neumann top', nx:'25', ny:'25', bc:'neumann_top' },
        { label: 'Robin BC', nx:'20', ny:'20', bc:'robin' }
    ];
    var poissonExamples = [
        { label: 'Constant source', nx:'25', ny:'25', source:'const', bc:'dirichlet' },
        { label: 'Gaussian source', nx:'30', ny:'30', source:'gaussian', bc:'dirichlet' },
        { label: 'Sinusoidal', nx:'25', ny:'25', source:'sin', bc:'dirichlet' },
        { label: 'Dipole', nx:'30', ny:'30', source:'dipole', bc:'neumann' }
    ];
    var transportExamples = [
        { label: 'Gaussian upwind', c:'1', L:'2', tmax:'1.5', ic:'gauss', scheme:'upwind' },
        { label: 'Step, Lax-Wendroff', c:'1', L:'2', tmax:'1', ic:'step', scheme:'lax_wendroff' },
        { label: 'Square wave', c:'1.5', L:'3', tmax:'1.5', ic:'square', scheme:'lax_friedrichs' }
    ];
    var schrodingerExamples = [
        { label: 'Infinite well', L:'1', potential:'infinite_well', nstates:'5' },
        { label: 'Harmonic osc.', L:'1', potential:'harmonic', nstates:'5' },
        { label: 'Finite well', L:'1', potential:'finite_well', nstates:'4' },
        { label: 'Double well', L:'1', potential:'double_well', nstates:'4' }
    ];
    var linear1Examples = [
        { label: 'u_x+u_y+u=0', a:'1', b:'1', c:'1', g:'0' },
        { label: '2u_x-4u_y+5u=e^(x+3y)', a:'2', b:'-4', c:'5', g:'exp(x+3*y)' },
        { label: 'u_x-u_y=0', a:'1', b:'-1', c:'0', g:'0' }
    ];

    function getExamples() {
        switch (currentMode) {
            case 'heat': return heatExamples;
            case 'wave': return waveExamples;
            case 'laplace': return laplaceExamples;
            case 'poisson': return poissonExamples;
            case 'transport': return transportExamples;
            case 'schrodinger': return schrodingerExamples;
            case 'linear1': return linear1Examples;
            default: return heatExamples;
        }
    }

    function updateExamples() {
        var container = document.getElementById('pde-examples');
        if (!container) return;
        var arr = getExamples();
        container.innerHTML = arr.map(function(ex) {
            return '<button type="button" class="pde-example-chip" data-ex=\'' + JSON.stringify(ex).replace(/'/g, '&#39;') + '\'>' + escapeHtml(ex.label) + '</button>';
        }).join('');
    }
    updateExamples();

    document.getElementById('pde-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.pde-example-chip');
        if (!chip) return;
        try {
            var ex = JSON.parse(chip.getAttribute('data-ex').replace(/&#39;/g, "'"));
            applyPreset(ex);
            updatePreview();
        } catch(err) {}
    });

    function applyPreset(ex) {
        if (currentMode === 'heat') {
            if (heatK) heatK.value = ex.k || '1';
            if (heatL) heatL.value = ex.L || '1';
            if (heatTmax) heatTmax.value = ex.tmax || '0.5';
            if (heatIC) heatIC.value = ex.ic || 'sin';
            if (heatBC) heatBC.value = ex.bc || 'dirichlet';
        } else if (currentMode === 'wave') {
            if (waveC) waveC.value = ex.c || '1';
            if (waveL) waveL.value = ex.L || '1';
            if (waveTmax) waveTmax.value = ex.tmax || '2';
            if (waveIC) waveIC.value = ex.ic || 'sin';
            if (waveBC) waveBC.value = ex.bc || 'dirichlet';
        } else if (currentMode === 'laplace') {
            if (laplaceNx) laplaceNx.value = ex.nx || '20';
            if (laplaceNy) laplaceNy.value = ex.ny || '20';
            if (laplaceBC) laplaceBC.value = ex.bc || 'dirichlet';
        } else if (currentMode === 'poisson') {
            if (poissonNx) poissonNx.value = ex.nx || '25';
            if (poissonNy) poissonNy.value = ex.ny || '25';
            if (poissonSource) poissonSource.value = ex.source || 'const';
            if (poissonBC) poissonBC.value = ex.bc || 'dirichlet';
        } else if (currentMode === 'transport') {
            if (transportC) transportC.value = ex.c || '1';
            if (transportL) transportL.value = ex.L || '2';
            if (transportTmax) transportTmax.value = ex.tmax || '1.5';
            if (transportIC) transportIC.value = ex.ic || 'gauss';
            if (transportScheme) transportScheme.value = ex.scheme || 'upwind';
        } else if (currentMode === 'schrodinger') {
            if (schrodingerL) schrodingerL.value = ex.L || '1';
            if (schrodingerPotential) schrodingerPotential.value = ex.potential || 'infinite_well';
            if (schrodingerNstates) schrodingerNstates.value = ex.nstates || '5';
        } else if (currentMode === 'linear1') {
            if (linear1A) linear1A.value = ex.a || '1';
            if (linear1B) linear1B.value = ex.b || '1';
            if (linear1C) linear1C.value = ex.c || '1';
            if (linear1G) linear1G.value = ex.g || '0';
        }
    }

    // Random
    document.getElementById('pde-random-btn').addEventListener('click', function() {
        var arr = getExamples();
        var p = arr[Math.floor(Math.random() * arr.length)];
        applyPreset(p);
        updatePreview();
    });

    // ===== Output Tabs =====
    var tabBtns = document.querySelectorAll('.pde-output-tab');
    var panels = document.querySelectorAll('.pde-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('pde-panel-' + panel).classList.add('active');
            if (panel === 'graph' && pendingGraph) loadPlotly(function() { renderSurface(pendingGraph); });
            if (panel === 'contour' && pendingGraph) loadPlotly(function() { renderContour(pendingGraph); });
            if (panel === 'animate' && pendingFrames) loadPlotly(function() { renderAnimation(pendingFrames); });
            if (panel === 'python' && !compilerLoaded) { loadCompilerWithTemplate(); compilerLoaded = true; }
        });
    });

    function loadCompilerWithTemplate() {
        var code = buildCode();
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('pde-compiler-iframe');
        if (iframe) iframe.src = (window.PDE_CALC_CTX || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    // ===== Reference Table =====
    var formulaData = [
        { f: 'u_t = k\\,u_{xx}', m: '\\text{FTCS, Crank-Nicolson | Diffusion, heat conduction}' },
        { f: 'u_{tt} = c^2 u_{xx}', m: '\\text{Central diff | Strings, sound, EM waves}' },
        { f: 'u_{xx} + u_{yy} = 0', m: '\\text{Jacobi/SOR | Steady-state, potential fields}' },
        { f: '\\nabla^2 u = f(x,y)', m: '\\text{Jacobi | Gravity, electrostatics, sources}' },
        { f: 'u_t + c\\,u_x = 0', m: '\\text{Upwind, Lax-Wendroff | Advection, pollution}' },
        { f: '-\\tfrac{\\hbar^2}{2m}\\psi\'\' + V\\psi = E\\psi', m: '\\text{Matrix eigh | Quantum energy levels}' },
        { f: 'a\\,u_x + b\\,u_y + c\\,u = G', m: '\\text{Method of characteristics | 1st-order linear}' }
    ];

    function renderFormulas() {
        if (typeof katex === 'undefined') return;
        formulaData.forEach(function(row, i) {
            var fEl = document.getElementById('pde-formula-f' + i);
            var mEl = document.getElementById('pde-formula-m' + i);
            if (fEl) katex.render(row.f, fEl, { throwOnError: false });
            if (mEl) katex.render(row.m, mEl, { throwOnError: false });
        });
    }

    var formulasToggle = document.getElementById('pde-formulas-toggle');
    var formulasContent = document.getElementById('pde-formulas-content');
    if (formulasToggle) {
        formulasToggle.addEventListener('click', function() {
            var open = formulasContent.style.display !== 'none';
            formulasContent.style.display = open ? 'none' : '';
            formulasToggle.querySelector('.pde-formulas-chevron').style.transform = open ? '' : 'rotate(180deg)';
            if (!open) renderFormulas();
        });
    }

    var syntaxToggle = document.getElementById('pde-syntax-toggle');
    var syntaxContent = document.getElementById('pde-syntax-content');
    if (syntaxToggle) {
        syntaxToggle.addEventListener('click', function() {
            var open = syntaxContent.style.display !== 'none';
            syntaxContent.style.display = open ? 'none' : '';
            syntaxToggle.querySelector('.pde-formulas-chevron').style.transform = open ? '' : 'rotate(180deg)';
        });
    }

    // ===== Result Display =====
    function showError(msg) {
        if (emptyState) emptyState.style.display = 'none';
        resultContent.innerHTML = '<div class="pde-error"><h4>Error</h4><p>' + escapeHtml(msg) + '</p></div>';
        pendingGraph = null;
        pendingFrames = null;
        if (exportRow) exportRow.style.display = 'none';
    }

    function showResult(stdout) {
        if (emptyState) emptyState.style.display = 'none';

        var errMatch = stdout.match(/ERROR:([^\n]*)/);
        if (errMatch) { showError(errMatch[1].trim()); return; }

        // Parse metadata
        var meta = {};
        var metaRe = /META_(\w+):([^\n]*)/g;
        var m;
        while ((m = metaRe.exec(stdout)) !== null) meta[m[1]] = m[2].trim();

        // Parse steps
        var steps = [];
        var stepRe = /STEP(\d+)_TITLE:([^\n]*)/g;
        while ((m = stepRe.exec(stdout)) !== null) {
            var idx = m[1];
            var latexMatch = stdout.match(new RegExp('STEP' + idx + '_LATEX:([^\n]*)'));
            steps.push({ title: m[2].trim(), latex: latexMatch ? latexMatch[1].trim() : '' });
        }
        lastStepsData = steps;

        // Parse result text
        var resultMatch = stdout.match(/RESULT:([^\n]*)/);
        var resultLatexMatch = stdout.match(/RESULT_LATEX:([^\n]*)/);
        var textMatch = stdout.match(/TEXT:([^\n]*)/);
        var verifiedMatch = stdout.match(/VERIFIED:([^\n]*)/);

        var resultText = resultMatch ? resultMatch[1].trim() : currentMode + ' equation solved';
        lastResultText = resultText;
        lastResultLatex = resultLatexMatch ? resultLatexMatch[1].trim() : (textMatch ? textMatch[1].trim() : resultText);

        // Parse surface data
        var xMatch = stdout.match(/SURFACE_X:(\[[\s\S]*?\])(?=\n|$)/);
        var yMatch = stdout.match(/SURFACE_Y:(\[[\s\S]*?\])(?=\n|$)/);
        var zMatch = stdout.match(/SURFACE_Z:(\[[\s\S]*?\])(?=\n|$)/);
        var surfaceData = null;
        try {
            if (xMatch && yMatch && zMatch) {
                surfaceData = { x: JSON.parse(xMatch[1]), y: JSON.parse(yMatch[1]), z: JSON.parse(zMatch[1]) };
            }
        } catch(e) {}
        pendingGraph = surfaceData;

        // Parse frames for animation (time-dependent PDEs)
        if (surfaceData && (currentMode === 'heat' || currentMode === 'wave' || currentMode === 'transport')) {
            pendingFrames = surfaceData;
        } else {
            pendingFrames = null;
        }

        // Parse Schrodinger eigenstates for special display
        var eigenData = null;
        if (currentMode === 'schrodinger') {
            var nEigen = parseInt((stdout.match(/EIGEN_N:(\d+)/) || [])[1] || '0');
            if (nEigen > 0) {
                eigenData = { x: null, V: null, states: [] };
                var exMatch = stdout.match(/EIGEN_X:(\[[\s\S]*?\])(?=\n|$)/);
                var evMatch = stdout.match(/EIGEN_V:(\[[\s\S]*?\])(?=\n|$)/);
                if (exMatch) eigenData.x = JSON.parse(exMatch[1]);
                if (evMatch) eigenData.V = JSON.parse(evMatch[1]);
                for (var ei = 0; ei < nEigen; ei++) {
                    var eE = stdout.match(new RegExp('EIGEN_' + ei + '_E:([^\n]*)'));
                    var ePsi = stdout.match(new RegExp('EIGEN_' + ei + '_PSI:(\\[[\\s\\S]*?\\])(?=\\n|$)'));
                    if (eE && ePsi) eigenData.states.push({ E: parseFloat(eE[1]), psi: JSON.parse(ePsi[1]) });
                }
                pendingFrames = eigenData;
            }
        }

        // Build result HTML
        var verified = verifiedMatch ? verifiedMatch[1].trim() === 'True' : null;
        var methodLabel = meta.METHOD || (currentMode === 'linear1' ? 'Method of characteristics' : 'Finite Difference');
        var verBadge = (verified === true) ? '<span class="pde-verified-badge">Verified</span>' : '';
        var methodBadge = '<span class="pde-method-badge">' + escapeHtml(methodLabel) + '</span>';
        var bcBadge = meta.BC ? '<span class="pde-classify-badge">BC: ' + escapeHtml(meta.BC) + '</span>' : '';

        // Stability badge
        var stabilityBadge = '';
        if (meta.STABLE === 'True') stabilityBadge = '<span class="pde-verified-badge">Stable</span>';
        else if (meta.STABLE === 'False') stabilityBadge = '<span class="pde-error-badge">Unstable</span>';
        if (meta.CONVERGED === 'True') stabilityBadge = '<span class="pde-verified-badge">Converged</span>';
        else if (meta.CONVERGED === 'False') stabilityBadge = '<span class="pde-error-badge">Max iterations</span>';

        // Numerical info
        var numInfo = '';
        if (meta.R) numInfo += '<span class="pde-meta-item">r = ' + meta.R + '</span>';
        if (meta.CFL) numInfo += '<span class="pde-meta-item">CFL = ' + meta.CFL + '</span>';
        if (meta.DX) numInfo += '<span class="pde-meta-item">&Delta;x = ' + meta.DX + '</span>';
        if (meta.DT) numInfo += '<span class="pde-meta-item">&Delta;t = ' + meta.DT + '</span>';
        if (meta.NT) numInfo += '<span class="pde-meta-item">' + meta.NT + ' steps</span>';
        if (meta.ITER) numInfo += '<span class="pde-meta-item">' + meta.ITER + ' iterations</span>';
        if (meta.NSTATES) numInfo += '<span class="pde-meta-item">' + meta.NSTATES + ' eigenstates</span>';

        var html = '<div class="pde-result-math">';
        html += '<div class="pde-result-label">' + escapeHtml(getModeName()) + ' Solution</div>';
        html += '<div class="pde-result-main" id="pde-result-main-latex"></div>';
        html += '<div class="pde-result-detail">' + methodBadge + bcBadge + verBadge + stabilityBadge + '</div>';
        if (numInfo) html += '<div class="pde-meta-row">' + numInfo + '</div>';

        // Steps button
        if (steps.length > 0) {
            html += '<button type="button" class="pde-steps-btn" id="pde-steps-btn">Show Steps (' + steps.length + ')</button>';
            html += '<div class="pde-steps-container" id="pde-steps-container" style="display:none;">';
            html += '<div class="pde-steps-header"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/></svg> Solution Steps <span>(' + steps.length + ')</span> <span class="pde-steps-cas-badge">FD</span></div>';
            steps.forEach(function(step, i) {
                html += '<div class="pde-step"><span class="pde-step-num">' + (i + 1) + '</span><div class="pde-step-body"><div class="pde-step-title">' + escapeHtml(step.title) + '</div><div class="pde-step-math" id="pde-step-math-' + i + '"></div></div></div>';
            });
            html += '</div>';
        }

        if (surfaceData && currentMode !== 'schrodinger') {
            html += '<p style="font-size:0.8125rem;color:var(--text-secondary);margin-top:0.75rem;">3D surface, contour, and animation available in tabs above.</p>';
        }
        html += '</div>';

        resultContent.innerHTML = html;

        // Render LaTeX for result
        var mainEl = document.getElementById('pde-result-main-latex');
        if (mainEl && typeof katex !== 'undefined') {
            try {
                katex.render(lastResultLatex, mainEl, { displayMode: true, throwOnError: false });
            } catch(e) {
                mainEl.textContent = lastResultText;
            }
        } else if (mainEl) {
            mainEl.textContent = lastResultText;
        }

        // Render step LaTeX
        steps.forEach(function(step, i) {
            var el = document.getElementById('pde-step-math-' + i);
            if (el && typeof katex !== 'undefined' && step.latex) {
                try { katex.render(step.latex, el, { displayMode: true, throwOnError: false }); }
                catch(e) { el.textContent = step.latex; }
            } else if (el) {
                el.textContent = step.latex || '';
            }
        });

        // Steps toggle
        var stepsBtn = document.getElementById('pde-steps-btn');
        var stepsContainer = document.getElementById('pde-steps-container');
        if (stepsBtn && stepsContainer) {
            stepsBtn.addEventListener('click', function() {
                stepsContainer.style.display = stepsContainer.style.display === 'none' ? '' : 'none';
                stepsBtn.style.display = 'none';
            });
        }

        // Show export buttons
        if (exportRow) exportRow.style.display = '';

        // Auto-render graphs if tabs active
        if (surfaceData) {
            if (graphHint) graphHint.style.display = 'none';
            if (contourHint) contourHint.style.display = 'none';
            var graphPanel = document.getElementById('pde-panel-graph');
            if (graphPanel && graphPanel.classList.contains('active')) loadPlotly(function() { renderSurface(surfaceData); });
            var contourPanel = document.getElementById('pde-panel-contour');
            if (contourPanel && contourPanel.classList.contains('active')) loadPlotly(function() { renderContour(surfaceData); });
        }
        if (pendingFrames) {
            if (animateHint) animateHint.style.display = 'none';
            var animPanel = document.getElementById('pde-panel-animate');
            if (animPanel && animPanel.classList.contains('active')) loadPlotly(function() { renderAnimation(pendingFrames); });
        }
    }

    function getModeName() {
        var names = { heat:'Heat Equation', wave:'Wave Equation', laplace:'Laplace Equation', poisson:'Poisson Equation', transport:'Transport Equation', schrodinger:'Schrodinger Equation', linear1:'1st-Order Linear PDE' };
        return names[currentMode] || 'PDE';
    }

    // ===== 3D Surface Rendering =====
    function renderSurface(data) {
        var container = document.getElementById('pde-graph-container');
        if (!container || !data) return;
        try {
            var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
            var bgColor = isDark ? '#1e293b' : '#ffffff';
            var gridColor = isDark ? '#334155' : '#e2e8f0';
            var textColor = isDark ? '#cbd5e1' : '#1e293b';
            var isXY = currentMode === 'laplace' || currentMode === 'poisson';

            Plotly.newPlot(container, [{
                z: data.z,
                x: Array.isArray(data.x[0]) ? data.x[0] : data.x,
                y: data.y && Array.isArray(data.y[0]) ? data.y.map(function(r) { return r[0]; }) : data.y,
                type: 'surface',
                colorscale: 'Viridis',
                showscale: true
            }], {
                margin: { t: 40, r: 20, b: 40, l: 50 },
                paper_bgcolor: bgColor,
                scene: {
                    xaxis: { title: 'x', color: textColor, gridcolor: gridColor },
                    yaxis: { title: isXY ? 'y' : 't', color: textColor, gridcolor: gridColor },
                    zaxis: { title: 'u', color: textColor, gridcolor: gridColor },
                    bgcolor: bgColor
                }
            }, { responsive: true });
        } catch(e) {
            container.innerHTML = '<p style="color:var(--text-muted);">Graph error: ' + (e.message || '') + '</p>';
        }
    }

    // ===== Contour Plot =====
    function renderContour(data) {
        var container = document.getElementById('pde-contour-container');
        if (!container || !data) return;
        try {
            var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
            var bgColor = isDark ? '#1e293b' : '#ffffff';
            var textColor = isDark ? '#cbd5e1' : '#1e293b';
            var isXY = currentMode === 'laplace' || currentMode === 'poisson';

            // For time-dependent PDEs, show the last time slice as heatmap or use full z
            var zData = data.z;
            var xArr = Array.isArray(data.x[0]) ? data.x[0] : data.x;
            var yArr = data.y && Array.isArray(data.y[0]) ? data.y.map(function(r) { return r[0]; }) : data.y;

            Plotly.newPlot(container, [{
                z: zData,
                x: xArr,
                y: yArr || xArr,
                type: 'heatmap',
                colorscale: 'Viridis',
                showscale: true
            }], {
                margin: { t: 40, r: 20, b: 60, l: 60 },
                paper_bgcolor: bgColor,
                plot_bgcolor: bgColor,
                xaxis: { title: 'x', color: textColor },
                yaxis: { title: isXY ? 'y' : 't', color: textColor },
                font: { color: textColor }
            }, { responsive: true });
        } catch(e) {
            container.innerHTML = '<p style="color:var(--text-muted);">Contour error: ' + (e.message || '') + '</p>';
        }
    }

    // ===== Time Animation =====
    function renderAnimation(data) {
        var container = document.getElementById('pde-animate-container');
        var controls = document.getElementById('pde-animate-controls');
        if (!container) return;

        // Schrodinger: plot eigenstates
        if (currentMode === 'schrodinger' && data.states) {
            renderSchrodingerPlot(data, container);
            if (controls) controls.style.display = 'none';
            return;
        }

        if (!data.z || data.z.length < 2) {
            container.innerHTML = '<p style="color:var(--text-muted);">Not enough frames for animation.</p>';
            return;
        }

        var xArr = Array.isArray(data.x[0]) ? data.x[0] : data.x;
        var tArr = data.y && Array.isArray(data.y[0]) ? data.y.map(function(r) { return r[0]; }) : data.y;
        var nFrames = data.z.length;

        if (controls) controls.style.display = '';
        var slider = document.getElementById('pde-anim-slider');
        var timeLabel = document.getElementById('pde-anim-time');
        if (slider) { slider.min = 0; slider.max = nFrames - 1; slider.value = 0; }

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var bgColor = isDark ? '#1e293b' : '#ffffff';
        var lineColor = '#0891b2';
        var textColor = isDark ? '#cbd5e1' : '#1e293b';

        // Find global y range
        var yMin = Infinity, yMax = -Infinity;
        data.z.forEach(function(row) {
            row.forEach(function(v) {
                if (v < yMin) yMin = v;
                if (v > yMax) yMax = v;
            });
        });
        var pad = (yMax - yMin) * 0.1 || 0.5;

        Plotly.newPlot(container, [{
            x: xArr,
            y: data.z[0],
            type: 'scatter',
            mode: 'lines',
            line: { color: lineColor, width: 2 },
            name: 'u(x,t)'
        }], {
            margin: { t: 30, r: 20, b: 50, l: 50 },
            paper_bgcolor: bgColor,
            plot_bgcolor: bgColor,
            xaxis: { title: 'x', color: textColor },
            yaxis: { title: 'u', range: [yMin - pad, yMax + pad], color: textColor },
            font: { color: textColor }
        }, { responsive: true });

        function updateFrame(idx) {
            if (idx >= nFrames) idx = 0;
            Plotly.restyle(container, { y: [data.z[idx]] });
            if (timeLabel && tArr) timeLabel.textContent = 't=' + (tArr[idx] !== undefined ? tArr[idx].toFixed(3) : idx);
            if (slider) slider.value = idx;
        }

        // Controls
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        animFrame = 0;

        var playBtn = document.getElementById('pde-anim-play');
        var pauseBtn = document.getElementById('pde-anim-pause');
        if (playBtn) playBtn.onclick = function() {
            if (animInterval) return;
            animInterval = setInterval(function() {
                animFrame = (animFrame + 1) % nFrames;
                updateFrame(animFrame);
            }, 120);
        };
        if (pauseBtn) pauseBtn.onclick = function() {
            if (animInterval) { clearInterval(animInterval); animInterval = null; }
        };
        if (slider) slider.oninput = function() {
            animFrame = parseInt(this.value);
            updateFrame(animFrame);
        };
    }

    function renderSchrodingerPlot(data, container) {
        if (!data.x || !data.states || data.states.length === 0) return;
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var bgColor = isDark ? '#1e293b' : '#ffffff';
        var textColor = isDark ? '#cbd5e1' : '#1e293b';
        var colors = ['#0891b2', '#db2777', '#16a34a', '#f59e0b', '#8b5cf6', '#ef4444', '#06b6d4', '#84cc16', '#f97316', '#6366f1'];

        var traces = [];
        // Potential
        if (data.V) {
            var vMax = Math.max.apply(null, data.V.filter(function(v) { return v < 1e8; }));
            var vNorm = data.V.map(function(v) { return Math.min(v, vMax); });
            traces.push({ x: data.x, y: vNorm, type: 'scatter', mode: 'lines', line: { color: '#94a3b8', width: 1, dash: 'dot' }, name: 'V(x)' });
        }
        data.states.forEach(function(st, i) {
            var scaled = st.psi.map(function(p) { return p * p * 20 + st.E * 0.2; });
            traces.push({ x: data.x, y: scaled, type: 'scatter', mode: 'lines', line: { color: colors[i % colors.length], width: 2 }, name: 'n=' + (i + 1) + ' E=' + st.E.toFixed(2) });
        });

        Plotly.newPlot(container, traces, {
            margin: { t: 30, r: 20, b: 50, l: 60 },
            paper_bgcolor: bgColor, plot_bgcolor: bgColor,
            xaxis: { title: 'x', color: textColor },
            yaxis: { title: '|psi|^2 (shifted by E)', color: textColor },
            font: { color: textColor },
            showlegend: true, legend: { font: { size: 10, color: textColor } }
        }, { responsive: true });
    }

    // ===== Compute =====
    computeBtn.addEventListener('click', doCompute);

    var isComputing = false;

    function setComputing(busy) {
        isComputing = busy;
        if (computeBtn) {
            computeBtn.disabled = busy;
            computeBtn.textContent = busy ? 'Solving...' : 'Solve PDE';
        }
    }

    function doCompute() {
        if (isComputing) return;
        setComputing(true);

        var code = buildCode();
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem;"><div class="pde-spinner" style="width:24px;height:24px;border-width:3px;margin:0 auto 1rem;"></div><p style="color:var(--text-secondary);font-size:0.9375rem;">Solving ' + getModeName() + '...</p></div>';
        if (emptyState) emptyState.style.display = 'none';
        if (exportRow) exportRow.style.display = 'none';

        var controller = new AbortController();
        var timeoutId = setTimeout(function() { controller.abort(); }, 90000);

        fetch((window.PDE_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: controller.signal
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            clearTimeout(timeoutId);
            setComputing(false);
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();
            if (!stdout || (stderr && /error|exception|traceback/i.test(stderr) && !stdout)) {
                showError(stderr || 'Computation failed.');
                return;
            }
            showResult(stdout);
        })
        .catch(function(err) {
            clearTimeout(timeoutId);
            setComputing(false);
            showError(err.name === 'AbortError' ? 'Request timed out (90s)' : err.message);
        });
    }

    // ===== Export: Copy LaTeX =====
    var copyBtn = document.getElementById('pde-copy-latex-btn');
    if (copyBtn) copyBtn.addEventListener('click', function() {
        if (!lastResultLatex) return;
        navigator.clipboard.writeText(lastResultLatex).then(function() {
            copyBtn.textContent = 'Copied!';
            setTimeout(function() { copyBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg> LaTeX'; }, 2000);
        });
    });

    // ===== Export: Download PDF =====
    var pdfBtn = document.getElementById('pde-download-pdf-btn');
    if (pdfBtn) pdfBtn.addEventListener('click', function() {
        var w = window.open('', '_blank');
        if (!w) return;
        var stepsHtml = '';
        if (lastStepsData && lastStepsData.length > 0) {
            stepsHtml = '<h3 style="margin-top:1.5rem;">Solution Steps</h3><ol>';
            lastStepsData.forEach(function(s) {
                stepsHtml += '<li><strong>' + escapeHtml(s.title) + '</strong><br><code>' + escapeHtml(s.latex) + '</code></li>';
            });
            stepsHtml += '</ol>';
        }
        w.document.write('<!DOCTYPE html><html><head><title>PDE Solution - ' + getModeName() + '</title><style>body{font-family:Georgia,serif;max-width:700px;margin:2rem auto;padding:1rem;} code{background:#f1f5f9;padding:0.2rem 0.4rem;border-radius:3px;font-size:0.9rem;} h1{color:#0891b2;} ol li{margin-bottom:0.75rem;line-height:1.6;}</style></head><body><h1>' + getModeName() + ' - PDE Solver</h1><p><strong>Result:</strong> ' + escapeHtml(lastResultText) + '</p><p><strong>LaTeX:</strong> <code>' + escapeHtml(lastResultLatex) + '</code></p>' + stepsHtml + '<hr><p style="color:#64748b;font-size:0.8rem;">Generated by 8gwifi.org PDE Solver Calculator</p></body></html>');
        w.document.close();
        w.print();
    });

    // ===== Export: Worksheet =====
    var worksheetBtn = document.getElementById('pde-worksheet-btn');
    if (worksheetBtn) worksheetBtn.addEventListener('click', function() {
        if (typeof WorksheetEngine !== 'undefined') {
            WorksheetEngine.open({
                jsonUrl: 'https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@refs/heads/master/src/main/webapp/worksheet/math/calculus/pde.json',
                title: 'Partial Differential Equations',
                accentColor: '#0891b2',
                branding: '8gwifi.org',
                defaultCount: 20
            });
        }
    });

    // ===== Export: Share =====
    var shareBtn = document.getElementById('pde-share-btn');
    if (shareBtn) shareBtn.addEventListener('click', function() {
        var params = 'mode=' + currentMode;
        if (currentMode === 'heat') params += '&k=' + (heatK.value) + '&L=' + (heatL.value) + '&tmax=' + (heatTmax.value) + '&ic=' + (heatIC.value) + '&bc=' + (heatBC.value);
        else if (currentMode === 'wave') params += '&c=' + (waveC.value) + '&L=' + (waveL.value) + '&tmax=' + (waveTmax.value) + '&ic=' + (waveIC.value) + '&bc=' + (waveBC.value);
        else if (currentMode === 'linear1') params += '&a=' + (linear1A.value) + '&b=' + (linear1B.value) + '&c=' + (linear1C.value) + '&g=' + encodeURIComponent(linear1G.value);
        var url = window.location.origin + window.location.pathname + '?' + params;
        navigator.clipboard.writeText(url).then(function() {
            shareBtn.textContent = 'Copied!';
            setTimeout(function() { shareBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg> Share'; }, 2000);
        });
    });

    // ===== URL Parameter Restore =====
    function restoreFromURL() {
        var params = new URLSearchParams(window.location.search);
        var mode = params.get('mode');
        if (!mode || !allWraps[mode]) return;
        // Click the correct mode button
        document.querySelectorAll('.pde-mode-btn').forEach(function(btn) {
            if (btn.getAttribute('data-mode') === mode) btn.click();
        });
        if (mode === 'heat') {
            if (params.get('k')) heatK.value = params.get('k');
            if (params.get('L')) heatL.value = params.get('L');
            if (params.get('tmax')) heatTmax.value = params.get('tmax');
            if (params.get('ic')) heatIC.value = params.get('ic');
            if (params.get('bc')) heatBC.value = params.get('bc');
        } else if (mode === 'wave') {
            if (params.get('c')) waveC.value = params.get('c');
            if (params.get('L')) waveL.value = params.get('L');
            if (params.get('tmax')) waveTmax.value = params.get('tmax');
            if (params.get('ic')) waveIC.value = params.get('ic');
            if (params.get('bc')) waveBC.value = params.get('bc');
        } else if (mode === 'linear1') {
            if (params.get('a')) linear1A.value = params.get('a');
            if (params.get('b')) linear1B.value = params.get('b');
            if (params.get('c')) linear1C.value = params.get('c');
            if (params.get('g')) linear1G.value = params.get('g');
        }
        updatePreview();
    }
    restoreFromURL();

    // Init
    updatePreview();

    window.pdeGetContext = function pdeGetContext() {
        return {
            toolType: 'pde',
            mode: currentMode,
            params: buildParamsSnapshot(),
            resultSummary: (lastResultText || lastResultLatex || '').slice(0, 4000)
        };
    };
})();
