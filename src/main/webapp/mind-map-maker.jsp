<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mind Map Maker – Online Mind Mapping Tool (Free MindMeister Alternative)</title>
    <meta name="description" content="Create mind maps online with drag-and-drop nodes, branch connections, and color-coded themes. Export your mind map as PNG or PDF. Great for brainstorming, essay planning, and project ideas.">
    <meta name="keywords" content="mind map maker, online mind mapping, free mindmeister alternative, mind map online, brainstorming tool, essay planner, drag and drop mind map, visual mapping">

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Mind Map Maker",
      "applicationCategory": "ProductivityApplication",
      "description": "Online mind mapping with drag-drop nodes, branch connections, themes, and PNG/PDF export.",
      "url": "https://8gwifi.org/mind-map-maker.jsp",
      "author": {
        "@type": "Person",
        "name": "Anish Nath"
      },
      "datePublished": "2025-10-26"
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <!-- Open-source JS libraries (CDN) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jsmind@0.5.7/style/jsmind.css">
    <style>
        /* Page-specific styling to keep visuals clean and appealing */
        .toolbar .btn { margin-right: .35rem; margin-bottom: .35rem; }
        #jsmind_container {
            height: 70vh;
            min-height: 520px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            background: linear-gradient(180deg, #fafafa 0%, #ffffff 100%);
            box-shadow: inset 0 0 0 1px #fafafa;
            overflow: visible;
        }
        /* Keep controls accessible while scrolling */
        .sticky-toolbar-card { position: sticky; top: 64px; z-index: 1030; }
        .sticky-toolbar-card .card-header, .sticky-toolbar-card .card-body { background: #fff; }
        .hint { font-size: 0.9rem; color: #666; }
        .badge-dot { width:12px; height:12px; border-radius:50%; display:inline-block; margin-right:6px; border:1px solid rgba(0,0,0,.1); }
        .theme-chip { cursor:pointer; padding:6px 10px; border:1px solid #e5e7eb; border-radius:6px; margin-right:8px; margin-bottom:8px; display:inline-flex; align-items:center; }
        .theme-chip.active { border-color:#6366f1; box-shadow:0 0 0 2px rgba(99,102,241,.15); }
    </style>
</head>
<%@ include file="body-script.jsp"%>

    <h1 class="mb-2">Mind Map Maker</h1>
    <p class="mb-4">Online mind mapping for brainstorming, essays, and planning. Drag and drop nodes, connect branches, choose color themes, and export your map as PNG or PDF — a fast, free MindMeister alternative.</p>

    <!-- Controls -->
    <div class="card mb-3 sticky-toolbar-card">
        <div class="card-header">Build & Style</div>
        <div class="card-body toolbar">
            <div class="d-flex flex-wrap align-items-center">
                <div class="btn-group mr-2 mb-2" role="group" aria-label="Edit">
                    <button id="btn-new" class="btn btn-sm btn-secondary">New Map</button>
                    <button id="btn-add-child" class="btn btn-sm btn-primary">Add Child</button>
                    <button id="btn-add-sibling" class="btn btn-sm btn-primary">Add Sibling</button>
                    <button id="btn-edit" class="btn btn-sm btn-info">Edit Text</button>
                    <button id="btn-delete" class="btn btn-sm btn-danger">Delete</button>
                </div>

                <div class="btn-group mr-2 mb-2" role="group" aria-label="View">
                    <button id="btn-expand" class="btn btn-sm btn-outline-secondary">Expand All</button>
                    <button id="btn-collapse" class="btn btn-sm btn-outline-secondary">Collapse All</button>
                    <button id="btn-center" class="btn btn-sm btn-outline-secondary">Center</button>
                </div>

                <div class="btn-group mr-2 mb-2" role="group" aria-label="Zoom">
                    <button id="btn-zoom-out" class="btn btn-sm btn-outline-secondary">−</button>
                    <button id="btn-zoom-in" class="btn btn-sm btn-outline-secondary">+</button>
                    <button id="btn-fit" class="btn btn-sm btn-outline-secondary">Fit</button>
                    <button id="btn-reset" class="btn btn-sm btn-outline-secondary">Reset</button>
                </div>

                <div class="btn-group mr-2 mb-2" role="group" aria-label="Export">
                    <button id="btn-export-png" class="btn btn-sm btn-success">Export PNG</button>
                    <button id="btn-export-svg" class="btn btn-sm btn-success">Export SVG</button>
                    <button id="btn-export-pdf" class="btn btn-sm btn-success">Export PDF</button>
                    <button id="btn-export-json" class="btn btn-sm btn-outline-success">Export JSON</button>
                    <label class="btn btn-sm btn-outline-primary mb-0">
                        Import JSON <input type="file" id="import-json" accept="application/json" style="display:none;">
                    </label>
                </div>

                <div class="btn-group mr-2 mb-2" role="group" aria-label="History">
                    <button id="btn-undo" class="btn btn-sm btn-outline-dark">Undo</button>
                    <button id="btn-redo" class="btn btn-sm btn-outline-dark">Redo</button>
                </div>

                <div class="ml-auto d-flex align-items-center mb-2">
                    <input id="save-name" type="text" class="form-control form-control-sm mr-2" placeholder="Map name (e.g., Brainstorm)" style="width:220px;">
                    <button id="btn-save" class="btn btn-sm btn-outline-dark mr-2">Save</button>
                    <button id="btn-load" class="btn btn-sm btn-outline-dark">Load</button>
                    <div class="form-check ml-2">
                        <input class="form-check-input" type="checkbox" id="autosave-toggle" checked>
                        <label class="form-check-label" for="autosave-toggle">Autosave</label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Mind map canvas -->
    <div id="jsmind_container" class="mb-3"></div>

    <!-- Context menu -->
    <div id="ctx-menu" style="position:absolute; display:none; z-index:2000; min-width:180px; background:#fff; border:1px solid #ddd; border-radius:6px; box-shadow:0 6px 24px rgba(0,0,0,.12);">
        <div class="list-group list-group-flush">
            <button class="list-group-item list-group-item-action" data-act="add-child">Add Child</button>
            <button class="list-group-item list-group-item-action" data-act="add-sibling">Add Sibling</button>
            <button class="list-group-item list-group-item-action" data-act="edit">Edit</button>
            <button class="list-group-item list-group-item-action text-danger" data-act="delete">Delete</button>
            <div class="dropdown-divider"></div>
            <button class="list-group-item list-group-item-action" data-act="expand">Expand Node</button>
            <button class="list-group-item list-group-item-action" data-act="collapse">Collapse Node</button>
            <button class="list-group-item list-group-item-action" data-act="center">Center on Node</button>
        </div>
    </div>

    <div class="hint mb-4">Use mouse or touch to drag nodes. Double-click a node to edit text. Keyboard: Enter = sibling, Tab = child, Delete = remove.</div>

    <!-- Themes -->
    <div class="card mb-3">
        <div class="card-header">Theme & Colors</div>
        <div class="card-body">
            <div id="theme-list" class="d-flex flex-wrap"></div>
            <div class="hint mt-2">Tip: Pick a theme to color-code branches for clarity (essays: topics/arguments/sources; projects: epics/tasks/dependencies).</div>
        </div>
    </div>

    <!-- Templates -->
    <div class="card mb-3">
        <div class="card-header">Templates</div>
        <div class="card-body">
            <div id="template-list" class="d-flex flex-wrap"></div>
            <div class="hint mt-2">Click a template to start quickly. It replaces the current map.</div>
        </div>
    </div>

    <!-- Saved maps -->
    <div class="card mb-3">
        <div class="card-header">Saved Maps (Local)</div>
        <div class="card-body p-0">
            <ul id="saved-list" class="list-group list-group-flush" style="max-height: 240px; overflow-y: auto;"></ul>
        </div>
        <div class="px-3 pb-3"><small class="text-muted">Double-click a saved name to open. Single-click selects the name.</small></div>
    </div>

    <!-- About and How To (SEO-friendly content) -->
    <section class="mb-4" id="about-mind-map-maker">
        <h2 class="h4 mb-3">Mind Map Maker: Online Mind Mapping (Free MindMeister Alternative)</h2>
        <p>
            This free mind map maker lets you organize ideas visually with fast, online mind mapping.
            Drag and drop nodes, connect branches, color-code themes, and export to PNG, PDF, SVG, or JSON.
            Perfect for brainstorming, essay planning, project roadmaps, meetings, and study notes.
        </p>

        <h3 class="h5 mt-4">How to Use</h3>
        <ol class="mb-3">
            <li>Click <strong>New Map</strong> or start from the central topic.</li>
            <li>Use <strong>Add Child</strong> and <strong>Add Sibling</strong> (or press <strong>Tab</strong> and <strong>Enter</strong>).</li>
            <li><strong>Drag and drop</strong> nodes to rearrange; right‑click a node for quick actions.</li>
            <li><strong>Zoom/Pan:</strong> +/− to zoom, <strong>Space+drag</strong> to pan, <strong>Fit</strong> and <strong>Reset</strong> to reframe.</li>
            <li>Pick a <strong>Theme</strong> to color‑code branches for clarity.</li>
            <li><strong>Save</strong> and <strong>Load</strong> maps locally; manage from the Saved Maps list.</li>
            <li><strong>Export</strong> as <strong>PNG</strong>, <strong>PDF</strong>, <strong>SVG</strong>, or <strong>JSON</strong> for sharing or backup.</li>
        </ol>

        <h3 class="h5 mt-4">Tips & Templates</h3>
        <ul class="mb-3">
            <li><strong>Brainstorming:</strong> center = goal; first level = themes; next = ideas.</li>
            <li><strong>Essays:</strong> center = thesis; branches = arguments; leaves = evidence/sources.</li>
            <li><strong>Projects:</strong> center = project; branches = epics; leaves = tasks/dependencies.</li>
            <li><strong>Frameworks:</strong> SWOT, 5W1H, OKRs — use different colors per category.</li>
        </ul>

        <h3 class="h5 mt-4">Keyboard Shortcuts</h3>
        <p class="mb-2">
            <strong>Enter</strong> = add sibling, <strong>Tab</strong> = add child, <strong>Delete</strong> = remove,
            <strong>Ctrl/Cmd+Z</strong> = undo, <strong>Ctrl/Cmd+Shift+Z</strong> or <strong>Ctrl/Cmd+Y</strong> = redo,
            <strong>Space+drag</strong> = pan.
        </p>

        <h3 class="h5 mt-4">FAQ</h3>
        <p><strong>Is this mind map maker free?</strong> Yes — it runs in your browser and uses open‑source libraries.</p>
        <p><strong>Where are my maps stored?</strong> On this device via local storage. You can also export JSON/PNG/PDF/SVG.</p>
        <p><strong>Do I need an account?</strong> No sign‑in needed. Just save locally or export files.</p>

        <h3 class="h5 mt-4">Why choose this tool?</h3>
        <ul>
            <li><strong>Fast, simple, and private:</strong> no account required, data stays local.</li>
            <li><strong>Works anywhere:</strong> modern browsers, no installation needed.</li>
            <li><strong>Flexible export:</strong> PNG, PDF, SVG, and JSON for reuse.</li>
        </ul>
    </section>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "Is this mind map maker free?",
          "acceptedAnswer": {"@type": "Answer", "text": "Yes. It runs in your browser and uses open‑source libraries; no sign‑in is required."}
        },
        {
          "@type": "Question",
          "name": "Where are my maps stored?",
          "acceptedAnswer": {"@type": "Answer", "text": "Your maps are saved locally on this device via browser storage. You can export PNG, PDF, SVG, or JSON for backups and sharing."}
        },
        {
          "@type": "Question",
          "name": "How do I export or share a mind map?",
          "acceptedAnswer": {"@type": "Answer", "text": "Use the Export buttons to download PNG/PDF/SVG for documents or JSON to re‑open later on this site."}
        }
      ]
    }
    </script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>
    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/jsmind@0.5.7/es6/jsmind.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jsmind@0.5.7/es6/jsmind.draggable.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jsmind@0.5.7/es6/jsmind.screenshot.js"></script>
<script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
<script>
    // Initialize jsMind
    var jm = null;
    var initialData = {
        meta: { name: 'Mind Map' },
        format: 'node_array',
        data: [ { id: 'root', isroot: true, topic: 'Central Topic' } ]
    };

    function initMind(theme) {
        var options = {
            container: 'jsmind_container',
            theme: theme || 'primary',
            editable: true
        };
        jm = new jsMind(options);
        jm.show(initialData);
        jm.expand_all();
        captureSnapshot('init');
    }

    function uid() { return 'n' + Math.random().toString(36).substr(2, 9); }

    function getSelectedNode() { return jm ? jm.get_selected_node() : null; }

    // Zoom/Pan state
    var zoomScale = 1.0, transX = 0, transY = 0;
    function innerEl(){
        var c = document.getElementById('jsmind_container');
        return c.firstElementChild || c;
    }
    function applyTransform(){
        var el = innerEl();
        el.style.transformOrigin = '0 0';
        el.style.transform = 'translate(' + transX + 'px,' + transY + 'px) scale(' + zoomScale + ')';
    }
    function setZoom(delta){ zoomScale = Math.max(0.2, Math.min(3, zoomScale + delta)); applyTransform(); }
    function resetView(){ zoomScale = 1.0; transX = 0; transY = 0; applyTransform(); jm.center_root(); }
    function fitView(){
        var c = document.getElementById('jsmind_container');
        var b = computeContentBounds(c);
        if (!b.width || !b.height) return resetView();
        var scaleX = (c.clientWidth - 40) / b.width;
        var scaleY = (c.clientHeight - 40) / b.height;
        zoomScale = Math.max(0.2, Math.min(3, Math.min(scaleX, scaleY)));
        transX = 20; transY = 20; // small margin
        applyTransform();
    }

    // Pan with Space-drag or Middle-click drag
    var isPanning = false, panStart = {x:0,y:0}, transStart = {x:0,y:0}, spaceDown = false;
    document.addEventListener('keydown', function(e){ if (e.code === 'Space') spaceDown = true; });
    document.addEventListener('keyup', function(e){ if (e.code === 'Space') spaceDown = false; });
    document.getElementById('jsmind_container').addEventListener('mousedown', function(e){
        if (e.button === 1 || spaceDown) {
            isPanning = true; panStart = {x:e.clientX, y:e.clientY}; transStart = {x:transX, y:transY};
            e.preventDefault();
        }
    });
    document.addEventListener('mousemove', function(e){
        if (!isPanning) return;
        transX = transStart.x + (e.clientX - panStart.x);
        transY = transStart.y + (e.clientY - panStart.y);
        applyTransform();
    });
    document.addEventListener('mouseup', function(){ isPanning = false; });

    // Toolbar actions
    document.getElementById('btn-new').addEventListener('click', function() {
        initialData = { meta: { name: 'Mind Map' }, format: 'node_array', data: [ { id: 'root', isroot: true, topic: 'Central Topic' } ] };
        jm.show(initialData);
        jm.expand_all();
    });

    document.getElementById('btn-add-child').addEventListener('click', function() {
        var node = getSelectedNode() || jm.get_root();
        jm.add_node(node, uid(), 'New Idea');
        scheduleSnapshot();
    });

    document.getElementById('btn-add-sibling').addEventListener('click', function() {
        var node = getSelectedNode();
        if (!node) { node = jm.get_root(); jm.add_node(node, uid(), 'New Idea'); scheduleSnapshot(); return; }
        var parent = node.parent || jm.get_root();
        jm.add_node(parent, uid(), 'New Idea'); scheduleSnapshot();
    });

    document.getElementById('btn-edit').addEventListener('click', function() {
        var node = getSelectedNode();
        if (!node) return;
        var text = prompt('Edit node text', node.topic || '');
        if (text !== null) { jm.update_node(node.id, text); scheduleSnapshot(); }
    });

    document.getElementById('btn-delete').addEventListener('click', function() {
        var node = getSelectedNode();
        if (!node || node.isroot) return;
        jm.remove_node(node.id); scheduleSnapshot();
    });

    document.getElementById('btn-expand').addEventListener('click', function(){ jm.expand_all(); });
    document.getElementById('btn-collapse').addEventListener('click', function(){ jm.collapse_all(); });
    document.getElementById('btn-center').addEventListener('click', function(){ jm.center_root(); });
    document.getElementById('btn-zoom-in').addEventListener('click', function(){ setZoom(0.1); });
    document.getElementById('btn-zoom-out').addEventListener('click', function(){ setZoom(-0.1); });
    document.getElementById('btn-reset').addEventListener('click', resetView);
    document.getElementById('btn-fit').addEventListener('click', fitView);

    // Helper: compute full content bounds inside the container for full capture
    function computeContentBounds(el){
        var base = el.getBoundingClientRect();
        var minL = 0, minT = 0, maxR = base.width, maxB = base.height;
        var any = false;
        el.querySelectorAll('*').forEach(function(ch){
            var r = ch.getBoundingClientRect();
            if (!r || (r.width === 0 && r.height === 0)) return;
            any = true;
            var l = r.left - base.left;
            var t = r.top - base.top;
            var rr = r.right - base.left;
            var bb = r.bottom - base.top;
            minL = Math.min(minL, l);
            minT = Math.min(minT, t);
            maxR = Math.max(maxR, rr);
            maxB = Math.max(maxB, bb);
        });
        var width = Math.ceil(maxR - Math.min(0, minL));
        var height = Math.ceil(maxB - Math.min(0, minT));
        return { width: Math.max(1, width), height: Math.max(1, height) };
    }

    function currentBaseName(){
        var base = (document.getElementById('save-name').value || '').trim();
        if (!base) base = 'mindmap';
        return '8gwifi-' + base.replace(/\s+/g, '-').toLowerCase();
    }

    // Export PNG: prefer jsMind screenshot plugin if available; else fallback to html2canvas with full-bounds sizing
    document.getElementById('btn-export-png').addEventListener('click', function() {
        try {
            if (jm && jm.screenshot && typeof jm.screenshot.shoot === 'function') {
                var url = jm.screenshot.shoot();
                if (url) {
                    var a = document.createElement('a');
                    a.href = url;
                    a.download = currentBaseName() + '.png';
                    a.click();
                    return;
                }
            }
        } catch (e) { /* fall back */ }

        var el = document.getElementById('jsmind_container');
        var origW = el.style.width, origH = el.style.height;
        var bounds = computeContentBounds(el);
        if (bounds.width) el.style.width = bounds.width + 'px';
        if (bounds.height) el.style.height = bounds.height + 'px';

        html2canvas(el, { backgroundColor: '#ffffff', scale: 2, width: bounds.width, height: bounds.height }).then(function(canvas){
            var link = document.createElement('a');
            link.download = currentBaseName() + '.png';
            link.href = canvas.toDataURL('image/png');
            link.click();
        }).finally(function(){
            el.style.width = origW; el.style.height = origH;
        });
    });

    // Export PDF using jsPDF + html2canvas
    document.getElementById('btn-export-pdf').addEventListener('click', async function(){
        const { jsPDF } = window.jspdf;
        const el = document.getElementById('jsmind_container');

        // Resize temporarily to fit full content
        const origW = el.style.width, origH = el.style.height;
        const bounds = computeContentBounds(el);
        if (bounds.width) el.style.width = bounds.width + 'px';
        if (bounds.height) el.style.height = bounds.height + 'px';

        try {
            const canvas = await html2canvas(el, { backgroundColor: '#ffffff', scale: 2, width: bounds.width, height: bounds.height });
            const imgData = canvas.toDataURL('image/png');

            const pdf = new jsPDF({ orientation: 'landscape', unit: 'pt', format: 'a4' });
            const pageWidth = pdf.internal.pageSize.getWidth();
            const pageHeight = pdf.internal.pageSize.getHeight();
            const margin = 20;
            const maxW = pageWidth - margin * 2;
            const ratio = canvas.height / canvas.width;
            const imgWidth = maxW;
            const imgHeight = imgWidth * ratio;
            const y = Math.max(margin, (pageHeight - imgHeight) / 2);
            pdf.addImage(imgData, 'PNG', margin, y, imgWidth, imgHeight);
            pdf.save(currentBaseName() + '.pdf');
        } finally {
            el.style.width = origW; el.style.height = origH;
        }
    });

    // Export SVG (raster inside SVG wrapper)
    document.getElementById('btn-export-svg').addEventListener('click', async function(){
        const el = document.getElementById('jsmind_container');
        const origW = el.style.width, origH = el.style.height;
        const bounds = computeContentBounds(el);
        if (bounds.width) el.style.width = bounds.width + 'px';
        if (bounds.height) el.style.height = bounds.height + 'px';
        try {
            const canvas = await html2canvas(el, { backgroundColor: '#ffffff', scale: 2, width: bounds.width, height: bounds.height });
            const dataUrl = canvas.toDataURL('image/png');
            const svg = '<?xml version="1.0" encoding="UTF-8"?>' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="' + canvas.width + '" height="' + canvas.height + '">' +
                '<image href="' + dataUrl + '" width="' + canvas.width + '" height="' + canvas.height + '"/></svg>';
            const blob = new Blob([svg], { type: 'image/svg+xml' });
            const a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = currentBaseName() + '.svg';
            a.click();
            URL.revokeObjectURL(a.href);
        } finally {
            el.style.width = origW; el.style.height = origH;
        }
    });

    // JSON import/export
    document.getElementById('btn-export-json').addEventListener('click', function(){
        var data = jm.get_data('node_array');
        var blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
        var a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = currentBaseName() + '.json';
        a.click();
        URL.revokeObjectURL(a.href);
    });

    document.getElementById('import-json').addEventListener('change', function(ev){
        var file = ev.target.files[0];
        if (!file) return;
        var reader = new FileReader();
        reader.onload = function(){
            try { var obj = JSON.parse(reader.result); jm.show(obj); jm.expand_all(); }
            catch(e){ alert('Invalid JSON'); }
        };
        reader.readAsText(file);
        ev.target.value = '';
    });

    // Save/Load via localStorage
    function storageKey(name){ return 'mindmap:' + (name || '').trim(); }

    document.getElementById('btn-save').addEventListener('click', function(){
        var name = document.getElementById('save-name').value.trim();
        if (!name) { alert('Enter a map name to save'); return; }
        try {
            var data = jm.get_data('node_array');
            localStorage.setItem(storageKey(name), JSON.stringify(data));
            alert('Saved "' + name + '"');
            renderSavedList();
        } catch (e) { alert('Save failed'); }
    });

    document.getElementById('btn-load').addEventListener('click', function(){
        var name = document.getElementById('save-name').value.trim();
        if (!name) { alert('Enter a map name to load'); return; }
        var raw = localStorage.getItem(storageKey(name));
        if (!raw) { alert('No saved map with that name'); return; }
        try { var obj = JSON.parse(raw); jm.show(obj); jm.expand_all(); }
        catch(e){ alert('Load failed'); }
    });

    // Theme handling
    var THEMES = [
        { id: 'primary', label: 'Primary', color: '#2563eb' },
        { id: 'warning', label: 'Warning', color: '#f59e0b' },
        { id: 'danger',  label: 'Danger',  color: '#ef4444' },
        { id: 'success', label: 'Success', color: '#16a34a' },
        { id: 'info',    label: 'Info',    color: '#0ea5e9' },
        { id: 'greensea',label: 'Sea',     color: '#16a085' },
        { id: 'nephrite',label: 'Nephrite',color: '#27ae60' },
        { id: 'peterriver',label:'River',  color: '#3498db' },
        { id: 'wisteria',label:'Wisteria', color: '#8e44ad' }
    ];

    function renderThemes(active) {
        var wrap = document.getElementById('theme-list');
        wrap.innerHTML = '';
        THEMES.forEach(function(t){
            var div = document.createElement('div');
            div.className = 'theme-chip' + (t.id === active ? ' active' : '');
            div.dataset.theme = t.id;
            div.innerHTML = '<span class="badge-dot" style="background:'+t.color+'"></span>' + t.label;
            div.addEventListener('click', function(){ jm.set_theme(t.id); renderThemes(t.id); });
            wrap.appendChild(div);
        });
    }

    // Templates
    var TEMPLATES = [
        { id:'brainstorm', label:'Brainstorm', desc:'Goal > Themes > Ideas' },
        { id:'essay', label:'Essay Planner', desc:'Thesis > Arguments > Evidence' },
        { id:'swot', label:'SWOT Analysis', desc:'Strengths, Weaknesses, Opportunities, Threats' },
        { id:'5w1h', label:'5W1H', desc:'Who, What, When, Where, Why, How' },
        { id:'okr', label:'OKR Planner', desc:'Objectives > Key Results > Initiatives' },
        { id:'project', label:'Project Plan', desc:'Phases > Tasks > Owners' },
        { id:'meeting', label:'Meeting Notes', desc:'Agenda, Decisions, Action Items' },
        { id:'research', label:'Research Map', desc:'Topics, Questions, Sources' },
        { id:'roadmap', label:'Product Roadmap', desc:'Q1–Q4 > Epics > Items' },
        { id:'proscons', label:'Pros & Cons', desc:'Pros vs Cons > Notes' },
        { id:'decision', label:'Decision Tree', desc:'Yes/No Branches' },
        { id:'fishbone', label:'Fishbone (Ishikawa)', desc:'Causes > Categories' }
    ];

    function nidSeq() { return 't' + Math.random().toString(36).slice(2, 10); }

    function makeData(rootTopic, structure) {
        var arr = [ { id:'root', isroot:true, topic: rootTopic } ];
        function addChildren(parentId, children) {
            (children || []).forEach(function(ch){
                var id = nidSeq();
                arr.push({ id:id, parentid: parentId, topic: ch.t });
                if (ch.c && ch.c.length) addChildren(id, ch.c);
            });
        }
        addChildren('root', structure);
        return { meta:{ name: rootTopic }, format:'node_array', data: arr };
    }

    function templateData(key) {
        switch (key) {
            case 'brainstorm':
                return makeData('Brainstorm', [
                    { t:'Theme 1', c:[ {t:'Idea A'}, {t:'Idea B'} ] },
                    { t:'Theme 2', c:[ {t:'Idea C'}, {t:'Idea D'} ] },
                    { t:'Theme 3', c:[ {t:'Idea E'}, {t:'Idea F'} ] }
                ]);
            case 'essay':
                return makeData('Essay Thesis', [
                    { t:'Argument 1', c:[ {t:'Evidence A'}, {t:'Counterpoint'} ] },
                    { t:'Argument 2', c:[ {t:'Evidence B'}, {t:'Source'} ] },
                    { t:'Conclusion', c:[ {t:'Summary'}, {t:'Next Steps'} ] }
                ]);
            case 'swot':
                return makeData('SWOT Analysis', [
                    { t:'Strengths', c:[ {t:'S1'}, {t:'S2'} ] },
                    { t:'Weaknesses', c:[ {t:'W1'}, {t:'W2'} ] },
                    { t:'Opportunities', c:[ {t:'O1'}, {t:'O2'} ] },
                    { t:'Threats', c:[ {t:'T1'}, {t:'T2'} ] }
                ]);
            case '5w1h':
                return makeData('5W1H', [
                    { t:'Who', c:[ {t:'Stakeholders'} ] },
                    { t:'What', c:[ {t:'Scope'} ] },
                    { t:'When', c:[ {t:'Timeline'} ] },
                    { t:'Where', c:[ {t:'Location'} ] },
                    { t:'Why', c:[ {t:'Goal'} ] },
                    { t:'How', c:[ {t:'Approach'} ] }
                ]);
            case 'okr':
                return makeData('OKRs', [
                    { t:'Objective 1', c:[ {t:'KR1'}, {t:'KR2'}, {t:'Initiatives'} ] },
                    { t:'Objective 2', c:[ {t:'KR1'}, {t:'KR2'}, {t:'Initiatives'} ] }
                ]);
            case 'project':
                return makeData('Project Plan', [
                    { t:'Phase 1', c:[ {t:'Task 1'}, {t:'Task 2'} ] },
                    { t:'Phase 2', c:[ {t:'Task 3'}, {t:'Task 4'} ] },
                    { t:'Risks', c:[ {t:'Risk A'}, {t:'Mitigation'} ] }
                ]);
            case 'meeting':
                return makeData('Meeting Notes', [
                    { t:'Agenda', c:[ {t:'Topic 1'}, {t:'Topic 2'} ] },
                    { t:'Decisions', c:[ {t:'Decision A'}, {t:'Decision B'} ] },
                    { t:'Action Items', c:[ {t:'Owner / Due'}, {t:'Next Meeting'} ] }
                ]);
            case 'research':
                return makeData('Research Map', [
                    { t:'Topics', c:[ {t:'Topic A'}, {t:'Topic B'} ] },
                    { t:'Questions', c:[ {t:'Q1'}, {t:'Q2'} ] },
                    { t:'Sources', c:[ {t:'Paper 1'}, {t:'Dataset'} ] }
                ]);
            case 'roadmap':
                return makeData('Product Roadmap', [
                    { t:'Q1', c:[ {t:'Epic A'}, {t:'Epic B'} ] },
                    { t:'Q2', c:[ {t:'Epic C'} ] },
                    { t:'Q3', c:[ {t:'Epic D'} ] },
                    { t:'Q4', c:[ {t:'Epic E'} ] }
                ]);
            case 'proscons':
                return makeData('Pros & Cons', [
                    { t:'Pros', c:[ {t:'Pro 1'}, {t:'Pro 2'} ] },
                    { t:'Cons', c:[ {t:'Con 1'}, {t:'Con 2'} ] }
                ]);
            case 'decision':
                return makeData('Decision Tree', [
                    { t:'Option A', c:[ {t:'Yes -> Outcome'}, {t:'No -> Outcome'} ] },
                    { t:'Option B', c:[ {t:'Yes -> Outcome'}, {t:'No -> Outcome'} ] }
                ]);
            case 'fishbone':
                return makeData('Fishbone Diagram', [
                    { t:'People', c:[ {t:'Cause A'} ] },
                    { t:'Process', c:[ {t:'Cause B'} ] },
                    { t:'Tools', c:[ {t:'Cause C'} ] },
                    { t:'Environment', c:[ {t:'Cause D'} ] },
                    { t:'Materials', c:[ {t:'Cause E'} ] },
                    { t:'Measurement', c:[ {t:'Cause F'} ] }
                ]);
        }
        return makeData('Mind Map', []);
    }

    function renderTemplates(){
        var wrap = document.getElementById('template-list');
        wrap.innerHTML = '';
        TEMPLATES.forEach(function(t){
            var btn = document.createElement('button');
            btn.className = 'btn btn-sm btn-outline-primary mr-2 mb-2';
            btn.textContent = t.label;
            btn.title = t.desc;
            btn.addEventListener('click', function(){
                if (!confirm('Replace current map with the "' + t.label + '" template?')) return;
                var data = templateData(t.id);
                initialData = data;
                jm.show(data);
                jm.expand_all();
                document.getElementById('save-name').value = t.label;
                scheduleSnapshot();
            });
            wrap.appendChild(btn);
        });
    }

    // Keyboard helpers
    document.addEventListener('keydown', function(e){
        if (!jm) return;
        var node = jm.get_selected_node();
        if (e.key === 'Enter') {
            // sibling
            if (!node) node = jm.get_root();
            var parent = node.parent || jm.get_root();
            jm.add_node(parent, uid(), 'New Idea'); scheduleSnapshot();
            e.preventDefault();
        } else if (e.key === 'Tab') {
            // child
            jm.add_node(node || jm.get_root(), uid(), 'New Idea'); scheduleSnapshot();
            e.preventDefault();
        } else if (e.key === 'Delete' || e.key === 'Backspace') {
            if (node && !node.isroot) { jm.remove_node(node.id); scheduleSnapshot(); }
        }
    });

    // Boot
    initMind('primary');
    renderThemes('primary');
    renderTemplates();

    // Saved list rendering
    function renderSavedList(){
        var names = [];
        for (var i=0; i<localStorage.length; i++){
            var k = localStorage.key(i) || '';
            if (k.indexOf('mindmap:') === 0) {
                names.push(k.substring('mindmap:'.length));
            }
        }
        names.sort(function(a,b){ return a.localeCompare(b); });
        var ul = document.getElementById('saved-list');
        if (!ul) return;
        if (names.length === 0) {
            ul.innerHTML = '<li class="list-group-item text-muted">No saved maps yet.</li>';
            return;
        }
        ul.innerHTML = names.map(function(n){
            var safe = n.replace(/</g,'&lt;').replace(/>/g,'&gt;');
            return '<li class="list-group-item saved-item" data-name="'+safe+'" title="Double-click to open">'+safe+'</li>';
        }).join('');
        Array.prototype.forEach.call(ul.querySelectorAll('.saved-item'), function(li){
            li.addEventListener('click', function(){ document.getElementById('save-name').value = li.dataset.name; });
            li.addEventListener('dblclick', function(){
                var raw = localStorage.getItem(storageKey(li.dataset.name));
                if (!raw) { alert('Missing saved data'); return; }
                try { var obj = JSON.parse(raw); jm.show(obj); jm.expand_all(); document.getElementById('save-name').value = li.dataset.name; }
                catch(e){ alert('Failed to open'); }
            });
        });
    }

    renderSavedList();

    // Undo/Redo history with autosave
    var history = [], hIndex = -1, hDebounce = null;
    function captureSnapshot(reason){
        try {
            var data = jm.get_data('node_array');
            history = history.slice(0, hIndex + 1);
            history.push(JSON.stringify(data));
            if (history.length > 100) history.shift();
            hIndex = history.length - 1;
            autosave();
        } catch (e) { /* ignore */ }
    }
    function scheduleSnapshot(){
        clearTimeout(hDebounce);
        hDebounce = setTimeout(function(){ captureSnapshot('auto'); }, 500);
    }
    function restoreSnapshot(json){ try { jm.show(JSON.parse(json)); jm.expand_all(); } catch(e){} }
    function undo(){ if (hIndex > 0) { hIndex--; restoreSnapshot(history[hIndex]); } }
    function redo(){ if (hIndex < history.length - 1) { hIndex++; restoreSnapshot(history[hIndex]); } }
    function autosave(){
        var on = document.getElementById('autosave-toggle').checked;
        var name = document.getElementById('save-name').value.trim();
        if (!on || !name) return;
        var json = history[hIndex];
        if (json) localStorage.setItem(storageKey(name), json);
        renderSavedList();
    }
    document.getElementById('btn-undo').addEventListener('click', undo);
    document.getElementById('btn-redo').addEventListener('click', redo);
    document.addEventListener('keydown', function(e){
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'z') { e.preventDefault(); if (e.shiftKey) redo(); else undo(); }
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'y') { e.preventDefault(); redo(); }
    });

    // Observe changes to map for autosnapshots (covers keyboard edits)
    var mo = new MutationObserver(function(){ scheduleSnapshot(); });
    mo.observe(document.getElementById('jsmind_container'), { subtree:true, childList:true, attributes:true, characterData:true });

    // Context menu handling
    var ctxMenu = document.getElementById('ctx-menu');
    function showCtxMenu(x,y){ ctxMenu.style.left = x+'px'; ctxMenu.style.top = y+'px'; ctxMenu.style.display = 'block'; }
    function hideCtxMenu(){ ctxMenu.style.display = 'none'; }
    document.addEventListener('click', hideCtxMenu);
    document.getElementById('jsmind_container').addEventListener('contextmenu', function(e){
        e.preventDefault();
        var target = e.target;
        var nodeEl = target.closest('[nodeid], .jmnode');
        if (nodeEl) {
            var nid = nodeEl.getAttribute('nodeid') || nodeEl.dataset.nodeid;
            if (nid) jm.select_node(nid);
        }
        showCtxMenu(e.pageX, e.pageY);
    });
    ctxMenu.addEventListener('click', function(e){
        var act = e.target && e.target.getAttribute('data-act');
        if (!act) return;
        hideCtxMenu();
        var node = getSelectedNode() || jm.get_root();
        if (act === 'add-child') jm.add_node(node, uid(), 'New Idea');
        else if (act === 'add-sibling') { var p = node.parent || jm.get_root(); jm.add_node(p, uid(), 'New Idea'); }
        else if (act === 'edit') { var t = prompt('Edit node text', node.topic || ''); if (t !== null) jm.update_node(node.id, t); }
        else if (act === 'delete') { if (!node.isroot) jm.remove_node(node.id); }
        else if (act === 'expand') { jm.expand_node(node); }
        else if (act === 'collapse') { jm.collapse_node(node); }
        else if (act === 'center') { jm.select_node(node.id); jm.center_root(); }
        scheduleSnapshot();
    });
</script>

</div>

<%@ include file="body-close.jsp"%>
