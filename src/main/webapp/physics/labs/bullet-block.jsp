<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Bullet–Block–Spring — Where Does 99% of the Energy Go?" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="Fire a bullet into a block on a spring. Watch momentum conservation and energy loss in a perfectly inelastic collision. Add friction to see the oscillation decay. Free, no signup." />
    <jsp:param name="toolUrl" value="physics/labs/bullet-block.jsp" />
    <jsp:param name="toolKeywords" value="bullet block spring, inelastic collision, momentum conservation, energy loss, ballistic pendulum, friction oscillation, AP physics collision" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate, AP Physics" />
    <jsp:param name="teaches" value="inelastic collision, momentum conservation, kinetic energy loss, spring compression, friction, ballistic pendulum concept" />
    <jsp:param name="faq1q" value="Why is so much kinetic energy lost when a bullet hits a block?" />
    <jsp:param name="faq1a" value="In a perfectly inelastic collision the fraction of kinetic energy retained is m divided by m plus M where m is the bullet mass and M is the block mass. For a 10g bullet and 2kg block only 0.5 percent of the energy survives. The rest becomes heat sound and deformation. Momentum is always conserved but kinetic energy is not in inelastic collisions." />
    <jsp:param name="faq2q" value="How do you find the maximum spring compression after a bullet embeds in a block?" />
    <jsp:param name="faq2a" value="Use momentum conservation to find the post-collision velocity v1 equals m times v0 divided by m plus M. Then use energy conservation for the spring compression: one half times m plus M times v1 squared equals one half times k times x max squared plus mu times m plus M times g times x max. Without friction x max equals v1 times the square root of m plus M divided by k." />
</jsp:include>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
<link rel="stylesheet" href="css/labs.css?v=<%=v%>">
<!-- GPT Ads -->
<script async src="https://securepubads.g.doubleclick.net/tag/js/gpt.js" onerror="console.warn('GPT failed')"></script>
<script>
stpd=window.stpd||{que:[]};window.googletag=window.googletag||{cmd:[]};
googletag.cmd.push(function(){
  var w=window.innerWidth;
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_970x90_hero_desktop',[[970,90],[728,90]],'ad_lab_hero').addService(googletag.pubads());
  else if(w>=768)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_hero_tablet',[[728,90]],'ad_lab_hero').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_hero_mobile',[[320,50],[320,100]],'ad_lab_hero').addService(googletag.pubads());
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop',[[970,90],[728,90]],'ad_lab_below').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_leaderboard_mobile',[[320,100],[320,50]],'ad_lab_below').addService(googletag.pubads());
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_anchor_desktop',[[970,90],[728,90]],'ad_lab_sticky').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_anchor_mobile',[[320,100],[320,50]],'ad_lab_sticky').addService(googletag.pubads());
  googletag.pubads().disableInitialLoad();googletag.pubads().enableSingleRequest();googletag.pubads().collapseEmptyDivs();googletag.enableServices();
});
</script>
<script>(function(){var s=document.createElement('script');s.src='https://stpd.cloud/saas/5796';s.async=true;s.onerror=function(){};document.head.appendChild(s)})()</script>
<style>
.ad-lab-hero{text-align:center;max-width:970px;margin:0 auto 8px;min-height:50px}
.ad-lab-hero .ad-label,.ad-lab-below .ad-label,.ad-lab-sticky .ad-label{font-size:.55rem;text-transform:uppercase;letter-spacing:.06em;color:var(--lab-text-muted);opacity:.5;margin-bottom:4px}
.ad-lab-below{margin:20px auto 0;padding:12px 0;text-align:center;max-width:970px;min-height:50px;opacity:0;transition:opacity .4s}
.ad-lab-below.ad-loaded{opacity:1}
.ad-lab-sticky{position:fixed;bottom:0;left:0;right:0;z-index:6000;text-align:center;padding:6px 0 8px;background:var(--lab-bg-panel);border-top:1px solid var(--lab-border);box-shadow:0 -2px 12px rgba(0,0,0,.15);transform:translateY(100%);transition:transform .4s;display:none}
.ad-lab-sticky.ad-visible{display:block;transform:translateY(0)}
.ad-lab-sticky.ad-dismissed{transform:translateY(100%);pointer-events:none}
.ad-lab-sticky .ad-close{position:absolute;top:4px;right:12px;width:22px;height:22px;border:1px solid var(--lab-border);border-radius:50%;background:var(--lab-bg-input);color:var(--lab-text-muted);font-size:14px;line-height:20px;text-align:center;cursor:pointer}
</style>
</head>
<body style="background:var(--lab-bg-deep);margin:0;min-height:100vh;">
<%@ include file="../../modern/components/nav-header.jsp" %>
<div class="lab-wrap">
<div class="ad-lab-hero" id="ad_lab_hero"><div class="ad-label">Advertisement</div></div>
  <nav class="lab-crumb">
    <a href="<%=request.getContextPath()%>/">Home</a> /
    <a href="<%=request.getContextPath()%>/physics/">Physics</a> /
    <a href="<%=request.getContextPath()%>/physics/labs/">Labs</a> /
    <span>Bullet–Block–Spring</span>
  </nav>
  <h1 class="lab-title">Bullet–Block–Spring</h1>
  <div id="labTabs"></div>
  <div class="lab-grid">
    <div class="lab-canvas-area" id="canvasArea">
      <div class="lab-canvas-wrap" id="simPanel"><canvas id="simCanvas"></canvas></div>
      <div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
        <canvas id="graphCanvas" width="600" height="450"></canvas>
        <canvas id="timeCanvas" width="600" height="450" style="display:none;"></canvas>
        <canvas id="energyCanvas" width="600" height="300" style="display:none;"></canvas>
        <canvas id="peWellCanvas" width="600" height="400" style="display:none;"></canvas>
      </div>
    </div>
    <div class="lab-sidebar">
      <div id="transport"></div>
      <div id="controls"></div>
      <div id="presets"></div>
      <div id="varPicker"></div>
      <div id="dataTools"></div>
    </div>
  </div>
  <section class="lab-info" id="labInfo"></section>
  <div class="ad-lab-below" id="ad_lab_below"><div class="ad-label">Advertisement</div></div>
  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/spring.jsp">Horizontal Spring</a>
    <a href="<%=request.getContextPath()%>/physics/labs/collide-blocks.jsp">Colliding Blocks</a>
    <a href="<%=request.getContextPath()%>/physics/labs/drop-mass.jsp">Drop Mass</a>
    <a href="<%=request.getContextPath()%>/physics/labs/">All Physics Labs</a>
  </div>
