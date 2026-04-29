/**
 * Derivative Calculator — DOM/UI logic.
 *
 * Depends on (loaded in this order by
 *   math/partials/derivative-calculator-scripts.jsp):
 *     · KaTeX, nerdamer (core + Algebra + Calculus)   — from math-libs.jsp
 *     · IntegralCalculatorCore                         — from this partial
 *     · DerivativeCalculatorCore                       — from this partial
 *
 * ID contract:
 *   · #ic-expr           — shared math-input text field (math-input-setup.jsp)
 *   · #dc-*              — derivative-specific elements (order, eval point,
 *                          result content, graph, python tab, etc.)
 *
 * This file was extracted from the inline <script> block of the original
 * derivative-calculator.jsp (lines 555-1262) as part of the math-tool
 * migration; see math/MIGRATION_TEMPLATE.md.
 */
(function(){
'use strict';
var normalizeExpr=(typeof DerivativeCalculatorCore!=='undefined'&&DerivativeCalculatorCore.normalizeExpr)?DerivativeCalculatorCore.normalizeExpr:function(e){return(e&&e.trim)?e.trim():'';};
var exprInput=document.getElementById('ic-expr');
var previewEl=document.getElementById('dc-preview');
var varSelect=document.getElementById('dc-var');
var evalPointInput=document.getElementById('dc-eval-point');
var diffBtn=document.getElementById('dc-differentiate-btn');
var resultContent=document.getElementById('dc-result-content');
var resultActions=document.getElementById('dc-result-actions');
var emptyState=document.getElementById('dc-empty-state');
var graphHint=document.getElementById('dc-graph-hint');
var currentOrder=1;
var lastResultLatex='';
var lastResultText='';
var compilerLoaded=false;
var pendingGraph=null;
var lastDiffContext=null;

window.toggleFaq=function(btn){btn.parentElement.classList.toggle('open');};

/**
 * Unwrap semantic "full-notation" derivative input.
 *
 * Students copying from a textbook (or using MathLive's visual mode with
 * the \dfrac{d}{dx}...|_{x=a} glyphs) end up with an ascii-math string
 * like:
 *     (d)/(dx) 3sin(x) |_(x=2)
 * Raw nerdamer can't parse that — it expects JUST the integrand (3*sin(x)),
 * with the variable and eval point supplied via the dropdown + text field.
 *
 * This pre-parser runs before normalizeExpr, extracting:
 *   · the differentiation operator "d/dx" (with optional powers for higher
 *     orders: "(d^2)/(dx^2)") — variable goes to `opts.varSelect` if given
 *   · the wrapping brackets `[f(x)]`, `(f(x))`, `{f(x)}` around the body
 *   · the evaluation bar `|_{x=V}`, `|_(x=V)`, or `|_x=V` — V goes to
 *     `opts.evalInput` if given and the field is empty
 *
 * Returns the cleaned expression (or the original if nothing matched).
 * `opts` is optional — omit for pure / side-effect-free usage (e.g. the
 * live preview).
 */
function unwrapSemanticDerivative(raw, opts) {
    if (!raw || typeof raw !== 'string') return raw;
    opts = opts || {};
    var s = raw.trim();

    // ── 1. Strip the d/dx operator (with higher-order variants) ──────────
    //    Matches: (d)/(dx), d/dx, (d^2)/(dx^2), d^n/dx^n, possibly * after
    var opRe = /^\s*\(?\s*d(?:\s*\^\s*\d+)?\s*\)?\s*\/\s*\(?\s*d\s*([a-z])(?:\s*\^\s*\d+)?\s*\)?\s*\*?\s*/i;
    var m = s.match(opRe);
    if (m) {
        var detectedVar = m[1].toLowerCase();
        if (opts.varSelect) {
            var opt = opts.varSelect.querySelector('option[value="' + detectedVar + '"]');
            if (opt) opts.varSelect.value = detectedVar;
        }
        s = s.slice(m[0].length).trim();
    }

    // ── 2. Detect the evaluation bar at end FIRST: |_{x=V}, |_(x=V), |_x=V
    //    Runs before bracket-strip because textbook notation wraps the
    //    function in brackets AND adds the eval bar after, e.g.
    //        d/dx[3*sin(x)]|_{x=2}
    //    Without this order, the string `[3*sin(x)]|_{x=2}` isn't
    //    fully-bracketed so stage 3 would skip it.
    var evalRe = /\s*\|\s*_?\s*[\{\(]?\s*([a-z])\s*=\s*([^}\)|]+?)\s*[\}\)]?\s*$/i;
    var em = s.match(evalRe);
    if (em) {
        var evalVar = em[1].toLowerCase();
        var evalVal = em[2].trim();
        if (opts.evalInput && !opts.evalInput.value.trim()) {
            opts.evalInput.value = evalVal;
        }
        if (opts.varSelect) {
            var vopt = opts.varSelect.querySelector('option[value="' + evalVar + '"]');
            if (vopt) opts.varSelect.value = evalVar;
        }
        s = s.slice(0, em.index).trim();
    }

    // ── 3. Strip one layer of wrapping brackets around the body ──────────
    //    [f(x)] and {f(x)} are always safe; (f(x)) only if the outer
    //    parens are balanced across the entire string (so we don't
    //    accidentally strip the parens around sin(x)).
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

// Order toggle
var orderBtns=document.querySelectorAll('.dc-order-btn');
orderBtns.forEach(function(btn){
    btn.addEventListener('click',function(){
        var order=parseInt(this.getAttribute('data-order'));
        if(order===currentOrder)return;
        currentOrder=order;
        orderBtns.forEach(function(b){b.classList.remove('active');});
        this.classList.add('active');
        updatePreview();
    });
});

// Output tabs
// Tab/panel classes are SHARED across all migrated calc pages — they're
// styled in math-studio.css as `.ic-output-tab` / `.ic-panel` and we
// reuse the same selectors for click-binding.  (The IDs stay
// tool-specific: `dc-panel-result/graph/python`.)
var tabBtns=document.querySelectorAll('.ic-output-tab');
var panels=document.querySelectorAll('.ic-panel');
tabBtns.forEach(function(btn){
    btn.addEventListener('click',function(){
        var panel=this.getAttribute('data-panel');
        tabBtns.forEach(function(b){b.classList.remove('active');});
        panels.forEach(function(p){p.classList.remove('active');});
        this.classList.add('active');
        document.getElementById('dc-panel-'+panel).classList.add('active');
        if(panel==='graph'&&pendingGraph){loadPlotly(function(){renderGraph(pendingGraph);});}
        if(panel==='python'&&!compilerLoaded){loadCompilerWithTemplate();compilerLoaded=true;}
    });
});

// Syntax help
var syntaxBtn=document.getElementById('dc-syntax-btn');
var syntaxContent=document.getElementById('dc-syntax-content');
syntaxBtn.addEventListener('click',function(){
    syntaxContent.classList.toggle('open');
    var chev=syntaxBtn.querySelector('.dc-syntax-chevron');
    chev.style.transform=syntaxContent.classList.contains('open')?'rotate(180deg)':'';
});

// Quick examples
document.getElementById('dc-examples').addEventListener('click',function(e){
    var chip=e.target.closest('.dc-example-chip');
    if(!chip)return;
    exprInput.value=chip.getAttribute('data-expr');
    updatePreview();
    exprInput.focus();
});

// Live preview
var previewTimer=null;
exprInput.addEventListener('input',function(){
    // Eagerly auto-fill variable / eval-point if the user typed a
    // semantic derivative operator (d/dx f(x) — common in MathLive
    // visual mode) or |_{x=a} eval bar.  Side-effects only — exprInput
    // is stripped at submit time inside doDifferentiate().  Same
    // pattern as limit-calculator.js.
    var evalBefore = evalPointInput.value;
    unwrapSemanticDerivative(exprInput.value.trim(), {
        varSelect: varSelect,
        evalInput: evalPointInput
    });
    if (evalPointInput.value !== evalBefore && document.activeElement !== evalPointInput) {
        evalPointInput.dispatchEvent(new Event('input', { bubbles: true }));
    }
    clearTimeout(previewTimer);
    previewTimer = setTimeout(updatePreview, 200);
});
varSelect.addEventListener('change',updatePreview);

function updatePreview(){
    // Unwrap d/dx + |_{x=a} syntax for the preview too, so the KaTeX render
    // shows a clean "d/dx[f(x)]" derivative instead of "d/dx[d/dx[...]]".
    // No side effects here — just a clean string.
    var raw=unwrapSemanticDerivative(exprInput.value.trim());
    var v=varSelect.value;
    if(!raw){previewEl.innerHTML='<span style="color:var(--text-muted);font-size:0.8125rem;">Type a function above\u2026</span>';return;}
    try{
        var expr=normalizeExpr(raw);
        var latex=exprToLatex(expr);
        var derivLatex;
        if(currentOrder===1){derivLatex='\\frac{d}{d'+v+'}\\left['+latex+'\\right]';}
        else{derivLatex='\\frac{d^{'+currentOrder+'}}{d'+v+'^{'+currentOrder+'}}\\left['+latex+'\\right]';}
        katex.render(derivLatex,previewEl,{displayMode:true,throwOnError:false});
    }catch(e){
        previewEl.innerHTML='<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
    }
}

function exprToLatex(expr){
    try{return nerdamer(expr).toTeX();}catch(e){
        return expr.replace(/\*/g,' \\cdot ').replace(/sqrt\(/g,'\\sqrt{').replace(/\)/g,'}').replace(/\^(\w)/g,'^{$1}');
    }
}

// Differentiation
diffBtn.addEventListener('click',doDifferentiate);
exprInput.addEventListener('keydown',function(e){if(e.key==='Enter')doDifferentiate();});

function doDifferentiate(){
    // Pre-parse semantic input (d/dx, wrapping brackets, |_{x=a} eval bar).
    // Side effects: auto-populates the variable dropdown and eval-point
    // field when the user typed them into the math-field directly.
    var raw=unwrapSemanticDerivative(exprInput.value.trim(),{
        varSelect: varSelect,
        evalInput: evalPointInput
    });
    var v=varSelect.value;
    if(!raw){if(typeof ToolUtils!=='undefined')ToolUtils.showToast('Please enter a function.',2000,'warning');return;}
    try{
        var expr=normalizeExpr(raw);
        var intermediates=[];
        var current=expr;
        for(var i=0;i<currentOrder;i++){
            var result=nerdamer('diff('+current+','+v+')');
            intermediates.push({order:i+1,tex:result.toTeX(),text:result.text()});
            current=result.text();
        }
        var finalResult=intermediates[intermediates.length-1];
        var method=identifyDiffMethod(expr);
        var evalResult=null;
        var evalPt=evalPointInput.value.trim()
            .replace(/\u03c0/g,'pi').replace(/\u221e/g,'Infinity').replace(/\u2212/g,'-')
            .replace(/\u00b2/g,'^2').replace(/\u00b3/g,'^3');
        if(evalPt){
            try{
                var evalNum=evalPt.toLowerCase()==='pi'?Math.PI:evalPt.toLowerCase()==='e'?Math.E:parseFloat(evalPt);
                var scope={};scope[v]=evalNum;
                var numVal=parseFloat(nerdamer(finalResult.text).evaluate(scope).text('decimals'));
                if(isFinite(numVal))evalResult={point:evalPt,value:numVal};
            }catch(ex){}
        }
        showResult(expr,v,intermediates,method,evalResult);
        prepareGraph(expr,v,finalResult.text,evalPt,evalResult);
        resultActions.classList.add('visible');
        if(emptyState)emptyState.style.display='none';
    }catch(err){
        showError(raw,err.message);
    }
}

function identifyDiffMethod(expr){
    var e=expr.trim();
    // Check for quotient (f/g at top level)
    if(hasTopLevelDiv(e))return 'Quotient Rule';
    // Check for product (f*g at top level)
    if(hasTopLevelMul(e))return 'Product Rule';
    // Check for composition (function of function)
    if(/\w+\([^)]*[a-z]\^|[a-z]\*/.test(e))return 'Chain Rule';
    if(/(sin|cos|tan|sec|csc|cot)\(/.test(e))return 'Trigonometric';
    if(/e\^|exp\(/.test(e))return 'Exponential';
    if(/log\(|ln\(/.test(e))return 'Logarithmic';
    if(/sqrt\(/.test(e))return 'Chain Rule';
    if(/^\s*[\d.]*\*?[a-z]\^[\d]+/.test(e)||/^\s*[a-z]\^/.test(e))return 'Power Rule';
    if(/^[\d.]+$/.test(e))return 'Constant';
    return 'Symbolic Differentiation';
}

function hasTopLevelDiv(expr){
    var depth=0;
    for(var i=0;i<expr.length;i++){
        if(expr[i]==='(')depth++;else if(expr[i]===')')depth--;
        if(depth===0&&expr[i]==='/'&&i>0&&i<expr.length-1)return true;
    }
    return false;
}
function hasTopLevelMul(expr){
    var depth=0;
    for(var i=0;i<expr.length;i++){
        if(expr[i]==='(')depth++;else if(expr[i]===')')depth--;
        if(depth===0&&expr[i]==='*'&&i>0&&i<expr.length-1)return true;
    }
    return false;
}

function orderLabel(n){
    var primes='';for(var i=0;i<n&&i<3;i++)primes+="'";
    if(n>3)return 'f^{('+n+')}';
    return "f"+primes;
}
function orderLabelText(n){
    if(n===1)return "f'";if(n===2)return "f''";if(n===3)return "f'''";
    return 'f^('+n+')';
}

function showResult(expr,v,intermediates,method,evalResult){
    var exprTeX=exprToLatex(expr);
    var finalR=intermediates[intermediates.length-1];
    lastResultLatex=finalR.tex;
    lastResultText=finalR.text;
    lastDiffContext={expr:expr,v:v,intermediates:intermediates,method:method,evalResult:evalResult,order:currentOrder};

    var html='<div class="dc-result-math">';
    html+='<div class="dc-result-label">Function</div>';
    html+='<div id="dc-r-fn"></div>';
    html+='<div class="dc-result-label" style="margin-top:1rem;">'+orderLabelText(currentOrder)+'('+v+') =</div>';
    html+='<div class="dc-result-main" id="dc-r-result"></div>';
    html+='<div class="dc-result-detail"><span class="dc-method-badge">'+escapeHtml(method)+'</span></div>';

    // Intermediate derivatives for order > 1
    if(currentOrder>1){
        html+='<div style="margin-top:1rem;">';
        html+='<div class="dc-result-label">Intermediate Derivatives</div>';
        for(var i=0;i<intermediates.length-1;i++){
            html+='<div class="dc-intermediate"><div class="dc-intermediate-label">'+orderLabelText(intermediates[i].order)+'('+v+')</div>';
            html+='<div id="dc-r-inter-'+i+'"></div></div>';
        }
        html+='</div>';
    }

    // Point evaluation
    if(evalResult){
        html+='<div class="dc-result-numeric">'+orderLabelText(currentOrder)+'('+escapeHtml(evalResult.point)+') = '+evalResult.value.toFixed(6)+'</div>';
    }

    html+='<button type="button" class="dc-steps-btn" id="dc-steps-btn" onclick="showSteps()">&#128221; Show Steps</button>';
    html+='<div id="dc-steps-area"></div>';
    html+='</div>';
    resultContent.innerHTML=html;

    // Render KaTeX
    var derivNotation=currentOrder===1?'\\frac{d}{d'+v+'}':'\\frac{d^{'+currentOrder+'}}{d'+v+'^{'+currentOrder+'}}';
    katex.render('f('+v+') = '+exprTeX,document.getElementById('dc-r-fn'),{displayMode:true,throwOnError:false});
    katex.render(finalR.tex,document.getElementById('dc-r-result'),{displayMode:true,throwOnError:false});
    if(currentOrder>1){
        for(var j=0;j<intermediates.length-1;j++){
            var el=document.getElementById('dc-r-inter-'+j);
            if(el)katex.render(intermediates[j].tex,el,{displayMode:true,throwOnError:false});
        }
    }
}

function showError(expr,msg){
    resultActions.classList.remove('visible');
    var html='<div class="dc-error"><h4>Could Not Differentiate</h4>';
    html+='<p>The expression <strong>'+escapeHtml(expr)+'</strong> could not be differentiated.'+(msg?' ('+escapeHtml(msg)+')':'')+'</p>';
    html+='<ul><li>Check syntax (see Syntax Help)</li><li>Simplify the expression</li><li>Ensure parentheses are balanced</li></ul></div>';
    resultContent.innerHTML=html;
    if(emptyState)emptyState.style.display='none';
}

// Step-by-step
window.showSteps=function(){
    if(!lastDiffContext)return;
    var ctx=lastDiffContext;
    var stepsBtn=document.getElementById('dc-steps-btn');
    var steps=generateDiffSteps(ctx.expr,ctx.v,ctx.intermediates[0].tex,ctx.method);
    if(steps&&steps.length>0){
        renderSteps(steps,ctx.method);
        if(stepsBtn)stepsBtn.style.display='none';
        return;
    }
    // AI fallback
    if(stepsBtn){stepsBtn.classList.add('loading');stepsBtn.innerHTML='<span class="dc-spinner"></span> Generating steps\u2026';}
    var payload={operation:'differentiate',expression:ctx.expr,variable:ctx.v,answer:ctx.intermediates[0].text};
    fetch('' + (window.__DC_CTX || '') + '/CFExamMarkerFunctionality?action=math_steps',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(payload)})
    .then(function(r){return r.json();})
    .then(function(data){
        if(data.success&&data.steps&&data.steps.length>0){renderSteps(data.steps,data.method||ctx.method);}
        else{renderStepsError(data.error||'Could not generate steps');}
        if(stepsBtn)stepsBtn.style.display='none';
    })
    .catch(function(){
        renderStepsError('Network error. Please try again.');
        if(stepsBtn){stepsBtn.classList.remove('loading');stepsBtn.innerHTML='\u{1F4DD} Show Steps';}
    });
};

function generateDiffSteps(expr,v,resultTeX,method){
    var steps=[];var e=expr.trim();
    // Power rule: x^n or c*x^n
    var pwrMatch=e.match(/^(\d+\*?)?([a-z])\^(\d+)$/);
    if(pwrMatch){
        var c=pwrMatch[1]?parseInt(pwrMatch[1]):1;var n=parseInt(pwrMatch[3]);var nm1=n-1;
        steps.push({title:'Apply Power Rule: d/d'+v+'['+v+'^n] = n'+v+'^(n-1)',latex:'\\frac{d}{d'+v+'}\\left['+(c>1?c:'')+ v+'^{'+n+'}\\right] = '+(c>1?c+'\\cdot ':'')+n+v+'^{'+(nm1)+'}'});
        if(c>1){steps.push({title:'Simplify coefficient',latex:'= '+(c*n)+v+'^{'+(nm1)+'}'});}
        return steps;
    }
    // Basic known derivatives
    var normalized=e.replace(new RegExp(v,'g'),'x');
    var basicDerivs={'sin(x)':[{title:'Standard trigonometric derivative',latex:'\\frac{d}{d'+v+'}[\\sin('+v+')] = \\cos('+v+')'}],
        'cos(x)':[{title:'Standard trigonometric derivative',latex:'\\frac{d}{d'+v+'}[\\cos('+v+')] = -\\sin('+v+')'}],
        'tan(x)':[{title:'Standard trigonometric derivative',latex:'\\frac{d}{d'+v+'}[\\tan('+v+')] = \\sec^2('+v+')'}],
        'e^x':[{title:'Exponential rule',latex:'\\frac{d}{d'+v+'}[e^{'+v+'}] = e^{'+v+'}'}],
        'log(x)':[{title:'Logarithmic rule',latex:'\\frac{d}{d'+v+'}[\\ln('+v+')] = \\frac{1}{'+v+'}'}],
        '1/x':[{title:'Power rule with n=-1',latex:'\\frac{d}{d'+v+'}['+v+'^{-1}] = -'+v+'^{-2} = -\\frac{1}{'+v+'^2}'}]};
    if(basicDerivs[normalized])return basicDerivs[normalized];

    // Sum/difference: split terms
    var terms=splitTerms(e);
    if(terms&&terms.length>1){
        steps.push({title:'Apply Sum Rule: d/d'+v+'[f+g] = f\'+g\'',latex:'\\frac{d}{d'+v+'}\\left['+exprToLatex(e)+'\\right] = '+terms.map(function(t){return '\\frac{d}{d'+v+'}\\left['+exprToLatex(t.trim())+'\\right]';}).join(' + ')});
        var allOk=true;var partResults=[];
        for(var i=0;i<terms.length;i++){
            try{var r=nerdamer('diff('+terms[i]+','+v+')');partResults.push(r.toTeX());}
            catch(ex){allOk=false;break;}
        }
        if(allOk&&partResults.length===terms.length){
            for(var j=0;j<terms.length;j++){
                steps.push({title:'Differentiate term '+(j+1),latex:'\\frac{d}{d'+v+'}\\left['+exprToLatex(terms[j].trim())+'\\right] = '+partResults[j]});
            }
            steps.push({title:'Combine',latex:'= '+resultTeX});
            return steps;
        }
    }

    // Constant multiple: c*f(x)
    var constMatch=e.match(/^(\d+)\*(.+)$/);
    if(constMatch){
        var cc=constMatch[1];var inner=constMatch[2];
        steps.push({title:'Factor out constant',latex:'\\frac{d}{d'+v+'}\\left['+cc+'\\cdot '+exprToLatex(inner)+'\\right] = '+cc+'\\cdot \\frac{d}{d'+v+'}\\left['+exprToLatex(inner)+'\\right]'});
        try{var innerR=nerdamer('diff('+inner+','+v+')');
            steps.push({title:'Differentiate inner function',latex:'= '+cc+' \\cdot \\left('+innerR.toTeX()+'\\right)'});
            steps.push({title:'Simplify',latex:'= '+resultTeX});
            return steps;
        }catch(ex){}
    }

    // Product rule: f*g at top level
    if(hasTopLevelMul(e)){
        var mulParts=splitAtTopLevel(e,'*');
        if(mulParts&&mulParts.length===2){
            var fTex=exprToLatex(mulParts[0]);var gTex=exprToLatex(mulParts[1]);
            steps.push({title:'Apply Product Rule: (fg)\' = f\'g + fg\'',latex:'\\frac{d}{d'+v+'}\\left['+fTex+'\\cdot '+gTex+'\\right]'});
            try{
                var fp=nerdamer('diff('+mulParts[0]+','+v+')');var gp=nerdamer('diff('+mulParts[1]+','+v+')');
                steps.push({title:'Find f\'('+v+') and g\'('+v+')',latex:"f'="+fp.toTeX()+",\\quad g'="+gp.toTeX()});
                steps.push({title:'Apply formula',latex:'= '+fp.toTeX()+'\\cdot '+gTex+' + '+fTex+'\\cdot '+gp.toTeX()});
                steps.push({title:'Simplify',latex:'= '+resultTeX});
                return steps;
            }catch(ex){}
        }
    }

    // Quotient rule: f/g at top level
    if(hasTopLevelDiv(e)){
        var divParts=splitAtTopLevel(e,'/');
        if(divParts&&divParts.length===2){
            var fTex2=exprToLatex(divParts[0]);var gTex2=exprToLatex(divParts[1]);
            steps.push({title:'Apply Quotient Rule: (f/g)\' = (f\'g - fg\')/g\u00B2',latex:'\\frac{d}{d'+v+'}\\left[\\frac{'+fTex2+'}{'+gTex2+'}\\right]'});
            try{
                var fp2=nerdamer('diff('+divParts[0]+','+v+')');var gp2=nerdamer('diff('+divParts[1]+','+v+')');
                steps.push({title:'Find f\'('+v+') and g\'('+v+')',latex:"f'="+fp2.toTeX()+",\\quad g'="+gp2.toTeX()});
                steps.push({title:'Apply formula',latex:'= \\frac{'+fp2.toTeX()+'\\cdot '+gTex2+' - '+fTex2+'\\cdot '+gp2.toTeX()+'}{\\left('+gTex2+'\\right)^2}'});
                steps.push({title:'Simplify',latex:'= '+resultTeX});
                return steps;
            }catch(ex){}
        }
    }

    // Chain rule: f(g(x)) where f is a known outer function
    var chainPatterns=[
        {re:/^sin\((.+)\)$/,name:'sin',outerDeriv:'\\cos',outerDerivText:'cos'},
        {re:/^cos\((.+)\)$/,name:'cos',outerDeriv:'-\\sin',outerDerivText:'-sin'},
        {re:/^tan\((.+)\)$/,name:'tan',outerDeriv:'\\sec^2',outerDerivText:'sec^2'},
        {re:/^log\((.+)\)$/,name:'ln',outerDeriv:'\\frac{1}{\\Box}',outerDerivText:'1/u'},
        {re:/^sqrt\((.+)\)$/,name:'sqrt',outerDeriv:'\\frac{1}{2\\sqrt{\\Box}}',outerDerivText:'1/(2*sqrt(u))'},
        {re:/^asin\((.+)\)$/,name:'arcsin',outerDeriv:'\\frac{1}{\\sqrt{1-\\Box^2}}',outerDerivText:'1/sqrt(1-u^2)'},
        {re:/^acos\((.+)\)$/,name:'arccos',outerDeriv:'\\frac{-1}{\\sqrt{1-\\Box^2}}',outerDerivText:'-1/sqrt(1-u^2)'},
        {re:/^atan\((.+)\)$/,name:'arctan',outerDeriv:'\\frac{1}{1+\\Box^2}',outerDerivText:'1/(1+u^2)'},
        {re:/^sinh\((.+)\)$/,name:'sinh',outerDeriv:'\\cosh',outerDerivText:'cosh'},
        {re:/^cosh\((.+)\)$/,name:'cosh',outerDeriv:'\\sinh',outerDerivText:'sinh'},
        {re:/^tanh\((.+)\)$/,name:'tanh',outerDeriv:'\\text{sech}^2',outerDerivText:'sech^2'}
    ];
    for(var ci=0;ci<chainPatterns.length;ci++){
        var cp=chainPatterns[ci];var cm=e.match(cp.re);
        if(cm){
            var innerExpr=cm[1];
            // Only apply chain rule if inner is not just the variable
            var innerNorm=innerExpr.replace(new RegExp(v,'g'),'x');
            if(innerNorm!=='x'){
                var innerTeX=exprToLatex(innerExpr);
                try{
                    var gPrime=nerdamer('diff('+innerExpr+','+v+')');var gPrimeTex=gPrime.toTeX();
                    steps.push({title:'Identify composite function (Chain Rule)',latex:'\\text{Let } u = '+innerTeX+', \\quad \\text{outer function } f(u) = \\'+cp.name+'(u)'});
                    var outerStep=cp.outerDeriv.replace(/\\Box/g,innerTeX);
                    steps.push({title:"Outer derivative: f'(u)",latex:"f'(u) = "+outerStep});
                    steps.push({title:"Inner derivative: g'("+v+')',latex:"g'("+v+') = '+gPrimeTex});
                    steps.push({title:'Apply Chain Rule: f\'(g('+v+')) \\cdot g\'('+v+')',latex:'= '+outerStep+' \\cdot '+gPrimeTex});
                    steps.push({title:'Simplify',latex:'= '+resultTeX});
                    return steps;
                }catch(ex){}
            }
        }
    }
    // Chain rule for e^(g(x))
    var expMatch=e.match(/^e\^\((.+)\)$/);
    if(expMatch){
        var innerExp=expMatch[1];var innerExpNorm=innerExp.replace(new RegExp(v,'g'),'x');
        if(innerExpNorm!=='x'){
            var innerExpTeX=exprToLatex(innerExp);
            try{
                var gPrimeExp=nerdamer('diff('+innerExp+','+v+')');var gPrimeExpTex=gPrimeExp.toTeX();
                steps.push({title:'Identify composite function (Chain Rule)',latex:'\\text{Let } u = '+innerExpTeX+', \\quad f(u) = e^u'});
                steps.push({title:"Outer derivative: f'(u) = e^u",latex:"f'(u) = e^{"+innerExpTeX+'}'});
                steps.push({title:"Inner derivative: g'("+v+')',latex:"g'("+v+') = '+gPrimeExpTex});
                steps.push({title:'Apply Chain Rule',latex:'= e^{'+innerExpTeX+'} \\cdot '+gPrimeExpTex});
                steps.push({title:'Simplify',latex:'= '+resultTeX});
                return steps;
            }catch(ex){}
        }
    }
    // Chain rule for (g(x))^n  e.g. (x^2+1)^3
    var powCompMatch=e.match(/^\((.+)\)\^(\d+)$/);
    if(powCompMatch){
        var innerPow=powCompMatch[1];var nPow=parseInt(powCompMatch[2]);
        var innerPowTeX=exprToLatex(innerPow);
        try{
            var gPrimePow=nerdamer('diff('+innerPow+','+v+')');var gPrimePowTex=gPrimePow.toTeX();
            steps.push({title:'Identify composite function (Chain Rule + Power Rule)',latex:'\\text{Let } u = '+innerPowTeX+', \\quad f(u) = u^{'+nPow+'}'});
            steps.push({title:"Outer derivative (Power Rule): f'(u) = "+nPow+'u^{'+(nPow-1)+'}',latex:"f'(u) = "+nPow+'\\left('+innerPowTeX+'\\right)^{'+(nPow-1)+'}'});
            steps.push({title:"Inner derivative: g'("+v+')',latex:"g'("+v+') = '+gPrimePowTex});
            steps.push({title:'Apply Chain Rule',latex:'= '+nPow+'\\left('+innerPowTeX+'\\right)^{'+(nPow-1)+'} \\cdot '+gPrimePowTex});
            steps.push({title:'Simplify',latex:'= '+resultTeX});
            return steps;
        }catch(ex){}
    }

    return null;
}

function splitTerms(expr){
    var terms=[];var depth=0;var current='';
    for(var i=0;i<expr.length;i++){
        var ch=expr[i];
        if(ch==='('||ch==='[')depth++;else if(ch===')'||ch===']')depth--;
        if(depth===0&&(ch==='+'||(ch==='-'&&i>0&&current.trim()))){terms.push(current.trim());current=ch==='-'?'-':'';
        }else{current+=ch;}
    }
    if(current.trim())terms.push(current.trim());
    return terms.length>1?terms:null;
}

function splitAtTopLevel(expr,op){
    var depth=0;
    for(var i=0;i<expr.length;i++){
        if(expr[i]==='(')depth++;else if(expr[i]===')')depth--;
        if(depth===0&&expr[i]===op&&i>0&&i<expr.length-1){
            return[expr.substring(0,i),expr.substring(i+1)];
        }
    }
    return null;
}

function renderSteps(steps,method){
    var container=document.getElementById('dc-steps-area');
    if(!container)return;
    var html='<div class="dc-steps-container"><div class="dc-steps-header">';
    html+='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
    html+='Solution Steps</div>';
    for(var i=0;i<steps.length;i++){
        html+='<div class="dc-step"><span class="dc-step-num">'+(i+1)+'</span><div class="dc-step-body">';
        html+='<div class="dc-step-title">'+escapeHtml(steps[i].title)+'</div>';
        html+='<div class="dc-step-math" id="dc-step-math-'+i+'"></div></div></div>';
    }
    html+='</div>';container.innerHTML=html;
    for(var j=0;j<steps.length;j++){
        var el=document.getElementById('dc-step-math-'+j);
        if(el&&steps[j].latex){try{katex.render(steps[j].latex,el,{displayMode:true,throwOnError:false});}catch(e2){el.textContent=steps[j].latex;}}
    }
}

function renderStepsError(msg){
    var container=document.getElementById('dc-steps-area');
    if(!container)return;
    container.innerHTML='<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">'+escapeHtml(msg)+'</div>';
}

// Graph
function prepareGraph(exprStr,v,derivStr,evalPt,evalResult){
    pendingGraph={expr:exprStr,v:v,deriv:derivStr,evalPt:evalPt,evalResult:evalResult};
    if(graphHint)graphHint.style.display='none';
    var graphPanel=document.getElementById('dc-panel-graph');
    if(graphPanel.classList.contains('active')){loadPlotly(function(){renderGraph(pendingGraph);});}
}

function renderGraph(cfg){
    if(!window.Plotly)return;
    var container=document.getElementById('dc-graph-container');
    var xMin=-10,xMax=10,n=500;
    var xs=[],ysFx=[],ysDeriv=[];
    var step=(xMax-xMin)/n;
    for(var i=0;i<=n;i++){
        var xVal=xMin+i*step;xs.push(xVal);
        ysFx.push(evalAtPoint(cfg.expr,cfg.v,xVal));
        ysDeriv.push(evalAtPoint(cfg.deriv,cfg.v,xVal));
    }
    var traces=[];
    traces.push({x:xs,y:ysFx,type:'scatter',mode:'lines',name:'f('+cfg.v+')',line:{color:'#d97706',width:2.5}});
    traces.push({x:xs,y:ysDeriv,type:'scatter',mode:'lines',name:"f'("+cfg.v+')',line:{color:'#b45309',width:2,dash:'dash'}});

    // Critical points where f'(x) = 0
    var critX=[],critY=[];
    for(var j=1;j<ysDeriv.length-1;j++){
        if(ysDeriv[j]!==null&&ysDeriv[j-1]!==null&&ysDeriv[j+1]!==null){
            if((ysDeriv[j-1]>0&&ysDeriv[j+1]<0)||(ysDeriv[j-1]<0&&ysDeriv[j+1]>0)){
                critX.push(xs[j]);critY.push(ysFx[j]);
            }
        }
    }
    if(critX.length>0){
        traces.push({x:critX,y:critY,type:'scatter',mode:'markers',name:'Critical Points',marker:{color:'#ef4444',symbol:'diamond',size:10}});
    }

    // Tangent line at evaluated point
    if(cfg.evalResult&&cfg.evalPt){
        var a=parseFloat(cfg.evalPt);
        var fa=evalAtPoint(cfg.expr,cfg.v,a);
        var slope=cfg.evalResult.value;
        if(isFinite(fa)&&isFinite(slope)){
            var tanXs=[a-3,a+3];
            var tanYs=[fa+slope*(-3),fa+slope*(3)];
            traces.push({x:tanXs,y:tanYs,type:'scatter',mode:'lines',name:'Tangent at '+cfg.evalPt,line:{color:'#3b82f6',width:1.5,dash:'dot'}});
            traces.push({x:[a],y:[fa],type:'scatter',mode:'markers',name:'Point ('+cfg.evalPt+', '+fa.toFixed(2)+')',marker:{color:'#3b82f6',size:8}});
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
    // Strip the d/dx wrapper + |_{x=a} eval bar if the user typed a
    // semantic operator in MathLive visual mode.  Without unwrap, SymPy
    // would see literal `(d)/(dx)*x*sin(x)|_(x=2)` which is junk.  Pure
    // call (no opts) — we don't want side effects during code-gen.
    var rawExpr = exprInput.value.trim() || 'x^3';
    // Pipeline: unwrap semantic ops → normalizeExpr (inserts implicit
    // `*` between digit/letter and function names — `3sin(x)` →
    // `3*sin(x)`, mandatory for valid SymPy) → nerdamerToPython (^→**).
    var cleanExpr = normalizeExpr(unwrapSemanticDerivative(rawExpr));
    var pyExpr = nerdamerToPython(cleanExpr);
    var v = varSelect.value;
    var evalPt = (evalPointInput && evalPointInput.value || '').trim()
        .replace(/\u03c0/g, 'pi').replace(/\u221e/g, 'oo').replace(/infinity/gi, 'oo');

    // Both 'symbolic' (new staging value) and 'sympy-diff' (legacy) map
    // to the order-aware template.  Always use currentOrder so the user's
    // 1st/2nd/3rd toggle survives the round-trip into Python.  If they
    // also filled an Evaluate-at point, append the substitution + numeric
    // evaluation lines.
    var head = 'from sympy import *\n\n'
        + v + ' = symbols(\'' + v + '\')\n'
        + 'expr = ' + pyExpr + '\n'
        + 'n = ' + currentOrder + '\n\n'
        + 'result = diff(expr, ' + v + ', n)\n'
        + 'print(f"Derivative of order {n}:")\npprint(result)\n'
        + 'print("\\nLaTeX:", latex(result))';

    if (evalPt) {
        head += '\n\n# Evaluate at ' + v + ' = ' + evalPt + '\n'
            + 'value = result.subs(' + v + ', ' + evalPt + ')\n'
            + 'print(f"\\nf^({n})(' + evalPt + ') =", value)\n'
            + 'print("Numeric:", float(value) if value.is_real else value)';
    }

    if (template === 'numerical') {
        // Override with a SciPy-based numerical derivative around the eval
        // point (or 0 if not specified).
        var pt = evalPt || '0';
        return 'import numpy as np\n'
            + 'from scipy.misc import derivative\n\n'
            + 'def f(' + v + '):\n'
            + '    return ' + pyExpr.replace(/\bsin\b/g, 'np.sin')
                                    .replace(/\bcos\b/g, 'np.cos')
                                    .replace(/\btan\b/g, 'np.tan')
                                    .replace(/\bexp\b/g, 'np.exp')
                                    .replace(/\blog\b/g, 'np.log')
                                    .replace(/\bsqrt\b/g, 'np.sqrt') + '\n\n'
            + 'point = ' + pt + '\n'
            + 'order = ' + currentOrder + '\n'
            + 'value = derivative(f, point, n=order, dx=1e-6, order=2*order+1)\n'
            + 'print(f"f^({order})({point}) =", value)';
    }
    return head;
}

function loadCompilerWithTemplate(){
    var template=document.getElementById('dc-compiler-template').value;
    var code=buildCompilerCode(template);
    var b64Code=btoa(unescape(encodeURIComponent(code)));
    var config=JSON.stringify({lang:'python',code:b64Code});
    document.getElementById('dc-compiler-iframe').src='' + (window.__DC_CTX || '') + '/onecompiler-embed.jsp?c='+encodeURIComponent(config);
}
document.getElementById('dc-compiler-template').addEventListener('change',function(){loadCompilerWithTemplate();});

// Copy / Share
document.getElementById('dc-copy-latex-btn').addEventListener('click',function(){
    if(typeof ToolUtils!=='undefined'){ToolUtils.copyToClipboard(lastResultLatex,'LaTeX copied!');}
    else{navigator.clipboard.writeText(lastResultLatex);}
});
document.getElementById('dc-copy-text-btn').addEventListener('click',function(){
    if(typeof ToolUtils!=='undefined'){ToolUtils.copyToClipboard(lastResultText,'Result copied!');}
    else{navigator.clipboard.writeText(lastResultText);}
});
document.getElementById('dc-share-btn').addEventListener('click',function(){
    var params={expr:exprInput.value,v:varSelect.value,order:currentOrder};
    var pt=evalPointInput.value.trim();if(pt)params.pt=pt;
    if(typeof ToolUtils!=='undefined'){
        var url=ToolUtils.generateShareUrl(params,{toolName:'Derivative Calculator'});
        ToolUtils.copyToClipboard(url,'Share URL copied!');
    }
});

// Download PDF
document.getElementById('dc-download-pdf-btn').addEventListener('click',downloadResultPdf);

function downloadResultPdf(){
    if(!lastDiffContext){if(typeof ToolUtils!=='undefined')ToolUtils.showToast('No result to download',2000,'warning');return;}
    var ctx=lastDiffContext;var exprTeX=exprToLatex(ctx.expr);
    var container=document.createElement('div');
    container.style.cssText='position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
    document.body.appendChild(container);
    var title=document.createElement('div');title.style.cssText='font-size:22px;font-weight:700;margin-bottom:8px;color:#d97706;';
    title.textContent='Derivative Calculator \u2014 8gwifi.org';container.appendChild(title);
    var divider=document.createElement('div');divider.style.cssText='height:2px;background:linear-gradient(90deg,#d97706,#f59e0b,transparent);margin-bottom:24px;';
    container.appendChild(divider);
    var qLabel=document.createElement('div');qLabel.style.cssText='font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
    qLabel.textContent=orderLabelText(ctx.order)+' Derivative';container.appendChild(qLabel);
    var qMath=document.createElement('div');qMath.style.cssText='font-size:20px;margin-bottom:24px;';container.appendChild(qMath);
    var derivNotation=ctx.order===1?'\\frac{d}{d'+ctx.v+'}':'\\frac{d^{'+ctx.order+'}}{d'+ctx.v+'^{'+ctx.order+'}}';
    katex.render(derivNotation+'\\left['+exprTeX+'\\right]',qMath,{displayMode:true,throwOnError:false});
    var aLabel=document.createElement('div');aLabel.style.cssText='font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
    aLabel.textContent='Result';container.appendChild(aLabel);
    var aMath=document.createElement('div');aMath.style.cssText='font-size:22px;margin-bottom:16px;padding:16px;background:#fffbeb;border-radius:8px;';container.appendChild(aMath);
    katex.render(ctx.intermediates[ctx.intermediates.length-1].tex,aMath,{displayMode:true,throwOnError:false});
    var methodDiv=document.createElement('div');methodDiv.style.cssText='font-size:13px;color:#64748b;margin-bottom:20px;';
    methodDiv.textContent='Method: '+ctx.method;container.appendChild(methodDiv);
    if(ctx.evalResult){
        var evalDiv=document.createElement('div');evalDiv.style.cssText='font-size:16px;margin-bottom:16px;padding:12px;background:#d97706;color:#fff;border-radius:8px;text-align:center;font-weight:700;';
        evalDiv.textContent=orderLabelText(ctx.order)+'('+ctx.evalResult.point+') = '+ctx.evalResult.value.toFixed(6);container.appendChild(evalDiv);
    }
    // Steps if rendered
    var stepsArea=document.getElementById('dc-steps-area');
    if(stepsArea&&stepsArea.children.length>0){
        var stepsLabel=document.createElement('div');stepsLabel.style.cssText='font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
        stepsLabel.textContent='Step-by-Step Solution';container.appendChild(stepsLabel);
        var stepEls=stepsArea.querySelectorAll('.dc-step');
        for(var i=0;i<stepEls.length;i++){
            var stepRow=document.createElement('div');stepRow.style.cssText='display:flex;gap:12px;margin-bottom:12px;';
            var stepNum=document.createElement('div');stepNum.style.cssText='width:24px;height:24px;background:#d97706;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
            stepNum.textContent=(i+1);stepRow.appendChild(stepNum);
            var stepBody=document.createElement('div');stepBody.style.cssText='flex:1;';
            var titleEl=stepEls[i].querySelector('.dc-step-title');
            if(titleEl){var sTitle=document.createElement('div');sTitle.style.cssText='font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';sTitle.textContent=titleEl.textContent;stepBody.appendChild(sTitle);}
            var mathEl=stepEls[i].querySelector('.dc-step-math');
            if(mathEl){var sMath=document.createElement('div');sMath.style.cssText='font-size:16px;';
                var annotation=mathEl.querySelector('annotation');
                if(annotation){katex.render(annotation.textContent,sMath,{displayMode:true,throwOnError:false});}
                else{sMath.innerHTML=mathEl.innerHTML;}
                stepBody.appendChild(sMath);}
            stepRow.appendChild(stepBody);container.appendChild(stepRow);
        }
    }
    var footer=document.createElement('div');footer.style.cssText='margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
    footer.innerHTML='<span>Generated by 8gwifi.org Derivative Calculator</span><span>'+new Date().toLocaleDateString()+'</span>';
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
        pdf.save('derivative-'+ctx.expr.replace(/[^a-zA-Z0-9]/g,'_').substring(0,30)+'.pdf');
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
    var expr=p.get('expr');var v=p.get('v');var order=p.get('order');var pt=p.get('pt');
    if(expr)exprInput.value=decodeURIComponent(expr);
    if(v)varSelect.value=v;
    if(order){
        var o=parseInt(order);if(o>=1&&o<=5){
            currentOrder=o;
            orderBtns.forEach(function(b){b.classList.toggle('active',parseInt(b.getAttribute('data-order'))===o);});
        }
    }
    if(pt)evalPointInput.value=decodeURIComponent(pt);
    if(expr){updatePreview();setTimeout(doDifferentiate,300);}
}

function escapeHtml(str){var div=document.createElement('div');div.appendChild(document.createTextNode(str));return div.innerHTML;}

// ========== Print Worksheet ==========
function openDerivativeWorksheet() {
    if (typeof WorksheetEngine !== 'undefined') {
        WorksheetEngine.open({
            jsonUrl: 'worksheet/math/calculus/derivatives.json',
            title: 'Derivatives Practice Worksheet',
            accentColor: '#2563eb',
            branding: '8gwifi.org',
            defaultCount: 20
        });
    }
}
var dcWsBtn = document.getElementById('dc-worksheet-btn');
if (dcWsBtn) dcWsBtn.addEventListener('click', openDerivativeWorksheet);

loadFromUrl();

// ═══════════════════════════════════════════════════════════
// Image Scan — expose internals for the image-to-math module
// defined below. We don't build a cross-tool "DC" global like
// IC; we just stash what the scan callbacks need.
// ═══════════════════════════════════════════════════════════
window.__DC_SCAN__ = {
    exprInput: exprInput,
    varSelect: varSelect,
    orderBtns: orderBtns,
    getOrder: function () { return currentOrder; },
    setOrder: function (n) {
        if (!(n >= 1 && n <= 5)) return;
        currentOrder = n;
        orderBtns.forEach(function (b) {
            b.classList.toggle('active', parseInt(b.getAttribute('data-order')) === n);
        });
    },
    updatePreview: updatePreview,
    doDifferentiate: doDifferentiate,
    nerdamerToPython: nerdamerToPython,
    escapeHtml: escapeHtml,
    generateDiffSteps: generateDiffSteps,
    identifyDiffMethod: identifyDiffMethod,
    exprToLatex: exprToLatex
};
})();
