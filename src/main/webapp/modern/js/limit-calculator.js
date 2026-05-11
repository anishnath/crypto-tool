/**
 * Limit Calculator — DOM/UI logic.
 *
 * Depends on (loaded in order by
 *   math/partials/limit-calculator-scripts.jsp):
 *     · KaTeX, nerdamer (core + Algebra + Calculus)   — from math-libs.jsp
 *     · IntegralCalculatorCore                         — from this partial
 *     · LimitCalculatorCore                            — from this partial
 *
 * ID contract:
 *   · #ic-expr           — shared math-input text field (math-input-setup.jsp)
 *   · #lc-*              — limit-specific elements (point, dir-toggle,
 *                          result content, graph, python tab, etc.)
 *
 * Moved from /js/limit-calculator.js to /modern/js/limit-calculator.js
 * during the math-tool migration so all calculator scripts share one
 * directory; see math/MIGRATION_TEMPLATE.md.
 */
(function(){
'use strict';
var CTX=window.__LC_CTX||'';
var normalizeExpr=(typeof LimitCalculatorCore!=='undefined'&&LimitCalculatorCore.normalizeExpr)?LimitCalculatorCore.normalizeExpr:function(e){return(e&&e.trim)?e.trim():'';};
// Pure-compute helpers + step generator live in LimitCalculatorCore so the
// LaTeX editor can solve limits inline. Local aliases keep this file's
// existing call sites unchanged.
var parsePoint=LimitCalculatorCore.parsePoint;
var computeLimit=LimitCalculatorCore.compute;
var splitFraction=LimitCalculatorCore.splitFraction;
var exprToLatex=LimitCalculatorCore.exprToLatex;
var pointToLatex=LimitCalculatorCore.pointToLatex;
var generateLimitSteps=LimitCalculatorCore.generateSteps;
var exprInput=document.getElementById('ic-expr');
var previewEl=document.getElementById('lc-preview');
var varSelect=document.getElementById('lc-var');
var pointInput=document.getElementById('lc-point');
var calcBtn=document.getElementById('lc-calculate-btn');
var resultContent=document.getElementById('lc-result-content');
var resultActions=document.getElementById('lc-result-actions');
var emptyState=document.getElementById('lc-empty-state');
var graphHint=document.getElementById('lc-graph-hint');
var currentDir='two-sided';
var lastResultLatex='';
var lastResultText='';
var compilerLoaded=false;
var pendingGraph=null;
var lastLimitContext=null;

window.toggleFaq=function(btn){btn.parentElement.classList.toggle('open');};

// Direction toggle
var dirBtns=document.querySelectorAll('.lc-dir-btn');
dirBtns.forEach(function(btn){
    btn.addEventListener('click',function(){
        var dir=this.getAttribute('data-dir');
        if(dir===currentDir)return;
        currentDir=dir;
        dirBtns.forEach(function(b){b.classList.remove('active');});
        this.classList.add('active');
        updatePreview();
    });
});

// Output tabs
// Tab/panel classes are SHARED across all migrated calc pages — they're
// styled in math-studio.css as `.ic-output-tab` / `.ic-panel` and we
// reuse the same selectors for click-binding.  (The IDs stay
// tool-specific: `lc-panel-result/graph/python`.)
var tabBtns=document.querySelectorAll('.ic-output-tab');
var panels=document.querySelectorAll('.ic-panel');
tabBtns.forEach(function(btn){
    btn.addEventListener('click',function(){
        var panel=this.getAttribute('data-panel');
        tabBtns.forEach(function(b){b.classList.remove('active');});
        panels.forEach(function(p){p.classList.remove('active');});
        this.classList.add('active');
        document.getElementById('lc-panel-'+panel).classList.add('active');
        if(panel==='graph'&&pendingGraph){loadPlotly(function(){renderGraph(pendingGraph);});}
        if(panel==='python'&&!compilerLoaded){loadCompilerWithTemplate();compilerLoaded=true;}
    });
});

// Syntax help
var syntaxBtn=document.getElementById('lc-syntax-btn');
var syntaxContent=document.getElementById('lc-syntax-content');
syntaxBtn.addEventListener('click',function(){
    syntaxContent.classList.toggle('open');
    var chev=syntaxBtn.querySelector('.lc-syntax-chevron');
    chev.style.transform=syntaxContent.classList.contains('open')?'rotate(180deg)':'';
});

// Quick examples
document.getElementById('lc-examples').addEventListener('click',function(e){
    var chip=e.target.closest('.lc-example-chip');
    if(!chip)return;
    exprInput.value=chip.getAttribute('data-expr');
    pointInput.value=chip.getAttribute('data-point');
    var dir=chip.getAttribute('data-dir')||'two-sided';
    currentDir=dir;
    dirBtns.forEach(function(b){b.classList.toggle('active',b.getAttribute('data-dir')===dir);});
    updatePreview();
    exprInput.focus();
});

// Live preview
var previewTimer=null;
exprInput.addEventListener('input',function(){
    // Eagerly auto-fill var / point / direction if the user typed a
    // semantic limit operator (lim_(x->a) f(x) — common in MathLive
    // visual mode).  Side-effects only — exprInput.value is left alone
    // and only stripped at submit time inside doCalculateLimit().
    // Done immediately (not in the debounce) so the Calculate button
    // enables on the same keystroke that completed the operator.
    var pointBefore = pointInput.value;
    unwrapSemanticLimit(exprInput.value.trim(), {
        varSelect: varSelect,
        pointInput: pointInput,
        dirButtons: dirBtns,
        onDirChange: function (d) { currentDir = d; }
    });
    // Programmatic .value = ... does NOT fire an input event.  If the
    // unwrap populated the point, dispatch one ourselves so any UX
    // listener (e.g. limit-calculator2.jsp's enable-state IIFE) sees it.
    if (pointInput.value !== pointBefore && document.activeElement !== pointInput) {
        pointInput.dispatchEvent(new Event('input', { bubbles: true }));
    }
    clearTimeout(previewTimer);
    previewTimer = setTimeout(updatePreview, 200);
});
pointInput.addEventListener('input',function(){clearTimeout(previewTimer);previewTimer=setTimeout(updatePreview,200);});
varSelect.addEventListener('change',updatePreview);

function updatePreview(){
    // Pure unwrap (no side effects) so the live KaTeX preview shows just
    // the inner f(x) — not the lim_(x->a) operator wrapped around itself.
    var raw=unwrapSemanticLimit(exprInput.value.trim());
    var v=varSelect.value;
    var pt=pointInput.value.trim()||'a';
    if(!raw){previewEl.innerHTML='<span style="color:var(--text-muted);font-size:0.8125rem;">Type a function above\u2026</span>';return;}
    var expr=normalizeExpr(raw);
    try{
        var latex=exprToLatex(expr);
        var ptLatex=pointToLatex(pt);
        var arrow=v+'\\to '+ptLatex;
        if(currentDir==='left')arrow+='^{-}';
        else if(currentDir==='right')arrow+='^{+}';
        var limLatex='\\lim_{'+arrow+'}\\left['+latex+'\\right]';
        katex.render(limLatex,previewEl,{displayMode:true,throwOnError:false});
    }catch(e){
        previewEl.innerHTML='<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
    }
}


// parsePoint moved to LimitCalculatorCore.parsePoint (aliased above as parsePoint)

// Main limit calculation
calcBtn.addEventListener('click',doCalculateLimit);
exprInput.addEventListener('keydown',function(e){if(e.key==='Enter')doCalculateLimit();});
pointInput.addEventListener('keydown',function(e){if(e.key==='Enter')doCalculateLimit();});

/**
 * Unwrap semantic "full-notation" limit input.
 *
 * Students copying from a textbook (or using MathLive's visual mode with
 * the \lim_{x \to 0} \sin(x)/x glyph) end up with an ascii-math string
 * like:
 *     lim_(x->0) (sin(x))/x
 * Raw nerdamer can't parse that — `lim_(...)` is not a recognised
 * operator.  doCalculateLimit() expects JUST the function in #ic-expr,
 * with the variable, point, and direction in their own fields.
 *
 * This pre-parser runs before normalizeExpr, extracting:
 *   · the limit operator `lim_(VAR -> POINT [^+|^-])` — variable,
 *     approach point, optional one-sided marker
 *   · wrapping brackets `[f(x)]` / `(f(x))` / `{f(x)}` around the body
 *
 * `oo` (ascii-math infinity) is normalised to `infinity` so parsePoint
 * accepts it.
 *
 * Returns the cleaned expression (or the original if nothing matched).
 * `opts` is optional — omit for pure / side-effect-free usage (e.g. live
 * preview).  When provided:
 *   opts.varSelect    — <select id="lc-var">
 *   opts.pointInput   — <input id="lc-point">
 *   opts.dirButtons   — NodeList of .lc-dir-btn (the segment toggle)
 */
function unwrapSemanticLimit(raw, opts) {
    if (!raw || typeof raw !== 'string') return raw;
    opts = opts || {};
    var s = raw.trim();

    // ── 1. Detect the lim_(VAR -> POINT [^+/^-]) operator ────────────────
    // Accept arrow forms: ->, →, rarr.  REQUIRE the subscript to be
    // bracket-wrapped — `{...}` or `(...)` — so the non-greedy point
    // capture knows where to stop.  MathLive's ascii output for
    // \lim_{x \to 0} is `lim_(x->0)`, which fits.  If a tool consumer
    // ever wants to support plain `lim x->a f(x)` (no brackets), add
    // a separate regex branch — for now we require the brackets that
    // every visual editor produces.
    var limRe = /^\s*lim\s*_\s*[\{\(]\s*([a-z])\s*(?:->|\u2192|rarr|\\to)\s*((?:-\s*)?[a-z0-9.+\-*\/\^]+?)(?:\s*\^\s*[\{\(]?\s*([+\-])\s*[\}\)]?)?\s*[\}\)]\s*/i;
    var m = s.match(limRe);
    if (m) {
        var detectedVar = m[1].toLowerCase();
        var rawPoint    = m[2].trim();
        var dirSign     = m[3] || '';

        // ascii-math 'oo' → 'infinity' (and '-oo' → '-infinity').
        // parsePoint() recognises 'infinity' / '-infinity' / 'inf' / '-inf'.
        var normPoint = rawPoint
            .replace(/(^|[^a-z])oo\b/gi, '$1infinity')
            .replace(/\u221e/g, 'infinity')
            .trim();

        if (opts.varSelect) {
            var opt = opts.varSelect.querySelector('option[value="' + detectedVar + '"]');
            if (opt) opts.varSelect.value = detectedVar;
        }
        if (opts.pointInput && !opts.pointInput.value.trim()) {
            opts.pointInput.value = normPoint;
        }
        if (dirSign && opts.dirButtons) {
            var wantDir = dirSign === '+' ? 'right' : 'left';
            opts.dirButtons.forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-dir') === wantDir);
            });
            if (opts.onDirChange) opts.onDirChange(wantDir);
        }
        s = s.slice(m[0].length).trim();
    }

    // ── 2. Strip one wrapping bracket pair around the function body ──────
    var sqWrap = s.match(/^\[([\s\S]+)\]$/);
    if (sqWrap) s = sqWrap[1].trim();
    var crWrap = s.match(/^\{([\s\S]+)\}$/);
    if (crWrap) s = crWrap[1].trim();
    if (s.charAt(0) === '(' && s.charAt(s.length - 1) === ')') {
        var depth = 0, balanced = true;
        for (var i = 0; i < s.length; i++) {
            if (s.charAt(i) === '(') depth++;
            else if (s.charAt(i) === ')') depth--;
            if (depth === 0 && i < s.length - 1) { balanced = false; break; }
        }
        if (balanced) s = s.slice(1, -1).trim();
    }

    return s || raw;
}

