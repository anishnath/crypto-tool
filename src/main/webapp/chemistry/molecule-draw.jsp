<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Molecule Draw - Free Online Molecular Structure Editor" />
    <jsp:param name="toolCategory" value="Chemistry" />
    <jsp:param name="toolDescription" value="Draw molecular structures online with our free interactive editor. Supports SMILES input, MOL file export, SVG/PNG download, reaction drawing, and real-time molecular property calculation. No signup needed." />
    <jsp:param name="toolUrl" value="chemistry/molecule-draw.jsp" />
    <jsp:param name="toolKeywords" value="molecule drawer, molecular structure editor, draw molecules online, SMILES to structure, MOL file editor, chemical structure drawing, reaction editor, molecular weight calculator, SVG molecule export, free chemistry tool" />
    <jsp:param name="toolImage" value="molecule-draw.svg" />
    <jsp:param name="breadcrumbCategoryUrl" value="chemistry/" />
    <jsp:param name="toolFeatures" value="Interactive molecular structure drawing,SMILES notation input and conversion,MOL V2/V3 file import and export,SVG and PNG molecule image export,Real-time molecular formula and weight,Reaction drawing mode with RXN export,12 pre-built common molecule templates,24 configurable render options,Atom and bond number display,Symmetry and stereochemistry visualization,Dark and light theme support,Keyboard shortcuts for power users,No registration required,100% client-side processing" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate, Graduate" />
    <jsp:param name="teaches" value="Molecular structure drawing, chemical notation (SMILES), stereochemistry, organic chemistry, reaction mechanisms" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Draw or load a molecule|Use the interactive canvas editor to draw bonds and atoms or paste a SMILES string like c1ccccc1 for benzene,View molecular properties|See real-time formula and molecular weight and toggle render options like atom numbers or symmetry,Export your structure|Download as SVG or PNG image or copy SMILES notation or export as MOL file for use in other chemistry software,Switch to reaction mode|Click Reaction in the editor header to draw chemical reactions with reactants and products and export as RXN" />
    <jsp:param name="faq1q" value="What molecule formats does this editor support?" />
    <jsp:param name="faq1a" value="The editor supports SMILES notation input, MOL V2 and V3 file import/export, RXN reaction files, SVG vector graphics export, and PNG image download. You can also copy IDCode format used by OpenChemLib." />
    <jsp:param name="faq2q" value="Can I draw chemical reactions, not just molecules?" />
    <jsp:param name="faq2a" value="Yes. Click the Reaction button in the editor header to switch to reaction mode. You can draw reactants, products, and catalysts, add atom mapping, and export as reaction SMILES or RXN files." />
    <jsp:param name="faq3q" value="Is this molecule editor free and does it work offline?" />
    <jsp:param name="faq3a" value="Yes, it is completely free with no registration or login required. The editor runs 100% in your browser using the OpenChemLib library loaded from CDN. After the initial load, all drawing and calculations happen client-side with no data sent to any server." />
</jsp:include>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=DM+Sans:ital,wght@0,400;0,500;0,600;1,400&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">

<!-- GPT Ad Init -->
<script async src="https://securepubads.g.doubleclick.net/tag/js/gpt.js" onerror="console.warn('GPT failed to load')"></script>
<script>
stpd = window.stpd || {que: []};
window.googletag = window.googletag || {cmd: []};
googletag.cmd.push(function() {
  var w = window.innerWidth;
  // Slot 0: Hero banner (above fold)
  if (w >= 992) {
    googletag.defineSlot('/147246189,22976055811/8gwifi.org_970x90_hero_desktop',
      [[970,90],[728,90]], 'ad_moldraw_hero').addService(googletag.pubads());
  } else if (w >= 768) {
    googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_hero_tablet',
      [[728,90],[468,60]], 'ad_moldraw_hero').addService(googletag.pubads());
  } else {
    googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_hero_mobile',
      [[320,50],[320,100],[300,50]], 'ad_moldraw_hero').addService(googletag.pubads());
  }
  // Slot 1: Below-editor leaderboard
  if (w >= 992) {
    googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop',
      [[970,90],[728,90],[970,250]], 'ad_moldraw_below_editor').addService(googletag.pubads());
  } else if (w >= 768) {
    googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_tablet',
      [[728,90]], 'ad_moldraw_below_editor').addService(googletag.pubads());
  } else {
    googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_leaderboard_mobile',
      [[320,100],[320,50],[300,100]], 'ad_moldraw_below_editor').addService(googletag.pubads());
  }
  // Slot 2: Sticky footer
  if (w >= 992) {
    googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_anchor_desktop',
      [[970,90],[728,90]], 'ad_moldraw_sticky_footer').addService(googletag.pubads());
  } else {
    googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_anchor_mobile',
      [[320,100],[320,50]], 'ad_moldraw_sticky_footer').addService(googletag.pubads());
  }
  googletag.pubads().disableInitialLoad();
  googletag.pubads().enableSingleRequest();
  googletag.pubads().collapseEmptyDivs();
  googletag.enableServices();
});
</script>
<script>
(function(){var s=document.createElement('script');s.src='https://stpd.cloud/saas/5796';s.async=true;
s.onerror=function(){console.debug('Ad script blocked')};document.head.appendChild(s)})();
</script>

<style>
/* ═══════════════════════════════════════════════════════
   DESIGN TOKENS
   ═══════════════════════════════════════════════════════ */
:root {
  --bg-deep:       #060B14;
  --bg-base:       #0B1120;
  --bg-surface:    #111927;
  --bg-elevated:   #172033;
  --bg-card:       rgba(17, 25, 39, 0.75);
  --border-subtle: rgba(16, 185, 129, 0.12);
  --border-mid:    rgba(16, 185, 129, 0.25);
  --border-bright: rgba(16, 185, 129, 0.5);
  --accent:        #10b981;
  --accent-bright: #34d399;
  --accent-dim:    #059669;
  --accent2:       #06b6d4;
  --accent2-bright:#22d3ee;
  --warn:          #f59e0b;
  --error:         #ef4444;
  --text-primary:  #e2e8f0;
  --text-secondary:#94a3b8;
  --text-muted:    #64748b;
  --text-code:     #a5f3fc;
  --glow-sm:       0 0 8px rgba(16,185,129,0.25);
  --glow-md:       0 0 20px rgba(16,185,129,0.2), 0 0 40px rgba(16,185,129,0.1);
  --glow-lg:       0 0 30px rgba(16,185,129,0.3), 0 0 60px rgba(16,185,129,0.15), 0 0 100px rgba(16,185,129,0.05);
  --glass:         rgba(17, 25, 39, 0.6);
  --glass-border:  rgba(255,255,255,0.06);
  --radius-sm:     6px;
  --radius-md:     10px;
  --radius-lg:     16px;
  --radius-xl:     24px;
  --font-display:  'Sora', sans-serif;
  --font-body:     'DM Sans', sans-serif;
  --font-code:     'Fira Code', monospace;
  --editor-h:      520px;
}

[data-theme="light"] {
  --bg-deep:       #f0f4f8;
  --bg-base:       #f8fafc;
  --bg-surface:    #ffffff;
  --bg-elevated:   #ffffff;
  --bg-card:       rgba(255,255,255,0.85);
  --border-subtle: rgba(16,185,129,0.15);
  --border-mid:    rgba(16,185,129,0.3);
  --border-bright: rgba(16,185,129,0.6);
  --glass:         rgba(255,255,255,0.7);
  --glass-border:  rgba(0,0,0,0.06);
  --text-primary:  #1e293b;
  --text-secondary:#475569;
  --text-muted:    #94a3b8;
  --text-code:     #0e7490;
  --glow-sm:       0 1px 3px rgba(0,0,0,0.08);
  --glow-md:       0 4px 16px rgba(0,0,0,0.06);
  --glow-lg:       0 8px 32px rgba(0,0,0,0.08);
}

/* ═══════════════════════════════════════════════════════
   RESET & BASE
   ═══════════════════════════════════════════════════════ */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
html { font-size: 15px; scroll-behavior: smooth; }
body {
  font-family: var(--font-body);
  background: var(--bg-deep);
  color: var(--text-primary);
  line-height: 1.6;
  min-height: 100vh;
  overflow-x: hidden;
}

/* hex grid background */
body::before {
  content: '';
  position: fixed;
  inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='28' height='49' viewBox='0 0 28 49'%3E%3Cg fill-rule='evenodd'%3E%3Cg fill='%2310b981' fill-opacity='0.03'%3E%3Cpath d='M13.99 9.25l13 7.5v15l-13 7.5L1 31.75v-15l12.99-7.5zM3 17.9v12.7l10.99 6.34 11-6.35V17.9l-11-6.34L3 17.9zM0 15l12.98-7.5V0h-2v6.35L0 12.69v2.3zm0 18.5L12.98 41v8h-2v-6.85L0 35.81v-2.3zM15 0v7.5L27.99 15H28v-2.31h-.01L17 6.35V0h-2zm0 49v-8l12.99-7.5H28v2.31h-.01L17 42.15V49h-2z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
  pointer-events: none;
  z-index: 0;
}

