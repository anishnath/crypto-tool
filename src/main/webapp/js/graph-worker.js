/* Graph Worker: evaluates expressions with expr-eval, returns sampled points.
   Accepts inputs like "y=..." or "f(x)=...". Falls back to a safe local evaluator if CDN is blocked. */
try {
  importScripts('https://cdn.jsdelivr.net/npm/expr-eval@2.0.2/dist/bundle.min.js');
} catch (e) {
  // ignore; we'll fallback below if expr-eval isn't available
}

function preprocess(exprText) {
  var s = String(exprText || '').trim();
  // Accept common prefixes y=..., f(x)=...
  s = s.replace(/^\s*y\s*=\s*/i, '');
  s = s.replace(/^\s*f\s*\(\s*x\s*\)\s*=\s*/i, '');
  // Normalize constants
  s = s.replace(/π/gi, 'PI').replace(/\bpi\b/gi, 'PI');
  return s;
}

// Fallback evaluator: safe-ish wrapper exposing common Math funcs/constants; converts ^ to **.
function compileFallback(expr) {
  var code = expr.replace(/\^/g, '**');
  // Disallow dangerous tokens
  if (/(new|constructor|globalThis|Function|eval|window|self|document|importScripts)/i.test(code)) {
    throw new Error('Unsafe expression');
  }
  // Provide common Math functions directly: sin, cos, tan, asin, acos, atan, log (ln), sqrt, abs, exp, pow, floor, ceil, round, min, max
  /* eslint no-new-func: "off" */
  var fn = new Function(
    'x','a','b','k','E','PI',
    'sin','cos','tan','asin','acos','atan',
    'log','ln','sqrt','abs','exp','pow',
    'floor','ceil','round','min','max',
    'Math',
    'return (' + code + ');'
  );
  return {
    evaluate: function(scope) {
      var x = +scope.x;
      var a = +scope.a || 0, b = +scope.b || 0, k = +scope.k || 0;
      var E = Math.E, PI = Math.PI;
      return fn(
        x, a, b, k, E, PI,
        Math.sin, Math.cos, Math.tan, Math.asin, Math.acos, Math.atan,
        Math.log, Math.log, Math.sqrt, Math.abs, Math.exp, Math.pow,
        Math.floor, Math.ceil, Math.round, Math.min, Math.max,
        Math
      );
    }
  };
}

self.onmessage = function(ev){
  var data = ev.data;
  if (data.type === 'sample'){
    var vp = data.viewport;
    var samples = Math.max(100, Math.min(5000, data.samples|0));
    var step = (vp.xMax - vp.xMin) / samples;
    var series = [];
    var Parser = self.exprEval && self.exprEval.Parser;

    for (var i=0;i<data.expressions.length;i++){
      var item = data.expressions[i];
      var exprText = preprocess(item && item.expr ? item.expr : '');
      var color = (item && item.color) || '#3b82f6';
      var points = [];
      var compiled = null;

      try {
        if (Parser) {
          var parser = new Parser({ operators: { '^': true } });
          compiled = parser.parse(exprText);
        } else {
          compiled = compileFallback(exprText);
        }
      } catch(e){
        // parsing failed; return empty series so UI keeps running
        series.push({ color: color, points: [] });
        continue;
      }

      var lastOk = false;
      for (var k=0;k<=samples;k++){
        var x = vp.xMin + k * step;
        var scope = Object.assign({ x: x, E: Math.E, PI: Math.PI }, (data.vars || {}));
        var y = null;
        try {
          y = compiled.evaluate(scope);
        } catch(err){ y = null; }
        if (typeof y !== 'number' || !isFinite(y)){
          points.push(null);
          lastOk = false;
        } else {
          if (Math.abs(y) > 1e12){
            points.push(null);
            lastOk = false;
          } else {
            if (lastOk && points.length > 0) {
              var prev = points[points.length-1];
              if (prev && Math.abs(y - prev[1]) > (vp.yMax - vp.yMin) * 3){
                points.push(null);
              }
            }
            points.push([x, y]);
            lastOk = true;
          }
        }
      }
      series.push({ color: color, points: points });
    }

    self.postMessage({ type: 'sampleResult', series: series });
  }
};
