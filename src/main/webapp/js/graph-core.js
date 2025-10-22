/* GraphCore: canvas renderer with axes/grid, pan/zoom, and worker-backed sampling */
(function(global){
  function GraphCore(canvas, opts){
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.dpr = window.devicePixelRatio || 1;
    this.viewport = Object.assign({ xMin: -10, xMax: 10, yMin: -6, yMax: 6 }, (opts && opts.viewport || {}));
    this.expressions = []; // [{id, expr, color}]
    this.vars = {}; // additional variables e.g., a, b, k
    // Try to create worker; if it fails, we'll fall back to sync sampling
    this.worker = null;
    this.workerReady = false;
    this.mode = 'init';
    try {
      this.worker = new Worker((opts && opts.workerPath) || 'js/graph-worker.js');
      this.workerReady = true;
      this.mode = 'worker';
    } catch (e) {
      console.warn('[GraphCore] Worker creation failed, switching to sync mode:', e);
      this.workerReady = false;
      this.mode = 'sync';
    }
    this.pending = 0;
    this.samplesPerPx = 1; // samples ~= width * samplesPerPx
    this._bindWorker();
    this._bindResize();
    this.resize();
    this._lastData = null;
  }

  GraphCore.prototype._bindWorker = function(){
    var self = this;
    if (!this.worker) return;
    this.worker.onmessage = function(ev){
      var data = ev.data;
      if (data && data.type === 'sampleResult'){
        self._lastData = data.series || [];
        self._draw();
        self.pending = Math.max(0, self.pending - 1);
      }
    };
    this.worker.onerror = function(err){
      console.error('[GraphCore] Worker error:', err);
      try { self.worker.terminate(); } catch(e){}
      self.worker = null;
      self.workerReady = false;
      self.mode = 'sync';
      // re-render using sync fallback
      self.render();
    };
  };

  GraphCore.prototype._bindResize = function(){
    var self = this;
    window.addEventListener('resize', function(){ self.resize(); self.render(); });
  };

  GraphCore.prototype.resize = function(){
    var cssW = this.canvas.clientWidth || 600;
    var cssH = this.canvas.clientHeight || 360;
    this.canvas.width = Math.max(1, Math.floor(cssW * this.dpr));
    this.canvas.height = Math.max(1, Math.floor(cssH * this.dpr));
  };

  GraphCore.prototype.setExpressions = function(list){
    this.expressions = (list || []).slice(0, 12); // safety cap
  };

  GraphCore.prototype.setVars = function(vars){
    this.vars = vars || {};
  };

  GraphCore.prototype.worldToScreen = function(x, y){
    var W = this.canvas.width, H = this.canvas.height;
    var vx = this.viewport, sx = (x - vx.xMin) / (vx.xMax - vx.xMin) * W;
    var sy = H - (y - vx.yMin) / (vx.yMax - vx.yMin) * H;
    return { x: sx, y: sy };
  };

  GraphCore.prototype.screenToWorld = function(sx, sy){
    var W = this.canvas.width, H = this.canvas.height;
    var vx = this.viewport;
    var x = vx.xMin + (sx / W) * (vx.xMax - vx.xMin);
    var y = vx.yMin + ((H - sy) / H) * (vx.yMax - vx.yMin);
    return { x: x, y: y };
  };

  GraphCore.prototype.panPx = function(dxPx, dyPx){
    var vx = this.viewport, W = this.canvas.width, H = this.canvas.height;
    var dx = dxPx / W * (vx.xMax - vx.xMin);
    var dy = -dyPx / H * (vx.yMax - vx.yMin);
    this.viewport.xMin += dx; this.viewport.xMax += dx;
    this.viewport.yMin += dy; this.viewport.yMax += dy;
    this.render();
  };

  GraphCore.prototype.zoom = function(factor, centerSx, centerSy){
    var vx = this.viewport;
    var c = this.screenToWorld(centerSx, centerSy);
    var rx = (vx.xMax - vx.xMin) * factor;
    var ry = (vx.yMax - vx.yMin) * factor;
    // keep center fixed
    vx.xMin = c.x - rx * (centerSx / this.canvas.width);
    vx.xMax = vx.xMin + rx;
    vx.yMax = c.y + ry * ((this.canvas.height - centerSy) / this.canvas.height);
    vx.yMin = vx.yMax - ry;
    this.render();
  };

  GraphCore.prototype._niceStep = function(range){
    var exp = Math.floor(Math.log10(range)) - 1;
    var base = Math.pow(10, exp);
    var steps = [1, 2, 5, 10];
    var best = steps[0]*base, minDiff = Infinity;
    for (var i=0;i<steps.length;i++){
      var s = steps[i]*base;
      var count = range / s;
      var diff = Math.abs(count - 10);
      if (diff < minDiff){ minDiff = diff; best = s; }
    }
    return best;
    };

  GraphCore.prototype._drawAxes = function(){
    var ctx = this.ctx, W = this.canvas.width, H = this.canvas.height;
    ctx.save();
    ctx.scale(this.dpr, this.dpr); // logical CSS units
    ctx.clearRect(0, 0, W, H);
    ctx.scale(1/this.dpr, 1/this.dpr);
    // redraw at device pixels
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0,0,W,H);

    // grid
    var vx = this.viewport;
    var xRange = vx.xMax - vx.xMin, yRange = vx.yMax - vx.yMin;
    var xStep = this._niceStep(xRange);
    var yStep = this._niceStep(yRange);
    ctx.strokeStyle = '#e5e7eb';
    ctx.lineWidth = 1;
    ctx.beginPath();
    // vertical lines
    var x0 = Math.ceil(vx.xMin / xStep) * xStep;
    for (var x=x0; x<=vx.xMax; x+=xStep){
      var p = this.worldToScreen(x, 0);
      ctx.moveTo(p.x, 0); ctx.lineTo(p.x, H);
    }
    // horizontal lines
    var y0 = Math.ceil(vx.yMin / yStep) * yStep;
    for (var y=y0; y<=vx.yMax; y+=yStep){
      var p2 = this.worldToScreen(0, y);
      ctx.moveTo(0, p2.y); ctx.lineTo(W, p2.y);
    }
    ctx.stroke();

    // axes
    ctx.strokeStyle = '#9ca3af';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    var pY = this.worldToScreen(0, 0);
    if (pY.x >= 0 && pY.x <= W){ ctx.moveTo(pY.x, 0); ctx.lineTo(pY.x, H); }
    if (pY.y >= 0 && pY.y <= H){ ctx.moveTo(0, pY.y); ctx.lineTo(W, pY.y); }
    ctx.stroke();

    // ticks
    ctx.fillStyle = '#6b7280';
    ctx.font = '12px system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial';
    for (x=x0; x<=vx.xMax; x+=xStep){
      var ps = this.worldToScreen(x, 0);
      if (ps.x < 0 || ps.x > W) continue;
      ctx.fillText(String(Math.round(x*1000)/1000), ps.x+2, Math.min(H-2, pY.y-2));
    }
    for (y=y0; y<=vx.yMax; y+=yStep){
      var ps2 = this.worldToScreen(0, y);
      if (ps2.y < 0 || ps2.y > H) continue;
      ctx.fillText(String(Math.round(y*1000)/1000), Math.min(W-40, ps2.x+4), ps2.y-2);
    }
    ctx.restore();
  };

  GraphCore.prototype._drawSeries = function(series){
    if (!series) return;
    var ctx = this.ctx, W = this.canvas.width, H = this.canvas.height;
    ctx.save();
    ctx.lineWidth = 2;
    for (var i=0;i<series.length;i++){
      var s = series[i];
      ctx.strokeStyle = s.color || '#3b82f6';
      ctx.beginPath();
      var started = false;
      for (var k=0; k<s.points.length; k++){
        var pt = s.points[k];
        if (pt === null){ started = false; continue; }
        var p = this.worldToScreen(pt[0], pt[1]);
        if (!started){ ctx.moveTo(p.x, p.y); started = true; }
        else { ctx.lineTo(p.x, p.y); }
      }
      ctx.stroke();
    }
    ctx.restore();
  };

  GraphCore.prototype.render = function(){
    // axes first
    this._drawAxes();

    var widthCSS = Math.max(300, Math.floor(this.canvas.width / this.dpr));
    var samples = Math.min(1600, Math.max(200, Math.floor(widthCSS * this.samplesPerPx)));

    if (this.workerReady && this.worker) {
      var msg = {
        type: 'sample',
        viewport: this.viewport,
        expressions: this.expressions,
        vars: this.vars,
        samples: samples
      };
      this.pending++;
      try {
        this.worker.postMessage(msg);
      } catch (e) {
        console.warn('[GraphCore] postMessage failed, switching to sync mode:', e);
        this.workerReady = false;
        this.mode = 'sync';
        var series = this._sampleSync(this.viewport, this.expressions, this.vars, samples);
        this._lastData = series;
        this._draw();
      }
    } else {
      // Sync fallback
      var series = this._sampleSync(this.viewport, this.expressions, this.vars, samples);
      this._lastData = series;
      this._draw();
    }
  };

  GraphCore.prototype._draw = function(){
    this._drawAxes();
    this._drawSeries(this._lastData);
  };

  // ---- Sync fallback sampling (used when worker unavailable) ----
  GraphCore.prototype._preprocess = function(s){
    s = String(s || '').trim();
    s = s.replace(/^\s*y\s*=\s*/i, '');
    s = s.replace(/^\s*f\s*\(\s*x\s*\)\s*=\s*/i, '');
    s = s.replace(/π/gi, 'PI').replace(/\bpi\b/gi, 'PI');
    return s;
  };
  GraphCore.prototype._compileFallback = function(expr){
    var code = String(expr || '').replace(/\^/g, '**');
    if (/(new|constructor|globalThis|Function|eval|window|self|document|importScripts)/i.test(code)) {
      throw new Error('Unsafe expression');
    }
    /* eslint no-new-func: "off" */
    var fn = new Function(
      'x','a','b','k','E','PI',
      'sin','cos','tan','asin','acos','atan',
      'log','ln','sqrt','abs','exp','pow',
      'floor','ceil','round','min','max',
      'Math',
      'return (' + code + ');'
    );
    return function(scope){
      var x = +scope.x, a = +scope.a || 0, b = +scope.b || 0, k = +scope.k || 0;
      return fn(
        x, a, b, k, Math.E, Math.PI,
        Math.sin, Math.cos, Math.tan, Math.asin, Math.acos, Math.atan,
        Math.log, Math.log, Math.sqrt, Math.abs, Math.exp, Math.pow,
        Math.floor, Math.ceil, Math.round, Math.min, Math.max,
        Math
      );
    };
  };
  GraphCore.prototype._sampleSync = function(vp, expressions, vars, samples){
    try { samples = Math.max(100, Math.min(5000, samples|0)); } catch(e){ samples = 600; }
    var step = (vp.xMax - vp.xMin) / samples;
    var series = [];
    for (var i=0;i<(expressions||[]).length;i++){
      var item = expressions[i] || {};
      var exprText = this._preprocess(item.expr || '');
      var color = item.color || '#3b82f6';
      var evalFn;
      try {
        evalFn = this._compileFallback(exprText);
      } catch (e) {
        console.warn('[GraphCore] compile fallback failed:', e);
        series.push({ color: color, points: [] });
        continue;
      }
      var pts = [], lastOk = false;
      for (var k=0;k<=samples;k++){
        var x = vp.xMin + k * step;
        var scope = Object.assign({ x: x, E: Math.E, PI: Math.PI }, (vars || {}));
        var y = null;
        try { y = evalFn(scope); } catch (err) { y = null; }
        if (typeof y !== 'number' || !isFinite(y) || Math.abs(y) > 1e12){
          pts.push(null); lastOk = false;
        } else {
          if (lastOk && pts.length > 0){
            var prev = pts[pts.length-1];
            if (prev && Math.abs(y - prev[1]) > (vp.yMax - vp.yMin) * 3){ pts.push(null); }
          }
          pts.push([x, y]); lastOk = true;
        }
      }
      series.push({ color: color, points: pts });
    }
    return series;
  };

  // Interaction helpers
  GraphCore.prototype.attachInteractions = function(el){
    var self = this;
    var dragging = false, last = null;
    el.addEventListener('mousedown', function(e){ dragging=true; last={x:e.clientX, y:e.clientY}; });
    window.addEventListener('mouseup', function(){ dragging=false; });
    window.addEventListener('mousemove', function(e){
      if (!dragging) return;
      self.panPx(e.clientX - last.x, e.clientY - last.y);
      last = {x:e.clientX, y:e.clientY};
    });
    el.addEventListener('wheel', function(e){
      var factor = e.deltaY < 0 ? 0.9 : 1.1;
      var rect = el.getBoundingClientRect();
      var sx = (e.clientX - rect.left) * (self.dpr);
      var sy = (e.clientY - rect.top) * (self.dpr);
      self.zoom(factor, sx, sy);
      e.preventDefault();
    }, { passive: false });
    // double click to reset
    el.addEventListener('dblclick', function(){
      self.viewport = { xMin: -10, xMax: 10, yMin: -6, yMax: 6 };
      self.render();
    });
  };

  global.GraphCore = GraphCore;
})(window);
