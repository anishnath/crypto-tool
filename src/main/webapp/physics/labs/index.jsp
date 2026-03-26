<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Physics Labs — 20 Interactive Simulations" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="20 free interactive physics simulations. Drag pendulums, collide billiard balls, watch chaos unfold, explore wave equations. All run in your browser with no signup required." />
    <jsp:param name="toolUrl" value="physics/labs/" />
    <jsp:param name="toolKeywords" value="physics simulations, interactive physics, pendulum simulator, spring oscillator, chaos theory, billiards physics, wave equation, Newton's cradle, molecular dynamics, brachistochrone" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="toolFeatures" value="20 interactive simulations,Drag-and-drop physics,Real-time graphs and energy plots,Phase space visualization,Direction field overlays,Export CSV data for lab reports,Screenshot sim and graph,Dark and light themes,No signup required,100% client-side" />
    <jsp:param name="faq1q" value="Are these physics simulations free?" />
    <jsp:param name="faq1a" value="Yes all 20 simulations are completely free. No registration no payment no limits. They run entirely in your browser using JavaScript. Your data never leaves your device." />
    <jsp:param name="faq2q" value="Can I use these for homework and lab reports?" />
    <jsp:param name="faq2a" value="Yes. Every simulation has Export CSV to download data for Excel or Google Sheets and Screenshot to capture the sim and graphs as PNG for lab reports. You can also share specific configurations via URL." />
</jsp:include>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">

<!-- ItemList Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "CollectionPage",
  "name": "Physics Labs",
  "description": "20 free interactive physics simulations",
  "url": "https://8gwifi.org/physics/labs/",
  "mainEntity": {
    "@type": "ItemList",
    "numberOfItems": 20,
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Simple Pendulum","url":"https://8gwifi.org/physics/labs/pendulum.jsp"},
      {"@type":"ListItem","position":2,"name":"Spring Oscillator","url":"https://8gwifi.org/physics/labs/spring.jsp"},
      {"@type":"ListItem","position":3,"name":"Double Spring","url":"https://8gwifi.org/physics/labs/double-spring.jsp"},
      {"@type":"ListItem","position":4,"name":"Kapitza Pendulum","url":"https://8gwifi.org/physics/labs/kapitza-pendulum.jsp"},
      {"@type":"ListItem","position":5,"name":"Cart + Pendulum","url":"https://8gwifi.org/physics/labs/cart-pendulum.jsp"},
      {"@type":"ListItem","position":6,"name":"Double Pendulum","url":"https://8gwifi.org/physics/labs/double-pendulum.jsp"},
      {"@type":"ListItem","position":7,"name":"Two Chaotic Pendulums","url":"https://8gwifi.org/physics/labs/compare-pendulum.jsp"},
      {"@type":"ListItem","position":8,"name":"Colliding Blocks","url":"https://8gwifi.org/physics/labs/collide-blocks.jsp"},
      {"@type":"ListItem","position":9,"name":"Billiards","url":"https://8gwifi.org/physics/labs/billiards.jsp"},
      {"@type":"ListItem","position":10,"name":"Newton's Cradle","url":"https://8gwifi.org/physics/labs/newtons-cradle.jsp"},
      {"@type":"ListItem","position":11,"name":"Molecule","url":"https://8gwifi.org/physics/labs/molecule.jsp"},
      {"@type":"ListItem","position":12,"name":"Brachistochrone","url":"https://8gwifi.org/physics/labs/brachistochrone.jsp"},
      {"@type":"ListItem","position":13,"name":"Vibrating String","url":"https://8gwifi.org/physics/labs/string-wave.jsp"},
      {"@type":"ListItem","position":14,"name":"Pile","url":"https://8gwifi.org/physics/labs/pile.jsp"},
      {"@type":"ListItem","position":15,"name":"Ramp: Forces & Motion","url":"https://8gwifi.org/physics/labs/ramp.jsp"},
      {"@type":"ListItem","position":16,"name":"Resonance","url":"https://8gwifi.org/physics/labs/resonance.jsp"},
      {"@type":"ListItem","position":17,"name":"Inclined Plane Pulley","url":"https://8gwifi.org/physics/labs/pulley.jsp"},
      {"@type":"ListItem","position":18,"name":"Center of Mass: Raft","url":"https://8gwifi.org/physics/labs/raft-cm.jsp"},
      {"@type":"ListItem","position":19,"name":"States of Matter","url":"https://8gwifi.org/physics/labs/states-of-matter.jsp"}
    ]
  }
}
</script>

