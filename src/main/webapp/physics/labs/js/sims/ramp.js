/**
 * Ramp: Forces & Motion — Three.js 3D Simulation
 *
 * Block on flat ground → inclined ramp → wall.
 * Push it with an applied force — does it reach the wall?
 *
 * Visual style: sky-blue background, green grass, wood ramp, brick walls
 * Uses engine's TimeGraph + EnergyBar for graph tabs.
 */

import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { TabSwitcher } from '../ui/tabs.js';
import { TimeGraph } from '../canvas/time-graph.js';
import { EnergyBar } from '../canvas/energy-bar.js';

const G = 9.81;
const GROUND_LEFT = -7;
const RAMP_W = 3;         // ramp width (z-axis)
const RAMP_T = 0.25;      // ramp plank thickness

/* ─── Object & surface catalogs ─── */
const OBJECTS = {
  crate_sm:  { label: 'Small Crate',   mass: 5,   mu_s: 0.50, mu_k: 0.30, color: 0xD4881C, edge: 0x8A5010, icon: '\uD83D\uDCE6' },
  crate_lg:  { label: 'Large Crate',   mass: 20,  mu_s: 0.50, mu_k: 0.30, color: 0xB87818, edge: 0x704010, icon: '\uD83D\uDCE6' },
  fridge:    { label: 'Refrigerator',   mass: 80,  mu_s: 0.45, mu_k: 0.25, color: 0xCCCCDD, edge: 0x777788, icon: '\uD83E\uDDCA' },
  piano:     { label: 'Piano',          mass: 250, mu_s: 0.55, mu_k: 0.35, color: 0x1A1A1A, edge: 0x444444, icon: '\uD83C\uDFB9' },
  person:    { label: 'Person',         mass: 75,  mu_s: 0.60, mu_k: 0.40, color: 0x4488CC, edge: 0x2266AA, icon: '\uD83E\uDDCD' },
  ice_block: { label: 'Ice Block',      mass: 10,  mu_s: 0.05, mu_k: 0.02, color: 0xAADDFF, edge: 0x66AADD, icon: '\uD83E\uDDCA' },
  custom:    { label: 'Custom',         mass: 5,   mu_s: 0.50, mu_k: 0.30, color: 0x8B5CF6, edge: 0x6D28D9, icon: '\u2699\uFE0F'  },
};

const SURFACES = {
  wood:   { label: 'Wood',    color: 0xC07828, grain: 0xA06010, mu_s: null, mu_k: null },  // uses object's mu
  ice:    { label: 'Ice',     color: 0xAADDEE, grain: 0x88BBCC, mu_s: 0.03, mu_k: 0.01 },
  rubber: { label: 'Rubber',  color: 0x333333, grain: 0x222222, mu_s: 0.90, mu_k: 0.70 },
  metal:  { label: 'Metal',   color: 0x888899, grain: 0x666677, mu_s: 0.35, mu_k: 0.20 },
};

/* ═══════════════════════ PHYSICS ═══════════════════════ */

function forces(s, v, P) {
  const th = P.angle * Math.PI / 180, m = P.mass;
  const onRamp = s >= 0, slope = onRamp ? th : 0;
  const Fg = m * G;
  const Fg_par = Fg * Math.sin(slope), Fg_perp = Fg * Math.cos(slope);
  const Fa_along = P.appliedForce * Math.cos(slope);
  const Fa_into = onRamp ? P.appliedForce * Math.sin(slope) : 0;
  const N = Math.max(0, Fg_perp + Fa_into);
  const Fnet_nf = Fa_along - Fg_par;
  let Ff = 0;
  if (Math.abs(v) > 1e-3) {
    Ff = -Math.sign(v) * P.mu_k * N;
  } else {
    const Fs_max = P.mu_s * N;
    Ff = Math.abs(Fnet_nf) <= Fs_max ? -Fnet_nf : -Math.sign(Fnet_nf) * P.mu_k * N;
  }
  const Fnet = Fnet_nf + Ff;
  return { Fg, Fg_par, Fg_perp, N, Fa_along, Fa_into, Ff, Fnet, a: Fnet / m,
           Fs_max: P.mu_s * N, slope, onRamp };
}

/* ═══════════════════ THREE.JS SCENE ═══════════════════ */

