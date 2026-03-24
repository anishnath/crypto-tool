/**
 * Center of Mass: Person on a Floating Raft — Three.js 3D
 *
 * Person walks on a raft floating on water. No external horizontal forces
 * → center of mass stays fixed.
 *
 * Constraint: mₚ·(raftX + personOnRaft) + mᵣ·raftX = (mₚ+mᵣ)·x_cm
 *           → raftX = x_cm_initial − mₚ·personOnRaft / (mₚ+mᵣ)
 *
 * No ODE needed — position computed directly from constraint each frame.
 */

import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { TabSwitcher } from '../ui/tabs.js';
import { TimeGraph } from '../canvas/time-graph.js';

/* ═══════════════════════ PHYSICS ═══════════════════════ */

function computeRaftX(personOnRaft, P) {
  // CM stays at x=0 (initial position)
  // raftX = -mₚ·personOnRaft / (mₚ + mᵣ)
  return -P.massPerson * personOnRaft / (P.massPerson + P.massRaft);
}

function computeCM(personOnRaft, raftX, P) {
  const xPerson = raftX + personOnRaft;
  return (P.massPerson * xPerson + P.massRaft * raftX) / (P.massPerson + P.massRaft);
}

/* ═══════════════════ THREE.JS SCENE ═══════════════════ */