/* radial glow behind editor */
body::after {
  content: '';
  position: fixed;
  top: 30%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 900px;
  height: 600px;
  background: radial-gradient(ellipse, rgba(16,185,129,0.06) 0%, transparent 70%);
  pointer-events: none;
  z-index: 0;
}

/* ═══════════════════════════════════════════════════════
   LAYOUT
   ═══════════════════════════════════════════════════════ */
.page-wrap {
  position: relative;
  z-index: 1;
  max-width: 1540px;
  margin: 0 auto;
  padding: 0 20px 40px;
}

/* ═══════════════════════════════════════════════════════
   BREADCRUMB
   ═══════════════════════════════════════════════════════ */
.breadcrumb {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 0.75rem;
  margin-bottom: 14px;
}
.breadcrumb a {
  color: var(--text-muted);
  text-decoration: none;
  transition: color 0.15s;
}
.breadcrumb a:hover { color: var(--accent-bright); }
.breadcrumb .sep { color: var(--text-muted); opacity: 0.4; }
.breadcrumb .current { color: var(--text-secondary); }

/* ═══════════════════════════════════════════════════════
   HEADER
   ═══════════════════════════════════════════════════════ */
.site-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 0;
  border-bottom: 1px solid var(--border-subtle);
  margin-bottom: 24px;
}
.site-header .logo-area {
  display: flex;
  align-items: center;
  gap: 14px;
}
.logo-hex {
  width: 38px; height: 44px;
  position: relative;
}
.logo-hex svg { width: 100%; height: 100%; }
.site-header h1 {
  font-family: var(--font-display);
  font-weight: 600;
  font-size: 1.35rem;
  background: linear-gradient(135deg, var(--accent-bright), var(--accent2));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: -0.02em;
}
.site-header .subtitle {
  font-size: 0.78rem;
  color: var(--text-muted);
  font-weight: 400;
  letter-spacing: 0.03em;
}
.header-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

/* theme toggle */
.theme-toggle {
  width: 36px; height: 36px;
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-sm);
  background: var(--glass);
  color: var(--text-secondary);
  cursor: pointer;
  display: grid;
  place-items: center;
  transition: all 0.2s;
}
.theme-toggle:hover {
  border-color: var(--border-mid);
  color: var(--accent-bright);
  box-shadow: var(--glow-sm);
}
.theme-toggle svg { width: 18px; height: 18px; }

/* shortcuts btn */
.shortcuts-btn {
  height: 36px;
  padding: 0 12px;
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-sm);
  background: var(--glass);
  color: var(--text-secondary);
  font-family: var(--font-body);
  font-size: 0.78rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 6px;
  transition: all 0.2s;
}
.shortcuts-btn:hover {
  border-color: var(--border-mid);
  color: var(--accent-bright);
}
.shortcuts-btn kbd {
  font-family: var(--font-code);
  font-size: 0.7rem;
  background: var(--bg-elevated);
  padding: 1px 5px;
  border-radius: 3px;
  border: 1px solid var(--glass-border);
}

/* ═══════════════════════════════════════════════════════
   MAIN GRID
   ═══════════════════════════════════════════════════════ */
.main-grid {
  display: grid;
  grid-template-columns: 280px 1fr 300px;
  gap: 16px;
  align-items: start;
}

/* ═══════════════════════════════════════════════════════
   PANEL (glass cards)
   ═══════════════════════════════════════════════════════ */
.panel {
  background: var(--bg-card);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-lg);
  overflow: hidden;
  animation: panelIn 0.5s ease both;
}
.panel:nth-child(2) { animation-delay: 0.08s; }
.panel:nth-child(3) { animation-delay: 0.16s; }

@keyframes panelIn {
  from { opacity: 0; transform: translateY(12px); }
  to   { opacity: 1; transform: translateY(0); }
}

.panel-header {
  padding: 14px 18px;
  border-bottom: 1px solid var(--glass-border);
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.panel-header h2 {
  font-family: var(--font-display);
  font-size: 0.82rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--text-secondary);
}
.panel-header .badge {
  font-size: 0.65rem;
  font-family: var(--font-code);
  color: var(--accent);
  background: rgba(16,185,129,0.1);
  padding: 2px 8px;
  border-radius: 99px;
  border: 1px solid var(--border-subtle);
}
.panel-body {
  padding: 16px 18px;
}

/* ═══════════════════════════════════════════════════════
   LEFT: INPUT PANEL
   ═══════════════════════════════════════════════════════ */
.input-section + .input-section { margin-top: 16px; }
.input-section label {
  display: block;
  font-size: 0.75rem;
  font-weight: 500;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.06em;
  margin-bottom: 6px;
}
.input-field {
  width: 100%;
  background: var(--bg-elevated);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-sm);
  color: var(--text-primary);
  font-family: var(--font-code);
  font-size: 0.82rem;
  padding: 10px 12px;
  resize: vertical;
  transition: border-color 0.2s, box-shadow 0.2s;
  outline: none;
}
.input-field:focus {
  border-color: var(--accent);
  box-shadow: 0 0 0 3px rgba(16,185,129,0.12);
}
.input-field::placeholder {
  color: var(--text-muted);
  font-family: var(--font-body);
  font-style: italic;
}

.btn-row {
  display: flex;
  gap: 6px;
  margin-top: 8px;
}
.btn {
  flex: 1;
  height: 34px;
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-sm);
  background: var(--bg-elevated);
  color: var(--text-primary);
  font-family: var(--font-body);
  font-size: 0.78rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
}
.btn:hover {
  border-color: var(--accent);
  background: rgba(16,185,129,0.08);
  color: var(--accent-bright);
  box-shadow: var(--glow-sm);
}
.btn.btn-accent {
  background: linear-gradient(135deg, var(--accent-dim), var(--accent));
  border-color: var(--accent);
  color: #fff;
}
.btn.btn-accent:hover {
  background: linear-gradient(135deg, var(--accent), var(--accent-bright));
  box-shadow: var(--glow-md);
}

/* gallery */
.gallery-label {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8px;
}
.gallery-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 6px;
}
.gallery-card {
  background: var(--bg-elevated);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-sm);
  padding: 6px;
  cursor: pointer;
  transition: all 0.2s;
  text-align: center;
  position: relative;
  overflow: hidden;
}
.gallery-card:hover {
  border-color: var(--accent);
  box-shadow: var(--glow-sm);
  transform: translateY(-1px);
}
.gallery-card.active {
  border-color: var(--accent-bright);
  box-shadow: var(--glow-md);
}
.gallery-card .mol-thumb {
  width: 100%;
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}
.gallery-card .mol-thumb svg {
  max-width: 100%;
  max-height: 100%;
}
.gallery-card .mol-name {
  font-size: 0.68rem;
  font-weight: 500;
  color: var(--text-secondary);
  margin-top: 3px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.gallery-card .mol-thumb {
  background: #ffffff;
  border-radius: 3px;
}

/* ═══════════════════════════════════════════════════════
   CENTER: EDITOR
   ═══════════════════════════════════════════════════════ */
.editor-panel {
  position: relative;
}
.editor-container {
  width: 100%;
  min-height: var(--editor-h);
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-mid);
  overflow: hidden;
  position: relative;
  transition: box-shadow 0.3s;
}
.editor-container:hover,
.editor-container:focus-within {
  box-shadow: var(--glow-lg);
  border-color: var(--border-bright);
}
.editor-container > div {
  width: 100% !important;
  height: var(--editor-h) !important;
}
.editor-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  gap: 8px;
}
.editor-toolbar .tool-group {
  display: flex;
  gap: 4px;
}
.tool-btn {
  width: 32px; height: 32px;
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-sm);
  background: var(--bg-elevated);
  color: var(--text-secondary);
  cursor: pointer;
  display: grid;
  place-items: center;
  transition: all 0.15s;
  font-size: 0.78rem;
}
.tool-btn:hover {
  border-color: var(--accent);
  color: var(--accent-bright);
}
.tool-btn.active {
  background: rgba(16,185,129,0.15);
  border-color: var(--accent);
  color: var(--accent-bright);
}
.editor-status {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 6px 14px;
  font-size: 0.72rem;
  color: var(--text-muted);
  border-top: 1px solid var(--glass-border);
}
.editor-status .dot {
  width: 6px; height: 6px;
  border-radius: 50%;
  background: var(--accent);
  box-shadow: 0 0 6px var(--accent);
  animation: pulse 2s ease-in-out infinite;
}
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}
.editor-status .status-text { flex: 1; }

/* ═══════════════════════════════════════════════════════
   RIGHT: OUTPUT PANEL
   ═══════════════════════════════════════════════════════ */
.output-section + .output-section {
  margin-top: 14px;
  padding-top: 14px;
  border-top: 1px solid var(--glass-border);
}
.output-section h3 {
  font-family: var(--font-display);
  font-size: 0.72rem;
  font-weight: 600;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.06em;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 6px;
}
.output-section h3 .icon {
  width: 14px; height: 14px;
  color: var(--accent);
}

