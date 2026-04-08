/**
 * AC/DC Generator & Motor — 3D Interactive (Three.js)
 *
 * Standalone Three.js scene showing a rotating coil in a magnetic field.
 * Same physics as generator.js but with full 3D visualization:
 *   - Rotating rectangular coil (wireframe + filled sides)
 *   - N/S pole magnets with field lines
 *   - Current flow particles on coil wires
 *   - Slip rings / commutator
 *   - Real-time oscilloscope waveform (HUD overlay)
 *   - 3-phase coils at 120° offsets
 *   - Motor mode with spin-up dynamics
 *   - OrbitControls for camera
 */

import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { EffectComposer } from 'three/addons/postprocessing/EffectComposer.js';
import { RenderPass } from 'three/addons/postprocessing/RenderPass.js';
import { UnrealBloomPass } from 'three/addons/postprocessing/UnrealBloomPass.js';

/* ═══════════════════ PHYSICS ═══════════════════ */

function rk4Gen(state, dt, params) {
  // state = [theta, omega, I]
  const f = (s) => genDerivs(s, params);
  const k1 = f(state);
  const s2 = state.map((v, i) => v + 0.5 * dt * k1[i]);
  const k2 = f(s2);
  const s3 = state.map((v, i) => v + 0.5 * dt * k2[i]);
  const k3 = f(s3);
  const s4 = state.map((v, i) => v + dt * k3[i]);
  const k4 = f(s4);
  return state.map((v, i) => v + (dt / 6) * (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]));
}

function genDerivs(state, P) {
  const [theta, omega, I] = state;
  const NBA = P.N * P.B * P.A;
  const sinT = Math.sin(theta);
  const R = P.R, L = P.L;

  let dTheta = omega;
  let dOmega = 0;
  let dI = 0;

  if (P.mode === 0) {
    // Generator: constant omega
    dOmega = 0;
    const emf = NBA * omega * sinT;
    const e = P.commutator ? Math.abs(emf) : emf;
    if (L < 0.0001) dI = 0; // algebraic in postStep
    else dI = (e - R * I) / L;
  } else {
    // Motor: DC voltage drives current, torque spins
    const backEMF = NBA * omega * Math.abs(sinT);
    if (L < 0.0001) dI = 0;
    else dI = (P.motorV - backEMF - R * I) / L;
    const Ieff = L < 0.0001 ? Math.max(0, (P.motorV - backEMF) / R) : I;
    const tau = NBA * Ieff * Math.abs(sinT);
    dOmega = (tau - P.friction * omega) / P.J;
  }
  return [dTheta, dOmega, dI];
}

function postStepGen(state, P) {
  const [theta, omega, I] = state;
  const NBA = P.N * P.B * P.A;
  const sinT = Math.sin(theta);
  if (P.L < 0.0001) {
    if (P.mode === 0) {
      const emf = NBA * omega * sinT;
      state[2] = (P.commutator ? Math.abs(emf) : emf) / P.R;
    } else {
      const backEMF = NBA * omega * Math.abs(sinT);
      state[2] = Math.max(0, (P.motorV - backEMF) / P.R);
    }
  }
}

/* ═══════════════════ MAIN EXPORT ═══════════════════ */

