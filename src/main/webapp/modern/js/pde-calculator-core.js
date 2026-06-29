/**
 * PDE Calculator Core — shared NumPy/SymPy backbone for page + Math AI chat.
 * Same finite-difference / pdsolve engines as pde-solver-calculator.jsp.
 */
var PDECalculatorCore = (function () {
    'use strict';

    function parseNum(val, def) {
        var n = parseFloat(String(val).trim());
        return isNaN(n) ? def : n;
    }

    function param(p, key, def) {
        if (!p || p[key] == null) return def;
        var s = String(p[key]).trim();
        return s === '' ? def : p[key];
    }

    function line(stdout, key) {
        var m = stdout.match(new RegExp(key + ':([^\n]*)'));
        return m ? m[1].trim() : '';
    }

    function parseSteps(stdout) {
        var steps = [];
        var stepRe = /STEP(\d+)_TITLE:([^\n]*)/g;
        var m;
        while ((m = stepRe.exec(stdout)) !== null) {
            var idx = m[1];
            var latexMatch = stdout.match(new RegExp('STEP' + idx + '_LATEX:([^\n]*)'));
            steps.push({ title: m[2].trim(), latex: latexMatch ? latexMatch[1].trim() : '' });
        }
        return steps;
    }

    function parseMeta(stdout) {
        var meta = {};
        var metaRe = /META_(\w+):([^\n]*)/g;
        var m;
        while ((m = metaRe.exec(stdout)) !== null) meta[m[1]] = m[2].trim();
        return meta;
    }

    function buildHeatCode(p) {
        var k = parseNum(param(p, 'k', '1'), 1);
        var L = parseNum(param(p, 'L', '1'), 1);
        var tmax = parseNum(param(p, 'tmax', '0.5'), 0.5);
        var ic = param(p, 'ic', 'sin') || 'sin';
        var bc = param(p, 'bc', 'dirichlet') || 'dirichlet';
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

    function buildWaveCode(p) {
        var c = parseNum(param(p, 'c', '1'), 1);
        var L = parseNum(param(p, 'L', '1'), 1);
        var tmax = parseNum(param(p, 'tmax', '2'), 2);
        var ic = param(p, 'ic', 'sin') || 'sin';
        var bc = param(p, 'bc', 'dirichlet') || 'dirichlet';
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

    function buildLaplaceCode(p) {
        var nx = parseInt(param(p, 'nx', '20'), 10) || 20;
        var ny = parseInt(param(p, 'ny', '20'), 10) || 20;
        var bc = param(p, 'bc', 'dirichlet') || 'dirichlet';
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

    function buildPoissonCode(p) {
        var nx = parseInt(param(p, 'nx', '25'), 10) || 25;
        var ny = parseInt(param(p, 'ny', '25'), 10) || 25;
        var source = param(p, 'source', 'const') || 'const';
        var bc = param(p, 'bc', 'dirichlet') || 'dirichlet';
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

    function buildTransportCode(p) {
        var c = parseNum(param(p, 'c', '1'), 1);
        var L = parseNum(param(p, 'L', '2'), 2);
        var tmax = parseNum(param(p, 'tmax', '1.5'), 1.5);
        var ic = param(p, 'ic', 'gauss') || 'gauss';
        var scheme = param(p, 'scheme', 'upwind') || 'upwind';
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

    function buildSchrodingerCode(p) {
        var L = parseNum(param(p, 'L', '1'), 1);
        var potential = param(p, 'potential', 'infinite_well') || 'infinite_well';
        var nstates = parseInt(param(p, 'nstates', '5'), 10) || 5;
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

    function buildLinear1Code(p) {
        var a = parseNum(param(p, 'a', '1'), 1);
        var b = parseNum(param(p, 'b', '1'), 1);
        var c = parseNum(param(p, 'c', '1'), 1);
        var gExpr = String(param(p, 'g', '0')).trim();
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
            '    print("META_METHOD:Method of characteristics (symbolic)")',
            '    print("META_BC:analytical")',
            '    print("STEP1_TITLE:Given PDE")',
            '    print("STEP1_LATEX:" + str(a) + "u_x + " + str(b) + "u_y + " + str(c) + "u = " + latex(G))',
            '    print("STEP2_TITLE:Method")',
            '    print("STEP2_LATEX:\\\\text{Method of characteristics}")',
            '    print("STEP3_TITLE:General solution")',
            '    print("STEP3_LATEX:" + latex(sol.rhs))',
            '    print("STEP4_TITLE:Verification")',
            '    v_msg = "\\\\text{Verified } \\\\checkmark" if chk[0] else "\\\\text{Check: residual = }" + latex(chk[1])',
            '    print("STEP4_LATEX:" + v_msg)',
            'except Exception as e:',
            '    print("ERROR:" + str(e))'
        ].join('\n');
    }


    function buildCode(spec) {
        var mode = (spec && spec.mode) || 'heat';
        var p = (spec && spec.params) || {};
        switch (mode) {
            case 'heat': return buildHeatCode(p);
            case 'wave': return buildWaveCode(p);
            case 'laplace': return buildLaplaceCode(p);
            case 'poisson': return buildPoissonCode(p);
            case 'transport': return buildTransportCode(p);
            case 'schrodinger': return buildSchrodingerCode(p);
            case 'linear1': return buildLinear1Code(p);
            default: return buildHeatCode(p);
        }
    }

    function parseResult(mode, stdout) {
        stdout = String(stdout || '').trim();
        var errMatch = stdout.match(/ERROR:([^\n]*)/);
        if (errMatch) return { ok: false, error: errMatch[1].trim(), mode: mode };
        if (!stdout) return { ok: false, error: 'Computation failed.', mode: mode };

        var meta = parseMeta(stdout);
        var steps = parseSteps(stdout);
        var resultMatch = stdout.match(/RESULT:([^\n]*)/);
        var resultLatexMatch = stdout.match(/RESULT_LATEX:([^\n]*)/);
        var textMatch = stdout.match(/TEXT:([^\n]*)/);
        var verifiedMatch = stdout.match(/VERIFIED:([^\n]*)/);

        var resultText = resultMatch ? resultMatch[1].trim() : mode + ' equation solved';
        var resultLatex = resultLatexMatch ? resultLatexMatch[1].trim() : (textMatch ? textMatch[1].trim() : resultText);
        var methodLabel = meta.METHOD || (mode === 'linear1' ? 'Method of characteristics' : 'Finite Difference');

        return {
            ok: true,
            mode: mode,
            resultLatex: resultLatex,
            text: resultText,
            method: methodLabel,
            verified: verifiedMatch ? verifiedMatch[1].trim() === 'True' : null,
            meta: meta,
            steps: steps,
        };
    }

    function resolveCtx(opts) {
        if (opts && opts.ctx != null) return opts.ctx;
        if (typeof window !== 'undefined') {
            if (window.PDE_CALC_CTX != null) return window.PDE_CALC_CTX;
            var meta = document.querySelector && document.querySelector('meta[name="ctx"]');
            if (meta && meta.content != null) return meta.content;
        }
        return '';
    }

    function taskToSpec(task) {
        var mode = String(task && task.mode || 'heat').toLowerCase();
        var p = Object.assign({}, task && task.params);
        if (task) {
            ['k','L','tmax','ic','bc','c','nx','ny','source','scheme','potential','nstates','a','b','g'].forEach(function (k) {
                if (task[k] != null && p[k] == null) p[k] = task[k];
            });
        }
        return { mode: mode, params: p };
    }

    function solve(spec, opts) {
        opts = opts || {};
        if (typeof fetch === 'undefined') {
            return Promise.resolve({ ok: false, error: 'Network unavailable for the PDE engine.', mode: spec && spec.mode });
        }
        var code = buildCode(spec);
        var ctx = resolveCtx(opts);
        var controller = (typeof AbortController !== 'undefined') ? new AbortController() : null;
        var signal = opts.signal || (controller ? controller.signal : undefined);
        var timeoutMs = opts.timeoutMs != null ? opts.timeoutMs : 90000;
        var timeoutId = controller ? setTimeout(function () { controller.abort(); }, timeoutMs) : null;

        return fetch(ctx + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: signal,
        })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (timeoutId) clearTimeout(timeoutId);
                var stdout = (data.Stdout || data.stdout || '').trim();
                var stderr = (data.Stderr || data.stderr || '').trim();
                if (!stdout || (stderr && /error|exception|traceback/i.test(stderr) && !stdout)) {
                    return { ok: false, error: stderr || 'Computation failed.', mode: spec.mode };
                }
                return parseResult(spec.mode, stdout);
            })
            .catch(function (err) {
                if (timeoutId) clearTimeout(timeoutId);
                return { ok: false, error: err.name === 'AbortError' ? 'Request timed out (' + (timeoutMs / 1000) + 's)' : err.message, mode: spec.mode };
            });
    }

    function solveTask(task, opts) {
        return solve(taskToSpec(task), opts);
    }

    return {
        parseNum: parseNum,
        buildCode: buildCode,
        parseResult: parseResult,
        solve: solve,
        solveTask: solveTask,
        taskToSpec: taskToSpec,
    };
})();

if (typeof window !== 'undefined') window.PDECalculatorCore = PDECalculatorCore;
if (typeof module !== 'undefined' && module.exports) module.exports = PDECalculatorCore;
