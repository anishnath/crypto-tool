/**
 * lab.js — The Orchestrator
 *
 * Single entry point for creating a physics lab.
 * Wires: SimRunner + canvases + controls + tabs + presets + interaction.
 *
 * Usage in JSP:
 *   import { createLab } from './js/lab.js';
 *   import { PendulumSim } from './js/sims/pendulum.js';
 *   const lab = createLab(PendulumSim, { simCanvas, graphCanvas, ... });
 */

import { SimRunner } from './core/runner.js';
import { PeriodDetector } from './core/state.js';
import { SimCanvas, screenToWorld } from './canvas/sim-canvas.js';
import { GraphCanvas } from './canvas/graph-canvas.js';
import { TimeGraph } from './canvas/time-graph.js';
import { EnergyBar } from './canvas/energy-bar.js';
import { PotentialWell } from './canvas/potential-well.js';
import { bindInteraction } from './core/interact.js';
import { TabSwitcher } from './ui/tabs.js';
import { buildSimControls, extractDefaults } from './ui/controls.js';
import { buildEngineControls, encodeShareUrl, decodeShareUrl } from './ui/engine-controls.js';
import { buildTransport } from './ui/transport.js';
import { buildPresets, applyPreset } from './ui/presets.js';
import { buildVarPicker, resolveGraphDefaults } from './ui/var-picker.js';
import { buildDataTools } from './ui/data-tools.js';

/**
 * @param {object} sim — sim definition
 * @param {object} elements — DOM elements
 * @returns {{ runner: SimRunner, destroy: function }}
 */
