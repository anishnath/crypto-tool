/**
 * Resonance — Driven Damped Harmonic Oscillator (Three.js 3D)
 *
 * 1–3 spring-mass systems hang from a shared driver that oscillates at ω_d.
 * Each has independent mass, stiffness, damping → different ω₀.
 * When ω_d ≈ ω₀ for one of them, that one resonates!
 *
 * ODE per oscillator:  m_i·x_i'' + b_i·x_i' + k_i·x_i = F₀·cos(ω_d·t)
 *
 * State per oscillator: [x, v]
 */

import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { TabSwitcher } from '../ui/tabs.js';
import { TimeGraph } from '../canvas/time-graph.js';

/* ═══════════════════════ PHYSICS ═══════════════════════ */

function oscAccel(x, v, t, osc, driveFreq, driveAmp) {
  const omega0sq = osc.k / osc.m;
  const gamma = osc.b / (2 * osc.m);
  const drive = (driveAmp / osc.m) * Math.cos(driveFreq * t);
  return -omega0sq * x - 2 * gamma * v + drive;
}

function ssAmplitude(wd, osc, driveAmp) {
  const w0sq = osc.k / osc.m;
  const g2 = osc.b / osc.m;
  const denom = Math.sqrt((w0sq - wd * wd) ** 2 + (g2 * wd) ** 2);
  return denom > 1e-12 ? (driveAmp / osc.m) / denom : 999;
}

function ssPhase(wd, osc) {
  const w0sq = osc.k / osc.m;
  const g2 = osc.b / osc.m;
  return -Math.atan2(g2 * wd, w0sq - wd * wd);
}

/* RK4 step for one oscillator */
function rk4Osc(x, v, t, dt, osc, wD, F0) {
  const k1a = oscAccel(x, v, t, osc, wD, F0);
  const k1v = v;
  const k2a = oscAccel(x+.5*dt*k1v, v+.5*dt*k1a, t+.5*dt, osc, wD, F0);
  const k2v = v+.5*dt*k1a;
  const k3a = oscAccel(x+.5*dt*k2v, v+.5*dt*k2a, t+.5*dt, osc, wD, F0);
  const k3v = v+.5*dt*k2a;
  const k4a = oscAccel(x+dt*k3v, v+dt*k3a, t+dt, osc, wD, F0);
  const k4v = v+dt*k3a;
  return {
    x: x + (dt/6)*(k1v + 2*k2v + 2*k3v + k4v),
    v: v + (dt/6)*(k1a + 2*k2a + 2*k3a + k4a),
  };
}

/* ═══════════════════ OSCILLATOR CONFIG ═══════════════════ */

const OSC_COLORS = [
  { body: 0x7C3AED, edge: 0x9B6DFF, spring: 0x7C3AED, label: '#6D28D9', name: 'A' },
  { body: 0x0891B2, edge: 0x22D3EE, spring: 0x0891B2, label: '#0E7490', name: 'B' },
  { body: 0xD97706, edge: 0xFBBF24, spring: 0xD97706, label: '#B45309', name: 'C' },
];

/* ═══════════════════ THREE.JS SCENE ═══════════════════ */