export function createGenerator3D(el) {
  const container = el.simContainer;
  const sidebarEl = el.sidebar;
  const readoutEl = el.readout;

  /* ─── Parameters ─── */
  const P = {
    N: 100, B: 0.5, A: 0.01, R: 10, L: 0, rpm: 60,
    commutator: false, mode: 0, phases: 1,
    motorV: 5, J: 0.01, friction: 0.005,
  };

  let state = [0, P.rpm * 2 * Math.PI / 60, 0];
  let simTime = 0;
  P._playing = true;

  /* ─── Three.js Setup ─── */
  const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: false });
  renderer.setPixelRatio(window.devicePixelRatio);
  renderer.setClearColor(0x0E1420);
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;
  renderer.toneMapping = THREE.ACESFilmicToneMapping;
  renderer.toneMappingExposure = 1.1;
  container.appendChild(renderer.domElement);

  const scene = new THREE.Scene();
  scene.fog = new THREE.FogExp2(0x0E1420, 0.04);

  const camera = new THREE.PerspectiveCamera(50, 2, 0.1, 100);
  camera.position.set(4, 3, 5);
  camera.lookAt(0, 0, 0);

  const controls = new OrbitControls(camera, renderer.domElement);
  controls.enableDamping = true;
  controls.dampingFactor = 0.08;
  controls.target.set(0, 0, 0);

  // ── Bloom post-processing ──
  const composer = new EffectComposer(renderer);
  composer.addPass(new RenderPass(scene, camera));
  const bloomPass = new UnrealBloomPass(new THREE.Vector2(512, 512), 0.4, 0.3, 0.85);
  composer.addPass(bloomPass);

  // Lighting — realistic with shadows
  scene.add(new THREE.AmbientLight(0x334466, 0.8));
  const dirLight = new THREE.DirectionalLight(0xFFEEDD, 2.0);
  dirLight.position.set(5, 8, 5);
  dirLight.castShadow = true;
  dirLight.shadow.mapSize.set(1024, 1024);
  dirLight.shadow.camera.near = 0.5;
  dirLight.shadow.camera.far = 25;
  dirLight.shadow.camera.left = -5;
  dirLight.shadow.camera.right = 5;
  dirLight.shadow.camera.top = 5;
  dirLight.shadow.camera.bottom = -5;
  scene.add(dirLight);
  // Rim light for depth
  const rimLight = new THREE.DirectionalLight(0x6688CC, 0.6);
  rimLight.position.set(-3, 2, -4);
  scene.add(rimLight);

  /* ─── Scene Objects ─── */

  // ── Magnets (brushed metal look) ──
  const nPoleMat = new THREE.MeshStandardMaterial({ color: 0xCC2222, metalness: 0.7, roughness: 0.3 });
  const nPole = new THREE.Mesh(new THREE.BoxGeometry(0.5, 2, 1.6), nPoleMat);
  nPole.position.set(-2, 0, 0);
  nPole.castShadow = true; nPole.receiveShadow = true;
  scene.add(nPole);
  // Pole face plate (lighter, indicates the active face)
  const nFace = new THREE.Mesh(new THREE.BoxGeometry(0.02, 1.8, 1.4),
    new THREE.MeshStandardMaterial({ color: 0xFF5555, metalness: 0.5, roughness: 0.4 }));
  nFace.position.set(-1.74, 0, 0);
  scene.add(nFace);
  const nLabel = makeTextSprite('N', '#FFF', 64);
  nLabel.position.set(-2.4, 0.6, 0);
  nLabel.scale.set(0.6, 0.6, 1);
  scene.add(nLabel);

  const sPoleMat = new THREE.MeshStandardMaterial({ color: 0x1D4ED8, metalness: 0.7, roughness: 0.3 });
  const sPole = new THREE.Mesh(new THREE.BoxGeometry(0.5, 2, 1.6), sPoleMat);
  sPole.position.set(2, 0, 0);
  sPole.castShadow = true; sPole.receiveShadow = true;
  scene.add(sPole);
  const sFace = new THREE.Mesh(new THREE.BoxGeometry(0.02, 1.8, 1.4),
    new THREE.MeshStandardMaterial({ color: 0x5588FF, metalness: 0.5, roughness: 0.4 }));
  sFace.position.set(1.74, 0, 0);
  scene.add(sFace);
  const sLabel = makeTextSprite('S', '#FFF', 64);
  sLabel.position.set(2.4, 0.6, 0);
  sLabel.scale.set(0.6, 0.6, 1);
  scene.add(sLabel);

  // ── Iron yoke (U-frame connecting magnets) ──
  const yokeMat = new THREE.MeshStandardMaterial({ color: 0x555566, metalness: 0.75, roughness: 0.25 });
  // Top bar
  const yokeTop = new THREE.Mesh(new THREE.BoxGeometry(4.5, 0.25, 0.5), yokeMat);
  yokeTop.position.set(0, 1.15, 0);
  yokeTop.castShadow = true; yokeTop.receiveShadow = true;
  scene.add(yokeTop);
  // Bottom bar
  const yokeBot = new THREE.Mesh(new THREE.BoxGeometry(4.5, 0.25, 0.5), yokeMat);
  yokeBot.position.set(0, -1.15, 0);
  yokeBot.castShadow = true; yokeBot.receiveShadow = true;
  scene.add(yokeBot);
  // Left pillar (behind N pole)
  const yokeL = new THREE.Mesh(new THREE.BoxGeometry(0.25, 2.05, 0.5), yokeMat);
  yokeL.position.set(-2.12, 0, 0);
  yokeL.castShadow = true;
  scene.add(yokeL);
  // Right pillar (behind S pole)
  const yokeR = new THREE.Mesh(new THREE.BoxGeometry(0.25, 2.05, 0.5), yokeMat);
  yokeR.position.set(2.12, 0, 0);
  yokeR.castShadow = true;
  scene.add(yokeR);

  // ── Animated field particles (flowing from N to S) ──
  const fieldParticleCount = 120;
  const fieldPGeo = new THREE.BufferGeometry();
  const fieldPPos = new Float32Array(fieldParticleCount * 3);
  const fieldPPhase = new Float32Array(fieldParticleCount); // individual phase offsets
  for (let i = 0; i < fieldParticleCount; i++) {
    fieldPPhase[i] = Math.random();
    fieldPPos[i * 3 + 1] = (Math.random() - 0.5) * 1.4;
    fieldPPos[i * 3 + 2] = (Math.random() - 0.5) * 1.2;
  }
  fieldPGeo.setAttribute('position', new THREE.BufferAttribute(fieldPPos, 3));
  const fieldPMat = new THREE.PointsMaterial({
    color: 0xFF6644, size: 0.04, sizeAttenuation: true, transparent: true, opacity: 0.5,
  });
  const fieldParticles = new THREE.Points(fieldPGeo, fieldPMat);
  scene.add(fieldParticles);

  // ── Rotation shaft (steel cylinder) ──
  const shaftMat = new THREE.MeshStandardMaterial({ color: 0x8899AA, metalness: 0.8, roughness: 0.2 });
  const shaft = new THREE.Mesh(new THREE.CylinderGeometry(0.04, 0.04, 3.2, 16), shaftMat);
  shaft.castShadow = true;
  scene.add(shaft);
  // Shaft bearings (top and bottom)
  const bearingGeo = new THREE.TorusGeometry(0.08, 0.025, 8, 16);
  const bearingMat = new THREE.MeshStandardMaterial({ color: 0x666677, metalness: 0.9, roughness: 0.15 });
  const bearingTop = new THREE.Mesh(bearingGeo, bearingMat);
  bearingTop.position.y = 1.3; bearingTop.rotation.x = Math.PI / 2;
  scene.add(bearingTop);
  const bearingBot = new THREE.Mesh(bearingGeo, bearingMat);
  bearingBot.position.y = -1.3; bearingBot.rotation.x = Math.PI / 2;
  scene.add(bearingBot);

  // ── Coil group (rotates) ──
  const coilGroup = new THREE.Group();
  scene.add(coilGroup);

  const coilW = 1.2, coilH = 1.6;
  // Copper wire material
  const copperMat = new THREE.MeshStandardMaterial({ color: 0xD4760A, metalness: 0.85, roughness: 0.2 });
  const copperMatL = new THREE.MeshStandardMaterial({ color: 0xD4760A, metalness: 0.85, roughness: 0.2 });
  const copperMatR = new THREE.MeshStandardMaterial({ color: 0xD4760A, metalness: 0.85, roughness: 0.2 });

  const coilEdges = [];
  const edgeR = 0.025;
  const TURNS = 4; // visible wire turns
  const turnSpacing = 0.04;
  const turnOffset = (i) => (i - (TURNS - 1) / 2) * turnSpacing;

  for (let turn = 0; turn < TURNS; turn++) {
    const zo = turnOffset(turn);
    // Top edge
    const top = makeEdge(coilW, edgeR, copperMat);
    top.position.set(0, coilH / 2, zo);
    top.castShadow = true;
    coilGroup.add(top);
    // Bottom edge
    const bot = makeEdge(coilW, edgeR, copperMat);
    bot.position.set(0, -coilH / 2, zo);
    bot.castShadow = true;
    coilGroup.add(bot);
    // Left active edge (all turns share copperMatL for unified current color)
    const left = makeEdgeV(coilH, edgeR, copperMatL);
    left.position.set(-coilW / 2, 0, zo);
    left.castShadow = true;
    coilGroup.add(left);
    // Right active edge (all turns share copperMatR)
    const right = makeEdgeV(coilH, edgeR, copperMatR);
    right.position.set(coilW / 2, 0, zo);
    right.castShadow = true;
    coilGroup.add(right);
    // Track first turn's active edges for color changes
    if (turn === 0) {
      coilEdges.push(top, bot, left, right);
    }
  }

  // Coil face (flux indicator)
  const faceMat = new THREE.MeshStandardMaterial({
    color: 0x22C55E, transparent: true, opacity: 0.1,
    side: THREE.DoubleSide, depthWrite: false,
  });
  const face = new THREE.Mesh(new THREE.PlaneGeometry(coilW - 0.05, coilH - 0.05), faceMat);
  coilGroup.add(face);

  // Normal vector arrow
  const normalArrow = new THREE.ArrowHelper(
    new THREE.Vector3(0, 0, 1), new THREE.Vector3(0, 0, 0),
    0.8, 0x22C55E, 0.12, 0.06);
  coilGroup.add(normalArrow);

  // ── Commutator / Slip rings (3D geometry at shaft bottom) ──
  const commGroup = new THREE.Group();
  commGroup.position.y = -1.1;
  scene.add(commGroup);
  // Two ring halves (copper)
  const ringGeo = new THREE.TorusGeometry(0.1, 0.03, 8, 16, Math.PI);
  const commRing1 = new THREE.Mesh(ringGeo, new THREE.MeshStandardMaterial({ color: 0xD4760A, metalness: 0.8, roughness: 0.2 }));
  const commRing2 = new THREE.Mesh(ringGeo, new THREE.MeshStandardMaterial({ color: 0xD4760A, metalness: 0.8, roughness: 0.2 }));
  commRing2.rotation.y = Math.PI;
  commGroup.add(commRing1, commRing2);
  // Brushes (carbon blocks)
  const brushGeo = new THREE.BoxGeometry(0.06, 0.08, 0.04);
  const brushMat = new THREE.MeshStandardMaterial({ color: 0x333333, roughness: 0.9 });
  const brush1 = new THREE.Mesh(brushGeo, brushMat);
  brush1.position.set(-0.14, 0, 0);
  const brush2 = new THREE.Mesh(brushGeo, brushMat);
  brush2.position.set(0.14, 0, 0);
  commGroup.add(brush1, brush2);
  // Brush holder arms
  const armMat = new THREE.MeshStandardMaterial({ color: 0x556677, metalness: 0.6, roughness: 0.3 });
  const arm1 = new THREE.Mesh(new THREE.BoxGeometry(0.12, 0.02, 0.02), armMat);
  arm1.position.set(-0.2, 0, 0);
  const arm2 = new THREE.Mesh(new THREE.BoxGeometry(0.12, 0.02, 0.02), armMat);
  arm2.position.set(0.2, 0, 0);
  commGroup.add(arm1, arm2);

  // ── Lightbulb (load indicator, glows with power) ──
  const bulbGroup = new THREE.Group();
  bulbGroup.position.set(0, -1.6, 0.8);
  scene.add(bulbGroup);
  // Bulb glass
  const bulbGlass = new THREE.Mesh(
    new THREE.SphereGeometry(0.12, 16, 12),
    new THREE.MeshStandardMaterial({ color: 0xFFFFDD, transparent: true, opacity: 0.3, roughness: 0.1, metalness: 0 })
  );
  bulbGroup.add(bulbGlass);
  // Filament (glows)
  const filamentMat = new THREE.MeshBasicMaterial({ color: 0x000000 });
  const filament = new THREE.Mesh(new THREE.SphereGeometry(0.04, 8, 6), filamentMat);
  bulbGroup.add(filament);
  // Bulb base
  const bulbBase = new THREE.Mesh(
    new THREE.CylinderGeometry(0.06, 0.08, 0.08, 12),
    new THREE.MeshStandardMaterial({ color: 0x888888, metalness: 0.7, roughness: 0.3 }));
  bulbBase.position.y = -0.14;
  bulbGroup.add(bulbBase);
  // Wires from commutator to bulb
  const wireMat = new THREE.MeshStandardMaterial({ color: 0xD4760A, metalness: 0.7, roughness: 0.3 });
  // Simple L-shaped wires
  const wire1V = new THREE.Mesh(new THREE.CylinderGeometry(0.015, 0.015, 0.5, 6), wireMat);
  wire1V.position.set(-0.14, -1.35, 0);
  scene.add(wire1V);
  const wire1H = new THREE.Mesh(new THREE.CylinderGeometry(0.015, 0.015, 0.8, 6), wireMat);
  wire1H.rotation.x = Math.PI / 2;
  wire1H.position.set(-0.14, -1.6, 0.4);
  scene.add(wire1H);
  const wire2V = new THREE.Mesh(new THREE.CylinderGeometry(0.015, 0.015, 0.5, 6), wireMat);
  wire2V.position.set(0.14, -1.35, 0);
  scene.add(wire2V);
  const wire2H = new THREE.Mesh(new THREE.CylinderGeometry(0.015, 0.015, 0.8, 6), wireMat);
  wire2H.rotation.x = Math.PI / 2;
  wire2H.position.set(0.14, -1.6, 0.4);
  scene.add(wire2H);

  // ── Current flow particles on coil ──
  const particleCount = 60;
  const particleGeo = new THREE.BufferGeometry();
  const particlePositions = new Float32Array(particleCount * 3);
  particleGeo.setAttribute('position', new THREE.BufferAttribute(particlePositions, 3));
  const particleMat = new THREE.PointsMaterial({
    color: 0xFCD34D, size: 0.07, sizeAttenuation: true, transparent: true,
  });
  const particles = new THREE.Points(particleGeo, particleMat);
  coilGroup.add(particles);

  // ── Brush spark particles ──
  const sparkCount = 20;
  const sparkGeo = new THREE.BufferGeometry();
  const sparkPos = new Float32Array(sparkCount * 3);
  const sparkVel = new Float32Array(sparkCount * 3);
  const sparkLife = new Float32Array(sparkCount);
  for (let i = 0; i < sparkCount; i++) sparkLife[i] = -1; // inactive
  sparkGeo.setAttribute('position', new THREE.BufferAttribute(sparkPos, 3));
  const sparkMat = new THREE.PointsMaterial({
    color: 0xFFDD44, size: 0.035, sizeAttenuation: true, transparent: true, opacity: 0.9,
  });
  const sparks = new THREE.Points(sparkGeo, sparkMat);
  scene.add(sparks);

  // ── Workbench (ground plane with wood-like color) ──
  const benchGeo = new THREE.BoxGeometry(6, 0.15, 4);
  const benchMat = new THREE.MeshStandardMaterial({ color: 0x5C3A1E, roughness: 0.85, metalness: 0.05 });
  const bench = new THREE.Mesh(benchGeo, benchMat);
  bench.position.y = -1.87;
  bench.receiveShadow = true; bench.castShadow = true;
  scene.add(bench);
  // Bench legs
  const legGeo = new THREE.BoxGeometry(0.12, 0.6, 0.12);
  const legMat = new THREE.MeshStandardMaterial({ color: 0x4A2E15, roughness: 0.9, metalness: 0.05 });
  [[-2.5, -2.17, -1.5], [2.5, -2.17, -1.5], [-2.5, -2.17, 1.5], [2.5, -2.17, 1.5]].forEach(p => {
    const leg = new THREE.Mesh(legGeo, legMat);
    leg.position.set(p[0], p[1], p[2]);
    leg.castShadow = true;
    scene.add(leg);
  });
  // Ground floor (under bench)
  const floorGeo = new THREE.PlaneGeometry(12, 12);
  const floorMat = new THREE.MeshStandardMaterial({ color: 0x151D2A, roughness: 1, metalness: 0 });
  const floor = new THREE.Mesh(floorGeo, floorMat);
  floor.rotation.x = -Math.PI / 2;
  floor.position.y = -2.47;
  floor.receiveShadow = true;
  scene.add(floor);
  // Grid
  const gridHelper = new THREE.GridHelper(8, 16, 0x334155, 0x1E293B);
  gridHelper.position.y = -1.79;
  scene.add(gridHelper);

  /* ─── Waveform history ─── */
  const wfHistory = [];
  const WF_MAX = 300;

  /* ─── UI Controls ─── */
  sidebarEl.innerHTML = buildSidebar(P);
  bindControls(sidebarEl, P, () => {
    if (P.mode === 1) { state = [0.3, 0, 0]; }
    else { state = [0, P.rpm * 2 * Math.PI / 60, 0]; }
    simTime = 0;
    wfHistory.length = 0;
  });

  /* ─── Resize ─── */
  function resize() {
    const w = container.clientWidth;
    const h = Math.min(w * 0.65, 560);
    renderer.setSize(w, h);
    composer.setSize(w, h);
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
  }
  resize();
  window.addEventListener('resize', resize);

  /* ─── Animation Loop ─── */
  const DT = 1 / 120;
  const SUBSTEPS = 3;

  function animate() {
    requestAnimationFrame(animate);

    if (P._playing) {
      for (let s = 0; s < SUBSTEPS; s++) {
        state = rk4Gen(state, DT, P);
        postStepGen(state, P);
        simTime += DT;
      }
    }

    const [theta, omega, I] = state;
    const NBA = P.N * P.B * P.A;
    const emfRaw = NBA * omega * Math.sin(theta);
    const emf = (P.commutator || P.mode === 1) ? Math.abs(emfRaw) : emfRaw;
    const peakEMF = NBA * Math.abs(omega);
    const torque = NBA * I * ((P.commutator || P.mode === 1) ? Math.abs(Math.sin(theta)) : Math.sin(theta));
    const power = emf * I;

    // Rotate coil around Y-axis. Offset by π/2 so that at θ=0 the coil normal
    // aligns with B (along +X) — matching the physics convention Φ = NBA·cos(θ).
    // Without offset: PlaneGeometry normal starts along +Z, perpendicular to B.
    coilGroup.rotation.y = theta + Math.PI / 2;

    // Current direction → color ALL active edges (shared materials)
    const curSign = emf > 0.001 ? 1 : emf < -0.001 ? -1 : 0;
    copperMatL.color.setHex(curSign > 0 ? 0xEF4444 : curSign < 0 ? 0x3B82F6 : 0xD4760A);
    copperMatR.color.setHex(curSign > 0 ? 0x3B82F6 : curSign < 0 ? 0xEF4444 : 0xD4760A);

    // Flux indicator: face opacity (Φ = NBA·cos(θ), max at θ=0)
    faceMat.opacity = 0.05 + 0.25 * Math.abs(Math.cos(theta));

    // Current particles: flow along coil edges
    const speed = Math.abs(I) * 2;
    const pos = particles.geometry.attributes.position.array;
    for (let i = 0; i < particleCount; i++) {
      const t = ((simTime * speed + i / particleCount) % 1);
      // Trace the coil rectangle: 4 sides
      const perimeter = 2 * (coilW + coilH);
      const d = t * perimeter;
      let px, py, pz = 0;
      if (d < coilW) {
        // Bottom: left to right
        px = -coilW / 2 + d; py = -coilH / 2;
      } else if (d < coilW + coilH) {
        // Right: bottom to top
        px = coilW / 2; py = -coilH / 2 + (d - coilW);
      } else if (d < 2 * coilW + coilH) {
        // Top: right to left
        px = coilW / 2 - (d - coilW - coilH); py = coilH / 2;
      } else {
        // Left: top to bottom
        px = -coilW / 2; py = coilH / 2 - (d - 2 * coilW - coilH);
      }
      pos[i * 3] = px;
      pos[i * 3 + 1] = py;
      pos[i * 3 + 2] = pz;
    }
    particles.geometry.attributes.position.needsUpdate = true;
    particleMat.opacity = Math.min(1, Math.abs(I) * 10 + 0.1);

    // ── Animated field particles (flowing N → S) ──
    const fPos = fieldParticles.geometry.attributes.position.array;
    for (let i = 0; i < fieldParticleCount; i++) {
      const phase = (fieldPPhase[i] + simTime * 0.3) % 1;
      fPos[i * 3] = -1.6 + phase * 3.2; // x: N to S
      // y and z stay as initialized (random spread)
    }
    fieldParticles.geometry.attributes.position.needsUpdate = true;

    // ── Commutator rotates with coil (same offset) ──
    commGroup.rotation.y = theta + Math.PI / 2;

    // ── Lightbulb glow (pulses with AC power, scales to peak) ──
    const peakPower = peakEMF > 0.001 ? (peakEMF * peakEMF) / P.R : 1;
    const glowIntensity = Math.min(1, Math.abs(power) / peakPower);
    const glowR = Math.round(255 * glowIntensity);
    const glowG = Math.round(200 * glowIntensity);
    const glowB = Math.round(50 * glowIntensity);
    filamentMat.color.setRGB(glowR / 255, glowG / 255, glowB / 255);
    bulbGlass.material.opacity = 0.15 + glowIntensity * 0.4;
    bulbGlass.material.emissive = filamentMat.color;
    bulbGlass.material.emissiveIntensity = glowIntensity * 0.5;

    // ── Brush sparks (emit when current is high) ──
    const sPos = sparks.geometry.attributes.position.array;
    for (let i = 0; i < sparkCount; i++) {
      if (sparkLife[i] < 0) {
        // Spawn sparks only near commutator switching points (θ ≈ 0, π)
        // and only in DC commutator mode (slip rings don't spark)
        const nearSwitch = Math.abs(Math.sin(theta)) < 0.15;
        if ((P.commutator || P.mode === 1) && nearSwitch && Math.abs(I) > 0.02 && Math.random() < 0.5) {
          const side = Math.random() < 0.5 ? -1 : 1;
          const cy = commGroup.position.y;
          sPos[i * 3] = side * 0.14 + (Math.random() - 0.5) * 0.03;
          sPos[i * 3 + 1] = cy + (Math.random() - 0.5) * 0.04;
          sPos[i * 3 + 2] = (Math.random() - 0.5) * 0.03;
          sparkVel[i * 3] = (Math.random() - 0.5) * 0.8;
          sparkVel[i * 3 + 1] = Math.random() * 0.5 - 0.3;
          sparkVel[i * 3 + 2] = (Math.random() - 0.5) * 0.8;
          sparkLife[i] = 1;
        }
      } else {
        // Update existing spark
        sparkLife[i] -= DT * 4;
        sPos[i * 3] += sparkVel[i * 3] * DT;
        sPos[i * 3 + 1] += sparkVel[i * 3 + 1] * DT;
        sPos[i * 3 + 2] += sparkVel[i * 3 + 2] * DT;
        sparkVel[i * 3 + 1] -= 2 * DT; // gravity
        if (sparkLife[i] < 0) {
          sPos[i * 3 + 1] = -10; // hide
        }
      }
    }
    sparks.geometry.attributes.position.needsUpdate = true;
    sparkMat.opacity = Math.min(0.9, Math.abs(I) * 5);

    // Waveform history
    if (P._playing) {
      wfHistory.push({ t: simTime, emf, I, flux: NBA * Math.cos(theta) });
      if (wfHistory.length > WF_MAX) wfHistory.shift();
    }

    // Update readout
    const rpmActual = Math.abs(omega) * 60 / (2 * Math.PI);
    const rmsV = peakEMF / Math.SQRT2;
    readoutEl.innerHTML =
      `<span>EMF <b>${emf.toFixed(2)} V</b></span>` +
      `<span>I <b>${(I * 1000).toFixed(1)} mA</b></span>` +
      `<span>τ <b>${(torque * 1000).toFixed(1)} mN·m</b></span>` +
      `<span>P <b>${(power * 1000).toFixed(1)} mW</b></span>` +
      `<span>${P.mode === 1 ? 'Motor' : 'Gen'} <b>${rpmActual.toFixed(0)} RPM</b></span>` +
      `<span>Peak <b>${peakEMF.toFixed(2)} V</b></span>` +
      (P.mode === 0 ? `<span>RMS <b>${rmsV.toFixed(2)} V</b></span>` : `<span>V_dc <b>${P.motorV} V</b></span>`) +
      `<span>θ <b>${(((theta * 180 / Math.PI) % 360 + 360) % 360).toFixed(0)}°</b></span>`;

    controls.update();
    composer.render();
  }

  animate();
}