<!-- GPT Ads -->
<script async src="https://securepubads.g.doubleclick.net/tag/js/gpt.js" onerror="console.warn('GPT failed')"></script>
<script>
stpd=window.stpd||{que:[]};window.googletag=window.googletag||{cmd:[]};
googletag.cmd.push(function(){
  var w=window.innerWidth;
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_970x90_hero_desktop',[[970,90],[728,90]],'ad_labs_hero').addService(googletag.pubads());
  else if(w>=768)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_hero_tablet',[[728,90]],'ad_labs_hero').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_hero_mobile',[[320,50],[320,100]],'ad_labs_hero').addService(googletag.pubads());
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop',[[970,90],[728,90]],'ad_labs_below').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_leaderboard_mobile',[[320,100],[320,50]],'ad_labs_below').addService(googletag.pubads());
  googletag.pubads().disableInitialLoad();googletag.pubads().enableSingleRequest();googletag.pubads().collapseEmptyDivs();googletag.enableServices();
});
</script>
<script>(function(){var s=document.createElement('script');s.src='https://stpd.cloud/saas/5796';s.async=true;s.onerror=function(){};document.head.appendChild(s)})()</script>

<style>
:root {
  --li-bg: #0B1120;
  --li-surface: #131B2A;
  --li-border: rgba(139,92,246,0.12);
  --li-text: #E2E8F0;
  --li-text2: #94A3B8;
  --li-text3: #64748B;
  --li-accent: #8B5CF6;
}
[data-theme="light"] {
  --li-bg: #F0F4F8;
  --li-surface: #FFFFFF;
  --li-border: rgba(139,92,246,0.1);
  --li-text: #1E293B;
  --li-text2: #475569;
  --li-text3: #94A3B8;
}
body { background: var(--li-bg); margin: 0; font-family: 'DM Sans', sans-serif; color: var(--li-text); }
.labs-wrap { max-width: 1200px; margin: 0 auto; padding: 84px 20px 40px; }
@media(max-width:768px) { .labs-wrap { padding-top: 76px; } }

/* Hero */
.labs-hero {
  text-align: center;
  padding: 24px 0 20px;
}
.labs-hero h1 {
  font-family: 'Sora', sans-serif;
  font-size: 1.8rem;
  font-weight: 700;
  margin: 0 0 6px;
  background: linear-gradient(135deg, #A78BFA, #06B6D4);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.labs-hero p { color: var(--li-text2); font-size: 0.95rem; margin: 0 0 12px; }
.labs-stats { display: flex; justify-content: center; gap: 20px; }
.labs-stat {
  background: var(--li-surface);
  border: 1px solid var(--li-border);
  border-radius: 8px;
  padding: 6px 16px;
  font-size: 0.78rem;
  font-weight: 600;
  color: var(--li-accent);
}

/* Category */
.labs-cat {
  margin-top: 18px;
}
.labs-cat-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  font-size: 0.72rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--li-text3);
}
.labs-cat-header .cat-line {
  flex: 1;
  height: 1px;
  background: var(--li-border);
}
.labs-cat-header .cat-count {
  font-family: 'Sora', sans-serif;
  color: var(--li-accent);
}

/* Card Grid */
.labs-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 10px;
}

