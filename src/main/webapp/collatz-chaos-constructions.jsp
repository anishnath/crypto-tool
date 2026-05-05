<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Collatz Chaos Constructions Visualizer" />
        <jsp:param name="toolDescription" value="Interactive Collatz chaos constructions page inspired by odd-core flows, ascent/descent zones, and graph structure. Visualize the mod-4 split, stream links, and animated trajectories." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="collatz-chaos-constructions.jsp" />
        <jsp:param name="toolKeywords" value="collatz chaos, collatz graph structure, ascent descent zones, odd core collatz, collatz visualization, collatz tree, 3n+1 chaos" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Odd-core flow graph visualization,Ascent and descent zone coloring,Animated Collatz trajectory overlay,Live stopping-time and peak stats,Transition table for odd-number structure" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="High School, College" />
        <jsp:param name="teaches" value="Collatz conjecture, modular arithmetic, iterative maps, deterministic chaos" />
        <jsp:param name="howToSteps" value="Set odd limit|Choose how many odd nodes to include in the structure graph,Set start number|Pick a positive integer as trajectory seed,Build structure|Click Draw Structure to render odd-core links and zone classes,Animate path|Click Animate Trajectory to overlay one Collatz orbit,Inspect metrics|Read stopping time, peak, and zone step counts in the stats panel" />
    </jsp:include>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">

    <style>
        :root {
            --cc-descent: #f59e0b;
            --cc-ascent: #16a34a;
            --cc-link: #64748b;
            --cc-trajectory: #ef4444;
            --cc-grid: rgba(100, 116, 139, 0.3);
        }
        .ccx-main {
            max-width: 1200px;
            margin: 1.5rem auto 2.5rem;
            padding: 0 1rem;
            display: grid;
            grid-template-columns: 330px minmax(0, 1fr);
            gap: 1rem;
        }
        .ccx-card {
            border: 1px solid var(--border);
            border-radius: 0.85rem;
            background: var(--bg-primary);
            overflow: hidden;
        }
        .ccx-card-head {
            padding: 0.85rem 1rem;
            border-bottom: 1px solid var(--border);
            background: var(--bg-secondary);
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.95rem;
        }
        .ccx-card-body {
            padding: 1rem;
        }
        .ccx-form-group {
            margin-bottom: 0.9rem;
        }
        .ccx-form-group label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 0.35rem;
        }
        .ccx-input,
        .ccx-range,
        .ccx-btn {
            width: 100%;
            font: inherit;
        }
        .ccx-input,
        .ccx-range {
            border: 1px solid var(--border);
            border-radius: 0.55rem;
            padding: 0.62rem 0.7rem;
            background: var(--bg-primary);
            color: var(--text-primary);
        }
        .ccx-btn {
            border: 0;
            border-radius: 0.55rem;
            padding: 0.66rem 0.8rem;
            color: #fff;
            background: linear-gradient(135deg, #2563eb, #4f46e5);
            font-weight: 600;
            cursor: pointer;
            margin-bottom: 0.55rem;
        }
        .ccx-btn.alt {
            background: linear-gradient(135deg, #059669, #0d9488);
        }
        .ccx-btn.reset {
            background: linear-gradient(135deg, #64748b, #475569);
        }
        .ccx-quick {
            display: flex;
            flex-wrap: wrap;
            gap: 0.35rem;
        }
        .ccx-chip {
            border: 1px solid var(--border);
            background: var(--bg-secondary);
            color: var(--text-secondary);
            border-radius: 999px;
            font-size: 0.74rem;
            padding: 0.25rem 0.55rem;
            cursor: pointer;
        }
        .ccx-canvas-wrap {
            position: relative;
            min-height: 520px;
            border-radius: 0.8rem;
            overflow: hidden;
            border: 1px solid var(--border);
            background: var(--bg-secondary);
        }
        #ccx-canvas {
            width: 100%;
            height: 520px;
            display: block;
        }
        .ccx-legend {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            margin-top: 0.75rem;
            color: var(--text-secondary);
            font-size: 0.8rem;
        }
        .ccx-key {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }
        .ccx-swatch {
            width: 0.75rem;
            height: 0.75rem;
            border-radius: 50%;
            display: inline-block;
        }
        .ccx-stats {
            margin-top: 0.8rem;
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0.45rem;
        }
        .ccx-stat {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: 0.55rem;
            padding: 0.55rem;
        }
        .ccx-stat .label {
            font-size: 0.74rem;
            color: var(--text-muted);
        }
        .ccx-stat .value {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--text-primary);
        }
        .ccx-table-wrap {
            margin-top: 0.95rem;
            max-height: 200px;
            overflow: auto;
            border: 1px solid var(--border);
            border-radius: 0.6rem;
        }
        .ccx-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.78rem;
        }
        .ccx-table th,
        .ccx-table td {
            padding: 0.45rem 0.5rem;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }
        .ccx-table th {
            background: var(--bg-secondary);
            color: var(--text-secondary);
            position: sticky;
            top: 0;
        }
        @media (max-width: 980px) {
            .ccx-main {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Collatz Chaos Constructions</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                Collatz Chaos Constructions
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Odd-Core Graph</span>
            <span class="tool-badge">Zone Split</span>
            <span class="tool-badge">Animated Path</span>
        </div>
    </div>
</header>

<main class="ccx-main">
    <section class="ccx-card">
        <div class="ccx-card-head">Control Panel</div>
        <div class="ccx-card-body">
            <div class="ccx-form-group">
                <label for="ccx-start">Start Number</label>
                <input class="ccx-input" type="number" id="ccx-start" min="1" max="1000000" value="27">
            </div>
            <div class="ccx-form-group">
                <label for="ccx-limit">Odd Nodes (1..N odd)</label>
                <input class="ccx-input" type="number" id="ccx-limit" min="25" max="999" step="2" value="199">
            </div>
            <div class="ccx-form-group">
                <label for="ccx-speed">Animation Speed: <span id="ccx-speed-value">160ms</span></label>
                <input class="ccx-range" type="range" id="ccx-speed" min="40" max="700" step="20" value="160">
            </div>

            <button class="ccx-btn" id="ccx-build">Draw Structure</button>
            <button class="ccx-btn alt" id="ccx-animate">Animate Trajectory</button>
            <button class="ccx-btn reset" id="ccx-reset">Reset</button>

            <div class="ccx-form-group" style="margin-top:0.6rem;">
                <label>Quick Examples</label>
                <div class="ccx-quick">
                    <button class="ccx-chip" data-seed="27">27</button>
                    <button class="ccx-chip" data-seed="63">63</button>
                    <button class="ccx-chip" data-seed="97">97</button>
                    <button class="ccx-chip" data-seed="871">871</button>
                    <button class="ccx-chip" data-seed="6171">6171</button>
                </div>
            </div>

            <div class="ccx-stats">
                <div class="ccx-stat"><div class="label">Stopping Time</div><div class="value" id="stat-steps">-</div></div>
                <div class="ccx-stat"><div class="label">Peak Value</div><div class="value" id="stat-peak">-</div></div>
                <div class="ccx-stat"><div class="label">Ascent Zone Steps</div><div class="value" id="stat-ascent">-</div></div>
                <div class="ccx-stat"><div class="label">Descent Zone Steps</div><div class="value" id="stat-descent">-</div></div>
            </div>

            <div class="ccx-table-wrap">
                <table class="ccx-table" id="ccx-table">
                    <thead>
                    <tr><th>Odd n</th><th>Zone</th><th>(3n+1)/2</th><th>Odd Core</th></tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </section>

    <section class="ccx-card">
        <div class="ccx-card-head">Flow Graph (Odd-Core Construction)</div>
        <div class="ccx-card-body">
            <div class="ccx-canvas-wrap">
                <canvas id="ccx-canvas"></canvas>
            </div>
            <div class="ccx-legend">
                <span class="ccx-key"><i class="ccx-swatch" style="background:var(--cc-descent);"></i> Descent zone: n ≡ 1 (mod 4)</span>
                <span class="ccx-key"><i class="ccx-swatch" style="background:var(--cc-ascent);"></i> Ascent zone: n ≡ 3 (mod 4)</span>
                <span class="ccx-key"><i class="ccx-swatch" style="background:var(--cc-trajectory);"></i> Animated trajectory</span>
            </div>
        </div>
    </section>
</main>

<section style="max-width:1200px;margin:0 auto 2.5rem;padding:0 1rem;">
    <div class="ccx-card">
        <div class="ccx-card-body">
            <h2 style="margin:0 0 0.5rem;font-size:1.15rem;">What this page shows</h2>
            <p style="margin:0;color:var(--text-secondary);line-height:1.65;">This visualization follows the odd-core viewpoint: even numbers are treated as transitions, while odd numbers become structural nodes. Each odd node n links to the odd core of (3n+1)/2. The color split reflects the mod-4 zones from the chaos-construction framing: n ≡ 1 (mod 4) gives local descent behavior, and n ≡ 3 (mod 4) gives local ascent behavior.</p>
        </div>
    </div>
</section>

<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/collatz-conjecture.jsp" class="footer-link">Collatz Explorer</a>
            <a href="<%=request.getContextPath()%>/math/" class="footer-link">Math Tools</a>
        </div>
    </div>
</footer>

<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script>
(function () {
    var canvas = document.getElementById('ccx-canvas');
    var ctx = canvas.getContext('2d');
    var startInput = document.getElementById('ccx-start');
    var limitInput = document.getElementById('ccx-limit');
    var speedInput = document.getElementById('ccx-speed');
    var speedValue = document.getElementById('ccx-speed-value');
    var tableBody = document.querySelector('#ccx-table tbody');

    var animTimer = null;
    var graphState = null;

    function v2(n) {
        var count = 0;
        while (n % 2 === 0 && n > 0) {
            n = n / 2;
            count++;
        }
        return count;
    }

    function oddCore(n) {
        while (n % 2 === 0 && n > 0) {
            n = n / 2;
        }
        return n;
    }

    function step(n) {
        return n % 2 === 0 ? n / 2 : 3 * n + 1;
    }

    function zone(oddNumber) {
        return oddNumber % 4 === 1 ? 'descent' : 'ascent';
    }

    function buildOddNodes(maxOdd) {
        var nodes = [];
        var nodeMap = {};
        var maxValue = 1;
        for (var n = 1; n <= maxOdd; n += 2) {
            var halfStep = (3 * n + 1) / 2;
            var core = oddCore(halfStep);
            var entry = {
                n: n,
                zone: zone(n),
                halfStep: halfStep,
                oddCore: core,
                twoAdic: v2(3 * n + 1)
            };
            nodes.push(entry);
            nodeMap[n] = entry;
            maxValue = Math.max(maxValue, n, core);
        }
        return { nodes: nodes, map: nodeMap, maxValue: maxValue };
    }

    function resizeCanvas() {
        var rect = canvas.getBoundingClientRect();
        canvas.width = Math.max(640, Math.floor(rect.width));
        canvas.height = 520;
    }

    function clearCanvas() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.fillStyle = getComputedStyle(document.documentElement).getPropertyValue('--bg-secondary') || '#f8fafc';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
    }

    function drawGrid() {
        var pad = 36;
        ctx.strokeStyle = getComputedStyle(document.documentElement).getPropertyValue('--cc-grid');
        ctx.lineWidth = 1;
        for (var x = pad; x <= canvas.width - pad; x += 80) {
            ctx.beginPath();
            ctx.moveTo(x, pad);
            ctx.lineTo(x, canvas.height - pad);
            ctx.stroke();
        }
        for (var y = pad; y <= canvas.height - pad; y += 72) {
            ctx.beginPath();
            ctx.moveTo(pad, y);
            ctx.lineTo(canvas.width - pad, y);
            ctx.stroke();
        }
    }

    function nodePoint(n, maxOdd, maxValue) {
        var pad = 36;
        var x = pad + ((n - 1) / Math.max(2, maxOdd - 1)) * (canvas.width - 2 * pad);
        var yNorm = Math.log2(Math.max(1, n)) / Math.log2(Math.max(2, maxValue));
        var y = canvas.height - pad - yNorm * (canvas.height - 2 * pad);
        return { x: x, y: y };
    }

    function drawStructure(state) {
        clearCanvas();
        drawGrid();

        var nodes = state.nodes;
        var maxOdd = nodes[nodes.length - 1].n;
        var maxValue = state.maxValue;
        var nodePoints = {};

        for (var i = 0; i < nodes.length; i++) {
            var p = nodePoint(nodes[i].n, maxOdd, maxValue);
            nodePoints[nodes[i].n] = p;
        }

        ctx.strokeStyle = getComputedStyle(document.documentElement).getPropertyValue('--cc-link') || '#64748b';
        ctx.lineWidth = 1.2;
        ctx.globalAlpha = 0.55;
        for (var j = 0; j < nodes.length; j++) {
            var src = nodes[j];
            if (!nodePoints[src.oddCore]) {
                continue;
            }
            var from = nodePoints[src.n];
            var to = nodePoints[src.oddCore];
            var mx = (from.x + to.x) / 2;
            var bend = src.zone === 'ascent' ? -24 : 24;
            ctx.beginPath();
            ctx.moveTo(from.x, from.y);
            ctx.quadraticCurveTo(mx, (from.y + to.y) / 2 + bend, to.x, to.y);
            ctx.stroke();
        }
        ctx.globalAlpha = 1;

        for (var k = 0; k < nodes.length; k++) {
            var node = nodes[k];
            var point = nodePoints[node.n];
            ctx.beginPath();
            ctx.fillStyle = node.zone === 'descent'
                ? getComputedStyle(document.documentElement).getPropertyValue('--cc-descent')
                : getComputedStyle(document.documentElement).getPropertyValue('--cc-ascent');
            ctx.arc(point.x, point.y, 3.4, 0, Math.PI * 2);
            ctx.fill();
        }

        graphState = {
            nodes: nodes,
            maxOdd: maxOdd,
            maxValue: maxValue,
            nodePoints: nodePoints
        };
        renderTable(nodes);
    }

    function renderTable(nodes) {
        tableBody.innerHTML = '';
        var rows = Math.min(34, nodes.length);
        for (var i = 0; i < rows; i++) {
            var row = nodes[i];
            var tr = document.createElement('tr');
            tr.innerHTML = '<td>' + row.n + '</td><td>' + (row.zone === 'descent' ? 'n ≡ 1 mod 4' : 'n ≡ 3 mod 4') + '</td><td>' + row.halfStep + '</td><td>' + row.oddCore + '</td>';
            tableBody.appendChild(tr);
        }
    }

    function buildTrajectory(start) {
        var cur = Math.max(1, Math.floor(start));
        var seq = [cur];
        var peak = cur;
        var ascentSteps = 0;
        var descentSteps = 0;
        var maxSteps = 900;
        while (cur !== 1 && seq.length < maxSteps) {
            if (cur % 2 === 1) {
                if (cur % 4 === 1) descentSteps++;
                if (cur % 4 === 3) ascentSteps++;
            }
            cur = step(cur);
            peak = Math.max(peak, cur);
            seq.push(cur);
        }
        return {
            seq: seq,
            peak: peak,
            ascentSteps: ascentSteps,
            descentSteps: descentSteps
        };
    }

    function updateStats(data) {
        document.getElementById('stat-steps').textContent = String(data.seq.length - 1);
        document.getElementById('stat-peak').textContent = String(data.peak);
        document.getElementById('stat-ascent').textContent = String(data.ascentSteps);
        document.getElementById('stat-descent').textContent = String(data.descentSteps);
    }

    function drawTrajectory(data) {
        if (!graphState) return;
        if (animTimer) {
            clearInterval(animTimer);
            animTimer = null;
        }
        drawStructure({
            nodes: graphState.nodes,
            maxValue: graphState.maxValue
        });

        var path = [];
        for (var i = 0; i < data.seq.length; i++) {
            var n = data.seq[i];
            var x = 36 + (i / Math.max(1, data.seq.length - 1)) * (canvas.width - 72);
            var yNorm = Math.log2(Math.max(1, n)) / Math.log2(Math.max(2, data.peak));
            var y = canvas.height - 36 - yNorm * (canvas.height - 72);
            path.push({ x: x, y: y });
        }

        var idx = 1;
        var speed = parseInt(speedInput.value, 10);
        animTimer = setInterval(function () {
            if (idx >= path.length) {
                clearInterval(animTimer);
                animTimer = null;
                return;
            }
            var from = path[idx - 1];
            var to = path[idx];

            ctx.strokeStyle = getComputedStyle(document.documentElement).getPropertyValue('--cc-trajectory') || '#ef4444';
            ctx.fillStyle = getComputedStyle(document.documentElement).getPropertyValue('--cc-trajectory') || '#ef4444';
            ctx.lineWidth = 2.1;
            ctx.globalAlpha = 0.95;
            ctx.beginPath();
            ctx.moveTo(from.x, from.y);
            ctx.lineTo(to.x, to.y);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(to.x, to.y, 2.8, 0, Math.PI * 2);
            ctx.fill();
            ctx.globalAlpha = 1;
            idx++;
        }, speed);
    }

    function buildAndDraw() {
        var maxOdd = Math.max(25, parseInt(limitInput.value, 10) || 199);
        if (maxOdd % 2 === 0) {
            maxOdd -= 1;
        }
        limitInput.value = String(maxOdd);
        var state = buildOddNodes(maxOdd);
        drawStructure(state);
    }

    speedInput.addEventListener('input', function () {
        speedValue.textContent = speedInput.value + 'ms';
    });

    document.getElementById('ccx-build').addEventListener('click', function () {
        buildAndDraw();
    });

    document.getElementById('ccx-animate').addEventListener('click', function () {
        if (!graphState) buildAndDraw();
        var seed = Math.max(1, parseInt(startInput.value, 10) || 27);
        startInput.value = String(seed);
        var traj = buildTrajectory(seed);
        updateStats(traj);
        drawTrajectory(traj);
    });

    document.getElementById('ccx-reset').addEventListener('click', function () {
        if (animTimer) {
            clearInterval(animTimer);
            animTimer = null;
        }
        startInput.value = '27';
        limitInput.value = '199';
        speedInput.value = '160';
        speedValue.textContent = '160ms';
        document.getElementById('stat-steps').textContent = '-';
        document.getElementById('stat-peak').textContent = '-';
        document.getElementById('stat-ascent').textContent = '-';
        document.getElementById('stat-descent').textContent = '-';
        buildAndDraw();
    });

    document.querySelectorAll('.ccx-chip').forEach(function (chip) {
        chip.addEventListener('click', function () {
            startInput.value = chip.getAttribute('data-seed');
        });
    });

    window.addEventListener('resize', function () {
        resizeCanvas();
        if (graphState) {
            drawStructure({
                nodes: graphState.nodes,
                maxValue: graphState.maxValue
            });
        }
    });

    resizeCanvas();
    buildAndDraw();
})();
</script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