/* ═══════════════════ HELPERS ═══════════════════ */

function makeEdge(len, r, mat) {
  const geo = new THREE.CylinderGeometry(r, r, len, 8);
  geo.rotateZ(Math.PI / 2);
  return new THREE.Mesh(geo, mat);
}

function makeEdgeV(len, r, mat) {
  return new THREE.Mesh(new THREE.CylinderGeometry(r, r, len, 8), mat);
}

function makeTextSprite(text, color, size) {
  const canvas = document.createElement('canvas');
  canvas.width = size * 2; canvas.height = size * 2;
  const ctx = canvas.getContext('2d');
  ctx.font = `bold ${size}px sans-serif`;
  ctx.fillStyle = color;
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.fillText(text, size, size);
  const tex = new THREE.CanvasTexture(canvas);
  const mat = new THREE.SpriteMaterial({ map: tex, transparent: true, depthTest: false });
  const sprite = new THREE.Sprite(mat);
  sprite.scale.set(0.5, 0.5, 1);
  return sprite;
}

/* ═══════════════════ UI ═══════════════════ */

function buildSidebar(P) {
  return `
    <div class="lab-ctrl-group">
      <div class="lab-ctrl-head">Generator / Motor</div>
      ${slider('B', 'Field B (T)', P.B, 0.05, 2, 0.05)}
      ${slider('N', 'Turns N', P.N, 1, 500, 1)}
      ${slider('A', 'Area A (m²)', P.A, 0.001, 0.1, 0.001)}
      ${slider('rpm', 'Speed RPM', P.rpm, 5, 3000, 5)}
      ${slider('R', 'Load R (Ω)', P.R, 0.5, 1000, 0.5)}
      ${slider('L', 'Load L (H)', P.L, 0, 0.5, 0.01)}
      ${toggle('commutator', 'DC Commutator', P.commutator)}
      ${slider('mode', 'Mode (0=Gen 1=Motor)', P.mode, 0, 1, 1)}
      ${slider('motorV', 'Motor V (V)', P.motorV, 0, 50, 0.5)}
      ${slider('phases', 'Phases', P.phases, 1, 3, 2)}
    </div>
    <div class="lab-ctrl-group">
      <div class="lab-ctrl-head">Presets</div>
      <div id="gen3d-presets" style="display:flex;flex-wrap:wrap;gap:6px;padding:8px 0;">
        <button class="lab-preset" data-preset="default">AC Default</button>
        <button class="lab-preset" data-preset="dc">DC Commutator</button>
        <button class="lab-preset" data-preset="3phase">3-Phase</button>
        <button class="lab-preset" data-preset="rl">RL Load</button>
        <button class="lab-preset" data-preset="motor">DC Motor</button>
        <button class="lab-preset" data-preset="fast">Fast 600RPM</button>
      </div>
    </div>
    <div class="lab-ctrl-group" style="padding:8px 12px;">
      <button id="gen3d-play" class="lab-preset" style="width:100%;padding:8px;">⏸ Pause</button>
    </div>
  `;
}