function doCalculateLimit(){
    // Pre-parse semantic input: lim_(x->a) f(x) and bracket wrappers.
    // Side effects auto-fill var / point / direction when the user typed
    // them inside the math-field (MathLive visual mode).
    var raw = unwrapSemanticLimit(exprInput.value.trim(), {
        varSelect: varSelect,
        pointInput: pointInput,
        dirButtons: dirBtns,
        onDirChange: function (d) { currentDir = d; }
    });
    var v=varSelect.value;
    var ptStr=pointInput.value.trim();
    if(!raw){if(typeof ToolUtils!=='undefined')ToolUtils.showToast('Please enter a function.',2000,'warning');return;}
    if(!ptStr){if(typeof ToolUtils!=='undefined')ToolUtils.showToast('Please enter a limit point.',2000,'warning');return;}
    var a=parsePoint(ptStr);
    if(a===null){if(typeof ToolUtils!=='undefined')ToolUtils.showToast('Invalid limit point.',2000,'warning');return;}

    var expr=normalizeExpr(raw);
    try{
        var result=computeLimit(expr,v,a,currentDir);
        showResult(expr,v,ptStr,a,result);
        prepareGraph(expr,v,a,result);
        resultActions.classList.add('visible');
        if(emptyState)emptyState.style.display='none';
    }catch(err){
        showError(raw,err.message);
    }
}


