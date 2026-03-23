/**
 * Two Masses on Inclined Plane with Pulley — Three.js 3D
 *
 * m₁ (brown) on ramp at angle θ with friction μ,
 * connected via rope over pulley to m₂ (green) hanging vertically.
 *
 * a = g·(m₂ − μ·m₁·cosθ − m₁·sinθ) / (m₁ + m₂)   [m₁ moving uphill]
 * T = m₁·m₂·g·(1 + μ·cosθ + sinθ) / (m₁ + m₂)
 *
 * State: s = distance m₁ moved along ramp (positive = uphill, m₂ goes down)
 */

import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { TabSwitcher } from '../ui/tabs.js';
import { TimeGraph } from '../canvas/time-graph.js';

const G = 9.81;

/* ═══════════════════════ PHYSICS ═══════════════════════ */

function pulleyPhysics(s, v, P) {
  const th = P.angle * Math.PI / 180;
  const m1 = P.m1, m2 = P.m2, mu_k = P.mu_k, mu_s = P.mu_s;
  const ct = Math.cos(th), st = Math.sin(th);

  const N = m1 * G * ct;                       // normal force on m₁
  const gravRamp = m1 * G * st;                // m₁ gravity component along ramp (downhill)
  const gravHang = m2 * G;                     // m₂ weight (pulling rope)

  // Net force without friction (positive = m₂ wins → m₁ uphill)
  const Fnet_nf = gravHang - gravRamp;

  let Ff = 0, equilibrium = false;
  const moving = Math.abs(v) > 1e-3;

  if (moving) {
    // Kinetic friction opposes motion direction
    Ff = mu_k * N * Math.sign(v);              // v>0 (uphill) → Ff>0 (resists uphill)
  } else {
    const Fs_max = mu_s * N;
    if (Math.abs(Fnet_nf) <= Fs_max) {
      // Static friction holds — equilibrium
      return { a: 0, T: gravHang, Ff: -Fnet_nf, Fnet: 0, N, gravRamp, gravHang,
               equilibrium: true };
    }
    // Static overcome → kinetic kicks in
    Ff = mu_k * N * Math.sign(Fnet_nf);
  }

  const Fnet = Fnet_nf - Ff;
  const a = Fnet / (m1 + m2);

  // Tension from m₂ FBD:  m₂g − T = m₂·a  →  T = m₂·(g − a)
  const T = m2 * (G - a);

  return { a, T, Ff, Fnet, N, gravRamp, gravHang, equilibrium };
}

/** Analytical acceleration (for tests) */
function analyticAccel(P) {
  const th = P.angle * Math.PI / 180;
  const ct = Math.cos(th), st = Math.sin(th);
  return G * (P.m2 - P.mu_k * P.m1 * ct - P.m1 * st) / (P.m1 + P.m2);
}

/** Analytical tension (for tests) */
function analyticTension(P) {
  const th = P.angle * Math.PI / 180;
  const ct = Math.cos(th), st = Math.sin(th);
  return P.m1 * P.m2 * G * (1 + P.mu_k * ct + st) / (P.m1 + P.m2);
}

/* ═══════════════════ THREE.JS SCENE ═══════════════════ */

