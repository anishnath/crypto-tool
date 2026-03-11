/**
 * Ray Optics Simulator — UI Controller
 * ES5 IIFE, depends on RayScene + RayEngine + RayRender
 *
 * Features: click-to-place construction, control-point handles, undo/redo,
 * ghost preview, drag tooltip, context menu, JSON import/export.
 *
 * Exports: window.RayUI
 */
;(function (win) {
  'use strict';

  var S = win.RayScene;
  var E = win.RayEngine;
  var R = win.RayRender;

  var scene = null;
  var canvas = null;
  var tracedPaths = null;
  var selectedId = null;
  var hoveredObjId = null;
  var hoveredHandle = null;
  var rafPending = false;

  var viewport = { ox: 0, oy: 0, scale: 1 };

  // Interaction state
  var dragging = null;
  var panning = null;
  var constructing = null;

  // Ghost preview (cursor position during pending construction)
  var ghostPos = null;

  // Drag tooltip
  var dragTooltip = null; // { cx, cy, text }

  // Context menu
  var ctxMenu = null;  // DOM element
  var ctxObjId = null;

  /* ---- DOM refs ---- */
  var els = {};

  /* ================================================================
   *  UNDO / REDO
   * ================================================================ */

  var undoStack = [];
  var redoStack = [];
  var MAX_UNDO = 40;

  function saveUndo() {
    if (!scene) return;
    var snapshot = serializeObjects();
    // Don't push if identical to top
    if (undoStack.length > 0 && undoStack[undoStack.length - 1] === snapshot) return;
    undoStack.push(snapshot);
    if (undoStack.length > MAX_UNDO) undoStack.shift();
    redoStack = [];
    updateUndoButtons();
  }

  function undo() {
    if (undoStack.length === 0) return;
    redoStack.push(serializeObjects());
    restoreObjects(undoStack.pop());
    updateUndoButtons();
  }

  function redo() {
    if (redoStack.length === 0) return;
    undoStack.push(serializeObjects());
    restoreObjects(redoStack.pop());
    updateUndoButtons();
  }

  function serializeObjects() {
    var arr = [];
    for (var i = 0; i < scene.objects.length; i++) arr.push(scene.objects[i].toJSON());
    return JSON.stringify(arr);
  }

  function restoreObjects(json) {
    var arr = JSON.parse(json);
    scene.objects = [];
    for (var i = 0; i < arr.length; i++) {
      var obj = S.createObject(arr[i]);
      if (obj) scene.objects.push(obj);
    }
    selectedId = null;
    updateObjBar();
    refreshAll();
  }

  function updateUndoButtons() {
    if (els.undoBtn) els.undoBtn.disabled = undoStack.length === 0;
    if (els.redoBtn) els.redoBtn.disabled = redoStack.length === 0;
  }

  /* ================================================================
   *  ENDPOINT MATH
   * ================================================================ */

  function getEndpoints(obj) {
    if (obj.getEndpoints) return obj.getEndpoints();
    var prop = (obj.type === 'IdealLens' || obj.type === 'IdealMirror' || obj.type === 'ParabolicMirror') ? 'height' : 'length';
    var half = (obj[prop] || 100) / 2;
    var sa = Math.sin(obj.angle), ca = Math.cos(obj.angle);
    return {
      p1: { x: obj.x + sa * half, y: obj.y - ca * half },
      p2: { x: obj.x - sa * half, y: obj.y + ca * half }
    };
  }

  function setFromEndpoints(obj, p1x, p1y, p2x, p2y) {
    var prop = (obj.type === 'IdealLens' || obj.type === 'IdealMirror' || obj.type === 'ParabolicMirror') ? 'height' : 'length';
    obj.x = (p1x + p2x) / 2;
    obj.y = (p1y + p2y) / 2;
    var dx = p1x - p2x, dy = p1y - p2y;
    var len = Math.sqrt(dx * dx + dy * dy);
    obj[prop] = Math.max(20, len);
    if (len > 0.1) obj.angle = Math.atan2(dx / len, -dy / len);
  }

  function getBeamEndpoints(obj) {
    var half = (obj.width || 40) / 2;
    var px = -Math.sin(obj.angle), py = Math.cos(obj.angle);
    return {
      p1: { x: obj.x + px * half, y: obj.y + py * half },
      p2: { x: obj.x - px * half, y: obj.y - py * half }
    };
  }

  function setBeamFromEndpoints(obj, p1x, p1y, p2x, p2y) {
    obj.x = (p1x + p2x) / 2;
    obj.y = (p1y + p2y) / 2;
    var dx = p1x - p2x, dy = p1y - p2y;
    var len = Math.sqrt(dx * dx + dy * dy);
    obj.width = Math.max(10, len);
    if (len > 0.1) obj.angle = Math.atan2(-dx / len, dy / len);
  }

  /* ================================================================
   *  HANDLE SYSTEM
   * ================================================================ */

  function getHandles(obj) {
    if (!obj) return [];
    var handles = [];
    var t = obj.type;

    if (t === 'FlatMirror' || t === 'Blocker' || t === 'BeamSplitter' ||
        t === 'DiffractionGrating' || t === 'Aperture' || t === 'ParabolicMirror') {
      var ep = getEndpoints(obj);
      handles.push({ id: 'p1', x: ep.p1.x, y: ep.p1.y, style: 'square', cursor: 'grab' });
      handles.push({ id: 'p2', x: ep.p2.x, y: ep.p2.y, style: 'square', cursor: 'grab' });
      if (t === 'ParabolicMirror') {
        handles.push({ id: 'focal', x: obj.x + Math.cos(obj.angle) * obj.focalLength, y: obj.y + Math.sin(obj.angle) * obj.focalLength, style: 'diamond', cursor: 'crosshair' });
      }
      if (t === 'Aperture') {
        var oh = (obj.opening || 40) / 2, sa2 = Math.sin(obj.angle), ca2 = Math.cos(obj.angle);
        handles.push({ id: 'o1', x: obj.x + sa2 * oh, y: obj.y - ca2 * oh, style: 'circle', cursor: 'pointer' });
      }
    }
    else if (t === 'IdealLens' || t === 'IdealMirror') {
      var iep = getEndpoints(obj);
      handles.push({ id: 'p1', x: iep.p1.x, y: iep.p1.y, style: 'square', cursor: 'grab' });
      handles.push({ id: 'p2', x: iep.p2.x, y: iep.p2.y, style: 'square', cursor: 'grab' });
      var ic = Math.cos(obj.angle), is = Math.sin(obj.angle);
      handles.push({ id: 'f1', x: obj.x + ic * obj.focalLength, y: obj.y + is * obj.focalLength, style: 'diamond', cursor: 'crosshair' });
      handles.push({ id: 'f2', x: obj.x - ic * obj.focalLength, y: obj.y - is * obj.focalLength, style: 'diamond', cursor: 'crosshair' });
    }
    else if (t === 'ParallelBeam') {
      var bep = getBeamEndpoints(obj);
      handles.push({ id: 'w1', x: bep.p1.x, y: bep.p1.y, style: 'square', cursor: 'grab' });
      handles.push({ id: 'w2', x: bep.p2.x, y: bep.p2.y, style: 'square', cursor: 'grab' });
      handles.push({ id: 'dir', x: obj.x + Math.cos(obj.angle) * 40, y: obj.y + Math.sin(obj.angle) * 40, style: 'circle', cursor: 'crosshair' });
    }
    else if (t === 'PointSource') {
      handles.push({ id: 'dir', x: obj.x + Math.cos(obj.angle) * 35, y: obj.y + Math.sin(obj.angle) * 35, style: 'circle', cursor: 'crosshair' });
    }
    else if (t === 'SingleRay') {
      handles.push({ id: 'dir', x: obj.x + Math.cos(obj.angle) * 45, y: obj.y + Math.sin(obj.angle) * 45, style: 'circle', cursor: 'crosshair' });
    }
    else if (t === 'CurvedMirror') {
      var arc = obj.getArc();
      handles.push({ id: 'a1', x: arc.center.x + arc.radius * Math.cos(arc.startAngle), y: arc.center.y + arc.radius * Math.sin(arc.startAngle), style: 'square', cursor: 'grab' });
      handles.push({ id: 'a2', x: arc.center.x + arc.radius * Math.cos(arc.endAngle), y: arc.center.y + arc.radius * Math.sin(arc.endAngle), style: 'square', cursor: 'grab' });
      handles.push({ id: 'center', x: arc.center.x, y: arc.center.y, style: 'diamond', cursor: 'move' });
    }
    else if (t === 'CircleLens' || t === 'CircleBlocker' || t === 'GrinLens') {
      handles.push({ id: 'edge', x: obj.x + (obj.radius || 50), y: obj.y, style: 'square', cursor: 'ew-resize' });
    }
    else if (t === 'Observer') {
      handles.push({ id: 'edge', x: obj.x + (obj.pupilRadius || 20), y: obj.y, style: 'square', cursor: 'ew-resize' });
      handles.push({ id: 'dir', x: obj.x + Math.cos(obj.angle) * 35, y: obj.y + Math.sin(obj.angle) * 35, style: 'circle', cursor: 'crosshair' });
    }
    else if (t === 'GlassSlab') {
      var corners = obj.getCorners();
      handles.push({ id: 'c0', x: corners[0].x, y: corners[0].y, style: 'square', cursor: 'nwse-resize' });
      handles.push({ id: 'c2', x: corners[2].x, y: corners[2].y, style: 'square', cursor: 'nwse-resize' });
    }
    else if (t === 'Prism') {
      var verts = obj.getVertices();
      for (var vi = 0; vi < verts.length; vi++)
        handles.push({ id: 'v' + vi, x: verts[vi].x, y: verts[vi].y, style: 'square', cursor: 'grab' });
    }
    else if (t === 'SphericalLens') {
      var sa3 = Math.sin(obj.angle), ca3 = Math.cos(obj.angle), sr = (obj.diameter || 60) / 2;
      handles.push({ id: 'edge', x: obj.x + sa3 * sr, y: obj.y - ca3 * sr, style: 'square', cursor: 'grab' });
    }

    return handles;
  }

  function applyHandleDrag(obj, handleId, wx, wy, shiftKey) {
    var t = obj.type;

    if (handleId === 'dir') {
      obj.angle = Math.atan2(wy - obj.y, wx - obj.x);
      if (shiftKey) obj.angle = snap15(obj.angle);
      setTooltipAngle(obj.angle);
      return true;
    }

    if (handleId === 'focal' || handleId === 'f1' || handleId === 'f2') {
      obj.focalLength = Math.max(5, dist(obj.x, obj.y, wx, wy));
      setTooltipVal('f', obj.focalLength);
      return true;
    }

    if ((handleId === 'p1' || handleId === 'p2') && (
      t === 'FlatMirror' || t === 'Blocker' || t === 'BeamSplitter' || t === 'DiffractionGrating' ||
      t === 'Aperture' || t === 'ParabolicMirror' || t === 'IdealLens' || t === 'IdealMirror'
    )) {
      var ep = getEndpoints(obj);
      var fixed = (handleId === 'p1') ? ep.p2 : ep.p1;
      if (shiftKey) { var sn = snapToDir(wx - fixed.x, wy - fixed.y); wx = fixed.x + sn.x; wy = fixed.y + sn.y; }
      if (handleId === 'p1') setFromEndpoints(obj, wx, wy, fixed.x, fixed.y);
      else setFromEndpoints(obj, fixed.x, fixed.y, wx, wy);
      var lprop = (t === 'IdealLens' || t === 'IdealMirror' || t === 'ParabolicMirror') ? 'height' : 'length';
      setTooltipMulti('L=' + obj[lprop].toFixed(0) + '  \u03B8=' + deg(obj.angle));
      return true;
    }

    if ((handleId === 'w1' || handleId === 'w2') && t === 'ParallelBeam') {
      var bep = getBeamEndpoints(obj);
      var bfixed = (handleId === 'w1') ? bep.p2 : bep.p1;
      if (shiftKey) { var sn2 = snapToDir(wx - bfixed.x, wy - bfixed.y); wx = bfixed.x + sn2.x; wy = bfixed.y + sn2.y; }
      if (handleId === 'w1') setBeamFromEndpoints(obj, wx, wy, bfixed.x, bfixed.y);
      else setBeamFromEndpoints(obj, bfixed.x, bfixed.y, wx, wy);
      setTooltipMulti('w=' + obj.width.toFixed(0) + '  \u03B8=' + deg(obj.angle));
      return true;
    }

    if (handleId === 'o1' && t === 'Aperture') {
      var sa = Math.sin(obj.angle), ca = Math.cos(obj.angle);
      var proj = Math.abs((wx - obj.x) * sa + (wy - obj.y) * (-ca));
      obj.opening = Math.max(4, Math.min(obj.length - 4, proj * 2));
      setTooltipVal('open', obj.opening);
      return true;
    }

    if (handleId === 'edge') {
      var er = dist(obj.x, obj.y, wx, wy);
      if (t === 'Observer') { obj.pupilRadius = Math.max(5, er); setTooltipVal('r', er); return true; }
      if (t === 'SphericalLens') { obj.diameter = Math.max(10, er * 2); setTooltipVal('dia', obj.diameter); return true; }
      if (t === 'CircleLens' || t === 'CircleBlocker' || t === 'GrinLens') {
        obj.radius = Math.max(10, er); setTooltipVal('r', er); return true;
      }
    }

    if ((handleId === 'c0' || handleId === 'c2') && t === 'GlassSlab') {
      var cos2 = Math.cos(-obj.angle), sin2 = Math.sin(-obj.angle);
      var ldx = wx - obj.x, ldy = wy - obj.y;
      obj.width = Math.max(15, Math.abs(ldx * cos2 - ldy * sin2) * 2);
      obj.height = Math.max(15, Math.abs(ldx * sin2 + ldy * cos2) * 2);
      setTooltipMulti(obj.width.toFixed(0) + '\u00D7' + obj.height.toFixed(0));
      return true;
    }

    if (handleId.charAt(0) === 'v' && t === 'Prism') {
      obj.sideLength = Math.max(20, dist(obj.x, obj.y, wx, wy) * 2.2);
      setTooltipVal('side', obj.sideLength);
      return true;
    }

    if (t === 'CurvedMirror') {
      if (handleId === 'center') { obj.radius = Math.max(20, dist(obj.x, obj.y, wx, wy)); setTooltipVal('R', obj.radius); return true; }
      if (handleId === 'a1' || handleId === 'a2') {
        var arc = obj.getArc();
        var diff = normAngle(Math.atan2(wy - arc.center.y, wx - arc.center.x) - (obj.angle + Math.PI));
        obj.arcAngle = Math.max(5, Math.min(170, Math.abs(diff) * 2 * 180 / Math.PI));
        setTooltipVal('arc', obj.arcAngle);
        return true;
      }
    }

    return false;
  }

  /* ---- Tooltip helpers ---- */
  function setTooltipAngle(a) { setTooltipMulti('\u03B8=' + deg(a)); }
  function setTooltipVal(label, v) { setTooltipMulti(label + '=' + v.toFixed(1)); }
  function setTooltipMulti(text) {
    if (!dragTooltip) dragTooltip = { cx: 0, cy: 0, text: '' };
    dragTooltip.text = text;
  }
  function deg(a) { return (a * 180 / Math.PI).toFixed(1) + '\u00B0'; }

  /* ---- Snap helpers ---- */
  function snap15(a) { var s = Math.PI / 12; return Math.round(a / s) * s; }
  function snapToDir(dx, dy) {
    var a = snap15(Math.atan2(dy, dx)), d = Math.sqrt(dx * dx + dy * dy);
    return { x: Math.cos(a) * d, y: Math.sin(a) * d };
  }
  function normAngle(a) { while (a > Math.PI) a -= 2 * Math.PI; while (a < -Math.PI) a += 2 * Math.PI; return a; }
  function dist(x1, y1, x2, y2) { var dx = x2 - x1, dy = y2 - y1; return Math.sqrt(dx * dx + dy * dy); }
  function ptSegDist(px, py, ax, ay, bx, by) {
    var dx = bx - ax, dy = by - ay, len2 = dx * dx + dy * dy;
    if (len2 === 0) return dist(px, py, ax, ay);
    var t = Math.max(0, Math.min(1, ((px - ax) * dx + (py - ay) * dy) / len2));
    return dist(px, py, ax + t * dx, ay + t * dy);
  }

  /* ================================================================
   *  CONSTRUCTION
   * ================================================================ */

  var DEFAULTS = {
    FlatMirror: { length: 100 }, CurvedMirror: { radius: 120, arcAngle: 50 },
    ParabolicMirror: { height: 100, focalLength: 50 },
    GlassSlab: { width: 120, height: 60 }, Prism: { sideLength: 80 },
    CircleLens: { radius: 50 }, SphericalLens: { diameter: 60 },
    IdealLens: { height: 100, focalLength: 80 }, IdealMirror: { height: 100, focalLength: 80 },
    BeamSplitter: { length: 80 }, DiffractionGrating: { length: 80 },
    GrinLens: { radius: 50 }, Blocker: { length: 80 },
    Aperture: { length: 100, opening: 40 }, CircleBlocker: { radius: 40 },
    Observer: { pupilRadius: 30 },
    PointSource: { numRays: 36 }, ParallelBeam: { width: 80 }, SingleRay: {}
  };

  var CONSTRUCT_MODE = {
    FlatMirror: 'line', Blocker: 'line', BeamSplitter: 'line', DiffractionGrating: 'line',
    Aperture: 'line', ParabolicMirror: 'line', IdealLens: 'line', IdealMirror: 'line',
    CurvedMirror: 'line', ParallelBeam: 'beam',
    GlassSlab: 'rect', Prism: 'radius',
    CircleLens: 'radius', CircleBlocker: 'radius', GrinLens: 'radius',
    SphericalLens: 'radius', Observer: 'radius',
    PointSource: 'instant', SingleRay: 'instant'
  };

  function constructMouseDown(type, wx, wy) {
    var mode = CONSTRUCT_MODE[type] || 'instant';
    if (mode === 'instant') {
      saveUndo();
      var obj = createWithDefaults(type, wx, wy);
      scene.addObject(obj);
      selectedId = obj.id;
      constructing = null;
      ghostPos = null;
      canvas.style.cursor = '';
      updateObjBar();
      refreshAll();
      return;
    }
    constructing = { type: type, anchorX: wx, anchorY: wy, obj: null, mode: mode };
  }

  function constructMouseMove(wx, wy, shiftKey) {
    if (!constructing || constructing.anchorX === undefined) return;
    var ax = constructing.anchorX, ay = constructing.anchorY;
    var d = dist(ax, ay, wx, wy);
    if (d < 3 / viewport.scale) return;

    if (!constructing.obj) {
      saveUndo();
      var obj = createWithDefaults(constructing.type, ax, ay);
      scene.addObject(obj);
      selectedId = obj.id;
      constructing.obj = obj;
    }

    var o = constructing.obj;
    var mode = constructing.mode;

    if (mode === 'line') {
      var p1x = ax, p1y = ay, p2x = wx, p2y = wy;
      if (shiftKey) { var sn = snapToDir(p2x - p1x, p2y - p1y); p2x = p1x + sn.x; p2y = p1y + sn.y; }
      setFromEndpoints(o, p1x, p1y, p2x, p2y);
      var clprop = (o.type === 'IdealLens' || o.type === 'IdealMirror' || o.type === 'ParabolicMirror') ? 'height' : 'length';
      setTooltipMulti('L=' + o[clprop].toFixed(0) + '  \u03B8=' + deg(o.angle));
    }
    else if (mode === 'beam') {
      var bp1x = ax, bp1y = ay, bp2x = wx, bp2y = wy;
      if (shiftKey) { var sn2 = snapToDir(bp2x - bp1x, bp2y - bp1y); bp2x = bp1x + sn2.x; bp2y = bp1y + sn2.y; }
      setBeamFromEndpoints(o, bp1x, bp1y, bp2x, bp2y);
      setTooltipMulti('w=' + o.width.toFixed(0));
    }
    else if (mode === 'radius') {
      o.x = ax; o.y = ay;
      var r = Math.max(10, d);
      if (o.type === 'Prism') { o.sideLength = r * 2; setTooltipVal('side', o.sideLength); }
      else if (o.type === 'Observer') { o.pupilRadius = r; setTooltipVal('r', r); }
      else if (o.type === 'SphericalLens') { o.diameter = r * 2; setTooltipVal('dia', o.diameter); }
      else { o.radius = r; setTooltipVal('r', r); }
    }
    else if (mode === 'rect') {
      o.x = (ax + wx) / 2; o.y = (ay + wy) / 2;
      o.width = Math.max(15, Math.abs(wx - ax));
      o.height = Math.max(15, Math.abs(wy - ay));
      if (shiftKey) o.angle = snap15(Math.atan2(wy - ay, wx - ax));
      setTooltipMulti(o.width.toFixed(0) + '\u00D7' + o.height.toFixed(0));
    }
    refreshAll();
  }

  function constructMouseUp() {
    if (!constructing) return;
    if (!constructing.obj) {
      saveUndo();
      var obj = createWithDefaults(constructing.type, constructing.anchorX, constructing.anchorY);
      scene.addObject(obj);
      selectedId = obj.id;
    }
    constructing = null;
    ghostPos = null;
    dragTooltip = null;
    canvas.style.cursor = '';
    updateObjBar();
    refreshAll();
  }

  function createWithDefaults(type, x, y) {
    var opts = { type: type, x: x, y: y, angle: 0 };
    var defs = DEFAULTS[type] || {};
    for (var k in defs) { if (defs.hasOwnProperty(k)) opts[k] = defs[k]; }
    return S.createObject(opts);
  }

  function cancelConstruction() {
    if (constructing && constructing.obj) {
      scene.removeObject(constructing.obj.id);
      if (selectedId === constructing.obj.id) selectedId = null;
    }
    constructing = null;
    ghostPos = null;
    dragTooltip = null;
    if (canvas) canvas.style.cursor = '';
    updateObjBar();
    scheduleRepaint();
  }

  /* ================================================================
   *  CONTEXT MENU
   * ================================================================ */

  function initContextMenu() {
    ctxMenu = document.getElementById('rs-ctx-menu');
    if (!ctxMenu) return;
    var items = ctxMenu.querySelectorAll('.rs-ctx-item');
    for (var i = 0; i < items.length; i++) {
      items[i].addEventListener('click', onCtxAction);
    }
    document.addEventListener('click', function () { hideCtxMenu(); });
  }

  function showCtxMenu(cx, cy, objId) {
    if (!ctxMenu) return;
    ctxObjId = objId;
    var wrap = document.getElementById('rs-canvas-wrap');
    if (!wrap) return;
    var rect = wrap.getBoundingClientRect();
    var x = cx, y = cy;
    // Clamp to canvas bounds
    if (x + 170 > rect.width) x = rect.width - 170;
    if (y + 140 > rect.height) y = rect.height - 140;
    ctxMenu.style.left = x + 'px';
    ctxMenu.style.top = y + 'px';
    ctxMenu.style.display = 'block';

    // Update lock label
    var obj = scene.findObject(objId);
    var lockItem = ctxMenu.querySelector('[data-action="lock"]');
    if (lockItem && obj) lockItem.textContent = obj.locked ? 'Unlock' : 'Lock';
  }

  function hideCtxMenu() {
    if (ctxMenu) ctxMenu.style.display = 'none';
    ctxObjId = null;
  }

  function onCtxAction(e) {
    e.stopPropagation();
    var action = e.currentTarget.getAttribute('data-action');
    if (!ctxObjId || !scene) { hideCtxMenu(); return; }

    var obj = scene.findObject(ctxObjId);
    if (!obj) { hideCtxMenu(); return; }

    if (action === 'delete') {
      saveUndo();
      scene.removeObject(ctxObjId);
      if (selectedId === ctxObjId) selectedId = null;
      updateObjBar();
      refreshAll();
    }
    else if (action === 'duplicate') {
      selectedId = ctxObjId;
      duplicateSelected();
    }
    else if (action === 'lock') {
      obj.locked = !obj.locked;
      scheduleRepaint();
    }
    else if (action === 'front') {
      saveUndo();
      var idx = scene.objects.indexOf(obj);
      if (idx >= 0) {
        scene.objects.splice(idx, 1);
        scene.objects.push(obj);
      }
      scheduleRepaint();
    }

    hideCtxMenu();
  }

  /* ================================================================
   *  JSON IMPORT / EXPORT
   * ================================================================ */

  function exportJSON() {
    var data = {
      version: 1,
      tool: '8gwifi.org/physics/ray-optics-simulator.jsp',
      contact: 'https://x.com/anish2good',
      exportedAt: new Date().toISOString(),
      scene: { width: scene.width, height: scene.height, rayMode: scene.rayMode,
        fresnelEnabled: scene.fresnelEnabled, backgroundN: scene.backgroundN,
        showGrid: scene.showGrid, gridSize: scene.gridSize },
      objects: []
    };
    for (var i = 0; i < scene.objects.length; i++) data.objects.push(scene.objects[i].toJSON());
    var json = JSON.stringify(data, null, 2);
    var blob = new Blob([json], { type: 'application/json' });
    var a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = 'ray-optics-scene.json';
    a.click();
    URL.revokeObjectURL(a.href);
  }

  function importJSON(file) {
    var reader = new FileReader();
    reader.onload = function (e) {
      try {
        var data = JSON.parse(e.target.result);
        if (!data.objects) throw new Error('No objects');
        saveUndo();
        // Restore scene properties
        if (data.scene) {
          scene.width = data.scene.width || scene.width;
          scene.height = data.scene.height || scene.height;
          scene.rayMode = data.scene.rayMode || 'rays';
          scene.fresnelEnabled = !!data.scene.fresnelEnabled;
          scene.backgroundN = data.scene.backgroundN || 1;
          scene.showGrid = !!data.scene.showGrid;
          scene.gridSize = data.scene.gridSize || 50;
        }
        scene.objects = [];
        for (var i = 0; i < data.objects.length; i++) {
          var obj = S.createObject(data.objects[i]);
          if (obj) scene.objects.push(obj);
        }
        selectedId = null;
        fitViewport();
        syncSettingsUI();
        updateObjBar();
        refreshAll();
      } catch (err) {
        console.warn('Import failed:', err);
        alert('Invalid scene file.');
      }
    };
    reader.readAsText(file);
  }

  /* ================================================================
   *  HIT TESTING
   * ================================================================ */

  var HANDLE_HIT_R = 12;
  var OBJ_HIT_R = 14;

  function hitTestHandle(wx, wy) {
    if (!selectedId) return null;
    var obj = scene.findObject(selectedId);
    if (!obj) return null;
    var handles = getHandles(obj);
    var bestD = HANDLE_HIT_R / viewport.scale, bestH = null;
    for (var i = 0; i < handles.length; i++) {
      var d = dist(wx, wy, handles[i].x, handles[i].y);
      if (d < bestD) { bestD = d; bestH = handles[i]; }
    }
    return bestH;
  }

  function hitTestObject(wx, wy) {
    var bestId = null, bestDist = OBJ_HIT_R / viewport.scale;
    for (var i = scene.objects.length - 1; i >= 0; i--) {
      var d = objDist(scene.objects[i], wx, wy);
      if (d < bestDist) { bestDist = d; bestId = scene.objects[i].id; }
    }
    return bestId;
  }

  function objDist(obj, wx, wy) {
    var t = obj.type;
    if (t === 'PointSource' || t === 'SingleRay') return dist(obj.x, obj.y, wx, wy);
    if (t === 'CircleLens' || t === 'CircleBlocker' || t === 'GrinLens') {
      var cd = dist(obj.x, obj.y, wx, wy); return Math.min(cd, Math.abs(cd - obj.radius));
    }
    if (t === 'Observer') {
      var od = dist(obj.x, obj.y, wx, wy); return Math.min(od, Math.abs(od - obj.pupilRadius));
    }
    if (obj.getEdges) {
      var edges = obj.getEdges(), minD = Infinity;
      for (var i = 0; i < edges.length; i++) {
        minD = Math.min(minD, ptSegDist(wx, wy, edges[i].p1.x, edges[i].p1.y, edges[i].p2.x, edges[i].p2.y));
      }
      return minD;
    }
    if (t === 'ParallelBeam') {
      var bep = getBeamEndpoints(obj);
      return ptSegDist(wx, wy, bep.p1.x, bep.p1.y, bep.p2.x, bep.p2.y);
    }
    return dist(obj.x, obj.y, wx, wy);
  }

  /* ================================================================
   *  INIT
   * ================================================================ */

  function init(opts) {
    opts = opts || {};
    canvas = document.getElementById(opts.canvasId || 'rs-canvas');

    els.presetSel   = document.getElementById('rs-preset-select');
    els.addSel      = document.getElementById('rs-add-select');
    els.removeBtn   = document.getElementById('rs-remove-btn');
    els.clearBtn    = document.getElementById('rs-clear-btn');
    els.objBar      = document.getElementById('rs-objbar');
    els.rayModeSel  = document.getElementById('rs-ray-mode');
    els.fresnelChk  = document.getElementById('rs-fresnel');
    els.gridChk     = document.getElementById('rs-grid');
    els.gridSizeInp = document.getElementById('rs-grid-size');
    els.bgNInp      = document.getElementById('rs-bg-n');
    els.exportPng   = document.getElementById('rs-export-png');
    els.shareBtn    = document.getElementById('rs-share-btn');
    els.undoBtn     = document.getElementById('rs-undo-btn');
    els.redoBtn     = document.getElementById('rs-redo-btn');
    els.exportJson  = document.getElementById('rs-export-json');
    els.importBtn   = document.getElementById('rs-import-btn');
    els.importFile  = document.getElementById('rs-import-file');

    initContextMenu();
    loadPreset(opts.preset || 'Plane Mirror');
    wireEvents();
    fitViewport();
    refreshAll();
    updateUndoButtons();
  }

  function wireEvents() {
    if (els.presetSel) els.presetSel.addEventListener('change', function () { if (this.value) { cancelConstruction(); loadPreset(this.value); } });
    if (els.addSel) els.addSel.addEventListener('change', function () {
      var type = this.value; if (!type) return;
      cancelConstruction(); selectedId = null;
      constructing = { pendingType: type };
      canvas.style.cursor = 'crosshair';
      this.value = '';
      updateObjBar(); scheduleRepaint();
    });
    if (els.removeBtn) els.removeBtn.addEventListener('click', removeSelected);
    if (els.clearBtn) els.clearBtn.addEventListener('click', function () { saveUndo(); scene.objects = []; selectedId = null; cancelConstruction(); updateObjBar(); refreshAll(); });

    // Scene settings
    if (els.rayModeSel) els.rayModeSel.addEventListener('change', function () { if (scene) { scene.rayMode = this.value; refreshAll(); } });
    if (els.fresnelChk) els.fresnelChk.addEventListener('change', function () { if (scene) { scene.fresnelEnabled = this.checked; refreshAll(); } });
    if (els.gridChk) els.gridChk.addEventListener('change', function () { if (scene) { scene.showGrid = this.checked; scheduleRepaint(); } });
    if (els.gridSizeInp) els.gridSizeInp.addEventListener('input', function () { var v = parseInt(this.value, 10); if (scene && v > 0) { scene.gridSize = v; scheduleRepaint(); } });
    if (els.bgNInp) els.bgNInp.addEventListener('input', function () { var v = parseFloat(this.value); if (scene && v >= 1) { scene.backgroundN = v; refreshAll(); } });

    // Undo / redo
    if (els.undoBtn) els.undoBtn.addEventListener('click', undo);
    if (els.redoBtn) els.redoBtn.addEventListener('click', redo);

    // Export / import
    if (els.exportPng) els.exportPng.addEventListener('click', exportPng);
    if (els.shareBtn) els.shareBtn.addEventListener('click', shareScene);
    if (els.exportJson) els.exportJson.addEventListener('click', exportJSON);
    if (els.importBtn) els.importBtn.addEventListener('click', function () { if (els.importFile) els.importFile.click(); });
    if (els.importFile) els.importFile.addEventListener('change', function () { if (this.files.length > 0) { importJSON(this.files[0]); this.value = ''; } });

    // Canvas events
    if (canvas) {
      canvas.addEventListener('mousedown', onMouseDown);
      canvas.addEventListener('mousemove', onMouseMove);
      canvas.addEventListener('mouseup', onMouseUp);
      canvas.addEventListener('wheel', onWheel, { passive: false });
      canvas.addEventListener('contextmenu', onContextMenu);
      canvas.addEventListener('touchstart', onTouchStart, { passive: false });
      canvas.addEventListener('touchmove', onTouchMove, { passive: false });
      canvas.addEventListener('touchend', onTouchEnd);
    }

    document.addEventListener('keydown', onKeyDown);
    window.addEventListener('resize', function () { scheduleRepaint(); });
  }

  function onKeyDown(e) {
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT' || e.target.tagName === 'TEXTAREA') return;
    if (e.key === 'Delete' || e.key === 'Backspace') { e.preventDefault(); removeSelected(); }
    if (e.key === 'Escape') { if (constructing) cancelConstruction(); else { selectedId = null; updateObjBar(); scheduleRepaint(); } }
    if ((e.ctrlKey || e.metaKey) && e.key === 'd') { e.preventDefault(); duplicateSelected(); }
    if ((e.ctrlKey || e.metaKey) && e.key === 'z' && !e.shiftKey) { e.preventDefault(); undo(); }
    if ((e.ctrlKey || e.metaKey) && e.key === 'z' && e.shiftKey) { e.preventDefault(); redo(); }
    if ((e.ctrlKey || e.metaKey) && e.key === 'y') { e.preventDefault(); redo(); }
  }

  /* ================================================================
   *  MOUSE INTERACTION
   * ================================================================ */

  function getMousePos(e) {
    var rect = canvas.getBoundingClientRect();
    return { x: e.clientX - rect.left, y: e.clientY - rect.top };
  }

  function onContextMenu(e) {
    e.preventDefault();
    if (constructing) { cancelConstruction(); return; }
    var mp = getMousePos(e);
    var wp = canvasToWorld(mp.x, mp.y);
    var hitId = hitTestObject(wp.x, wp.y);
    if (hitId) {
      selectedId = hitId;
      updateObjBar();
      scheduleRepaint();
      showCtxMenu(mp.x, mp.y, hitId);
    }
  }

  function onMouseDown(e) {
    hideCtxMenu();
    if (e.button === 2) return;
    var mp = getMousePos(e);
    var wp = canvasToWorld(mp.x, mp.y);

    if (constructing && constructing.pendingType) {
      constructMouseDown(constructing.pendingType, wp.x, wp.y);
      e.preventDefault();
      return;
    }

    var hHit = hitTestHandle(wp.x, wp.y);
    if (hHit) {
      saveUndo();
      dragging = { id: selectedId, handleId: hHit.id, lastMX: mp.x, lastMY: mp.y };
      e.preventDefault();
      return;
    }

    var hitId = hitTestObject(wp.x, wp.y);
    if (hitId) {
      selectedId = hitId;
      var hitObj = scene.findObject(hitId);
      if ((e.ctrlKey || e.metaKey) && hitObj) { duplicateSelected(); hitObj = scene.findObject(selectedId); }
      saveUndo();
      dragging = { id: selectedId, handleId: null, origObj: cloneObj(hitObj), startWX: wp.x, startWY: wp.y, lastMX: mp.x, lastMY: mp.y };
      updateObjBar();
      scheduleRepaint();
      e.preventDefault();
      return;
    }

    selectedId = null;
    updateObjBar();
    panning = { startMX: mp.x, startMY: mp.y, startOX: viewport.ox, startOY: viewport.oy };
    scheduleRepaint();
  }

  function onMouseMove(e) {
    var mp = getMousePos(e);
    var wp = canvasToWorld(mp.x, mp.y);

    // Ghost preview during pending construction
    if (constructing && constructing.pendingType && !constructing.anchorX) {
      ghostPos = { x: wp.x, y: wp.y, type: constructing.pendingType };
      scheduleRepaint();
    }

    if (constructing && constructing.anchorX !== undefined) {
      constructMouseMove(wp.x, wp.y, e.shiftKey);
      if (dragTooltip) { dragTooltip.cx = mp.x; dragTooltip.cy = mp.y; }
      e.preventDefault();
      return;
    }

    if (dragging && dragging.handleId) {
      var obj = scene.findObject(dragging.id);
      if (obj) {
        applyHandleDrag(obj, dragging.handleId, wp.x, wp.y, e.shiftKey);
        if (dragTooltip) { dragTooltip.cx = mp.x; dragTooltip.cy = mp.y; }
        updateObjBar();
        refreshAll();
      }
      e.preventDefault();
      return;
    }

    if (dragging && !dragging.handleId) {
      var bObj = scene.findObject(dragging.id);
      if (bObj && !bObj.locked && dragging.origObj) {
        var ddx = wp.x - dragging.startWX, ddy = wp.y - dragging.startWY;
        if (e.shiftKey) { if (Math.abs(ddx) > Math.abs(ddy)) ddy = 0; else ddx = 0; }
        bObj.x = dragging.origObj.x + ddx;
        bObj.y = dragging.origObj.y + ddy;
        if (scene.showGrid && scene.gridSize > 0) {
          bObj.x = Math.round(bObj.x / scene.gridSize) * scene.gridSize;
          bObj.y = Math.round(bObj.y / scene.gridSize) * scene.gridSize;
        }
        dragTooltip = { cx: mp.x, cy: mp.y, text: 'x=' + bObj.x.toFixed(0) + '  y=' + bObj.y.toFixed(0) };
        updateObjBar();
        refreshAll();
      }
      e.preventDefault();
      return;
    }

    if (panning) {
      viewport.ox = panning.startOX - (mp.x - panning.startMX) / viewport.scale;
      viewport.oy = panning.startOY - (mp.y - panning.startMY) / viewport.scale;
      scheduleRepaint();
      e.preventDefault();
      return;
    }

    updateHoverCursor(wp.x, wp.y);
  }

  function onMouseUp() {
    if (constructing && constructing.anchorX !== undefined) { constructMouseUp(); return; }
    dragging = null;
    panning = null;
    dragTooltip = null;
    scheduleRepaint();
  }

  function onWheel(e) {
    e.preventDefault();
    var mp = getMousePos(e);
    var wp = canvasToWorld(mp.x, mp.y);
    var ns = Math.max(0.1, Math.min(10, viewport.scale * (e.deltaY < 0 ? 1.1 : 0.9)));
    viewport.ox = wp.x - mp.x / ns;
    viewport.oy = wp.y - mp.y / ns;
    viewport.scale = ns;
    scheduleRepaint();
  }

  function updateHoverCursor(wx, wy) {
    if (constructing && constructing.pendingType) { canvas.style.cursor = 'crosshair'; return; }
    var hHit = hitTestHandle(wx, wy);
    if (hHit) { canvas.style.cursor = hHit.cursor || 'pointer'; hoveredHandle = { objId: selectedId, handleId: hHit.id }; hoveredObjId = null; return; }
    hoveredHandle = null;
    var hitId = hitTestObject(wx, wy);
    if (hitId) { canvas.style.cursor = 'move'; hoveredObjId = hitId; return; }
    hoveredObjId = null;
    canvas.style.cursor = '';
  }

  /* ---- Touch ---- */
  function onTouchStart(e) { if (e.touches.length === 1) { var t = e.touches[0]; onMouseDown({ button: 0, clientX: t.clientX, clientY: t.clientY, shiftKey: false, ctrlKey: false, metaKey: false, preventDefault: function () { e.preventDefault(); } }); } }
  function onTouchMove(e) { if (e.touches.length === 1) { var t = e.touches[0]; onMouseMove({ clientX: t.clientX, clientY: t.clientY, shiftKey: false, preventDefault: function () { e.preventDefault(); } }); } }
  function onTouchEnd() { onMouseUp(); }

  /* ================================================================
   *  HELPERS
   * ================================================================ */

  function cloneObj(obj) {
    if (!obj) return null;
    var c = {};
    for (var k in obj) { if (obj.hasOwnProperty(k) && typeof obj[k] !== 'function') c[k] = obj[k]; }
    return c;
  }

  function removeSelected() {
    if (!selectedId || !scene) return;
    saveUndo();
    scene.removeObject(selectedId);
    selectedId = null;
    updateObjBar();
    refreshAll();
  }

  function duplicateSelected() {
    if (!selectedId || !scene) return;
    var obj = scene.findObject(selectedId);
    if (!obj) return;
    saveUndo();
    var json = cloneObj(obj);
    delete json.id;
    json.x += 30 / viewport.scale;
    json.y += 30 / viewport.scale;
    var newObj = S.createObject(json);
    if (newObj) { scene.addObject(newObj); selectedId = newObj.id; updateObjBar(); refreshAll(); }
  }

  function exportPng() {
    // Draw branding watermark before export
    var ctx = canvas.getContext('2d');
    var dpr = window.devicePixelRatio || 1;
    ctx.save();
    ctx.scale(dpr, dpr);
    var cw = canvas.offsetWidth;
    var ch = canvas.offsetHeight;
    ctx.font = '10px system-ui, sans-serif';
    ctx.textAlign = 'right';
    ctx.textBaseline = 'bottom';
    ctx.fillStyle = 'rgba(150,150,150,0.6)';
    ctx.fillText('8gwifi.org/physics/ray-optics-simulator.jsp  |  @anish2good', cw - 8, ch - 6);
    ctx.restore();

    var TU = win.ToolUtils;
    if (TU && TU.downloadCanvasAsImage) TU.downloadCanvasAsImage(canvas, 'ray-optics.png', { toolName: 'Ray Optics Simulator', showToast: true, showSupportPopup: true });
    else { var a = document.createElement('a'); a.href = canvas.toDataURL('image/png'); a.download = 'ray-optics.png'; a.click(); }

    // Repaint to remove watermark from live canvas
    repaint();
  }

  function shareScene() {
    if (!scene) return;
    var TU = win.ToolUtils;
    if (TU && TU.shareResult) TU.shareResult(JSON.stringify({ objects: scene.objects.map(function (o) { return o.toJSON(); }), props: { rayMode: scene.rayMode, fresnelEnabled: scene.fresnelEnabled, backgroundN: scene.backgroundN } }), { paramName: 'scene', encode: true, copyToClipboard: true, showSupportPopup: true, toolName: 'Ray Optics Simulator' });
  }

  /* ================================================================
   *  OBJECT BAR
   * ================================================================ */

  var PROP_MAP = {
    PointSource: ['numRays','brightness','wavelength','spreadAngle'],
    ParallelBeam: ['numRays','width','brightness','wavelength'],
    SingleRay: ['brightness','wavelength'],
    FlatMirror: ['length'], CurvedMirror: ['radius','arcAngle'],
    ParabolicMirror: ['focalLength','height'],
    GlassSlab: ['width','height','refractiveIndex','cauchyB'],
    Prism: ['sideLength','apexAngle','refractiveIndex','cauchyB'],
    CircleLens: ['radius','refractiveIndex','cauchyB'],
    SphericalLens: ['radius1','radius2','thickness','diameter','refractiveIndex','cauchyB'],
    IdealLens: ['focalLength','height'], IdealMirror: ['focalLength','height'],
    BeamSplitter: ['length','transmissionRatio','dichroic','dichroicMinWL','dichroicMaxWL'],
    DiffractionGrating: ['length','lineDensity'],
    GrinLens: ['radius','gradientCoeff','refractiveIndex'],
    Blocker: ['length'], Aperture: ['length','opening'],
    CircleBlocker: ['radius'], Observer: ['pupilRadius']
  };

  function updateObjBar() {
    if (!els.objBar) return;
    if (constructing && constructing.pendingType) {
      els.objBar.innerHTML = '<span class="rs-objbar-empty">Click canvas to place ' + constructing.pendingType + ' \u2022 Drag to size \u2022 Esc to cancel</span>';
      return;
    }
    if (!selectedId) {
      els.objBar.innerHTML = '<span class="rs-objbar-empty">Select object to edit \u2022 Drag handles to resize \u2022 Scroll to zoom</span>';
      return;
    }
    var obj = scene.findObject(selectedId);
    if (!obj) { els.objBar.innerHTML = ''; return; }

    var html = '<span class="rs-objbar-title">' + obj.type + '</span>';
    html += propG('x', obj.x.toFixed(0));
    html += propG('y', obj.y.toFixed(0));
    html += propG('angle', (obj.angle * 180 / Math.PI).toFixed(1) + '\u00B0');
    var props = PROP_MAP[obj.type] || [];
    for (var i = 0; i < props.length; i++) {
      var key = props[i];
      if (obj[key] !== undefined) {
        if (key === 'dichroic') html += chkG(key, obj[key]);
        else html += propG(key, smartFmt(obj[key]));
      }
    }
    // Duplicate + Delete buttons
    html += ' <button class="rs-btn rs-objbar-dup" title="Duplicate (Ctrl+D)">\u2398</button>';
    html += ' <button class="rs-btn rs-btn-danger rs-objbar-del" title="Delete (Del)">\u2716</button>';
    els.objBar.innerHTML = html;

    var inputs = els.objBar.querySelectorAll('.rs-prop-inp');
    for (var j = 0; j < inputs.length; j++) inputs[j].addEventListener('change', onPropChange);
    var checks = els.objBar.querySelectorAll('.rs-prop-chk');
    for (var k = 0; k < checks.length; k++) checks[k].addEventListener('change', onChkChange);
    var del = els.objBar.querySelector('.rs-objbar-del');
    if (del) del.addEventListener('click', removeSelected);
    var dup = els.objBar.querySelector('.rs-objbar-dup');
    if (dup) dup.addEventListener('click', duplicateSelected);
  }

  function propG(key, val) {
    return '<span class="rs-prop-group"><span class="rs-prop-lbl">' + lbl(key) +
           '</span><input class="rs-prop-inp" data-key="' + key + '" value="' + val + '" type="text" size="5"></span>';
  }
  function chkG(key, chk) {
    return '<label class="rs-prop-group" style="cursor:pointer"><input class="rs-prop-chk" data-key="' +
           key + '" type="checkbox"' + (chk ? ' checked' : '') + '><span class="rs-prop-lbl">' + lbl(key) + '</span></label>';
  }
  function lbl(k) {
    var m = { x:'x', y:'y', angle:'\u03B8', numRays:'rays', brightness:'I', wavelength:'\u03BB',
      spreadAngle:'spread', width:'w', height:'h', length:'L', refractiveIndex:'n', cauchyB:'B',
      radius:'r', radius1:'R1', radius2:'R2', diameter:'dia', arcAngle:'arc', focalLength:'f',
      sideLength:'side', apexAngle:'apex', opening:'open',
      transmissionRatio:'T', dichroic:'dichroic', dichroicMinWL:'\u03BB\u2081', dichroicMaxWL:'\u03BB\u2082',
      lineDensity:'lines/mm', gradientCoeff:'g', pupilRadius:'pupil', thickness:'t' };
    return m[k] || k;
  }
  function smartFmt(v) { return Math.abs(v) >= 100 ? v.toFixed(0) : Math.abs(v) >= 1 ? v.toFixed(1) : v.toPrecision(3); }
  function onPropChange(e) {
    if (!selectedId) return;
    var obj = scene.findObject(selectedId);
    if (!obj) return;
    var key = e.target.getAttribute('data-key');
    var val = parseFloat(e.target.value.replace('\u00B0', ''));
    if (isNaN(val)) return;
    saveUndo();
    if (key === 'angle') obj.angle = val * Math.PI / 180;
    else if (obj[key] !== undefined) obj[key] = val;
    refreshAll();
  }
  function onChkChange(e) {
    if (!selectedId) return;
    var obj = scene.findObject(selectedId);
    if (obj) { saveUndo(); obj[e.target.getAttribute('data-key')] = e.target.checked; refreshAll(); }
  }

  /* ================================================================
   *  VIEWPORT & PAINT
   * ================================================================ */

  function fitViewport() {
    if (!canvas || !scene) return;
    var cw = canvas.offsetWidth, ch = canvas.offsetHeight;
    viewport.scale = Math.min(cw / scene.width, ch / scene.height) * 0.9;
    viewport.ox = (scene.width - cw / viewport.scale) / 2;
    viewport.oy = (scene.height - ch / viewport.scale) / 2;
  }

  function canvasToWorld(cx, cy) {
    return { x: cx / viewport.scale + viewport.ox, y: cy / viewport.scale + viewport.oy };
  }

  function loadPreset(name) {
    if (!S.PRESETS[name]) return;
    saveUndo();
    scene = S.PRESETS[name]();
    selectedId = null;
    constructing = null;
    ghostPos = null;
    undoStack = []; redoStack = [];
    fitViewport();
    syncSettingsUI();
    updateObjBar();
    refreshAll();
    updateUndoButtons();
  }

  function syncSettingsUI() {
    if (!scene) return;
    if (els.rayModeSel) els.rayModeSel.value = scene.rayMode || 'rays';
    if (els.fresnelChk) els.fresnelChk.checked = !!scene.fresnelEnabled;
    if (els.gridChk) els.gridChk.checked = !!scene.showGrid;
    if (els.gridSizeInp) els.gridSizeInp.value = scene.gridSize || 50;
    if (els.bgNInp) els.bgNInp.value = scene.backgroundN || 1;
  }

  function refreshAll() {
    if (!scene) return;
    tracedPaths = E.traceAll(scene);
    scheduleRepaint();
  }

  function scheduleRepaint() {
    if (rafPending) return;
    rafPending = true;
    requestAnimationFrame(function () { rafPending = false; repaint(); });
  }

  function repaint() {
    if (!canvas || !scene) return;
    R.paint(canvas, scene, tracedPaths, {
      viewport: viewport,
      selectedId: selectedId,
      hoveredObjId: hoveredObjId,
      handles: selectedId ? getHandles(scene.findObject(selectedId)) : null,
      hoveredHandle: hoveredHandle,
      constructing: !!(constructing && constructing.pendingType),
      ghost: ghostPos,
      dragTooltip: dragTooltip
    });
  }

  /* ================================================================
   *  EXPORT
   * ================================================================ */

  win.RayUI = {
    init: init,
    getScene: function () { return scene; },
    loadPreset: loadPreset,
    refreshAll: refreshAll,
    getViewport: function () { return viewport; },
    getHandles: getHandles,
    undo: undo,
    redo: redo
  };

})(window);
