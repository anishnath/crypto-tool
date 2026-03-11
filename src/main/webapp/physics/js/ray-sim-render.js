/**
 * Ray Optics Simulator — Canvas Renderer
 * ES5 IIFE, depends on RayScene + RayEngine
 *
 * Exports: window.RayRender
 *   .paint(canvas, scene, tracedPaths, opts)
 */
;(function (win) {
  'use strict';

  var S = win.RayScene;
  var E = win.RayEngine;
  var Vec = E.Vec;

  function isDark() {
    var el = document.documentElement;
    return el.getAttribute('data-theme') === 'dark';
  }

  function colors() {
    var dark = isDark();
    return {
      bg:        dark ? '#1a1a2e' : '#ffffff',
      grid:      dark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)',
      axis:      dark ? '#3a3a5c' : '#d0d0d0',
      text:      dark ? '#e0e0e0' : '#1f2937',
      textSub:   dark ? '#9ca3af' : '#6b7280',
      mirror:    dark ? '#60a5fa' : '#2563eb',
      glass:     dark ? 'rgba(14,165,233,0.15)' : 'rgba(14,165,233,0.10)',
      glassEdge: dark ? 'rgba(14,165,233,0.6)' : 'rgba(14,165,233,0.4)',
      lens:      dark ? '#a78bfa' : '#7c3aed',
      blocker:   dark ? '#6b7280' : '#374151',
      source:    dark ? '#fbbf24' : '#f59e0b',
      selected:  dark ? '#f59e0b' : '#d97706',
      handle:    dark ? '#22d3ee' : '#0891b2'
    };
  }

  function setupCanvas(canvas) {
    var dpr = window.devicePixelRatio || 1;
    var w = canvas.offsetWidth;
    var h = canvas.offsetHeight;
    canvas.width = w * dpr;
    canvas.height = h * dpr;
    var c = canvas.getContext('2d');
    c.scale(dpr, dpr);
    return { c: c, w: w, h: h };
  }

  /* ================================================================
   *  MAIN PAINT
   * ================================================================ */

  function paint(canvas, scene, tracedPaths, opts) {
    opts = opts || {};
    var setup = setupCanvas(canvas);
    var c = setup.c, cw = setup.w, ch = setup.h;
    var col = colors();

    // Viewport transform
    var vp = opts.viewport || { ox: 0, oy: 0, scale: 1 };

    function toCanvas(wx, wy) {
      return { x: (wx - vp.ox) * vp.scale, y: (wy - vp.oy) * vp.scale };
    }

    // Background
    c.fillStyle = col.bg;
    c.fillRect(0, 0, cw, ch);

    // Grid
    if (scene.showGrid && scene.gridSize > 0) {
      drawGrid(c, cw, ch, scene.gridSize, vp, col);
    }

    // Draw all traced ray paths
    drawRays(c, tracedPaths, vp, col);

    // Draw extended rays (dashed, behind objects)
    drawExtendedRays(c, tracedPaths, vp, col);

    // Draw image points
    if (tracedPaths && tracedPaths.imagePoints) {
      drawImagePoints(c, tracedPaths.imagePoints, vp, col);
    }

    // Draw scene objects
    for (var i = 0; i < scene.objects.length; i++) {
      var obj = scene.objects[i];
      var isSel = opts.selectedId === obj.id;
      drawObject(c, obj, vp, col, isSel);
    }

    // Hover highlight
    if (opts.hoveredObjId && opts.hoveredObjId !== opts.selectedId) {
      var hov = scene.findObject(opts.hoveredObjId);
      if (hov) {
        var hp = tp(vp, hov.x, hov.y);
        c.strokeStyle = col.handle;
        c.lineWidth = 1;
        c.globalAlpha = 0.3;
        c.setLineDash([3, 3]);
        c.beginPath();
        c.arc(hp.x, hp.y, 14, 0, Math.PI * 2);
        c.stroke();
        c.setLineDash([]);
        c.globalAlpha = 1;
      }
    }

    // Selection handles (control points)
    if (opts.selectedId) {
      var sel = scene.findObject(opts.selectedId);
      if (sel) drawHandles(c, sel, vp, col, opts.handles, opts.hoveredHandle);
    }

    // Construction mode indicator
    if (opts.constructing) {
      c.fillStyle = col.handle;
      c.globalAlpha = 0.7;
      c.font = '11px system-ui, sans-serif';
      c.textAlign = 'center';
      c.fillText('Click to place \u2022 Drag to size \u2022 Esc to cancel', cw / 2, ch - 12);
      c.globalAlpha = 1;
    }

    // Ghost preview (semi-transparent object following cursor before placement)
    if (opts.ghost) {
      drawGhostPreview(c, opts.ghost, vp, col);
    }

    // Drag tooltip (shows coordinates/size near cursor during drag)
    if (opts.dragTooltip) {
      drawTooltip(c, opts.dragTooltip);
    }

    // Locked indicator
    for (var li = 0; li < scene.objects.length; li++) {
      if (scene.objects[li].locked) {
        var lp = tp(vp, scene.objects[li].x, scene.objects[li].y);
        c.fillStyle = col.textSub;
        c.globalAlpha = 0.5;
        c.font = '9px system-ui, sans-serif';
        c.textAlign = 'center';
        c.fillText('\uD83D\uDD12', lp.x, lp.y - 12);
        c.globalAlpha = 1;
      }
    }
  }

  /* ---- Ghost Preview ---- */
  function drawGhostPreview(c, ghost, vp, col) {
    var gp = tp(vp, ghost.x, ghost.y);
    c.globalAlpha = 0.25;
    c.strokeStyle = col.handle;
    c.lineWidth = 2;
    c.setLineDash([4, 4]);

    var t = ghost.type;
    // Draw a representative shape
    if (t === 'FlatMirror' || t === 'Blocker' || t === 'BeamSplitter' ||
        t === 'DiffractionGrating' || t === 'Aperture') {
      var hl = 50 * vp.scale;
      c.beginPath();
      c.moveTo(gp.x, gp.y - hl);
      c.lineTo(gp.x, gp.y + hl);
      c.stroke();
    } else if (t === 'ParabolicMirror' || t === 'CurvedMirror') {
      c.beginPath();
      c.arc(gp.x + 60 * vp.scale, gp.y, 60 * vp.scale, Math.PI * 0.7, Math.PI * 1.3);
      c.stroke();
    } else if (t === 'CircleLens' || t === 'CircleBlocker' || t === 'GrinLens') {
      c.beginPath();
      c.arc(gp.x, gp.y, 50 * vp.scale, 0, Math.PI * 2);
      c.stroke();
    } else if (t === 'GlassSlab') {
      var hw = 60 * vp.scale, hh = 30 * vp.scale;
      c.strokeRect(gp.x - hw, gp.y - hh, hw * 2, hh * 2);
    } else if (t === 'Prism') {
      var sz = 40 * vp.scale;
      c.beginPath();
      c.moveTo(gp.x, gp.y - sz);
      c.lineTo(gp.x + sz * 0.87, gp.y + sz * 0.5);
      c.lineTo(gp.x - sz * 0.87, gp.y + sz * 0.5);
      c.closePath();
      c.stroke();
    } else if (t === 'IdealLens' || t === 'IdealMirror') {
      var lh = 50 * vp.scale;
      c.beginPath();
      c.moveTo(gp.x, gp.y - lh);
      c.lineTo(gp.x, gp.y + lh);
      c.stroke();
      // Arrow tips
      c.beginPath();
      c.moveTo(gp.x - 5, gp.y - lh + 8);
      c.lineTo(gp.x, gp.y - lh);
      c.lineTo(gp.x + 5, gp.y - lh + 8);
      c.moveTo(gp.x - 5, gp.y + lh - 8);
      c.lineTo(gp.x, gp.y + lh);
      c.lineTo(gp.x + 5, gp.y + lh - 8);
      c.stroke();
    } else if (t === 'PointSource') {
      c.fillStyle = col.source;
      c.beginPath();
      c.arc(gp.x, gp.y, 6, 0, Math.PI * 2);
      c.fill();
    } else if (t === 'ParallelBeam') {
      var bw = 40 * vp.scale;
      c.beginPath();
      c.moveTo(gp.x, gp.y - bw);
      c.lineTo(gp.x, gp.y + bw);
      c.stroke();
      // Arrows
      for (var bi = -1; bi <= 1; bi++) {
        var by = gp.y + bi * bw;
        c.beginPath();
        c.moveTo(gp.x, by);
        c.lineTo(gp.x + 20, by);
        c.stroke();
      }
    } else if (t === 'SingleRay') {
      c.beginPath();
      c.moveTo(gp.x, gp.y);
      c.lineTo(gp.x + 40, gp.y);
      c.stroke();
      c.fillStyle = col.source;
      c.beginPath();
      c.arc(gp.x, gp.y, 4, 0, Math.PI * 2);
      c.fill();
    } else if (t === 'SphericalLens') {
      c.beginPath();
      c.arc(gp.x - 20 * vp.scale, gp.y, 50 * vp.scale, -0.4, 0.4);
      c.stroke();
      c.beginPath();
      c.arc(gp.x + 20 * vp.scale, gp.y, 50 * vp.scale, Math.PI - 0.4, Math.PI + 0.4);
      c.stroke();
    } else if (t === 'Observer') {
      c.beginPath();
      c.arc(gp.x, gp.y, 20 * vp.scale, 0, Math.PI * 2);
      c.stroke();
    } else {
      // Fallback: crosshair
      c.beginPath();
      c.moveTo(gp.x - 10, gp.y); c.lineTo(gp.x + 10, gp.y);
      c.moveTo(gp.x, gp.y - 10); c.lineTo(gp.x, gp.y + 10);
      c.stroke();
    }

    c.setLineDash([]);
    c.globalAlpha = 1;
  }

  /* ---- Drag Tooltip ---- */
  function drawTooltip(c, tip) {
    // tip = { cx, cy, text } in canvas coords
    var text = tip.text;
    c.font = '10px JetBrains Mono, monospace';
    var tw = c.measureText(text).width;
    var px = tip.cx + 14, py = tip.cy - 14;
    var pad = 4;
    var bw = tw + pad * 2, bh = 16;

    // Keep on screen
    if (px + bw > c.canvas.offsetWidth) px = tip.cx - bw - 6;
    if (py - bh < 0) py = tip.cy + 20;

    // Background pill
    c.fillStyle = 'rgba(0,0,0,0.75)';
    c.beginPath();
    roundRect(c, px - pad, py - bh + 2, bw, bh, 3);
    c.fill();

    // Text
    c.fillStyle = '#ffffff';
    c.textAlign = 'left';
    c.textBaseline = 'bottom';
    c.fillText(text, px, py);
    c.textBaseline = 'alphabetic';
  }

  function roundRect(c, x, y, w, h, r) {
    c.moveTo(x + r, y);
    c.lineTo(x + w - r, y);
    c.quadraticCurveTo(x + w, y, x + w, y + r);
    c.lineTo(x + w, y + h - r);
    c.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
    c.lineTo(x + r, y + h);
    c.quadraticCurveTo(x, y + h, x, y + h - r);
    c.lineTo(x, y + r);
    c.quadraticCurveTo(x, y, x + r, y);
  }

  /* ---- Grid ---- */
  function drawGrid(c, cw, ch, gridSize, vp, col) {
    c.strokeStyle = col.grid;
    c.lineWidth = 1;
    var gs = gridSize * vp.scale;
    if (gs < 5) return; // too dense

    var startX = -(vp.ox * vp.scale) % gs;
    var startY = -(vp.oy * vp.scale) % gs;
    c.beginPath();
    for (var x = startX; x < cw; x += gs) {
      c.moveTo(x, 0); c.lineTo(x, ch);
    }
    for (var y = startY; y < ch; y += gs) {
      c.moveTo(0, y); c.lineTo(cw, y);
    }
    c.stroke();
  }

  /* ---- Rays ---- */
  function drawRays(c, paths, vp, col) {
    if (!paths) return;
    for (var pi = 0; pi < paths.length; pi++) {
      var path = paths[pi];
      c.strokeStyle = path.color || 'rgba(255,200,50,0.8)';
      c.lineWidth = 1.5;
      c.globalAlpha = Math.min(1, path.brightness || 0.8);
      c.beginPath();
      for (var si = 0; si < path.segments.length; si++) {
        var seg = path.segments[si];
        var p1 = { x: (seg.x1 - vp.ox) * vp.scale, y: (seg.y1 - vp.oy) * vp.scale };
        var p2 = { x: (seg.x2 - vp.ox) * vp.scale, y: (seg.y2 - vp.oy) * vp.scale };
        c.moveTo(p1.x, p1.y);
        c.lineTo(p2.x, p2.y);
      }
      c.stroke();
      c.globalAlpha = 1;
    }
  }

  /* ---- Objects ---- */
  function drawObject(c, obj, vp, col, selected) {
    var t = obj.type;
    if (t === 'PointSource' || t === 'SingleRay')     drawSourceDot(c, obj, vp, col, selected);
    else if (t === 'ParallelBeam')                     drawBeamSource(c, obj, vp, col, selected);
    else if (t === 'FlatMirror')                       drawFlatMirror(c, obj, vp, col, selected);
    else if (t === 'CurvedMirror')                     drawCurvedMirror(c, obj, vp, col, selected);
    else if (t === 'ParabolicMirror')                  drawParabolicMirror(c, obj, vp, col, selected);
    else if (t === 'GlassSlab')                        drawGlassSlab(c, obj, vp, col, selected);
    else if (t === 'Prism')                            drawPrism(c, obj, vp, col, selected);
    else if (t === 'CircleLens')                       drawCircleLens(c, obj, vp, col, selected);
    else if (t === 'IdealLens')                        drawIdealLens(c, obj, vp, col, selected);
    else if (t === 'Blocker' || t === 'Aperture')      drawBlocker(c, obj, vp, col, selected);
    else if (t === 'SphericalLens')                    drawSphericalLens(c, obj, vp, col, selected);
    else if (t === 'BeamSplitter')                     drawBeamSplitter(c, obj, vp, col, selected);
    else if (t === 'IdealMirror')                      drawIdealMirror(c, obj, vp, col, selected);
    else if (t === 'CircleBlocker')                    drawCircleBlocker(c, obj, vp, col, selected);
    else if (t === 'DiffractionGrating')               drawDiffractionGrating(c, obj, vp, col, selected);
    else if (t === 'GrinLens')                         drawGrinLens(c, obj, vp, col, selected);
    else if (t === 'Observer')                         drawObserver(c, obj, vp, col, selected);
  }

  function tp(vp, wx, wy) {
    return { x: (wx - vp.ox) * vp.scale, y: (wy - vp.oy) * vp.scale };
  }

  function drawSourceDot(c, obj, vp, col, sel) {
    var p = tp(vp, obj.x, obj.y);
    c.fillStyle = sel ? col.selected : col.source;
    c.beginPath();
    c.arc(p.x, p.y, sel ? 7 : 5, 0, Math.PI * 2);
    c.fill();
    // Direction indicator
    var dx = Math.cos(obj.angle) * 14, dy = Math.sin(obj.angle) * 14;
    c.strokeStyle = col.source;
    c.lineWidth = 2;
    c.beginPath();
    c.moveTo(p.x, p.y);
    c.lineTo(p.x + dx, p.y + dy);
    c.stroke();
  }

  function drawBeamSource(c, obj, vp, col, sel) {
    var dx = Math.cos(obj.angle), dy = Math.sin(obj.angle);
    var px = -dy, py = dx;
    var half = obj.width / 2;
    var p1 = tp(vp, obj.x + px * half, obj.y + py * half);
    var p2 = tp(vp, obj.x - px * half, obj.y - py * half);
    c.strokeStyle = sel ? col.selected : col.source;
    c.lineWidth = sel ? 3 : 2;
    c.beginPath();
    c.moveTo(p1.x, p1.y);
    c.lineTo(p2.x, p2.y);
    c.stroke();
    // Arrow in center
    var pc = tp(vp, obj.x, obj.y);
    c.beginPath();
    c.moveTo(pc.x, pc.y);
    c.lineTo(pc.x + dx * 12, pc.y + dy * 12);
    c.stroke();
  }

  function drawFlatMirror(c, obj, vp, col, sel) {
    var ep = obj.getEndpoints();
    var p1 = tp(vp, ep.p1.x, ep.p1.y);
    var p2 = tp(vp, ep.p2.x, ep.p2.y);
    c.strokeStyle = sel ? col.selected : col.mirror;
    c.lineWidth = sel ? 3.5 : 3;
    c.beginPath();
    c.moveTo(p1.x, p1.y);
    c.lineTo(p2.x, p2.y);
    c.stroke();
    // Hatching on back side
    c.lineWidth = 1;
    c.strokeStyle = sel ? col.selected : col.mirror;
    var nx = -(p2.y - p1.y), ny = p2.x - p1.x;
    var nl = Math.sqrt(nx * nx + ny * ny);
    nx /= nl; ny /= nl;
    var nHatch = 8;
    for (var i = 0; i <= nHatch; i++) {
      var frac = i / nHatch;
      var hx = p1.x + (p2.x - p1.x) * frac;
      var hy = p1.y + (p2.y - p1.y) * frac;
      c.beginPath();
      c.moveTo(hx, hy);
      c.lineTo(hx - nx * 6 - (p2.x - p1.x) / nl * 4, hy - ny * 6 - (p2.y - p1.y) / nl * 4);
      c.stroke();
    }
  }

  function drawCurvedMirror(c, obj, vp, col, sel) {
    var arc = obj.getArc();
    var cp = tp(vp, arc.center.x, arc.center.y);
    var r = arc.radius * vp.scale;
    c.strokeStyle = sel ? col.selected : col.mirror;
    c.lineWidth = sel ? 3.5 : 3;
    c.beginPath();
    c.arc(cp.x, cp.y, r, arc.startAngle, arc.endAngle);
    c.stroke();
  }

  function drawParabolicMirror(c, obj, vp, col, sel) {
    var pts = obj.getPolyline(30);
    c.strokeStyle = sel ? col.selected : col.mirror;
    c.lineWidth = sel ? 3.5 : 3;
    c.beginPath();
    for (var i = 0; i < pts.length; i++) {
      var p = tp(vp, pts[i].x, pts[i].y);
      if (i === 0) c.moveTo(p.x, p.y); else c.lineTo(p.x, p.y);
    }
    c.stroke();
  }

  function drawGlassSlab(c, obj, vp, col, sel) {
    var corners = obj.getCorners();
    c.fillStyle = col.glass;
    c.strokeStyle = sel ? col.selected : col.glassEdge;
    c.lineWidth = sel ? 2 : 1.5;
    c.beginPath();
    for (var i = 0; i < corners.length; i++) {
      var p = tp(vp, corners[i].x, corners[i].y);
      if (i === 0) c.moveTo(p.x, p.y); else c.lineTo(p.x, p.y);
    }
    c.closePath();
    c.fill();
    c.stroke();
    // Label
    var center = tp(vp, obj.x, obj.y);
    c.fillStyle = col.textSub;
    c.font = '10px system-ui, sans-serif';
    c.textAlign = 'center';
    c.fillText('n=' + obj.refractiveIndex.toFixed(2), center.x, center.y + 4);
  }

  function drawPrism(c, obj, vp, col, sel) {
    var verts = obj.getVertices();
    c.fillStyle = col.glass;
    c.strokeStyle = sel ? col.selected : col.glassEdge;
    c.lineWidth = sel ? 2 : 1.5;
    c.beginPath();
    for (var i = 0; i < verts.length; i++) {
      var p = tp(vp, verts[i].x, verts[i].y);
      if (i === 0) c.moveTo(p.x, p.y); else c.lineTo(p.x, p.y);
    }
    c.closePath();
    c.fill();
    c.stroke();
  }

  function drawCircleLens(c, obj, vp, col, sel) {
    var cp = tp(vp, obj.x, obj.y);
    var r = obj.radius * vp.scale;
    c.fillStyle = col.glass;
    c.strokeStyle = sel ? col.selected : col.glassEdge;
    c.lineWidth = sel ? 2 : 1.5;
    c.beginPath();
    c.arc(cp.x, cp.y, r, 0, Math.PI * 2);
    c.fill();
    c.stroke();
  }

  function drawIdealLens(c, obj, vp, col, sel) {
    var edges = obj.getEdges();
    var p1 = tp(vp, edges[0].p1.x, edges[0].p1.y);
    var p2 = tp(vp, edges[0].p2.x, edges[0].p2.y);
    c.strokeStyle = sel ? col.selected : col.lens;
    c.lineWidth = sel ? 2.5 : 2;
    c.setLineDash([4, 3]);
    c.beginPath();
    c.moveTo(p1.x, p1.y);
    c.lineTo(p2.x, p2.y);
    c.stroke();
    c.setLineDash([]);
    // Arrow tips at both ends
    var dx = p2.x - p1.x, dy = p2.y - p1.y;
    var l = Math.sqrt(dx * dx + dy * dy);
    dx /= l; dy /= l;
    var sz = 6;
    // Converging lens: arrows point outward
    c.beginPath();
    c.moveTo(p1.x, p1.y);
    c.lineTo(p1.x + dx * sz - dy * sz, p1.y + dy * sz + dx * sz);
    c.moveTo(p1.x, p1.y);
    c.lineTo(p1.x + dx * sz + dy * sz, p1.y + dy * sz - dx * sz);
    c.moveTo(p2.x, p2.y);
    c.lineTo(p2.x - dx * sz - dy * sz, p2.y - dy * sz + dx * sz);
    c.moveTo(p2.x, p2.y);
    c.lineTo(p2.x - dx * sz + dy * sz, p2.y - dy * sz - dx * sz);
    c.stroke();
    // Focal point dots
    var cp = tp(vp, obj.x, obj.y);
    var ax = Math.cos(obj.angle - Math.PI / 2);
    var ay = Math.sin(obj.angle - Math.PI / 2);
    var fPx = obj.focalLength * vp.scale;
    c.fillStyle = col.lens;
    c.globalAlpha = 0.5;
    c.beginPath();
    c.arc(cp.x + ax * fPx, cp.y + ay * fPx, 3, 0, Math.PI * 2);
    c.arc(cp.x - ax * fPx, cp.y - ay * fPx, 3, 0, Math.PI * 2);
    c.fill();
    c.globalAlpha = 1;
  }

  function drawBlocker(c, obj, vp, col, sel) {
    var edges = obj.getEdges();
    c.strokeStyle = sel ? col.selected : col.blocker;
    c.lineWidth = sel ? 4 : 3;
    c.lineCap = 'round';
    for (var i = 0; i < edges.length; i++) {
      var p1 = tp(vp, edges[i].p1.x, edges[i].p1.y);
      var p2 = tp(vp, edges[i].p2.x, edges[i].p2.y);
      c.beginPath();
      c.moveTo(p1.x, p1.y);
      c.lineTo(p2.x, p2.y);
      c.stroke();
    }
    c.lineCap = 'butt';
  }

  /* ---- Phase 2 objects ---- */

  function drawSphericalLens(c, obj, vp, col, sel) {
    var arcs = obj.getArcs();
    c.fillStyle = col.glass;
    c.strokeStyle = sel ? col.selected : col.glassEdge;
    c.lineWidth = sel ? 2 : 1.5;
    // Draw filled shape between the two arcs
    // Approximate: fill a path using front and back arcs
    for (var ai = 0; ai < arcs.length; ai++) {
      var a = arcs[ai];
      var cp = tp(vp, a.center.x, a.center.y);
      var r = a.radius * vp.scale;
      c.beginPath();
      c.arc(cp.x, cp.y, r, a.startAngle, a.endAngle);
      c.stroke();
    }
    // Fill between arcs (simplified: draw both arcs as a closed shape)
    if (arcs.length === 2) {
      var a0 = arcs[0], a1 = arcs[1];
      var c0 = tp(vp, a0.center.x, a0.center.y);
      var c1 = tp(vp, a1.center.x, a1.center.y);
      c.beginPath();
      c.arc(c0.x, c0.y, a0.radius * vp.scale, a0.startAngle, a0.endAngle);
      c.arc(c1.x, c1.y, a1.radius * vp.scale, a1.endAngle, a1.startAngle, true);
      c.closePath();
      c.fillStyle = col.glass;
      c.fill();
    }
  }

  function drawBeamSplitter(c, obj, vp, col, sel) {
    var ep = obj.getEndpoints();
    var p1 = tp(vp, ep.p1.x, ep.p1.y);
    var p2 = tp(vp, ep.p2.x, ep.p2.y);
    c.strokeStyle = sel ? col.selected : col.lens;
    c.lineWidth = sel ? 2.5 : 2;
    c.setLineDash([6, 4]);
    c.beginPath();
    c.moveTo(p1.x, p1.y);
    c.lineTo(p2.x, p2.y);
    c.stroke();
    c.setLineDash([]);
    // Dichroic indicator
    if (obj.dichroic) {
      var mx = (p1.x + p2.x) / 2, my = (p1.y + p2.y) / 2;
      c.fillStyle = 'rgba(168,85,247,0.6)';
      c.beginPath();
      c.arc(mx, my, 4, 0, Math.PI * 2);
      c.fill();
    }
  }

  function drawIdealMirror(c, obj, vp, col, sel) {
    var edges = obj.getEdges();
    var p1 = tp(vp, edges[0].p1.x, edges[0].p1.y);
    var p2 = tp(vp, edges[0].p2.x, edges[0].p2.y);
    c.strokeStyle = sel ? col.selected : col.mirror;
    c.lineWidth = sel ? 3.5 : 3;
    c.beginPath();
    c.moveTo(p1.x, p1.y);
    c.lineTo(p2.x, p2.y);
    c.stroke();
    // Focal point dot
    var cp = tp(vp, obj.x, obj.y);
    var ax = Math.cos(obj.angle - Math.PI / 2);
    var ay = Math.sin(obj.angle - Math.PI / 2);
    var fPx = obj.focalLength * vp.scale;
    c.fillStyle = col.mirror;
    c.globalAlpha = 0.5;
    c.beginPath();
    c.arc(cp.x + ax * fPx, cp.y + ay * fPx, 3, 0, Math.PI * 2);
    c.fill();
    c.globalAlpha = 1;
    // Hatching (same as FlatMirror)
    c.lineWidth = 1;
    var nx = -(p2.y - p1.y), ny = p2.x - p1.x;
    var nl = Math.sqrt(nx * nx + ny * ny);
    nx /= nl; ny /= nl;
    for (var i = 0; i <= 8; i++) {
      var frac = i / 8;
      var hx = p1.x + (p2.x - p1.x) * frac;
      var hy = p1.y + (p2.y - p1.y) * frac;
      c.beginPath();
      c.moveTo(hx, hy);
      c.lineTo(hx - nx * 6 - (p2.x - p1.x) / nl * 4, hy - ny * 6 - (p2.y - p1.y) / nl * 4);
      c.stroke();
    }
  }

  function drawCircleBlocker(c, obj, vp, col, sel) {
    var cp = tp(vp, obj.x, obj.y);
    var r = obj.radius * vp.scale;
    c.strokeStyle = sel ? col.selected : col.blocker;
    c.lineWidth = sel ? 3 : 2;
    c.beginPath();
    c.arc(cp.x, cp.y, r, 0, Math.PI * 2);
    c.stroke();
    // Cross pattern inside
    c.lineWidth = 1;
    c.globalAlpha = 0.3;
    c.beginPath();
    c.moveTo(cp.x - r * 0.5, cp.y - r * 0.5);
    c.lineTo(cp.x + r * 0.5, cp.y + r * 0.5);
    c.moveTo(cp.x + r * 0.5, cp.y - r * 0.5);
    c.lineTo(cp.x - r * 0.5, cp.y + r * 0.5);
    c.stroke();
    c.globalAlpha = 1;
  }

  function drawDiffractionGrating(c, obj, vp, col, sel) {
    var edges = obj.getEdges();
    var p1 = tp(vp, edges[0].p1.x, edges[0].p1.y);
    var p2 = tp(vp, edges[0].p2.x, edges[0].p2.y);
    c.strokeStyle = sel ? col.selected : '#a78bfa';
    c.lineWidth = sel ? 3 : 2;
    c.beginPath();
    c.moveTo(p1.x, p1.y);
    c.lineTo(p2.x, p2.y);
    c.stroke();
    // Hash marks perpendicular to grating
    var dx = p2.x - p1.x, dy = p2.y - p1.y;
    var l = Math.sqrt(dx * dx + dy * dy);
    var nx = -dy / l, ny = dx / l;
    c.lineWidth = 1;
    c.globalAlpha = 0.5;
    var nMarks = Math.min(20, Math.max(6, Math.round(l / 6)));
    for (var i = 0; i <= nMarks; i++) {
      var frac = i / nMarks;
      var mx = p1.x + dx * frac, my = p1.y + dy * frac;
      c.beginPath();
      c.moveTo(mx - nx * 4, my - ny * 4);
      c.lineTo(mx + nx * 4, my + ny * 4);
      c.stroke();
    }
    c.globalAlpha = 1;
  }

  function drawGrinLens(c, obj, vp, col, sel) {
    var cp = tp(vp, obj.x, obj.y);
    var r = obj.radius * vp.scale;
    // Gradient fill to show n variation
    var grad = c.createRadialGradient(cp.x, cp.y, 0, cp.x, cp.y, r);
    grad.addColorStop(0, 'rgba(14,165,233,0.25)');
    grad.addColorStop(1, 'rgba(14,165,233,0.05)');
    c.fillStyle = grad;
    c.beginPath();
    c.arc(cp.x, cp.y, r, 0, Math.PI * 2);
    c.fill();
    c.strokeStyle = sel ? col.selected : col.glassEdge;
    c.lineWidth = sel ? 2 : 1.5;
    c.stroke();
    // Label
    c.fillStyle = col.textSub;
    c.font = '10px system-ui, sans-serif';
    c.textAlign = 'center';
    c.fillText('GRIN', cp.x, cp.y + 4);
  }

  function drawObserver(c, obj, vp, col, sel) {
    var cp = tp(vp, obj.x, obj.y);
    var r = obj.pupilRadius * vp.scale;
    // Eye shape
    c.strokeStyle = sel ? col.selected : '#10b981';
    c.lineWidth = sel ? 2.5 : 2;
    c.beginPath();
    c.arc(cp.x, cp.y, r, 0, Math.PI * 2);
    c.stroke();
    // Pupil dot
    c.fillStyle = sel ? col.selected : '#10b981';
    c.beginPath();
    c.arc(cp.x, cp.y, 3, 0, Math.PI * 2);
    c.fill();
    // Label
    c.fillStyle = col.textSub;
    c.font = '9px system-ui, sans-serif';
    c.textAlign = 'center';
    c.fillText('eye', cp.x, cp.y + r + 12);
  }

  /* ---- Extended rays & image points ---- */
  function drawExtendedRays(c, paths, vp, col) {
    if (!paths) return;
    c.setLineDash([4, 4]);
    c.lineWidth = 1;
    c.globalAlpha = 0.4;
    for (var pi = 0; pi < paths.length; pi++) {
      var ext = paths[pi].extendedSegments;
      if (!ext || ext.length === 0) continue;
      c.strokeStyle = paths[pi].color || 'rgba(255,200,50,0.5)';
      c.beginPath();
      for (var si = 0; si < ext.length; si++) {
        var seg = ext[si];
        var p1 = { x: (seg.x1 - vp.ox) * vp.scale, y: (seg.y1 - vp.oy) * vp.scale };
        var p2 = { x: (seg.x2 - vp.ox) * vp.scale, y: (seg.y2 - vp.oy) * vp.scale };
        c.moveTo(p1.x, p1.y);
        c.lineTo(p2.x, p2.y);
      }
      c.stroke();
    }
    c.setLineDash([]);
    c.globalAlpha = 1;
  }

  function drawImagePoints(c, imagePoints, vp, col) {
    if (!imagePoints || imagePoints.length === 0) return;
    for (var i = 0; i < imagePoints.length; i++) {
      var ip = imagePoints[i];
      var p = tp(vp, ip.x, ip.y);
      c.fillStyle = ip.real ? '#ef4444' : '#8b5cf6';
      c.beginPath();
      c.arc(p.x, p.y, 5, 0, Math.PI * 2);
      c.fill();
      // Cross marker
      c.strokeStyle = ip.real ? '#ef4444' : '#8b5cf6';
      c.lineWidth = 1.5;
      c.beginPath();
      c.moveTo(p.x - 7, p.y); c.lineTo(p.x + 7, p.y);
      c.moveTo(p.x, p.y - 7); c.lineTo(p.x, p.y + 7);
      c.stroke();
    }
  }

  /* ---- Selection handles (control points) ---- */
  function drawHandles(c, obj, vp, col, handles, hoveredHandle) {
    if (!handles || handles.length === 0) return;
    var HANDLE_SIZE = 6;

    for (var i = 0; i < handles.length; i++) {
      var h = handles[i];
      var hp = tp(vp, h.x, h.y);
      var isHovered = hoveredHandle && hoveredHandle.handleId === h.id;
      var sz = isHovered ? HANDLE_SIZE + 2 : HANDLE_SIZE;

      c.fillStyle = isHovered ? '#ffffff' : col.handle;
      c.strokeStyle = col.handle;
      c.lineWidth = 1.5;

      if (h.style === 'diamond') {
        // Diamond shape for focal points
        c.beginPath();
        c.moveTo(hp.x, hp.y - sz);
        c.lineTo(hp.x + sz, hp.y);
        c.lineTo(hp.x, hp.y + sz);
        c.lineTo(hp.x - sz, hp.y);
        c.closePath();
        c.fill();
        c.stroke();
      } else if (h.style === 'circle') {
        // Circle for direction handles
        c.beginPath();
        c.arc(hp.x, hp.y, sz, 0, Math.PI * 2);
        c.fill();
        c.stroke();
        // Draw line from center to direction handle
        var cp = tp(vp, obj.x, obj.y);
        c.setLineDash([3, 3]);
        c.globalAlpha = 0.5;
        c.beginPath();
        c.moveTo(cp.x, cp.y);
        c.lineTo(hp.x, hp.y);
        c.stroke();
        c.setLineDash([]);
        c.globalAlpha = 1;
      } else {
        // Square for endpoints / resize handles
        c.fillRect(hp.x - sz, hp.y - sz, sz * 2, sz * 2);
        c.strokeRect(hp.x - sz, hp.y - sz, sz * 2, sz * 2);
      }
    }

    // Draw selection highlight around center
    var cp2 = tp(vp, obj.x, obj.y);
    c.strokeStyle = col.handle;
    c.lineWidth = 1;
    c.globalAlpha = 0.4;
    c.setLineDash([4, 4]);
    c.beginPath();
    c.arc(cp2.x, cp2.y, 12, 0, Math.PI * 2);
    c.stroke();
    c.setLineDash([]);
    c.globalAlpha = 1;
  }

  /* ================================================================
   *  EXPORT
   * ================================================================ */

  win.RayRender = {
    paint:      paint,
    setupCanvas: setupCanvas,
    colors:     colors
  };

})(window);