export function createPulleySim(el) {
  const canvasWrap = el.simContainer;
  const sidebarEl  = el.sidebar;
  const readoutEl  = el.readout;
  const tabsEl     = el.tabs;

  /* ─── State ─── */
  const P = {
    m1: 5, m2: 3, angle: 30, mu_k: 0.3, mu_s: 0.4, rampLength: 6,
    showForces: true, showValues: true,
  };
  let s = 1, v = 0, t = 0, running = true, lastTime = null, s0 = 1; // s0 = PE reference
  let frictionHeat = 0, simSpeed = 1;
  const RAMP_W = 1.8, RAMP_T = 0.15;  // narrower, thinner — less bulky

  /* ─── Scene ─── */
  const scene = new THREE.Scene();
  scene.background = new THREE.Color(0xB8D0E8);
  scene.fog = new THREE.Fog(0xB8D0E8, 30, 65);

  const W = canvasWrap.clientWidth || 700;
  const H = Math.max(canvasWrap.clientHeight || 0, 480);
  const isMobile = W < 600;
  const camera = new THREE.PerspectiveCamera(isMobile ? 55 : 45, W / H, 0.1, 100);
  // Higher, more to the right, looking down — clear overview of ramp + hanging mass
  camera.position.set(isMobile ? 2 : 3, isMobile ? 5 : 6, isMobile ? 9 : 11);

  const renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(W, H);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;
  canvasWrap.appendChild(renderer.domElement);

  const orbit = new OrbitControls(camera, renderer.domElement);
  orbit.target.set(3, 2, 0);  // center on ramp midpoint
  orbit.enableDamping = true;
  orbit.dampingFactor = 0.08;
  orbit.update();

  /* ─── Lighting (3-point: ambient + sun + fill) ─── */
  scene.add(new THREE.AmbientLight(0xFFFFFF, 0.55));
  const sun = new THREE.DirectionalLight(0xFFF5DD, 1.0);
  sun.position.set(8, 15, 6); sun.castShadow = true;
  sun.shadow.mapSize.set(1024, 1024);
  sun.shadow.camera.left = -12; sun.shadow.camera.right = 12;
  sun.shadow.camera.top = 12; sun.shadow.camera.bottom = -4;
  scene.add(sun);
  const fill = new THREE.DirectionalLight(0xAABBDD, 0.35);
  fill.position.set(-5, 4, -3);
  scene.add(fill);

  /* ─── Sprite helpers ─── */
  function drawOutlinedText(cx, text, x, y, color, fs) {
    cx.font = `bold ${fs}px 'DM Sans', Arial, sans-serif`;
    cx.textBaseline = 'top';
    cx.strokeStyle = 'rgba(255,255,255,0.85)';
    cx.lineWidth = 4; cx.lineJoin = 'round';
    cx.strokeText(text, x, y);
    cx.fillStyle = color || '#333';
    cx.fillText(text, x, y);
  }
  function makeSprite(text, color, fontSize) {
    const c = document.createElement('canvas'); c.width = 512; c.height = 128;
    drawOutlinedText(c.getContext('2d'), text, 6, 10, color, fontSize || 30);
    const tex = new THREE.CanvasTexture(c); tex.minFilter = THREE.LinearFilter;
    const spr = new THREE.Sprite(new THREE.SpriteMaterial({ map: tex, transparent: true, depthTest: false }));
    spr.scale.set(2.8, 0.65, 1);
    return spr;
  }
  function updateSpriteText(spr, text, color) {
    const tex = spr.material.map, c = tex.image, cx = c.getContext('2d');
    cx.clearRect(0, 0, c.width, c.height);
    drawOutlinedText(cx, text, 6, 10, color, 26);
    tex.needsUpdate = true;
  }

  /* ─── Ground ─── */
  const ground = new THREE.Mesh(
    new THREE.PlaneGeometry(30, 15),
    new THREE.MeshLambertMaterial({ color: 0x6AAA50 }));
  ground.rotation.x = -Math.PI / 2;
  ground.receiveShadow = true;
  scene.add(ground);

  /* ─── Ramp (rebuilt when angle/length changes) ─── */
  const rampGroup = new THREE.Group();
  scene.add(rampGroup);

  function buildRamp() {
    while (rampGroup.children.length) {
      const c = rampGroup.children[0]; rampGroup.remove(c);
      if (c.geometry) c.geometry.dispose();
    }
    const th = P.angle * Math.PI / 180;
    const L = P.rampLength, ct = Math.cos(th), st = Math.sin(th);
    if (th < 0.01) return;

    // ── Single clean ramp plank ──
    const plank = new THREE.Mesh(
      new THREE.BoxGeometry(L, RAMP_T, RAMP_W),
      new THREE.MeshLambertMaterial({ color: 0xC8943C, transparent: true, opacity: 0.85 }));
    plank.castShadow = true; plank.receiveShadow = true;
    plank.position.set((L / 2) * ct, (L / 2) * st + RAMP_T / 2, 0);
    plank.rotation.z = th;
    rampGroup.add(plank);

    // Thin edge line along the top surface for definition
    const edgeMat = new THREE.LineBasicMaterial({ color: 0x8B6914 });
    const topEdge = new THREE.Line(
      new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(0, 0, RAMP_W / 2 + 0.01),
        new THREE.Vector3(L * ct, L * st + RAMP_T, RAMP_W / 2 + 0.01)]),
      edgeMat);
    rampGroup.add(topEdge);

    // One simple support leg at the midpoint
    const midD = L * 0.6;
    const legX = midD * ct, legY = midD * st;
    if (legY > 0.3) {
      const legMat = new THREE.MeshLambertMaterial({ color: 0x7A6545 });
      const leg = new THREE.Mesh(new THREE.BoxGeometry(0.1, legY, 0.1), legMat);
      leg.position.set(legX, legY / 2, 0);
      leg.castShadow = true;
      rampGroup.add(leg);
    }

    // Angle arc
    const R = 1.0, arcPts = [];
    for (let a = 0; a <= th + 0.01; a += 0.04)
      arcPts.push(new THREE.Vector3(R * Math.cos(a), R * Math.sin(a), RAMP_W / 2 + 0.1));
    rampGroup.add(new THREE.Line(
      new THREE.BufferGeometry().setFromPoints(arcPts),
      new THREE.LineBasicMaterial({ color: 0x555577 })));
    const lbl = makeSprite(P.angle.toFixed(0) + '°', '#444', 26);
    lbl.position.set(1.3 * Math.cos(th / 2), 1.3 * Math.sin(th / 2), RAMP_W / 2 + 0.2);
    lbl.scale.set(1.8, 0.45, 1);
    rampGroup.add(lbl);
  }

  /* ─── Pulley structure: vertical pole + arm + torus wheel ─── */
  const pulleyGroup = new THREE.Group();
  scene.add(pulleyGroup);
  const pulleyR = 0.3;     // wheel radius (slightly bigger for visibility)
  const TUBE_R = 0.04;     // torus tube thickness

  function buildPulley() {
    while (pulleyGroup.children.length) {
      const c = pulleyGroup.children[0]; pulleyGroup.remove(c);
      if (c.geometry) c.geometry.dispose();
    }
    const th = P.angle * Math.PI / 180;
    const L = P.rampLength;
    const topX = L * Math.cos(th);
    const topY = L * Math.sin(th) + RAMP_T;
    // Pulley sits just above the ramp top
    const px = topX, py = topY + pulleyR + 0.15;

    // Vertical pole — from ground up past the ramp top
    const poleH = py + 0.5;
    const poleMat = new THREE.MeshLambertMaterial({ color: 0x445566 });
    const pole = new THREE.Mesh(
      new THREE.CylinderGeometry(0.06, 0.06, poleH, 8), poleMat);
    pole.position.set(topX, poleH / 2, 0);
    pole.castShadow = true;
    pulleyGroup.add(pole);

    // Horizontal arm — extends left from pole top (over the ramp)
    const arm = new THREE.Mesh(
      new THREE.BoxGeometry(0.8, 0.08, 0.08), poleMat);
    arm.position.set(topX - 0.4, py + 0.15, 0);
    pulleyGroup.add(arm);

    // Pulley wheel — TorusGeometry (donut shape, visible from all angles)
    const wheel = new THREE.Mesh(
      new THREE.TorusGeometry(pulleyR, TUBE_R, 12, 24),
      new THREE.MeshLambertMaterial({ color: 0x556677 }));
    wheel.position.set(px, py, 0);
    // Torus flat face toward camera by default — rotate so rope goes over it in XY plane
    // No rotation needed — torus default orientation has the hole facing +Z
    wheel.castShadow = true;
    pulleyGroup.add(wheel);

    // Axle through center
    const axle = new THREE.Mesh(
      new THREE.CylinderGeometry(0.03, 0.03, 0.3, 8),
      new THREE.MeshLambertMaterial({ color: 0xBBBBCC }));
    axle.rotation.x = Math.PI / 2;
    axle.position.set(px, py, 0);
    pulleyGroup.add(axle);

    pulleyGroup.userData.wheel = wheel;
    pulleyGroup.userData.center = { x: px, y: py };
  }

  /* ─── Masses ─── */
  let m1Mesh, m1Edges, m2Mesh, m2Edges, m1Size, m2Size;

  function buildMasses() {
    [m1Mesh, m1Edges, m2Mesh, m2Edges].forEach(m => { if (m) { scene.remove(m); if (m.geometry) m.geometry.dispose(); } });
    m1Size = 0.3 + 0.04 * Math.sqrt(P.m1);
    m2Size = 0.3 + 0.04 * Math.sqrt(P.m2);

    // m₁: warm red-brown (distinct from ramp wood which is 0xC07828)
    const g1 = new THREE.BoxGeometry(m1Size, m1Size, m1Size * 0.9);
    m1Mesh = new THREE.Mesh(g1, new THREE.MeshLambertMaterial({ color: 0xD45A20 }));
    m1Mesh.castShadow = true; scene.add(m1Mesh);
    m1Edges = new THREE.LineSegments(new THREE.EdgesGeometry(g1), new THREE.LineBasicMaterial({ color: 0x993310 }));
    scene.add(m1Edges);

    // m₂: vivid green
    const g2 = new THREE.BoxGeometry(m2Size, m2Size, m2Size * 0.9);
    m2Mesh = new THREE.Mesh(g2, new THREE.MeshLambertMaterial({ color: 0x10B981 }));
    m2Mesh.castShadow = true; scene.add(m2Mesh);
    m2Edges = new THREE.LineSegments(new THREE.EdgesGeometry(g2), new THREE.LineBasicMaterial({ color: 0x059669 }));
    scene.add(m2Edges);
  }

  /* ─── Rope (TubeGeometry along CatmullRomCurve3 — smooth, realistic) ─── */
  let ropeMesh = null;
  const ropeMat = new THREE.MeshLambertMaterial({ color: 0x332211 });
  const ROPE_R = 0.03;

  function syncPositions() {
    const th = P.angle * Math.PI / 180;
    const ct = Math.cos(th), st = Math.sin(th);
    const pc = pulleyGroup.userData.center;
    if (!pc || !m1Mesh) return;

    // ── m₁ on ramp ──
    const perpOff = RAMP_T / 2 + m1Size / 2;
    const m1x = s * ct - perpOff * st;
    const m1y = s * st + perpOff * ct;
    m1Mesh.position.set(m1x, m1y, 0);
    m1Mesh.rotation.z = th;
    m1Edges.position.copy(m1Mesh.position);
    m1Edges.rotation.copy(m1Mesh.rotation);

    // ── m₂ hanging ── (m₁ up → m₂ down)
    const hangDist = Math.max(0.5, s + 1.5);
    const m2x = pc.x;
    const m2y = pc.y - pulleyR - hangDist;
    m2Mesh.position.set(m2x, m2y, 0);
    m2Edges.position.copy(m2Mesh.position);

    // ── Rope as smooth TubeGeometry via CatmullRomCurve3 ──
    if (ropeMesh) { scene.remove(ropeMesh); ropeMesh.geometry.dispose(); }

    // Control points: rope hugs the pulley rim from ramp side over the top to vertical drop
    const r1 = new THREE.Vector3(m1x + (m1Size / 2) * ct, m1y + (m1Size / 2) * st, 0);

    // Tangent contact on left side (where rope from ramp meets the wheel)
    const entryAngle = Math.atan2(r1.y - pc.y, r1.x - pc.x);
    const pEntry = new THREE.Vector3(
      pc.x + pulleyR * Math.cos(entryAngle),
      pc.y + pulleyR * Math.sin(entryAngle), 0);

    // Top of pulley (rope drapes over)
    const pTop = new THREE.Vector3(pc.x, pc.y + pulleyR, 0);

    // Exit point: straight down from pulley center (rope drops vertically to m₂)
    const pExit = new THREE.Vector3(pc.x, pc.y - pulleyR, 0);

    const r2 = new THREE.Vector3(m2x, m2y + m2Size / 2, 0);

    const curve = new THREE.CatmullRomCurve3(
      [r1, pEntry, pTop, pExit, r2], false, 'catmullrom', 0.25);
    const tubeGeo = new THREE.TubeGeometry(curve, 32, ROPE_R, 6, false);
    ropeMesh = new THREE.Mesh(tubeGeo, ropeMat);
    ropeMesh.castShadow = true;
    scene.add(ropeMesh);

    // Spin pulley wheel (rotation.z since torus default faces +Z)
    const wheel = pulleyGroup.userData.wheel;
    if (wheel) wheel.rotation.z = s / pulleyR;
  }

  /* ─── Force arrows ─── */
  const arrowGroup = new THREE.Group();
  scene.add(arrowGroup);

  function make3DArrow(color) {
    const g = new THREE.Group();
    const shaft = new THREE.Mesh(
      new THREE.CylinderGeometry(0.04, 0.04, 1, 8),
      new THREE.MeshLambertMaterial({ color }));
    shaft.position.y = 0.5; g.add(shaft);
    const head = new THREE.Mesh(
      new THREE.ConeGeometry(0.12, 0.35, 8),
      new THREE.MeshLambertMaterial({ color }));
    head.position.y = 1.2; g.add(head);
    g.visible = false;
    arrowGroup.add(g);
    return g;
  }

  function setArrow(arr, ox, oy, dx, dy, show) {
    const mag = Math.hypot(dx, dy);
    if (!show || mag < 0.02) { arr.visible = false; return; }
    arr.visible = true;
    arr.position.set(ox, oy, 0);
    arr.rotation.set(0, 0, -Math.atan2(dx, dy));
    arr.children[0].scale.y = mag;
    arr.children[0].position.y = mag / 2;
    arr.children[1].position.y = mag + 0.18;
  }

  // Arrows for m₁: weight, normal, friction, tension
  const A1 = { weight: make3DArrow(0x2255EE), normal: make3DArrow(0xCCCC00),
               friction: make3DArrow(0xEE3333), tension: make3DArrow(0xE86A00) };
  // Arrows for m₂: weight, tension
  const A2 = { weight: make3DArrow(0x2255EE), tension: make3DArrow(0xE86A00) };
  // Labels
  const L1 = { weight: makeSprite('m₁g','#2255EE',22), normal: makeSprite('N','#999900',22),
               friction: makeSprite('f','#CC2222',22), tension: makeSprite('T','#CC5500',22) };
  const L2 = { weight: makeSprite('m₂g','#2255EE',22), tension: makeSprite('T','#CC5500',22) };
  Object.values(L1).forEach(l => { l.scale.set(2,0.5,1); l.visible = false; scene.add(l); });
  Object.values(L2).forEach(l => { l.scale.set(2,0.5,1); l.visible = false; scene.add(l); });

  const ASCALE = 0.03;

  function updateForceArrows() {
    const f = pulleyPhysics(s, v, P);
    const th = P.angle * Math.PI / 180;
    const ct = Math.cos(th), st = Math.sin(th);
    const show = P.showForces;
    const ox1 = m1Mesh.position.x, oy1 = m1Mesh.position.y;
    const ox2 = m2Mesh.position.x, oy2 = m2Mesh.position.y;

    // m₁ weight (straight down)
    setArrow(A1.weight, ox1, oy1, 0, -P.m1 * G * ASCALE, show);
    L1.weight.visible = show && P.showValues;
    L1.weight.position.set(ox1 + 0.4, oy1 - P.m1 * G * ASCALE - 0.2, 0.3);

    // m₁ normal (perpendicular outward from ramp)
    setArrow(A1.normal, ox1, oy1, -st * f.N * ASCALE, ct * f.N * ASCALE, show);
    L1.normal.visible = show && P.showValues;
    L1.normal.position.set(ox1 - st * f.N * ASCALE - 0.3, oy1 + ct * f.N * ASCALE + 0.2, 0.3);

    // m₁ tension (along ramp, uphill)
    setArrow(A1.tension, ox1, oy1, ct * f.T * ASCALE, st * f.T * ASCALE, show);
    L1.tension.visible = show && P.showValues;
    L1.tension.position.set(ox1 + ct * f.T * ASCALE + 0.2, oy1 + st * f.T * ASCALE + 0.2, 0.3);

    // m₁ friction (along ramp — Ff > 0 means subtracted from uphill = acts DOWNHILL)
    // Arrow direction: Ff > 0 → downhill (−ct,−st), Ff < 0 → uphill (+ct,+st)
    if (Math.abs(f.Ff) > 0.01) {
      const fDir = -Math.sign(f.Ff);  // flip: Ff>0 means downhill → arrow in −ramp direction
      const fLen = Math.abs(f.Ff) * ASCALE;
      setArrow(A1.friction, ox1, oy1, fDir * fLen * ct, fDir * fLen * st, show);
      L1.friction.visible = show && P.showValues;
      L1.friction.position.set(ox1 + fDir * fLen * ct, oy1 + fDir * fLen * st - 0.3, 0.3);
    } else { A1.friction.visible = false; L1.friction.visible = false; }

    // m₂ weight (down)
    setArrow(A2.weight, ox2, oy2, 0, -P.m2 * G * ASCALE, show);
    L2.weight.visible = show && P.showValues;
    L2.weight.position.set(ox2 + 0.4, oy2 - P.m2 * G * ASCALE - 0.2, 0.3);

    // m₂ tension (up)
    setArrow(A2.tension, ox2, oy2, 0, f.T * ASCALE, show);
    L2.tension.visible = show && P.showValues;
    L2.tension.position.set(ox2 + 0.3, oy2 + f.T * ASCALE + 0.2, 0.3);

    return f;
  }

  /* ─── Drag interaction ─── */
  const raycaster = new THREE.Raycaster();
  const pointer = new THREE.Vector2();
  let dragTarget = null, dragStartY = 0, dragStartS = 0;

  function ptrNDC(e) {
    const r = renderer.domElement.getBoundingClientRect();
    pointer.x = ((e.clientX - r.left) / r.width) * 2 - 1;
    pointer.y = -((e.clientY - r.top) / r.height) * 2 + 1;
  }

  renderer.domElement.addEventListener('pointerdown', e => {
    ptrNDC(e); raycaster.setFromCamera(pointer, camera);
    if (m1Mesh && raycaster.intersectObject(m1Mesh).length > 0) dragTarget = 'm1';
    else if (m2Mesh && raycaster.intersectObject(m2Mesh).length > 0) dragTarget = 'm2';
    if (!dragTarget) return;
    dragStartY = e.clientY; dragStartS = s;
    orbit.enabled = false;
    renderer.domElement.style.cursor = 'grabbing';
    renderer.domElement.setPointerCapture(e.pointerId);
  });

  renderer.domElement.addEventListener('pointermove', e => {
    if (dragTarget) {
      const dy = dragStartY - e.clientY;
      const ds = dy * 0.025;
      if (dragTarget === 'm2') s = dragStartS - ds;  // drag m₂ down → s decreases
      else s = dragStartS + ds;                        // drag m₁ up → s increases
      s = Math.max(0.2, Math.min(P.rampLength - 0.5, s));
      v = 0;
      return;
    }
    // Hover
    ptrNDC(e); raycaster.setFromCamera(pointer, camera);
    const hitM1 = m1Mesh && raycaster.intersectObject(m1Mesh).length > 0;
    const hitM2 = m2Mesh && raycaster.intersectObject(m2Mesh).length > 0;
    renderer.domElement.style.cursor = (hitM1 || hitM2) ? 'grab' : '';
    if (m1Mesh) m1Mesh.material.emissive.setHex(hitM1 ? 0x221100 : 0);
    if (m2Mesh) m2Mesh.material.emissive.setHex(hitM2 ? 0x002211 : 0);
  });

  renderer.domElement.addEventListener('pointerup', e => {
    if (!dragTarget) return;
    dragTarget = null; orbit.enabled = true;
    renderer.domElement.style.cursor = '';
    renderer.domElement.releasePointerCapture(e.pointerId);
  });

  /* ─── Info labels ─── */
  const m1Label = makeSprite('m₁', '#B84515', 28); m1Label.scale.set(2.2, 0.5, 1); scene.add(m1Label);
  const m2Label = makeSprite('m₂', '#059669', 28); m2Label.scale.set(2.2, 0.5, 1); scene.add(m2Label);

  /* ─── Physics step ─── */
  const DT = 1 / 240;

  function step(dt) {
    if (dragTarget) return;
    const f = pulleyPhysics(s, v, P);
    frictionHeat += Math.abs(f.Ff) * Math.abs(v) * dt;
    // RK4
    const k1a = f.a, k1v = v;
    const f2 = pulleyPhysics(s + 0.5 * dt * k1v, k1v + 0.5 * dt * k1a, P);
    const k2a = f2.a, k2v = k1v + 0.5 * dt * k1a;
    const f3 = pulleyPhysics(s + 0.5 * dt * k2v, k2v + 0.5 * dt * k2a, P);
    const k3a = f3.a, k3v = k2v + 0.5 * dt * k2a;
    const f4 = pulleyPhysics(s + dt * k3v, k3v + dt * k3a, P);
    const k4a = f4.a, k4v = k3v + dt * k3a;

    v += (dt / 6) * (k1a + 2 * k2a + 2 * k3a + k4a);
    s += (dt / 6) * (k1v + 2 * k2v + 2 * k3v + k4v);
    t += dt;

    // Boundaries
    if (s < 0.1) { s = 0.1; v = Math.max(v, 0); }
    if (s > P.rampLength - 0.3) { s = P.rampLength - 0.3; v = Math.min(v, 0); }
  }

  /* ─── Readout ─── */
  function updateReadout(f) {
    if (!readoutEl) return;
    let status;
    if (f.equilibrium) {
      status = '<span style="color:#22C55E">\u25CF EQUILIBRIUM — static friction holds</span>';
    } else if (f.a > 0.01) {
      status = '<span style="color:#E86A00">\u25CF m\u2082 pulling m\u2081 UPHILL</span>';
    } else if (f.a < -0.01) {
      status = '<span style="color:#3B82F6">\u25CF m\u2081 sliding DOWNHILL</span>';
    } else {
      status = '<span style="color:#22C55E">\u25CF Nearly balanced</span>';
    }
    readoutEl.innerHTML =
      `<span>a=<b>${f.a.toFixed(2)}</b> m/s\u00B2</span>` +
      `<span>T=<b>${f.T.toFixed(1)}</b> N</span>` +
      `<span>v=<b>${v.toFixed(2)}</b> m/s</span>` +
      `<span>f=<b>${Math.abs(f.Ff).toFixed(1)}</b> N</span>` +
      `<span>N=<b>${f.N.toFixed(1)}</b> N</span>` +
      `<span>Heat=<b>${frictionHeat.toFixed(1)}</b> J</span>` +
      `<span class="ramp-status">${status}</span>`;
  }

  /* ─── Tabs + Graphs ─── */
  let tabs = null, timeGraph = null, energyGraph = null;

  function setupTabs() {
    if (!tabsEl) return;
    const views = ['sim', 'time', 'energy'];
    const graphCanvases = { time: el.timeCanvas, energy: el.energyCanvas };
    tabs = new TabSwitcher(tabsEl, views, { canvasArea: el.canvasArea, graphCanvases });

    if (el.timeCanvas) {
      timeGraph = new TimeGraph(el.timeCanvas, { window: 12, capacity: 3000 });
      timeGraph.addLine(0, 'Position s (m)', '#8B5CF6');
      timeGraph.addLine(1, 'Velocity v (m/s)', '#06B6D4');
      timeGraph.addLine(2, 'Acceleration a (m/s\u00B2)', '#F59E0B');
    }
    if (el.energyCanvas) {
      energyGraph = new TimeGraph(el.energyCanvas, { window: 12, capacity: 3000 });
      energyGraph.addLine(0, 'KE total', '#EF4444');
      energyGraph.addLine(1, 'PE total', '#3B82F6');
      energyGraph.addLine(2, 'Total + Heat', '#10B981');
    }

    tabs.onSwitch(name => {
      requestAnimationFrame(() => {
        if (name === 'time' && timeGraph && timeGraph._resize) timeGraph._resize();
        if (name === 'energy' && energyGraph && energyGraph._resize) energyGraph._resize();
      });
    });
    tabs.restoreFromSession();
  }

  /* ─── Controls ─── */
  let doReset;

  function buildControls() {
    if (!sidebarEl) return;
    sidebarEl.innerHTML = '';

    function fmt(val, stp) { return stp >= 1 ? Math.round(val) + '' : stp >= 0.1 ? val.toFixed(1) : val.toFixed(2); }
    function slider(label, key, min, max, stp, unit) {
      const id = 'pul_' + key;
      const row = document.createElement('div'); row.className = 'param-row';
      row.innerHTML = `<div class="param-header"><span class="param-label">${label}</span>
        <span class="param-value" id="${id}_v">${fmt(P[key],stp)}${unit||''}</span></div>
        <input type="range" class="param-slider" id="${id}" aria-label="${label}"
               min="${min}" max="${max}" step="${stp}" value="${P[key]}">`;
      row.querySelector('input').addEventListener('input', e => {
        P[key] = parseFloat(e.target.value);
        row.querySelector('.param-value').textContent = fmt(P[key], stp) + (unit || '');
        if (key === 'angle' || key === 'rampLength') { buildRamp(); buildPulley(); }
        if (key === 'm1' || key === 'm2') buildMasses();
      });
      return row;
    }

    /* Transport */
    const tr = document.createElement('div'); tr.className = 'lab-transport';
    tr.innerHTML = `<button class="transport-btn" id="pul_play" title="Play/Pause">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path id="pul_icon" d="M6 4h4v16H6zM14 4h4v16h-4z"/></svg>
    </button><button class="transport-btn" id="pul_rst" title="Reset">\u21BA</button>
    <button class="transport-btn" id="pul_step" title="Step">\u25B6|</button>`;
    sidebarEl.appendChild(tr);

    function syncPlayIcon() {
      const icon = document.getElementById('pul_icon');
      if (icon) icon.setAttribute('d', running ? 'M6 4h4v16H6zM14 4h4v16h-4z' : 'M8 5v14l11-7z');
    }
    function togglePlay() { running = !running; lastTime = null; syncPlayIcon(); }
    doReset = function() { reset(); running = true; lastTime = null; syncPlayIcon(); };

    document.getElementById('pul_play').onclick = togglePlay;
    document.getElementById('pul_rst').onclick = doReset;
    document.getElementById('pul_step').onclick = () => { if (running) { running = false; syncPlayIcon(); } step(DT); };

    document.addEventListener('keydown', e => {
      if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT') return;
      if (e.code === 'Space') { e.preventDefault(); togglePlay(); }
      else if (e.code === 'KeyR') doReset();
      else if (e.code === 'ArrowRight') { if (running) { running = false; syncPlayIcon(); } step(DT); }
    });

    /* Params */
    const ps = document.createElement('div'); ps.className = 'lab-params';
    ps.appendChild(slider('m\u2081 (ramp)', 'm1', 0.5, 20, 0.5, ' kg'));
    ps.appendChild(slider('m\u2082 (hanging)', 'm2', 0.5, 20, 0.5, ' kg'));
    ps.appendChild(slider('Angle \u03B8', 'angle', 0, 60, 0.5, '\u00B0'));
    ps.appendChild(slider('\u03BC\u2096 (kinetic)', 'mu_k', 0, 1.0, 0.01, ''));
    ps.appendChild(slider('\u03BC\u209B (static)', 'mu_s', 0, 1.5, 0.01, ''));
    ps.appendChild(slider('Ramp Length', 'rampLength', 3, 10, 0.5, ' m'));
    sidebarEl.appendChild(ps);

    /* Checkboxes */
    const cs = document.createElement('div'); cs.className = 'lab-params';
    [['Show Forces','showForces'],['Show Values','showValues']].forEach(([l,k]) => {
      const r = document.createElement('div'); r.className = 'param-row';
      r.innerHTML = `<label class="param-check"><input type="checkbox" ${P[k]?'checked':''} id="pul_${k}"> ${l}</label>`;
      r.querySelector('input').addEventListener('change', e => { P[k] = e.target.checked; });
      cs.appendChild(r);
    });
    sidebarEl.appendChild(cs);

    /* Presets */
    const presets = [
      { name: 'Default', p: { m1: 5, m2: 3, angle: 30, mu_k: 0.3, mu_s: 0.4 } },
      { name: 'Balanced', p: { m1: 5, m2: 4.2, angle: 30, mu_k: 0.3, mu_s: 0.4 } },  // near upper dead zone edge (4.23)
      { name: 'Frictionless', p: { m1: 5, m2: 3, angle: 30, mu_k: 0, mu_s: 0 } },
      { name: 'Heavy Hanging', p: { m1: 2, m2: 10, angle: 30, mu_k: 0.2, mu_s: 0.3 } },
      { name: 'Slides Down', p: { m1: 15, m2: 3, angle: 40, mu_k: 0.1, mu_s: 0.15 } },
      { name: 'Equal Masses', p: { m1: 5, m2: 5, angle: 30, mu_k: 0.2, mu_s: 0.3 } },
      { name: 'High Friction', p: { m1: 5, m2: 5, angle: 30, mu_k: 0.7, mu_s: 0.9 } },
    ];
    const pre = document.createElement('div'); pre.className = 'lab-presets';
    presets.forEach(pr => {
      const b = document.createElement('button'); b.className = 'preset-btn'; b.textContent = pr.name;
      b.onclick = () => { Object.assign(P, pr.p); syncAll(); buildRamp(); buildPulley(); buildMasses(); doReset(); };
      pre.appendChild(b);
    });
    sidebarEl.appendChild(pre);

    /* Settings */
    const settings = document.createElement('details'); settings.className = 'lab-engine-settings';
    settings.innerHTML = '<summary>Settings</summary>';
    const setBody = document.createElement('div'); setBody.className = 'engine-body';
    const speedRow = document.createElement('div'); speedRow.className = 'engine-row';
    speedRow.innerHTML = `<span class="param-label">Speed</span>
      <select class="param-select" id="pul_speed"><option value="0.25">0.25\u00D7</option>
      <option value="0.5">0.5\u00D7</option><option value="1" selected>1\u00D7</option>
      <option value="2">2\u00D7</option><option value="4">4\u00D7</option></select>`;
    setBody.appendChild(speedRow);
    // Speed listener attached via querySelector on the element directly (not DOM yet)
    speedRow.querySelector('#pul_speed').addEventListener('change', e => { simSpeed = parseFloat(e.target.value); });
    const shareBtn = document.createElement('button'); shareBtn.className = 'lab-share-btn'; shareBtn.textContent = 'Share Link';
    shareBtn.addEventListener('click', () => {
      const pairs = Object.entries(P).filter(([,val]) => typeof val !== 'boolean')
        .map(([k,val]) => encodeURIComponent(k) + '=' + encodeURIComponent(val));
      const url = location.href.split('#')[0] + '#' + pairs.join('&');
      navigator.clipboard.writeText(url).then(() => { shareBtn.textContent = 'Copied!'; setTimeout(() => shareBtn.textContent = 'Share Link', 2000); })
        .catch(() => prompt('Copy:', url));
    });
    setBody.appendChild(shareBtn);
    settings.appendChild(setBody);
    sidebarEl.appendChild(settings);
  }

  function syncAll() {
    ['m1','m2','angle','mu_k','mu_s','rampLength'].forEach(k => {
      const inp = document.getElementById('pul_' + k); if (inp) inp.value = P[k];
      const ve = document.getElementById('pul_' + k + '_v');
      if (ve) { const stp = { m1:0.5,m2:0.5,angle:0.5,mu_k:0.01,mu_s:0.01,rampLength:0.5 }[k]||0.01;
        const u = { m1:' kg',m2:' kg',angle:'\u00B0',rampLength:' m' }[k]||'';
        ve.textContent = (stp>=0.1?P[k].toFixed(1):P[k].toFixed(2))+u; }
    });
  }

  /* ─── Animation ─── */
  function animate(now) {
    requestAnimationFrame(animate);
    if (running && lastTime !== null) {
      let dt = Math.min((now - lastTime) / 1000, 0.05) * simSpeed;
      while (dt >= DT) {
        step(DT);
        const f = pulleyPhysics(s, v, P);
        const th = P.angle * Math.PI / 180;
        if (timeGraph) timeGraph.push(t, new Float64Array([s, v, f.a]));
        if (energyGraph) {
          const KE = 0.5 * (P.m1 + P.m2) * v * v;
          // PE change relative to initial position (s₀=1):
          // m₁ rises by Δh₁ = (s - s₀)·sinθ  (positive when going uphill)
          // m₂ drops by Δh₂ = (s - s₀)         (positive s = m₂ drops = negative height)
          const ds = s - s0;  // relative to PE reference position
          const dPE = P.m1 * G * ds * Math.sin(th) - P.m2 * G * ds;
          energyGraph.push(t, new Float64Array([KE, dPE, KE + dPE + frictionHeat]));
        }
        dt -= DT;
      }
    }
    lastTime = running ? now : null;

    syncPositions();
    m1Label.position.set(m1Mesh.position.x, m1Mesh.position.y + m1Size * 0.8, 0.6);
    updateSpriteText(m1Label, 'm\u2081 = ' + P.m1.toFixed(1) + ' kg', '#B84515');
    m2Label.position.set(m2Mesh.position.x + 0.5, m2Mesh.position.y, 0.6);
    updateSpriteText(m2Label, 'm\u2082 = ' + P.m2.toFixed(1) + ' kg', '#059669');

    const f = updateForceArrows();
    updateReadout(f);

    if (timeGraph && el.timeCanvas && el.timeCanvas.style.display !== 'none') timeGraph.render();
    if (energyGraph && el.energyCanvas && el.energyCanvas.style.display !== 'none') energyGraph.render();

    // Gentle auto-orbit (stops permanently when user touches camera controls)
    if (autoOrbit && !dragTarget) {
      camTheta += 0.003;
      const camR = isMobile ? 9 : 11;
      camera.position.x = 3 + Math.sin(camTheta) * 2;
      camera.position.z = camR + Math.cos(camTheta) * 1.5;
    }
    orbit.update();
    renderer.render(scene, camera);
  }
  let camTheta = 0;
  let autoOrbit = true;
  orbit.addEventListener('start', () => { autoOrbit = false; });  // user touched camera → stop auto

  function reset() {
    s = 1; v = 0; t = 0; lastTime = null; frictionHeat = 0; s0 = s;  // PE reference = reset position
    if (timeGraph) timeGraph.clear();
    if (energyGraph) energyGraph.clear();
  }

  /* ─── Resize ─── */
  const ro = new ResizeObserver(() => {
    const w = canvasWrap.clientWidth; if (w === 0) return;
    const h = canvasWrap.clientHeight || Math.round(w * 0.6);
    camera.aspect = w / h;
    camera.fov = w < 500 ? 60 : w < 800 ? 50 : 45;
    camera.updateProjectionMatrix();
    renderer.setSize(w, h);
  });
  ro.observe(canvasWrap);

  /* ─── Init ─── */
  buildControls();
  buildRamp();
  buildPulley();
  buildMasses();
  setupTabs();
  requestAnimationFrame(animate);

  return { reset, destroy() { ro.disconnect(); renderer.dispose(); orbit.dispose(); } };
}