// Display result
function showResult(expr,v,ptStr,a,result){
    var exprTeX=exprToLatex(expr);
    var ptLatex=pointToLatex(ptStr);
    var arrow=v+'\\to '+ptLatex;
    if(currentDir==='left')arrow+='^{-}';
    else if(currentDir==='right')arrow+='^{+}';

    var valueStr;var valueLatex;
    if(result.value==='DNE'){valueStr='Does Not Exist';valueLatex='\\text{Does Not Exist}';}
    else if(result.value===Infinity){valueStr='\u221E';valueLatex='\\infty';}
    else if(result.value===-Infinity){valueStr='-\u221E';valueLatex='-\\infty';}
    else if(typeof result.value==='number'){
        valueStr=Number.isInteger(result.value)?result.value.toString():result.value.toFixed(6).replace(/0+$/,'').replace(/\.$/,'');
        valueLatex=valueStr;
    }else{valueStr=String(result.value);valueLatex=valueStr;}

    lastResultLatex='\\lim_{'+arrow+'}'+exprTeX+' = '+valueLatex;
    lastResultText='lim('+v+'->'+ptStr+') '+expr+' = '+valueStr;
    lastLimitContext={expr:expr,v:v,ptStr:ptStr,a:a,dir:currentDir,result:result,exprTeX:exprTeX,arrow:arrow,valueLatex:valueLatex,valueStr:valueStr};

    var html='<div class="lc-result-math">';
    html+='<div class="lc-result-label">Limit Expression</div>';
    html+='<div id="lc-r-expr"></div>';
    html+='<div class="lc-result-label" style="margin-top:1rem;">Result</div>';
    html+='<div class="lc-result-main" id="lc-r-value"></div>';
    html+='<div class="lc-result-detail">';
    html+='<span class="lc-method-badge">'+escapeHtml(result.method)+'</span>';
    if(result.form)html+=' <span class="lc-form-badge">Indeterminate: '+escapeHtml(result.form)+'</span>';
    html+='</div>';

    if(typeof result.value==='number'&&isFinite(result.value)){
        html+='<div class="lc-result-value">'+escapeHtml(valueStr)+'</div>';
    }

    // Approximation table
    if(result.approxTable){
        html+=buildApproxTableHtml(result.approxTable,a);
    }

    html+='<button type="button" class="lc-steps-btn" id="lc-steps-btn" onclick="showSteps()">&#128221; Show Steps</button>';
    html+='<div id="lc-steps-area"></div>';
    html+='</div>';
    resultContent.innerHTML=html;

    katex.render('\\lim_{'+arrow+'}\\left['+exprTeX+'\\right]',document.getElementById('lc-r-expr'),{displayMode:true,throwOnError:false});
    katex.render(valueLatex,document.getElementById('lc-r-value'),{displayMode:true,throwOnError:false});
}