/* Card */
.lab-card {
  display: flex;
  gap: 10px;
  align-items: flex-start;
  padding: 12px;
  background: var(--li-surface);
  border: 1px solid var(--li-border);
  border-radius: 10px;
  text-decoration: none;
  transition: all 0.2s;
  position: relative;
  overflow: hidden;
}
.lab-card:hover {
  border-color: var(--li-accent);
  box-shadow: 0 0 16px rgba(139,92,246,0.12);
  transform: translateY(-2px);
}
.lab-card-icon {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}
.lab-card-icon svg { width: 24px; height: 24px; }
.lab-card-body h3 {
  font-family: 'Sora', sans-serif;
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--li-text);
  margin: 0 0 2px;
  line-height: 1.2;
}
.lab-card-body p {
  font-size: 0.72rem;
  color: var(--li-text2);
  margin: 0;
  line-height: 1.4;
}
.card-badges { display: flex; gap: 4px; margin-top: 4px; }
.card-badge {
  font-size: 0.55rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  padding: 1px 5px;
  border-radius: 3px;
}
.badge-drag { background: rgba(139,92,246,0.15); color: #A78BFA; }
.badge-chaos { background: rgba(239,68,68,0.15); color: #F87171; }
.badge-collision { background: rgba(6,182,212,0.15); color: #22D3EE; }
.badge-wave { background: rgba(16,185,129,0.15); color: #34D399; }
.badge-race { background: rgba(245,158,11,0.15); color: #FBBF24; }
.badge-engine { background: rgba(236,72,153,0.15); color: #F472B6; }
.badge-new { background: #D946EF; color: #fff; }

/* Breadcrumb */
.labs-crumb { font-size: 0.75rem; color: var(--li-text3); margin-bottom: 6px; }
.labs-crumb a { color: var(--li-text3); text-decoration: none; }
.labs-crumb a:hover { color: var(--li-accent); }

/* Related */
.labs-related {
  display: flex; gap: 10px; flex-wrap: wrap; align-items: center;
  margin-top: 24px; font-size: 0.75rem; color: var(--li-text3);
}
.labs-related a {
  padding: 5px 12px; background: var(--li-surface); border: 1px solid var(--li-border);
  border-radius: 8px; text-decoration: none; font-size: 0.78rem; font-weight: 500;
  color: var(--li-text); transition: all 0.15s;
}
.labs-related a:hover { border-color: var(--li-accent); color: #A78BFA; }

/* Responsive */
@media(max-width:600px) {
  .labs-grid { grid-template-columns: 1fr; }
  .labs-hero h1 { font-size: 1.4rem; }
  .labs-stats { gap: 10px; }
}
</style>
</head>
<body>
<%@ include file="../../modern/components/nav-header.jsp" %>

<div class="labs-wrap">

<!-- Hero Ad -->
<div style="text-align:center;max-width:970px;margin:0 auto 8px;min-height:50px;" id="ad_labs_hero">
  <div style="font-size:.55rem;text-transform:uppercase;letter-spacing:.06em;color:var(--li-text3);opacity:.5;margin-bottom:4px;">Advertisement</div>
</div>

<nav class="labs-crumb">
  <a href="<%=request.getContextPath()%>/">Home</a> /
  <a href="<%=request.getContextPath()%>/physics/">Physics</a> /
  <span>Labs</span>
</nav>

<section class="labs-hero">
  <h1>Physics Labs</h1>
  <p>Interactive simulations — grab, drag, explore real physics</p>
  <div class="labs-stats">
    <span class="labs-stat">15 Labs</span>
    <span class="labs-stat">100% Free</span>
    <span class="labs-stat">No Signup</span>
    <span class="labs-stat">Export CSV</span>
  </div>
</section>

<%-- ═══ MECHANICS ═══ --%>
<div class="labs-cat">
  <div class="labs-cat-header">Mechanics <span class="cat-line"></span> <span class="cat-count">9</span></div>
  <div class="labs-grid">

    <a href="pendulum.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#8B5CF6,#6D28D9);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><circle cx="12" cy="4" r="2"/><line x1="12" y1="6" x2="18" y2="18"/><circle cx="18" cy="18" r="3" fill="#A78BFA" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Pendulum</h3>
        <p>Drag the bob, adjust gravity, damping, drive force</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span></div>
      </div>
    </a>

    <a href="spring.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#06B6D4,#0891B2);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><line x1="2" y1="12" x2="5" y2="12"/><polyline points="5,8 8,16 11,8 14,16 17,8 20,16"/><line x1="20" y1="12" x2="22" y2="12"/><rect x="20" y="9" width="4" height="6" rx="1" fill="#22D3EE" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Spring</h3>
        <p>Stretch, release, watch harmonic oscillation</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span></div>
      </div>
    </a>

    <a href="vertical-spring.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#06B6D4,#22C55E);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><line x1="6" y1="2" x2="18" y2="2" stroke-width="3"/><polyline points="12,2 10,5 14,7 10,9 14,11 12,13" fill="none"/><rect x="9" y="13" width="6" height="5" rx="1" fill="#8B5CF6" stroke="none"/><line x1="12" y1="20" x2="12" y2="22" stroke="#EF4444" stroke-dasharray="1 1"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Vertical Spring</h3>
        <p>Does gravity change the period? (Spoiler: no!)</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="series-parallel-springs.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#F59E0B,#22C55E);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><line x1="4" y1="2" x2="4" y2="6"/><polyline points="2,6 4,9 6,6 4,9 2,12"/><polyline points="2,12 4,15 6,12 4,15 2,18"/><rect x="2" y="18" width="4" height="3" rx="1" fill="#F59E0B" stroke="none"/><line x1="16" y1="2" x2="16" y2="4"/><line x1="14" y1="2" x2="14" y2="4"/><polyline points="14,4 14,8 14,12" stroke-width="1.5"/><polyline points="18,4 18,8 18,12" stroke-width="1.5"/><rect x="13" y="12" width="6" height="3" rx="1" fill="#22C55E" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Series vs Parallel</h3>
        <p>Compare spring combinations side by side</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="double-spring.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#10B981,#059669);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><rect x="1" y="10" width="3" height="4" fill="#475569" stroke="none"/><polyline points="4,12 7,10 10,14 13,10"/><rect x="13" y="9" width="4" height="6" rx="1" fill="#10B981" stroke="none"/><polyline points="17,12 19,10 21,14"/><rect x="21" y="9" width="3" height="6" rx="1" fill="#06B6D4" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Double Spring</h3>
        <p>Coupled oscillators, normal modes, energy transfer</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span></div>
      </div>
    </a>

    <a href="drop-mass.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#EF4444,#8B5CF6);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><line x1="12" y1="2" x2="12" y2="8"/><polyline points="9,6 12,8 15,6" fill="none"/><rect x="9" y="8" width="6" height="4" rx="1" fill="#EF4444" stroke="none"/><polyline points="12,12 9,16 15,16 12,12" fill="none"/><rect x="9" y="16" width="6" height="5" rx="1" fill="#8B5CF6" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Drop Mass</h3>
        <p>Drop a mass onto an oscillator — inelastic collision</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="bungee.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#22C55E,#EF4444);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><line x1="4" y1="3" x2="20" y2="3" stroke-width="3"/><line x1="12" y1="3" x2="12" y2="10" stroke-dasharray="2 1"/><circle cx="12" cy="12" r="2" fill="#22C55E"/><line x1="12" y1="14" x2="12" y2="18"/><line x1="10" y1="18" x2="14" y2="18"/><line x1="4" y1="22" x2="20" y2="22" stroke="#EF4444"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Bungee Jump</h3>
        <p>Drop a mass onto an oscillator — inelastic collision</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="pulley-scale.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#06B6D4,#8B5CF6);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><line x1="4" y1="4" x2="20" y2="4"/><circle cx="6" cy="4" r="2"/><circle cx="18" cy="4" r="2"/><line x1="6" y1="6" x2="6" y2="16"/><line x1="18" y1="6" x2="18" y2="16"/><rect x="3" y="16" width="6" height="4" rx="1" fill="#8B5CF6" stroke="none"/><rect x="15" y="16" width="6" height="4" rx="1" fill="#22C55E" stroke="none"/><rect x="9" y="2.5" width="6" height="3" rx="1" fill="#06B6D4" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Pulley-Spring Scale</h3>
        <p>Does the scale read 100N or 200N? Tension misconception</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="kapitza-pendulum.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#F59E0B,#D97706);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><line x1="12" y1="20" x2="12" y2="6" stroke-dasharray="2 2"/><circle cx="12" cy="20" r="2" fill="#F59E0B" stroke="none"/><line x1="12" y1="6" x2="12" y2="2"/><circle cx="12" cy="2" r="2" fill="#FBBF24" stroke="none"/><text x="16" y="5" font-size="6" fill="#fff">↕</text></svg>
      </div>
      <div class="lab-card-body">
        <h3>Kapitza Pendulum</h3>
        <p>Inverted pendulum stabilized by vibration</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="cart-pendulum.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#64748B,#475569);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><rect x="6" y="12" width="8" height="5" rx="1" fill="#64748B" stroke="none"/><circle cx="8" cy="18" r="1.5" fill="#475569"/><circle cx="12" cy="18" r="1.5" fill="#475569"/><line x1="10" y1="12" x2="14" y2="4"/><circle cx="14" cy="4" r="2" fill="#8B5CF6" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Cart + Pendulum</h3>
        <p>Coupled cart-pendulum on a spring track</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span></div>
      </div>
    </a>

    <a href="ramp.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#F97316,#EA580C);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><line x1="2" y1="20" x2="22" y2="20"/><line x1="2" y1="20" x2="20" y2="6"/><rect x="10" y="10" width="5" height="4" rx="0.5" fill="#8B5CF6" stroke="none" transform="rotate(-35 12.5 12)"/><line x1="12" y1="10" x2="12" y2="6" stroke="#3B82F6" stroke-width="1.5"/><line x1="12" y1="10" x2="16" y2="8" stroke="#22C55E" stroke-width="1.5"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Ramp: Forces &amp; Motion</h3>
        <p>Inclined plane — friction, force decomposition, FBD</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="resonance.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#EF4444,#F97316);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><line x1="4" y1="12" x2="4" y2="20"/><polyline points="4,12 7,8 10,16 13,4 16,16 19,8 20,12"/><circle cx="13" cy="4" r="2" fill="#FBBF24" stroke="none"/><line x1="13" y1="6" x2="13" y2="20" stroke-dasharray="2 1" stroke-width="1"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Resonance</h3>
        <p>Driven oscillator — frequency response, phase flip, Q factor</p>
        <div class="card-badges"><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="raft-cm.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#2288BB,#10B981);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><rect x="4" y="12" width="16" height="3" rx="1" fill="#A07030" stroke="none"/><circle cx="10" cy="10" r="2" fill="#EEB888" stroke="none"/><line x1="10" y1="12" x2="10" y2="14" stroke="#DD6633"/><path d="M2 15 Q6 13 12 15 Q18 17 22 15" stroke="#2288BB" fill="none"/><line x1="12" y1="8" x2="12" y2="16" stroke="#EF4444" stroke-dasharray="2 1"/><polygon points="11,8 13,8 12,6" fill="#EF4444"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Center of Mass: Raft</h3>
        <p>Person walks on a raft — CM stays fixed, raft drifts</p>
        <div class="card-badges"><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="pulley.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#22AA55,#0891B2);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><circle cx="16" cy="4" r="2.5" fill="none"/><line x1="2" y1="20" x2="16" y2="6"/><rect x="6" y="10" width="4" height="3.5" rx=".5" fill="#C07828" stroke="none" transform="rotate(-55 8 12)"/><line x1="16" y1="6.5" x2="16" y2="20"/><rect x="14" y="16" width="4" height="3.5" rx=".5" fill="#22AA55" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Inclined Plane Pulley</h3>
        <p>Two masses, rope, pulley — tension, friction, coupled motion</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

  </div>
</div>

<%-- ═══ CHAOS ═══ --%>
<div class="labs-cat">
  <div class="labs-cat-header">Chaos <span class="cat-line"></span> <span class="cat-count">2</span></div>
  <div class="labs-grid">

    <a href="double-pendulum.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#EF4444,#DC2626);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><circle cx="12" cy="3" r="2"/><line x1="12" y1="5" x2="16" y2="12"/><circle cx="16" cy="12" r="2" fill="#F87171" stroke="none"/><line x1="16" y1="14" x2="10" y2="21"/><circle cx="10" cy="21" r="2" fill="#06B6D4" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Double Pendulum</h3>
        <p>Chaotic motion from simple deterministic equations</p>
        <div class="card-badges"><span class="card-badge badge-chaos">Chaos</span><span class="card-badge badge-drag">Drag</span></div>
      </div>
    </a>

    <a href="compare-pendulum.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#EC4899,#DB2777);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><circle cx="12" cy="3" r="2"/><line x1="12" y1="5" x2="8" y2="18" stroke="#A78BFA"/><circle cx="8" cy="18" r="2" fill="#8B5CF6" stroke="none"/><line x1="12" y1="5" x2="16" y2="17" stroke="#22D3EE"/><circle cx="16" cy="17" r="2" fill="#06B6D4" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Butterfly Effect</h3>
        <p>Two pendulums, 0.001 rad apart — watch them diverge</p>
        <div class="card-badges"><span class="card-badge badge-chaos">Chaos</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

  </div>
</div>

<%-- ═══ COLLISIONS ═══ --%>
<div class="labs-cat">
  <div class="labs-cat-header">Collisions <span class="cat-line"></span> <span class="cat-count">3</span></div>
  <div class="labs-grid">

    <a href="collide-blocks.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#3B82F6,#2563EB);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><rect x="2" y="8" width="6" height="8" rx="1" fill="#8B5CF6" stroke="none"/><rect x="16" y="8" width="6" height="8" rx="1" fill="#06B6D4" stroke="none"/><line x1="10" y1="12" x2="14" y2="12" stroke-dasharray="2 1"/><polyline points="13,10 15,12 13,14" fill="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Colliding Blocks</h3>
        <p>Elastic & inelastic, momentum readout, spring</p>
        <div class="card-badges"><span class="card-badge badge-collision">Collision</span><span class="card-badge badge-drag">Drag</span></div>
      </div>
    </a>

    <a href="billiards.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#0a4a2e,#065f46);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><rect x="2" y="4" width="20" height="16" rx="2" fill="#0a4a2e" stroke="#8B4513" stroke-width="2"/><circle cx="8" cy="12" r="2" fill="#fff"/><circle cx="14" cy="10" r="2" fill="#F59E0B"/><circle cx="16" cy="14" r="2" fill="#3B82F6"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Billiards</h3>
        <p>Break shot, 2D elastic collisions, friction</p>
        <div class="card-badges"><span class="card-badge badge-collision">Collision</span><span class="card-badge badge-drag">Drag</span></div>
      </div>
    </a>

    <a href="newtons-cradle.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#94A3B8,#64748B);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><line x1="4" y1="3" x2="20" y2="3" stroke-width="2"/><line x1="8" y1="3" x2="8" y2="16"/><circle cx="8" cy="17" r="2" fill="#C0C0C0"/><line x1="12" y1="3" x2="12" y2="16"/><circle cx="12" cy="17" r="2" fill="#C0C0C0"/><line x1="16" y1="3" x2="19" y2="14"/><circle cx="19" cy="15" r="2" fill="#E8E8E8"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Newton's Cradle</h3>
        <p>Lift 1, 2, or 3 balls — momentum chain</p>
        <div class="card-badges"><span class="card-badge badge-collision">Collision</span><span class="card-badge badge-drag">Drag</span></div>
      </div>
    </a>

  </div>
</div>

<%-- ═══ ADVANCED ═══ --%>
<div class="labs-cat">
  <div class="labs-cat-header">Advanced <span class="cat-line"></span> <span class="cat-count">8</span></div>
  <div class="labs-grid">

    <a href="molecule.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#8B5CF6,#06B6D4);">
        <svg viewBox="0 0 24 24" fill="none"><circle cx="8" cy="8" r="3" fill="#EF4444"/><circle cx="16" cy="8" r="2.5" fill="#06B6D4"/><circle cx="12" cy="17" r="2.5" fill="#8B5CF6"/><line x1="8" y1="8" x2="16" y2="8" stroke="#10B981" stroke-width="1.5"/><line x1="8" y1="8" x2="12" y2="17" stroke="#10B981" stroke-width="1.5"/><line x1="16" y1="8" x2="12" y2="17" stroke="#10B981" stroke-width="1.5"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Molecule</h3>
        <p>2-6 atoms, spring types, orbits, wall bouncing</p>
        <div class="card-badges"><span class="card-badge badge-drag">Drag</span></div>
      </div>
    </a>

<%--    <a href="oscillating-charge.jsp" class="lab-card">--%>
<%--      <div class="lab-card-icon" style="background:linear-gradient(135deg,#0EA5E9,#8B5CF6);">--%>
<%--        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.7"><circle cx="12" cy="12" r="2.2" fill="#EF4444" stroke="none"/><path d="M2 12 C5 8, 8 8, 12 12 C16 16, 19 16, 22 12"/><path d="M2 9 C5 5, 8 5, 12 9 C16 13, 19 13, 22 9" opacity=".7"/><path d="M2 15 C5 11, 8 11, 12 15 C16 19, 19 19, 22 15" opacity=".7"/></svg>--%>
<%--      </div>--%>
<%--      <div class="lab-card-body">--%>
<%--        <h3>Oscillating Charge</h3>--%>
<%--        <p>Liénard-Wiechert E-field heatmap + quiver animation</p>--%>
<%--        <div class="card-badges"><span class="card-badge badge-wave">EM</span><span class="card-badge badge-new">New</span></div>--%>
<%--      </div>--%>
<%--    </a>--%>

<%--    <a href="current-coil-magnetic-field.jsp" class="lab-card">--%>
<%--      <div class="lab-card-icon" style="background:linear-gradient(135deg,#14B8A6,#0EA5E9);">--%>
<%--        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.8"><circle cx="12" cy="12" r="7"/><path d="M12 3 v18" opacity=".7"/><path d="M3 12 h18" opacity=".7"/><circle cx="19" cy="12" r="1.8" fill="#fff" stroke="none"/></svg>--%>
<%--      </div>--%>
<%--      <div class="lab-card-body">--%>
<%--        <h3>Current Coil B-Field</h3>--%>
<%--        <p>Bz heatmap + on-axis Biot-Savart comparison</p>--%>
<%--        <div class="card-badges"><span class="card-badge badge-wave">EM</span><span class="card-badge badge-new">New</span></div>--%>
<%--      </div>--%>
<%--    </a>--%>

    <a href="states-of-matter.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#3B82F6,#EF4444);">
        <svg viewBox="0 0 24 24" fill="none"><circle cx="5" cy="5" r="2" fill="#3B82F6"/><circle cx="10" cy="5" r="2" fill="#3B82F6"/><circle cx="7" cy="9" r="2" fill="#22C55E"/><circle cx="12" cy="9" r="2" fill="#22C55E"/><circle cx="17" cy="4" r="2" fill="#EF4444"/><circle cx="20" cy="10" r="2" fill="#EF4444"/><circle cx="4" cy="14" r="2" fill="#F59E0B"/><rect x="1" y="18" width="22" height="3" rx="1" fill="#F97316" opacity=".5"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>States of Matter</h3>
        <p>Lennard-Jones MD — solid, liquid, gas, phase transitions, heat</p>
        <div class="card-badges"><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="circuit-simulator.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#06b6d4,#8b5cf6);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><line x1="2" y1="12" x2="6" y2="12"/><polyline points="6,12 8,8 10,16 12,8 14,16 16,12"/><line x1="16" y1="12" x2="22" y2="12"/><circle cx="4" cy="12" r="1.5" fill="#06b6d4" stroke="none"/><circle cx="20" cy="12" r="1.5" fill="#06b6d4" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Circuit Simulator</h3>
        <p>Draw circuits, see current flow and voltage colors live</p>
        <div class="card-badges"><span class="card-badge badge-new">New</span><span class="card-badge badge-drag">Draw</span></div>
      </div>
    </a>

    <a href="../optical-designer.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#3B82F6,#06B6D4);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.8"><circle cx="6" cy="12" r="2.5"/><line x1="8.5" y1="12" x2="19" y2="12"/><path d="M19 7 L22 12 L19 17"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Optical Designer</h3>
        <p>Design optical setups with lenses, mirrors, and ray tracing</p>
        <div class="card-badges"><span class="card-badge badge-wave">Optics</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="../ray-optics-simulator.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#6366F1,#8B5CF6);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.8"><line x1="3" y1="6" x2="11" y2="12"/><line x1="11" y1="12" x2="21" y2="12"/><line x1="11" y1="12" x2="20" y2="6"/><line x1="11" y1="12" x2="20" y2="18"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Ray Optics Simulator</h3>
        <p>Explore reflection, refraction, and lens behavior with live rays</p>
        <div class="card-badges"><span class="card-badge badge-wave">Optics</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

    <a href="brachistochrone.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#F59E0B,#EF4444);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.5"><circle cx="4" cy="4" r="2" fill="#fff"/><circle cx="20" cy="20" r="2" fill="#fff"/><path d="M4 4 Q4 20 20 20" stroke="#8B5CF6" stroke-width="2" fill="none"/><path d="M4 4 L20 20" stroke="#EF4444" stroke-width="1.5" fill="none"/><circle cx="10" cy="14" r="2" fill="#8B5CF6" stroke="none"/><circle cx="13" cy="13" r="2" fill="#EF4444" stroke="none"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Brachistochrone</h3>
        <p>4 balls race — cycloid always wins</p>
        <div class="card-badges"><span class="card-badge badge-race">Race</span></div>
      </div>
    </a>

  </div>
</div>

<%-- ═══ WAVES ═══ --%>
<div class="labs-cat">
  <div class="labs-cat-header">Waves <span class="cat-line"></span> <span class="cat-count">1</span></div>
  <div class="labs-grid">

    <a href="string-wave.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#10B981,#06B6D4);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2"><circle cx="2" cy="12" r="1.5" fill="#475569"/><path d="M3 12 Q8 4 12 12 Q16 20 21 12" stroke="#10B981" stroke-width="2" fill="none"/><circle cx="22" cy="12" r="1.5" fill="#475569"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Vibrating String</h3>
        <p>Wave equation PDE — pluck, sine modes, pulse</p>
        <div class="card-badges"><span class="card-badge badge-wave">Waves</span><span class="card-badge badge-new">New</span></div>
      </div>
    </a>

  </div>
</div>

<%-- ═══ RIGID BODY ═══ --%>
<div class="labs-cat">
  <div class="labs-cat-header">Rigid Body <span class="cat-line"></span> <span class="cat-count">1</span></div>
  <div class="labs-grid">

    <a href="pile.jsp" class="lab-card">
      <div class="lab-card-icon" style="background:linear-gradient(135deg,#EC4899,#DB2777);">
        <svg viewBox="0 0 24 24" fill="none"><rect x="3" y="16" width="18" height="2" fill="#475569"/><rect x="5" y="12" width="5" height="4" rx="0.5" fill="#8B5CF6" transform="rotate(-5 7 14)"/><rect x="11" y="11" width="6" height="5" rx="0.5" fill="#06B6D4" transform="rotate(8 14 13)"/><polygon points="8,8 11,8 9.5,5" fill="#F59E0B"/><rect x="13" y="6" width="4" height="5" rx="0.5" fill="#EF4444" transform="rotate(-12 15 8)"/></svg>
      </div>
      <div class="lab-card-body">
        <h3>Pile</h3>
        <p>Drop polygons — SAT collision, stacking, attract</p>
        <div class="card-badges"><span class="card-badge badge-engine">Engine2D</span><span class="card-badge badge-drag">Drag</span></div>
      </div>
    </a>

  </div>
</div>

<!-- Below-content Ad -->
<div style="margin:20px auto 0;padding:12px 0;text-align:center;max-width:970px;min-height:50px;opacity:0;transition:opacity .4s;" id="ad_labs_below">
  <div style="font-size:.55rem;text-transform:uppercase;letter-spacing:.06em;color:var(--li-text3);opacity:.5;margin-bottom:4px;">Advertisement</div>
</div>

<div class="labs-related">
  <span>Also try &rarr;</span>
  <a href="<%=request.getContextPath()%>/physics/">All Physics Tools</a>
  <a href="<%=request.getContextPath()%>/chemistry/">Chemistry Tools</a>
  <a href="<%=request.getContextPath()%>/chemistry/molecule-draw.jsp">Molecule Draw</a>
</div>

</div>

<script>
(function(){
  if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_labs_hero')});
  var below=document.getElementById('ad_labs_below');
  if(below&&'IntersectionObserver'in window){
    var obs=new IntersectionObserver(function(e){e.forEach(function(en){if(en.isIntersecting){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_labs_below');below.style.opacity='1'});obs.unobserve(below)}})},{rootMargin:'200px'});
    obs.observe(below);
  }
})();
</script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