</div>
<div class="ad-lab-sticky" id="adLabSticky">
  <button class="ad-close" onclick="document.getElementById('adLabSticky').classList.add('ad-dismissed');try{localStorage.setItem('ad_lab_sticky_d','1')}catch(e){}">&times;</button>
  <div class="ad-label">Advertisement</div>
  <div id="ad_lab_sticky"></div>
</div>
<script type="module">
import { createLab } from './js/lab.js';
import { BulletBlockSim } from './js/sims/bullet-block.js';
const lab = createLab(BulletBlockSim, {
  simCanvas: document.getElementById('simCanvas'),
  graphCanvas: document.getElementById('graphCanvas'),
  timeCanvas: document.getElementById('timeCanvas'),
  energyCanvas: document.getElementById('energyCanvas'),
  peWellCanvas: document.getElementById('peWellCanvas'),
  canvasArea: document.getElementById('canvasArea'),
  controls: document.getElementById('controls'),
  transport: document.getElementById('transport'),
  presets: document.getElementById('presets'),
  tabs: document.getElementById('labTabs'),
  varPicker: document.getElementById('varPicker'),
  dataTools: document.getElementById('dataTools'),
});
document.getElementById('labInfo').innerHTML = BulletBlockSim.info || '';
</script>
<script>
(function(){
  if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_hero')});
  var below=document.getElementById('ad_lab_below');
  if(below&&'IntersectionObserver'in window){
    var obs=new IntersectionObserver(function(e){e.forEach(function(en){if(en.isIntersecting){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_below');below.classList.add('ad-loaded')});obs.unobserve(below)}})},{rootMargin:'200px'});
    obs.observe(below);
  }
  var sticky=document.getElementById('adLabSticky');
  if(sticky&&!(localStorage.getItem('ad_lab_sticky_d')==='1')){
    window.addEventListener('load',function(){setTimeout(function(){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_sticky');sticky.classList.add('ad-visible')});setTimeout(function(){if(sticky&&!sticky.classList.contains('ad-dismissed'))sticky.classList.add('ad-dismissed')},30000)},window.innerWidth<768?4000:2000)});
  }
})();
</script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