// buildApproxTable moved to LimitCalculatorCore.buildApproxTable
function buildApproxTableHtml(table,a){
    var html='';
    if(table.left&&table.left.length>0){
        html+='<table class="lc-approx-table"><thead><tr><th>x (from left)</th><th>f(x)</th></tr></thead><tbody>';
        for(var i=0;i<table.left.length;i++){
            var r=table.left[i];
            html+='<tr><td>'+formatNum(r.x)+'</td><td>'+(r.y!==null&&isFinite(r.y)?formatNum(r.y):'undef')+'</td></tr>';
        }
        html+='</tbody></table>';
    }
    if(table.right&&table.right.length>0){
        html+='<table class="lc-approx-table" style="margin-top:0.5rem;"><thead><tr><th>x (from '+(isFinite(a)?'right':'&infin;')+')</th><th>f(x)</th></tr></thead><tbody>';
        for(var j=0;j<table.right.length;j++){
            var r2=table.right[j];
            html+='<tr><td>'+formatNum(r2.x)+'</td><td>'+(r2.y!==null&&isFinite(r2.y)?formatNum(r2.y):'undef')+'</td></tr>';
        }
        html+='</tbody></table>';
    }
    return html;
}

function formatNum(n){
    if(n===null||n===undefined)return'undef';
    if(!isFinite(n))return n>0?'\u221E':'-\u221E';
    if(Number.isInteger(n))return n.toString();
    var s=n.toPrecision(8);
    return parseFloat(s).toString();
}

function showError(expr,msg){
    resultActions.classList.remove('visible');
    var html='<div class="lc-error"><h4>Could Not Compute Limit</h4>';
    html+='<p>The limit of <strong>'+escapeHtml(expr)+'</strong> could not be evaluated.'+(msg?' ('+escapeHtml(msg)+')':'')+'</p>';
    html+='<ul><li>Check syntax (see Syntax Help)</li><li>Ensure parentheses are balanced</li><li>Try a simpler expression</li></ul></div>';
    resultContent.innerHTML=html;
    if(emptyState)emptyState.style.display='none';
}