export function createLab(sim, elements) {
  const {
    simCanvas, graphCanvas, timeCanvas, energyCanvas, peWellCanvas,
    controls, transport, presets, tabs, varPicker, dataTools,
    canvasArea,
  } = elements;

  // --- Runner ---
  const runner = new SimRunner(sim);

  // Apply shared params from URL (?key=val from ToolUtils, or #key=val fallback)
  if (typeof window !== 'undefined') {
    let sharedParams = {};
    // Prefer ?query params (ToolUtils.generateShareUrl format)
    if (window.location.search) {
      const urlParams = new URLSearchParams(window.location.search);
      urlParams.forEach((v, k) => {
        const num = parseFloat(v);
        sharedParams[k] = isNaN(num) ? v : num;
      });
    }
    // Fallback: #hash params
    if (Object.keys(sharedParams).length === 0 && window.location.hash) {
      sharedParams = decodeShareUrl(window.location.hash);
    }
    let applied = false;
    for (const [k, v] of Object.entries(sharedParams)) {
      if (runner.params[k] !== undefined) { runner.setParam(k, v); applied = true; }
    }
    if (applied) runner.reset();
  }

  // --- Simulation Canvas ---
  let simCvs = null;
  if (simCanvas) {
    simCvs = new SimCanvas(simCanvas, sim.worldRect || { xMin: -3, xMax: 3, yMin: -3, yMax: 3 });
  }

  // --- State for optional overlays ---
  let showEnergy = true;
  let showClock = true;
  let bgMode = 'dark';
  let energyMax = 1;
  const trailPoints = [];
  const maxTrail = 60;

  // --- Graph Canvas ---
  let graphCvs = null;
  if (graphCanvas && sim.views?.includes('phase')) {
    const gd = resolveGraphDefaults(sim.vars, sim.graphDefaults, 'phase');
    const xDef = sim.vars[gd.x];
    const yDef = sim.vars[gd.y];
    graphCvs = new GraphCanvas(graphCanvas, {
      xVar: xDef?.index ?? 0,
      yVar: yDef?.index ?? 1,
      xLabel: xDef?.symbol || gd.x,
      yLabel: yDef?.symbol || gd.y,
    });

    // Enable direction field on phase graph
    // Direction field only meaningful for low-DOF systems (<=5 state vars)
    if (typeof sim.evaluate === 'function' && sim.varCount <= 5) {
      const evalForField = (state, change, params) => sim.evaluate(state, change, params, false);
      graphCvs.setDirectionField(evalForField, runner.params, sim.varCount);
    }
  }

  // --- Time Graph ---
  let timeCvs = null;
  if (timeCanvas && sim.views?.includes('time')) {
    timeCvs = new TimeGraph(timeCanvas);
    const timeDefaults = sim.graphDefaults?.time;
    if (Array.isArray(timeDefaults)) {
      timeDefaults.forEach(varName => {
        const def = sim.vars[varName];
        if (def) timeCvs.addLine(def.index, def.symbol || def.label);
      });
    }
    // Energy has its own dedicated Energy tab (stacked area chart).
    // Time graph stays clean with just state variables.
  }

  // --- Energy Bar ---
  let energyCvs = null;
  if (energyCanvas && sim.views?.includes('energy') && typeof sim.energy === 'function') {
    energyCvs = new EnergyBar(energyCanvas);
  }

  // --- Potential Well ---
  let peWellCvs = null;
  if (peWellCanvas && typeof sim.potentialEnergy === 'function' && sim.peWellConfig) {
    peWellCvs = new PotentialWell(peWellCanvas, {
      posVar: sim.peWellConfig.posVar,
      posLabel: sim.peWellConfig.posLabel,
      posRange: sim.peWellConfig.range,
    });
  }

  // --- Period Detector ---
  let periodDetector = null;
  if (typeof sim.periodVar === 'number') {
    periodDetector = new PeriodDetector(sim.periodVar);
  }

  // --- Overlay state ---
  let showVectors = false;

  // --- Tabs ---
  let tabSwitcher = null;
  if (tabs && sim.views) {
    tabSwitcher = new TabSwitcher(tabs, sim.views, {
      canvasArea: canvasArea || null,
      graphCanvases: {
        phase: graphCanvas || null,
        time: timeCanvas || null,
        energy: energyCanvas || null,
        well: peWellCanvas || null,
      },
    });
    tabSwitcher.restoreFromSession();

    // Show var-picker only on graph tabs
    if (varPicker) {
      tabSwitcher.onSwitch(tab => {
        varPicker.style.display = tab === 'phase' ? '' : 'none';
      });
      varPicker.style.display = (tabSwitcher.active === 'phase' || tabSwitcher.active === 'time') ? '' : 'none';
    }
  }

  // --- Controls ---
  let controlsHandle = null;
  if (controls) {
    controlsHandle = buildSimControls(sim.params, controls, (name, value) => {
      runner.setParam(name, value);
      if (graphCvs) graphCvs.updateParams(runner.params);
      // Params flagged resetsState require full reset (e.g., numAtoms changes state size)
      const paramDef = sim.params[name];
      if (paramDef && paramDef.resetsState) {
        runner.reset();
        if (graphCvs) graphCvs.clear();
        if (timeCvs) timeCvs.clear();
        if (energyCvs) energyCvs.reset();
        energyMax = 1;
        if (periodDetector) periodDetector.reset();
        trailPoints.length = 0;
      } else if (!runner.playing) {
        runner._notifyRender();
      }
    });
  }

  // --- Transport ---
  let transportHandle = null;
  if (transport) {
    transportHandle = buildTransport(transport, runner);
  }

  // --- Presets ---
  let presetsHandle = null;
  if (presets && sim.presets) {
    const defaults = extractDefaults(sim.params);
    presetsHandle = buildPresets(sim.presets, presets, (preset) => {
      const newParams = applyPreset(defaults, preset);
      for (const [k, v] of Object.entries(newParams)) runner.setParam(k, v);
      runner.reset();
      if (graphCvs) graphCvs.clear();
      if (timeCvs) timeCvs.clear();
      if (energyCvs) energyCvs.reset();
      energyMax = 1;
      if (periodDetector) periodDetector.reset();
      trailPoints.length = 0;
      if (dataToolsHandle) dataToolsHandle.clearBuffer();
      if (controlsHandle) controlsHandle.updateSliders(runner.params);
    });
  }

  // --- Engine Controls ---
  if (controls) {
    buildEngineControls(controls, runner, {
      showEnergy,
      showClock,
      onToggleEnergy(v) { showEnergy = v; },
      onToggleClock(v) { showClock = v; },
      onToggleVectors: typeof sim.vectors === 'function' ? (v) => { showVectors = v; } : null,
      onBackground(mode) { bgMode = mode; },
      toolName: sim.name || 'Physics Lab',
    });
  }

  // --- Var Picker ---
  if (varPicker && sim.vars && sim.graphDefaults && sim.views?.includes('phase')) {
    const gd = resolveGraphDefaults(sim.vars, sim.graphDefaults, 'phase');
    buildVarPicker(sim.vars, varPicker, gd, (xIdx, yIdx, xLabel, yLabel) => {
      if (graphCvs) {
        graphCvs.setVars(xIdx, yIdx, xLabel, yLabel);
      }
    });
  }

  // --- Data Tools (Export CSV, Screenshot, Live Readout) ---
  let dataToolsHandle = null;
  if (dataTools) {
    dataToolsHandle = buildDataTools(dataTools, sim, runner, simCanvas, {
      allCanvases: [simCanvas, graphCanvas, timeCanvas, energyCanvas, peWellCanvas].filter(Boolean),
    });
  }

  // --- Interaction (drag) ---
  let interactHandle = null;
  if (simCvs && sim.hitTest) {
    interactHandle = bindInteraction(
      simCanvas, sim, runner,
      (px, py) => simCvs.toWorld(px, py)
    );
  }

  // --- Render callback ---
  runner.onRender((state, params) => {
    const activeTab = tabSwitcher?.active || 'sim';
    const isDark = bgMode !== 'white';

    // Sim canvas — always renders (visible in all tabs)
    if (simCvs) {
      const bg = bgMode === 'white' ? '#ffffff' : '#0E1420';
      simCvs.clear(bg);
      if (bgMode === 'grid') simCvs.grid(1, '#ffffff', 0.04);

      // Motion trail (behind the sim objects)
      if (trailPoints.length > 1) {
        simCvs.trail(trailPoints, '#8B5CF6', 120);
      }

      sim.render(simCvs, state, params);

      // Clock overlay
      if (showClock) {
        simCvs.clockOverlay(runner.getTime(), isDark);
      }

      // Energy bar overlay on sim canvas
      if (showEnergy && sim.energy) {
        const e = sim.energy(state, params);
        energyMax = Math.max(energyMax, e.total * 1.1, 0.01);
        simCvs.energyOverlay(e.kinetic, e.potential, e.total, energyMax, isDark);
      }

      // Velocity + acceleration vectors overlay
      if (showVectors && typeof sim.vectors === 'function') {
        simCvs.vectorsOverlay(sim.vectors(state, params), isDark);
      }

      // Period readout overlay
      if (periodDetector && periodDetector.period > 0) {
        const thP = typeof sim.theoreticalPeriod === 'function' ? sim.theoreticalPeriod(params) : 0;
        simCvs.periodOverlay(periodDetector.period, thP, isDark);
      }
    }

    // Graph canvases — render when their tab is active (shown side-by-side with sim)
    if (graphCvs && activeTab === 'phase') graphCvs.render();
    if (timeCvs && activeTab === 'time') timeCvs.render();
    if (energyCvs && activeTab === 'energy' && sim.energy) {
      const e = sim.energy(state, params);
      energyCvs.update(e.kinetic, e.potential, e.total);
      energyCvs.render();
    }

    // Potential energy well
    if (peWellCvs && activeTab === 'well' && sim.potentialEnergy) {
      const e = sim.energy ? sim.energy(state, params) : null;
      peWellCvs.render(sim.potentialEnergy, state, params, e);
    }

    // Live data readout
    if (dataToolsHandle) dataToolsHandle.updateReadout(state, params);
  });

  // --- Tick callback (data collection for graphs) ---
  runner.onTick((state, params) => {
    if (graphCvs) graphCvs.push(state);
    const t = runner.getTime();
    if (timeCvs) timeCvs.push(t, state);

    // Feed energy data to time graph + energy chart
    if (sim.energy) {
      const e = sim.energy(state, params);
      if (energyCvs) energyCvs.pushTime(t, e.kinetic, e.potential, e.total);
    }

    // Period detection
    if (periodDetector) periodDetector.push(state, t);

    // Collect trail point
    if (typeof sim.trailPoint === 'function') {
      trailPoints.push(sim.trailPoint(state, params));
      if (trailPoints.length > 120) trailPoints.shift(); // keep last 120 frames (~2s at 60fps)
    }
  });

  // --- Auto-play ---
  runner.play();

  // --- Destroy ---
  function destroy() {
    runner.destroy();
    if (interactHandle) interactHandle.destroy();
    if (transportHandle) transportHandle.destroy();
    if (simCvs) simCvs.destroy();
  }

  return { runner, destroy };
}