export function createRampSim(el) {
  const canvasWrap = el.simContainer;
  const sidebarEl  = el.sidebar;
  const forceBarEl = el.forceBar;
  const readoutEl  = el.readout;
  const tabsEl     = el.tabs;

  /* ─── State ─── */
  const P = {
    angle: 30, mass: 5, mu_s: 0.5, mu_k: 0.3,
    appliedForce: 0, rampLength: 8,
    showForces: true, showValues: true, showDecomp: false,
    eTop: 0.0,             // restitution: top wall (0=brick, 1=perfectly elastic)
    eLeft: 0.0,            // restitution: left wall
    object: 'crate_sm',
    surface: 'wood',
  };
  let s = -3, v = 0, t = 0, running = true, lastTime = null;
  let frictionHeat = 0;   // accumulated energy lost to friction (Joules)
  let workApplied = 0;    // accumulated work done by applied force (Joules)

  /* ─── Scene ─── */
  const scene = new THREE.Scene();
  scene.background = new THREE.Color(0x87AACC);
  scene.fog = new THREE.Fog(0x87AACC, 30, 80);

  const W = canvasWrap.clientWidth || 700;
  const H = Math.max(canvasWrap.clientHeight || 0, 420);
  const isMobile = W < 600;
  const camera = new THREE.PerspectiveCamera(isMobile ? 60 : 50, W / H, 0.1, 200);
  camera.position.set(isMobile ? -1 : 0, isMobile ? 5 : 6, isMobile ? 14 : 16);
  camera.lookAt(2, 2, 0);

  const renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(W, H);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;
  canvasWrap.appendChild(renderer.domElement);

  const orbit = new OrbitControls(camera, renderer.domElement);
  orbit.target.set(2, 2, 0);
  orbit.enableDamping = true;
  orbit.dampingFactor = 0.08;
  orbit.maxPolarAngle = Math.PI * 0.48;
  orbit.minDistance = 5;
  orbit.maxDistance = 30;
  orbit.update();

  /* ─── Lighting ─── */
  scene.add(new THREE.AmbientLight(0xffffff, 0.55));
  const sun = new THREE.DirectionalLight(0xFFF5DD, 1.1);
  sun.position.set(10, 20, 10);
  sun.castShadow = true;
  sun.shadow.mapSize.set(1024, 1024);
  sun.shadow.camera.near = 1; sun.shadow.camera.far = 60;
  sun.shadow.camera.left = -20; sun.shadow.camera.right = 20;
  sun.shadow.camera.top = 20; sun.shadow.camera.bottom = -10;
  scene.add(sun);

  /* ─── Ground ─── */
  // Base ground (always green grass)
  const grassMesh = new THREE.Mesh(
    new THREE.PlaneGeometry(60, 30),
    new THREE.MeshLambertMaterial({ color: 0x6AAA50 }));
  grassMesh.rotation.x = -Math.PI / 2;
  grassMesh.receiveShadow = true;
  scene.add(grassMesh);

  // Surface overlay on ground (changes with surface selection, sits just above grass)
  const groundSurfMat = new THREE.MeshLambertMaterial({ color: 0x6AAA50, transparent: true, opacity: 0 });
  const groundSurfMesh = new THREE.Mesh(
    new THREE.BoxGeometry(GROUND_LEFT * -1 + 1, 0.04, RAMP_W),
    groundSurfMat);
  groundSurfMesh.position.set((GROUND_LEFT + 1) / 2, 0.02, 0);
  groundSurfMesh.receiveShadow = true;
  scene.add(groundSurfMesh);

  /** Update ground surface overlay to match current surface selection */
  function updateGroundSurface() {
    const surf = SURFACES[P.surface] || SURFACES.wood;
    if (P.surface === 'wood') {
      groundSurfMat.opacity = 0;   // show grass for wood
    } else {
      groundSurfMat.color.setHex(surf.color);
      groundSurfMat.opacity = 0.85; // overlay the surface material
    }
    groundSurfMat.needsUpdate = true;
  }

  /* ─── Metre rulers on ground ─── */
  const rulerGroup = new THREE.Group();
  scene.add(rulerGroup);

  function buildRuler() {
    while (rulerGroup.children.length) {
      const c = rulerGroup.children[0]; rulerGroup.remove(c);
      if (c.geometry) c.geometry.dispose();
    }
    const labelZ = RAMP_W / 2 + 0.5;

    // Ruler rail (long thin bar along ground edge)
    const rail = new THREE.Mesh(
      new THREE.BoxGeometry(22, 0.04, 0.08),
      new THREE.MeshBasicMaterial({ color: 0x557755 }));
    rail.position.set(3, 0.02, labelZ);
    rulerGroup.add(rail);

    for (let x = Math.ceil(GROUND_LEFT); x <= 14; x++) {
      // Tick mark — visible post
      const isMajor = x % 2 === 0;
      const tick = new THREE.Mesh(
        new THREE.BoxGeometry(0.06, isMajor ? 0.5 : 0.3, 0.06),
        new THREE.MeshBasicMaterial({ color: isMajor ? 0x558855 : 0x446644 }));
      tick.position.set(x, (isMajor ? 0.25 : 0.15), labelZ);
      rulerGroup.add(tick);
      // Metre label every 2m (large)
      if (isMajor) {
        const spr = makeSprite(x + 'm', '#557755', 28);
        spr.position.set(x, 0.08, labelZ + 0.6);
        spr.scale.set(1.8, 0.45, 1);
        rulerGroup.add(spr);
      }
    }

    // Ramp base marker — prominent bright bar across ground
    const baseMark = new THREE.Mesh(
      new THREE.BoxGeometry(0.12, 0.06, RAMP_W + 0.8),
      new THREE.MeshBasicMaterial({ color: 0xA78BFA }));
    baseMark.position.set(0, 0.03, 0);
    rulerGroup.add(baseMark);
    // "Ramp base" label — large
    const baseLabel = makeSprite('\u25B2 RAMP BASE (0m)', '#A78BFA', 26);
    baseLabel.position.set(0, 0.1, labelZ + 1.2);
    baseLabel.scale.set(3.2, 0.7, 1);
    rulerGroup.add(baseLabel);
  }

  /* ─── Ramp group (rebuilt when angle/length changes) ─── */
  const rampGroup = new THREE.Group();
  scene.add(rampGroup);
  let rampPlank = null;   // stored for raycasting
  let topWallMesh = null; // stored for hit flash

  function buildRamp() {
    while (rampGroup.children.length) {
      const c = rampGroup.children[0];
      rampGroup.remove(c);
      if (c.geometry) c.geometry.dispose();
    }
    const th = P.angle * Math.PI / 180;
    const L = P.rampLength;
    const ct = Math.cos(th), st = Math.sin(th);

    /* Ramp plank — color from current surface */
    rampPlank = null;
    const surf = SURFACES[P.surface] || SURFACES.wood;
    if (th > 0.01) {
      const rGeo = new THREE.BoxGeometry(L, RAMP_T, RAMP_W);
      const rMat = new THREE.MeshLambertMaterial({ color: surf.color });
      const ramp = new THREE.Mesh(rGeo, rMat);
      ramp.castShadow = true; ramp.receiveShadow = true;
      ramp.position.set((L / 2) * ct, (L / 2) * st + RAMP_T / 2, 0);
      ramp.rotation.z = th;
      rampPlank = ramp;
      rampGroup.add(ramp);
      /* Surface grain/texture lines */
      for (let i = -L / 2 + 1.5; i < L / 2; i += 1.5) {
        const lg = new THREE.Mesh(
          new THREE.BoxGeometry(0.05, RAMP_T + 0.01, RAMP_W + 0.01),
          new THREE.MeshLambertMaterial({ color: surf.grain }));
        lg.position.set(i, 0, 0);
        ramp.add(lg);
      }
    }

    /* Top wall */
    const wallH = 4;
    const topX = L * ct, topY = L * st;
    const wGeo = new THREE.BoxGeometry(0.6, wallH, RAMP_W);
    const wMat = new THREE.MeshLambertMaterial({ color: 0xB85A30 });
    const wall = new THREE.Mesh(wGeo, wMat);
    wall.castShadow = true;
    wall.position.set(topX + 0.3, topY + wallH / 2, 0);
    topWallMesh = wall;
    rampGroup.add(wall);
    /* Brick mortar */
    for (let r = 0; r < 6; r++) {
      const ml = new THREE.Mesh(
        new THREE.BoxGeometry(0.61, 0.05, RAMP_W + 0.01),
        new THREE.MeshLambertMaterial({ color: 0x8A3A18 }));
      ml.position.set(0, -wallH / 2 + r * 0.65 + 0.3, 0);
      wall.add(ml);
    }

    /* Angle arc */
    if (th > 0.01) {
      const R = 1.5;
      const arcPts = [];
      for (let a = 0; a <= th + 0.01; a += 0.04)
        arcPts.push(new THREE.Vector3(R * Math.cos(a), R * Math.sin(a), RAMP_W / 2 + 0.05));
      const arcGeo = new THREE.BufferGeometry().setFromPoints(arcPts);
      rampGroup.add(new THREE.Line(arcGeo, new THREE.LineBasicMaterial({ color: 0xFFFFFF })));
    }

    /* Height dashed line */
    if (topY > 0.1) {
      const hGeo = new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(topX, 0, RAMP_W / 2 + 0.05),
        new THREE.Vector3(topX, topY, RAMP_W / 2 + 0.05)]);
      const hLine = new THREE.Line(hGeo,
        new THREE.LineDashedMaterial({ color: 0x223355, dashSize: 0.3, gapSize: 0.2 }));
      hLine.computeLineDistances();
      rampGroup.add(hLine);
    }

    /* Angle label sprite */
    if (th > 0.01) {
      const spr = makeSprite(P.angle.toFixed(1) + '°', '#ffffff');
      spr.position.set(2.0, 0.8, RAMP_W / 2 + 0.1);
      rampGroup.add(spr);
    }
    /* Height label */
    if (topY > 0.1) {
      const spr = makeSprite('h=' + topY.toFixed(1) + 'm', '#223399');
      spr.position.set(topX + 1.2, topY / 2, RAMP_W / 2 + 0.1);
      rampGroup.add(spr);
    }
  }

  /* Left wall */
  const lw = new THREE.Mesh(
    new THREE.BoxGeometry(0.6, 5, RAMP_W),
    new THREE.MeshLambertMaterial({ color: 0xB85A30 }));
  lw.castShadow = true;
  lw.position.set(GROUND_LEFT - 0.3, 2.5, 0);
  scene.add(lw);

  /* ─── Live distance labels (updated every frame) ─── */
  const distLabels = {};
  function makeDistLabel(color) {
    const spr = makeSprite('', color, 32);
    spr.scale.set(3.5, 0.8, 1);
    spr.visible = false;
    scene.add(spr);
    return spr;
  }
  distLabels.pos      = makeDistLabel('#FFFFFF');   // "s = -3.0 m"
  distLabels.toRamp   = makeDistLabel('#A78BFA');   // "→ 3.0 m to ramp"
  distLabels.toWall   = makeDistLabel('#EE6644');   // "→ 5.0 m to wall"

  function updateDistLabels() {
    const th = P.angle * Math.PI / 180;
    const ox = crateMesh.position.x;
    const oy = crateMesh.position.y;
    const labelZ = RAMP_W / 2 + 0.3;

    // Position label above crate
    updateSpriteText(distLabels.pos, 's = ' + s.toFixed(1) + ' m', '#FFFFFF');
    distLabels.pos.position.set(ox, oy + crateSize * 0.8 + 0.4, labelZ);
    distLabels.pos.visible = true;

    // Distance to ramp base (only when on ground)
    if (s < -0.1) {
      const d = Math.abs(s);
      updateSpriteText(distLabels.toRamp, '\u2192 ' + d.toFixed(1) + 'm to ramp', '#A78BFA');
      distLabels.toRamp.position.set(ox / 2, 0.5, labelZ);
      distLabels.toRamp.visible = true;
    } else {
      distLabels.toRamp.visible = false;
    }

    // Distance to wall (always, measured along path)
    const dWall = P.rampLength - Math.max(0, s);
    if (s >= -0.1 && dWall > 0.2) {
      const wallX = P.rampLength * Math.cos(th);
      const wallY = P.rampLength * Math.sin(th);
      const midX = (ox + wallX) / 2;
      const midY = (oy + wallY) / 2;
      updateSpriteText(distLabels.toWall, '\u2192 ' + dWall.toFixed(1) + 'm to wall', '#EE6644');
      distLabels.toWall.position.set(midX, midY + 0.8, labelZ);
      distLabels.toWall.visible = true;
    } else {
      distLabels.toWall.visible = false;
    }
  }

  function updateSpriteText(sprite, text, color) {
    const tex = sprite.material.map;
    const c = tex.image;
    const cx = c.getContext('2d');
    cx.clearRect(0, 0, c.width, c.height);
    cx.font = "bold 32px 'DM Sans', Arial, sans-serif";
    cx.textBaseline = 'top';
    cx.fillStyle = color || '#fff';
    cx.fillText(text, 6, 10);
    tex.needsUpdate = true;
  }

  /* ─── Crate ─── */
  let crateSize = 0.9, crateMesh, crateEdges;
  const crateGroup = new THREE.Group();
  scene.add(crateGroup);

  function buildCrate() {
    while (crateGroup.children.length) {
      const c = crateGroup.children[0]; crateGroup.remove(c);
      if (c.geometry) c.geometry.dispose();
    }
    const obj = OBJECTS[P.object] || OBJECTS.crate_sm;
    crateSize = 0.5 + 0.015 * P.mass;
    const geo = new THREE.BoxGeometry(crateSize, crateSize, crateSize * 0.95);
    crateMesh = new THREE.Mesh(geo, new THREE.MeshLambertMaterial({ color: obj.color }));
    crateMesh.castShadow = true;
    crateGroup.add(crateMesh);
    crateEdges = new THREE.LineSegments(
      new THREE.EdgesGeometry(geo),
      new THREE.LineBasicMaterial({ color: obj.edge }));
    crateGroup.add(crateEdges);
  }

  function syncCrate() {
    const th = P.angle * Math.PI / 180;
    const hh = crateSize / 2;
    let cx, cy, rot;
    if (s < 0) { cx = s; cy = hh; rot = 0; }
    else {
      cx = s * Math.cos(th);
      cy = s * Math.sin(th) + RAMP_T / 2 * Math.cos(th) + hh * Math.cos(th);
      rot = th;
    }
    crateMesh.position.set(cx, cy, 0);
    crateMesh.rotation.z = rot;
    crateEdges.position.copy(crateMesh.position);
    crateEdges.rotation.copy(crateMesh.rotation);
  }

  /* ─── Click-drag interaction ─── */
  /*  • Click crate  → drag horizontally to apply force, release = force 0
   *  • Click ramp   → drag up/down to change angle
   *  • Hover either → visual highlight + cursor change               */
  const raycaster = new THREE.Raycaster();
  const pointer = new THREE.Vector2();
  const DRAG_NONE = 0, DRAG_CRATE = 1, DRAG_RAMP = 2;
  let dragMode = DRAG_NONE, dragStartX = 0, dragStartY = 0, dragStartAngle = 0;
  let hovTarget = '';   // '' | 'crate' | 'ramp'

  function ptrNDC(e) {
    const r = renderer.domElement.getBoundingClientRect();
    pointer.x = ((e.clientX - r.left) / r.width) * 2 - 1;
    pointer.y = -((e.clientY - r.top) / r.height) * 2 + 1;
  }

  function hitTest(e) {
    ptrNDC(e);
    raycaster.setFromCamera(pointer, camera);
    if (crateMesh && raycaster.intersectObject(crateMesh, false).length > 0) return 'crate';
    if (rampPlank && raycaster.intersectObject(rampPlank, true).length > 0) return 'ramp';
    return '';
  }

  /* ── Pointer down: start drag ── */
  renderer.domElement.addEventListener('pointerdown', e => {
    const hit = hitTest(e);
    if (!hit) return;
    dragMode = hit === 'crate' ? DRAG_CRATE : DRAG_RAMP;
    dragStartX = e.clientX;
    dragStartY = e.clientY;
    dragStartAngle = P.angle;
    orbit.enabled = false;
    renderer.domElement.style.cursor = 'grabbing';
    renderer.domElement.setPointerCapture(e.pointerId);
  });

  /* ── Pointer move: dragging or hover ── */
  renderer.domElement.addEventListener('pointermove', e => {
    if (dragMode === DRAG_CRATE) {
      const dx = e.clientX - dragStartX;
      P.appliedForce = Math.round(Math.max(-500, Math.min(500, dx * 1.5)));
      syncAll();
      return;
    }
    if (dragMode === DRAG_RAMP) {
      // Drag up = steeper, drag down = shallower (screen Y is inverted)
      const dy = dragStartY - e.clientY;           // positive = moved up
      const newAngle = Math.max(0, Math.min(60, dragStartAngle + dy * 0.25));
      P.angle = Math.round(newAngle * 2) / 2;     // snap to 0.5° steps
      syncAll();
      buildRamp();
      v = 0;                                       // reset velocity when angle changes
      return;
    }

    /* Hover */
    const hit = hitTest(e);
    if (hit !== hovTarget) {
      // Clear previous
      if (hovTarget === 'crate' && crateMesh) crateMesh.material.emissive.setHex(0x000000);
      if (hovTarget === 'ramp'  && rampPlank) rampPlank.material.emissive.setHex(0x000000);
      hovTarget = hit;
      // Highlight new
      if (hit === 'crate' && crateMesh) crateMesh.material.emissive.setHex(0x332200);
      if (hit === 'ramp'  && rampPlank) rampPlank.material.emissive.setHex(0x1A1000);
      renderer.domElement.style.cursor = hit ? 'grab' : '';
    }
  });

  /* ── Pointer up: release ── */
  renderer.domElement.addEventListener('pointerup', e => {
    if (dragMode === DRAG_NONE) return;
    const wasCrate = dragMode === DRAG_CRATE;
    dragMode = DRAG_NONE;
    orbit.enabled = true;
    renderer.domElement.style.cursor = hovTarget ? 'grab' : '';
    renderer.domElement.releasePointerCapture(e.pointerId);
    if (wasCrate) {
      P.appliedForce = 0;                          // release = no force
      syncAll();
    }
  });

  /* ─── 3D Force Arrows (cylinder + cone) ─── */
  const arrowGroup = new THREE.Group();
  scene.add(arrowGroup);

  function make3DArrow(color) {
    const g = new THREE.Group();
    const shaft = new THREE.Mesh(
      new THREE.CylinderGeometry(0.05, 0.05, 1, 8),
      new THREE.MeshLambertMaterial({ color }));
    shaft.position.y = 0.5;
    g.add(shaft);
    const head = new THREE.Mesh(
      new THREE.ConeGeometry(0.15, 0.4, 8),
      new THREE.MeshLambertMaterial({ color }));
    head.position.y = 1.2;
    g.add(head);
    g.visible = false;
    arrowGroup.add(g);
    return g;
  }

  function setArrow3D(arr, ox, oy, dx, dy, show) {
    const mag = Math.hypot(dx, dy);
    if (!show || mag < 0.05) { arr.visible = false; return; }
    arr.visible = true;
    arr.position.set(ox, oy, 0);
    const angle = Math.atan2(dx, dy);  // rotation around z to point in (dx,dy)
    arr.rotation.set(0, 0, -angle);
    const shaft = arr.children[0], head = arr.children[1];
    shaft.scale.y = mag;
    shaft.position.y = mag / 2;
    head.position.y = mag + 0.2;
  }

  const A = {
    gravity: make3DArrow(0x2255EE),
    normal:  make3DArrow(0xEEEE00),
    applied: make3DArrow(0xF97316),
    friction:make3DArrow(0xEE3333),
    mgSin:   make3DArrow(0x6699FF),
    mgCos:   make3DArrow(0x6699FF),
  };

  /* Sprite labels for forces */
  const labels = {};
  /**
   * Make a text sprite with high-DPI canvas for crisp rendering.
   * Returns a Sprite with default scale ~3×0.75 (override after call).
   */
  function makeSprite(text, color, fontSize) {
    const fs = fontSize || 36;
    const c = document.createElement('canvas');
    c.width = 512; c.height = 128;
    const cx = c.getContext('2d');
    cx.font = `bold ${fs}px 'DM Sans', Arial, sans-serif`;
    cx.fillStyle = color || '#fff';
    cx.textBaseline = 'top';
    cx.fillText(text, 6, 10);
    const tex = new THREE.CanvasTexture(c);
    tex.minFilter = THREE.LinearFilter;
    const mat = new THREE.SpriteMaterial({ map: tex, transparent: true, depthTest: false, sizeAttenuation: true });
    const spr = new THREE.Sprite(mat);
    spr.scale.set(3.0, 0.75, 1);
    return spr;
  }
  labels.gravity  = makeSprite('mg (weight)', '#4477FF', 30);
  labels.gravity.scale.set(2.8, 0.65, 1);
  labels.normal   = makeSprite('N (normal)', '#EEEE00', 30);
  labels.normal.scale.set(2.8, 0.65, 1);
  labels.applied  = makeSprite('F (applied)', '#F97316', 30);
  labels.applied.scale.set(2.8, 0.65, 1);
  labels.friction = makeSprite('f (friction)', '#EE4444', 30);
  labels.friction.scale.set(2.8, 0.65, 1);
  [labels.gravity, labels.normal, labels.applied, labels.friction].forEach(l => {
    l.visible = false; scene.add(l);
  });

  const ASCALE = 0.04; // world units per Newton

  function updateArrows() {
    const f = forces(s, v, P);
    const th = f.slope, ct = Math.cos(th), st = Math.sin(th);
    const ox = crateMesh.position.x, oy = crateMesh.position.y;
    const show = P.showForces;

    // Gravity — straight down
    setArrow3D(A.gravity, ox, oy, 0, -f.Fg * ASCALE, show);
    labels.gravity.visible = show && P.showValues;
    labels.gravity.position.set(ox + 0.6, oy - f.Fg * ASCALE - 0.3, 0.5);

    // Normal — perpendicular outward from surface
    setArrow3D(A.normal, ox, oy, -st * f.N * ASCALE, ct * f.N * ASCALE, show);
    labels.normal.visible = show && P.showValues;
    labels.normal.position.set(ox - st * f.N * ASCALE - 0.5, oy + ct * f.N * ASCALE + 0.3, 0.5);

    // Applied — horizontal
    if (Math.abs(P.appliedForce) > 0.5) {
      setArrow3D(A.applied, ox, oy, P.appliedForce * ASCALE, 0, show);
      labels.applied.visible = show && P.showValues;
      labels.applied.position.set(ox + P.appliedForce * ASCALE + 0.3, oy + 0.3, 0.5);
    } else { A.applied.visible = false; labels.applied.visible = false; }

    // Friction — along surface
    if (Math.abs(f.Ff) > 0.5) {
      const fs = f.Ff >= 0 ? 1 : -1;
      setArrow3D(A.friction, ox, oy, fs * Math.abs(f.Ff) * ASCALE * ct, fs * Math.abs(f.Ff) * ASCALE * st, show);
      labels.friction.visible = show && P.showValues;
      labels.friction.position.set(ox + fs * Math.abs(f.Ff) * ASCALE * ct, oy + fs * Math.abs(f.Ff) * ASCALE * st + 0.4, 0.5);
    } else { A.friction.visible = false; labels.friction.visible = false; }

    // Decomposition
    const sd = show && P.showDecomp && th > 0.02;
    setArrow3D(A.mgSin, ox, oy, -f.Fg_par * ASCALE * ct, -f.Fg_par * ASCALE * st, sd);
    setArrow3D(A.mgCos, ox, oy, st * f.Fg_perp * ASCALE, -ct * f.Fg_perp * ASCALE, sd);

    return f;
  }

  /* ─── Wall-hit flash effect ─── */
  let flashTop = 0, flashLeft = 0;  // countdown timers (seconds)
  const FLASH_DUR = 0.25;           // flash duration
  const FLASH_COLOR = 0xFFAA44;     // bright orange flash

  function updateFlash(dt) {
    if (flashTop > 0) {
      flashTop = Math.max(0, flashTop - dt);
      const intensity = flashTop / FLASH_DUR;
      if (topWallMesh) topWallMesh.material.emissive.setHex(intensity > 0.01 ? FLASH_COLOR : 0x000000);
      if (topWallMesh) topWallMesh.material.emissiveIntensity = intensity * 0.8;
    }
    if (flashLeft > 0) {
      flashLeft = Math.max(0, flashLeft - dt);
      const intensity = flashLeft / FLASH_DUR;
      lw.material.emissive.setHex(intensity > 0.01 ? FLASH_COLOR : 0x000000);
      lw.material.emissiveIntensity = intensity * 0.8;
    }
  }

  /* ─── Physics ─── */
  const DT = 1 / 120;

  function step(dt) {
    const f = forces(s, v, P);

    // Accumulate energy bookkeeping BEFORE velocity update
    frictionHeat += Math.abs(f.Ff) * Math.abs(v) * dt;
    workApplied += f.Fa_along * v * dt;

    v += f.a * dt;
    s += v * dt;

    // Wall collisions — per-wall restitution + flash
    if (s > P.rampLength) {
      const e = Math.max(P.eTop, 0.02);
      const vBefore = v;
      s = P.rampLength;
      if (v > 0) {
        v = -v * e;
        frictionHeat += 0.5 * P.mass * vBefore * vBefore * (1 - e * e);
        if (Math.abs(vBefore) > 0.3) flashTop = FLASH_DUR;  // only flash on real hits
      }
    }
    if (s < GROUND_LEFT) {
      const e = Math.max(P.eLeft, 0.02);
      const vBefore = v;
      s = GROUND_LEFT;
      if (v < 0) {
        v = -v * e;
        frictionHeat += 0.5 * P.mass * vBefore * vBefore * (1 - e * e);
        if (Math.abs(vBefore) > 0.3) flashLeft = FLASH_DUR;
      }
    }
    t += dt;
  }

  /* ─── Tabs + Graphs ─── */
  let tabs = null, timeGraph = null, energyChart = null;

  function setupTabs() {
    if (!tabsEl) return;
    const views = ['sim', 'time', 'energy'];
    tabs = new TabSwitcher(tabsEl, views, {
      canvasArea: el.canvasArea,
      graphCanvases: { time: el.timeCanvas, energy: el.energyCanvas },
    });

    if (el.timeCanvas) {
      timeGraph = new TimeGraph(el.timeCanvas, { window: 12, capacity: 3000 });
      // All 4 topics: position, velocity, acceleration, net force
      timeGraph.addLine(0, 'Position s (m)',        '#8B5CF6');  // purple
      timeGraph.addLine(1, 'Velocity v (m/s)',      '#06B6D4');  // cyan
      timeGraph.addLine(2, 'Acceleration a (m/s²)', '#F59E0B');  // amber
      timeGraph.addLine(3, 'Net Force ΣF (N)',      '#EF4444');  // red
    }
    if (el.energyCanvas) {
      energyChart = new EnergyBar(el.energyCanvas, { window: 12, capacity: 1500 });
    }

    // Re-trigger canvas resize when tab becomes visible (avoids 0×0 buffer)
    tabs.onSwitch(name => {
      requestAnimationFrame(() => {
        if (name === 'time' && timeGraph && timeGraph._resize) timeGraph._resize();
        if (name === 'energy' && energyChart && energyChart._resize) energyChart._resize();
      });
    });
    tabs.restoreFromSession();
  }

  /* ─── Readout ─── */
  function updateReadout(f) {
    if (!readoutEl) return;
    const th = P.angle * Math.PI / 180;
    const h = s >= 0 ? s * Math.sin(th) : 0;
    const KE = 0.5 * P.mass * v * v, PE = P.mass * G * h;
    let status;
    if (Math.abs(f.Fnet) < 0.1 && Math.abs(v) < 0.001) {
      const pct = f.Fs_max > 0 ? (Math.abs(f.Fa_along - f.Fg_par) / f.Fs_max * 100) : 0;
      status = `<span style="color:#22C55E">\u25CF EQUILIBRIUM</span> \u2014 static friction at ${pct.toFixed(0)}% of max`;
    } else {
      const dir = v > 0.01 ? '\u2197 uphill' : v < -0.01 ? '\u2198 downhill' : '';
      status = `<span style="color:#F59E0B">\u25CF MOVING ${dir}</span>`;
    }
    readoutEl.innerHTML =
      `<span>\u03A3F=<b>${f.Fnet.toFixed(1)}</b>N</span>` +
      `<span>a=<b>${f.a.toFixed(2)}</b>m/s\u00B2</span>` +
      `<span>v=<b>${v.toFixed(2)}</b>m/s</span>` +
      `<span>h=<b>${h.toFixed(2)}</b>m</span>` +
      `<span>KE=<b>${KE.toFixed(1)}</b>J</span>` +
      `<span>PE=<b>${PE.toFixed(1)}</b>J</span>` +
      `<span style="color:#F97316">Heat=<b>${frictionHeat.toFixed(1)}</b>J</span>` +
      `<span>Total=<b>${(KE+PE+frictionHeat).toFixed(1)}</b>J</span>` +
      `<span class="ramp-status">${status}</span>`;
  }

  /* ─── Controls ─── */
  function buildControls() {
    if (!sidebarEl) return;
    function fmt(v, stp) { return stp >= 1 ? Math.round(v)+'' : stp >= 0.1 ? v.toFixed(1) : v.toFixed(2); }

    function slider(label, key, min, max, stp, unit) {
      const id = 'ramp_' + key;
      const row = document.createElement('div'); row.className = 'param-row'; row.dataset.param = key;
      row.innerHTML = `<div class="param-header"><span class="param-label">${label}</span>
        <span class="param-value" id="${id}_v">${fmt(P[key],stp)}${unit||''}</span></div>
        <input type="range" class="param-slider" id="${id}" aria-label="${label}"
               min="${min}" max="${max}" step="${stp}" value="${P[key]}">`;
      row.querySelector('input').addEventListener('input', e => {
        P[key] = parseFloat(e.target.value);
        row.querySelector('.param-value').textContent = fmt(P[key],stp) + (unit||'');
        if (key === 'angle' || key === 'rampLength') buildRamp();
        if (key === 'mass') buildCrate();
      });
      return row;
    }

    /* Transport */
    const tr = document.createElement('div'); tr.className = 'lab-transport';
    tr.innerHTML = `<button class="transport-btn" id="rp_play" title="Play/Pause">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path id="rp_icon" d="M6 4h4v16H6zM14 4h4v16h-4z"/></svg>
    </button><button class="transport-btn" id="rp_rst" title="Reset">\u21BA</button>
    <button class="transport-btn" id="rp_step" title="Step">\u25B6|</button>`;
    sidebarEl.appendChild(tr);
    function syncPlayIcon() {
      const icon = document.getElementById('rp_icon');
      if (icon) icon.setAttribute('d',
        running ? 'M6 4h4v16H6zM14 4h4v16h-4z' : 'M8 5v14l11-7z');
    }
    function togglePlay() {
      running = !running; lastTime = null;
      syncPlayIcon();
    }
    function doReset() {
      reset();
      running = true; lastTime = null;
      syncPlayIcon();
    }

    document.getElementById('rp_play').onclick = togglePlay;
    document.getElementById('rp_rst').onclick = doReset;
    document.getElementById('rp_step').onclick = () => {
      if (running) { running = false; syncPlayIcon(); }
      step(DT);
    };

    // Keyboard shortcuts: Space=play/pause, R=reset, →=step
    document.addEventListener('keydown', e => {
      if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT' || e.target.tagName === 'TEXTAREA') return;
      if (e.code === 'Space') { e.preventDefault(); togglePlay(); }
      else if (e.code === 'KeyR') doReset();
      else if (e.code === 'ArrowRight') {
        if (running) { running = false; syncPlayIcon(); }
        step(DT);
      }
    });

    /* ── Object picker ── */
    const objSec = document.createElement('div'); objSec.className = 'lab-params';
    const objRow = document.createElement('div'); objRow.className = 'param-row';
    objRow.innerHTML = `<div class="param-header"><span class="param-label">Object</span></div>
      <select class="param-select" id="rp_obj" aria-label="Select object">
        ${Object.entries(OBJECTS).map(([k, o]) =>
          `<option value="${k}" ${k === P.object ? 'selected' : ''}>${o.icon} ${o.label} (${o.mass} kg)</option>`
        ).join('')}
      </select>
      <div id="rp_obj_info" style="font-size:12px;color:var(--lab-text-muted);margin-top:4px"></div>`;
    objSec.appendChild(objRow);
    sidebarEl.appendChild(objSec);

    function applyObject(key) {
      P.object = key;
      const obj = OBJECTS[key] || OBJECTS.crate_sm;
      if (key !== 'custom') {
        P.mass = obj.mass; P.mu_s = obj.mu_s; P.mu_k = obj.mu_k;
      }
      updateObjInfo();
      syncAll(); buildCrate(); v = 0;
    }
    function updateObjInfo() {
      const obj = OBJECTS[P.object] || OBJECTS.custom;
      const info = document.getElementById('rp_obj_info');
      if (info) info.innerHTML =
        `<span style="display:inline-block;width:12px;height:12px;border-radius:2px;background:#${obj.color.toString(16).padStart(6,'0')};vertical-align:-2px;margin-right:4px"></span>` +
        `${P.mass} kg &nbsp;|&nbsp; \u03BC\u209B=${P.mu_s} &nbsp; \u03BC\u2096=${P.mu_k}`;
    }
    /** When user manually changes mass or friction slider → switch to Custom */
    function switchToCustom() {
      if (P.object === 'custom') return;
      P.object = 'custom';
      // Keep current mass/friction but use Custom's color
      const sel = document.getElementById('rp_obj');
      if (sel) sel.value = 'custom';
      buildCrate();
      updateObjInfo();
    }
    document.getElementById('rp_obj').addEventListener('change', e => applyObject(e.target.value));
    applyObject(P.object);

    /* ── Surface picker ── */
    const surfSec = document.createElement('div'); surfSec.className = 'lab-presets';
    surfSec.innerHTML = `<span style="font-size:.78rem;color:var(--lab-text-muted);min-width:55px">Surface:</span>`;
    Object.entries(SURFACES).forEach(([key, sf]) => {
      const b = document.createElement('button');
      b.className = 'preset-btn' + (key === P.surface ? ' active' : '');
      b.dataset.surface = key;
      b.innerHTML = `<span style="display:inline-block;width:10px;height:10px;border-radius:2px;background:#${sf.color.toString(16).padStart(6,'0')};vertical-align:-1px;margin-right:3px"></span>${sf.label}`;
      b.onclick = () => {
        P.surface = key;
        surfSec.querySelectorAll('.preset-btn').forEach(x => x.classList.remove('active'));
        b.classList.add('active');
        // Override friction if surface has fixed values (ice, rubber, metal)
        if (sf.mu_s !== null) { P.mu_s = sf.mu_s; P.mu_k = sf.mu_k; }
        else {
          // Restore object's friction
          const obj = OBJECTS[P.object] || OBJECTS.crate_sm;
          P.mu_s = obj.mu_s; P.mu_k = obj.mu_k;
        }
        syncAll(); buildRamp(); updateGroundSurface(); updateObjInfo(); v = 0;
      };
      surfSec.appendChild(b);
    });
    sidebarEl.appendChild(surfSec);

    /* Applied Force — prominent */
    const fSec = document.createElement('div'); fSec.className = 'lab-params';
    const fRow = document.createElement('div'); fRow.className = 'param-row';
    fRow.innerHTML = `<div class="param-header">
      <span class="param-label" style="color:#F97316;font-weight:600">Applied Force</span>
      <span class="param-value" id="rf_v">${P.appliedForce} N</span></div>
      <input type="range" class="param-slider" id="rf_sl" min="-500" max="500" step="1" value="${P.appliedForce}" style="accent-color:#F97316">
      <div style="display:flex;flex-wrap:wrap;gap:4px;margin-top:6px">
        <button class="preset-btn" data-f="-200">-200N</button>
        <button class="preset-btn" data-f="-50">-50</button>
        <button class="preset-btn active" data-f="0">0</button>
        <button class="preset-btn" data-f="50">+50</button>
        <button class="preset-btn" data-f="200">+200N</button>
        <button class="preset-btn" data-f="500">+500N</button></div>`;
    fSec.appendChild(fRow);
    sidebarEl.appendChild(fSec);
    const rfSl = document.getElementById('rf_sl'), rfV = document.getElementById('rf_v');
    function syncF() {
      rfV.textContent = P.appliedForce + ' N'; rfSl.value = P.appliedForce;
      fRow.querySelectorAll('[data-f]').forEach(b => b.classList.toggle('active', +b.dataset.f === P.appliedForce));
      if (forceBarEl) { const s2 = forceBarEl.querySelector('#rf2_sl'); if (s2) s2.value = P.appliedForce;
        const n2 = forceBarEl.querySelector('#rf2_num'); if (n2) n2.value = P.appliedForce; }
    }
    rfSl.addEventListener('input', () => { P.appliedForce = +rfSl.value; syncF(); });
    fRow.querySelectorAll('[data-f]').forEach(b => b.addEventListener('click', () => { P.appliedForce = +b.dataset.f; syncF(); }));

    /* Params — mass range covers all objects (piano=250) */
    const ps = document.createElement('div'); ps.className = 'lab-params';
    ps.appendChild(slider('Ramp Angle', 'angle', 0, 60, 0.5, '°'));
    ps.appendChild(slider('Mass', 'mass', 0.5, 300, 0.5, ' kg'));
    ps.appendChild(slider('\u03BC\u209B (static)', 'mu_s', 0, 1.5, 0.01, ''));
    ps.appendChild(slider('\u03BC\u2096 (kinetic)', 'mu_k', 0, 1.0, 0.01, ''));
    ps.appendChild(slider('Ramp Length', 'rampLength', 2, 12, 0.5, ' m'));
    sidebarEl.appendChild(ps);

    // Wire: manually changing mass/friction → switch to Custom
    ['mass', 'mu_s', 'mu_k'].forEach(k => {
      const inp = document.getElementById('ramp_' + k);
      if (inp) inp.addEventListener('input', () => { switchToCustom(); updateObjInfo(); });
    });

    /* Checkboxes */
    const cs = document.createElement('div'); cs.className = 'lab-params';
    [['Show Forces','showForces'],['Show Labels','showValues'],['mg Decomposition','showDecomp']].forEach(([l,k]) => {
      const r = document.createElement('div'); r.className = 'param-row';
      r.innerHTML = `<label class="param-check"><input type="checkbox" ${P[k]?'checked':''} id="rp_${k}"> ${l}</label>`;
      r.querySelector('input').addEventListener('change', e => { P[k] = e.target.checked; });
      cs.appendChild(r);
    });
    sidebarEl.appendChild(cs);

    /* ── Per-wall restitution ── */
    const wallSec = document.createElement('div'); wallSec.className = 'lab-params';
    wallSec.appendChild(slider('Top Wall (e)', 'eTop', 0, 1, 0.05, ''));
    wallSec.appendChild(slider('Left Wall (e)', 'eLeft', 0, 1, 0.05, ''));
    // Quick presets for wall type
    const wallPre = document.createElement('div');
    wallPre.style.cssText = 'display:flex;flex-wrap:wrap;gap:4px;margin-top:4px;';
    [
      { name: 'Brick (both)', eT: 0, eL: 0 },
      { name: 'Bouncy (both)', eT: 0.8, eL: 0.8 },
      { name: 'Top bouncy', eT: 0.8, eL: 0 },
      { name: 'Super elastic', eT: 0.95, eL: 0.95 },
    ].forEach(wp => {
      const b = document.createElement('button'); b.className = 'preset-btn'; b.textContent = wp.name;
      b.onclick = () => { P.eTop = wp.eT; P.eLeft = wp.eL; syncAll(); };
      wallPre.appendChild(b);
    });
    wallSec.appendChild(wallPre);
    sidebarEl.appendChild(wallSec);

    /* ── Scenario presets ── */
    const pre = document.createElement('div'); pre.className = 'lab-presets';
    const presets = [
      { name: 'Frictionless Slide', p: { mu_s: 0, mu_k: 0, angle: 30, surface: 'ice' } },
      { name: 'Critical \u03B8',    p: { angle: 26.57, mu_s: 0.5, mu_k: 0.3, appliedForce: 0 } },
      { name: 'Steep & Icy',        p: { angle: 45, mu_s: 0.05, mu_k: 0.03, surface: 'ice' } },
      { name: 'Rubber Grip',        p: { angle: 50, mu_s: 0.9, mu_k: 0.7, surface: 'rubber' } },
      { name: 'Heavy Piano',        p: { object: 'piano', mass: 250, mu_s: 0.55, mu_k: 0.35, angle: 20 } },
      { name: 'Ice Hockey',         p: { object: 'ice_block', mass: 10, mu_s: 0.05, mu_k: 0.02, angle: 5, appliedForce: 30, surface: 'ice', eTop: 0.7, eLeft: 0.7 } },
      { name: 'Pinball',            p: { angle: 15, mu_s: 0.05, mu_k: 0.02, eTop: 0.9, eLeft: 0.9, appliedForce: 100, surface: 'metal' } },
      { name: 'Push Uphill',        p: { angle: 25, appliedForce: 80 } },
    ];
    presets.forEach(pr => {
      const b = document.createElement('button'); b.className = 'preset-btn'; b.textContent = pr.name;
      b.onclick = () => {
        // Defaults reset everything; pr.p overrides only what it specifies
        const defaults = { angle: 30, mass: 5, mu_s: 0.5, mu_k: 0.3, appliedForce: 0,
          rampLength: 8, eTop: 0, eLeft: 0, object: 'custom', surface: 'wood' };
        Object.assign(P, defaults, pr.p);
        // If preset specifies an object, fill in any missing mass/friction from catalog
        if (pr.p.object && OBJECTS[pr.p.object]) {
          const obj = OBJECTS[pr.p.object];
          if (pr.p.mass  === undefined) P.mass = obj.mass;
          if (pr.p.mu_s  === undefined) P.mu_s = obj.mu_s;
          if (pr.p.mu_k  === undefined) P.mu_k = obj.mu_k;
        }
        // If preset specifies a surface with fixed friction AND preset doesn't explicitly set mu
        if (pr.p.surface && SURFACES[pr.p.surface]) {
          const sf = SURFACES[pr.p.surface];
          if (sf.mu_s !== null && pr.p.mu_s === undefined) { P.mu_s = sf.mu_s; P.mu_k = sf.mu_k; }
        }
        syncAll(); buildRamp(); buildCrate(); updateGroundSurface(); updateObjInfo(); doReset();
      };
      pre.appendChild(b);
    });
    sidebarEl.appendChild(pre);
  }

  function syncAll() {
    // Param sliders
    ['angle','mass','mu_s','mu_k','rampLength','eTop','eLeft'].forEach(k => {
      const inp = document.getElementById('ramp_'+k); if (inp) inp.value = P[k];
      const ve = document.getElementById('ramp_'+k+'_v');
      if (ve) { const stp={angle:0.5,mass:0.5,mu_s:0.01,mu_k:0.01,rampLength:0.5,eTop:0.05,eLeft:0.05}[k]||0.01;
        const u={angle:'°',mass:' kg',rampLength:' m'}[k]||'';
        ve.textContent = (stp>=0.1?P[k].toFixed(1):P[k].toFixed(2))+u; }
    });
    // Checkboxes
    ['showForces','showValues','showDecomp'].forEach(k => { const c=document.getElementById('rp_'+k); if(c) c.checked=P[k]; });
    // Force controls — sidebar slider + quick buttons + below-canvas bar + number input
    const sl=document.getElementById('rf_sl'),vl=document.getElementById('rf_v');
    if(sl) sl.value=P.appliedForce; if(vl) vl.textContent=P.appliedForce+' N';
    document.querySelectorAll('[data-f]').forEach(b =>
      b.classList.toggle('active', parseFloat(b.dataset.f) === P.appliedForce));
    const sl2=document.getElementById('rf2_sl'),num2=document.getElementById('rf2_num');
    if(sl2) sl2.value=P.appliedForce; if(num2) num2.value=P.appliedForce;
    // Object dropdown
    const objSel = document.getElementById('rp_obj');
    if (objSel) objSel.value = P.object;
    // Surface button highlights
    document.querySelectorAll('[data-surface]').forEach(b =>
      b.classList.toggle('active', b.dataset.surface === P.surface));
  }

  /* ─── Force bar below canvas ─── */
  function buildForceBar() {
    if (!forceBarEl) return;
    forceBarEl.innerHTML = `<div class="ramp-force-bar">
      <label class="ramp-force-label">Force</label>
      <input type="range" id="rf2_sl" class="param-slider" min="-500" max="500" step="1" value="${P.appliedForce}" style="flex:1;accent-color:#F97316">
      <input type="number" id="rf2_num" value="${P.appliedForce}" min="-500" max="500" step="5"
        style="width:60px;padding:4px 6px;border:1px solid var(--lab-border);border-radius:6px;background:var(--lab-bg-input);color:var(--lab-text);font:13px 'Fira Code',monospace;text-align:right">
      <span style="font:600 13px 'DM Sans',sans-serif;color:var(--lab-text-sec)">N</span></div>`;
    const sl = forceBarEl.querySelector('#rf2_sl'), num = forceBarEl.querySelector('#rf2_num');
    function sync2() { sl.value=P.appliedForce; num.value=P.appliedForce;
      const m=document.getElementById('rf_sl'),mv=document.getElementById('rf_v');
      if(m) m.value=P.appliedForce; if(mv) mv.textContent=P.appliedForce+' N';
      // Sync quick-pick button highlights
      document.querySelectorAll('[data-f]').forEach(b =>
        b.classList.toggle('active', parseFloat(b.dataset.f) === P.appliedForce)); }
    sl.addEventListener('input', () => { P.appliedForce = parseFloat(sl.value); sync2(); });
    num.addEventListener('input', () => { const val = parseFloat(num.value); if (!isNaN(val)) { P.appliedForce = Math.max(-500, Math.min(500, val)); sync2(); } });
  }

  /* ─── Animation ─── */
  function animate(now) {
    requestAnimationFrame(animate);
    if (running && lastTime !== null) {
      let dt = Math.min((now - lastTime) / 1000, 0.05);
      while (dt >= DT) {
        step(DT);
        // Compute current forces for graph data
        const f = forces(s, v, P);
        const th = P.angle * Math.PI / 180;
        const h = s >= 0 ? s * Math.sin(th) : 0;
        // Feed all 4 topics: position, velocity, acceleration, net force
        if (timeGraph) timeGraph.push(t, new Float64Array([s, v, f.a, f.Fnet]));
        if (energyChart) {
          const KE = 0.5 * P.mass * v * v, PE = P.mass * G * h;
          // Total = KE + PE + frictionHeat: the green line stays flat
          // when no applied force (energy conserved, just converted to heat).
          // The gap between KE+PE stacked area and total = visible heat loss.
          energyChart.pushTime(t, KE, PE, KE + PE + frictionHeat);
        }
        dt -= DT;
      }
    }
    lastTime = running ? now : null;

    syncCrate();
    updateDistLabels();
    updateFlash(1 / 60);  // fade wall flash
    const f = updateArrows();
    updateReadout(f);

    // Render graphs if tab active
    if (timeGraph && el.timeCanvas && el.timeCanvas.style.display !== 'none') timeGraph.render();
    if (energyChart && el.energyCanvas && el.energyCanvas.style.display !== 'none') energyChart.render();

    orbit.update();
    renderer.render(scene, camera);
  }

  function reset() {
    s = -3; v = 0; t = 0; lastTime = null;
    frictionHeat = 0; workApplied = 0;
    flashTop = 0; flashLeft = 0;
    if (timeGraph) timeGraph.clear();
    if (energyChart) energyChart.reset();
  }

  /* ─── Resize ─── */
  const ro = new ResizeObserver(() => {
    const w = canvasWrap.clientWidth;
    if (w === 0) return;
    const h = canvasWrap.clientHeight || Math.round(w * 0.55);
    camera.aspect = w / h;
    // Adaptive FOV: wider on narrow screens so scene stays visible
    camera.fov = w < 500 ? 65 : w < 800 ? 55 : 50;
    camera.updateProjectionMatrix();
    renderer.setSize(w, h);
  });
  ro.observe(canvasWrap);

  /* ─── Init ─── */
  buildControls();
  buildForceBar();
  buildCrate();
  buildRamp();
  buildRuler();
  updateGroundSurface();
  setupTabs();
  requestAnimationFrame(animate);

  return { reset, destroy() { ro.disconnect(); renderer.dispose(); orbit.dispose(); } };
}