// Step-by-step
window.showSteps=function(){
    if(!lastLimitContext)return;
    var ctx=lastLimitContext;
    var stepsBtn=document.getElementById('lc-steps-btn');
    var steps=generateLimitSteps(ctx);
    if(steps&&steps.length>0){
        renderSteps(steps,ctx.result.method);
        if(stepsBtn)stepsBtn.style.display='none';
        return;
    }
    // AI fallback
    if(stepsBtn){stepsBtn.classList.add('loading');stepsBtn.innerHTML='<span class="lc-spinner"></span> Generating steps\u2026';}
    var payload={operation:'limit',expression:ctx.expr,variable:ctx.v,answer:ctx.valueStr,bounds:{lower:ctx.ptStr}};
    fetch(CTX+'/CFExamMarkerFunctionality?action=math_steps',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(payload)})
    .then(function(r){return r.json();})
    .then(function(data){
        if(data.success&&data.steps&&data.steps.length>0){renderSteps(data.steps,data.method||ctx.result.method);}
        else{renderStepsError(data.error||'Could not generate steps');}
        if(stepsBtn)stepsBtn.style.display='none';
    })
    .catch(function(){
        renderStepsError('Network error. Please try again.');
        if(stepsBtn){stepsBtn.classList.remove('loading');stepsBtn.innerHTML='\u{1F4DD} Show Steps';}
    });
};


function renderSteps(steps,method){
    var container=document.getElementById('lc-steps-area');
    if(!container)return;
    var html='<div class="lc-steps-container"><div class="lc-steps-header">';
    html+='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
    html+='Solution Steps</div>';
    for(var i=0;i<steps.length;i++){
        var title=steps[i].title||steps[i].t||'';
        var latex=steps[i].latex||steps[i].l||'';
        html+='<div class="lc-step"><span class="lc-step-num">'+(i+1)+'</span><div class="lc-step-body">';
        html+='<div class="lc-step-title">'+escapeHtml(title)+'</div>';
        html+='<div class="lc-step-math" id="lc-step-math-'+i+'"></div></div></div>';
    }
    html+='</div>';container.innerHTML=html;
    for(var j=0;j<steps.length;j++){
        var el=document.getElementById('lc-step-math-'+j);
        var ltx=steps[j].latex||steps[j].l||'';
        if(el&&ltx){try{katex.render(ltx,el,{displayMode:true,throwOnError:false});}catch(e2){el.textContent=ltx;}}
    }
}

function renderStepsError(msg){
    var container=document.getElementById('lc-steps-area');
    if(!container)return;
    container.innerHTML='<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">'+escapeHtml(msg)+'</div>';
}

// Graph
function prepareGraph(exprStr,v,a,result){
    pendingGraph={expr:exprStr,v:v,a:a,result:result};
    if(graphHint)graphHint.style.display='none';
    var graphPanel=document.getElementById('lc-panel-graph');
    if(graphPanel.classList.contains('active')){loadPlotly(function(){renderGraph(pendingGraph);});}
}

function renderGraph(cfg){
    if(!window.Plotly)return;
    var container=document.getElementById('lc-graph-container');
    var xMin,xMax,n=500;
    if(isFinite(cfg.a)){xMin=cfg.a-10;xMax=cfg.a+10;}
    else if(cfg.a===Infinity){xMin=0;xMax=1000;}
    else{xMin=-1000;xMax=0;}

    var xs=[],ys=[];
    var step=(xMax-xMin)/n;
    for(var i=0;i<=n;i++){
        var xVal=xMin+i*step;xs.push(xVal);
        ys.push(evalAtPoint(cfg.expr,cfg.v,xVal));
    }

    var traces=[];
    traces.push({x:xs,y:ys,type:'scatter',mode:'lines',name:'f('+cfg.v+')',line:{color:'#8b5cf6',width:2.5}});

    // Limit point marker
    if(isFinite(cfg.a)){
        var limVal=cfg.result.value;
        if(typeof limVal==='number'&&isFinite(limVal)){
            // Open circle at the limit point
            traces.push({x:[cfg.a],y:[limVal],type:'scatter',mode:'markers',name:'Limit point',marker:{color:'#fff',size:10,line:{color:'#8b5cf6',width:2.5}},showlegend:false});
            // Dashed horizontal line at limit value
            traces.push({x:[xMin,xMax],y:[limVal,limVal],type:'scatter',mode:'lines',name:'L = '+limVal,line:{color:'#a78bfa',width:1.5,dash:'dash'}});
            // Vertical dashed at x=a
            traces.push({x:[cfg.a,cfg.a],y:[Math.min.apply(null,ys.filter(function(y){return y!==null&&isFinite(y);}))||0,Math.max.apply(null,ys.filter(function(y){return y!==null&&isFinite(y);}))||1],type:'scatter',mode:'lines',name:'x = '+cfg.a,line:{color:'#7c3aed',width:1,dash:'dot'},showlegend:false});
        }
    }

    var isDark=document.documentElement.getAttribute('data-theme')==='dark';
    var layout={
        margin:{t:30,r:20,b:40,l:50},
        xaxis:{title:cfg.v,gridcolor:isDark?'#334155':'#e2e8f0',zerolinecolor:isDark?'#475569':'#cbd5e1',color:isDark?'#cbd5e1':'#475569'},
        yaxis:{gridcolor:isDark?'#334155':'#e2e8f0',zerolinecolor:isDark?'#475569':'#cbd5e1',color:isDark?'#cbd5e1':'#475569'},
        paper_bgcolor:isDark?'#1e293b':'#fff',plot_bgcolor:isDark?'#1e293b':'#fff',
        font:{family:'Inter, sans-serif',size:12,color:isDark?'#cbd5e1':'#475569'},
        legend:{x:0,y:1.12,orientation:'h',font:{size:11}},showlegend:true
    };
    Plotly.newPlot(container,traces,layout,{responsive:true,displayModeBar:true,modeBarButtonsToRemove:['lasso2d','select2d']});
}

