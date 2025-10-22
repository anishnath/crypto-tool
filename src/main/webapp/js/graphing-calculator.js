(function(){
  var canvas = document.getElementById('graphCanvas');
  var addBtn = document.getElementById('btnAddExpr');
  var exprList = document.getElementById('exprList');
  var fitBtn = document.getElementById('btnFit');
  var varsForm = document.getElementById('varsForm');
  var statusEl = document.getElementById('gcStatus');

  var graph = new GraphCore(canvas, { workerPath: 'js/graph-worker.js' });
  graph.attachInteractions(canvas);

  function setStatus(msg){
    if (statusEl) statusEl.textContent = 'Status: ' + msg;
    console.debug('[GraphingCalculator]', msg);
  }
  setStatus(graph.workerReady ? 'worker ready' : 'sync mode (no worker)');
  // Expose debug handle
  window.gcDebug = { graph: graph, addExpression: function(t){ addExpression(t||''); }, collect: collectExpressions };

  var colors = ['#3b82f6','#10b981','#ef4444','#f59e0b','#8b5cf6','#22c55e','#06b6d4','#e11d48'];

  function collectExpressions(){
    var items = [].slice.call(exprList.querySelectorAll('.expr-item'));
    var list = items.map(function(item){
      return {
        id: item.dataset.id,
        expr: item.querySelector('.expr-input').value,
        color: item.querySelector('input[type=color]').value
      };
    });
    console.debug('[GraphingCalculator] expressions:', list);
    graph.setExpressions(list);
    graph.render();
  }

  function addExpression(text){
    var id = String(Date.now() + Math.random());
    var color = colors[exprList.children.length % colors.length];
    var div = document.createElement('div');
    div.className = 'expr-item input-group mb-2';
    div.dataset.id = id;
    div.innerHTML =
      '<div class="input-group-prepend"><span class="input-group-text" style="padding:0;border:none;background:transparent;"><input type="color" value="'+color+'" style="width:36px;height:36px;border:none;background:transparent;"></span></div>' +
      '<input type="text" class="form-control expr-input" placeholder="y = f(x)" value="'+(text||'sin(x)')+'">' +
      '<div class="input-group-append"><button class="btn btn-outline-danger btn-sm btnRm" type="button">&times;</button></div>';
    exprList.appendChild(div);
    div.querySelector('.expr-input').addEventListener('input', debounce(collectExpressions, 200));
    div.querySelector('input[type=color]').addEventListener('input', collectExpressions);
    div.querySelector('.btnRm').addEventListener('click', function(){
      exprList.removeChild(div);
      collectExpressions();
    });
    collectExpressions();
  }

  function debounce(fn, ms){
    var t=null; return function(){ clearTimeout(t); var args=arguments; t=setTimeout(function(){ fn.apply(null,args); }, ms); };
  }

  addBtn.addEventListener('click', function(){ addExpression(''); });
  fitBtn.addEventListener('click', function(){
    graph.viewport = { xMin: -10, xMax: 10, yMin: -6, yMax: 6 };
    setStatus(graph.workerReady ? 'worker ready' : 'sync mode (no worker)');
    graph.render();
  });

  varsForm.addEventListener('input', debounce(function(){
    var vars = {};
    [].forEach.call(varsForm.querySelectorAll('input[data-var]'), function(inp){
      var name = inp.getAttribute('data-var');
      var val = parseFloat(inp.value);
      if (isFinite(val)) vars[name] = val;
    });
    graph.setVars(vars);
    graph.render();
  }, 200));

  // Init
  addExpression('sin(x)');
  addExpression('x^2');
  graph.render();
})();