function slider(key, label, value, min, max, step) {
  return `<div class="lab-ctrl-row">
    <label>${label}</label>
    <input type="range" data-key="${key}" min="${min}" max="${max}" step="${step}" value="${value}">
    <span class="lab-ctrl-val" data-val="${key}">${value}</span>
  </div>`;
}

function toggle(key, label, value) {
  return `<div class="lab-ctrl-row">
    <label>${label}</label>
    <input type="checkbox" data-key="${key}" ${value ? 'checked' : ''}>
  </div>`;
}

const PRESETS = {
  default: { N: 100, B: 0.5, A: 0.01, rpm: 60, R: 10, L: 0, commutator: false, mode: 0, phases: 1, motorV: 5 },
  dc: { N: 100, B: 0.5, A: 0.01, rpm: 60, R: 10, L: 0, commutator: true, mode: 0, phases: 1 },
  '3phase': { N: 100, B: 0.5, A: 0.01, rpm: 60, R: 10, L: 0, commutator: false, mode: 0, phases: 3 },
  rl: { N: 100, B: 0.5, A: 0.01, rpm: 60, R: 10, L: 0.1, commutator: false, mode: 0, phases: 1 },
  motor: { N: 100, B: 0.5, A: 0.01, rpm: 60, R: 10, L: 0, commutator: true, mode: 1, motorV: 5, phases: 1 },
  fast: { N: 100, B: 0.5, A: 0.01, rpm: 600, R: 10, L: 0, commutator: false, mode: 0, phases: 1 },
};

