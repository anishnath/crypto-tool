<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>RC/RLC Filter Calculator – Cutoff, Resonance, Q, Bode Plot</title>
  <meta name="description" content="Compute RC low/high‑pass cutoff and series RLC band‑pass resonance, Q, and bandwidth. Interactive Bode magnitude plot with presets, unit‑aware inputs, share link, and PNG export.">
  <meta name="keywords" content="rc filter calculator, rlc resonance calculator, bode plot, low pass calculator, high pass calculator, band pass calculator, cutoff frequency, quality factor">
  <link rel="canonical" href="https://8gwifi.org/rc-rlc-filter.jsp">
  <meta name="robots" content="index,follow">
  <meta property="og:title" content="RC/RLC Filter Calculator – Cutoff, Resonance, Q, Bode Plot">
  <meta property="og:description" content="RC low/high‑pass and RLC band‑pass calculators with Bode plot, presets, and unit‑aware inputs.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/rc-rlc-filter.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"RC/RLC Filter Calculator","url":"https://8gwifi.org/rc-rlc-filter.jsp","applicationCategory":"EducationalApplication","operatingSystem":"Web","description":"Compute RC cutoff and RLC resonance/Q and visualize the Bode magnitude plot. Unit‑aware inputs, presets, and share links included.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"},"keywords":["rc filter calculator","rlc resonance","bode plot","cutoff frequency","quality factor"]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do I find the RC cutoff frequency?","acceptedAnswer":{"@type":"Answer","text":"For RC low/high‑pass, the cutoff is f_c = 1/(2πRC). Enter R and C in SI units and the tool computes f_c and plots the −3 dB point."}},
    {"@type":"Question","name":"What are resonance and Q for RLC?","acceptedAnswer":{"@type":"Answer","text":"For a series RLC band‑pass (output across R), f_0 = 1/(2π√(LC)). The quality factor Q = (1/R)√(L/C) and bandwidth BW ≈ f_0/Q. The plot shows a peak near f_0."}},
    {"@type":"Question","name":"How do units work?","acceptedAnswer":{"@type":"Answer","text":"Choose convenient prefixes (Ω/kΩ/MΩ, nF/µF, mH/H). The calculator converts to SI internally and displays derived values and plots accordingly."}},
    {"@type":"Question","name":"What is a Bode plot and how do I read it?","acceptedAnswer":{"@type":"Answer","text":"A Bode magnitude plot shows |H(jω)| in dB vs frequency on a log axis. The −3 dB point marks the cutoff for RC/RL filters. For RLC band‑pass, the peak occurs near f_0 and the −3 dB points define the bandwidth (≈ f_0/Q)."}},
    {"@type":"Question","name":"Where are these filters used?","acceptedAnswer":{"@type":"Answer","text":"RC/RL low‑/high‑pass: sensor smoothing, anti‑aliasing, audio tone controls, power‑supply decoupling. RLC band‑pass: radio receivers, instrumentation, resonance experiments, selecting narrow frequency bands."}},
    {"@type":"Question","name":"What should learners notice?","acceptedAnswer":{"@type":"Answer","text":"Relate time constants to cutoff: τ=RC for RC and τ=L/R for RL. On the Bode plot, 20 dB/decade slopes appear beyond cutoff. For RLC, increasing R lowers Q and broadens the peak; changing L or C shifts f_0 without changing its shape when Q is fixed."}},
    {"@type":"Question","name":"How do RC, RL, and RLC compare?","acceptedAnswer":{"@type":"Answer","text":"RC and RL are single‑pole filters with f_c at 1/(2πRC) and R/(2πL) respectively and ~20 dB/decade roll‑off; RLC introduces resonance at f_0=1/(2π√(LC)) with quality factor Q=(1/R)√(L/C), giving a peaked band‑pass (or band‑stop in other topologies)."}}
  ]}
  </script>
  <style>
    .rf .card-header{padding:.6rem .9rem;font-weight:600}
    .rf .card-body{padding:.7rem .9rem}
    .rf .form-group{margin-bottom:.55rem}
    #bodeCanvas{width:100%;height:260px;border:1px solid #e5e7eb;border-radius:6px;background:#fff}
    .badge-note{background:#eef2ff;color:#3730a3}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 rf">
  <h1 class="mb-2">RC/RLC Filter Calculator</h1>
  <p class="text-muted mb-3">Cutoff, resonance, Q, bandwidth, and Bode magnitude plot for common filters.</p>
  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3"><h5 class="card-header d-flex justify-content-between align-items-center">Inputs
        <div class="dropdown"><button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="presetBtn" data-toggle="dropdown">Presets</button>
          <div class="dropdown-menu" aria-labelledby="presetBtn">
            <a class="dropdown-item" href="#" data-preset="rc-lp">RC Low‑pass: 10 kΩ, 10 nF</a>
            <a class="dropdown-item" href="#" data-preset="rc-hp">RC High‑pass: 1 kΩ, 100 nF</a>
            <a class="dropdown-item" href="#" data-preset="rlc-bp">RLC Band‑pass: R=100 Ω, L=10 mH, C=10 nF</a>
          </div></div>
      </h5><div class="card-body">
        <div class="form-group form-inline">
          <label class="mr-2 mb-0">Filter</label>
          <select id="mode" class="form-control" style="max-width:220px">
            <option value="rc_lp" selected>RC Low‑pass</option>
            <option value="rc_hp">RC High‑pass</option>
            <option value="rlc_bp">RLC Band‑pass (series, across R)</option>
          </select>
        </div>
        <div id="grpRC">
          <div class="form-group form-inline"><label class="mr-2 mb-0" for="R">R</label><input id="R" type="number" step="0.001" class="form-control mr-2" style="max-width:160px" value="10000"><select id="Ru" class="form-control" style="max-width:110px"><option value="ohm">Ω</option><option value="k">kΩ</option><option value="M">MΩ</option></select></div>
          <div class="form-group form-inline"><label class="mr-2 mb-0" for="C">C</label><input id="C" type="number" step="0.001" class="form-control mr-2" style="max-width:160px" value="10"><select id="Cu" class="form-control" style="max-width:110px"><option value="F">F</option><option value="mF">mF</option><option value="uF">µF</option><option value="nF" selected>nF</option><option value="pF">pF</option></select></div>
        </div>
        <div id="grpRLC" style="display:none">
          <div class="form-group form-inline"><label class="mr-2 mb-0" for="RR">R</label><input id="RR" type="number" step="0.001" class="form-control mr-2" style="max-width:160px" value="100"><span class="text-muted">Ω</span></div>
          <div class="form-group form-inline"><label class="mr-2 mb-0" for="L">L</label><input id="L" type="number" step="0.001" class="form-control mr-2" style="max-width:160px" value="10"><select id="Lu" class="form-control" style="max-width:110px"><option value="H">H</option><option value="mH" selected>mH</option><option value="uH">µH</option></select></div>
          <div class="form-group form-inline"><label class="mr-2 mb-0" for="CC">C</label><input id="CC" type="number" step="0.001" class="form-control mr-2" style="max-width:160px" value="10"><select id="CCu" class="form-control" style="max-width:110px"><option value="F">F</option><option value="mF">mF</option><option value="uF">µF</option><option value="nF" selected>nF</option><option value="pF">pF</option></select></div>
        </div>
        <div class="form-group form-inline"><label class="mr-2 mb-0">Sweep</label>
          <select id="sweep" class="form-control mr-2" style="max-width:140px"><option value="auto" selected>Auto</option><option value="manual">Manual</option></select>
          <input id="fmin" type="number" step="0.1" class="form-control mr-2" style="max-width:120px" value="10" title="Min Hz">
          <input id="fmax" type="number" step="0.1" class="form-control" style="max-width:120px" value="100000" title="Max Hz">
        </div>
        <div class="d-flex align-items-center"><button id="btnRun" class="btn btn-primary btn-sm mr-2">Run</button><button id="btnSave" class="btn btn-outline-secondary btn-sm mr-2">Save PNG</button><button id="btnShare" class="btn btn-outline-secondary btn-sm">Share URL</button></div>
      </div></div>
      <div class="card mb-3"><h5 class="card-header">Derived Values</h5><div class="card-body small">
        <div id="dv_rc" style="display:none">f<sub>c</sub> = <span id="fc">–</span> Hz</div>
        <div id="dv_rlc" style="display:none">f<sub>0</sub> = <span id="f0">–</span> Hz, Q = <span id="Q">–</span>, BW ≈ <span id="BW">–</span> Hz</div>
      </div></div>
      <div class="card mb-3"><h5 class="card-header">Notes</h5><div class="card-body small text-muted">
        <div><span class="badge badge-note">RC</span> f<sub>c</sub> = 1/(2πRC); magnitude at f<sub>c</sub> is −3 dB.</div>
        <div class="mt-1"><span class="badge badge-note">RLC (series)</span> f<sub>0</sub> = 1/(2π√(LC)), Q = (1/R)√(L/C), BW ≈ f<sub>0</sub>/Q.</div>
      </div></div>

    </div>
    <div class="col-lg-8">
      <div class="card mb-3"><h5 class="card-header">Bode Magnitude (dB)</h5><div class="card-body">
        <canvas id="bodeCanvas" height="260"></canvas>
        <small class="text-muted d-block mt-1">Log frequency axis; presets explore common scenarios.</small>
      </div>
      <div class="card mb-3"><h5 class="card-header">About & Learning</h5><div class="card-body small">
              <div><strong>What this is:</strong> RC/RL filters pass low or high frequencies; RLC band‑pass selects a narrow band around the resonance f<sub>0</sub>.</div>
              <div class="mt-1"><strong>Why it’s used:</strong> smoothing sensor noise, anti‑aliasing, tone controls, EMI mitigation (RC/RL), and tuning/selectivity (RLC) in radios and instruments.</div>
              <div class="mt-1"><strong>How to read the plot:</strong> The Bode magnitude (dB) uses a log frequency axis. The −3 dB point marks cutoff (RC/RL). For RLC, the peak near f<sub>0</sub> and the −3 dB points define bandwidth (≈ f<sub>0</sub>/Q).</div>
              <div class="mt-1"><strong>Learning tips:</strong> Connect time constants to cutoff (τ=RC, τ=L/R). Notice 20 dB/dec slopes beyond cutoff. Increasing R lowers Q and broadens the RLC peak; changing L or C shifts f<sub>0</sub>.</div>
      </div></div>
      <div class="card mb-3"><h5 class="card-header">RC/RL/RLC Comparison</h5><div class="card-body small">
        <div class="table-responsive">
          <table class="table table-sm mb-2">
            <thead class="thead-light">
              <tr><th>Aspect</th><th>RC</th><th>RL</th><th>RLC (series, BP)</th></tr>
            </thead>
            <tbody>
              <tr><td>Key parameter</td><td>τ = RC</td><td>τ = L/R</td><td>f<sub>0</sub> = 1/(2π√(LC))</td></tr>
              <tr><td>Cutoff/Resonance</td><td>f<sub>c</sub> = 1/(2πRC)</td><td>f<sub>c</sub> = R/(2πL)</td><td>Q = (1/R)√(L/C), BW ≈ f<sub>0</sub>/Q</td></tr>
              <tr><td>Roll‑off</td><td>~20 dB/dec (1st order)</td><td>~20 dB/dec (1st order)</td><td>Rises then falls (~±20 dB/dec around f<sub>0</sub>)</td></tr>
              <tr><td>Phase @ f<sub>c</sub>/f<sub>0</sub></td><td>±45° (LP/HP)</td><td>±45° (LP/HP)</td><td>≈0° at f<sub>0</sub> (lead/lag either side)</td></tr>
              <tr><td>Typical uses</td><td>Smoothing, anti‑aliasing, tone</td><td>Decoupling, current shaping</td><td>Tuning/selectivity, resonance</td></tr>
            </tbody>
          </table>
        </div>
        <div class="text-muted">Note: Other RLC topologies (low/high/band‑stop, parallel RLC) have different transfer functions but share f<sub>0</sub>, Q relationships.</div>
      </div></div>
      </div>
    </div>
  </div>
</div>
<script>
;(function(){
  function $(id){ return document.getElementById(id); }
  const mode=$('mode');
  const R=$('R'), Ru=$('Ru'), C=$('C'), Cu=$('Cu');
  const RR=$('RR'), L=$('L'), Lu=$('Lu'), CC=$('CC'), CCu=$('CCu');
  const grpRC=$('grpRC'), grpRLC=$('grpRLC');
  const sweep=$('sweep'), fmin=$('fmin'), fmax=$('fmax');
  const fc=$('fc'), dv_rc=$('dv_rc'); const f0=$('f0'), Q=$('Q'), BW=$('BW'), dv_rlc=$('dv_rlc');
  const ctx=$('bodeCanvas').getContext('2d'); let chart;

  function showGroups(){
    const md=mode.value;
    grpRC.style.display = (md.indexOf('rc_')===0)? '' : 'none';
    grpRLC.style.display = (md==='rlc_bp')? '' : 'none';
    dv_rc.style.display = (md.indexOf('rc_')===0)? '' : 'none';
    dv_rlc.style.display = (md==='rlc_bp')? '' : 'none';
  }

  function ohm(v,u){ if(u==='k') return v*1e3; if(u==='M') return v*1e6; return v; }
  function farad(v,u){ if(u==='mF') return v*1e-3; if(u==='uF') return v*1e-6; if(u==='nF') return v*1e-9; if(u==='pF') return v*1e-12; return v; }
  function henry(v,u){ if(u==='mH') return v*1e-3; if(u==='uH') return v*1e-6; return v; }

  function logspace(f1,f2,n){ var a=Math.log10(f1), b=Math.log10(f2), step=(b-a)/(n-1); var arr=[]; for(var i=0;i<n;i++){ arr.push(Math.pow(10, a+i*step)); } return arr; }
  function db(x){ return 20*Math.log10(x); }

  function rcMag(md,w,Rsi,Csi){ const x=w*Rsi*Csi; if(md==='rc_lp') return 1/Math.sqrt(1+x*x); else return x/Math.sqrt(1+x*x); }
  function rlcMagBP(w,Rsi,Lsi,Csi){ const X = w*Lsi - 1/(w*Csi); const denom = Math.sqrt(Rsi*Rsi + X*X); return Rsi/denom; }

  function run(){
    showGroups();
    const md=mode.value;
    let Rv, Cv, Rsi, Csi, Lsi;
    if(md.indexOf('rc_')===0){
      Rv = parseFloat(R.value)||0; Cv=parseFloat(C.value)||0; Rsi = ohm(Rv,Ru.value); Csi = farad(Cv,Cu.value);
      const fcVal = (Rsi>0 && Csi>0)? (1/(2*Math.PI*Rsi*Csi)) : NaN; fc.textContent = isFinite(fcVal)? fcVal.toFixed(2):'–';
    } else {
      const Rrv=parseFloat(RR.value)||0, Lv=parseFloat(L.value)||0, Ccv=parseFloat(CC.value)||0;
      Rsi=Rrv; Lsi=henry(Lv,Lu.value); Csi=farad(Ccv,CCu.value);
      const f0Val = (Lsi>0 && Csi>0)? (1/(2*Math.PI*Math.sqrt(Lsi*Csi))):NaN; f0.textContent = isFinite(f0Val)? f0Val.toFixed(2):'–';
      const QVal = (Rsi>0 && Lsi>0 && Csi>0)? ((1/Rsi)*Math.sqrt(Lsi/Csi)) : NaN; Q.textContent = isFinite(QVal)? QVal.toFixed(3):'–';
      const BWVal = (isFinite(f0Val)&&isFinite(QVal)&&QVal>0)? (f0Val/QVal):NaN; BW.textContent = isFinite(BWVal)? BWVal.toFixed(2):'–';
    }

    // sweep
    let f1=parseFloat(fmin.value)||10, f2=parseFloat(fmax.value)||100000;
    if(sweep.value==='auto'){
      if(md.indexOf('rc_')===0){
        const fcVal = parseFloat(fc.textContent)||1000; f1=fcVal/100; f2=fcVal*100;
      } else {
        const f0Val = parseFloat(f0.textContent)||1000; f1=f0Val/100; f2=f0Val*100;
      }
    }
    f1=Math.max(0.1,f1); f2=Math.max(f1*1.1, f2);
    var freqs = logspace(f1,f2,200);
    var points = freqs.map(function(f){
      var w=2*Math.PI*f;
      var mag = (md.indexOf('rc_')===0) ? db(rcMag(md,w,Rsi,Csi)) : db(rlcMagBP(w,Rsi,Lsi,Csi));
      return { x: f, y: mag };
    });

    if(chart){ chart.destroy(); }
    var cfg = {
      type: 'line',
      data: {
        datasets: [{ label: '|H| (dB)', data: points, borderColor: '#0ea5e9', pointRadius: 0 }]
      },
      options: {
        responsive: true,
        parsing: true,
        scales: {
          x: { type: 'logarithmic', title: { display: true, text: 'Frequency (Hz)' } },
          y: { title: { display: true, text: 'Magnitude (dB)' } }
        },
        plugins: { legend: { display: false } }
      }
    };
    chart = new Chart(ctx, cfg);
  }

  // share/save
  $('btnRun').addEventListener('click', run);
  ['input','change'].forEach(function(ev){
    [mode,R,Ru,C,Cu,RR,L,Lu,CC,CCu,sweep,fmin,fmax].forEach(function(el){
      el.addEventListener(ev, run);
    });
  });
  $('btnSave').addEventListener('click', function(){
    try{
      var url=$('bodeCanvas').toDataURL('image/png');
      var a=document.createElement('a'); a.href=url; a.download='bode.png'; a.click();
    }catch(e){ alert('Unable to save image.'); }
  });
  $('btnShare').addEventListener('click', function(){
    var params=new URLSearchParams({ mode:mode.value, R:R.value, Ru:Ru.value, C:C.value, Cu:Cu.value, RR:RR.value, L:L.value, Lu:Lu.value, CC:CC.value, CCu:CCu.value, sweep:sweep.value, fmin:fmin.value, fmax:fmax.value });
    var link=location.origin + location.pathname + '?' + params.toString();
    if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(link).then(function(){ alert('Share URL copied'); }).catch(function(){ prompt('Copy this URL', link); });
    } else { prompt('Copy this URL', link); }
  });
  // presets
  var presetItems = document.querySelectorAll('#presetBtn ~ .dropdown-menu a[data-preset]');
  for(var i=0;i<presetItems.length;i++){
    (function(a){
      a.addEventListener('click', function(e){
        e.preventDefault(); var p=a.getAttribute('data-preset');
        if(p==='rc-lp'){ mode.value='rc_lp'; R.value='10000'; Ru.value='ohm'; C.value='10'; Cu.value='nF'; }
        if(p==='rc-hp'){ mode.value='rc_hp'; R.value='1000'; Ru.value='ohm'; C.value='100'; Cu.value='nF'; }
        if(p==='rlc-bp'){ mode.value='rlc_bp'; RR.value='100'; L.value='10'; Lu.value='mH'; CC.value='10'; CCu.value='nF'; }
        run();
      });
    })(presetItems[i]);
  }
  // apply query
  function initFromQuery(){
    var p=new URLSearchParams(location.search);
    ['mode','R','Ru','C','Cu','RR','L','Lu','CC','CCu','sweep','fmin','fmax'].forEach(function(k){ if(p.has(k)) $(k).value=p.get(k); });
    showGroups();
    run();
  }
  initFromQuery();
})();
</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<!-- E-E-A-T: About & Learning Outcomes (Physics) -->
<section class="container my-4"><div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
  <h2 class="h6 mb-2">About This Tool & Methodology</h2>
  <p>Analyzes RC/RLC circuits (time/frequency response) using SI units and standard circuit equations. Computes cutoff/ resonance and visualizes basic filter behavior.</p>
  <h3 class="h6 mt-2">Learning Outcomes</h3>
  <ul class="mb-2"><li>Understand time constants and resonance.</li><li>Relate component values to filter behavior.</li><li>Practice unit consistency and Bode intuition.</li></ul>
  <div class="row mt-2"><div class="col-md-6"><h4 class="h6">Authorship</h4><ul><li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">Anish Nath</a> — Follow on X</li><li><strong>Last updated:</strong> 2025-11-19</li></ul></div><div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul><li>Runs locally in your browser.</li></ul></div></div>
</div></div></div></div></section>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"WebPage","name":"RC/RLC Filter Calculator","url":"https://8gwifi.org/rc-rlc-filter.jsp","dateModified":"2025-11-19","author":{"@type":"Person","name":"Anish Nath","url":"https://x.com/anish2good"},"publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"RC/RLC Filter Calculator","item":"https://8gwifi.org/rc-rlc-filter.jsp"}]}
</script>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
