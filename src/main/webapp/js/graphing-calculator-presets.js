/**
 * Graphing Calculator Presets
 * Extracted from inline JSP script — loads AFTER graphing-tool-engine.js
 * Depends on: engine, addExpression, updateGraph, updateExpressionType,
 *             updateExpressionValue, updateExpressionColor, toggleDerivative,
 *             toggleIntegration, updateIntegrationBounds
 */
(function(){
  'use strict';

  // ---- helpers ----

  function gcSetExpr(id, type, value, color){
    var typeSel = document.getElementById('type-'+id);
    if (typeSel){ typeSel.value = type; updateExpressionType(id); }
    var input = document.getElementById('expr-'+id);
    if (input){ input.value = value; updateExpressionValue(id); }
    if (color){ var c = document.getElementById('color-'+id); if (c){ c.value = color; updateExpressionColor(id); } }
  }

  function gcAdd(type, value, color){
    if (typeof addExpression==='function') addExpression();
    var items = document.querySelectorAll('[id^=expr-item-]');
    var last = items[items.length-1];
    if(!last) return null;
    var id = parseInt(last.id.replace('expr-item-',''));
    gcSetExpr(id, type, value, color);
    return id;
  }

  // ---- public API ----

  window.gcClearAll = function(){
    try{
      engine.expressions = [];
      var list = document.getElementById('expressions-list'); if (list) list.innerHTML='';
      window.expressionElements = {};
      if (typeof addExpression === 'function') addExpression();
      if (typeof updateGraph === 'function') updateGraph();
    }catch(_){ }
  };

  window.gcQuickSample = function(kind){
    gcClearAll();
    var exprEls = document.querySelectorAll('[id^=expr-item-]');
    if (!exprEls.length) { if (typeof addExpression==='function') addExpression(); }
    var item = document.querySelector('[id^=expr-item-]');
    if (!item) return;
    var id = parseInt(item.id.replace('expr-item-',''));
    var typeSel = document.getElementById('type-'+id);
    switch(kind){
      case 'cartesian':
        if (typeSel){ typeSel.value='cartesian'; updateExpressionType(id); }
        var input = document.getElementById('expr-'+id); if (input){ input.value='sin(x)'; updateExpressionValue(id); }
        break;
      case 'parametric':
        if (typeSel){ typeSel.value='parametric'; updateExpressionType(id); }
        var input2 = document.getElementById('expr-'+id); if (input2){ input2.value='cos(t), sin(t)'; updateExpressionValue(id); }
        break;
      case 'polar':
        if (typeSel){ typeSel.value='polar'; updateExpressionType(id); }
        var input3 = document.getElementById('expr-'+id); if (input3){ input3.value='theta'; updateExpressionValue(id); }
        break;
      case 'implicit':
        if (typeSel){ typeSel.value='implicit'; updateExpressionType(id); }
        var input4 = document.getElementById('expr-'+id); if (input4){ input4.value='x^2 + y^2 = 9'; updateExpressionValue(id); }
        break;
    }
  };

  window.gcQuickPreset = function(name){
    gcClearAll();
    var firstEl = document.querySelector('[id^=expr-item-]');
    if (!firstEl) { if (typeof addExpression==='function') addExpression(); firstEl = document.querySelector('[id^=expr-item-]'); }
    var firstId = parseInt(firstEl.id.replace('expr-item-',''));
    var xMin = document.getElementById('xMin'), xMax = document.getElementById('xMax');
    var yMin = document.getElementById('yMin'), yMax = document.getElementById('yMax');
    function setRange(x0,x1,y0,y1){ if(xMin)xMin.value=x0; if(xMax)xMax.value=x1; if(yMin)yMin.value=y0; if(yMax)yMax.value=y1; }

    switch(name){
      case 'sin_cos':
        gcSetExpr(firstId, 'cartesian', 'sin(x)', '#2563eb');
        gcAdd('cartesian', 'cos(x)', '#f59e0b');
        setRange(-10,10,-2,2);
        break;
      case 'circle_line':
        gcSetExpr(firstId, 'implicit', 'x^2 + y^2 = 9', '#10b981');
        gcAdd('cartesian', 'y = x', '#ef4444');
        setRange(-5,5,-5,5);
        break;
      case 'polar_flowers':
        gcSetExpr(firstId, 'polar', '2*cos(5*theta)', '#a78bfa');
        gcAdd('polar', '2*sin(3*theta)', '#22d3ee');
        setRange(-3,3,-3,3);
        break;
      case 'band_inequality':
        gcSetExpr(firstId, 'inequality', 'y > x - 1', '#f43f5e');
        gcAdd('inequality', 'y < x + 1', '#22c55e');
        setRange(-10,10,-10,10);
        break;
      case 'data_vs_fit':
        gcSetExpr(firstId, 'table', '1, 2\n2, 4.1\n3, 6.0\n4, 8.2\n5, 10.1', '#2563eb');
        gcAdd('cartesian', '2*x', '#f59e0b');
        setRange(0,6,0,12);
        break;
      case 'lissajous':
        gcSetExpr(firstId, 'parametric', 'sin(3*t), sin(4*t)', '#10b981');
        setRange(-1.2, 1.2, -1.2, 1.2);
        break;
      case 'hypotrochoid':
        gcSetExpr(firstId, 'parametric', '2*cos(t), 2*sin(t)', '#a78bfa');
        gcAdd('parametric', '2*cos(t) + 5*cos((2/3)*t), 2*sin(t) - 5*sin((2/3)*t)', '#22d3ee');
        setRange(-8, 8, -8, 8);
        break;
      case 'logistic_exp':
        gcSetExpr(firstId, 'cartesian', '1/(1+exp(-x))', '#22c55e');
        gcAdd('cartesian', '0.2*exp(0.3*x)', '#ef4444');
        setRange(-10, 10, 0, 5);
        break;
      case 'rose_curves':
        gcSetExpr(firstId, 'polar', '2*cos(3*theta)', '#ef4444');
        gcAdd('polar', '2*cos(4*theta)', '#22c55e');
        gcAdd('polar', '2*cos(5*theta)', '#2563eb');
        setRange(-3,3,-3,3);
        break;
      case 'piece_deriv_integral':
        gcSetExpr(firstId, 'cartesian', 'x^2 - 2*x + 1', '#2563eb');
        (function(){
          var cb = document.getElementById('show-derivative-'+firstId);
          if (cb){ cb.checked = true; toggleDerivative(firstId); }
          var ci = document.getElementById('show-integration-'+firstId);
          if (ci){ ci.checked = true; toggleIntegration(firstId); }
          var a = document.getElementById('integration-a-'+firstId);
          var b = document.getElementById('integration-b-'+firstId);
          if (a && b){ a.value = 0; b.value = 2; updateIntegrationBounds(firstId); }
        })();
        gcAdd('piecewise', '', '#10b981');
        setRange(-4,4,-2,6);
        break;
      case 'quad_regression':
        (function(){
          var xs = [], ys = [], pts = [];
          for (var x=-3; x<=3; x+=0.5){
            var noise = (Math.random()-0.5)*0.6;
            var y = 0.5*x*x - 1*x + 2 + noise;
            xs.push(x); ys.push(y);
            pts.push(x.toFixed(2) + ', ' + y.toFixed(2));
          }
          gcSetExpr(firstId, 'table', pts.join('\n'), '#2563eb');
          function quadFit(xs, ys){
            var n = xs.length;
            var s1=0,s2=0,s3=0,s4=0, sx=0, sy=0, sxy=0, sx2y=0;
            for (var i=0;i<n;i++){
              var x=xs[i], y=ys[i];
              var x2=x*x; var x3=x2*x; var x4=x3*x;
              s1 += 1; sx += x; s2 += x2; s3 += x3; s4 += x4;
              sy += y; sxy += x*y; sx2y += x2*y;
            }
            var A = [ [s4, s3, s2], [s3, s2, sx], [s2, sx, s1] ];
            var b = [ sx2y, sxy, sy ];
            try{
              var sol = math.lusolve(A, b);
              var a = sol[0][0], bb = sol[1][0], c = sol[2][0];
              return {a:a, b:bb, c:c};
            }catch(e){ return {a:0.5, b:-1, c:2}; }
          }
          var coeffs = quadFit(xs, ys);
          var expr = coeffs.a.toFixed(3)+'*x^2 + '+coeffs.b.toFixed(3)+'*x + '+coeffs.c.toFixed(3);
          gcAdd('cartesian', expr, '#f59e0b');
          setRange(-3.5,3.5, -1, 7);
        })();
        break;
      case 'fourier_square':
        var pi = Math.PI;
        gcSetExpr(firstId, 'cartesian', '(4/'+pi.toFixed(3)+')*(sin(x))', '#ef4444');
        gcAdd('cartesian', '(4/'+pi.toFixed(3)+')*(sin(x) + (1/3)*sin(3*x))', '#22c55e');
        gcAdd('cartesian', '(4/'+pi.toFixed(3)+')*(sin(x) + (1/3)*sin(3*x) + (1/5)*sin(5*x))', '#2563eb');
        gcAdd('cartesian', '(4/'+pi.toFixed(3)+')*(sin(x) + (1/3)*sin(3*x) + (1/5)*sin(5*x) + (1/7)*sin(7*x))', '#a78bfa');
        setRange(-10,10, -2, 2);
        break;
      case 'spirals':
        gcSetExpr(firstId, 'polar', '0.1*theta', '#2563eb');
        gcAdd('polar', '0.1*exp(0.15*theta)', '#f59e0b');
        setRange(-6,6,-6,6);
        break;
      case 'distributions_overlay':
        var norm = '(1/sqrt(2*pi))*exp(-x^2/2)';
        var t3 = '(gamma((3+1)/2)/(sqrt(3*pi)*gamma(3/2)))* (1 + x^2/3)^(- (3+1)/2)';
        gcSetExpr(firstId, 'cartesian', norm, '#2563eb');
        gcAdd('cartesian', t3, '#ef4444');
        setRange(-5,5, 0, 0.5);
        break;
      case 'deltoid':
        gcSetExpr(firstId, 'parametric', '3*cos(t) - cos(3*t), 3*sin(t) - sin(3*t)', '#22c55e');
        setRange(-4,4,-4,4);
        break;
      case 'lemniscate':
        gcSetExpr(firstId, 'implicit', '(x^2 + y^2)^2 = 8*(x^2 - y^2)', '#a78bfa');
        setRange(-4,4,-4,4);
        break;
      case 'butterfly':
        gcSetExpr(firstId, 'polar', 'exp(sin(theta)) - 2*cos(4*theta) + (sin(theta/12))^5', '#f43f5e');
        setRange(-4,4,-4,4);
        break;

      // ============ CREATIVE CURVES ============
      case 'heart':
        gcSetExpr(firstId, 'parametric', '16*(sin(t))^3, 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)', '#e11d48');
        setRange(-20, 20, -20, 18);
        break;
      case 'spirograph':
        gcSetExpr(firstId, 'parametric', '(5+3)*cos(t) - 5*cos((5+3)/3*t), (5+3)*sin(t) - 5*sin((5+3)/3*t)', '#8b5cf6');
        gcAdd('parametric', '(7+2)*cos(t) - 3*cos((7+2)/2*t), (7+2)*sin(t) - 3*sin((7+2)/2*t)', '#06b6d4');
        setRange(-15, 15, -15, 15);
        break;
      case 'astroid':
        gcSetExpr(firstId, 'parametric', '4*(cos(t))^3, 4*(sin(t))^3', '#f59e0b');
        gcAdd('parametric', '4*cos(t), 4*sin(t)', '#94a3b8');
        setRange(-5, 5, -5, 5);
        break;
      case 'cardioid':
        gcSetExpr(firstId, 'polar', '2*(1 + cos(theta))', '#ec4899');
        gcAdd('polar', '1*(1 - cos(theta))', '#f472b6');
        setRange(-1, 5, -3, 3);
        break;
      case 'golden_spiral':
        var phi = 1.618033988749895;
        gcSetExpr(firstId, 'polar', '0.3 * ' + phi.toFixed(6) + '^(2*theta/pi)', '#d97706');
        gcAdd('cartesian', '0', '#94a3b8');
        setRange(-8, 8, -8, 8);
        break;
      case 'cycloid':
        gcSetExpr(firstId, 'parametric', '2*(t - sin(t)), 2*(1 - cos(t))', '#3b82f6');
        gcAdd('parametric', '2*t - 1*sin(t), 2 - 1*cos(t)', '#10b981');
        gcAdd('parametric', '2*t - 3*sin(t), 2 - 3*cos(t)', '#f43f5e');
        setRange(-2, 15, -2, 8);
        break;
      case 'nephroid':
        gcSetExpr(firstId, 'parametric', '3*cos(t) - cos(3*t), 3*sin(t) - sin(3*t)', '#7c3aed');
        gcAdd('parametric', '4*cos(t), 4*sin(t)', '#94a3b8');
        setRange(-5, 5, -5, 5);
        break;
      case 'limacon':
        gcSetExpr(firstId, 'polar', '1 + 2*cos(theta)', '#ef4444');
        gcAdd('polar', '2 + 2*cos(theta)', '#22c55e');
        gcAdd('polar', '3 + 2*cos(theta)', '#3b82f6');
        gcAdd('polar', '4 + 2*cos(theta)', '#a855f7');
        setRange(-5, 7, -5, 5);
        break;

      // ============ PHYSICS & SCIENCE ============
      case 'damped_oscillation':
        gcSetExpr(firstId, 'cartesian', '5*exp(-0.15*x)*cos(2*x)', '#3b82f6');
        gcAdd('cartesian', '5*exp(-0.15*x)', '#94a3b8');
        gcAdd('cartesian', '-5*exp(-0.15*x)', '#94a3b8');
        gcAdd('cartesian', '5*(1 + 0.5*x)*exp(-0.5*x)', '#f59e0b');
        setRange(-1, 25, -6, 6);
        break;
      case 'catenary':
        gcSetExpr(firstId, 'cartesian', '2*cosh(x/2)', '#0ea5e9');
        gcAdd('cartesian', '0.25*x^2 + 2', '#f43f5e');
        setRange(-5, 5, 0, 8);
        break;
      case 'wave_interference':
        gcSetExpr(firstId, 'cartesian', 'sin(x)', '#3b82f6');
        gcAdd('cartesian', 'sin(x + pi/4)', '#ef4444');
        gcAdd('cartesian', 'sin(x) + sin(x + pi/4)', '#22c55e');
        gcAdd('cartesian', 'sin(5*x) + sin(5.5*x)', '#a855f7');
        setRange(-10, 10, -3, 3);
        break;
      case 'projectile':
        gcSetExpr(firstId, 'cartesian', 'x*tan(pi/6) - (9.8*x^2)/(2*20^2*(cos(pi/6))^2)', '#ef4444');
        gcAdd('cartesian', 'x*tan(pi/4) - (9.8*x^2)/(2*20^2*(cos(pi/4))^2)', '#22c55e');
        gcAdd('cartesian', 'x*tan(pi/3) - (9.8*x^2)/(2*20^2*(cos(pi/3))^2)', '#3b82f6');
        gcAdd('cartesian', 'x*tan(pi/4.5) - (9.8*x^2)/(2*20^2*(cos(pi/4.5))^2)', '#f59e0b');
        setRange(-5, 50, -5, 25);
        break;
      case 'pendulum_phase':
        gcSetExpr(firstId, 'parametric', '0.5*cos(t), 0.5*sin(t)', '#3b82f6');
        gcAdd('parametric', '1*cos(t), 1*sin(t)', '#22c55e');
        gcAdd('parametric', '1.5*cos(t), 1.5*sin(t)', '#f59e0b');
        gcAdd('parametric', '2*cos(t), 2*sin(t)', '#ef4444');
        gcAdd('cartesian', 'sqrt(4 - 2*(1 - cos(x)))', '#a855f7');
        gcAdd('cartesian', '-sqrt(4 - 2*(1 - cos(x)))', '#a855f7');
        setRange(-4, 4, -3, 3);
        break;

      // ============ CLASSIC & HISTORICAL ============
      case 'witch_agnesi':
        gcSetExpr(firstId, 'cartesian', '8/(x^2 + 4)', '#7c3aed');
        gcAdd('parametric', '2*cos(t), 1 + sin(t)', '#94a3b8');
        setRange(-8, 8, -1, 4);
        break;
      case 'folium':
        gcSetExpr(firstId, 'implicit', 'x^3 + y^3 = 3*2*x*y', '#10b981');
        gcAdd('cartesian', '-x - 2', '#94a3b8');
        setRange(-4, 6, -4, 6);
        break;
      case 'cissoid':
        gcSetExpr(firstId, 'parametric', '2*(sin(t))^2, 2*(sin(t))^3/cos(t)', '#0891b2');
        gcAdd('parametric', '1 + cos(t), sin(t)', '#94a3b8');
        gcAdd('cartesian', 'x = 2', '#f43f5e');
        setRange(-1, 4, -4, 4);
        break;
      case 'tractrix':
        gcSetExpr(firstId, 'parametric', '2*(t - tanh(t)), 2/cosh(t)', '#dc2626');
        gcAdd('cartesian', '2*cosh((x-4)/2)', '#94a3b8');
        setRange(-2, 8, -1, 5);
        break;

      // ============ MACHINE LEARNING ============
      case 'activation_functions':
        gcSetExpr(firstId, 'cartesian', '1/(1+exp(-x))', '#3b82f6');
        gcAdd('cartesian', 'tanh(x)', '#22c55e');
        gcAdd('cartesian', 'max(0, x)', '#ef4444');
        gcAdd('cartesian', 'max(0.1*x, x)', '#f59e0b');
        setRange(-5, 5, -1.5, 1.5);
        break;
      case 'sigmoid_tanh':
        gcSetExpr(firstId, 'cartesian', '1/(1+exp(-x))', '#3b82f6');
        gcAdd('cartesian', 'tanh(x)', '#22c55e');
        gcAdd('cartesian', '(1/(1+exp(-x)))*(1 - 1/(1+exp(-x)))', '#93c5fd');
        gcAdd('cartesian', '1 - (tanh(x))^2', '#86efac');
        setRange(-5, 5, -1.2, 1.2);
        break;
      case 'relu_variants':
        gcSetExpr(firstId, 'cartesian', 'max(0, x)', '#ef4444');
        gcAdd('cartesian', 'max(0.1*x, x)', '#f59e0b');
        gcAdd('cartesian', 'max(0.2*x, x)', '#22c55e');
        gcAdd('cartesian', 'log(1 + exp(x))', '#3b82f6');
        gcAdd('cartesian', 'x * (1/(1+exp(-x)))', '#a855f7');
        setRange(-4, 4, -1, 4);
        break;
      case 'loss_functions':
        gcSetExpr(firstId, 'cartesian', 'x^2', '#3b82f6');
        gcAdd('cartesian', 'abs(x)', '#22c55e');
        gcAdd('cartesian', 'x < 1 ? 0.5*x^2 : abs(x) - 0.5', '#f59e0b');
        gcAdd('cartesian', '-log(1/(1+exp(-x)))', '#ef4444');
        setRange(-3, 3, -0.5, 5);
        break;
      case 'softmax':
        gcSetExpr(firstId, 'cartesian', 'exp(x)', '#3b82f6');
        gcAdd('cartesian', 'exp(x)/(exp(-2) + exp(0) + exp(x))', '#22c55e');
        gcAdd('cartesian', 'exp(2*x)/(exp(-4) + exp(0) + exp(2*x))', '#ef4444');
        gcAdd('cartesian', 'exp(0.5*x)/(exp(-1) + exp(0) + exp(0.5*x))', '#f59e0b');
        setRange(-3, 3, 0, 1.2);
        break;
      case 'gradient_descent':
        gcSetExpr(firstId, 'cartesian', 'x^2', '#3b82f6');
        gcAdd('cartesian', '0.5*x^2 + 0.3*sin(5*x)', '#ef4444');
        gcAdd('cartesian', 'abs(x)', '#22c55e');
        gcAdd('cartesian', '4 + 2*(x-2)', '#94a3b8');
        setRange(-4, 4, -0.5, 8);
        break;
      case 'learning_rates':
        gcSetExpr(firstId, 'cartesian', 'exp(-0.1*x)', '#3b82f6');
        gcAdd('cartesian', 'exp(-0.5*x)', '#22c55e');
        gcAdd('cartesian', 'exp(-0.3*x)*cos(2*x)', '#ef4444');
        gcAdd('cartesian', '0.5*exp(-0.2*x) + 0.5', '#f59e0b');
        setRange(0, 15, -0.5, 1.5);
        break;
      case 'regularization':
        gcSetExpr(firstId, 'cartesian', 'x^2', '#3b82f6');
        gcAdd('cartesian', 'abs(x)', '#22c55e');
        gcAdd('cartesian', '0.5*x^2 + 0.5*abs(x)', '#f59e0b');
        gcAdd('implicit', 'x^2 + y^2 = 1', '#93c5fd');
        gcAdd('implicit', 'abs(x) + abs(y) = 1', '#86efac');
        setRange(-2, 2, -2, 2);
        break;
      case 'decision_boundary':
        gcSetExpr(firstId, 'cartesian', '0.5*x + 0.5', '#3b82f6');
        gcAdd('cartesian', '0.2*x^2', '#22c55e');
        gcAdd('cartesian', 'sin(x)', '#ef4444');
        gcAdd('implicit', 'x^2 + y^2 = 4', '#f59e0b');
        setRange(-4, 4, -3, 3);
        break;
      case 'gaussian_distributions':
        gcSetExpr(firstId, 'cartesian', '(1/sqrt(2*pi))*exp(-x^2/2)', '#3b82f6');
        gcAdd('cartesian', '(1/(2*sqrt(2*pi)))*exp(-x^2/(2*4))', '#22c55e');
        gcAdd('cartesian', '(1/(0.5*sqrt(2*pi)))*exp(-x^2/(2*0.25))', '#ef4444');
        gcAdd('cartesian', '(1/sqrt(2*pi))*exp(-(x-2)^2/2)', '#f59e0b');
        setRange(-5, 7, 0, 1);
        break;
      case 'bias_variance':
        gcSetExpr(firstId, 'cartesian', 'sin(x)', '#3b82f6');
        gcAdd('cartesian', '0.2*x', '#ef4444');
        gcAdd('cartesian', 'sin(x) + 0.3*sin(5*x)', '#22c55e');
        gcAdd('cartesian', 'sin(x) + 0.1*sin(3*x)', '#f59e0b');
        setRange(-5, 5, -2, 2);
        break;
      case 'vanishing_gradient':
        gcSetExpr(firstId, 'cartesian', '1/(1+exp(-x))', '#3b82f6');
        gcAdd('cartesian', '(1/(1+exp(-x)))*(1 - 1/(1+exp(-x)))', '#22c55e');
        gcAdd('cartesian', '((1/(1+exp(-x)))*(1 - 1/(1+exp(-x))))^2', '#f59e0b');
        gcAdd('cartesian', '((1/(1+exp(-x)))*(1 - 1/(1+exp(-x))))^4', '#ef4444');
        gcAdd('cartesian', '0.25', '#94a3b8');
        setRange(-5, 5, 0, 0.5);
        break;

      default:
        gcQuickSample('cartesian');
    }
    if (typeof updateGraph==='function') updateGraph();
  };
})();