function bindControls(sidebar, P, onReset) {
  // Sliders
  sidebar.querySelectorAll('input[type=range]').forEach(inp => {
    inp.addEventListener('input', () => {
      const key = inp.dataset.key;
      P[key] = parseFloat(inp.value);
      sidebar.querySelector(`[data-val="${key}"]`).textContent = inp.value;
      if (key === 'rpm' && P.mode === 0) onReset();
      if (key === 'mode') onReset();
    });
  });
  // Toggles
  sidebar.querySelectorAll('input[type=checkbox]').forEach(inp => {
    inp.addEventListener('change', () => {
      P[inp.dataset.key] = inp.checked;
    });
  });
  // Presets
  sidebar.querySelectorAll('[data-preset]').forEach(btn => {
    btn.addEventListener('click', () => {
      const preset = PRESETS[btn.dataset.preset];
      if (!preset) return;
      Object.assign(P, preset);
      // Update UI
      sidebar.querySelectorAll('input[type=range]').forEach(inp => {
        const key = inp.dataset.key;
        if (P[key] !== undefined) {
          inp.value = P[key];
          sidebar.querySelector(`[data-val="${key}"]`).textContent = P[key];
        }
      });
      sidebar.querySelectorAll('input[type=checkbox]').forEach(inp => {
        if (P[inp.dataset.key] !== undefined) inp.checked = P[inp.dataset.key];
      });
      onReset();
    });
  });
  // Play/pause
  const playBtn = sidebar.querySelector('#gen3d-play');
  if (playBtn) {
    playBtn.addEventListener('click', () => {
      P._playing = !P._playing;
      playBtn.textContent = P._playing ? '⏸ Pause' : '▶ Play';
    });
  }
}