/* SVG preview */
.svg-preview {
  width: 100%;
  height: 140px;
  background: var(--bg-elevated);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-sm);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  position: relative;
}
.svg-preview svg {
  max-width: 95%;
  max-height: 95%;
}
.svg-preview {
  background: #ffffff;
}
[data-theme="light"] .svg-preview {
  background: #ffffff;
}
.svg-preview .empty-msg {
  color: var(--text-muted);
  font-size: 0.78rem;
  font-style: italic;
}

/* properties grid */
.props-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 6px;
}
.prop-card {
  background: var(--bg-elevated);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-sm);
  padding: 8px 10px;
  text-align: center;
}
.prop-card .prop-value {
  font-family: var(--font-code);
  font-size: 0.9rem;
  font-weight: 500;
  color: var(--accent-bright);
  line-height: 1.2;
  word-break: break-all;
}
.prop-card .prop-label {
  font-size: 0.65rem;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.04em;
  margin-top: 2px;
}
.prop-card.wide {
  grid-column: 1 / -1;
}

/* output text areas */
.output-field-wrap {
  position: relative;
}
.output-field {
  width: 100%;
  background: var(--bg-elevated);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-sm);
  color: var(--text-code);
  font-family: var(--font-code);
  font-size: 0.75rem;
  padding: 10px 12px;
  padding-right: 36px;
  resize: vertical;
  outline: none;
  line-height: 1.5;
}
.output-field:focus {
  border-color: var(--accent);
}
.copy-btn {
  position: absolute;
  top: 6px;
  right: 6px;
  width: 26px; height: 26px;
  border: 1px solid var(--glass-border);
  border-radius: 4px;
  background: var(--bg-surface);
  color: var(--text-muted);
  cursor: pointer;
  display: grid;
  place-items: center;
  transition: all 0.15s;
}
.copy-btn:hover {
  color: var(--accent-bright);
  border-color: var(--accent);
}
.copy-btn svg { width: 13px; height: 13px; }

/* export buttons */
.export-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 6px;
}
.export-btn {
  height: 36px;
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-sm);
  background: var(--bg-elevated);
  color: var(--text-primary);
  font-family: var(--font-body);
  font-size: 0.75rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  transition: all 0.2s;
}
.export-btn:hover {
  border-color: var(--accent);
  color: var(--accent-bright);
  box-shadow: var(--glow-sm);
  background: rgba(16,185,129,0.06);
}
.export-btn svg { width: 14px; height: 14px; }

/* ═══════════════════════════════════════════════════════
   MODE SWITCHER
   ═══════════════════════════════════════════════════════ */
.mode-switcher {
  display: flex;
  background: var(--bg-elevated);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-sm);
  overflow: hidden;
}
.mode-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  border: none;
  background: transparent;
  color: var(--text-muted);
  font-family: var(--font-body);
  font-size: 0.72rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
}
.mode-btn:hover {
  color: var(--text-secondary);
}
.mode-btn.active {
  background: rgba(16,185,129,0.15);
  color: var(--accent-bright);
}
.mode-btn svg {
  flex-shrink: 0;
}

/* ═══════════════════════════════════════════════════════
   RENDER OPTIONS
   ═══════════════════════════════════════════════════════ */
.collapsible-header {
  cursor: pointer;
  user-select: none;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.collapsible-header .chevron {
  transition: transform 0.25s;
  color: var(--text-muted);
}
.collapsible-header.open .chevron {
  transform: rotate(180deg);
}
.render-opts-body {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.35s ease, opacity 0.25s;
  opacity: 0;
}
.render-opts-body.open {
  max-height: 800px;
  opacity: 1;
}
.opt-group {
  margin-top: 10px;
}
.opt-group-label {
  font-size: 0.65rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--accent);
  margin-bottom: 4px;
  padding-bottom: 3px;
  border-bottom: 1px solid var(--border-subtle);
}
.opt-toggle {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 3px 0;
  cursor: pointer;
  font-size: 0.78rem;
  color: var(--text-secondary);
  transition: color 0.15s;
}
.opt-toggle:hover {
  color: var(--text-primary);
}
.opt-toggle input[type="checkbox"] {
  appearance: none;
  -webkit-appearance: none;
  width: 14px;
  height: 14px;
  border: 1.5px solid var(--border-mid);
  border-radius: 3px;
  background: var(--bg-elevated);
  cursor: pointer;
  position: relative;
  flex-shrink: 0;
  transition: all 0.15s;
}
.opt-toggle input[type="checkbox"]:checked {
  background: var(--accent);
  border-color: var(--accent);
}
.opt-toggle input[type="checkbox"]:checked::after {
  content: '';
  position: absolute;
  left: 3px;
  top: 0.5px;
  width: 5px;
  height: 8px;
  border: solid #fff;
  border-width: 0 1.5px 1.5px 0;
  transform: rotate(45deg);
}
.opt-label {
  line-height: 1.3;
}

/* ═══════════════════════════════════════════════════════
   LOADING OVERLAY
   ═══════════════════════════════════════════════════════ */
.loading-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  background: var(--bg-deep);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 24px;
  transition: opacity 0.5s, visibility 0.5s;
}
.loading-overlay.hidden {
  opacity: 0;
  visibility: hidden;
  pointer-events: none;
}
.loader-molecule {
  width: 80px; height: 80px;
  position: relative;
}
.loader-molecule .atom {
  position: absolute;
  width: 12px; height: 12px;
  background: var(--accent);
  border-radius: 50%;
  box-shadow: 0 0 12px var(--accent);
}
.loader-molecule .atom:nth-child(1) { top: 0; left: 50%; transform: translateX(-50%); animation: loaderOrbit 1.5s ease-in-out infinite; }
.loader-molecule .atom:nth-child(2) { top: 50%; right: 0; transform: translateY(-50%); animation: loaderOrbit 1.5s ease-in-out 0.25s infinite; }
.loader-molecule .atom:nth-child(3) { bottom: 0; left: 50%; transform: translateX(-50%); animation: loaderOrbit 1.5s ease-in-out 0.5s infinite; }
.loader-molecule .atom:nth-child(4) { top: 50%; left: 0; transform: translateY(-50%); animation: loaderOrbit 1.5s ease-in-out 0.75s infinite; }
.loader-molecule .atom:nth-child(5) { top: 25%; left: 25%; animation: loaderOrbit 1.5s ease-in-out 1s infinite; background: var(--accent2); box-shadow: 0 0 12px var(--accent2); }
.loader-molecule .atom:nth-child(6) { top: 25%; right: 25%; animation: loaderOrbit 1.5s ease-in-out 1.25s infinite; background: var(--accent2); box-shadow: 0 0 12px var(--accent2); }
@keyframes loaderOrbit {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.3; transform: scale(0.6); }
}
.loading-text {
  font-family: var(--font-display);
  font-size: 0.88rem;
  color: var(--text-secondary);
  letter-spacing: 0.1em;
  text-transform: uppercase;
}
.loading-sub {
  font-size: 0.75rem;
  color: var(--text-muted);
  margin-top: -16px;
}

/* ═══════════════════════════════════════════════════════
   TOAST
   ═══════════════════════════════════════════════════════ */