function evalAtPoint(exprStr,v,xVal){
    try{var scope={};scope[v]=xVal;var val=parseFloat(nerdamer(exprStr).evaluate(scope).text('decimals'));
        if(!isFinite(val)||Math.abs(val)>1e6)return null;return val;}catch(e){return null;}
}

// Python compiler
function nerdamerToPython(expr){
    return expr.replace(/e\^(\([^)]+\))/g,'exp$1').replace(/e\^([a-zA-Z0-9_]+)/g,'exp($1)').replace(/\^/g,'**');
}

function buildCompilerCode(template){
    // Strip the lim_(x->a) wrapper if the user typed a semantic operator
    // (MathLive visual mode emits this).  Without unwrap, SymPy would
    // see `lim_(x->0)*(sin(x))/x` which has no valid parse.  Pure call
    // (no opts) — we don't want side effects when generating code.
    var rawExpr = exprInput.value.trim() || '(x^2-1)/(x-1)';
    // Pipeline: unwrap semantic ops → normalizeExpr (inserts implicit
    // `*`, e.g. `3sin(x)` → `3*sin(x)`, mandatory for SymPy) →
    // nerdamerToPython (^ → **).
    var cleanExpr = normalizeExpr(unwrapSemanticLimit(rawExpr));
    var pyExpr = nerdamerToPython(cleanExpr);
    var v = varSelect.value;
    var pt = pointInput.value.trim() || '1';
    // SymPy uses `oo` for infinity.  Map all common variants.
    var pyPt = pt.replace(/infinity/gi, 'oo').replace(/\binf\b/gi, 'oo');

    // Both 'symbolic' (new staging value) and 'sympy-limit' (legacy) map
    // to the standard symbolic single-limit template — direction-aware,
    // respects the Left/Right/Two-sided toggle.
    if (template === 'symbolic' || template === 'sympy-limit') {
        var dirArg =
            currentDir === 'left'  ? ", '-'" :
            currentDir === 'right' ? ", '+'" : '';
        return 'from sympy import *\n\n'
            + v + ' = symbols(\'' + v + '\')\n'
            + 'expr = ' + pyExpr + '\n\n'
            + 'result = limit(expr, ' + v + ', ' + pyPt + dirArg + ')\n'
            + 'print("Limit:")\npprint(result)\n'
            + 'print("\\nLaTeX:", latex(result))';
    }
    // 'numerical' (new) or 'sympy-onesided' (legacy) → show left vs right
    // sided limits side-by-side (also useful for verifying two-sided).
    return 'from sympy import *\n\n'
        + v + ' = symbols(\'' + v + '\')\n'
        + 'expr = ' + pyExpr + '\n\n'
        + 'left  = limit(expr, ' + v + ', ' + pyPt + ", '-')\n"
        + 'right = limit(expr, ' + v + ', ' + pyPt + ", '+')\n"
        + 'print("Left-hand limit: ", left)\n'
        + 'print("Right-hand limit:", right)\n'
        + 'if left == right:\n'
        + '    print("\\nTwo-sided limit exists =", left)\n'
        + 'else:\n'
        + '    print("\\nTwo-sided limit DOES NOT exist (left != right)")';
}

function loadCompilerWithTemplate(){
    var template=document.getElementById('lc-compiler-template').value;
    var code=buildCompilerCode(template);
    var b64Code=btoa(unescape(encodeURIComponent(code)));
    var config=JSON.stringify({lang:'python',code:b64Code});
    document.getElementById('lc-compiler-iframe').src=CTX+'/onecompiler-embed.jsp?c='+encodeURIComponent(config);
}
document.getElementById('lc-compiler-template').addEventListener('change',function(){loadCompilerWithTemplate();});

