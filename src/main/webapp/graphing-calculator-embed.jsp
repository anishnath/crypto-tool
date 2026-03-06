<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    // Allow embedding in iframes
    response.setHeader("X-Frame-Options", "ALLOWALL");
    response.setHeader("Content-Security-Policy", "frame-ancestors *");

    String cacheVersion = String.valueOf(System.currentTimeMillis());

    // URL parameters for pre-loading
    // Sanitize helpers
    // JS string escape: prevents XSS in JavaScript string literals
    // HTML attribute values are safe because they go into value="" of number inputs (validated as numbers)
%>
<%!
    static String jsEsc(String s) {
        if (s == null) return null;
        return s.replace("\\", "\\\\").replace("'", "\\'")
                 .replace("\"", "\\\"").replace("\n", "\\n")
                 .replace("\r", "").replace("<", "\\x3c").replace(">", "\\x3e");
    }
    static String numParam(String s, String def) {
        if (s == null) return def;
        try { Double.parseDouble(s); return s; } catch (Exception e) { return def; }
    }
%>
<%

    String expr = request.getParameter("expr");         // expression(s), pipe-separated: sin(x)|cos(x)
    String types = request.getParameter("type");         // type(s), pipe-separated: cartesian|polar
    String colors = request.getParameter("color");       // color(s), pipe-separated: #2563eb|#ef4444
    String presetRaw = request.getParameter("preset");
    String preset = (presetRaw != null && presetRaw.matches("^[a-zA-Z0-9_]+$")) ? presetRaw : null;
    String xMinP = numParam(request.getParameter("xmin"), "-10");
    String xMaxP = numParam(request.getParameter("xmax"), "10");
    String yMinP = numParam(request.getParameter("ymin"), "-10");
    String yMaxP = numParam(request.getParameter("ymax"), "10");
    String showInputs = request.getParameter("inputs");  // "0" to hide input panel
    String theme = request.getParameter("theme");        // "dark" or "light"
    String grid = request.getParameter("grid");          // "0" to hide grid
    String legend = request.getParameter("legend");      // "0" to hide legend

    boolean hideInputs = "0".equals(showInputs);