.toast-container {
  position: fixed;
  bottom: 24px;
  right: 24px;
  z-index: 8000;
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.toast {
  padding: 10px 18px;
  background: var(--bg-elevated);
  border: 1px solid var(--border-mid);
  border-radius: var(--radius-md);
  color: var(--text-primary);
  font-size: 0.82rem;
  box-shadow: var(--glow-md);
  backdrop-filter: blur(12px);
  animation: toastIn 0.3s ease, toastOut 0.3s ease 2.5s forwards;
  display: flex;
  align-items: center;
  gap: 8px;
}
.toast .toast-icon { color: var(--accent-bright); flex-shrink: 0; }
@keyframes toastIn {
  from { opacity: 0; transform: translateX(40px); }
  to   { opacity: 1; transform: translateX(0); }
}
@keyframes toastOut {
  from { opacity: 1; transform: translateX(0); }
  to   { opacity: 0; transform: translateX(40px); }
}

/* ═══════════════════════════════════════════════════════
   SHORTCUTS MODAL
   ═══════════════════════════════════════════════════════ */
.modal-backdrop {
  position: fixed;
  inset: 0;
  z-index: 7000;
  background: rgba(0,0,0,0.5);
  backdrop-filter: blur(4px);
  display: none;
  place-items: center;
  animation: fadeIn 0.2s;
}
.modal-backdrop.open { display: grid; }
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
.modal {
  background: var(--bg-surface);
  border: 1px solid var(--glass-border);
  border-radius: var(--radius-xl);
  padding: 28px 32px;
  max-width: 440px;
  width: 90%;
  animation: modalIn 0.25s ease;
}
@keyframes modalIn {
  from { opacity: 0; transform: scale(0.95) translateY(8px); }
  to   { opacity: 1; transform: scale(1) translateY(0); }
}
.modal h2 {
  font-family: var(--font-display);
  font-size: 1.05rem;
  font-weight: 600;
  margin-bottom: 16px;
  color: var(--text-primary);
}
.shortcut-list {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.shortcut-list li {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 6px 0;
  font-size: 0.85rem;
  color: var(--text-secondary);
  border-bottom: 1px solid var(--glass-border);
}
.shortcut-list li:last-child { border: none; }
.shortcut-list kbd {
  font-family: var(--font-code);
  font-size: 0.72rem;
  background: var(--bg-elevated);
  border: 1px solid var(--glass-border);
  padding: 3px 8px;
  border-radius: 4px;
  color: var(--accent-bright);
}

/* ═══════════════════════════════════════════════════════
   ADS
   ═══════════════════════════════════════════════════════ */
.ad-hero {
  text-align: center;
  max-width: 970px;
  margin: 0 auto 8px;
  min-height: 50px;
}
.ad-hero .ad-label {
  font-size: 0.55rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--text-muted);
  opacity: 0.5;
  margin-bottom: 4px;
}
.ad-below-editor {
  margin: 20px auto 0;
  padding: 12px 0;
  text-align: center;
  max-width: 970px;
  min-height: 90px;
  opacity: 0;
  transition: opacity 0.4s;
}
.ad-below-editor.ad-loaded { opacity: 1; }
.ad-below-editor .ad-label {
  font-size: 0.6rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--text-muted);
  margin-bottom: 6px;
  opacity: 0.6;
}
.ad-sticky-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 6000;
  text-align: center;
  padding: 6px 0 8px;
  background: var(--bg-surface);
  border-top: 1px solid var(--glass-border);
  box-shadow: 0 -2px 12px rgba(0,0,0,0.15);
  transform: translateY(100%);
  transition: transform 0.4s ease;
  display: none;
}
.ad-sticky-footer.ad-visible {
  display: block;
  transform: translateY(0);
}
.ad-sticky-footer.ad-dismissed {
  transform: translateY(100%);
  pointer-events: none;
}
.ad-sticky-footer .ad-label {
  font-size: 0.55rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--text-muted);
  opacity: 0.5;
  margin-bottom: 2px;
}
.ad-sticky-footer .ad-close {
  position: absolute;
  top: 4px;
  right: 12px;
  width: 22px;
  height: 22px;
  border: 1px solid var(--glass-border);
  border-radius: 50%;
  background: var(--bg-elevated);
  color: var(--text-muted);
  font-size: 14px;
  line-height: 20px;
  text-align: center;
  cursor: pointer;
  transition: all 0.15s;
  z-index: 1;
}
.ad-sticky-footer .ad-close:hover {
  color: var(--text-primary);
  border-color: var(--border-mid);
}
@media (max-width: 600px) {
  .ad-below-editor { min-height: 50px; padding: 8px 0; }
  .ad-sticky-footer { padding: 4px 0 6px; }
}

/* ═══════════════════════════════════════════════════════
   RESPONSIVE
   ═══════════════════════════════════════════════════════ */
@media (max-width: 1200px) {
  .main-grid {
    grid-template-columns: 240px 1fr 260px;
  }
}
@media (max-width: 960px) {
  .main-grid {
    grid-template-columns: 1fr;
  }
  .editor-container { min-height: 400px; }
  .editor-container > div { height: 400px !important; }
  .gallery-grid { grid-template-columns: repeat(3, 1fr); }
}
@media (max-width: 600px) {
  html { font-size: 14px; }
  .site-header { flex-wrap: wrap; gap: 10px; }
  .gallery-grid { grid-template-columns: 1fr 1fr; }
  .export-grid { grid-template-columns: 1fr; }
  .props-grid { grid-template-columns: 1fr; }
  .page-wrap { padding: 0 12px 24px; }
}
</style>
</head>
<body>

<!-- LOADING OVERLAY -->
<div class="loading-overlay" id="loadingOverlay">
  <div class="loader-molecule">
    <div class="atom"></div><div class="atom"></div>
    <div class="atom"></div><div class="atom"></div>
    <div class="atom"></div><div class="atom"></div>
  </div>
  <div class="loading-text">Initializing ...</div>
  <div class="loading-sub">Loading molecular drawing engine&hellip;</div>
</div>

<!-- TOAST CONTAINER -->
<div class="toast-container" id="toastContainer"></div>

<!-- SHORTCUTS MODAL -->
<div class="modal-backdrop" id="shortcutsModal">
  <div class="modal">
    <h2>Keyboard Shortcuts</h2>
    <ul class="shortcut-list">
      <li>Load SMILES to editor <kbd>Ctrl + Enter</kbd></li>
      <li>Clear editor canvas <kbd>Ctrl + Shift + X</kbd></li>
      <li>Download SVG <kbd>Ctrl + S</kbd></li>
      <li>Download MOL file <kbd>Ctrl + Shift + S</kbd></li>
      <li>Copy SMILES <kbd>Ctrl + Shift + C</kbd></li>
      <li>Toggle dark / light <kbd>Ctrl + Shift + D</kbd></li>
      <li>Show shortcuts <kbd>?</kbd></li>
    </ul>
    <div style="text-align:right;margin-top:16px;">
      <button class="btn" onclick="document.getElementById('shortcutsModal').classList.remove('open')" style="width:auto;padding:0 18px;">Close</button>
    </div>
  </div>
</div>

<div class="page-wrap">