// Copy / Share
document.getElementById('lc-copy-latex-btn').addEventListener('click',function(){
    if(typeof ToolUtils!=='undefined'){ToolUtils.copyToClipboard(lastResultLatex,'LaTeX copied!');}
    else{navigator.clipboard.writeText(lastResultLatex);}
});
document.getElementById('lc-copy-text-btn').addEventListener('click',function(){
    if(typeof ToolUtils!=='undefined'){ToolUtils.copyToClipboard(lastResultText,'Result copied!');}
    else{navigator.clipboard.writeText(lastResultText);}
});
document.getElementById('lc-share-btn').addEventListener('click',function(){
    var params={expr:exprInput.value,v:varSelect.value,pt:pointInput.value,dir:currentDir};
    if(typeof ToolUtils!=='undefined'){
        var url=ToolUtils.generateShareUrl(params,{toolName:'Limit Calculator'});
        ToolUtils.copyToClipboard(url,'Share URL copied!');
    }
});

// Download PDF
document.getElementById('lc-download-pdf-btn').addEventListener('click',downloadResultPdf);

function downloadResultPdf(){
    if(!lastLimitContext){if(typeof ToolUtils!=='undefined')ToolUtils.showToast('No result to download',2000,'warning');return;}
    var ctx=lastLimitContext;
    var container=document.createElement('div');
    container.style.cssText='position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
    document.body.appendChild(container);
    var title=document.createElement('div');title.style.cssText='font-size:22px;font-weight:700;margin-bottom:8px;color:#8b5cf6;';
    title.textContent='Limit Calculator \u2014 8gwifi.org';container.appendChild(title);
    var divider=document.createElement('div');divider.style.cssText='height:2px;background:linear-gradient(90deg,#8b5cf6,#a78bfa,transparent);margin-bottom:24px;';
    container.appendChild(divider);
    var qLabel=document.createElement('div');qLabel.style.cssText='font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
    qLabel.textContent='Limit Expression';container.appendChild(qLabel);
    var qMath=document.createElement('div');qMath.style.cssText='font-size:20px;margin-bottom:24px;';container.appendChild(qMath);
    katex.render('\\lim_{'+ctx.arrow+'}\\left['+ctx.exprTeX+'\\right]',qMath,{displayMode:true,throwOnError:false});
    var aLabel=document.createElement('div');aLabel.style.cssText='font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
    aLabel.textContent='Result';container.appendChild(aLabel);
    var aMath=document.createElement('div');aMath.style.cssText='font-size:22px;margin-bottom:16px;padding:16px;background:#f5f3ff;border-radius:8px;';container.appendChild(aMath);
    katex.render(ctx.valueLatex,aMath,{displayMode:true,throwOnError:false});
    var methodDiv=document.createElement('div');methodDiv.style.cssText='font-size:13px;color:#64748b;margin-bottom:20px;';
    methodDiv.textContent='Method: '+ctx.result.method+(ctx.result.form?' | Indeterminate Form: '+ctx.result.form:'');container.appendChild(methodDiv);
    // Steps if rendered
    var stepsArea=document.getElementById('lc-steps-area');
    if(stepsArea&&stepsArea.children.length>0){
        var stepsLabel=document.createElement('div');stepsLabel.style.cssText='font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
        stepsLabel.textContent='Step-by-Step Solution';container.appendChild(stepsLabel);
        var stepEls=stepsArea.querySelectorAll('.lc-step');
        for(var i=0;i<stepEls.length;i++){
            var stepRow=document.createElement('div');stepRow.style.cssText='display:flex;gap:12px;margin-bottom:12px;';
            var stepNum=document.createElement('div');stepNum.style.cssText='width:24px;height:24px;background:#8b5cf6;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
            stepNum.textContent=(i+1);stepRow.appendChild(stepNum);
            var stepBody=document.createElement('div');stepBody.style.cssText='flex:1;';
            var titleEl=stepEls[i].querySelector('.lc-step-title');
            if(titleEl){var sTitle=document.createElement('div');sTitle.style.cssText='font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';sTitle.textContent=titleEl.textContent;stepBody.appendChild(sTitle);}
            var mathEl=stepEls[i].querySelector('.lc-step-math');
            if(mathEl){var sMath=document.createElement('div');sMath.style.cssText='font-size:16px;';
                var annotation=mathEl.querySelector('annotation');
                if(annotation){katex.render(annotation.textContent,sMath,{displayMode:true,throwOnError:false});}
                else{sMath.innerHTML=mathEl.innerHTML;}
                stepBody.appendChild(sMath);}
            stepRow.appendChild(stepBody);container.appendChild(stepRow);
        }
    }
    var footer=document.createElement('div');footer.style.cssText='margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
    footer.innerHTML='<span>Generated by 8gwifi.org Limit Calculator</span><span>'+new Date().toLocaleDateString()+'</span>';
    container.appendChild(footer);
    if(typeof ToolUtils!=='undefined')ToolUtils.showToast('Generating PDF...',1500,'info');
    var loadHtml2Canvas=(typeof html2canvas!=='undefined')?Promise.resolve():ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
    loadHtml2Canvas.then(function(){return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js');})
    .then(function(){return html2canvas(container,{scale:2,backgroundColor:'#ffffff',useCORS:true,logging:false});})
    .then(function(canvas){
        document.body.removeChild(container);
        var imgData=canvas.toDataURL('image/png');
        var pdf=new jspdf.jsPDF({orientation:'portrait',unit:'mm',format:'a4'});
        var pageWidth=pdf.internal.pageSize.getWidth();var margin=10;var usableWidth=pageWidth-margin*2;
        var imgWidth=usableWidth;var imgHeight=(canvas.height*usableWidth)/canvas.width;
        var usableHeight=pdf.internal.pageSize.getHeight()-margin*2;
        if(imgHeight>usableHeight){imgHeight=usableHeight;imgWidth=(canvas.width*usableHeight)/canvas.height;}
        var x=(pageWidth-imgWidth)/2;
        pdf.addImage(imgData,'PNG',x,margin,imgWidth,imgHeight);
        pdf.save('limit-'+ctx.expr.replace(/[^a-zA-Z0-9]/g,'_').substring(0,30)+'.pdf');
        if(typeof ToolUtils!=='undefined')ToolUtils.showToast('PDF downloaded!',2000,'success');
    }).catch(function(err){
        console.error('PDF generation failed:',err);
        if(container.parentNode)document.body.removeChild(container);
        if(typeof ToolUtils!=='undefined')ToolUtils.showToast('PDF generation failed: '+err.message,3000,'error');
    });
}

// Load from URL
function loadFromUrl(){
    var p=new URLSearchParams(window.location.search);
    var expr=p.get('expr');var v=p.get('v');var pt=p.get('pt');var dir=p.get('dir');
    if(expr)exprInput.value=decodeURIComponent(expr);
    if(v)varSelect.value=v;
    if(pt)pointInput.value=decodeURIComponent(pt);
    if(dir&&(dir==='two-sided'||dir==='left'||dir==='right')){
        currentDir=dir;
        dirBtns.forEach(function(b){b.classList.toggle('active',b.getAttribute('data-dir')===dir);});
    }
    if(expr&&pt){updatePreview();setTimeout(doCalculateLimit,300);}
    else if(expr){updatePreview();}
}

function escapeHtml(str){var div=document.createElement('div');div.appendChild(document.createTextNode(str));return div.innerHTML;}

// Worksheet button wiring
function openWorksheet() {
    if (typeof WorksheetEngine !== 'undefined') {
        WorksheetEngine.open({
            jsonUrl: 'worksheet/math/calculus/limits.json',
            title: 'Limits',
            accentColor: '#8b5cf6',
            branding: '8gwifi.org',
            defaultCount: 20
        });
    }
}
var wsBtn = document.getElementById('lc-worksheet-btn');
if (wsBtn) wsBtn.addEventListener('click', openWorksheet);
var wsTbBtn = document.getElementById('lc-toolbar-worksheet-btn');
if (wsTbBtn) wsTbBtn.addEventListener('click', openWorksheet);

// Expose for image-to-math scan
window.__LC_SCAN__ = {
    fillAndSolve: function(problem) {
        // Parse LaTeX via backend to get calculator-form expression
        var latex = problem.latex || problem.expr || '';
        var pt = problem.point || '0';
        var dir = problem.direction || 'two-sided';
        var v = problem.variable || 'x';

        // Convert common LaTeX point values
        pt = pt.replace(/\\infty/g, 'Infinity').replace(/\\pi/g, 'pi').replace(/\\e/g, 'e');

        if (exprInput) exprInput.value = latex;
        if (pointInput) pointInput.value = pt;
        if (varSelect) {
            var opt = varSelect.querySelector('option[value="' + v + '"]');
            if (opt) varSelect.value = v;
        }
        // Set direction
        currentDir = dir;
        dirBtns.forEach(function(b) {
            b.classList.toggle('active', b.getAttribute('data-dir') === dir);
        });
        updatePreview();
        setTimeout(doCalculateLimit, 300);
    },
    generateLimitSteps: generateLimitSteps,
    exprToLatex: exprToLatex
};

loadFromUrl();
})();
