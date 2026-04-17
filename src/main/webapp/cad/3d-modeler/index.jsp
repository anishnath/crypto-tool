<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free 3D CAD Modeler with AI - JSCAD Parametric Design" />
        <jsp:param name="toolDescription" value="AI-powered 3D CAD modeler. Describe what you want, AI writes the code. Or write JSCAD JavaScript directly. Boolean CSG, 15+ primitives, parametric sliders, export STL/OBJ/DXF for 3D printing. Free, no signup." />
        <jsp:param name="toolCategory" value="CAD &amp; 3D Design" />
        <jsp:param name="toolUrl" value="cad/3d-modeler/" />
        <jsp:param name="breadcrumbCategoryUrl" value="cad/" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolKeywords" value="ai 3d cad, ai 3d modeler, ai cad design, jscad online, parametric 3d modeler, openscad alternative, browser 3d modeling, stl export, 3d printing design tool, csg boolean operations, javascript 3d modeling, free cad software, ai generate 3d model, text to 3d, ai stl generator" />
        <jsp:param name="toolFeatures" value="AI code generation - describe a model and AI writes JSCAD code,Parametric 3D modeling with JavaScript,15+ primitives: cube sphere cylinder torus polyhedron,Boolean CSG: union subtract intersect,Export STL OBJ DXF AMF for 3D printing,Auto-generated parameter sliders,Real-time 3D preview with orbit controls,AI error fixing - AI reads errors and generates fixes,Built-in examples with live editing,Powered by JSCAD MIT license,Free no signup" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Open the editor|Click the pencil icon in the toolbar to open the JSCAD code editor,Use AI or write code|Type a description in the AI bar (e.g. create a gear with 20 teeth) or write JSCAD code directly,Adjust parameters|Use the auto-generated sliders to tweak dimensions in real time,Export for 3D printing|Choose STL or OBJ format and click Export to download your model" />
        <jsp:param name="faq1q" value="How does the AI 3D model generator work?" />
        <jsp:param name="faq1a" value="Open the code editor, then type a description in the AI bar like 'create a gear with 20 teeth and a 5mm bore hole'. AI generates complete JSCAD JavaScript code with parametric sliders. The code streams into the editor in real time, then auto-runs to render your 3D model. You can follow up with modifications like 'add 4 mounting holes' or 'make it taller'." />
        <jsp:param name="faq2q" value="What is JSCAD?" />
        <jsp:param name="faq2a" value="JSCAD is an open-source JavaScript library for creating parametric 2D and 3D models using code. It uses Constructive Solid Geometry (CSG) to combine primitives like cubes, spheres, and cylinders with boolean operations (union, subtract, intersect). Models export to STL for 3D printing." />
        <jsp:param name="faq3q" value="Can I export models for 3D printing?" />
        <jsp:param name="faq3a" value="Yes. Export to STL (most common for 3D printers), OBJ, AMF, 3MF, and DXF (for CNC and laser cutting). All exports happen in your browser — no server upload, no account needed." />
        <jsp:param name="faq4q" value="Do I need to know JavaScript to use this?" />
        <jsp:param name="faq4a" value="No. Use the AI to generate code by describing what you want in plain English. AI writes the complete JSCAD script with parameter sliders. You can then tweak dimensions using sliders without touching the code. For advanced designs, knowing basic JavaScript helps." />
        <jsp:param name="faq5q" value="Can AI fix errors in my JSCAD code?" />
        <jsp:param name="faq5a" value="Yes. When your code has an error, the AI bar auto-suggests 'Fix this error'. Hit Enter and AI reads your code plus the error message, then generates a corrected version. It streams the fix into the editor and auto-runs it." />
        <jsp:param name="faq6q" value="Is this free?" />
        <jsp:param name="faq6a" value="Yes, completely free with no signup. Powered by JSCAD, an MIT-licensed open-source project. AI generation, 3D rendering, and file export all run in your browser." />
        <jsp:param name="faq7q" value="What 3D shapes can I create?" />
        <jsp:param name="faq7a" value="Any shape that can be built from primitives and boolean operations: gears, enclosures, phone stands, brackets, vases, mechanical parts, architectural models, and more. JSCAD supports cube, sphere, cylinder, torus, polygon extrusions, hulls, and polyhedra. Combine them with union, subtract, and intersect." />
    </jsp:include>

    <!-- JSCAD CSS -->
    <link rel="stylesheet" href="css/codemirror.css">
    <link rel="stylesheet" href="css/demo.css">

    <!-- Site CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ai-code-assistant.css">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    </noscript>

    <%@ include file="../../modern/ads/ad-init.jsp" %>

    <style>
        html, body { height: 100%; margin: 0; }

        /* ── Topbar: title + AI input + links ── */
        .cad-topbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 100;
            display: flex; align-items: center; gap: 0.75rem;
            padding: 0 0.75rem; height: 40px;
            background: #0f172a; border-bottom: 1px solid rgba(255,255,255,0.08);
            font-family: 'Inter', system-ui, sans-serif; font-size: 0.75rem;
        }
        h1.cad-topbar-title { font-weight: 700; color: #fff; font-size: 0.8125rem; white-space: nowrap; margin: 0; }
        .cad-topbar-bc { color: #475569; white-space: nowrap; }
        .cad-topbar-bc a { color: #64748b; text-decoration: none; }
        .cad-topbar-bc a:hover { color: #fff; }
        .cad-topbar-bc .sep { margin: 0 0.25rem; }

        /* AI input — integrated into the topbar */
        .cad-ai-wrap {
            flex: 1; display: flex; align-items: center; gap: 4px;
            max-width: 480px; margin: 0 auto;
        }
        .cad-ai-label {
            color: #818cf8; font-size: 0.625rem; font-weight: 600;
            white-space: nowrap; letter-spacing: 0.05em;
        }
        .cad-ai-input {
            flex: 1; padding: 4px 10px; background: #1e293b; color: #e2e8f0;
            border: 1px solid #334155; border-radius: 6px; font-size: 0.6875rem;
            font-family: inherit; outline: none;
        }
        .cad-ai-input:focus { border-color: #6366f1; }
        .cad-ai-input::placeholder { color: #475569; }
        .cad-ai-send {
            padding: 4px 8px; background: #6366f1; color: #fff; border: none;
            border-radius: 4px; font-size: 0.625rem; font-weight: 600; cursor: pointer;
        }
        .cad-ai-send:hover { background: #818cf8; }
        .cad-ai-send:disabled { opacity: 0.3; cursor: default; }

        .cad-topbar-right { display: flex; align-items: center; gap: 0.5rem; margin-left: auto; }
        .cad-topbar-badge {
            padding: 2px 8px; background: rgba(99,102,241,0.15); color: #a5b4fc;
            border-radius: 9999px; font-size: 0.5625rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.05em;
        }
        .cad-topbar-link { color: #64748b; text-decoration: none; font-size: 0.625rem; }
        .cad-topbar-link:hover { color: #fff; }

        /* AI status — slim bar below topbar, auto-hides */
        .cad-ai-status {
            position: fixed; top: 40px; left: 0; right: 0; z-index: 99;
            text-align: center; font-size: 0.6875rem; padding: 3px 0;
            font-family: 'Inter', system-ui, sans-serif;
            transform: translateY(-100%); transition: transform 0.2s;
        }
        .cad-ai-status.show { transform: translateY(0); }
        .cad-ai-status.loading { background: #1e293b; color: #818cf8; }
        .cad-ai-status.error { background: #451a1a; color: #f87171; }
        .cad-ai-status.success { background: #052e16; color: #34d399; }

        /* ── Content flows under fixed topbar ── */
        .cad-content {
            padding-top: 40px; /* clear the fixed topbar */
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ── Hero ad strip ── */
        .cad-ad-hero {
            background: #0f172a; border-bottom: 1px solid rgba(255,255,255,0.06);
            display: flex; align-items: center; justify-content: center;
            min-height: 50px; padding: 4px 0;
            flex-shrink: 0;
        }

        /* ── JSCAD fills remaining space ── */
        #jscad {
            flex: 1;
            position: relative;
            min-height: 0;
        }

        /* ── JSCAD UI overrides ── */
        .jscad { font-family: 'Inter', system-ui, sans-serif !important; }
        /* ── JSCAD header bar ── */
        /* ── JSCAD's header/controls/toolbar all live inside #jscad (position:relative) ── */
        /* They use position:absolute internally — that's fine, they stay within #jscad */
        #header, #controls {
            background: rgba(15,23,42,0.8) !important;
            backdrop-filter: blur(10px) !important;
            -webkit-backdrop-filter: blur(10px) !important;
            color: #cbd5e1 !important;
            font-size: 0.6875rem !important;
            border-radius: 0 0 8px 0 !important;
        }
        #header {
            padding: 4px 10px !important;
            display: inline-flex !important; align-items: center !important; gap: 6px !important;
        }
        #controls {
            padding: 4px 10px !important;
            display: flex !important; gap: 12px !important;
        }
        #designName { font-size: 0.6875rem !important; color: #94a3b8 !important; }
        #io { margin: 0 5px !important; }
        #header select, #exportFormats {
            background: rgba(15,23,42,0.9); color: #e2e8f0; border: 1px solid #475569;
            border-radius: 4px; padding: 3px 6px; font-size: 0.6875rem; opacity: 1 !important;
        }
        #controls label {
            display: inline-flex !important; align-items: center !important; gap: 3px !important;
            white-space: nowrap !important;
        }

        /* ── Toolbar icons (top right) — styled in-place ── */
        #toolbar { top: 4px !important; right: 8px !important; }
        .jscad button, #toolbar button, #header button, #io button {
            background: #334155 !important; color: #e2e8f0 !important;
            border: 1px solid #475569 !important; border-radius: 4px !important;
            opacity: 1 !important; font-size: 0.6875rem !important;
            padding: 3px 8px !important; box-shadow: none !important;
            font-family: inherit !important;
        }
        .jscad button:hover, #toolbar button:hover, #header button:hover {
            background: #475569 !important; border-color: #6366f1 !important; color: #fff !important;
        }
        #fileLoader + label {
            background: #334155 !important; color: #e2e8f0 !important;
            border: 1px solid #475569 !important; border-radius: 4px !important;
            opacity: 1 !important; padding: 3px 8px !important; font-size: 0.6875rem !important;
        }
        #fileLoader + label:hover { background: #475569 !important; border-color: #6366f1 !important; }
        #editor {
            background: #0f172a !important; border: none !important; box-shadow: none !important;
            border-right: 1px solid rgba(255,255,255,0.06) !important; padding: 0 !important;
        }
        .CodeMirror {
            background: #0f172a !important; color: #e2e8f0 !important;
            font-family: 'JetBrains Mono', monospace !important; font-size: 12px !important;
        }
        .CodeMirror-gutters { background: #1e293b !important; border-right: 1px solid #334155 !important; }
        .CodeMirror-linenumber { color: #475569 !important; }
        .CodeMirror-cursor { border-left-color: #6366f1 !important; }
        .CodeMirror-selected { background: rgba(99,102,241,0.2) !important; }
        .cm-s-default .cm-keyword { color: #c084fc !important; }
        .cm-s-default .cm-string { color: #34d399 !important; }
        .cm-s-default .cm-number { color: #f59e0b !important; }
        .cm-s-default .cm-comment { color: #64748b !important; }
        .cm-s-default .cm-def { color: #60a5fa !important; }
        .cm-s-default .cm-variable { color: #e2e8f0 !important; }
        .cm-s-default .cm-property { color: #93c5fd !important; }
        .cm-s-default .cm-operator { color: #94a3b8 !important; }
        section#params {
            background: rgba(15,23,42,0.92) !important; backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.08) !important; border-radius: 8px !important;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3) !important; color: #e2e8f0 !important; padding: 8px !important;
            max-width: 320px;
        }
        #paramsTable td { color: #e2e8f0 !important; }
        #paramsTable td.caption { color: #94a3b8 !important; font-weight: 500 !important; font-size: 0.75rem !important; }
        #paramsTable input[type="range"] { accent-color: #6366f1; }
        #paramsTable input[type="number"], #paramsTable input[type="text"], #paramsTable select {
            background: #1e293b !important; color: #e2e8f0 !important;
            border: 1px solid #334155 !important; border-radius: 4px !important;
            padding: 3px 6px !important; font-size: 0.75rem !important;
        }
        #paramsTable input[type="checkbox"], #controls input[type="checkbox"],
        .jscad input[type="checkbox"], #options input[type="checkbox"] {
            accent-color: #6366f1; opacity: 1 !important; width: 16px; height: 16px;
            cursor: pointer; filter: brightness(1.5);
        }
        span#paramsControls input[type="button"] {
            background: #334155 !important; color: #e2e8f0 !important;
            border: 1px solid #475569 !important; border-radius: 4px !important;
            opacity: 1 !important; font-size: 0.6875rem !important; padding: 4px 10px !important;
        }
        span#paramsControls input[type="button"]:hover { background: #6366f1 !important; border-color: #6366f1 !important; }
        section.popup-menu, #help, #options, #shortcuts {
            background: rgba(15,23,42,0.95) !important; backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.08) !important; border-radius: 8px !important;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3) !important; color: #e2e8f0 !important;
        }
        section.popup-menu h2, section.popup-menu h3 { color: #94a3b8 !important; }
        section.popup-menu a, #help a { color: #818cf8 !important; }
        #controls { color: #94a3b8 !important; }
        #toolbar { top: 4px !important; right: 8px !important; }
        #status {
            color: #f87171 !important; font-family: 'JetBrains Mono', monospace !important;
            font-size: 0.75rem !important;
            top: auto !important; bottom: 10px !important; left: 10px !important;
            right: auto !important; max-width: 50% !important;
            z-index: 50 !important;
            background: rgba(15,23,42,0.95) !important; padding: 10px 14px !important;
            border: 1px solid rgba(248,113,113,0.3) !important; border-radius: 6px !important;
            max-height: 25vh !important; overflow-y: auto !important;
            box-shadow: 0 4px 16px rgba(0,0,0,0.3) !important;
        }
        #status:empty { display: none !important; }
        #busy {
            color: #94a3b8 !important;
            position: absolute !important; bottom: 10px !important; left: 10px !important;
            top: auto !important;
        }
        #renderTarget { background: #111827 !important; }
        .renderHotkeyHelp { color: #475569 !important; font-size: 0.625rem !important; }
        #paramsTable .groupTitle { border-top-color: #334155 !important; background: linear-gradient(180deg, rgba(255,255,255,0.03), transparent) !important; }
        #paramsTable .groupTitle:hover { background: rgba(99,102,241,0.1) !important; }
        #jscadName { display: none !important; }

        @media (max-width: 640px) {
            .cad-ai-wrap { max-width: 200px; }
            .cad-topbar-bc, .cad-topbar-badge { display: none; }
        }
    </style>
</head>
<body>

    <!-- Topbar: title + AI command bar + links -->
    <div class="cad-topbar">
        <h1 class="cad-topbar-title">3D CAD</h1>
        <nav class="cad-topbar-bc" aria-label="Breadcrumb">
            <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
            <span class="sep">/</span>
            <a href="<%=request.getContextPath()%>/cad/">CAD</a>
        </nav>

        <!-- AI command bar — only shown when editor is open -->
        <div class="cad-ai-wrap" id="cad-ai-wrap" style="display:none;">
            <span class="cad-ai-label">AI</span>
            <input type="text" class="cad-ai-input" id="cad-ai-input"
                   placeholder="Create a gear... / Add holes... / Fix error..."
                   autocomplete="off" />
            <button class="cad-ai-send" id="cad-ai-send" disabled>Go</button>
        </div>

        <div class="cad-topbar-right">
            <span class="cad-topbar-badge">JSCAD</span>
            <a href="<%=request.getContextPath()%>/cad/" class="cad-topbar-link">All CAD</a>
            <a href="<%=request.getContextPath()%>/index.jsp" class="cad-topbar-link">8gwifi</a>
        </div>
    </div>

    <!-- AI status bar (slides in below topbar) -->
    <div class="cad-ai-status" id="cad-ai-status"></div>

    <!-- Content flows: ad → jscad (no overlapping) -->
    <div class="cad-content">
        <!-- Hero ad strip -->
        <div class="cad-ad-hero">
            <jsp:include page="/modern/ads/ad-hero-banner.jsp" />
        </div>

        <!-- JSCAD (fills remaining height) -->
        <div id="jscad"></div>
    </div>

    <script src="dist/jscad-web.min.js"></script>
    <script>
        // Init JSCAD
        jscadWeb(document.getElementById('jscad'), { name: 'jscad1' });

        // Restore AI-generated code after stuck-state reload
        var pendingCode = sessionStorage.getItem('jscad_ai_code');
        if (pendingCode) {
            sessionStorage.removeItem('jscad_ai_code');
            // Wait for JSCAD + editor to initialize, then inject
            setTimeout(function () {
                // Open editor first — find and click the editor toggle
                var toolbarBtns = document.querySelectorAll('#toolbar button');
                for (var b = 0; b < toolbarBtns.length; b++) {
                    var svg = toolbarBtns[b].querySelector('svg');
                    if (svg) { toolbarBtns[b].click(); break; }
                }
                // Wait for CodeMirror then inject
                setTimeout(function () {
                    var ed = document.querySelector('#editor');
                    var cmEl = ed ? ed.querySelector('.CodeMirror') : document.querySelector('.CodeMirror');
                    var cmInst = cmEl ? cmEl.CodeMirror : null;
                    if (cmInst) {
                        cmInst.setValue(pendingCode);
                        cmInst.refresh();
                        setTimeout(function () {
                            cmInst.triggerOnKeyDown({
                                type: 'keydown', keyCode: 13, shiftKey: true,
                                preventDefault: function(){}, stopPropagation: function(){}
                            });
                        }, 500);
                    }
                }, 1000);
            }, 2000);
        }

        // Watch for editor open/close → show/hide AI bar
        // Watch for errors → suggest fix in AI bar
        var aiWrap = document.getElementById('cad-ai-wrap');
        var aiInput = document.getElementById('cad-ai-input');
        var aiSend = document.getElementById('cad-ai-send');
        var jscadRoot = document.getElementById('jscad');
        var lastSeenError = '';

        if (jscadRoot && aiWrap) {
            new MutationObserver(function () {
                // Show/hide AI bar based on editor state
                var edSec = document.querySelector('#editor');
                var isOpen = edSec && edSec.style.visibility !== 'hidden' && edSec.offsetParent !== null;
                aiWrap.style.display = isOpen ? 'flex' : 'none';

                // Detect errors in #status and suggest fix
                var statusEl = document.querySelector('#status');
                var errText = statusEl ? statusEl.textContent.trim() : '';
                if (errText && errText !== lastSeenError && isOpen) {
                    lastSeenError = errText;
                    // Auto-populate AI input with fix suggestion
                    if (aiInput && !aiInput.value.trim()) {
                        aiInput.value = 'Fix this error';
                        aiInput.style.borderColor = '#f87171';
                        aiSend.disabled = false;
                        setTimeout(function () { aiInput.style.borderColor = ''; }, 3000);
                    }
                } else if (!errText) {
                    lastSeenError = '';
                }
            }).observe(jscadRoot, { childList: true, subtree: true, attributes: true, attributeFilter: ['style'] });
        }

        // ── AI Command Bar ──
        (function () {
            var input = document.getElementById('cad-ai-input');
            var sendBtn = document.getElementById('cad-ai-send');
            var statusBar = document.getElementById('cad-ai-status');
            var busy = false;

            var ctxMeta = document.querySelector('meta[name="ctx"]');
            var aiUrl = (ctxMeta ? ctxMeta.getAttribute('content') : '') + '/ai';

            var SYSTEM_PROMPT =
                'You are an expert JSCAD programmer. Generate or modify complete JSCAD code.\n\n' +
                'OUTPUT FORMAT — CRITICAL:\n' +
                '- Return ONLY pure JavaScript code. Nothing else.\n' +
                '- Do NOT wrap in markdown code fences (no ``` at all).\n' +
                '- Do NOT start with the word "javascript" or "js" or any language tag.\n' +
                '- The FIRST line must be a const/require/comment — valid JS.\n' +
                '- Do NOT include any explanation, description, or text outside the code.\n\n' +
                'JSCAD API REFERENCE:\n\n' +
                'IMPORTS:\n' +
                '  const jscad = require("@jscad/modeling")\n' +
                '  const { cube, cuboid, sphere, cylinder, roundedCuboid, roundedCylinder, torus, polygon, circle, rectangle } = jscad.primitives\n' +
                '  const { union, subtract, intersect } = jscad.booleans\n' +
                '  const { translate, translateX, translateY, translateZ, rotate, rotateX, rotateY, rotateZ, scale, mirror, center } = jscad.transforms\n' +
                '  const { extrudeLinear, extrudeRotate } = jscad.extrusions\n' +
                '  const { colorize } = jscad.colors\n' +
                '  const { degToRad } = jscad.utils\n\n' +
                'PRIMITIVES: cube({size}) cuboid({size:[w,d,h]}) roundedCuboid({size,roundRadius,segments})\n' +
                '  sphere({radius,segments}) cylinder({radius,height,segments}) torus({innerRadius,outerRadius})\n' +
                '  All accept optional center:[x,y,z]\n\n' +
                'TRANSFORMS (params, geometry): translate([x,y,z],s) rotate([rx,ry,rz],s) — angles in RADIANS\n' +
                'BOOLEANS (variadic, NOT arrays): union(a,b,c) subtract(base,hole) intersect(a,b)\n' +
                'EXTRUSIONS: extrudeLinear({height,twistAngle,twistSteps},geom2d) extrudeRotate({angle,segments},geom2d)\n' +
                'COLORS: colorize([r,g,b],shape) — values 0.0 to 1.0\n\n' +
                'PARAMETERS:\n' +
                '  const getParameterDefinitions = () => [\n' +
                '    {name:"width",type:"float",initial:10,min:1,max:100,step:1,caption:"Width (mm):"},\n' +
                '    {name:"count",type:"int",initial:6,min:3,max:60,caption:"Count:"},\n' +
                '    {name:"showLid",type:"checkbox",checked:true,caption:"Show lid"},\n' +
                '    {name:"style",type:"choice",values:["round","square"],captions:["Round","Square"],initial:"round",caption:"Style:"}\n' +
                '  ]\n\n' +
                'REQUIRED STRUCTURE:\n' +
                '  const main = (params) => { ... return shapeOrArray }\n' +
                '  module.exports = { main, getParameterDefinitions }\n\n' +
                'RULES:\n' +
                '- Units are millimeters.\n' +
                '- ALWAYS include getParameterDefinitions() with sensible defaults.\n' +
                '- Use colorize() for visual appeal.\n' +
                '- If modifying existing code, preserve the overall structure.\n' +
                '- REMEMBER: output is raw JS executed directly. Any non-JS text will cause SyntaxError.\n';

            input.addEventListener('input', function () { sendBtn.disabled = !input.value.trim(); });
            input.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' && !sendBtn.disabled && !busy) { e.preventDefault(); doGenerate(); }
            });
            sendBtn.addEventListener('click', function () { if (!busy) doGenerate(); });

            function showStatus(cls, text) {
                statusBar.className = 'cad-ai-status ' + cls + ' show';
                statusBar.textContent = text;
            }
            function hideStatus() {
                statusBar.classList.remove('show');
            }

            function getCM() {
                var ed = document.querySelector('#editor');
                var cm = ed ? ed.querySelector('.CodeMirror') : document.querySelector('.CodeMirror');
                return cm ? cm.CodeMirror : null;
            }

            function doGenerate() {
                var text = input.value.trim();
                if (!text || busy) return;
                busy = true;
                sendBtn.disabled = true;
                showStatus('loading', 'AI is writing code\u2026');

                // Get current code for context (if editor is open)
                var currentCode = '';
                var cm = getCM();
                if (cm) currentCode = cm.getValue() || '';

                var messages = [{ role: 'system', content: SYSTEM_PROMPT }];
                if (currentCode.trim()) {
                    messages.push({ role: 'user', content: 'Current code:\n```\n' + currentCode + '\n```' });
                    messages.push({ role: 'assistant', content: 'I see the code. What change do you need?' });
                }

                // Include JSCAD errors if user mentions fix/error
                var errEl = document.querySelector('#status');
                var errText = errEl ? errEl.textContent.trim() : '';
                var prompt = text;
                if (errText && /fix|error|bug|wrong/i.test(text)) {
                    prompt += '\n\nCurrent error: ' + errText;
                }
                messages.push({ role: 'user', content: prompt });

                var cm = getCM();
                var rawStream = '';
                var inThinkBlock = false;
                var codeStarted = false;  // true once first real code token arrives

                // Don't touch the editor yet — show "thinking" in status bar
                showStatus('loading', '\u2728 AI is thinking\u2026');

                fetch(aiUrl, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ messages: messages, stream: true })
                })
                .then(function (res) {
                    if (!res.ok) return res.json().then(function (d) { throw new Error(d.error || 'AI failed'); });

                    var reader = res.body.getReader();
                    var decoder = new TextDecoder();
                    var buffer = '';

                    function processChunk(result) {
                        if (result.done) { finish(); return; }
                        buffer += decoder.decode(result.value, { stream: true });
                        var lines = buffer.split('\n');
                        buffer = lines.pop();

                        for (var i = 0; i < lines.length; i++) {
                            var line = lines[i].trim();
                            if (!line) continue;
                            try {
                                var obj = JSON.parse(line);
                                if (obj.message && obj.message.content) {
                                    var token = obj.message.content;
                                    rawStream += token;

                                    // Skip <think> blocks (model is reasoning)
                                    if (token.indexOf('<think>') !== -1) inThinkBlock = true;
                                    if (inThinkBlock) {
                                        if (token.indexOf('</think>') !== -1) inThinkBlock = false;
                                        showStatus('loading', '\u2728 AI is thinking\u2026');
                                        continue;
                                    }

                                    // Skip markdown fences and bare language tags
                                    var trimmed = token.trim();
                                    if (/^```/.test(trimmed)) continue;
                                    if (!codeStarted && /^(?:javascript|js|jscad)$/i.test(trimmed)) continue;

                                    // First real code token — clear editor and start writing
                                    if (!codeStarted && cm) {
                                        codeStarted = true;
                                        cm.setValue('');
                                        cm.setOption('readOnly', true);
                                        showStatus('loading', '\u270d Writing code\u2026');
                                    }

                                    // Append token to editor
                                    if (cm && codeStarted) {
                                        var lastLine = cm.lastLine();
                                        var lastCh = cm.getLine(lastLine).length;
                                        cm.replaceRange(token, { line: lastLine, ch: lastCh });
                                        cm.scrollIntoView({ line: cm.lastLine(), ch: 0 });
                                    }
                                }
                                if (obj.done === true) { finish(); return; }
                            } catch (e) {}
                        }
                        return reader.read().then(processChunk);
                    }
                    return reader.read().then(processChunk);
                })
                .catch(function (err) {
                    if (cm) cm.setOption('readOnly', false);
                    showStatus('error', err.message);
                    setTimeout(hideStatus, 5000);
                    busy = false;
                    sendBtn.disabled = false;
                });

                function finish() {
                    if (cm) {
                        cm.setOption('readOnly', false);

                        // Clean up markdown fences, language tags, and think blocks
                        var finalCode = cm.getValue();
                        // Remove ```javascript ... ``` wrappers
                        finalCode = finalCode.replace(/^```(?:javascript|js|jscad)?\s*\n?/gm, '');
                        finalCode = finalCode.replace(/```\s*$/gm, '');
                        // Remove bare "javascript" or "js" on the very first line
                        finalCode = finalCode.replace(/^(?:javascript|js|jscad)\s*\n/, '');
                        // Remove any remaining think blocks
                        finalCode = finalCode.replace(/<think>[\s\S]*?<\/think>/g, '');
                        finalCode = finalCode.trim();
                        if (finalCode !== cm.getValue().trim()) {
                            cm.setValue(finalCode);
                        }
                        cm.refresh();

                        // Check if JSCAD is stuck in "processing" (known bug after first error)
                        var busyEl = document.querySelector('#busy');
                        var isStuck = busyEl && busyEl.textContent.indexOf('processing') !== -1;

                        if (isStuck) {
                            // Force reload JSCAD by re-initializing with the new code via page reload
                            // Store code in sessionStorage, reload, and restore
                            sessionStorage.setItem('jscad_ai_code', finalCode);
                            window.location.hash = '';
                            window.location.reload();
                            return;
                        }

                        // Run the code (Shift+Enter)
                        setTimeout(function () {
                            cm.triggerOnKeyDown({
                                type: 'keydown', keyCode: 13, shiftKey: true,
                                preventDefault: function(){}, stopPropagation: function(){}
                            });
                        }, 300);
                    }

                    showStatus('success', 'Done! Rendering 3D model\u2026');
                    setTimeout(hideStatus, 3000);
                    busy = false;
                    sendBtn.disabled = false;
                    input.value = '';
                    input.focus();
                }
            }
        })();
    </script>

    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
    <%@ include file="../../modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