<!-- ═══════ HEADER ═══════ -->
<header class="site-header">
  <div class="logo-area">
    <div class="logo-hex">
      <svg viewBox="0 0 38 44" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M19 2L35 12v20L19 42 3 32V12L19 2z" stroke="url(#lg)" stroke-width="2" fill="none"/>
        <circle cx="19" cy="14" r="3" fill="#10b981"/>
        <circle cx="10" cy="24" r="3" fill="#06b6d4"/>
        <circle cx="28" cy="24" r="3" fill="#10b981"/>
        <circle cx="19" cy="34" r="2.5" fill="#06b6d4"/>
        <line x1="19" y1="14" x2="10" y2="24" stroke="#10b981" stroke-width="1.5" opacity="0.5"/>
        <line x1="19" y1="14" x2="28" y2="24" stroke="#10b981" stroke-width="1.5" opacity="0.5"/>
        <line x1="10" y1="24" x2="19" y2="34" stroke="#06b6d4" stroke-width="1.5" opacity="0.5"/>
        <line x1="28" y1="24" x2="19" y2="34" stroke="#06b6d4" stroke-width="1.5" opacity="0.5"/>
        <defs><linearGradient id="lg" x1="3" y1="2" x2="35" y2="42"><stop stop-color="#10b981"/><stop offset="1" stop-color="#06b6d4"/></linearGradient></defs>
      </svg>
    </div>
    <div>
      <h1>Molecule Draw</h1>
      <div class="subtitle">Interactive Molecular Structure Editor</div>
    </div>
  </div>
  <div class="header-actions">
    <button class="shortcuts-btn" onclick="document.getElementById('shortcutsModal').classList.add('open')">
      Shortcuts <kbd>?</kbd>
    </button>
    <button class="theme-toggle" id="themeToggle" title="Toggle theme">
      <svg id="themeIcon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/>
      </svg>
    </button>
  </div>
</header>

<!-- Ad: Hero Banner -->
<div class="ad-hero" id="ad_moldraw_hero" role="complementary" aria-label="Advertisement">
  <div class="ad-label">Advertisement</div>
</div>

<!-- Breadcrumb -->
<nav class="breadcrumb" aria-label="Breadcrumb">
  <a href="<%=request.getContextPath()%>/">Home</a>
  <span class="sep">/</span>
  <a href="<%=request.getContextPath()%>/chemistry/">Chemistry</a>
  <span class="sep">/</span>
  <span class="current">Molecule Draw</span>
</nav>

<!-- ═══════ MAIN GRID ═══════ -->
<div class="main-grid">

  <!-- ─── LEFT: INPUT ─── -->
  <div class="panel">
    <div class="panel-header">
      <h2>Input</h2>
      <span class="badge">SMILES &bull; MOL</span>
    </div>
    <div class="panel-body">

      <div class="input-section">
        <label for="smilesInput">SMILES Notation</label>
        <input type="text" id="smilesInput" class="input-field" placeholder="e.g. c1ccccc1 (benzene)">
        <div class="btn-row">
          <button class="btn btn-accent" id="loadSmilesBtn">Load</button>
          <button class="btn" id="clearSmilesBtn">Clear</button>
        </div>
      </div>

      <div class="input-section" id="rxnSmilesSection" style="display:none;">
        <label for="rxnSmilesInput">Reaction SMILES</label>
        <input type="text" id="rxnSmilesInput" class="input-field" placeholder="e.g. CC(=O)O.OCC>>CC(=O)OCC.O">
        <div class="btn-row">
          <button class="btn btn-accent" id="loadRxnSmilesBtn">Load</button>
          <button class="btn" id="clearRxnSmilesBtn">Clear</button>
        </div>
      </div>

      <div class="input-section" id="rxnFileSection" style="display:none;">
        <label for="rxnInput">RXN File</label>
        <textarea id="rxnInput" class="input-field" rows="4" placeholder="Paste RXN file contents&hellip;"></textarea>
        <div class="btn-row">
          <button class="btn btn-accent" id="loadRxnFileBtn">Load</button>
          <button class="btn" id="clearRxnBtn">Clear</button>
        </div>
      </div>

      <div class="input-section">
        <label for="molInput">MOL / SDF File</label>
        <textarea id="molInput" class="input-field" rows="4" placeholder="Paste MOL file contents&hellip;"></textarea>
        <div class="btn-row">
          <button class="btn btn-accent" id="loadMolBtn">Load</button>
          <button class="btn" id="clearMolBtn">Clear</button>
        </div>
      </div>

      <div class="input-section" id="moleculeGallerySection">
        <div class="gallery-label">
          <label style="margin:0;">Common Molecules</label>
        </div>
        <div class="gallery-grid" id="galleryGrid"></div>
      </div>

      <div class="input-section" id="reactionGallerySection" style="display:none;">
        <div class="gallery-label">
          <label style="margin:0;">Common Reactions</label>
        </div>
        <div class="gallery-grid" id="rxnGalleryGrid"></div>
      </div>

    </div>
  </div>

  <!-- ─── CENTER: EDITOR ─── -->
  <div class="panel editor-panel">
    <div class="panel-header">
      <h2>Structure Editor</h2>
      <div style="display:flex;gap:6px;align-items:center;">
        <div class="mode-switcher" id="modeSwitcher">
          <button class="mode-btn active" data-mode="molecule" id="modeMolecule" title="Molecule mode">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="3"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="18" r="3"/><line x1="12" y1="11" x2="6" y2="15"/><line x1="12" y1="11" x2="18" y2="15"/></svg>
            Molecule
          </button>
          <button class="mode-btn" data-mode="reaction" id="modeReaction" title="Reaction mode">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="15 8 19 12 15 16"/></svg>
            Reaction
          </button>
        </div>
        <button class="tool-btn" id="clearEditorBtn" title="Clear canvas">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2"/></svg>
        </button>
      </div>
    </div>
    <div class="editor-container" id="editorContainer">
      <!-- OpenChemLib CanvasEditor mounts here -->
    </div>
    <div class="editor-status">
      <span class="dot"></span>
      <span class="status-text" id="statusText">Ready &mdash; draw or load a molecule</span>
      <span id="atomCount" style="font-family:var(--font-code);color:var(--accent);">0 atoms</span>
    </div>
  </div>

  <!-- ─── RIGHT: OUTPUT ─── -->
  <div class="panel">
    <div class="panel-header">
      <h2>Output</h2>
      <span class="badge">LIVE</span>
    </div>
    <div class="panel-body">

      <div class="output-section">
        <h3><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg> Preview</h3>
        <div class="svg-preview" id="svgPreview">
          <span class="empty-msg">Draw a molecule to see preview</span>
        </div>
      </div>

      <div class="output-section">
        <h3><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg> Properties</h3>
        <div class="props-grid" id="propsGrid">
          <div class="prop-card wide"><div class="prop-value" id="propFormula">&mdash;</div><div class="prop-label">Formula</div></div>
          <div class="prop-card"><div class="prop-value" id="propMW">&mdash;</div><div class="prop-label">Mol. Weight</div></div>
          <div class="prop-card"><div class="prop-value" id="propAtoms">&mdash;</div><div class="prop-label">Atoms</div></div>
          <div class="prop-card"><div class="prop-value" id="propBonds">&mdash;</div><div class="prop-label">Bonds</div></div>
          <div class="prop-card"><div class="prop-value" id="propRings">&mdash;</div><div class="prop-label">Rings</div></div>
        </div>
      </div>

      <div class="output-section">
        <h3 class="collapsible-header" id="renderOptsToggle">
          <span style="display:flex;align-items:center;gap:6px;">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"/></svg>
            Render Options
          </span>
          <svg class="chevron" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
        </h3>
        <div class="render-opts-body" id="renderOptsBody">
          <div class="opt-group">
            <div class="opt-group-label">Display</div>
            <label class="opt-toggle"><input type="checkbox" id="opt_inflateToMaxAVBL"><span class="opt-label">Inflate to max avg bond length</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_inflateToHighResAVBL"><span class="opt-label">Inflate high resolution</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_showAtomNumber"><span class="opt-label">Show atom numbers</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_showBondNumber"><span class="opt-label">Show bond numbers</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_showMapping"><span class="opt-label">Show mapping</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_showSymmetrySimple"><span class="opt-label">Show simple symmetries</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_showSymmetryAny"><span class="opt-label">Show all symmetries</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_showSymmetryStereoHeterotopicity"><span class="opt-label">Show stereo-heterotopicity</span></label>
          </div>
          <div class="opt-group">
            <div class="opt-group-label">Suppress / Hide</div>
            <label class="opt-toggle"><input type="checkbox" id="opt_suppressChiralText"><span class="opt-label">Suppress chiral text</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_suppressCIPParity"><span class="opt-label">Suppress CIP parity</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_suppressESR"><span class="opt-label">Suppress ESR</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_noImplicitHydrogen"><span class="opt-label">Hide implicit hydrogens</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_noImplicitAtomLabelColors"><span class="opt-label">Disable atom label colors</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_noStereoProblem"><span class="opt-label">Disable stereo problems</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_noCIPOnESR"><span class="opt-label">Disable CIP/ESR coloring</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_noCustomLabels"><span class="opt-label">Hide custom labels</span></label>
          </div>
          <div class="opt-group">
            <div class="opt-group-label">Chiral Text Position</div>
            <label class="opt-toggle"><input type="checkbox" id="opt_chiralTextBelowMolecule"><span class="opt-label">Below molecule</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_chiralTextAboveMolecule"><span class="opt-label">Above molecule</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_chiralTextOnFrameTop"><span class="opt-label">Top of frame</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_chiralTextOnFrameBottom"><span class="opt-label">Bottom of frame</span></label>
          </div>
          <div class="opt-group">
            <div class="opt-group-label">Style</div>
            <label class="opt-toggle"><input type="checkbox" id="opt_bondsInGray"><span class="opt-label">Bonds in gray</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_autoCrop"><span class="opt-label">Auto-crop whitespace</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_noTabus"><span class="opt-label">No tabus</span></label>
            <label class="opt-toggle"><input type="checkbox" id="opt_highlightQueryFeatures"><span class="opt-label">Highlight query features</span></label>
          </div>
        </div>
      </div>

      <div class="output-section">
        <h3><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg> SMILES</h3>
        <div class="output-field-wrap">
          <input type="text" class="output-field" id="smilesOutput" readonly placeholder="SMILES will appear here">
          <button class="copy-btn" onclick="copyField('smilesOutput')" title="Copy">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
          </button>
        </div>
      </div>

      <div class="output-section" id="molOutputSection">
        <h3><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg> MOL File</h3>
        <div class="output-field-wrap">
          <textarea class="output-field" id="molOutput" rows="5" readonly placeholder="MOL file data will appear here"></textarea>
          <button class="copy-btn" onclick="copyField('molOutput')" title="Copy">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
          </button>
        </div>
      </div>

      <div class="output-section" id="rxnOutputSection" style="display:none;">
        <h3><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="15 8 19 12 15 16"/></svg> Reaction</h3>
        <div class="props-grid" style="margin-bottom:8px;">
          <div class="prop-card"><div class="prop-value" id="propReactants">&mdash;</div><div class="prop-label">Reactants</div></div>
          <div class="prop-card"><div class="prop-value" id="propProducts">&mdash;</div><div class="prop-label">Products</div></div>
          <div class="prop-card"><div class="prop-value" id="propCatalysts">&mdash;</div><div class="prop-label">Catalysts</div></div>
          <div class="prop-card"><div class="prop-value" id="propMapped">&mdash;</div><div class="prop-label">Mapped</div></div>
        </div>
        <h3 style="margin-top:6px;"><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg> Reaction SMILES</h3>
        <div class="output-field-wrap" style="margin-bottom:8px;">
          <input type="text" class="output-field" id="rxnSmilesOutput" readonly placeholder="Reaction SMILES">
          <button class="copy-btn" onclick="copyField('rxnSmilesOutput')" title="Copy">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
          </button>
        </div>
        <div class="output-field-wrap">
          <textarea class="output-field" id="rxnOutput" rows="5" readonly placeholder="RXN file data"></textarea>
          <button class="copy-btn" onclick="copyField('rxnOutput')" title="Copy">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
          </button>
        </div>
      </div>

      <div class="output-section">
        <h3><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg> Export</h3>
        <div class="export-grid">
          <button class="export-btn" id="exportSvg">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
            SVG
          </button>
          <button class="export-btn" id="exportMol">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
            MOL
          </button>
          <button class="export-btn" id="exportPng">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg>
            PNG
          </button>
          <button class="export-btn" id="copySmiles">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
            SMILES
          </button>
        </div>
      </div>

    </div>
  </div>

</div><!-- /main-grid -->

<!-- Related Tools -->
<div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:20px;align-items:center;">
  <span style="font-size:0.75rem;color:var(--text-muted);font-weight:600;letter-spacing:0.04em;">ALSO TRY &rarr;</span>
  <a href="<%=request.getContextPath()%>/lewis-structure-generator.jsp" style="display:inline-flex;align-items:center;gap:6px;padding:6px 14px;background:var(--bg-elevated);border:1px solid var(--glass-border);border-radius:var(--radius-sm);text-decoration:none;font-size:0.8rem;font-weight:500;color:var(--text-primary);transition:all 0.2s;" onmouseover="this.style.borderColor='var(--accent)';this.style.boxShadow='var(--glow-sm)'" onmouseout="this.style.borderColor='';this.style.boxShadow=''">&#x1F517; Lewis Structures</a>
  <a href="<%=request.getContextPath()%>/molecular-geometry-calculator.jsp" style="display:inline-flex;align-items:center;gap:6px;padding:6px 14px;background:var(--bg-elevated);border:1px solid var(--glass-border);border-radius:var(--radius-sm);text-decoration:none;font-size:0.8rem;font-weight:500;color:var(--text-primary);transition:all 0.2s;" onmouseover="this.style.borderColor='var(--accent)';this.style.boxShadow='var(--glow-sm)'" onmouseout="this.style.borderColor='';this.style.boxShadow=''">&#x1F4D0; 3D Geometry</a>
  <a href="<%=request.getContextPath()%>/chemistry/" style="display:inline-flex;align-items:center;gap:6px;padding:6px 14px;background:var(--bg-elevated);border:1px solid var(--glass-border);border-radius:var(--radius-sm);text-decoration:none;font-size:0.8rem;font-weight:500;color:var(--text-primary);transition:all 0.2s;" onmouseover="this.style.borderColor='var(--accent)';this.style.boxShadow='var(--glow-sm)'" onmouseout="this.style.borderColor='';this.style.boxShadow=''">&#x269B; All Chemistry Tools</a>
</div>

<!-- Ad: Below Editor Leaderboard -->
<div class="ad-below-editor" id="ad_moldraw_below_editor" role="complementary" aria-label="Advertisement">
  <div class="ad-label">Advertisement</div>
</div>

</div><!-- /page-wrap -->

<!-- Ad: Sticky Footer -->
<div class="ad-sticky-footer" id="adStickyWrap" role="complementary" aria-label="Advertisement">
  <button class="ad-close" aria-label="Close advertisement" id="adStickyClose" type="button">&times;</button>
  <div class="ad-label">Advertisement</div>
  <div id="ad_moldraw_sticky_footer"></div>
</div>

<script type="module">
// ═══════════════════════════════════════════════════════
// COMMON MOLECULES
// ═══════════════════════════════════════════════════════
const MOLECULES = [
  { name: 'Benzene',      smiles: 'c1ccccc1' },
  { name: 'Ethanol',      smiles: 'CCO' },
  { name: 'Caffeine',     smiles: 'CN1C=NC2=C1C(=O)N(C(=O)N2C)C' },
  { name: 'Aspirin',      smiles: 'CC(=O)OC1=CC=CC=C1C(=O)O' },
  { name: 'Glucose',      smiles: 'OC[C@H]1OC(O)[C@H](O)[C@@H](O)[C@@H]1O' },
  { name: 'Paracetamol',  smiles: 'CC(=O)NC1=CC=C(O)C=C1' },
  { name: 'Dopamine',     smiles: 'C1=CC(=C(C=C1CCN)O)O' },
  { name: 'Nicotine',     smiles: 'CN1CCC[C@H]1C2=CN=CC=C2' },
  { name: 'Serotonin',    smiles: 'C1=CC2=C(C=C1O)C(=CN2)CCN' },
  { name: 'Adrenaline',   smiles: 'CNC[C@@H](O)C1=CC(O)=C(O)C=C1' },
  { name: 'Ibuprofen',    smiles: 'CC(C)CC1=CC=C(C=C1)C(C)C(=O)O' },
  { name: 'Cholesterol',  smiles: 'CC(CCCC(C)C)[C@H]1CC[C@@H]2[C@@]1(CC[C@H]3[C@H]2CC=C4[C@@]3(CC[C@@H](C4)O)C)C' },
];

const REACTIONS = [
  { name: 'Esterification',     smiles: 'CC(=O)O.OCC>>CC(=O)OCC.O' },
  { name: 'SN2 Substitution',   smiles: 'CCBr.[OH-]>>CCO.[Br-]' },
  { name: 'Diels-Alder',        smiles: 'C=CC=C.C=C>>C1CC=CCC1' },
  { name: 'Aldol Condensation', smiles: 'CC=O.CC=O>>CC(O)CC=O' },
  { name: 'Saponification',     smiles: 'CC(=O)OCC.[OH-]>>CC(=O)[O-].OCC' },
  { name: 'Dehydration',        smiles: 'CCO>>C=C.O' },
];

// ═══════════════════════════════════════════════════════
// GLOBALS
// ═══════════════════════════════════════════════════════
let OCL = null;
let editor = null;
let currentMolecule = null;
let currentMode = 'molecule';

// ═══════════════════════════════════════════════════════
// RENDER OPTIONS
// ═══════════════════════════════════════════════════════
const RENDER_OPT_IDS = [
  'inflateToMaxAVBL','inflateToHighResAVBL',
  'showAtomNumber','showBondNumber','showMapping',
  'showSymmetrySimple','showSymmetryAny','showSymmetryStereoHeterotopicity',
  'suppressChiralText','suppressCIPParity','suppressESR',
  'noImplicitHydrogen','noImplicitAtomLabelColors','noStereoProblem',
  'noCIPOnESR','noCustomLabels',
  'chiralTextBelowMolecule','chiralTextAboveMolecule',
  'chiralTextOnFrameTop','chiralTextOnFrameBottom',
  'bondsInGray','autoCrop','noTabus','highlightQueryFeatures'
];

function getRenderOptions() {
  const opts = {};
  RENDER_OPT_IDS.forEach(id => {
    const el = document.getElementById('opt_' + id);
    if (el && el.checked) opts[id] = true;
  });
  if (opts.autoCrop) opts.autoCropMargin = 5;
  return opts;
}

// ═══════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════
function $(id) { return document.getElementById(id); }

function toast(msg) {
  const el = document.createElement('div');
  el.className = 'toast';
  el.innerHTML = '<svg class="toast-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>' + msg;
  $('toastContainer').appendChild(el);
  setTimeout(() => el.remove(), 2800);
}

window.copyField = function(id) {
  const el = $(id);
  const val = el.value || el.textContent;
  if (!val || val === '\u2014') { toast('Nothing to copy'); return; }
  navigator.clipboard.writeText(val).then(() => toast('Copied to clipboard'));
};

function downloadFile(content, filename, mime) {
  const blob = new Blob([content], { type: mime });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url; a.download = filename;
  document.body.appendChild(a); a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
  toast('Downloaded ' + filename);
}

// ═══════════════════════════════════════════════════════
// UPDATE OUTPUT from a Molecule object
// ═══════════════════════════════════════════════════════
function updateOutput(molecule) {
  currentMolecule = molecule;
  if (!molecule || molecule.getAllAtoms() === 0) {
    $('svgPreview').innerHTML = '<span class="empty-msg">Draw a molecule to see preview</span>';
    $('smilesOutput').value = '';
    $('molOutput').value = '';
    $('propFormula').textContent = '\u2014';
    $('propMW').textContent = '\u2014';
    $('propAtoms').textContent = '\u2014';
    $('propBonds').textContent = '\u2014';
    $('propRings').textContent = '\u2014';
    $('atomCount').textContent = '0 atoms';
    $('statusText').textContent = 'Ready \u2014 draw or load a molecule';
    return;
  }
  try {
    // SVG preview
    const renderOpts = getRenderOptions();
    const svg = molecule.toSVG(280, 130, null, renderOpts);
    $('svgPreview').innerHTML = svg;

    // SMILES
    const smiles = molecule.toSmiles();
    $('smilesOutput').value = smiles || '';

    // MOL file
    const molfile = molecule.toMolfileV3();
    $('molOutput').value = molfile || '';

    // Properties
    const atoms = molecule.getAllAtoms();
    const bonds = molecule.getAllBonds();

    let formula = '\u2014';
    try { formula = molecule.getMolecularFormula().formula || '\u2014'; } catch {}

    let mw = '\u2014';
    try { const w = molecule.getMolweight(); mw = w ? w.toFixed(2) : '\u2014'; } catch {}

    let rings = '\u2014';
    try {
      molecule.ensureHelperArrays(OCL.Molecule.cHelperRings);
      rings = molecule.getRingSet().getSize();
    } catch {}

    $('propFormula').textContent = formula;
    $('propMW').textContent = mw;
    $('propAtoms').textContent = atoms;
    $('propBonds').textContent = bonds;
    $('propRings').textContent = rings;
    $('atomCount').textContent = atoms + ' atom' + (atoms !== 1 ? 's' : '');
    $('statusText').textContent = formula !== '\u2014' ? formula + ' \u2014 ' + smiles : 'Molecule loaded';
  } catch (e) {
    console.warn('Output update error:', e);
  }
}

function updateReactionOutput(reaction) {
  if (!reaction || reaction.isEmpty()) {
    $('svgPreview').innerHTML = '<span class="empty-msg">Draw a reaction to see preview</span>';
    $('rxnSmilesOutput').value = '';
    $('rxnOutput').value = '';
    $('propReactants').textContent = '\u2014';
    $('propProducts').textContent = '\u2014';
    $('propCatalysts').textContent = '\u2014';
    $('propMapped').textContent = '\u2014';
    $('atomCount').textContent = '0 atoms';
    $('statusText').textContent = 'Ready \u2014 draw a reaction';
    return;
  }
  try {
    const nR = reaction.getReactants();
    const nP = reaction.getProducts();
    const nC = reaction.getCatalysts();
    $('propReactants').textContent = nR;
    $('propProducts').textContent = nP;
    $('propCatalysts').textContent = nC;
    try { $('propMapped').textContent = reaction.isPerfectlyMapped() ? 'Yes' : 'Partial'; } catch { $('propMapped').textContent = '\u2014'; }

    let rxnSmiles = '';
    try { rxnSmiles = reaction.toSmiles(); } catch {}
    $('rxnSmilesOutput').value = rxnSmiles || '';

    let rxnFile = '';
    try { rxnFile = reaction.toRxnV3(); } catch {}
    $('rxnOutput').value = rxnFile || '';

    // Count total atoms
    let totalAtoms = 0;
    try {
      const mols = reaction.getMolecules();
      for (let i = 0; i < mols; i++) {
        totalAtoms += reaction.getMolecule(i).getAllAtoms();
      }
    } catch {}
    $('atomCount').textContent = totalAtoms + ' atoms';
    $('statusText').textContent = rxnSmiles ? nR + ' reactant' + (nR>1?'s':'') + ' \u2192 ' + nP + ' product' + (nP>1?'s':'') : 'Reaction loaded';
  } catch (e) {
    console.warn('Reaction output error:', e);
  }
}

// ═══════════════════════════════════════════════════════
// MODE SWITCHING
// ═══════════════════════════════════════════════════════
function switchMode(mode) {
  if (mode === currentMode) return;
  currentMode = mode;
  currentMolecule = null;

  // Update UI toggle
  document.querySelectorAll('.mode-btn').forEach(b => b.classList.toggle('active', b.dataset.mode === mode));

  // Show/hide mode-specific panels
  const isMol = mode === 'molecule';
  $('smilesInput').closest('.input-section').style.display = isMol ? '' : 'none';
  $('rxnSmilesSection').style.display = isMol ? 'none' : '';
  $('rxnFileSection').style.display = isMol ? 'none' : '';
  $('moleculeGallerySection').style.display = isMol ? '' : 'none';
  $('reactionGallerySection').style.display = isMol ? 'none' : '';

  // Output sections
  $('smilesOutput').closest('.output-section').style.display = isMol ? '' : 'none';
  $('molOutputSection').style.display = isMol ? '' : 'none';
  $('rxnOutputSection').style.display = isMol ? 'none' : '';

  // Properties section (hide molecule props in reaction mode)
  $('propsGrid').closest('.output-section').style.display = isMol ? '' : 'none';

  // Recreate editor in new mode
  if (editor) {
    try { editor.destroy(); } catch (_) {}
  }
  const container = $('editorContainer');
  container.innerHTML = '';
  editor = new OCL.CanvasEditor(container, {
    initialMode: mode,
    initialFragment: false,
    readOnly: false,
  });
  editor.setOnChangeListener(() => {
    try {
      if (currentMode === 'molecule') {
        updateOutput(editor.getMolecule());
      } else {
        updateReactionOutput(editor.getReaction());
      }
    } catch (e) {
      console.warn('Change listener error:', e);
    }
  });

  // Clear outputs
  if (isMol) {
    updateOutput(null);
  } else {
    updateReactionOutput(null);
  }
  $('svgPreview').innerHTML = '<span class="empty-msg">Draw ' + (isMol ? 'a molecule' : 'a reaction') + ' to see preview</span>';
  toast('Switched to ' + mode + ' mode');
}

// ═══════════════════════════════════════════════════════
// LOAD OpenChemLib
// ═══════════════════════════════════════════════════════
async function initApp() {
  try {
    OCL = await import('https://esm.sh/openchemlib@9.21.0');
    if (OCL.default) OCL = OCL.default;

    // Build gallery thumbnails
    const grid = $('galleryGrid');
    MOLECULES.forEach((m, i) => {
      const card = document.createElement('div');
      card.className = 'gallery-card';
      card.dataset.index = i;
      try {
        const mol = OCL.Molecule.fromSmiles(m.smiles);
        const svg = mol.toSVG(100, 56);
        card.innerHTML = '<div class="mol-thumb">' + svg + '</div><div class="mol-name">' + m.name + '</div>';
      } catch {
        card.innerHTML = '<div class="mol-thumb" style="font-size:0.7rem;color:var(--text-muted);">?</div><div class="mol-name">' + m.name + '</div>';
      }
      card.addEventListener('click', () => loadMoleculeFromSmiles(m.smiles, m.name, card));
      grid.appendChild(card);
    });

    // Build reaction gallery
    const rxnGrid = $('rxnGalleryGrid');
    REACTIONS.forEach((r, i) => {
      const card = document.createElement('div');
      card.className = 'gallery-card';
      card.dataset.index = i;
      card.innerHTML = '<div class="mol-thumb" style="font-size:0.65rem;color:var(--text-secondary);padding:4px;line-height:1.3;word-break:break-all;font-family:var(--font-code);">' + r.smiles.replace('>>', ' \u2192 ') + '</div><div class="mol-name">' + r.name + '</div>';
      card.addEventListener('click', () => {
        try {
          const rxn = OCL.Reaction.fromSmiles(r.smiles);
          editor.setReaction(rxn);
          updateReactionOutput(rxn);
          document.querySelectorAll('#rxnGalleryGrid .gallery-card').forEach(c => c.classList.remove('active'));
          card.classList.add('active');
          toast('Loaded ' + r.name);
        } catch (e) { toast('Error: ' + e.message); }
      });
      rxnGrid.appendChild(card);
    });

    // Init canvas editor
    const container = $('editorContainer');
    editor = new OCL.CanvasEditor(container, {
      initialMode: 'molecule',
      initialFragment: false,
      readOnly: false,
    });

    editor.setOnChangeListener(() => {
      try {
        if (currentMode === 'molecule') {
          updateOutput(editor.getMolecule());
        } else {
          updateReactionOutput(editor.getReaction());
        }
      } catch (e) {
        console.warn('Change listener error:', e);
      }
    });

    // Hide loading
    $('loadingOverlay').classList.add('hidden');

  } catch (err) {
    console.error('Failed to load OpenChemLib:', err);
    $('loadingOverlay').querySelector('.loading-text').textContent = 'Failed to load engine';
    $('loadingOverlay').querySelector('.loading-sub').textContent = err.message + ' \u2014 try refreshing';
  }
}

// ═══════════════════════════════════════════════════════
// ACTIONS
// ═══════════════════════════════════════════════════════
function loadMoleculeFromSmiles(smiles, name, cardEl) {
  if (!OCL || !editor) return;
  try {
    const mol = OCL.Molecule.fromSmiles(smiles);
    mol.inventCoordinates();
    editor.setMolecule(mol);
    updateOutput(mol);
    if (name) toast('Loaded ' + name);

    // highlight active gallery card
    document.querySelectorAll('.gallery-card').forEach(c => c.classList.remove('active'));
    if (cardEl) cardEl.classList.add('active');
  } catch (e) {
    toast('Invalid SMILES: ' + e.message);
  }
}

function loadMoleculeFromMolfile(molfile) {
  if (!OCL || !editor) return;
  try {
    const mol = OCL.Molecule.fromMolfile(molfile);
    editor.setMolecule(mol);
    updateOutput(mol);
    toast('Loaded MOL file');
  } catch (e) {
    toast('Invalid MOL file: ' + e.message);
  }
}

// ═══════════════════════════════════════════════════════
// WIRE UP UI
// ═══════════════════════════════════════════════════════
$('loadSmilesBtn').addEventListener('click', () => {
  const val = $('smilesInput').value.trim();
  if (val) loadMoleculeFromSmiles(val);
  else toast('Enter a SMILES string first');
});

$('smilesInput').addEventListener('keydown', (e) => {
  if (e.key === 'Enter') {
    e.preventDefault();
    $('loadSmilesBtn').click();
  }
});

$('clearSmilesBtn').addEventListener('click', () => { $('smilesInput').value = ''; });

$('loadMolBtn').addEventListener('click', () => {
  const val = $('molInput').value.trim();
  if (val) loadMoleculeFromMolfile(val);
  else toast('Paste a MOL file first');
});

$('clearMolBtn').addEventListener('click', () => { $('molInput').value = ''; });

// MODE BUTTONS
$('modeMolecule').addEventListener('click', () => switchMode('molecule'));
$('modeReaction').addEventListener('click', () => switchMode('reaction'));

// REACTION INPUTS
$('loadRxnSmilesBtn').addEventListener('click', () => {
  const val = $('rxnSmilesInput').value.trim();
  if (!val) { toast('Enter a reaction SMILES first'); return; }
  try {
    const rxn = OCL.Reaction.fromSmiles(val);
    editor.setReaction(rxn);
    updateReactionOutput(rxn);
    toast('Loaded reaction');
  } catch (e) { toast('Invalid reaction SMILES: ' + e.message); }
});

$('rxnSmilesInput').addEventListener('keydown', (e) => {
  if (e.key === 'Enter') { e.preventDefault(); $('loadRxnSmilesBtn').click(); }
});

$('clearRxnSmilesBtn').addEventListener('click', () => { $('rxnSmilesInput').value = ''; });

$('loadRxnFileBtn').addEventListener('click', () => {
  const val = $('rxnInput').value.trim();
  if (!val) { toast('Paste a RXN file first'); return; }
  try {
    const rxn = OCL.Reaction.fromRxn(val);
    editor.setReaction(rxn);
    updateReactionOutput(rxn);
    toast('Loaded RXN file');
  } catch (e) { toast('Invalid RXN file: ' + e.message); }
});

$('clearRxnBtn').addEventListener('click', () => { $('rxnInput').value = ''; });

// CLEAR EDITOR
$('clearEditorBtn').addEventListener('click', () => {
  if (!editor) return;
  editor.clearAll();
  if (currentMode === 'molecule') updateOutput(null);
  else updateReactionOutput(null);
  document.querySelectorAll('.gallery-card').forEach(c => c.classList.remove('active'));
  toast('Canvas cleared');
});

// EXPORTS
$('exportSvg').addEventListener('click', () => {
  if (currentMode === 'molecule') {
    if (!currentMolecule || currentMolecule.getAllAtoms() === 0) { toast('Draw a molecule first'); return; }
    const svg = currentMolecule.toSVG(800, 600, null, getRenderOptions());
    downloadFile(svg, 'molecule.svg', 'image/svg+xml');
  } else {
    toast('SVG export for reactions: use PNG or copy RXN');
  }
});

$('exportMol').addEventListener('click', () => {
  if (currentMode === 'molecule') {
    if (!currentMolecule || currentMolecule.getAllAtoms() === 0) { toast('Draw a molecule first'); return; }
    downloadFile(currentMolecule.toMolfileV3(), 'molecule.mol', 'chemical/x-mdl-molfile');
  } else {
    const rxnData = $('rxnOutput').value;
    if (!rxnData) { toast('Draw a reaction first'); return; }
    downloadFile(rxnData, 'reaction.rxn', 'chemical/x-mdl-rxnfile');
  }
});

$('exportPng').addEventListener('click', () => {
  if (currentMode === 'reaction') { toast('PNG export not available in reaction mode \u2014 use RXN export'); return; }
  if (!currentMolecule || currentMolecule.getAllAtoms() === 0) { toast('Draw a molecule first'); return; }
  const svg = currentMolecule.toSVG(1600, 1200, null, getRenderOptions());
  const canvas = document.createElement('canvas');
  canvas.width = 1600; canvas.height = 1200;
  const ctx = canvas.getContext('2d');
  const img = new Image();
  img.onload = () => {
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, 1600, 1200);
    ctx.drawImage(img, 0, 0);
    canvas.toBlob((b) => {
      const a = document.createElement('a');
      a.href = URL.createObjectURL(b);
      a.download = 'molecule.png';
      a.click();
      URL.revokeObjectURL(a.href);
      toast('Downloaded molecule.png');
    }, 'image/png');
  };
  img.onerror = () => { toast('PNG render failed'); };
  img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svg)));
});

