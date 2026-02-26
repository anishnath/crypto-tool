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

    // ===== Code Generators =====

    function buildHeatCode() {
        var k = parseNum(heatK.value, 1);
        var L = parseNum(heatL.value, 1);
        var tmax = parseNum(heatTmax.value, 0.5);
        var ic = (heatIC && heatIC.value) || 'sin';
        var bc = (heatBC && heatBC.value) || 'dirichlet';
        return [
            'import numpy as np, json',
            'k = ' + k,
            'L = ' + L,
            't_max = ' + tmax,
            'nx = 80',
            'dx = L / (nx - 1)',
            'dt = 0.4 * dx**2 / k',
            'r = k * dt / (dx**2)',
            'x = np.linspace(0, L, nx)',
            'ic_type = "' + ic + '"',
            'bc_type = "' + bc + '"',
            'if ic_type == "sin": u = np.sin(np.pi * x / L)',
            'elif ic_type == "gauss": u = np.exp(-40 * (x - L/2)**2)',
            'else: u = np.where(x < L/2, 1.0, 0.0)',
            '# Apply initial BCs',
            'if bc_type == "dirichlet": u[0], u[-1] = 0, 0',
            'elif bc_type == "periodic": u[-1] = u[0]',
            'n_snap = 20',
            'U_full = [u.copy()]',
            't_vals = [0.0]',
            't_now = 0',
            'nt_steps = 0',
            'while len(U_full) < n_snap and t_now < t_max:',
            '    u_new = u.copy()',
            '    for i in range(1, nx-1):',
            '        u_new[i] = u[i] + r * (u[i+1] - 2*u[i] + u[i-1])',
            '    if bc_type == "dirichlet": u_new[0], u_new[-1] = 0, 0',
            '    elif bc_type == "neumann": u_new[0] = u_new[1]; u_new[-1] = u_new[-2]',
            '    elif bc_type == "robin": u_new[0] = u_new[1]/(1+dx); u_new[-1] = u_new[-2]/(1+dx)',
            '    elif bc_type == "periodic": u_new[0] = u[0] + r*(u[1]-2*u[0]+u[-2]); u_new[-1] = u_new[0]',
            '    u = u_new',
            '    t_now += dt',
            '    nt_steps += 1',
            '    if nt_steps % max(1,int(t_max/dt/n_snap)) == 0:',
            '        t_vals.append(t_now)',
            '        U_full.append(u.copy())',
            'if len(U_full) < 2: U_full.append(u.copy()); t_vals.append(t_now)',
            'U_full = np.array(U_full)',
            't_vals = np.array(t_vals)',
            'X, T = np.meshgrid(x, t_vals)',
            'print("SURFACE_X:" + json.dumps(X.tolist()))',
            'print("SURFACE_Y:" + json.dumps(T.tolist()))',
            'print("SURFACE_Z:" + json.dumps(U_full.tolist()))',
            'print("RESULT:Heat equation solved")',
            'print("TEXT:u_t = " + str(k) + " u_xx")',
            'print("META_R:" + str(round(r,6)))',
            'print("META_DX:" + str(round(dx,6)))',
            'print("META_DT:" + str(round(dt,6)))',
            'print("META_NT:" + str(nt_steps))',
            'print("META_METHOD:Explicit Forward-Time Central-Space (FTCS)")',
            'print("META_BC:' + bc + '")',
            'print("META_STABLE:" + str(r <= 0.5))',
            'print("STEP1_TITLE:Given PDE")',
            'print("STEP1_LATEX:u_t = k \\\\, u_{xx}, \\\\quad k=" + str(k))',
            'print("STEP2_TITLE:Domain & initial condition")',
            'print("STEP2_LATEX:x \\\\in [0,' + L + '], \\\\quad t \\\\in [0,' + tmax + '], \\\\quad u(x,0) = \\\\text{' + ic + '}")',
            'print("STEP3_TITLE:Boundary conditions")',
            'bc_desc = {"dirichlet":"u(0,t)=0,\\\\; u(L,t)=0","neumann":"\\\\frac{\\\\partial u}{\\\\partial x}(0,t)=0,\\\\; \\\\frac{\\\\partial u}{\\\\partial x}(L,t)=0","robin":"\\\\frac{\\\\partial u}{\\\\partial x}+u=0 \\\\text{ at boundaries}","periodic":"u(0,t)=u(L,t)"}',
            'print("STEP3_LATEX:" + bc_desc.get("' + bc + '","Dirichlet"))',
            'print("STEP4_TITLE:Discretization (FTCS finite difference)")',
            'print("STEP4_LATEX:u_i^{n+1} = u_i^n + r(u_{i+1}^n - 2u_i^n + u_{i-1}^n), \\\\quad r = k\\\\Delta t/\\\\Delta x^2 = " + str(round(r,4)))',
            'print("STEP5_TITLE:Stability check")',
            'stable_msg = "r = " + str(round(r,4)) + " \\\\leq 0.5 \\\\; \\\\checkmark \\\\text{ STABLE}" if r <= 0.5 else "r = " + str(round(r,4)) + " > 0.5 \\\\; \\\\text{WARNING: may be unstable}"',
            'print("STEP5_LATEX:" + stable_msg)',
            'print("STEP6_TITLE:Grid parameters")',
            'print("STEP6_LATEX:\\\\Delta x = " + str(round(dx,6)) + ", \\\\quad \\\\Delta t = " + str(round(dt,6)) + ", \\\\quad " + str(nt_steps) + " \\\\text{ time steps}")'
        ].join('\n');
    }

    function buildWaveCode() {
        var c = parseNum(waveC.value, 1);
        var L = parseNum(waveL.value, 1);
        var tmax = parseNum(waveTmax.value, 2);
        var ic = (waveIC && waveIC.value) || 'sin';
        var bc = (waveBC && waveBC.value) || 'dirichlet';
        return [
            'import numpy as np, json',
            'c = ' + c,
            'L = ' + L,
            't_max = ' + tmax,
            'nx = 80',
            'dx = L / (nx - 1)',
            'dt = dx / (2 * c)',
            'cfl = c * dt / dx',
            'r = cfl**2',
            'x = np.linspace(0, L, nx)',
            'ic_type = "' + ic + '"',
            'bc_type = "' + bc + '"',
            'u0 = np.zeros(nx)',
            'if ic_type == "sin": u0 = np.sin(np.pi * x / L)',
            'elif ic_type == "gauss": u0 = np.exp(-40 * (x - L/2)**2)',
            'else: u0 = np.maximum(0, 1 - 4*np.abs(x - L/2)/L)',
            'if bc_type == "dirichlet": u0[0], u0[-1] = 0, 0',
            'u_prev = u0.copy()',
            'u_curr = u0.copy()',
            'for i in range(1, nx-1):',
            '    u_curr[i] = u0[i] + 0.5*r*(u0[i+1] - 2*u0[i] + u0[i-1])',
            'if bc_type == "dirichlet": u_curr[0], u_curr[-1] = 0, 0',
            'elif bc_type == "neumann": u_curr[0] = u_curr[1]; u_curr[-1] = u_curr[-2]',
            'elif bc_type == "mixed": u_curr[0] = 0; u_curr[-1] = u_curr[-2]',
            'n_snap = 25',
            'snap_times = np.linspace(0, t_max, n_snap)',
            'U_full = [u0.copy()]',
            't_now = dt',
            'snap_idx = 1',
            'nt_steps = 1',
            'while snap_idx < n_snap:',
            '    u_next = np.zeros(nx)',
            '    for i in range(1, nx-1):',
            '        u_next[i] = 2*u_curr[i] - u_prev[i] + r*(u_curr[i+1] - 2*u_curr[i] + u_curr[i-1])',
            '    if bc_type == "dirichlet": u_next[0], u_next[-1] = 0, 0',
            '    elif bc_type == "neumann": u_next[0] = u_next[1]; u_next[-1] = u_next[-2]',
            '    elif bc_type == "mixed": u_next[0] = 0; u_next[-1] = u_next[-2]',
            '    u_prev, u_curr = u_curr, u_next',
            '    t_now += dt',
            '    nt_steps += 1',
            '    if snap_idx < n_snap and t_now >= snap_times[snap_idx]:',
            '        U_full.append(u_curr.copy())',
            '        snap_idx += 1',
            '    if nt_steps > 5000: break',
            'U_full = np.array(U_full[:n_snap])',
            'actual_t = snap_times[:len(U_full)]',
            'X, T = np.meshgrid(x, actual_t)',
            'print("SURFACE_X:" + json.dumps(X.tolist()))',
            'print("SURFACE_Y:" + json.dumps(T.tolist()))',
            'print("SURFACE_Z:" + json.dumps(U_full.tolist()))',
            'print("RESULT:Wave equation solved")',
            'print("TEXT:u_tt = " + str(c) + "^2 u_xx")',
            'print("META_CFL:" + str(round(cfl,6)))',
            'print("META_DX:" + str(round(dx,6)))',
            'print("META_DT:" + str(round(dt,6)))',
            'print("META_NT:" + str(nt_steps))',
            'print("META_METHOD:Explicit Central Difference (Leapfrog)")',
            'print("META_BC:' + bc + '")',
            'print("META_STABLE:" + str(cfl <= 1.0))',
            'print("STEP1_TITLE:Given PDE")',
            'print("STEP1_LATEX:u_{tt} = c^2 u_{xx}, \\\\quad c=" + str(c))',
            'print("STEP2_TITLE:Domain & initial condition")',
            'print("STEP2_LATEX:x \\\\in [0,' + L + '], \\\\; t \\\\in [0,' + tmax + '], \\\\; u(x,0)=\\\\text{' + ic + '}, \\\\; u_t(x,0)=0")',
            'print("STEP3_TITLE:Boundary conditions (' + bc + ')")',
            'bc_desc = {"dirichlet":"u(0,t)=0,\\\\; u(L,t)=0 \\\\text{ (fixed ends)}","neumann":"u_x(0,t)=0,\\\\; u_x(L,t)=0 \\\\text{ (free ends)}","mixed":"u(0,t)=0,\\\\; u_x(L,t)=0 \\\\text{ (fixed-free)}"}',
            'print("STEP3_LATEX:" + bc_desc.get("' + bc + '","Dirichlet"))',
            'print("STEP4_TITLE:Discretization (central difference)")',
            'print("STEP4_LATEX:u_i^{n+1} = 2u_i^n - u_i^{n-1} + C^2(u_{i+1}^n - 2u_i^n + u_{i-1}^n)")',
            'print("STEP5_TITLE:CFL stability check")',
            'cfl_msg = "C = c\\\\Delta t/\\\\Delta x = " + str(round(cfl,4)) + " \\\\leq 1 \\\\; \\\\checkmark" if cfl <= 1 else "C = " + str(round(cfl,4)) + " > 1 \\\\; \\\\text{UNSTABLE}"',
            'print("STEP5_LATEX:" + cfl_msg)',
            'print("STEP6_TITLE:Grid parameters")',
            'print("STEP6_LATEX:\\\\Delta x=" + str(round(dx,6)) + ",\\\\; \\\\Delta t=" + str(round(dt,6)) + ",\\\\; " + str(nt_steps) + " \\\\text{ steps}")'
        ].join('\n');
    }

    function buildLaplaceCode() {
        var nx = parseInt(laplaceNx.value, 10) || 20;
        var ny = parseInt(laplaceNy.value, 10) || 20;
        var bc = (laplaceBC && laplaceBC.value) || 'dirichlet';
        nx = Math.max(5, Math.min(50, nx));
        ny = Math.max(5, Math.min(50, ny));
        return [
            'import numpy as np, json',
            'nx, ny = ' + nx + ', ' + ny,
            'bc_type = "' + bc + '"',
            'u = np.zeros((ny, nx))',
            'if bc_type == "dirichlet":',
            '    u[-1, :] = 1',
            'elif bc_type == "mixed":',
            '    u[:, 0] = 1; u[:, -1] = 0',
            'elif bc_type == "neumann_top":',
            '    u[-1, :] = 1',
            'elif bc_type == "robin":',
            '    u[-1, :] = 1',
            'n_iter = 0',
            'for _ in range(3000):',
            '    u_new = u.copy()',
            '    for j in range(1, ny-1):',
            '        for i in range(1, nx-1):',
            '            u_new[j,i] = 0.25*(u[j,i+1]+u[j,i-1]+u[j+1,i]+u[j-1,i])',
            '    # Re-apply BCs',
            '    if bc_type == "dirichlet":',
            '        u_new[0,:] = 0; u_new[-1,:] = 1; u_new[:,0] = 0; u_new[:,-1] = 0',
            '    elif bc_type == "mixed":',
            '        u_new[:,0] = 1; u_new[:,-1] = 0',
            '    elif bc_type == "neumann_top":',
            '        u_new[-1,:] = u_new[-2,:]; u_new[0,:] = 0; u_new[:,0] = 0; u_new[:,-1] = 0',
            '    elif bc_type == "robin":',
            '        dx = 1.0/(nx-1)',
            '        u_new[-1,:] = u_new[-2,:]/(1+dx)',
            '        u_new[0,:] = 0; u_new[:,0] = 0; u_new[:,-1] = 0',
            '    n_iter += 1',
            '    if np.max(np.abs(u_new - u)) < 1e-6: break',
            '    u = u_new',
            'x = np.linspace(0, 1, nx)',
            'y = np.linspace(0, 1, ny)',
            'X, Y = np.meshgrid(x, y)',
            'print("SURFACE_X:" + json.dumps(X.tolist()))',
            'print("SURFACE_Y:" + json.dumps(Y.tolist()))',
            'print("SURFACE_Z:" + json.dumps(u.tolist()))',
            'print("RESULT:Laplace equation solved")',
            'print("TEXT:u_xx + u_yy = 0")',
            'print("META_ITER:" + str(n_iter))',
            'print("META_METHOD:Jacobi Iterative (Gauss-Seidel)")',
            'print("META_BC:' + bc + '")',
            'print("META_CONVERGED:" + str(n_iter < 3000))',
            'print("STEP1_TITLE:Given PDE")',
            'print("STEP1_LATEX:\\\\nabla^2 u = u_{xx} + u_{yy} = 0 \\\\quad \\\\text{(Laplace equation)}")',
            'print("STEP2_TITLE:Domain")',
            'print("STEP2_LATEX:(x,y) \\\\in [0,1] \\\\times [0,1], \\\\quad ' + nx + '\\\\times' + ny + ' \\\\text{ grid}")',
            'print("STEP3_TITLE:Boundary conditions (' + bc + ')")',
            'bc_map = {"dirichlet":"u=0 \\\\text{ on 3 sides}, \\\\; u=1 \\\\text{ on top}","mixed":"u=1 \\\\text{ left}, \\\\; u=0 \\\\text{ right}","neumann_top":"\\\\frac{\\\\partial u}{\\\\partial y}=0 \\\\text{ top}, \\\\; u=0 \\\\text{ other sides}","robin":"\\\\frac{\\\\partial u}{\\\\partial n}+u=0 \\\\text{ top}, \\\\; u=0 \\\\text{ sides}"}',
            'print("STEP3_LATEX:" + bc_map.get("' + bc + '","Dirichlet"))',
            'print("STEP4_TITLE:Iterative scheme")',
            'print("STEP4_LATEX:u_{i,j}^{(k+1)} = \\\\frac{1}{4}(u_{i+1,j}^{(k)} + u_{i-1,j}^{(k)} + u_{i,j+1}^{(k)} + u_{i,j-1}^{(k)})")',
            'print("STEP5_TITLE:Convergence")',
            'conv_msg = "\\\\text{Converged in } " + str(n_iter) + " \\\\text{ iterations (tol }10^{-6}\\\\text{)}" if n_iter < 3000 else "\\\\text{Max iterations reached (3000)}"',
            'print("STEP5_LATEX:" + conv_msg)'
        ].join('\n');
    }

    function buildPoissonCode() {
        var nx = parseInt(poissonNx.value, 10) || 25;
        var ny = parseInt(poissonNy.value, 10) || 25;
        var source = (poissonSource && poissonSource.value) || 'const';
        var bc = (poissonBC && poissonBC.value) || 'dirichlet';
        nx = Math.max(5, Math.min(50, nx));
        ny = Math.max(5, Math.min(50, ny));
        var srcMap = {
            'const': 'f = -2 * np.ones((ny, nx))',
            'gaussian': 'f = -100 * np.exp(-50*((XX-0.5)**2 + (YY-0.5)**2))',
            'sin': 'f = -2*np.pi**2 * np.sin(np.pi*XX) * np.sin(np.pi*YY)',
            'dipole': 'f = -100*np.exp(-80*((XX-0.3)**2+(YY-0.5)**2)) + 100*np.exp(-80*((XX-0.7)**2+(YY-0.5)**2))'
        };
        return [
            'import numpy as np, json',
            'nx, ny = ' + nx + ', ' + ny,
            'x = np.linspace(0, 1, nx)',
            'y = np.linspace(0, 1, ny)',
            'XX, YY = np.meshgrid(x, y)',
            'dx = 1.0/(nx-1)',
            'dy = 1.0/(ny-1)',
            srcMap[source] || srcMap['const'],
            'u = np.zeros((ny, nx))',
            'bc_type = "' + bc + '"',
            'n_iter = 0',
            'for _ in range(5000):',
            '    u_new = u.copy()',
            '    for j in range(1, ny-1):',
            '        for i in range(1, nx-1):',
            '            u_new[j,i] = 0.25*(u[j,i+1]+u[j,i-1]+u[j+1,i]+u[j-1,i] - dx**2*f[j,i])',
            '    if bc_type == "dirichlet":',
            '        u_new[0,:]=0; u_new[-1,:]=0; u_new[:,0]=0; u_new[:,-1]=0',
            '    elif bc_type == "neumann":',
            '        u_new[0,:]=u_new[1,:]; u_new[-1,:]=u_new[-2,:]; u_new[:,0]=u_new[:,1]; u_new[:,-1]=u_new[:,-2]',
            '    elif bc_type == "mixed":',
            '        u_new[:,0]=0; u_new[:,-1]=0; u_new[0,:]=u_new[1,:]; u_new[-1,:]=u_new[-2,:]',
            '    n_iter += 1',
            '    if np.max(np.abs(u_new - u)) < 1e-6: break',
            '    u = u_new',
            'X, Y = np.meshgrid(x, y)',
            'print("SURFACE_X:" + json.dumps(X.tolist()))',
            'print("SURFACE_Y:" + json.dumps(Y.tolist()))',
            'print("SURFACE_Z:" + json.dumps(u.tolist()))',
            'print("RESULT:Poisson equation solved")',
            'print("TEXT:nabla^2 u = f(x,y)")',
            'print("META_ITER:" + str(n_iter))',
            'print("META_METHOD:Jacobi Iterative")',
            'print("META_BC:' + bc + '")',
            'print("META_CONVERGED:" + str(n_iter < 5000))',
            'print("META_SOURCE:' + source + '")',
            'print("STEP1_TITLE:Given PDE")',
            'print("STEP1_LATEX:\\\\nabla^2 u = f(x,y) \\\\quad \\\\text{(Poisson equation)}")',
            'print("STEP2_TITLE:Source term")',
            'src_desc = {"const":"f = -2","gaussian":"f = -100 e^{-50((x-0.5)^2+(y-0.5)^2)}","sin":"f = -2\\\\pi^2 \\\\sin(\\\\pi x)\\\\sin(\\\\pi y)","dipole":"\\\\text{Two point sources (dipole)}"}',
            'print("STEP2_LATEX:" + src_desc.get("' + source + '","f=-2"))',
            'print("STEP3_TITLE:Boundary conditions (' + bc + ')")',
            'bc_desc = {"dirichlet":"u=0 \\\\text{ on all edges}","neumann":"\\\\frac{\\\\partial u}{\\\\partial n}=0 \\\\text{ on all edges}","mixed":"u=0 \\\\text{ left/right}, \\\\; \\\\frac{\\\\partial u}{\\\\partial y}=0 \\\\text{ top/bottom}"}',
            'print("STEP3_LATEX:" + bc_desc.get("' + bc + '","Dirichlet"))',
            'print("STEP4_TITLE:Discretization")',
            'print("STEP4_LATEX:u_{i,j}^{(k+1)} = \\\\frac{1}{4}(u_{i+1,j}+u_{i-1,j}+u_{i,j+1}+u_{i,j-1} - \\\\Delta x^2 f_{i,j})")',
            'print("STEP5_TITLE:Convergence")',
            'print("STEP5_LATEX:\\\\text{Converged in } " + str(n_iter) + " \\\\text{ iterations}")'
        ].join('\n');
    }

    function buildTransportCode() {
        var c = parseNum(transportC.value, 1);
        var L = parseNum(transportL.value, 2);
        var tmax = parseNum(transportTmax.value, 1.5);
        var ic = (transportIC && transportIC.value) || 'gauss';
        var scheme = (transportScheme && transportScheme.value) || 'upwind';
        return [
            'import numpy as np, json',
            'c = ' + c,
            'L = ' + L,
            't_max = ' + tmax,
            'nx = 100',
            'dx = L / (nx - 1)',
            'cfl_target = 0.8',
            'dt = cfl_target * dx / abs(c)',
            'cfl = abs(c) * dt / dx',
            'x = np.linspace(0, L, nx)',
            'ic_type = "' + ic + '"',
            'scheme = "' + scheme + '"',
            'if ic_type == "gauss": u = np.exp(-40*(x - L/4)**2)',
            'elif ic_type == "step": u = np.where(x < L/4, 1.0, 0.0)',
            'elif ic_type == "sin": u = np.sin(np.pi*x/L)',
            'else:',
            '    u = np.where((x > L/4) & (x < L/2), 1.0, 0.0)',
            'n_snap = 25',
            'U_full = [u.copy()]',
            't_vals = [0.0]',
            't_now = 0',
            'nt_steps = 0',
            'while len(U_full) < n_snap and t_now < t_max:',
            '    u_new = u.copy()',
            '    if scheme == "upwind":',
            '        if c > 0:',
            '            for i in range(1, nx):',
            '                u_new[i] = u[i] - cfl*(u[i]-u[i-1])',
            '        else:',
            '            for i in range(0, nx-1):',
            '                u_new[i] = u[i] - cfl*(u[i+1]-u[i])',
            '    elif scheme == "lax_wendroff":',
            '        for i in range(1, nx-1):',
            '            u_new[i] = u[i] - 0.5*cfl*(u[i+1]-u[i-1]) + 0.5*cfl**2*(u[i+1]-2*u[i]+u[i-1])',
            '    elif scheme == "lax_friedrichs":',
            '        for i in range(1, nx-1):',
            '            u_new[i] = 0.5*(u[i+1]+u[i-1]) - 0.5*cfl*(u[i+1]-u[i-1])',
            '    u_new[0] = 0; u_new[-1] = 0',
            '    u = u_new',
            '    t_now += dt',
            '    nt_steps += 1',
            '    if nt_steps % max(1,int(t_max/dt/n_snap)) == 0:',
            '        t_vals.append(t_now)',
            '        U_full.append(u.copy())',
            'U_full = np.array(U_full)',
            't_vals = np.array(t_vals[:len(U_full)])',
            'X, T = np.meshgrid(x, t_vals)',
            'print("SURFACE_X:" + json.dumps(X.tolist()))',
            'print("SURFACE_Y:" + json.dumps(T.tolist()))',
            'print("SURFACE_Z:" + json.dumps(U_full.tolist()))',
            'print("RESULT:Transport equation solved")',
            'print("TEXT:u_t + ' + c + ' u_x = 0")',
            'print("META_CFL:" + str(round(cfl,6)))',
            'print("META_DX:" + str(round(dx,6)))',
            'print("META_DT:" + str(round(dt,6)))',
            'print("META_NT:" + str(nt_steps))',
            'print("META_METHOD:' + ({ upwind:'Upwind (1st order)', lax_wendroff:'Lax-Wendroff (2nd order)', lax_friedrichs:'Lax-Friedrichs' }[scheme] || 'Upwind') + '")',
            'print("META_BC:dirichlet")',
            'print("META_STABLE:" + str(cfl <= 1.0))',
            'print("STEP1_TITLE:Given PDE")',
            'print("STEP1_LATEX:u_t + c \\\\, u_x = 0, \\\\quad c = ' + c + '")',
            'print("STEP2_TITLE:Initial profile")',
            'print("STEP2_LATEX:u(x,0) = \\\\text{' + ic + '}, \\\\quad x \\\\in [0, ' + L + ']")',
            'print("STEP3_TITLE:Numerical scheme (' + scheme.replace('_',' ') + ')")',
            'scheme_latex = {"upwind":"u_i^{n+1} = u_i^n - C(u_i^n - u_{i-1}^n) \\\\text{ (1st order)}","lax_wendroff":"u_i^{n+1} = u_i^n - \\\\frac{C}{2}(u_{i+1}^n-u_{i-1}^n)+\\\\frac{C^2}{2}(u_{i+1}^n-2u_i^n+u_{i-1}^n)","lax_friedrichs":"u_i^{n+1}=\\\\frac{1}{2}(u_{i+1}^n+u_{i-1}^n)-\\\\frac{C}{2}(u_{i+1}^n-u_{i-1}^n)"}',
            'print("STEP3_LATEX:" + scheme_latex.get("' + scheme + '","upwind"))',
            'print("STEP4_TITLE:CFL condition")',
            'print("STEP4_LATEX:C = |c|\\\\Delta t/\\\\Delta x = " + str(round(cfl,4)) + (" \\\\leq 1 \\\\; \\\\checkmark" if cfl <= 1 else " > 1 \\\\; \\\\text{UNSTABLE}"))',
            'print("STEP5_TITLE:Solution")',
            'print("STEP5_LATEX:\\\\text{' + str(nt_steps) + ' time steps, pulse advects at speed }c = ' + c + '")'
        ].join('\n');
    }

    function buildSchrodingerCode() {
        var L = parseNum(schrodingerL.value, 1);
        var potential = (schrodingerPotential && schrodingerPotential.value) || 'infinite_well';
        var nstates = parseInt(schrodingerNstates.value, 10) || 5;
        nstates = Math.max(1, Math.min(10, nstates));
        return [
            'import numpy as np, json',
            'L = ' + L,
            'N = 200',
            'n_states = ' + nstates,
            'x = np.linspace(0, L, N)',
            'dx = x[1] - x[0]',
            'potential = "' + potential + '"',
            '# Build potential',
            'if potential == "infinite_well":',
            '    V = np.zeros(N)',
            'elif potential == "harmonic":',
            '    V = 0.5 * (x - L/2)**2 * 1000',
            'elif potential == "finite_well":',
            '    V = np.where((x > 0.2*L) & (x < 0.8*L), 0.0, 50.0)',
            'elif potential == "double_well":',
            '    V = 200*((x/L - 0.5)**2 - 0.04)**2',
            'else:',
            '    V = np.zeros(N)',
            '# Build Hamiltonian (h_bar^2/2m = 1)',
            'H = np.zeros((N, N))',
            'for i in range(1, N-1):',
            '    H[i,i] = 2.0/dx**2 + V[i]',
            '    H[i,i-1] = -1.0/dx**2',
            '    H[i,i+1] = -1.0/dx**2',
            'H[0,0] = 1e10; H[-1,-1] = 1e10',
            'eigenvalues, eigenvectors = np.linalg.eigh(H)',
            'E = eigenvalues[1:n_states+1]',
            'psi = eigenvectors[:, 1:n_states+1]',
            '# Normalize',
            'for j in range(n_states):',
            '    norm = np.sqrt(np.trapz(psi[:,j]**2, x))',
            '    if norm > 0: psi[:,j] /= norm',
            '# Build surface: rows = states, cols = x',
            'surf = []',
            'for j in range(n_states):',
            '    surf.append((psi[:,j]**2 + E[j]*0.01).tolist())',
            'state_labels = list(range(1, n_states+1))',
            'X, S = np.meshgrid(x, state_labels)',
            'print("SURFACE_X:" + json.dumps(X.tolist()))',
            'print("SURFACE_Y:" + json.dumps(S.tolist()))',
            'print("SURFACE_Z:" + json.dumps(surf))',
            '# Also output eigenstates as line plots (for animation tab)',
            'for j in range(n_states):',
            '    print("EIGEN_" + str(j) + "_E:" + str(round(float(E[j]),4)))',
            '    print("EIGEN_" + str(j) + "_PSI:" + json.dumps(psi[:,j].tolist()))',
            'print("EIGEN_X:" + json.dumps(x.tolist()))',
            'print("EIGEN_V:" + json.dumps(V.tolist()))',
            'print("EIGEN_N:" + str(n_states))',
            'print("RESULT:Schrodinger equation solved (' + potential.replace('_', ' ') + ')")',
            'E_str = ", ".join(["E_"+str(i+1)+"="+str(round(float(E[i]),2)) for i in range(min(n_states,5))])',
            'print("TEXT:" + E_str)',
            'print("META_METHOD:Matrix diagonalization (numpy.linalg.eigh)")',
            'print("META_BC:dirichlet")',
            'print("META_POTENTIAL:' + potential + '")',
            'print("META_NSTATES:" + str(n_states))',
            'print("STEP1_TITLE:Given PDE")',
            'print("STEP1_LATEX:-\\\\frac{\\\\hbar^2}{2m}\\\\frac{d^2\\\\psi}{dx^2} + V(x)\\\\psi = E\\\\psi")',
            'print("STEP2_TITLE:Potential")',
            'pot_desc = {"infinite_well":"V(x)=0 \\\\text{ inside }, V=\\\\infty \\\\text{ at walls}","harmonic":"V(x)=\\\\frac{1}{2}kx^2 \\\\text{ (harmonic oscillator)}","finite_well":"V=0 \\\\text{ inside}, V=50 \\\\text{ outside}","double_well":"V(x) = \\\\text{quartic double well}"}',
            'print("STEP2_LATEX:" + pot_desc.get("' + potential + '","V=0"))',
            'print("STEP3_TITLE:Discretization")',
            'print("STEP3_LATEX:H_{ij} = \\\\frac{-1}{\\\\Delta x^2}\\\\delta_{i,j\\\\pm 1} + (\\\\frac{2}{\\\\Delta x^2}+V_i)\\\\delta_{ij}, \\\\quad N=' + 'str(N)' + '")',
            'print("STEP4_TITLE:Eigenvalue problem")',
            'print("STEP4_LATEX:H\\\\psi_n = E_n\\\\psi_n \\\\quad \\\\text{solved via numpy.linalg.eigh}")',
            'print("STEP5_TITLE:Energy levels")',
            'print("STEP5_LATEX:" + E_str)'
        ].join('\n');
    }

    function buildLinear1Code() {
        var a = parseNum(linear1A ? linear1A.value : '', 1);
        var b = parseNum(linear1B ? linear1B.value : '', 1);
        var c = parseNum(linear1C ? linear1C.value : '', 1);
        var gExpr = (linear1G && linear1G.value) ? String(linear1G.value).trim() : '0';
        if (!gExpr) gExpr = '0';
        gExpr = gExpr.replace(/\s+/g, ' ').replace(/\^/g, '**').replace(/e\^\(/g, 'exp(');
        return [
            'from sympy import Function, Eq, symbols, exp, sin, cos, latex',
            'from sympy.solvers.pde import pdsolve, checkpdesol',
            'x, y = symbols("x y")',
            'f = Function("f")',
            'u = f(x, y)',
            'ux = u.diff(x)',
            'uy = u.diff(y)',
            'a, b, c = ' + a + ', ' + b + ', ' + c,
            'try:',
            '    G = ' + gExpr,
            'except: G = 0',
            'eq = Eq(a*ux + b*uy + c*u, G)',
            'try:',
            '    sol = pdsolve(eq)',
            '    print("RESULT:" + str(sol))',
            '    print("RESULT_LATEX:" + latex(sol))',
            '    chk = checkpdesol(eq, sol)',
            '    print("VERIFIED:" + str(chk[0]))',
            '    print("TEXT:a u_x + b u_y + c u = G, a=" + str(a) + " b=" + str(b) + " c=" + str(c))',
            '    print("META_METHOD:SymPy pdsolve (method of characteristics)")',
            '    print("META_BC:analytical")',
            '    print("STEP1_TITLE:Given PDE")',
            '    print("STEP1_LATEX:" + str(a) + "u_x + " + str(b) + "u_y + " + str(c) + "u = " + latex(G))',
            '    print("STEP2_TITLE:Method")',
            '    print("STEP2_LATEX:\\\\text{Method of characteristics (SymPy pdsolve)}")',
            '    print("STEP3_TITLE:General solution")',
            '    print("STEP3_LATEX:" + latex(sol.rhs))',
            '    print("STEP4_TITLE:Verification")',
            '    v_msg = "\\\\text{Verified } \\\\checkmark" if chk[0] else "\\\\text{Check: residual = }" + latex(chk[1])',
            '    print("STEP4_LATEX:" + v_msg)',
            'except Exception as e:',
            '    print("ERROR:" + str(e))'
        ].join('\n');
    }

    function buildCode() {
        switch (currentMode) {
            case 'heat': return buildHeatCode();
            case 'wave': return buildWaveCode();
            case 'laplace': return buildLaplaceCode();
            case 'poisson': return buildPoissonCode();
            case 'transport': return buildTransportCode();
            case 'schrodinger': return buildSchrodingerCode();
            case 'linear1': return buildLinear1Code();
            default: return buildHeatCode();
        }
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
        { f: 'a\\,u_x + b\\,u_y + c\\,u = G', m: '\\text{Characteristics (SymPy) | 1st-order linear}' }
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
        var methodLabel = meta.METHOD || (currentMode === 'linear1' ? 'SymPy pdsolve' : 'Finite Difference');
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
})();