export function createResonanceSim(el) {
  const canvasWrap = el.simContainer;
  const sidebarEl  = el.sidebar;
  const readoutEl  = el.readout;
  const tabsEl     = el.tabs;

  /* ─── Parameters ─── */
  const P = {
    numOsc: 1,            // 1, 2, or 3 oscillators
    driveAmp: 5,
    driveFreq: 3.16,
    showForces: true, showPhaseArc: true,
  };
  // Per-oscillator params
  const oscs = [
    { m: 1.0, k: 10, b: 0.5 },   // ω₀ ≈ 3.16
    { m: 2.5, k: 10, b: 0.5 },   // ω₀ = 2.0
    { m: 0.4, k: 10, b: 0.5 },   // ω₀ ≈ 5.0
  ];
  // Per-oscillator state
  const state = [
    { x: 0, v: 0 },
    { x: 0, v: 0 },
    { x: 0, v: 0 },
  ];
  let t = 0, running = true, lastTime = null;
  let energyDissipated = [0, 0, 0];
  let sweepActive = false, sweepT = 0;

  const omega0 = (i) => Math.sqrt(oscs[i].k / oscs[i].m);
  const Qfactor = (i) => Math.sqrt(oscs[i].k * oscs[i].m) / Math.max(oscs[i].b, 1e-6);

  /* ─── Scene ─── */
  const scene = new THREE.Scene();
  scene.background = new THREE.Color(0xB8D0E8);   // light blue-gray sky
  scene.fog = new THREE.Fog(0xB8D0E8, 35, 70);    // gentle far fog

  const W = canvasWrap.clientWidth || 700;
  const H = Math.max(canvasWrap.clientHeight || 0, 450);
  const isMobile = W < 600;
  const camera = new THREE.PerspectiveCamera(isMobile ? 55 : 45, W / H, 0.1, 100);
  camera.position.set(isMobile ? 2 : 4, 0.5, isMobile ? 8 : 10);  // closer

  const renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(W, H);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;
  canvasWrap.appendChild(renderer.domElement);

  const orbit = new OrbitControls(camera, renderer.domElement);
  orbit.target.set(0, -0.5, 0);
  orbit.enableDamping = true;
  orbit.dampingFactor = 0.08;
  orbit.update();

  /* ─── Lighting (bright, well-lit lab) ─── */
  scene.add(new THREE.AmbientLight(0xFFFFFF, 0.65));
  scene.add(new THREE.HemisphereLight(0xCCDDFF, 0x886644, 0.4));
  const sun = new THREE.DirectionalLight(0xFFF5DD, 1.0);
  sun.position.set(6, 10, 8); sun.castShadow = true;
  sun.shadow.mapSize.set(1024, 1024);
  scene.add(sun);

  /* ─── Sprite helpers (with outline for readability on any bg) ─── */
  function drawOutlinedText(cx, text, x, y, color, fontSize) {
    cx.font = `bold ${fontSize}px 'DM Sans', Arial, sans-serif`;
    cx.textBaseline = 'top';
    // White outline for readability on both light and dark backgrounds
    cx.strokeStyle = 'rgba(255,255,255,0.85)';
    cx.lineWidth = 4;
    cx.lineJoin = 'round';
    cx.strokeText(text, x, y);
    cx.fillStyle = color || '#333';
    cx.fillText(text, x, y);
  }

  function makeSprite(text, color, fontSize) {
    const fs = fontSize || 32;
    const c = document.createElement('canvas');
    c.width = 512; c.height = 128;
    drawOutlinedText(c.getContext('2d'), text, 6, 10, color, fs);
    const tex = new THREE.CanvasTexture(c);
    tex.minFilter = THREE.LinearFilter;
    const mat = new THREE.SpriteMaterial({ map: tex, transparent: true, depthTest: false });
    const spr = new THREE.Sprite(mat);
    spr.scale.set(2.5, 0.6, 1);
    return spr;
  }
  function updateSpriteText(sprite, text, color) {
    const tex = sprite.material.map;
    const c = tex.image;
    const cx = c.getContext('2d');
    cx.clearRect(0, 0, c.width, c.height);
    drawOutlinedText(cx, text, 6, 10, color, 26);
    tex.needsUpdate = true;
  }

  /* ─── Ground ─── */
  const ground = new THREE.Mesh(
    new THREE.PlaneGeometry(14, 8),
    new THREE.MeshLambertMaterial({ color: 0x88AA77 }));   // warm gray-green floor
  ground.rotation.x = -Math.PI / 2;
  ground.position.y = -4.5;
  ground.receiveShadow = true;
  scene.add(ground);

  /* ─── Shared support frame + driver ─── */
  const frameMat = new THREE.MeshLambertMaterial({ color: 0x778899 });  // visible steel gray
  let frameGroup = new THREE.Group();
  scene.add(frameGroup);
  const driverMat = new THREE.MeshLambertMaterial({ color: 0xF97316 });
  let driverMesh = null;
  const driverLabel = makeSprite('Driver ω_d', '#CC5500', 26);
  driverLabel.scale.set(3.0, 0.7, 1);
  scene.add(driverLabel);

  function buildFrame() {
    while (frameGroup.children.length) {
      const c = frameGroup.children[0]; frameGroup.remove(c);
      if (c.geometry) c.geometry.dispose();
    }
    if (driverMesh) { scene.remove(driverMesh); }
    const n = P.numOsc;
    const totalW = (n - 1) * 2.5 + 1.2;  // spacing between oscillators

    // Horizontal beam
    const beam = new THREE.Mesh(
      new THREE.BoxGeometry(totalW + 1.5, 0.15, 0.2), frameMat);
    beam.position.set(0, 3, 0);
    frameGroup.add(beam);
    // Vertical posts at ends
    [-totalW / 2 - 0.5, totalW / 2 + 0.5].forEach(px => {
      const post = new THREE.Mesh(
        new THREE.BoxGeometry(0.15, 7, 0.15), frameMat);
      post.position.set(px, -0.5, 0);
      post.castShadow = true;
      frameGroup.add(post);
    });

    // Driver platform
    driverMesh = new THREE.Mesh(
      new THREE.BoxGeometry(totalW + 0.8, 0.18, 1.0), driverMat);
    driverMesh.position.set(0, 3, 0);
    driverMesh.castShadow = true;
    scene.add(driverMesh);
  }

  /* ─── Per-oscillator scene objects ─── */
  const oscScene = [];  // { massMesh, massEdges, springLine, xLabel, massSize, zPos }

  function xPosForOsc(i) {
    // Center the N oscillators horizontally
    const n = P.numOsc;
    if (n === 1) return 0;
    const spacing = 2.5;
    return (i - (n - 1) / 2) * spacing;
  }

  const COILS = 12;
  const SPRING_R = 0.2;

  function buildOscScene() {
    // Remove old
    oscScene.forEach(o => {
      if (o.massMesh) scene.remove(o.massMesh);
      if (o.massEdges) scene.remove(o.massEdges);
      if (o.springLine) { scene.remove(o.springLine); o.springLine.geometry.dispose(); }
      if (o.xLabel) scene.remove(o.xLabel);
      if (o.nameLabel) scene.remove(o.nameLabel);
    });
    oscScene.length = 0;

    for (let i = 0; i < P.numOsc; i++) {
      const col = OSC_COLORS[i];
      const osc = oscs[i];
      const xp = xPosForOsc(i);
      const mSize = 0.3 + 0.08 * Math.sqrt(osc.m);

      // Mass block
      const geo = new THREE.BoxGeometry(mSize, mSize, mSize * 0.9);
      const massMesh = new THREE.Mesh(geo, new THREE.MeshLambertMaterial({ color: col.body }));
      massMesh.castShadow = true;
      scene.add(massMesh);
      const massEdges = new THREE.LineSegments(
        new THREE.EdgesGeometry(geo),
        new THREE.LineBasicMaterial({ color: col.edge }));
      scene.add(massEdges);

      // Displacement label
      const xLabel = makeSprite('x=0.00', col.label, 22);
      xLabel.scale.set(2.2, 0.5, 1);
      scene.add(xLabel);

      // Name label (A, B, C) + ω₀ value
      const w0 = Math.sqrt(osc.k / osc.m);
      const nameLabel = makeSprite(col.name + ': ω₀=' + w0.toFixed(2), col.label, 22);
      nameLabel.scale.set(3.0, 0.6, 1);
      scene.add(nameLabel);

      oscScene.push({ massMesh, massEdges, springLine: null, xLabel, nameLabel, massSize: mSize, xPos: xp });
    }
  }

  function syncOscScene() {
    const driverVisAmp = P.driveAmp / (oscs[0].k || 10);
    const driverY = 3 + driverVisAmp * Math.cos(P.driveFreq * t);
    if (driverMesh) driverMesh.position.y = driverY;
    driverLabel.position.set(0, driverY + 0.6, 0.8);

    for (let i = 0; i < P.numOsc; i++) {
      const o = oscScene[i];
      if (!o) continue;
      const s = state[i];
      const osc = oscs[i];
      const xp = xPosForOsc(i);
      const massY = -s.x;  // x positive=down, y positive=up

      o.massMesh.position.set(xp, massY, 0);
      o.massEdges.position.copy(o.massMesh.position);

      // Spring (helical coil)
      if (o.springLine) { scene.remove(o.springLine); o.springLine.geometry.dispose(); }
      const topY = driverY - 0.1;
      const botY = massY + o.massSize / 2;
      const pts = [];
      const len = topY - botY;
      for (let j = 0; j <= COILS * 10; j++) {
        const frac = j / (COILS * 10);
        const angle = frac * COILS * Math.PI * 2;
        pts.push(new THREE.Vector3(
          xp + Math.cos(angle) * SPRING_R,
          topY - frac * len,
          Math.sin(angle) * SPRING_R));
      }
      const geo = new THREE.BufferGeometry().setFromPoints(pts);
      const stretch = len / 2.5;
      const hue = stretch > 1.2 ? 0 : stretch < 0.5 ? 0.6 : 0.15;
      o.springLine = new THREE.Line(geo,
        new THREE.LineBasicMaterial({ color: new THREE.Color().setHSL(hue, 0.7, 0.5) }));
      scene.add(o.springLine);

      // Labels
      o.xLabel.position.set(xp - 0.8, massY - o.massSize / 2 - 0.3, 0.5);
      updateSpriteText(o.xLabel, 'x=' + s.x.toFixed(2), OSC_COLORS[i].label);

      const w0 = Math.sqrt(osc.k / osc.m);
      o.nameLabel.position.set(xp, -3.8, 0.5);
      updateSpriteText(o.nameLabel,
        OSC_COLORS[i].name + ': m=' + osc.m.toFixed(1) + ' k=' + osc.k.toFixed(0) + ' ω₀=' + w0.toFixed(2),
        OSC_COLORS[i].label);
    }
  }

  /* ─── Equilibrium line ─── */
  const eqLine = new THREE.Line(
    new THREE.BufferGeometry().setFromPoints([
      new THREE.Vector3(-5, 0, 0), new THREE.Vector3(5, 0, 0)]),
    new THREE.LineDashedMaterial({ color: 0x555577, dashSize: 0.15, gapSize: 0.1 }));
  eqLine.computeLineDistances();
  scene.add(eqLine);

  /* ─── Drag interaction: pull a mass and release ─── */
  const raycaster = new THREE.Raycaster();
  const pointer = new THREE.Vector2();
  let dragIdx = -1;           // which oscillator is being dragged (-1 = none)
  let dragStartY = 0;
  let dragStartX = 0;         // screen position at start

  function ptrNDC(e) {
    const r = renderer.domElement.getBoundingClientRect();
    pointer.x = ((e.clientX - r.left) / r.width) * 2 - 1;
    pointer.y = -((e.clientY - r.top) / r.height) * 2 + 1;
  }

  function hitTestMass(e) {
    ptrNDC(e);
    raycaster.setFromCamera(pointer, camera);
    for (let i = 0; i < P.numOsc; i++) {
      const o = oscScene[i];
      if (o && o.massMesh && raycaster.intersectObject(o.massMesh, false).length > 0) return i;
    }
    return -1;
  }

  renderer.domElement.addEventListener('pointerdown', e => {
    const hit = hitTestMass(e);
    if (hit < 0) return;
    dragIdx = hit;
    dragStartY = e.clientY;
    dragStartX = state[hit].x;
    orbit.enabled = false;
    renderer.domElement.style.cursor = 'grabbing';
    renderer.domElement.setPointerCapture(e.pointerId);
  });

  renderer.domElement.addEventListener('pointermove', e => {
    if (dragIdx >= 0) {
      // Drag down = increase x (displacement), up = decrease
      const dy = e.clientY - dragStartY;
      const scale = 0.02;  // pixels to meters
      state[dragIdx].x = dragStartX + dy * scale;
      state[dragIdx].v = 0;  // zero velocity while dragging
      return;
    }
    // Hover feedback
    const hit = hitTestMass(e);
    renderer.domElement.style.cursor = hit >= 0 ? 'grab' : '';
    for (let i = 0; i < P.numOsc; i++) {
      const o = oscScene[i];
      if (o && o.massMesh) {
        o.massMesh.material.emissive.setHex(i === hit ? 0x221133 : 0x000000);
      }
    }
  });

  renderer.domElement.addEventListener('pointerup', e => {
    if (dragIdx < 0) return;
    // Release — velocity stays 0, physics takes over from displaced position
    // This creates a visible transient as the system adjusts
    dragIdx = -1;
    orbit.enabled = true;
    renderer.domElement.style.cursor = '';
    renderer.domElement.releasePointerCapture(e.pointerId);
  });

  /* ─── Physics ─── */
  const DT = 1 / 240;

  function step(dt) {
    for (let i = 0; i < P.numOsc; i++) {
      if (i === dragIdx) continue;  // skip dragged oscillator — user controls it
      const s = state[i];
      const nxt = rk4Osc(s.x, s.v, t, dt, oscs[i], P.driveFreq, P.driveAmp);
      energyDissipated[i] += oscs[i].b * s.v * s.v * dt;
      s.x = nxt.x;
      s.v = nxt.v;
    }
    t += dt;

    if (sweepActive) {
      sweepT += dt;
      const wMax = Math.max(...Array.from({length: P.numOsc}, (_, i) => omega0(i))) * 2;
      P.driveFreq = 0.2 + (wMax - 0.2) * Math.min(sweepT / 25, 1);
      syncAll();
      if (sweepT >= 25) sweepActive = false;
    }
  }

  /* ─── Tabs + Graphs ─── */
  let tabs = null, timeGraph = null, energyGraph = null;

  /** Recreate TimeGraph with exactly P.numOsc displacement lines */
  function rebuildTimeGraph() {
    if (!el.timeCanvas) return;
    timeGraph = new TimeGraph(el.timeCanvas, { window: 15, capacity: 4000 });
    for (let i = 0; i < P.numOsc; i++) {
      timeGraph.addLine(i, OSC_COLORS[i].name + ' x (m)', OSC_COLORS[i].label);
    }
  }

  /** Recreate energy graph with per-oscillator KE+PE lines
   *  1 osc: KE, PE, Total+Heat (classic stacked feel)
   *  2-3 osc: per-oscillator Energy lines + Dissipated total  */
  function rebuildEnergyGraph() {
    if (!el.energyCanvas) return;
    energyGraph = new TimeGraph(el.energyCanvas, { window: 15, capacity: 3000 });
    if (P.numOsc === 1) {
      // Classic view: KE and PE as separate lines + total
      energyGraph.addLine(0, 'KE', '#EF4444');
      energyGraph.addLine(1, 'PE', '#3B82F6');
      energyGraph.addLine(2, 'Total (KE+PE+Heat)', '#10B981');
    } else {
      // Per-oscillator total energy (KE+PE) as colored lines
      for (let i = 0; i < P.numOsc; i++) {
        energyGraph.addLine(i, OSC_COLORS[i].name + ' Energy (J)', OSC_COLORS[i].label);
      }
      // Sum + dissipated
      energyGraph.addLine(P.numOsc, 'Total + Heat', '#10B981');
    }
  }

  function setupTabs() {
    if (!tabsEl) return;
    const views = ['sim', 'time', 'energy'];
    if (el.freqCanvas) views.splice(2, 0, 'freq');

    const graphCanvases = { time: el.timeCanvas, energy: el.energyCanvas };
    if (el.freqCanvas) graphCanvases.freq = el.freqCanvas;

    tabs = new TabSwitcher(tabsEl, views, {
      canvasArea: el.canvasArea,
      graphCanvases,
    });

    if (el.timeCanvas) rebuildTimeGraph();
    if (el.energyCanvas) rebuildEnergyGraph();

    tabs.onSwitch(name => {
      requestAnimationFrame(() => {
        if (name === 'time' && timeGraph && timeGraph._resize) timeGraph._resize();
        if (name === 'energy' && energyGraph && energyGraph._resize) energyGraph._resize();
        if (name === 'freq') drawFreqResponse();
      });
    });
    tabs.restoreFromSession();
  }

  /* ─── Frequency Response Graph ─── */
  function drawFreqResponse() {
    if (!el.freqCanvas) return;
    const cv = el.freqCanvas;
    const ctx = cv.getContext('2d');
    const dpr = window.devicePixelRatio || 1;
    const w = cv.parentElement ? cv.parentElement.clientWidth : cv.clientWidth;
    const h = cv.parentElement ? cv.parentElement.clientHeight : cv.clientHeight || w * 0.6;
    cv.style.width = w + 'px'; cv.style.height = h + 'px';
    cv.width = Math.round(w * dpr); cv.height = Math.round(h * dpr);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

    const pad = 50, pw = w - pad * 2, ph = h - pad * 2;
    ctx.fillStyle = '#0E1420';
    ctx.fillRect(0, 0, w, h);

    // Determine frequency range from all oscillators
    let wMaxAll = 0;
    for (let i = 0; i < P.numOsc; i++) wMaxAll = Math.max(wMaxAll, omega0(i));
    const wMax = wMaxAll * 2.5;

    // Find max amplitude for scaling
    let aMax = 0;
    for (let i = 0; i < P.numOsc; i++) {
      for (let wd = 0.1; wd <= wMax; wd += 0.05)
        aMax = Math.max(aMax, ssAmplitude(wd, oscs[i], P.driveAmp));
    }
    aMax = Math.min(aMax * 1.15, 50);

    const toX = wd => pad + (wd / wMax) * pw;
    const toY = a => pad + (1 - Math.min(a, aMax) / aMax) * ph;

    // Grid
    ctx.strokeStyle = 'rgba(255,255,255,0.05)';
    ctx.lineWidth = 0.5;
    for (let wd = 0; wd <= wMax; wd += 1) {
      const sx = toX(wd);
      ctx.beginPath(); ctx.moveTo(sx, pad); ctx.lineTo(sx, pad + ph); ctx.stroke();
    }

    // Draw curve for each oscillator
    for (let i = 0; i < P.numOsc; i++) {
      const col = OSC_COLORS[i];
      const osc = oscs[i];
      const w0 = Math.sqrt(osc.k / osc.m);

      // ω₀ dashed line
      ctx.setLineDash([4, 3]);
      ctx.strokeStyle = col.label;
      ctx.lineWidth = 1;
      const x0 = toX(w0);
      ctx.beginPath(); ctx.moveTo(x0, pad); ctx.lineTo(x0, pad + ph); ctx.stroke();
      ctx.setLineDash([]);

      // ω₀ label
      ctx.font = "bold 11px 'Fira Code', monospace";
      ctx.fillStyle = col.label;
      ctx.textAlign = 'center';
      ctx.fillText(col.name + ' ω₀=' + w0.toFixed(1), x0, pad - 6);

      // Amplitude curve
      ctx.strokeStyle = col.label;
      ctx.lineWidth = 2;
      ctx.beginPath();
      for (let wd = 0.05; wd <= wMax; wd += 0.03) {
        const a = Math.min(ssAmplitude(wd, osc, P.driveAmp), aMax);
        const sx = toX(wd), sy = toY(a);
        wd < 0.1 ? ctx.moveTo(sx, sy) : ctx.lineTo(sx, sy);
      }
      ctx.stroke();
    }

    // Current driving frequency line
    ctx.setLineDash([6, 4]);
    ctx.strokeStyle = '#F97316';
    ctx.lineWidth = 2;
    const dX = toX(P.driveFreq);
    ctx.beginPath(); ctx.moveTo(dX, pad); ctx.lineTo(dX, pad + ph); ctx.stroke();
    ctx.setLineDash([]);

    // Operating point dots for each oscillator
    for (let i = 0; i < P.numOsc; i++) {
      const curA = Math.min(ssAmplitude(P.driveFreq, oscs[i], P.driveAmp), aMax);
      const cx2 = toX(P.driveFreq), cy2 = toY(curA);
      ctx.beginPath(); ctx.arc(cx2, cy2, 6, 0, Math.PI * 2);
      ctx.fillStyle = OSC_COLORS[i].label; ctx.fill();
      ctx.strokeStyle = '#fff'; ctx.lineWidth = 1.5; ctx.stroke();
    }

    // ω_d label
    ctx.font = "bold 12px 'Fira Code', monospace";
    ctx.fillStyle = '#F97316';
    ctx.textAlign = 'center';
    ctx.fillText('ω_d=' + P.driveFreq.toFixed(2), dX, pad + ph + 18);

    // Axes labels
    ctx.font = "12px 'Fira Code', monospace";
    ctx.fillStyle = '#94A3B8';
    ctx.textAlign = 'center';
    ctx.fillText('Driving frequency ω_d (rad/s)', pad + pw / 2, h - 6);
    ctx.save();
    ctx.translate(12, pad + ph / 2);
    ctx.rotate(-Math.PI / 2);
    ctx.fillText('Amplitude A (m)', 0, 0);
    ctx.restore();

    // Legend
    ctx.font = "11px 'Fira Code', monospace";
    ctx.textAlign = 'left';
    for (let i = 0; i < P.numOsc; i++) {
      const ly = pad + 8 + i * 16;
      ctx.fillStyle = OSC_COLORS[i].label;
      ctx.fillRect(pad + 5, ly, 10, 10);
      ctx.fillStyle = '#94A3B8';
      const osc = oscs[i];
      ctx.fillText(OSC_COLORS[i].name + ': m=' + osc.m.toFixed(1) + ' k=' + osc.k.toFixed(0) +
        ' b=' + osc.b.toFixed(2) + ' ω₀=' + omega0(i).toFixed(2), pad + 20, ly + 9);
    }
  }

  /* ─── Readout ─── */
  function updateReadout() {
    if (!readoutEl) return;
    let html = `<span>ω_d=<b>${P.driveFreq.toFixed(2)}</b></span>`;
    for (let i = 0; i < P.numOsc; i++) {
      const col = OSC_COLORS[i];
      const w0 = omega0(i);
      const q = Qfactor(i);
      const A = ssAmplitude(P.driveFreq, oscs[i], P.driveAmp);
      const phi = ssPhase(P.driveFreq, oscs[i]) * 180 / Math.PI;
      const isRes = Math.abs(P.driveFreq - w0) < w0 * 0.1;
      html += `<span style="color:${col.label}">${col.name}: ω₀=<b>${w0.toFixed(2)}</b>` +
        ` Q=<b>${q.toFixed(1)}</b> A=<b>${Math.min(A, 99).toFixed(1)}</b>` +
        ` φ=<b>${phi.toFixed(0)}</b>°` +
        (isRes ? ' <b style="color:#EF4444">★ RESONANCE</b>' : '') + `</span>`;
    }
    if (sweepActive) html += `<span style="color:#F97316">● SWEEPING...</span>`;
    readoutEl.innerHTML = html;
  }

  /* ─── Controls ─── */
  let doReset;  // forward ref

  function buildControls() {
    if (!sidebarEl) return;
    sidebarEl.innerHTML = '';
    function fmt(val, stp) { return stp >= 1 ? Math.round(val) + '' : stp >= 0.1 ? val.toFixed(1) : val.toFixed(2); }

    function slider(label, getValue, setValue, min, max, stp, unit) {
      const id = 'res_' + label.replace(/[^a-zA-Z0-9]/g, '_');
      const row = document.createElement('div'); row.className = 'param-row';
      row.innerHTML = `<div class="param-header"><span class="param-label">${label}</span>
        <span class="param-value" id="${id}_v">${fmt(getValue(),stp)}${unit||''}</span></div>
        <input type="range" class="param-slider" id="${id}" aria-label="${label}"
               min="${min}" max="${max}" step="${stp}" value="${getValue()}">`;
      row.querySelector('input').addEventListener('input', e => {
        setValue(parseFloat(e.target.value));
        row.querySelector('.param-value').textContent = fmt(getValue(), stp) + (unit || '');
        drawFreqResponse();
      });
      return row;
    }

    /* Transport */
    const tr = document.createElement('div'); tr.className = 'lab-transport';
    tr.innerHTML = `<button class="transport-btn" id="res_play" title="Play/Pause">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path id="res_icon" d="M6 4h4v16H6zM14 4h4v16h-4z"/></svg>
    </button><button class="transport-btn" id="res_rst" title="Reset">↺</button>
    <button class="transport-btn" id="res_step" title="Step">▶|</button>
    <button class="transport-btn" id="res_sweep" title="Sweep" style="font-size:10px;width:auto;padding:0 8px;">Sweep</button>`;
    sidebarEl.appendChild(tr);

    function syncPlayIcon() {
      const icon = document.getElementById('res_icon');
      if (icon) icon.setAttribute('d',
        running ? 'M6 4h4v16H6zM14 4h4v16h-4z' : 'M8 5v14l11-7z');
    }
    function togglePlay() { running = !running; lastTime = null; syncPlayIcon(); }
    doReset = function() { reset(); running = true; lastTime = null; syncPlayIcon(); };

    document.getElementById('res_play').onclick = togglePlay;
    document.getElementById('res_rst').onclick = doReset;
    document.getElementById('res_step').onclick = () => {
      if (running) { running = false; syncPlayIcon(); }
      step(DT);
    };
    document.getElementById('res_sweep').onclick = () => {
      sweepActive = true; sweepT = 0;
      P.driveFreq = 0.2;
      if (!running) { running = true; syncPlayIcon(); }
      syncAll();
    };

    document.addEventListener('keydown', e => {
      if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT' || e.target.tagName === 'TEXTAREA') return;
      if (e.code === 'Space') { e.preventDefault(); togglePlay(); }
      else if (e.code === 'KeyR') doReset();
      else if (e.code === 'ArrowRight') { if (running) { running = false; syncPlayIcon(); } step(DT); }
    });

    /* Number of oscillators selector */
    const numSec = document.createElement('div'); numSec.className = 'lab-presets';
    numSec.innerHTML = '<span style="font-size:.78rem;color:var(--lab-text-muted);min-width:50px">Oscillators:</span>';
    [1, 2, 3].forEach(n => {
      const b = document.createElement('button');
      b.className = 'preset-btn' + (n === P.numOsc ? ' active' : '');
      b.textContent = n + (n === 1 ? ' spring' : ' springs');
      b.onclick = () => {
        P.numOsc = n;
        numSec.querySelectorAll('.preset-btn').forEach(x => x.classList.remove('active'));
        b.classList.add('active');
        rebuildAll();
        doReset();  // reset all state + energy when switching count
      };
      numSec.appendChild(b);
    });
    sidebarEl.appendChild(numSec);

    /* Shared drive controls */
    const driveSec = document.createElement('div'); driveSec.className = 'lab-params';
    driveSec.appendChild(slider('Drive Amp (F₀)', () => P.driveAmp, v => P.driveAmp = v, 0, 20, 0.5, ' N'));
    driveSec.appendChild(slider('Drive Freq (ω_d)', () => P.driveFreq, v => P.driveFreq = v, 0.1, 15, 0.01, ' rad/s'));
    sidebarEl.appendChild(driveSec);

    /* Per-oscillator controls */
    for (let i = 0; i < 3; i++) {
      const col = OSC_COLORS[i];
      const sec = document.createElement('div'); sec.className = 'lab-params';
      sec.id = 'res_osc_' + i;
      sec.style.borderLeft = '3px solid ' + col.label;
      if (i >= P.numOsc) sec.style.display = 'none';
      const title = document.createElement('div');
      title.className = 'param-header';
      title.innerHTML = `<span class="param-label" style="color:${col.label};font-weight:600">${col.name}: ω₀ = <span id="res_w0_${i}">${omega0(i).toFixed(2)}</span></span>`;
      sec.appendChild(title);
      sec.appendChild(slider(col.name + ' Mass', () => oscs[i].m, v => { oscs[i].m = v; updateOscDerived(i); }, 0.1, 10, 0.1, ' kg'));
      sec.appendChild(slider(col.name + ' Stiffness', () => oscs[i].k, v => { oscs[i].k = v; updateOscDerived(i); }, 0.5, 50, 0.5, ' N/m'));
      sec.appendChild(slider(col.name + ' Damping', () => oscs[i].b, v => { oscs[i].b = v; updateOscDerived(i); }, 0, 5, 0.01, ''));
      sidebarEl.appendChild(sec);
    }

    /* Checkboxes */
    const cs = document.createElement('div'); cs.className = 'lab-params';
    [['Show Phase Arc', 'showPhaseArc']].forEach(([l, k]) => {
      const r = document.createElement('div'); r.className = 'param-row';
      r.innerHTML = `<label class="param-check"><input type="checkbox" ${P[k] ? 'checked' : ''} id="res_${k}"> ${l}</label>`;
      r.querySelector('input').addEventListener('change', e => { P[k] = e.target.checked; });
      cs.appendChild(r);
    });
    sidebarEl.appendChild(cs);

    /* Presets */
    const presets = [
      { name: 'Single — At Resonance', p: { numOsc: 1, driveFreq: 3.16, driveAmp: 5 },
        o: [{ m: 1, k: 10, b: 0.5 }] },
      { name: 'Single — No Damping', p: { numOsc: 1, driveFreq: 3.16, driveAmp: 2 },
        o: [{ m: 1, k: 10, b: 0.01 }] },
      { name: 'Two — Same k, Different m', p: { numOsc: 2, driveFreq: 3.16, driveAmp: 5 },
        o: [{ m: 1, k: 10, b: 0.5 }, { m: 2.5, k: 10, b: 0.5 }] },
      { name: 'Two — Same m, Different k', p: { numOsc: 2, driveFreq: 3.16, driveAmp: 5 },
        o: [{ m: 1, k: 10, b: 0.5 }, { m: 1, k: 25, b: 0.5 }] },
      { name: 'Three — Radio Tuner', p: { numOsc: 3, driveFreq: 3.16, driveAmp: 5 },
        o: [{ m: 1, k: 10, b: 0.5 }, { m: 2.5, k: 10, b: 0.5 }, { m: 0.4, k: 10, b: 0.5 }] },
      { name: 'Three — Same ω₀, Different Q', p: { numOsc: 3, driveFreq: 3.16, driveAmp: 5 },
        o: [{ m: 1, k: 10, b: 0.1 }, { m: 1, k: 10, b: 0.5 }, { m: 1, k: 10, b: 2.0 }] },
      { name: 'Sweep Three', p: { numOsc: 3, driveFreq: 0.5, driveAmp: 5 },
        o: [{ m: 1, k: 4, b: 0.3 }, { m: 1, k: 10, b: 0.3 }, { m: 1, k: 25, b: 0.3 }] },
    ];
    const pre = document.createElement('div'); pre.className = 'lab-presets';
    presets.forEach(pr => {
      const b = document.createElement('button'); b.className = 'preset-btn'; b.textContent = pr.name;
      b.onclick = () => {
        Object.assign(P, pr.p);
        pr.o.forEach((o, i) => Object.assign(oscs[i], o));
        rebuildAll();
        doReset();
      };
      pre.appendChild(b);
    });
    sidebarEl.appendChild(pre);

    /* ── Settings (collapsible, like engine sims) ── */
    const settings = document.createElement('details');
    settings.className = 'lab-engine-settings';
    const sum = document.createElement('summary');
    sum.textContent = 'Settings';
    settings.appendChild(sum);
    const setBody = document.createElement('div');
    setBody.className = 'engine-body';

    // Sim Speed
    const speedRow = document.createElement('div');
    speedRow.className = 'engine-row';
    speedRow.innerHTML = `<span class="param-label">Speed</span>
      <select class="param-select" id="res_speed" aria-label="Simulation speed">
        <option value="0.25">0.25×</option><option value="0.5">0.5×</option>
        <option value="1" selected>1×</option><option value="2">2×</option><option value="4">4×</option>
      </select>`;
    setBody.appendChild(speedRow);
    document.getElementById('res_speed')?.addEventListener('change', e => {
      simSpeed = parseFloat(e.target.value);
    });

    // Background
    const bgRow = document.createElement('div');
    bgRow.className = 'engine-row';
    bgRow.innerHTML = `<span class="param-label">Background</span>
      <select class="param-select" id="res_bg" aria-label="Background style">
        <option value="light" selected>Light</option><option value="sky">Sky Blue</option>
        <option value="dark">Dark</option><option value="white">White</option>
      </select>`;
    setBody.appendChild(bgRow);
    document.getElementById('res_bg')?.addEventListener('change', e => {
      const bgMap = { light: 0xB8D0E8, sky: 0x87AACC, dark: 0x1A1A2E, white: 0xF0F0F0 };
      const col = bgMap[e.target.value] || 0x1A1A2E;
      scene.background.set(col);
      if (scene.fog) scene.fog.color.set(col);
    });

    // Share Link
    const shareBtn = document.createElement('button');
    shareBtn.className = 'lab-share-btn';
    shareBtn.textContent = 'Share Link';
    shareBtn.addEventListener('click', () => {
      const params = { ...P };
      for (let i = 0; i < P.numOsc; i++) {
        params['m' + i] = oscs[i].m;
        params['k' + i] = oscs[i].k;
        params['b' + i] = oscs[i].b;
      }
      const pairs = Object.entries(params).map(([k, v]) =>
        encodeURIComponent(k) + '=' + encodeURIComponent(v));
      const url = location.href.split('#')[0] + '#' + pairs.join('&');
      navigator.clipboard.writeText(url).then(() => {
        shareBtn.textContent = 'Copied!';
        setTimeout(() => { shareBtn.textContent = 'Share Link'; }, 2000);
      }).catch(() => {
        prompt('Copy this link:', url);
      });
    });
    setBody.appendChild(shareBtn);

    settings.appendChild(setBody);
    sidebarEl.appendChild(settings);
  }

  let simSpeed = 1;  // controlled by Settings speed dropdown

  function updateOscDerived(i) {
    const el2 = document.getElementById('res_w0_' + i);
    if (el2) el2.textContent = omega0(i).toFixed(2);
    buildOscScene(); // rebuild mass size
  }

  function syncAll() {
    // Sync drive sliders
    const driveSl = document.querySelector('[aria-label="Drive Freq (ω_d)"]');
    if (driveSl) {
      driveSl.value = P.driveFreq;
      const vEl = driveSl.parentElement.querySelector('.param-value');
      if (vEl) vEl.textContent = P.driveFreq.toFixed(2) + ' rad/s';
    }
    const ampSl = document.querySelector('[aria-label="Drive Amp (F₀)"]');
    if (ampSl) {
      ampSl.value = P.driveAmp;
      const vEl = ampSl.parentElement.querySelector('.param-value');
      if (vEl) vEl.textContent = P.driveAmp.toFixed(1) + ' N';
    }
    // Show/hide oscillator panels
    for (let i = 0; i < 3; i++) {
      const sec = document.getElementById('res_osc_' + i);
      if (sec) sec.style.display = i < P.numOsc ? '' : 'none';
    }
  }

  function rebuildAll() {
    buildFrame();
    buildOscScene();
    rebuildTimeGraph();
    rebuildEnergyGraph();
    syncAll();
    drawFreqResponse();
  }

  /* ─── Animation ─── */
  function animate(now) {
    requestAnimationFrame(animate);
    if (running && lastTime !== null) {
      let dt = Math.min((now - lastTime) / 1000, 0.05) * simSpeed;
      while (dt >= DT) {
        step(DT);
        // Feed time graph — only active oscillators (graph rebuilt with matching line count)
        if (timeGraph) {
          const arr = new Float64Array(P.numOsc);
          for (let i = 0; i < P.numOsc; i++) arr[i] = state[i].x;
          timeGraph.push(t, arr);
        }
        // Feed energy graph — per-oscillator for comparison
        if (energyGraph) {
          if (P.numOsc === 1) {
            // Classic: [KE, PE, Total+Heat]
            const KE = 0.5 * oscs[0].m * state[0].v * state[0].v;
            const PE = 0.5 * oscs[0].k * state[0].x * state[0].x;
            energyGraph.push(t, new Float64Array([KE, PE, KE + PE + energyDissipated[0]]));
          } else {
            // Per-oscillator: [A_energy, B_energy, (C_energy), Total+Heat]
            const arr = new Float64Array(P.numOsc + 1);
            let totalE = 0, totalDis = 0;
            for (let i = 0; i < P.numOsc; i++) {
              const e = 0.5 * oscs[i].m * state[i].v * state[i].v
                      + 0.5 * oscs[i].k * state[i].x * state[i].x;
              arr[i] = e;
              totalE += e;
              totalDis += energyDissipated[i];
            }
            arr[P.numOsc] = totalE + totalDis;  // green conservation line
            energyGraph.push(t, arr);
          }
        }
        dt -= DT;
      }
    }
    lastTime = running ? now : null;

    syncOscScene();
    updateReadout();

    if (timeGraph && el.timeCanvas && el.timeCanvas.style.display !== 'none') timeGraph.render();
    if (energyGraph && el.energyCanvas && el.energyCanvas.style.display !== 'none') energyGraph.render();
    if (el.freqCanvas && el.freqCanvas.style.display !== 'none') drawFreqResponse();

    orbit.update();
    renderer.render(scene, camera);
  }

  function reset() {
    for (let i = 0; i < 3; i++) { state[i].x = 0; state[i].v = 0; energyDissipated[i] = 0; }
    t = 0; lastTime = null;
    sweepActive = false; sweepT = 0;
    if (timeGraph) timeGraph.clear();
    if (energyGraph) energyGraph.clear();
  }

  /* ─── Resize ─── */
  const ro = new ResizeObserver(() => {
    const w = canvasWrap.clientWidth;
    if (w === 0) return;
    const h = canvasWrap.clientHeight || Math.round(w * 0.6);
    camera.aspect = w / h;
    camera.fov = w < 500 ? 62 : w < 800 ? 52 : 48;
    camera.updateProjectionMatrix();
    renderer.setSize(w, h);
  });
  ro.observe(canvasWrap);

  /* ─── Init ─── */
  buildControls();
  rebuildAll();
  setupTabs();
  requestAnimationFrame(animate);

  return { reset, destroy() { ro.disconnect(); renderer.dispose(); orbit.dispose(); } };
}