$('copySmiles').addEventListener('click', () => {
  const val = currentMode === 'molecule' ? $('smilesOutput').value : $('rxnSmilesOutput').value;
  if (!val) { toast('No SMILES to copy'); return; }
  navigator.clipboard.writeText(val).then(() => toast('SMILES copied'));
});

// THEME TOGGLE
$('themeToggle').addEventListener('click', () => {
  const html = document.documentElement;
  const isDark = html.dataset.theme === 'dark';
  html.dataset.theme = isDark ? 'light' : 'dark';
  $('themeIcon').innerHTML = isDark
    ? '<circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>'
    : '<path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/>';
  localStorage.setItem('mol-draw-theme', html.dataset.theme);
});

// restore theme
(function() {
  const saved = localStorage.getItem('mol-draw-theme');
  if (saved === 'light') {
    document.documentElement.dataset.theme = 'light';
    $('themeIcon').innerHTML = '<circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>';
  }
})();

// KEYBOARD SHORTCUTS
document.addEventListener('keydown', (e) => {
  // ? = show shortcuts
  if (e.key === '?' && !e.ctrlKey && !e.metaKey) {
    const tag = document.activeElement.tagName;
    if (tag === 'INPUT' || tag === 'TEXTAREA') return;
    $('shortcutsModal').classList.add('open');
  }
  // Escape = close modal
  if (e.key === 'Escape') {
    $('shortcutsModal').classList.remove('open');
  }
  const mod = e.ctrlKey || e.metaKey;
  // Ctrl+Enter = load SMILES
  if (mod && e.key === 'Enter') {
    e.preventDefault();
    $('loadSmilesBtn').click();
  }
  // Ctrl+Shift+X = clear
  if (mod && e.shiftKey && e.key === 'X') {
    e.preventDefault();
    $('clearEditorBtn').click();
  }
  // Ctrl+S = download SVG
  if (mod && !e.shiftKey && e.key === 's') {
    e.preventDefault();
    $('exportSvg').click();
  }
  // Ctrl+Shift+S = download MOL
  if (mod && e.shiftKey && e.key === 'S') {
    e.preventDefault();
    $('exportMol').click();
  }
  // Ctrl+Shift+C = copy SMILES
  if (mod && e.shiftKey && e.key === 'C') {
    e.preventDefault();
    $('copySmiles').click();
  }
  // Ctrl+Shift+D = toggle theme
  if (mod && e.shiftKey && e.key === 'D') {
    e.preventDefault();
    $('themeToggle').click();
  }
});

