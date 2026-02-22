# Snippet to embed in JSP - produces STEPS JSON from integral_steps
# Escape for JavaScript: " -> \", \ -> \\, newline -> \n
import json
from sympy.integrals.manualintegrate import (
    integral_steps, DontKnowRule,
    RewriteRule, AddRule, ConstantTimesRule, URule, ReciprocalRule,
    ArctanRule, PartsRule, ExpRule, PowerRule, ConstantRule, AlternativeRule
)
def _c(r): return getattr(r,'integrand',None) or getattr(r,'context',None)
def _s(r): return getattr(r,'variable',None) or getattr(r,'symbol',None)
def r2s(rule,v,st=None):
    if st is None: st=[]
    if rule is None or isinstance(rule,DontKnowRule): return st
    vs=_s(rule) or v; vs=str(vs)
    try:
        ctx=_c(rule); res=rule.eval() if hasattr(rule,'eval') else None
        if isinstance(rule,RewriteRule):
            st.append({'title':'Rewrite','latex':r'\int '+latex(ctx)+r' \,d'+vs+r' = \int '+latex(rule.rewritten)+r' \,d'+vs,'rule':'RewriteRule'})
            r2s(rule.substep,v,st)
        elif isinstance(rule,AddRule):
            st.append({'title':'Sum rule','latex':r'\int (f+g)\,d'+vs+r' = \int f\,d'+vs+r' + \int g\,d'+vs,'rule':'AddRule'})
            for s in rule.substeps: r2s(s,v,st)
            if res: st.append({'title':'Combine','latex':'= '+latex(res)+r' + C','rule':'AddRule'})
        elif isinstance(rule,ConstantTimesRule):
            st.append({'title':'Constant factor','latex':r'\int '+latex(ctx)+r' \,d'+vs+r' = '+latex(rule.constant)+r' \int '+latex(rule.other)+r' \,d'+vs,'rule':'ConstantTimesRule'})
            r2s(rule.substep,v,st)
            if res: st.append({'title':'Simplify','latex':'= '+latex(res)+r' + C','rule':'ConstantTimesRule'})
        elif isinstance(rule,URule):
            st.append({'title':'u-Substitution','latex':r'Let\ u = '+latex(rule.u_func)+r',\quad \frac{du}{d'+vs+r'} = '+latex(rule.u_func.diff(_s(rule))),'rule':'URule'})
            r2s(rule.substep,v,st)
            if res: st.append({'title':'Back substitute','latex':'= '+latex(res)+r' + C','rule':'URule'})
        elif isinstance(rule,ReciprocalRule):
            st.append({'title':'Reciprocal','latex':r'\int \frac{1}{'+latex(rule.base)+r'} \,d'+vs+r' = \ln|'+latex(rule.base)+r'| + C = '+latex(res),'rule':'ReciprocalRule'})
        elif isinstance(rule,ArctanRule):
            st.append({'title':'Arctan','latex':r'\int '+latex(ctx)+r' \,d'+vs+r' = '+latex(res)+r' + C','rule':'ArctanRule'})
        elif isinstance(rule,PartsRule):
            st.append({'title':'Integration by parts','latex':r'\int u\,dv = uv - \int v\,du.\quad u='+latex(rule.u)+r',\ dv='+latex(rule.dv)+r'\,d'+vs,'rule':'PartsRule'})
            r2s(rule.v_step,v,st); r2s(rule.second_step,v,st)
            if res: st.append({'title':'Result','latex':'= '+latex(res)+r' + C','rule':'PartsRule'})
        elif isinstance(rule,ExpRule):
            st.append({'title':'Exponential','latex':r'\int '+latex(ctx)+r' \,d'+vs+r' = '+latex(res)+r' + C','rule':'ExpRule'})
        elif isinstance(rule,PowerRule):
            st.append({'title':'Power rule','latex':r'\int '+latex(ctx)+r' \,d'+vs+r' = '+latex(res)+r' + C','rule':'PowerRule'})
        elif isinstance(rule,ConstantRule):
            st.append({'title':'Constant','latex':r'\int '+latex(rule.constant)+r' \,d'+vs+r' = '+latex(res),'rule':'ConstantRule'})
        elif isinstance(rule,AlternativeRule):
            for a in rule.alternatives[:1]: r2s(a,v,st)
            if not st and res: st.append({'title':'Result','latex':'= '+latex(res)+r' + C'})
        else:
            if ctx and res: st.append({'title':type(rule).__name__.replace('Rule',''),'latex':r'\int '+latex(ctx)+r' \,d'+vs+r' = '+latex(res)+r' + C'})
    except Exception:
        if res: st.append({'title':'Result','latex':'= '+latex(res)+r' + C'})
    return st