%>
<!DOCTYPE html>
<html lang="en"<% if ("dark".equalsIgnoreCase(theme)) { %> data-theme="dark"<% } %>>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex, nofollow">
    <meta name="context-path" content="<%=request.getContextPath()%>">
    <title>Graphing Calculator - 8gwifi.org</title>

    <!-- Preload heavy JS -->
    <link rel="preload" href="https://cdn.plot.ly/plotly-basic-2.27.0.min.js" as="script" crossorigin>
    <link rel="preload" href="https://cdnjs.cloudflare.com/ajax/libs/mathjs/12.4.1/math.min.js" as="script" crossorigin>

    <!-- Minimal CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/graphing-calculator.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* Embed-specific overrides */
        *, *::before, *::after { box-sizing: border-box; }
        html, body {
            margin: 0; padding: 0; height: 100%; overflow: hidden;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--surface-primary, #fff);
        }

        .embed-container {
            display: flex;
            height: 100vh;
            gap: 0;
        }

        /* When inputs are visible: side-by-side layout */
        .embed-container.with-inputs .embed-inputs {
            width: 280px;
            min-width: 220px;
            border-right: 1px solid var(--border-primary, #e5e7eb);
            overflow-y: auto;
            padding: 0.5rem;
            flex-shrink: 0;
        }

        .embed-container.with-inputs .embed-graph {
            flex: 1;
            min-width: 0;
        }

        /* When inputs are hidden: graph fills everything */
        .embed-container.graph-only .embed-inputs { display: none; }
        .embed-container.graph-only .embed-graph { width: 100%; }

        .embed-graph {
            display: flex;
            flex-direction: column;
            height: 100%;
            position: relative;
        }

        .embed-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 4px 8px;
            background: var(--surface-secondary, #f9fafb);
            border-bottom: 1px solid var(--border-primary, #e5e7eb);
            font-size: 12px;
            flex-shrink: 0;
        }

        .embed-toolbar-actions { display: flex; gap: 4px; align-items: center; }

        .embed-toolbar-btn {
            background: none; border: 1px solid var(--border-primary, #e5e7eb);
            border-radius: 4px; padding: 3px 8px; cursor: pointer;
            font-size: 11px; color: var(--text-secondary, #6b7280);
            transition: background 0.15s;
        }
        .embed-toolbar-btn:hover { background: var(--surface-tertiary, #f3f4f6); }

        .embed-branding a {
            color: var(--text-tertiary, #9ca3af);
            text-decoration: none;
            font-size: 11px;
            transition: color 0.15s;
        }
        .embed-branding a:hover { color: var(--gc-tool, #8b5cf6); }

        #graph {
            flex: 1;
            min-height: 0;
        }

        /* Hide elements not needed in embed */
        .gc-btn-add { font-size: 12px; padding: 6px 10px; }
        .gc-graph-card { border: none; border-radius: 0; box-shadow: none; }
        .gc-graph-toolbar { display: none; }

        /* Range inputs in embed */
        .embed-range { display: none; }
        .embed-range.visible {
            display: flex; gap: 4px; padding: 4px 8px;
            background: var(--surface-secondary, #f9fafb);
            border-bottom: 1px solid var(--border-primary, #e5e7eb);
        }
        .embed-range input {
            width: 60px; font-size: 11px; padding: 2px 4px;
            border: 1px solid var(--border-primary, #e5e7eb); border-radius: 3px;
            text-align: center;
        }
        .embed-range label { font-size: 11px; color: var(--text-secondary, #6b7280); }

        /* Mobile: stack vertically */
        @media (max-width: 500px) {
            .embed-container.with-inputs {
                flex-direction: column;
            }
            .embed-container.with-inputs .embed-inputs {
                width: 100%;
                max-height: 35vh;
                border-right: none;
                border-bottom: 1px solid var(--border-primary, #e5e7eb);
            }
        }

        /* Dark theme */
        [data-theme="dark"] { --surface-primary: #0f172a; --surface-secondary: #1e293b; --border-primary: #334155; }
    </style>
</head>
<body>

<div class="embed-container <%= hideInputs ? "graph-only" : "with-inputs" %>">

    <% if (!hideInputs) { %>
    <!-- Input Panel -->
    <div class="embed-inputs">
        <div id="expressions-list"></div>
        <button class="gc-btn-add" onclick="addExpression()">
            <i class="fas fa-plus"></i> Add
        </button>
    </div>
    <% } %>

    <!-- Graph Panel -->
    <div class="embed-graph">
        <div class="embed-toolbar">
            <div class="embed-toolbar-actions">
                <button class="embed-toolbar-btn" onclick="resetView()" title="Reset View"><i class="fas fa-sync"></i></button>
                <button class="embed-toolbar-btn" onclick="toggleTraceMode()" title="Trace Mode"><i class="fas fa-crosshairs"></i></button>
                <button class="embed-toolbar-btn" onclick="exportAsPNG()" title="Export PNG"><i class="fas fa-image"></i></button>
                <% if (hideInputs) { %>
                <button class="embed-toolbar-btn" onclick="window.open(gcFullUrl(),'_blank')" title="Open in Full Calculator"><i class="fas fa-expand"></i> Open Full</button>
                <% } %>
            </div>
            <div class="embed-branding">
                <a href="<%=request.getContextPath()%>/graphing-calculator.jsp" target="_blank" rel="noopener">8gwifi.org</a>
            </div>
        </div>

        <!-- Hidden range inputs -->
        <div class="embed-range" id="embed-range-bar">
            <label>X:</label>
            <input type="number" id="xMin" value="<%= xMinP %>">
            <input type="number" id="xMax" value="<%= xMaxP %>">
            <label>Y:</label>
            <input type="number" id="yMin" value="<%= yMinP %>">
            <input type="number" id="yMax" value="<%= yMaxP %>">
            <input type="checkbox" id="showGrid" <%= "0".equals(grid) ? "" : "checked" %> onchange="updateGraph()" style="display:none;">
            <input type="checkbox" id="showLegend" <%= "0".equals(legend) ? "" : "checked" %> onchange="updateGraph()" style="display:none;">
        </div>

        <div id="graph" style="flex:1;min-height:0;"></div>
    </div>
</div>

<!-- Nerdamer fix -->
<script>if (typeof window.i === 'undefined') window.i = NaN;</script>

<!-- Dark mode bridge -->
<script>
(function(){
    window.GC_DARK = document.documentElement.getAttribute('data-theme') === 'dark';
})();
</script>

<!-- Embed config: pass URL params to JS -->
<script>
    window.EMBED_MODE = true;
    window.EMBED_CONFIG = {
        expressions: <%= expr != null ? "'" + jsEsc(expr) + "'" : "null" %>,
        types: <%= types != null ? "'" + jsEsc(types) + "'" : "null" %>,
        colors: <%= colors != null ? "'" + jsEsc(colors) + "'" : "null" %>,
        preset: <%= preset != null ? "'" + jsEsc(preset) + "'" : "null" %>
    };

    // Build full calculator URL from current embed state
    function gcFullUrl() {
        var base = '<%=request.getContextPath()%>/graphing-calculator.jsp';
        try {
            if (window.EMBED_CONFIG.preset) return base + '?preset=' + encodeURIComponent(window.EMBED_CONFIG.preset);
            var exprs = [];
            if (engine && engine.expressions) {
                engine.expressions.forEach(function(e) {
                    if (e.expression) exprs.push(e.type + ':' + e.expression);
                });
            }
            if (exprs.length) return base + '#' + btoa(unescape(encodeURIComponent(JSON.stringify(exprs))));
        } catch(_) {}
        return base;
    }
</script>

<!-- Script loading (same strategy, no KaTeX in embed for speed) -->
<script>
(function(){
    var loaded = { math: false, plotly: false, nerdamer: false };

    function checkReady() {
        if (!loaded.math || !loaded.plotly || !loaded.nerdamer) return;
        loadScript('<%=request.getContextPath()%>/js/graphing-tool-engine.js', function(){
            loadScript('<%=request.getContextPath()%>/js/graphing-calculator-presets.js?v=<%=cacheVersion%>', function(){
                // Apply embed config after engine is ready
                applyEmbedConfig();
                // Resize observer
                var g = document.getElementById('graph');
                if (g && typeof ResizeObserver !== 'undefined') {
                    new ResizeObserver(function(){ try{ Plotly.Plots.resize('graph'); }catch(_){} }).observe(g);
                }
                // Listen for postMessage API from parent
                setupPostMessageAPI();
            });
        });
    }

    function loadScript(src, cb) {
        var s = document.createElement('script');
        s.src = src; s.async = true;
        s.setAttribute('data-cfasync', 'false');
        if (cb) s.onload = cb;
        s.onerror = function(){ console.warn('Failed: ' + src); if (cb) cb(); };
        document.body.appendChild(s);
    }

    loadScript('https://cdnjs.cloudflare.com/ajax/libs/mathjs/12.4.1/math.min.js', function(){ loaded.math = true; checkReady(); });
    loadScript('https://cdn.plot.ly/plotly-basic-2.27.0.min.js', function(){ loaded.plotly = true; checkReady(); });
    loadScript('https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.min.js', function(){
        loadScript('https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.min.js', function(){
            loadScript('https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.min.js', function(){
                loadScript('https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Solve.min.js', function(){
                    loaded.nerdamer = true; checkReady();
                });
            });
        });
    });
})();

function applyEmbedConfig() {
    var cfg = window.EMBED_CONFIG;
    if (!cfg) return;

    // Preset takes priority
    if (cfg.preset && typeof gcQuickPreset === 'function') {
        engine._animateNext = true;
        gcQuickPreset(cfg.preset);
        return;
    }

    // Load individual expressions
    if (cfg.expressions) {
        var exprs = cfg.expressions.split('|');
        var typeArr = cfg.types ? cfg.types.split('|') : [];
        var colorArr = cfg.colors ? cfg.colors.split('|') : [];

        // Clear default
        if (typeof gcClearAll === 'function') gcClearAll();

        exprs.forEach(function(ex, i) {
            if (i > 0 && typeof addExpression === 'function') addExpression();
            var items = document.querySelectorAll('[id^=expr-item-]');
            var last = items[items.length - 1];
            if (!last) return;
            var id = parseInt(last.id.replace('expr-item-', ''));
            var type = typeArr[i] || 'cartesian';
            var color = colorArr[i] || null;

            var typeSel = document.getElementById('type-' + id);
            if (typeSel) { typeSel.value = type; updateExpressionType(id); }
            var input = document.getElementById('expr-' + id);
            if (input) { input.value = ex; updateExpressionValue(id); }
            if (color) {
                var c = document.getElementById('color-' + id);
                if (c) { c.value = color; updateExpressionColor(id); }
            }
        });

        engine._animateNext = true;
        updateGraph();
    }
}

/**
 * postMessage API — allows parent pages to control the embedded calculator
 *
 * Messages: { action: 'setExpression', expr: 'sin(x)', type: 'cartesian' }
 *           { action: 'loadPreset', preset: 'heart' }
 *           { action: 'clear' }
 *           { action: 'setRange', xmin: -5, xmax: 5, ymin: -5, ymax: 5 }
 *           { action: 'exportPNG' }  // responds with { type: 'graphExport', dataUrl: '...' }
 */
function setupPostMessageAPI() {
    window.addEventListener('message', function(event) {
        var msg = event.data;
        if (!msg || typeof msg !== 'object' || !msg.action) return;

        try {
            switch (msg.action) {
                case 'setExpression':
                    if (typeof gcClearAll === 'function') gcClearAll();
                    var items = document.querySelectorAll('[id^=expr-item-]');
                    var last = items[items.length - 1];
                    if (last) {
                        var id = parseInt(last.id.replace('expr-item-', ''));
                        var typeSel = document.getElementById('type-' + id);
                        if (typeSel) { typeSel.value = msg.type || 'cartesian'; updateExpressionType(id); }
                        var input = document.getElementById('expr-' + id);
                        if (input) { input.value = msg.expr || ''; updateExpressionValue(id); }
                    }
                    engine._animateNext = true;
                    updateGraph();
                    break;

                case 'addExpression':
                    if (typeof addExpression === 'function') addExpression();
                    var items2 = document.querySelectorAll('[id^=expr-item-]');
                    var last2 = items2[items2.length - 1];
                    if (last2) {
                        var id2 = parseInt(last2.id.replace('expr-item-', ''));
                        var ts = document.getElementById('type-' + id2);
                        if (ts) { ts.value = msg.type || 'cartesian'; updateExpressionType(id2); }
                        var inp = document.getElementById('expr-' + id2);
                        if (inp) { inp.value = msg.expr || ''; updateExpressionValue(id2); }
                    }
                    updateGraph();
                    break;

                case 'loadPreset':
                    if (msg.preset && typeof gcQuickPreset === 'function') {
                        engine._animateNext = true;
                        gcQuickPreset(msg.preset);
                    }
                    break;

                case 'clear':
                    if (typeof gcClearAll === 'function') gcClearAll();
                    break;

                case 'setRange':
                    if (msg.xmin != null) document.getElementById('xMin').value = msg.xmin;
                    if (msg.xmax != null) document.getElementById('xMax').value = msg.xmax;
                    if (msg.ymin != null) document.getElementById('yMin').value = msg.ymin;
                    if (msg.ymax != null) document.getElementById('yMax').value = msg.ymax;
                    updateGraph();
                    break;

                case 'exportPNG':
                    if (typeof Plotly !== 'undefined') {
                        Plotly.toImage('graph', { format: 'png', width: 800, height: 600 }).then(function(url) {
                            event.source.postMessage({ type: 'graphExport', dataUrl: url }, '*');
                        });
                    }
                    break;
            }
        } catch (e) {
            console.error('Embed API error:', e);
        }
    });

    // Notify parent that embed is ready
    if (window.parent !== window) {
        window.parent.postMessage({ type: 'graphReady' }, '*');
    }
}
</script>

</body>
</html>