// Close modal on backdrop click
$('shortcutsModal').addEventListener('click', (e) => {
  if (e.target === $('shortcutsModal')) $('shortcutsModal').classList.remove('open');
});

// RENDER OPTIONS - collapsible toggle
$('renderOptsToggle').addEventListener('click', () => {
  $('renderOptsToggle').classList.toggle('open');
  $('renderOptsBody').classList.toggle('open');
});

// RENDER OPTIONS - re-render preview when any checkbox changes
RENDER_OPT_IDS.forEach(id => {
  const el = document.getElementById('opt_' + id);
  if (el) {
    el.addEventListener('change', () => {
      if (currentMode === 'molecule' && currentMolecule && currentMolecule.getAllAtoms() > 0) {
        try {
          const svg = currentMolecule.toSVG(280, 130, null, getRenderOptions());
          $('svgPreview').innerHTML = svg;
        } catch (e) { console.warn('Render option error:', e); }
      }
    });
  }
});

// ═══════════════════════════════════════════════════════
// ADS
// ═══════════════════════════════════════════════════════
(function initAds() {
  // Slot 0: Hero banner — loads immediately (above fold)
  if (typeof googletag !== 'undefined' && googletag.cmd) {
    googletag.cmd.push(() => { googletag.display('ad_moldraw_hero'); });
  }

  // Slot 1: Below-editor leaderboard — lazy load via IntersectionObserver
  const belowAd = document.getElementById('ad_moldraw_below_editor');
  if (belowAd && 'IntersectionObserver' in window) {
    const obs = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          if (typeof googletag !== 'undefined' && googletag.cmd) {
            googletag.cmd.push(() => {
              googletag.display('ad_moldraw_below_editor');
              belowAd.classList.add('ad-loaded');
            });
          }
          obs.unobserve(belowAd);
        }
      });
    }, { rootMargin: '200px', threshold: 0.01 });
    obs.observe(belowAd);
  }

  // Slot 2: Sticky footer — delayed, dismissible
  const stickyWrap = document.getElementById('adStickyWrap');
  const stickyClose = document.getElementById('adStickyClose');
  if (stickyWrap) {
    // Check if previously dismissed
    if (localStorage.getItem('ad_moldraw_sticky_dismissed') === 'true') return;

    const delay = window.innerWidth < 768 ? 4000 : 2000;
    window.addEventListener('load', () => {
      setTimeout(() => {
        if (typeof googletag !== 'undefined' && googletag.cmd) {
          googletag.cmd.push(() => {
            googletag.display('ad_moldraw_sticky_footer');
            stickyWrap.classList.add('ad-visible');
          });
        }
        // Auto-collapse after 30s
        setTimeout(() => {
          if (stickyWrap && !stickyWrap.classList.contains('ad-dismissed')) {
            stickyWrap.classList.add('ad-dismissed');
          }
        }, 30000);
      }, delay);
    });

    if (stickyClose) {
      stickyClose.addEventListener('click', () => {
        stickyWrap.classList.add('ad-dismissed');
        localStorage.setItem('ad_moldraw_sticky_dismissed', 'true');
      });
    }
  }
})();

// ═══════════════════════════════════════════════════════
// BOOT
// ═══════════════════════════════════════════════════════
initApp();
</script>
<%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
