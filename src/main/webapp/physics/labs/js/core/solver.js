/**
 * ODE Solvers — Runge-Kutta 4 and Euler
 *
 * Both take: state array, evaluate function, timestep, params
 * Both mutate state in-place for zero GC pressure.
 * evaluate(vars, change, params) must fill change[] with d(vars[i])/dt.
 */

/**
 * 4th-order Runge-Kutta — the gold standard for accuracy.
 * 4 evaluations per step. O(dt^4) error.
 */
export function rk4(vars, evaluate, dt, params) {
  const n = vars.length;
  const k1 = new Float64Array(n);
  const k2 = new Float64Array(n);
  const k3 = new Float64Array(n);
  const k4 = new Float64Array(n);
  const tmp = new Float64Array(n);

  // k1 = f(t, y)
  evaluate(vars, k1, params);

  // k2 = f(t + dt/2, y + dt/2 * k1)
  for (let i = 0; i < n; i++) tmp[i] = vars[i] + 0.5 * dt * k1[i];
  evaluate(tmp, k2, params);

  // k3 = f(t + dt/2, y + dt/2 * k2)
  for (let i = 0; i < n; i++) tmp[i] = vars[i] + 0.5 * dt * k2[i];
  evaluate(tmp, k3, params);

  // k4 = f(t + dt, y + dt * k3)
  for (let i = 0; i < n; i++) tmp[i] = vars[i] + dt * k3[i];
  evaluate(tmp, k4, params);

  // y_new = y + (dt/6)(k1 + 2*k2 + 2*k3 + k4)
  for (let i = 0; i < n; i++) {
    vars[i] += (dt / 6) * (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]);
  }
}

/**
 * Euler's method — 1st order, fast, less accurate.
 * 1 evaluation per step. O(dt) error.
 */
export function euler(vars, evaluate, dt, params) {
  const n = vars.length;
  const change = new Float64Array(n);
  evaluate(vars, change, params);
  for (let i = 0; i < n; i++) {
    vars[i] += dt * change[i];
  }
}

/**
 * Midpoint method — 2nd order, good balance.
 * 2 evaluations per step. O(dt^2) error.
 */
export function midpoint(vars, evaluate, dt, params) {
  const n = vars.length;
  const k1 = new Float64Array(n);
  const tmp = new Float64Array(n);
  const k2 = new Float64Array(n);

  evaluate(vars, k1, params);
  for (let i = 0; i < n; i++) tmp[i] = vars[i] + 0.5 * dt * k1[i];
  evaluate(tmp, k2, params);
  for (let i = 0; i < n; i++) {
    vars[i] += dt * k2[i];
  }
}
