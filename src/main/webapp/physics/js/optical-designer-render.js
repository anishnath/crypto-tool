/**
 * Optical Designer — Canvas Rendering Engine
 * ES5 IIFE, depends on ODModel + ODTrace
 *
 * Exports:  window.ODRender
 *   .paintCrossSection(canvas, design, opts)
 *   .paintSpotDiagram(canvas, design, opts)
 *   .paintRayAberration(canvas, design, opts)
 *   .paintChromaticTable(container, design)
 */
;(function (win) {
  'use strict';

  var M = win.ODModel;
  var T = win.ODTrace;

  /* ---- Helpers ---- */
  function isDark() {
    var el = document.documentElement;
    return el.getAttribute('data-theme') === 'dark';
  }

  function colors() {
    var dark = isDark();
    return {
      bg:       dark ? '#1e1e2e' : '#ffffff',
      axis:     dark ? '#6b7280' : '#9ca3af',
      text:     dark ? '#e5e7eb' : '#1f2937',
      textSub:  dark ? '#9ca3af' : '#6b7280',
      glass:    dark ? 'rgba(14,165,233,0.18)' : 'rgba(14,165,233,0.12)',
      glassEdge:dark ? 'rgba(14,165,233,0.6)'  : 'rgba(14,165,233,0.4)',
      selected: dark ? '#f59e0b'  : '#d97706',
      imgPlane: dark ? '#a78bfa'  : '#7c3aed',
      grid:     dark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
      spot:     dark ? '#38bdf8'  : '#0284c7',
      spotBg:   dark ? '#0f172a'  : '#f8fafc'
    };
  }

  /** Setup HiDPI canvas and return context */
  function setupCanvas(canvas) {
    var dpr = window.devicePixelRatio || 1;
    var w = canvas.offsetWidth;
    var h = canvas.offsetHeight;
    canvas.width  = w * dpr;
    canvas.height = h * dpr;
    var c = canvas.getContext('2d');
    c.scale(dpr, dpr);
    return { c: c, w: w, h: h };
  }

  /* ================================================================
   *  2D CROSS-SECTION VIEW
   * ================================================================ */

  /**
   * @param {HTMLCanvasElement} canvas
   * @param {Design} design
   * @param {object} [opts]
   *   .selectedSurface — index of highlighted surface (-1 for none)
   *   .wavelength      — override center wavelength
   */
  function paintCrossSection(canvas, design, opts) {
    opts = opts || {};
    var setup = setupCanvas(canvas);
    var c = setup.c, cw = setup.w, ch = setup.h;
    var col = colors();

    c.fillStyle = col.bg;
    c.fillRect(0, 0, cw, ch);

    if (design.surfaces.length === 0) {
      c.fillStyle = col.textSub;
      c.font = '14px system-ui, sans-serif';
      c.textAlign = 'center';
      c.fillText('Add surfaces to see the optical system', cw/2, ch/2);
      return;
    }

    var wavelength = opts.wavelength || design.wavelengthCenter;

    /* ---- Compute scale ---- */
    var totalLen = design.totalLength();
    if (totalLen <= 0) totalLen = 100;
    var maxAp = design.maxAperture();
    if (maxAp <= 0) maxAp = 25;

    // For finite conjugate, show some object space before the lens
    var objDist = design.objectDistance;
    var preLenZ = 0; // how much z space before z=0 to show
    var objCompressed = false; // true when obj space is compressed (break shown)
    if (isFinite(objDist)) {
      var maxPreLen = totalLen * 0.35;
      if (objDist <= maxPreLen) {
        preLenZ = objDist;
      } else {
        // Compressed: allocate fixed space, draw break indicator later
        preLenZ = maxPreLen;
        objCompressed = true;
      }
    } else {
      // Collimated: show a small pre-lens region for incoming rays
      preLenZ = totalLen * 0.12;
    }
    var fullZRange = preLenZ + totalLen;

    var marginL = 0.06, marginR = 0.06;
    var marginTB = 0.10;
    var usableW = cw * (1 - marginL - marginR);
    var usableH = ch * (1 - 2 * marginTB);

    var scaleX = usableW / fullZRange;
    var scaleY = usableH / (maxAp * 2);
    var scale = Math.min(scaleX, scaleY);

    // Transform: z=0 (first surface vertex) at preLenZ offset from left
    var ox = cw * marginL + preLenZ * scale;
    var oy = ch / 2;

    function toCanvas(zOpt, yOpt) {
      return { x: ox + zOpt * scale, y: oy - yOpt * scale };
    }

    /* ---- Grid ---- */
    c.strokeStyle = col.grid;
    c.lineWidth = 1;
    var gridStep = niceGridStep(totalLen, usableW / 60);
    for (var gz = 0; gz <= totalLen; gz += gridStep) {
      var gp = toCanvas(gz, 0);
      c.beginPath(); c.moveTo(gp.x, marginTB * ch); c.lineTo(gp.x, ch * (1-marginTB)); c.stroke();
    }

    /* ---- Optical axis ---- */
    c.strokeStyle = col.axis;
    c.lineWidth = 1;
    c.setLineDash([4, 3]);
    var axLeftZ = -(preLenZ + totalLen * 0.05);
    var axL = toCanvas(axLeftZ, 0);
    var axR = toCanvas(totalLen*1.05, 0);
    c.beginPath(); c.moveTo(axL.x, axL.y); c.lineTo(axR.x, axR.y); c.stroke();
    c.setLineDash([]);

    /* ---- Draw surfaces & glass fills ---- */
    var zPos = 0;
    for (var i = 0; i < design.surfaces.length; i++) {
      var s = design.surfaces[i];
      var outline = s.outline(40);

      // Is this a glass element? (material is not Air/Vacuum)
      var isGlass = s.material !== M.AIR && s.material !== M.VACUUM && s.material !== M.MIRROR;

      // Draw surface outline
      if (outline.length > 1) {
        c.strokeStyle = (opts.selectedSurface === i) ? col.selected : col.glassEdge;
        c.lineWidth = (opts.selectedSurface === i) ? 2.5 : 1.5;
        if (opts.selectedSurface === i) c.setLineDash([3, 2]);

        c.beginPath();
        for (var j = 0; j < outline.length; j++) {
          var p = toCanvas(zPos + outline[j].z, outline[j].y);
          if (j === 0) c.moveTo(p.x, p.y); else c.lineTo(p.x, p.y);
        }
        c.stroke();
        c.setLineDash([]);
      }

      // Glass fill: connect this surface to next surface
      if (isGlass && i < design.surfaces.length - 1) {
        var nextS = design.surfaces[i + 1];
        var nextZ = zPos + s.thickness;
        var nextOutline = nextS.outline(40);

        if (outline.length > 1 && nextOutline.length > 1) {
          c.fillStyle = col.glass;
          c.beginPath();

          // Forward path: this surface top to bottom
          for (var fi = 0; fi < outline.length; fi++) {
            var fp = toCanvas(zPos + outline[fi].z, outline[fi].y);
            if (fi === 0) c.moveTo(fp.x, fp.y); else c.lineTo(fp.x, fp.y);
          }

          // Reverse path: next surface bottom to top
          for (var ri = nextOutline.length - 1; ri >= 0; ri--) {
            var rp = toCanvas(nextZ + nextOutline[ri].z, nextOutline[ri].y);
            c.lineTo(rp.x, rp.y);
          }

          c.closePath();
          c.fill();
        }
      }

      zPos += s.thickness;
    }

    /* ---- Image plane ---- */
    c.strokeStyle = col.imgPlane;
    c.lineWidth = 1.5;
    c.setLineDash([6, 3]);
    var imgTop = toCanvas(zPos, design.imageRadius);
    var imgBot = toCanvas(zPos, -design.imageRadius);
    c.beginPath(); c.moveTo(imgTop.x, imgTop.y); c.lineTo(imgBot.x, imgBot.y); c.stroke();
    c.setLineDash([]);

    /* ---- Trace & draw rays ---- */
    var beams = T.traceAllBeams2D(design, wavelength);

    for (var bi = 0; bi < beams.length; bi++) {
      var beam = beams[bi];
      c.strokeStyle = beam.color;
      c.lineWidth = 0.8;
      c.globalAlpha = 0.85;

      for (var rsi = 0; rsi < beam.raySegments.length; rsi++) {
        var segs = beam.raySegments[rsi];
        c.beginPath();

        // Draw pre-lens ray (from object/left edge to first surface)
        if (segs.length > 0) {
          var startH = segs[0].y1;
          var inSlope = (beam.inputSlopes && beam.inputSlopes[rsi] !== undefined) ? beam.inputSlopes[rsi] : 0;
          // For compressed view, trace back to full objDist but draw at left edge
          var traceBackDist = (objCompressed) ? objDist : preLenZ;
          var backY = startH - inSlope * traceBackDist;
          var drawZ = -preLenZ; // always draw from left edge of viewport
          var pBack = toCanvas(drawZ, backY);
          c.moveTo(pBack.x, pBack.y);
          var pFirst = toCanvas(segs[0].x1, segs[0].y1);
          c.lineTo(pFirst.x, pFirst.y);
        }

        for (var si = 0; si < segs.length; si++) {
          var seg = segs[si];
          var p1 = toCanvas(seg.x1, seg.y1);
          var p2 = toCanvas(seg.x2, seg.y2);
          if (si === 0) c.moveTo(p1.x, p1.y);
          c.lineTo(p2.x, p2.y);
        }
        // Extend last segment to image plane
        if (segs.length > 0) {
          var lastSeg = segs[segs.length - 1];
          var remain = zPos - lastSeg.x2;
          if (remain > 0.01) {
            var extY = lastSeg.y2 + lastSeg.slope * remain;
            var pe = toCanvas(zPos, extY);
            c.lineTo(pe.x, pe.y);
          }
        }
        c.stroke();
      }
      c.globalAlpha = 1;
    }

    /* ---- Object point marker (finite conjugate) ---- */
    if (isFinite(objDist)) {
      // Place object point at true position or left edge when compressed
      var objDrawZ = objCompressed ? -preLenZ : -objDist;
      var objFieldH = Math.tan(design.fovAngle * Math.PI / 180) * objDist;
      var opP = toCanvas(objDrawZ, 0);

      // Object point dot
      c.fillStyle = '#22c55e';
      c.beginPath(); c.arc(opP.x, opP.y, 5, 0, Math.PI * 2); c.fill();

      // Off-axis object point (if FOV > 0, and within viewport)
      if (objFieldH > 0.5 && objFieldH <= maxAp * 1.2) {
        var opOff = toCanvas(objDrawZ, objFieldH);
        c.beginPath(); c.arc(opOff.x, opOff.y, 3.5, 0, Math.PI * 2); c.fill();
        var opOffN = toCanvas(objDrawZ, -objFieldH);
        c.beginPath(); c.arc(opOffN.x, opOffN.y, 3.5, 0, Math.PI * 2); c.fill();
      }

      // "Obj" label + distance
      c.fillStyle = col.textSub;
      c.font = '10px system-ui, sans-serif';
      c.textAlign = 'center';
      var distLabel = objDist >= 1000 ? (objDist/1000).toFixed(1) + ' m' : objDist.toFixed(0) + ' mm';
      c.fillText('Obj ' + distLabel, opP.x, opP.y - 10);

      // Axis break indicator when compressed
      if (objCompressed) {
        // Position break at 25% between object point and first surface vertex
        var surfP = toCanvas(0, 0);
        var breakGap = (surfP.x - opP.x) * 0.25;
        var breakX = opP.x + Math.max(breakGap, 16);
        var breakW = 12;
        var breakH = 6;
        c.strokeStyle = col.text;
        c.lineWidth = 1.5;
        c.beginPath();
        c.moveTo(breakX - 2, oy);
        c.lineTo(breakX, oy - breakH);
        c.lineTo(breakX + breakW * 0.33, oy + breakH);
        c.lineTo(breakX + breakW * 0.66, oy - breakH);
        c.lineTo(breakX + breakW, oy + breakH);
        c.lineTo(breakX + breakW + 2, oy);
        c.stroke();
      }
    }

    /* ---- Focal dots (paraxial) ---- */
    var focalLen = design.focalLength(wavelength);
    if (isFinite(focalLen)) {
      // Approximate focal point z position
      // For object at infinity, BFP ≈ last surface vertex + paraxial image distance
      var imgDist = design.paraxialImageDist(wavelength);
      if (isFinite(imgDist)) {
        var lastVertZ = 0;
        for (var fv = 0; fv < design.surfaces.length - 1; fv++) {
          lastVertZ += design.surfaces[fv].thickness;
        }
        var fpZ = lastVertZ + imgDist;
        if (fpZ > 0 && fpZ < totalLen * 1.5) {
          var fpP = toCanvas(fpZ, 0);
          c.fillStyle = col.imgPlane;
          c.beginPath(); c.arc(fpP.x, fpP.y, 4, 0, Math.PI * 2); c.fill();
        }
      }
    }

    /* ---- Metrics overlay ---- */
    var metrics = T.computeMetrics(design);
    c.fillStyle = col.text;
    c.font = '12px system-ui, sans-serif';
    c.textAlign = 'left';
    var infoY = 18;
    var infoX = 10;
    if (isFinite(metrics.focalLength)) {
      c.fillText('f = ' + metrics.focalLength.toFixed(2) + ' mm', infoX, infoY);
      infoY += 16;
    }
    if (isFinite(metrics.fNumber)) {
      c.fillText('f/' + metrics.fNumber.toFixed(2), infoX, infoY);
      infoY += 16;
    }
    c.fillStyle = col.textSub;
    c.font = '11px system-ui, sans-serif';
    c.fillText('NA = ' + metrics.NA.toFixed(4), infoX, infoY);

    // Surface labels
    c.font = '10px system-ui, sans-serif';
    c.textAlign = 'center';
    c.fillStyle = col.textSub;
    zPos = 0;
    for (var li = 0; li < design.surfaces.length; li++) {
      var ls = design.surfaces[li];
      var lp = toCanvas(zPos, -ls.aperture - maxAp * 0.08);
      c.fillText('S' + (li + 1), lp.x, lp.y);
      zPos += ls.thickness;
    }
  }

  /** Nice grid step: round to 1, 2, 5, 10, 20, 50 … */
  function niceGridStep(range, minPixPerStep) {
    var rough = range / (minPixPerStep || 5);
    var mag = Math.pow(10, Math.floor(Math.log10(rough)));
    var residual = rough / mag;
    if (residual <= 1) return mag;
    if (residual <= 2) return 2 * mag;
    if (residual <= 5) return 5 * mag;
    return 10 * mag;
  }

  /* ================================================================
   *  SPOT DIAGRAM VIEW
   * ================================================================ */

  /**
   * @param {HTMLCanvasElement} canvas
   * @param {Design} design
   * @param {object} [opts]
   *   .wavelength — override
   *   .fieldAngles — array of field angles (default [0])
   *   .numRays — ray count per angle (default 500)
   */
  function paintSpotDiagram(canvas, design, opts) {
    opts = opts || {};
    var setup = setupCanvas(canvas);
    var c = setup.c, cw = setup.w, ch = setup.h;
    var col = colors();

    c.fillStyle = col.spotBg;
    c.fillRect(0, 0, cw, ch);

    var wavelength = opts.wavelength || design.wavelengthCenter;
    var fieldAngles = opts.fieldAngles || [0];
    var numRays = opts.numRays || 500;

    var panelCount = fieldAngles.length;
    var panelW = cw / panelCount;
    var panelH = ch;
    var spotPadding = 0.15;

    for (var pi = 0; pi < panelCount; pi++) {
      var angle = fieldAngles[pi];
      var spots = T.computeSpotDiagram(design, angle, wavelength, numRays);

      if (spots.length === 0) {
        c.fillStyle = col.textSub;
        c.font = '12px system-ui, sans-serif';
        c.textAlign = 'center';
        c.fillText('No rays', panelW * pi + panelW/2, panelH/2);
        continue;
      }

      // Find bounds
      var minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
      for (var si = 0; si < spots.length; si++) {
        if (spots[si].x < minX) minX = spots[si].x;
        if (spots[si].x > maxX) maxX = spots[si].x;
        if (spots[si].y < minY) minY = spots[si].y;
        if (spots[si].y > maxY) maxY = spots[si].y;
      }

      var rangeX = maxX - minX || 0.01;
      var rangeY = maxY - minY || 0.01;
      var range = Math.max(rangeX, rangeY) * (1 + 2 * spotPadding);
      var cx = (minX + maxX) / 2;
      var cy = (minY + maxY) / 2;
      var spotScale = Math.min(panelW, panelH) / range;
      var offX = panelW * pi + panelW / 2;
      var offY = panelH / 2;

      // Crosshair
      c.strokeStyle = col.axis;
      c.lineWidth = 0.5;
      c.beginPath();
      c.moveTo(offX - panelW * 0.4, offY);
      c.lineTo(offX + panelW * 0.4, offY);
      c.moveTo(offX, offY - panelH * 0.4);
      c.lineTo(offX, offY + panelH * 0.4);
      c.stroke();

      // Airy disk circle (approximate)
      var f = design.focalLength(wavelength);
      var D = design.beamRadius * 2;
      if (isFinite(f) && D > 0) {
        var airyRadius = 1.22 * wavelength * 0.001 * Math.abs(f) / D; // mm
        var airyPx = airyRadius * spotScale;
        if (airyPx > 2 && airyPx < panelW * 0.4) {
          c.strokeStyle = col.imgPlane;
          c.lineWidth = 1;
          c.setLineDash([3, 2]);
          c.beginPath();
          c.arc(offX, offY, airyPx, 0, Math.PI * 2);
          c.stroke();
          c.setLineDash([]);
        }
      }

      // Draw spots
      c.fillStyle = col.spot;
      c.globalAlpha = 0.6;
      for (var di = 0; di < spots.length; di++) {
        var sx = offX + (spots[di].x - cx) * spotScale;
        var sy = offY - (spots[di].y - cy) * spotScale;
        c.fillRect(sx - 1, sy - 1, 2, 2);
      }
      c.globalAlpha = 1;

      // Panel label
      c.fillStyle = col.text;
      c.font = '11px system-ui, sans-serif';
      c.textAlign = 'center';
      c.fillText(angle.toFixed(1) + '°', offX, panelH - 8);

      // RMS spot size
      var sumR2 = 0;
      for (var ri = 0; ri < spots.length; ri++) {
        var ddx = spots[ri].x - cx;
        var ddy = spots[ri].y - cy;
        sumR2 += ddx*ddx + ddy*ddy;
      }
      var rms = Math.sqrt(sumR2 / spots.length) * 1000; // mm → μm
      c.font = '10px system-ui, sans-serif';
      c.fillStyle = col.textSub;
      c.fillText('RMS: ' + rms.toFixed(1) + ' μm', offX, panelH - 22);

      // Panel separator
      if (pi > 0) {
        c.strokeStyle = col.axis;
        c.lineWidth = 0.5;
        c.beginPath();
        c.moveTo(panelW * pi, 0);
        c.lineTo(panelW * pi, panelH);
        c.stroke();
      }
    }
  }

  /* ================================================================
   *  RAY ABERRATION VIEW
   * ================================================================ */

  /**
   * @param {HTMLCanvasElement} canvas
   * @param {Design} design
   * @param {object} [opts]
   *   .wavelength
   *   .fieldAngles — array (default [0])
   *   .numRays
   */
  function paintRayAberration(canvas, design, opts) {
    opts = opts || {};
    var setup = setupCanvas(canvas);
    var c = setup.c, cw = setup.w, ch = setup.h;
    var col = colors();

    c.fillStyle = col.spotBg;
    c.fillRect(0, 0, cw, ch);

    var wavelength = opts.wavelength || design.wavelengthCenter;
    var fieldAngles = opts.fieldAngles || [0];
    var numRays = opts.numRays || 50;

    var panelCount = fieldAngles.length;
    var panelW = cw / panelCount;
    var margin = 0.12;

    for (var pi = 0; pi < panelCount; pi++) {
      var angle = fieldAngles[pi];
      var data = T.computeRayAberration(design, angle, wavelength, numRays);
      if (data.length === 0) continue;

      // Find max |dy|
      var maxDy = 0;
      for (var di = 0; di < data.length; di++) {
        if (Math.abs(data[di].dy) > maxDy) maxDy = Math.abs(data[di].dy);
      }
      if (maxDy < 1e-6) maxDy = 0.01;

      var pxL = panelW * pi + panelW * margin;
      var pxR = panelW * (pi + 1) - panelW * margin;
      var pyT = ch * margin;
      var pyB = ch * (1 - margin);
      var plotW = pxR - pxL;
      var plotH = pyB - pyT;
      var centerX = pxL + plotW / 2;
      var centerY = pyT + plotH / 2;

      // Border
      c.strokeStyle = col.axis;
      c.lineWidth = 1;
      c.strokeRect(pxL, pyT, plotW, plotH);

      // Zero line
      c.strokeStyle = col.axis;
      c.lineWidth = 0.5;
      c.setLineDash([3, 2]);
      c.beginPath();
      c.moveTo(pxL, centerY);
      c.lineTo(pxR, centerY);
      c.moveTo(centerX, pyT);
      c.lineTo(centerX, pyB);
      c.stroke();
      c.setLineDash([]);

      // Plot points & connect
      c.strokeStyle = col.spot;
      c.lineWidth = 1.5;
      c.beginPath();
      for (var j = 0; j < data.length; j++) {
        var px = pxL + (data[j].h + 1) / 2 * plotW;
        var py = centerY - (data[j].dy / maxDy) * (plotH / 2) * 0.9;
        if (j === 0) c.moveTo(px, py); else c.lineTo(px, py);
      }
      c.stroke();

      // Label
      c.fillStyle = col.text;
      c.font = '11px system-ui, sans-serif';
      c.textAlign = 'center';
      c.fillText(angle.toFixed(1) + '°', pxL + plotW/2, pyB + 16);

      // Scale label
      c.font = '9px system-ui, sans-serif';
      c.fillStyle = col.textSub;
      c.textAlign = 'right';
      c.fillText('±' + maxDy.toFixed(3) + ' mm', pxR, pyT - 4);
    }
  }

  /* ================================================================
   *  CHROMATIC ABERRATION TABLE
   * ================================================================ */

  /**
   * @param {HTMLElement} container — will set innerHTML
   * @param {Design} design
   */
  function paintChromaticTable(container, design) {
    var ca = T.computeChromaticAberration(design);
    var col = colors();

    var html = '<table style="width:100%;border-collapse:collapse;font-size:0.8125rem;">';
    html += '<thead><tr style="border-bottom:2px solid ' + col.axis + ';">';
    html += '<th style="text-align:left;padding:6px;">Wavelength</th>';
    html += '<th style="text-align:right;padding:6px;">EFL (mm)</th>';
    html += '</tr></thead><tbody>';

    var rows = [
      { label: 'Short (' + (design.wavelengthShort * 1000).toFixed(0) + ' nm)', val: ca.fShort },
      { label: 'Center (' + (design.wavelengthCenter * 1000).toFixed(0) + ' nm)', val: ca.fCenter },
      { label: 'Long (' + (design.wavelengthLong * 1000).toFixed(0) + ' nm)', val: ca.fLong }
    ];

    for (var i = 0; i < rows.length; i++) {
      html += '<tr style="border-bottom:1px solid ' + col.grid + ';">';
      html += '<td style="padding:6px;">' + rows[i].label + '</td>';
      html += '<td style="text-align:right;padding:6px;font-family:monospace;">';
      html += isFinite(rows[i].val) ? rows[i].val.toFixed(4) : '∞';
      html += '</td></tr>';
    }

    html += '</tbody></table>';
    html += '<div style="margin-top:8px;font-size:0.75rem;color:' + col.textSub + ';">';
    html += 'Axial CA (Δf): <strong>' + (isFinite(ca.axial) ? ca.axial.toFixed(4) : '∞') + ' mm</strong>';
    html += '</div>';

    container.innerHTML = html;
  }

  /* ================================================================
   *  EXPORT
   * ================================================================ */

  win.ODRender = {
    paintCrossSection:     paintCrossSection,
    paintSpotDiagram:      paintSpotDiagram,
    paintRayAberration:    paintRayAberration,
    paintChromaticTable:   paintChromaticTable
  };

})(window);
