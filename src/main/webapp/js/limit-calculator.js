(function(){
'use strict';
var CTX=window.__LC_CTX||'';
var normalizeExpr=(typeof LimitCalculatorCore!=='undefined'&&LimitCalculatorCore.normalizeExpr)?LimitCalculatorCore.normalizeExpr:function(e){return(e&&e.trim)?e.trim():'';};
var exprInput=document.getElementById('lc-expr');
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
var tabBtns=document.querySelectorAll('.lc-output-tab');
var panels=document.querySelectorAll('.lc-panel');
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
exprInput.addEventListener('input',function(){clearTimeout(previewTimer);previewTimer=setTimeout(updatePreview,200);});
pointInput.addEventListener('input',function(){clearTimeout(previewTimer);previewTimer=setTimeout(updatePreview,200);});
varSelect.addEventListener('change',updatePreview);

function updatePreview(){
    var raw=exprInput.value.trim();
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

function exprToLatex(expr){
    try{return nerdamer(expr).toTeX();}catch(e){
        return expr.replace(/\*/g,' \\cdot ').replace(/sqrt\(/g,'\\sqrt{').replace(/\)/g,'}').replace(/\^(\w)/g,'^{$1}');
    }
}

function pointToLatex(pt){
    var p=pt.trim()
        .replace(/\u221e/g,'infinity').replace(/\u03c0/g,'pi').replace(/\u2212/g,'-')
        .replace(/\u2080/g,'0').replace(/\u2081/g,'1').replace(/\u2082/g,'2').replace(/\u2083/g,'3')
        .replace(/\u2084/g,'4').replace(/\u2085/g,'5').replace(/\u2086/g,'6').replace(/\u2087/g,'7')
        .replace(/\u2088/g,'8').replace(/\u2089/g,'9')
        .toLowerCase();
    if(p==='infinity'||p==='inf')return'\\infty';
    if(p==='-infinity'||p==='-inf')return'-\\infty';
    if(p==='pi')return'\\pi';
    if(p==='e')return'e';
    return pt;
}

function parsePoint(pt){
    var p=pt.trim()
        .replace(/\u03c0/g,'pi').replace(/\u221e/g,'infinity').replace(/\u2212/g,'-')
        .replace(/\u00b2/g,'^2').replace(/\u00b3/g,'^3')
        .toLowerCase();
    if(p==='infinity'||p==='inf')return Infinity;
    if(p==='-infinity'||p==='-inf')return -Infinity;
    if(p==='pi')return Math.PI;
    if(p==='e')return Math.E;
    var val=parseFloat(p);
    return isNaN(val)?null:val;
}

// Main limit calculation
calcBtn.addEventListener('click',doCalculateLimit);
exprInput.addEventListener('keydown',function(e){if(e.key==='Enter')doCalculateLimit();});
pointInput.addEventListener('keydown',function(e){if(e.key==='Enter')doCalculateLimit();});

function doCalculateLimit(){
    var raw=exprInput.value.trim();
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

function computeLimit(expr,v,a,dir){
    var result={value:null,method:'Numerical',form:null,approxTable:null,numApprox:null};

    // Step 1: Try direct substitution
    if(isFinite(a)){
        try{
            var scope={};scope[v]=a;
            var val=nerdamer(expr).evaluate(scope);
            var num=parseFloat(val.text('decimals'));
            if(isFinite(num)){
                result.value=num;result.method='Direct Substitution';
                result.approxTable=buildApproxTable(expr,v,a,dir);
                return result;
            }
        }catch(e){}
    }

    // Step 2: Detect indeterminate form for fractions
    var fracParts=splitFraction(expr);
    if(fracParts&&isFinite(a)){
        var numVal=safeEval(fracParts.num,v,a);
        var denVal=safeEval(fracParts.den,v,a);
        if(numVal!==null&&denVal!==null){
            if(Math.abs(numVal)<1e-10&&Math.abs(denVal)<1e-10)result.form='0/0';
            else if(!isFinite(numVal)&&!isFinite(denVal))result.form='\u221E/\u221E';
        }
    }

    // Step 3: Try algebraic simplification
    try{
        var simplified=nerdamer('simplify('+expr+')').text();
        if(simplified!==expr&&isFinite(a)){
            var scope2={};scope2[v]=a;
            var val2=parseFloat(nerdamer(simplified).evaluate(scope2).text('decimals'));
            if(isFinite(val2)){
                result.value=val2;result.method='Algebraic Simplification';
                result.approxTable=buildApproxTable(expr,v,a,dir);
                return result;
            }
        }
    }catch(e){}

    // Step 4: L'Hopital for 0/0 or inf/inf
    if(fracParts&&(result.form==='0/0'||result.form==='\u221E/\u221E')){
        try{
            var numExpr=fracParts.num;var denExpr=fracParts.den;
            for(var iter=0;iter<3;iter++){
                var numD=nerdamer('diff('+numExpr+','+v+')').text();
                var denD=nerdamer('diff('+denExpr+','+v+')').text();
                var newExpr='('+numD+')/('+denD+')';
                var scope3={};scope3[v]=a;
                var val3=parseFloat(nerdamer(newExpr).evaluate(scope3).text('decimals'));
                if(isFinite(val3)){
                    result.value=val3;result.method="L'H\u00F4pital's Rule";
                    result.approxTable=buildApproxTable(expr,v,a,dir);
                    return result;
                }
                numExpr=numD;denExpr=denD;
            }
        }catch(e){}
    }

    // Step 5: Known limits
    var known=checkKnownLimits(expr,v,a);
    if(known!==null){
        result.value=known.value;result.method=known.method;
        result.approxTable=buildApproxTable(expr,v,a,dir);
        return result;
    }

    // Step 6: Numerical approximation
    var approx=numericalLimit(expr,v,a,dir);
    result.approxTable=approx.table;
    if(approx.value!==null){
        result.value=approx.value;
        result.method='Numerical Approximation';
        result.numApprox=approx;
    }else if(approx.leftValue!==null&&approx.rightValue!==null){
        if(dir==='left'){result.value=approx.leftValue;result.method='Numerical (Left)';}
        else if(dir==='right'){result.value=approx.rightValue;result.method='Numerical (Right)';}
        else{result.value='DNE';result.method='Does Not Exist';result.numApprox=approx;}
    }else if(approx.leftValue!==null){
        result.value=approx.leftValue;result.method='Numerical (Left)';
    }else if(approx.rightValue!==null){
        result.value=approx.rightValue;result.method='Numerical (Right)';
    }else{
        result.value='DNE';result.method='Does Not Exist';
    }
    return result;
}

function splitFraction(expr){
    var depth=0;
    for(var i=0;i<expr.length;i++){
        if(expr[i]==='(')depth++;else if(expr[i]===')')depth--;
        if(depth===0&&expr[i]==='/'&&i>0&&i<expr.length-1){
            return{num:expr.substring(0,i),den:expr.substring(i+1)};
        }
    }
    return null;
}

function safeEval(expr,v,a){
    try{var scope={};scope[v]=a;return parseFloat(nerdamer(expr).evaluate(scope).text('decimals'));}catch(e){return null;}
}

function checkKnownLimits(expr,v,a){
    var e=expr.replace(/\s/g,'').toLowerCase();
    var vv=v.toLowerCase();
    if((e==='sin('+vv+')/'+vv||e==='sin('+vv+')/('+vv+')')&&a===0)return{value:1,method:'Known Limit (sin(x)/x)'};
    if((e==='(e^'+vv+'-1)/'+vv||e==='(e^('+vv+')-1)/'+vv||e==='(e^'+vv+'-1)/('+vv+')')&&a===0)return{value:1,method:'Known Limit ((e^x-1)/x)'};
    if(e==='tan('+vv+')/'+vv&&a===0)return{value:1,method:'Known Limit (tan(x)/x)'};
    if((e==='(1-cos('+vv+'))/'+vv+'^2'||e==='(1-cos('+vv+'))/('+vv+'^2)')&&a===0)return{value:0.5,method:'Known Limit ((1-cos(x))/x\u00B2)'};
    return null;
}

function numericalLimit(expr,v,a,dir){
    var table={left:[],right:[]};
    var leftVals=[],rightVals=[];
    if(isFinite(a)){
        var offsets=[0.1,0.01,0.001,0.0001,0.00001];
        if(dir!=='right'){
            for(var i=0;i<offsets.length;i++){
                var xv=a-offsets[i];var yv=safeEval(expr,v,xv);
                table.left.push({x:xv,y:yv});
                if(yv!==null&&isFinite(yv))leftVals.push(yv);
            }
        }
        if(dir!=='left'){
            for(var j=0;j<offsets.length;j++){
                var xr=a+offsets[j];var yr=safeEval(expr,v,xr);
                table.right.push({x:xr,y:yr});
                if(yr!==null&&isFinite(yr))rightVals.push(yr);
            }
        }
    }else{
        var bigVals=a===Infinity?[10,100,1000,10000,100000]:[-10,-100,-1000,-10000,-100000];
        for(var k=0;k<bigVals.length;k++){
            var xb=bigVals[k];var yb=safeEval(expr,v,xb);
            table.right.push({x:xb,y:yb});
            if(yb!==null&&isFinite(yb))rightVals.push(yb);
        }
    }
    var leftLim=convergeTo(leftVals);
    var rightLim=convergeTo(rightVals);
    var value=null;
    if(dir==='left')value=leftLim;
    else if(dir==='right')value=rightLim;
    else if(leftLim!==null&&rightLim!==null&&Math.abs(leftLim-rightLim)<0.001)value=(leftLim+rightLim)/2;
    else if(!isFinite(a))value=rightLim;
    return{value:value,leftValue:leftLim,rightValue:rightLim,table:table};
}

function convergeTo(vals){
    if(vals.length<2)return vals.length===1?vals[0]:null;
    var last=vals[vals.length-1];
    var prev=vals[vals.length-2];
    if(Math.abs(last)>1e12)return last>0?Infinity:-Infinity;
    if(Math.abs(last-prev)<0.01)return Math.round(last*1e8)/1e8;
    return last;
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

function buildApproxTable(expr,v,a,dir){
    return numericalLimit(expr,v,a,dir).table;
}

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

function generateLimitSteps(ctx){
    var steps=[];var expr=ctx.expr;var v=ctx.v;var a=ctx.a;var res=ctx.result;
    var exprTeX=ctx.exprTeX;var arrow=ctx.arrow;

    // Step 1: State the limit
    steps.push({title:'State the limit',latex:'\\lim_{'+arrow+'}\\left['+exprTeX+'\\right]'});

    if(res.method==='Direct Substitution'){
        steps.push({title:'Try direct substitution: '+v+' = '+ctx.ptStr,latex:'f('+ctx.ptStr+') = '+ctx.valueLatex});
        steps.push({title:'The function is defined at '+v+' = '+ctx.ptStr,latex:'\\lim_{'+arrow+'}'+exprTeX+' = '+ctx.valueLatex});
        return steps;
    }

    if(res.form){
        steps.push({title:'Direct substitution yields indeterminate form',latex:'\\text{Form: }'+escapeHtml(res.form)});
    }

    var frac=splitFraction(expr);
    if(res.method==="L'H\u00F4pital's Rule"&&frac){
        steps.push({title:"Apply L'H\u00F4pital's Rule: differentiate numerator and denominator",latex:"\\lim_{"+arrow+"}\\frac{f("+v+")}{g("+v+")} = \\lim_{"+arrow+"}\\frac{f'("+v+")}{g'("+v+")}"});
        try{
            var numD=nerdamer('diff('+frac.num+','+v+')');
            var denD=nerdamer('diff('+frac.den+','+v+')');
            steps.push({title:'Differentiate numerator',latex:"f'("+v+') = '+numD.toTeX()});
            steps.push({title:'Differentiate denominator',latex:"g'("+v+') = '+denD.toTeX()});
            steps.push({title:'Evaluate the new limit',latex:'\\lim_{'+arrow+'}\\frac{'+numD.toTeX()+'}{'+denD.toTeX()+'} = '+ctx.valueLatex});
        }catch(e){
            steps.push({title:'Evaluate after applying the rule',latex:'= '+ctx.valueLatex});
        }
        return steps;
    }

    if(res.method==='Algebraic Simplification'&&frac){
        steps.push({title:'Simplify the expression algebraically',latex:'\\text{Factor and cancel common terms}'});
        try{
            var simplified=nerdamer('simplify('+expr+')').toTeX();
            steps.push({title:'Simplified form',latex:simplified});
        }catch(e){}
        steps.push({title:'Substitute '+v+' = '+ctx.ptStr,latex:'= '+ctx.valueLatex});
        return steps;
    }

    if(res.method&&res.method.indexOf('Known Limit')===0){
        steps.push({title:'This is a known standard limit',latex:'\\lim_{'+arrow+'}'+exprTeX+' = '+ctx.valueLatex});
        return steps;
    }

    // Numerical or DNE - show table approach
    if(res.method==='Numerical Approximation'||res.method==='Does Not Exist'){
        steps.push({title:'Use numerical approximation',latex:'\\text{Evaluate f('+v+') for values approaching '+ctx.ptStr+'}'});
        if(res.numApprox&&res.numApprox.leftValue!==null&&res.numApprox.rightValue!==null){
            var lv=typeof res.numApprox.leftValue==='number'?res.numApprox.leftValue.toFixed(4):String(res.numApprox.leftValue);
            var rv=typeof res.numApprox.rightValue==='number'?res.numApprox.rightValue.toFixed(4):String(res.numApprox.rightValue);
            steps.push({title:'Left-hand limit',latex:'\\lim_{'+v+'\\to '+pointToLatex(ctx.ptStr)+'^{-}} = '+lv});
            steps.push({title:'Right-hand limit',latex:'\\lim_{'+v+'\\to '+pointToLatex(ctx.ptStr)+'^{+}} = '+rv});
        }
        steps.push({title:'Conclusion',latex:'\\lim_{'+arrow+'}'+exprTeX+' = '+ctx.valueLatex});
        return steps;
    }

    return null;
}

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
    var expr=exprInput.value.trim()||'(x**2-1)/(x-1)';
    var pyExpr=nerdamerToPython(expr);var v=varSelect.value;
    var pt=pointInput.value.trim()||'1';
    var pyPt=pt.replace(/infinity/gi,'oo').replace(/inf/gi,'oo').replace(/pi/gi,'pi');
    if(template==='sympy-limit'){
        return 'from sympy import *\n\n'+v+' = symbols(\''+v+'\')\nexpr = '+pyExpr+'\n\nresult = limit(expr, '+v+', '+pyPt+')\nprint("Limit:")\npprint(result)\nprint("\\nLaTeX:", latex(result))';
    }else{
        return 'from sympy import *\n\n'+v+' = symbols(\''+v+'\')\nexpr = '+pyExpr+'\n\nleft = limit(expr, '+v+', '+pyPt+', \'-\')\nright = limit(expr, '+v+', '+pyPt+', \'+\')\nprint("Left-hand limit:")\npprint(left)\nprint("\\nRight-hand limit:")\npprint(right)\nif left == right:\n    print("\\nTwo-sided limit:", left)\nelse:\n    print("\\nLimit does not exist (left != right)")';
    }
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

loadFromUrl();
})();