export function createRaftSim(el) {
  const canvasWrap = el.simContainer;
  const sidebarEl  = el.sidebar;
  const readoutEl  = el.readout;
  const tabsEl     = el.tabs;

  /* ─── State ─── */
  const P = {
    massPerson: 70, massRaft: 200,
    walkSpeed: 1.0, raftLength: 6,
    showCM: true, showArrows: true,
  };
  let personOnRaft = 0;   // position on raft (0=center, +right, −left)
  let walkDir = 1;        // +1 or −1
  let t = 0, running = true, lastTime = null, simSpeed = 1;

  /* ─── Scene ─── */
  const scene = new THREE.Scene();
  scene.background = new THREE.Color(0x87BBDD);
  scene.fog = new THREE.Fog(0x87BBDD, 25, 55);

  const W = canvasWrap.clientWidth || 700;
  const H = Math.max(canvasWrap.clientHeight || 0, 450);
  const isMobile = W < 600;
  const camera = new THREE.PerspectiveCamera(isMobile ? 55 : 45, W / H, 0.1, 100);
  camera.position.set(0, 4, isMobile ? 10 : 12);

  const renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(W, H);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;
  canvasWrap.appendChild(renderer.domElement);

  const orbit = new OrbitControls(camera, renderer.domElement);
  orbit.target.set(0, 0.5, 0);
  orbit.enableDamping = true;
  orbit.dampingFactor = 0.08;
  orbit.update();

  /* ─── Lighting ─── */
  scene.add(new THREE.AmbientLight(0xFFFFFF, 0.55));
  const sun = new THREE.DirectionalLight(0xFFF8EE, 1.0);
  sun.position.set(5, 12, 6); sun.castShadow = true;
  sun.shadow.mapSize.set(1024, 1024);
  sun.shadow.camera.left = -10; sun.shadow.camera.right = 10;
  sun.shadow.camera.top = 8; sun.shadow.camera.bottom = -4;
  scene.add(sun);
  const fill = new THREE.DirectionalLight(0xAABBDD, 0.3);
  fill.position.set(-4, 3, -5);
  scene.add(fill);

  /* ─── Sprite helpers ─── */
  function drawOutlinedText(cx, text, x, y, color, fs) {
    cx.font = `bold ${fs}px 'DM Sans', Arial, sans-serif`;
    cx.textBaseline = 'top';
    // Dark outline for readability on light sky background
    cx.strokeStyle = 'rgba(0,0,0,0.5)';
    cx.lineWidth = 5; cx.lineJoin = 'round';
    cx.strokeText(text, x, y);
    // White inner stroke for crispness
    cx.strokeStyle = 'rgba(255,255,255,0.9)';
    cx.lineWidth = 2;
    cx.strokeText(text, x, y);
    cx.fillStyle = color || '#222';
    cx.fillText(text, x, y);
  }
  function makeSprite(text, color, fontSize) {
    const c = document.createElement('canvas'); c.width = 512; c.height = 128;
    drawOutlinedText(c.getContext('2d'), text, 6, 10, color, fontSize || 28);
    const tex = new THREE.CanvasTexture(c); tex.minFilter = THREE.LinearFilter;
    const spr = new THREE.Sprite(new THREE.SpriteMaterial({ map: tex, transparent: true, depthTest: false }));
    spr.scale.set(2.8, 0.65, 1);
    return spr;
  }
  function updateSpriteText(spr, text, color) {
    const tex = spr.material.map, c = tex.image, cx = c.getContext('2d');
    cx.clearRect(0, 0, c.width, c.height);
    drawOutlinedText(cx, text, 6, 10, color, 24);
    tex.needsUpdate = true;
  }

  /* ─── Water ─── */
  const waterGeo = new THREE.PlaneGeometry(30, 12, 60, 24);
  const waterMat = new THREE.MeshLambertMaterial({
    color: 0x2288BB, transparent: true, opacity: 0.7, side: THREE.DoubleSide });
  const water = new THREE.Mesh(waterGeo, waterMat);
  water.rotation.x = -Math.PI / 2;
  water.position.y = 0;
  water.receiveShadow = true;
  scene.add(water);

  // Store original Y positions for wave animation
  const waterVerts = waterGeo.attributes.position;
  const waterOrigY = new Float32Array(waterVerts.count);
  for (let i = 0; i < waterVerts.count; i++) waterOrigY[i] = waterVerts.getY(i);

  function animateWater() {
    for (let i = 0; i < waterVerts.count; i++) {
      const x = waterVerts.getX(i), z = waterVerts.getZ(i);
      waterVerts.setY(i, waterOrigY[i] + Math.sin(x * 0.5 + t * 2) * 0.04 + Math.cos(z * 0.7 + t * 1.5) * 0.03);
    }
    waterVerts.needsUpdate = true;
  }

  /* ─── Raft ─── */
  let raftMesh, raftEdges;
  const raftH = 0.18, raftD = 2.0;  // height, depth(z)

  function buildRaft() {
    if (raftMesh) { scene.remove(raftMesh); raftMesh.geometry.dispose(); }
    if (raftEdges) { scene.remove(raftEdges); raftEdges.geometry.dispose(); }
    const geo = new THREE.BoxGeometry(P.raftLength, raftH, raftD);
    raftMesh = new THREE.Mesh(geo, new THREE.MeshLambertMaterial({ color: 0xA07030 }));
    raftMesh.castShadow = true; raftMesh.receiveShadow = true;
    scene.add(raftMesh);
    raftEdges = new THREE.LineSegments(
      new THREE.EdgesGeometry(geo),
      new THREE.LineBasicMaterial({ color: 0x704820 }));
    scene.add(raftEdges);
    // Wood plank lines
    for (let i = -P.raftLength / 2 + 0.8; i < P.raftLength / 2; i += 0.8) {
      const line = new THREE.Mesh(
        new THREE.BoxGeometry(0.03, raftH + 0.01, raftD + 0.01),
        new THREE.MeshLambertMaterial({ color: 0x886020 }));
      line.position.set(i, 0, 0);
      raftMesh.add(line);
    }
  }

  /* ─── Person (capsule body + sphere head + legs) ─── */
  const personGroup = new THREE.Group();
  scene.add(personGroup);
  const personMat = new THREE.MeshLambertMaterial({ color: 0xDD6633 });
  const personH = 1.4;

  // Body
  const body = new THREE.Mesh(new THREE.CylinderGeometry(0.18, 0.15, 0.7, 8), personMat);
  body.position.y = 0.7; personGroup.add(body);
  // Head
  const head = new THREE.Mesh(new THREE.SphereGeometry(0.18, 8, 8), new THREE.MeshLambertMaterial({ color: 0xEEBB88 }));
  head.position.y = 1.25; personGroup.add(head);
  // Legs
  const legMat = new THREE.MeshLambertMaterial({ color: 0x334466 });
  const legL = new THREE.Mesh(new THREE.CylinderGeometry(0.07, 0.07, 0.5, 6), legMat);
  legL.position.set(-0.1, 0.25, 0); personGroup.add(legL);
  const legR = new THREE.Mesh(new THREE.CylinderGeometry(0.07, 0.07, 0.5, 6), legMat);
  legR.position.set(0.1, 0.25, 0); personGroup.add(legR);
  personGroup.castShadow = true;

  /* ─── CM marker (fixed on water surface) ─── */
  const cmMarker = new THREE.Mesh(
    new THREE.ConeGeometry(0.15, 0.3, 4),
    new THREE.MeshLambertMaterial({ color: 0xEF4444 }));
  cmMarker.rotation.x = Math.PI;  // point down → diamond shape pointing up
  cmMarker.position.set(0, 0.2, 0);
  scene.add(cmMarker);

  const cmLine = new THREE.Line(
    new THREE.BufferGeometry().setFromPoints([
      new THREE.Vector3(0, -0.5, 0), new THREE.Vector3(0, 2.5, 0)]),
    new THREE.LineDashedMaterial({ color: 0xEF4444, dashSize: 0.12, gapSize: 0.08 }));
  cmLine.computeLineDistances();
  cmLine.position.set(0, 0, 0);
  scene.add(cmLine);

  /* ─── HTML HUD overlay (always readable, zoom-independent) ─── */
  const hud = document.createElement('div');
  hud.style.cssText = `position:absolute;top:0;left:0;right:0;bottom:0;pointer-events:none;overflow:hidden;`;
  canvasWrap.style.position = 'relative';
  canvasWrap.appendChild(hud);

  function makeHudLabel(color, bgColor) {
    const el = document.createElement('div');
    el.style.cssText = `position:absolute;padding:4px 10px;border-radius:6px;
      font:700 14px 'DM Sans',sans-serif;color:${color};
      background:${bgColor};border:1px solid ${color}33;
      white-space:nowrap;transform:translate(-50%,-100%);
      pointer-events:none;text-shadow:0 1px 2px rgba(0,0,0,0.15);`;
    hud.appendChild(el);
    return el;
  }

  const hudPerson = makeHudLabel('#CC3300', 'rgba(255,255,255,0.92)');
  const hudRaft   = makeHudLabel('#5A3A10', 'rgba(255,255,255,0.92)');
  const hudCM     = makeHudLabel('#CC1111', 'rgba(255,230,230,0.95)');

  /** Project a 3D world point to 2D screen pixel on the HUD. Returns null if behind camera. */
  function projectToHud(wx, wy, wz) {
    const v = new THREE.Vector3(wx, wy, wz || 0);
    v.project(camera);
    if (v.z > 1) return null;  // behind camera
    const cw = canvasWrap.clientWidth, ch = canvasWrap.clientHeight;
    return {
      x: Math.max(10, Math.min(cw - 10, (v.x * 0.5 + 0.5) * cw)),
      y: Math.max(10, Math.min(ch - 10, (-v.y * 0.5 + 0.5) * ch)),
    };
  }

  /* ─── Sync positions each frame ─── */
  function syncScene() {
    const raftX = computeRaftX(personOnRaft, P);
    const raftY = 0.08 + Math.sin(t * 1.2) * 0.015;  // gentle bob

    // Raft
    raftMesh.position.set(raftX, raftY, 0);
    raftEdges.position.copy(raftMesh.position);
    raftEdges.rotation.copy(raftMesh.rotation);

    // Person on raft (world position = raftX + personOnRaft)
    const personWorldX = raftX + personOnRaft;
    personGroup.position.set(personWorldX, raftY + raftH / 2, 0);

    // Walking leg animation
    const legSwing = Math.sin(t * P.walkSpeed * 6) * 0.25 * walkDir;
    legL.rotation.x = running ? legSwing : 0;
    legR.rotation.x = running ? -legSwing : 0;
    // Face person in walk direction
    personGroup.rotation.y = walkDir > 0 ? 0 : Math.PI;

    // CM marker (stays at x=0 always)
    const cm = computeCM(personOnRaft, raftX, P);
    cmMarker.position.set(cm, 0.2, 0);
    cmLine.position.set(cm, 0, 0);
    cmMarker.visible = P.showCM;
    cmLine.visible = P.showCM;

    // HUD labels (HTML overlay — always readable)
    function positionHud(el, pos, text) {
      if (!pos) { el.style.display = 'none'; return; }
      el.style.left = pos.x + 'px'; el.style.top = pos.y + 'px';
      el.textContent = text;
      el.style.display = '';
    }

    if (P.showArrows) {
      positionHud(hudPerson, projectToHud(personWorldX, personH + raftY + raftH / 2 + 0.4),
        '\uD83E\uDDCD Person x = ' + personWorldX.toFixed(2) + ' m');
      positionHud(hudRaft, projectToHud(raftX, -0.3),
        '\uD83D\uDEA3 Raft x = ' + raftX.toFixed(2) + ' m');
    } else {
      hudPerson.style.display = 'none';
      hudRaft.style.display = 'none';
    }

    if (P.showCM) {
      positionHud(hudCM, projectToHud(cm, 2.2),
        '\u25C6 Center of Mass \u2014 stays here!');
    } else {
      hudCM.style.display = 'none';
    }
  }

  /* ─── Physics step ─── */
  function step(dt) {
    // Person walks on raft at constant speed
    personOnRaft += walkDir * P.walkSpeed * dt;

    // Reverse at raft edges
    const edge = P.raftLength / 2 - 0.3;
    if (personOnRaft > edge) { personOnRaft = edge; walkDir = -1; }
    if (personOnRaft < -edge) { personOnRaft = -edge; walkDir = 1; }

    t += dt;
  }

  /* ─── Readout ─── */
  function updateReadout() {
    if (!readoutEl) return;
    const raftX = computeRaftX(personOnRaft, P);
    const personWorldX = raftX + personOnRaft;
    // World-frame velocities
    const rVel = running ? -P.massPerson * walkDir * P.walkSpeed / (P.massPerson + P.massRaft) : 0;
    const pVelWorld = running ? walkDir * P.walkSpeed + rVel : 0;
    const pMomentum = P.massPerson * pVelWorld;
    const rMomentum = P.massRaft * rVel;
    const ratio = P.massPerson / P.massRaft;

    readoutEl.innerHTML =
      // Positions (change every frame — interesting)
      `<span style="color:#992200">Person: x=<b>${personWorldX.toFixed(2)}</b>m &nbsp; v=<b>${pVelWorld.toFixed(2)}</b>m/s &nbsp; p=<b>${pMomentum.toFixed(1)}</b></span>` +
      `<span style="color:#5A3A10">Raft: x=<b>${raftX.toFixed(2)}</b>m &nbsp; v=<b>${rVel.toFixed(2)}</b>m/s &nbsp; p=<b>${rMomentum.toFixed(1)}</b></span>` +
      // The key insight: mass ratio determines displacement ratio
      `<span>Mass ratio: <b>m\u209A/m\u1D63 = ${ratio.toFixed(2)}</b></span>` +
      `<span>|Δraft/Δperson| = <b>${(Math.abs(personWorldX) > 0.01 ? Math.abs(raftX / personWorldX).toFixed(2) : '\u2014')}</b> <span style="color:${Math.abs(Math.abs(raftX / (personWorldX || 1)) - ratio) < 0.05 ? '#22C55E' : '#888'}">${Math.abs(personWorldX) > 0.01 ? '= mass ratio \u2713' : ''}</span></span>` +
      `<span class="ramp-status"><span style="color:#EF4444">\u25C6 CM fixed at origin &nbsp;|&nbsp;</span><span style="color:#22C55E">p\u209A + p\u1D63 = ${(pMomentum + rMomentum).toFixed(3)} \u2248 0 \u2713</span></span>`;
  }

  /* ─── Tabs + Graphs ─── */
  let tabs = null, timeGraph = null;

  function setupTabs() {
    if (!tabsEl) return;
    const views = ['sim', 'time'];
    const graphCanvases = { time: el.timeCanvas };
    tabs = new TabSwitcher(tabsEl, views, { canvasArea: el.canvasArea, graphCanvases });

    if (el.timeCanvas) {
      timeGraph = new TimeGraph(el.timeCanvas, { window: 15, capacity: 3000 });
      timeGraph.addLine(0, 'Person x (m)', '#DD6633');
      timeGraph.addLine(1, 'Raft x (m)', '#704820');
      timeGraph.addLine(2, 'CM x (m)', '#EF4444');
    }

    tabs.onSwitch(name => {
      requestAnimationFrame(() => {
        if (name === 'time' && timeGraph && timeGraph._resize) timeGraph._resize();
      });
    });
    tabs.restoreFromSession();
  }

  /* ─── Controls ─── */
  let doReset, onKeyDown;

  function buildControls() {
    if (!sidebarEl) return;
    sidebarEl.innerHTML = '';

    function fmt(val, stp) { return stp >= 1 ? Math.round(val) + '' : val.toFixed(1); }
    function slider(label, key, min, max, stp, unit) {
      const id = 'raft_' + key;
      const row = document.createElement('div'); row.className = 'param-row';
      row.innerHTML = `<div class="param-header"><span class="param-label">${label}</span>
        <span class="param-value" id="${id}_v">${fmt(P[key],stp)}${unit||''}</span></div>
        <input type="range" class="param-slider" id="${id}" aria-label="${label}"
               min="${min}" max="${max}" step="${stp}" value="${P[key]}">`;
      row.querySelector('input').addEventListener('input', e => {
        P[key] = parseFloat(e.target.value);
        row.querySelector('.param-value').textContent = fmt(P[key], stp) + (unit || '');
        if (key === 'raftLength') {
          buildRaft();
          const edge = P.raftLength / 2 - 0.3;
          personOnRaft = Math.max(-edge, Math.min(edge, personOnRaft));
        }
      });
      return row;
    }

    /* Transport */
    const tr = document.createElement('div'); tr.className = 'lab-transport';
    tr.innerHTML = `<button class="transport-btn" id="raft_play" title="Play/Pause">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path id="raft_icon" d="M6 4h4v16H6zM14 4h4v16h-4z"/></svg>
    </button><button class="transport-btn" id="raft_rst" title="Reset">\u21BA</button>
    <button class="transport-btn" id="raft_step" title="Step">\u25B6|</button>`;
    sidebarEl.appendChild(tr);

    function syncPlayIcon() {
      const icon = document.getElementById('raft_icon');
      if (icon) icon.setAttribute('d', running ? 'M6 4h4v16H6zM14 4h4v16h-4z' : 'M8 5v14l11-7z');
    }
    function togglePlay() { running = !running; lastTime = null; syncPlayIcon(); }
    doReset = function() { reset(); running = true; lastTime = null; syncPlayIcon(); };

    document.getElementById('raft_play').onclick = togglePlay;
    document.getElementById('raft_rst').onclick = doReset;
    document.getElementById('raft_step').onclick = () => { if (running) { running = false; syncPlayIcon(); } step(1 / 60); };

    onKeyDown = e => {
      if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT') return;
      if (e.code === 'Space') { e.preventDefault(); togglePlay(); }
      else if (e.code === 'KeyR') doReset();
      else if (e.code === 'ArrowRight') { if (running) { running = false; syncPlayIcon(); } step(1 / 60); }
    };
    document.addEventListener('keydown', onKeyDown);

    /* Params */
    const ps = document.createElement('div'); ps.className = 'lab-params';
    ps.appendChild(slider('Person Mass', 'massPerson', 30, 150, 5, ' kg'));
    ps.appendChild(slider('Raft Mass', 'massRaft', 50, 500, 10, ' kg'));
    ps.appendChild(slider('Walk Speed', 'walkSpeed', 0.3, 3, 0.1, ' m/s'));
    ps.appendChild(slider('Raft Length', 'raftLength', 3, 10, 0.5, ' m'));
    sidebarEl.appendChild(ps);

    /* Checkboxes */
    const cs = document.createElement('div'); cs.className = 'lab-params';
    [['Show CM Marker', 'showCM'], ['Show Labels', 'showArrows']].forEach(([l, k]) => {
      const r = document.createElement('div'); r.className = 'param-row';
      r.innerHTML = `<label class="param-check"><input type="checkbox" ${P[k] ? 'checked' : ''} id="raft_${k}"> ${l}</label>`;
      r.querySelector('input').addEventListener('change', e => { P[k] = e.target.checked; });
      cs.appendChild(r);
    });
    sidebarEl.appendChild(cs);

    /* Presets */
    const presets = [
      { name: 'Default', p: { massPerson: 70, massRaft: 200, walkSpeed: 1.0, raftLength: 6 } },
      { name: 'Equal Masses', p: { massPerson: 100, massRaft: 100, walkSpeed: 1.0, raftLength: 6 } },
      { name: 'Heavy Raft', p: { massPerson: 70, massRaft: 500, walkSpeed: 1.0, raftLength: 8 } },
      { name: 'Light Raft', p: { massPerson: 100, massRaft: 50, walkSpeed: 1.0, raftLength: 5 } },
      { name: 'Fast Walk', p: { massPerson: 80, massRaft: 150, walkSpeed: 2.5, raftLength: 6 } },
    ];
    const pre = document.createElement('div'); pre.className = 'lab-presets';
    presets.forEach(pr => {
      const b = document.createElement('button'); b.className = 'preset-btn'; b.textContent = pr.name;
      b.onclick = () => { Object.assign(P, pr.p); syncAll(); buildRaft(); doReset(); };
      pre.appendChild(b);
    });
    sidebarEl.appendChild(pre);

    /* Settings */
    const settings = document.createElement('details'); settings.className = 'lab-engine-settings';
    settings.innerHTML = '<summary>Settings</summary>';
    const setBody = document.createElement('div'); setBody.className = 'engine-body';
    const speedRow = document.createElement('div'); speedRow.className = 'engine-row';
    speedRow.innerHTML = `<span class="param-label">Speed</span>
      <select class="param-select" id="raft_speed"><option value="0.5">0.5\u00D7</option>
      <option value="1" selected>1\u00D7</option><option value="2">2\u00D7</option></select>`;
    setBody.appendChild(speedRow);
    speedRow.querySelector('select').addEventListener('change', e => { simSpeed = parseFloat(e.target.value); });
    const shareBtn = document.createElement('button'); shareBtn.className = 'lab-share-btn'; shareBtn.textContent = 'Share Link';
    shareBtn.addEventListener('click', () => {
      const pairs = Object.entries(P).filter(([, v]) => typeof v !== 'boolean')
        .map(([k, v]) => encodeURIComponent(k) + '=' + encodeURIComponent(v));
      const url = location.href.split('#')[0] + '#' + pairs.join('&');
      navigator.clipboard.writeText(url).then(() => { shareBtn.textContent = 'Copied!'; setTimeout(() => shareBtn.textContent = 'Share Link', 2000); })
        .catch(() => prompt('Copy:', url));
    });
    setBody.appendChild(shareBtn);
    settings.appendChild(setBody);
    sidebarEl.appendChild(settings);
  }

  function syncAll() {
    ['massPerson', 'massRaft', 'walkSpeed', 'raftLength'].forEach(k => {
      const inp = document.getElementById('raft_' + k); if (inp) inp.value = P[k];
      const ve = document.getElementById('raft_' + k + '_v');
      if (ve) {
        const stp = { massPerson: 5, massRaft: 10, walkSpeed: 0.1, raftLength: 0.5 }[k] || 1;
        const u = { massPerson: ' kg', massRaft: ' kg', walkSpeed: ' m/s', raftLength: ' m' }[k] || '';
        ve.textContent = (stp >= 1 ? Math.round(P[k]) + '' : P[k].toFixed(1)) + u;
      }
    });
  }

  /* ─── Animation ─── */
  const DT = 1 / 120;

  let animId;
  function animate(now) {
    animId = requestAnimationFrame(animate);
    if (running && lastTime !== null) {
      let dt = Math.min((now - lastTime) / 1000, 0.05) * simSpeed;
      while (dt >= DT) {
        step(DT);
        if (timeGraph) {
          const raftX = computeRaftX(personOnRaft, P);
          const personWorldX = raftX + personOnRaft;
          const cm = computeCM(personOnRaft, raftX, P);
          timeGraph.push(t, new Float64Array([personWorldX, raftX, cm]));
        }
        dt -= DT;
      }
    }
    lastTime = running ? now : null;

    animateWater();
    syncScene();
    updateReadout();

    if (timeGraph && el.timeCanvas && el.timeCanvas.style.display !== 'none') timeGraph.render();

    orbit.update();
    renderer.render(scene, camera);
  }

  function reset() {
    personOnRaft = 0; walkDir = 1; t = 0; lastTime = null;
    if (timeGraph) timeGraph.clear();
  }

  /* ─── Resize ─── */
  const ro = new ResizeObserver(() => {
    const w = canvasWrap.clientWidth; if (w === 0) return;
    const h = canvasWrap.clientHeight || Math.round(w * 0.55);
    camera.aspect = w / h;
    camera.fov = w < 500 ? 60 : w < 800 ? 50 : 45;
    camera.updateProjectionMatrix();
    renderer.setSize(w, h);
  });
  ro.observe(canvasWrap);

  /* ─── Init ─── */
  buildControls();
  buildRaft();
  setupTabs();
  animId = requestAnimationFrame(animate);

  return { reset, destroy() {
    cancelAnimationFrame(animId);
    document.removeEventListener('keydown', onKeyDown);
    if (hud.parentNode) hud.parentNode.removeChild(hud);
    ro.disconnect(); renderer.dispose(); orbit.dispose();
  } };
}
