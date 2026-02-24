/**
 * Lagrangian Mechanics Calculator - D3.js Animation Module
 * Provides animated SVG visualizations for mechanical systems.
 * Requires: D3 v7 (loaded lazily by JSP)
 * Exposes: window.LagrangianAnimations
 */
(function() {
    'use strict';

    var animFrame = null;
    var playing = false;
    var speed = 1;
    var currentIdx = 0;
    var startTime = null;
    var svgEl = null;
    var config = null;
    var timeDisplay = document.getElementById('lm-time-display');

    function destroy() {
        playing = false;
        if (animFrame) cancelAnimationFrame(animFrame);
        animFrame = null;
        currentIdx = 0;
        startTime = null;
        if (svgEl) {
            svgEl.remove();
            svgEl = null;
        }
    }

    function init(cfg) {
        destroy();
        config = cfg;
        if (!cfg || !cfg.data || !cfg.data.t || cfg.data.t.length === 0) return;

        var container = cfg.container;
        container.innerHTML = '';

        // Size SVG to fill container
        var rect = container.getBoundingClientRect();
        var width = Math.max(rect.width || 500, 400);
        var height = Math.max(rect.height || 380, 350);
        // Use a fixed viewBox aspect for consistency
        var vw = 500;
        var vh = 420;

        svgEl = d3.select(container)
            .append('svg')
            .attr('viewBox', '0 0 ' + vw + ' ' + vh)
            .attr('preserveAspectRatio', 'xMidYMid meet')
            .style('width', '100%')
            .style('height', '100%')
            .style('min-height', '360px')
            .style('display', 'block');

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var bgColor = isDark ? '#1e293b' : '#ffffff';
        var fgColor = isDark ? '#e2e8f0' : '#1e293b';
        var accentColor = '#7c3aed';
        var trailColor = isDark ? 'rgba(139, 92, 246, 0.3)' : 'rgba(124, 58, 237, 0.2)';

        svgEl.append('rect')
            .attr('width', vw)
            .attr('height', vh)
            .attr('fill', bgColor)
            .attr('rx', 8);

        config._w = vw;
        config._h = vh;
        config._fg = fgColor;
        config._accent = accentColor;
        config._trail = trailColor;
        config._isDark = isDark;

        switch (cfg.type) {
            case 'pendulum':
                initPendulum();
                break;
            case 'double_pendulum':
                initDoublePendulum();
                break;
            case 'spring_mass':
                initSpringMass();
                break;
            case 'kepler':
                initKepler();
                break;
            case 'coupled':
                initCoupled();
                break;
            default:
                initGenericPlot();
                break;
        }

        // Add system label
        var labels = {
            pendulum: 'Simple Pendulum',
            double_pendulum: 'Double Pendulum',
            spring_mass: 'Spring-Mass System',
            kepler: 'Kepler Orbit',
            coupled: 'Coupled Oscillators'
        };
        var label = labels[cfg.type] || 'System Animation';
        svgEl.append('text')
            .attr('x', vw / 2)
            .attr('y', 22)
            .attr('text-anchor', 'middle')
            .attr('fill', isDark ? '#94a3b8' : '#64748b')
            .attr('font-size', '13px')
            .attr('font-family', 'Inter, sans-serif')
            .attr('font-weight', '600')
            .text(label);

        updateTimeDisplay(0);
    }

    // ===== Simple Pendulum =====
    function initPendulum() {
        var w = config._w, h = config._h;
        var cx = w / 2, cy = 70;
        var L = Math.min(h * 0.55, 200); // visual rod length
        var data = config.data;
        var theta = data.q.theta || data.q[Object.keys(data.q)[0]] || [];

        var g = svgEl.append('g');

        // Pivot
        g.append('circle')
            .attr('cx', cx).attr('cy', cy).attr('r', 5)
            .attr('fill', config._fg);

        // Trail
        var trail = g.append('path')
            .attr('fill', 'none')
            .attr('stroke', config._trail)
            .attr('stroke-width', 2);

        // Rod
        var rod = g.append('line')
            .attr('x1', cx).attr('y1', cy)
            .attr('stroke', config._fg).attr('stroke-width', 2.5);

        // Bob
        var bob = g.append('circle')
            .attr('r', 14)
            .attr('fill', config._accent);

        var trailPoints = [];

        config._update = function(idx) {
            var th = theta[idx] || 0;
            var bx = cx + L * Math.sin(th);
            var by = cy + L * Math.cos(th);
            rod.attr('x2', bx).attr('y2', by);
            bob.attr('cx', bx).attr('cy', by);

            trailPoints.push([bx, by]);
            if (trailPoints.length > 120) trailPoints.shift();
            if (trailPoints.length > 1) {
                var d = 'M' + trailPoints[0][0] + ',' + trailPoints[0][1];
                for (var i = 1; i < trailPoints.length; i++) {
                    d += 'L' + trailPoints[i][0] + ',' + trailPoints[i][1];
                }
                trail.attr('d', d);
            }
        };
        config._resetTrail = function() { trailPoints.length = 0; trail.attr('d', ''); };
    }

    // ===== Double Pendulum =====
    function initDoublePendulum() {
        var w = config._w, h = config._h;
        var cx = w / 2, cy = 50;
        var armLen = Math.min(h * 0.35, 140);
        var L1 = armLen, L2 = armLen;
        var data = config.data;
        var qKeys = Object.keys(data.q);
        var theta1 = data.q[qKeys[0]] || [];
        var theta2 = data.q[qKeys[1]] || [];

        var g = svgEl.append('g');

        // Pivot
        g.append('circle')
            .attr('cx', cx).attr('cy', cy).attr('r', 4)
            .attr('fill', config._fg);

        // Trail for second bob
        var trail = g.append('path')
            .attr('fill', 'none')
            .attr('stroke', config._trail)
            .attr('stroke-width', 1.5);

        // Rod 1
        var rod1 = g.append('line')
            .attr('x1', cx).attr('y1', cy)
            .attr('stroke', config._fg).attr('stroke-width', 2);

        // Bob 1
        var bob1 = g.append('circle')
            .attr('r', 10)
            .attr('fill', '#ec4899');

        // Rod 2
        var rod2 = g.append('line')
            .attr('stroke', config._fg).attr('stroke-width', 2);

        // Bob 2
        var bob2 = g.append('circle')
            .attr('r', 10)
            .attr('fill', config._accent);

        var trailPoints = [];

        config._update = function(idx) {
            var th1 = theta1[idx] || 0;
            var th2 = theta2[idx] || 0;
            var x1 = cx + L1 * Math.sin(th1);
            var y1 = cy + L1 * Math.cos(th1);
            var x2 = x1 + L2 * Math.sin(th2);
            var y2 = y1 + L2 * Math.cos(th2);

            rod1.attr('x2', x1).attr('y2', y1);
            bob1.attr('cx', x1).attr('cy', y1);
            rod2.attr('x1', x1).attr('y1', y1).attr('x2', x2).attr('y2', y2);
            bob2.attr('cx', x2).attr('cy', y2);

            trailPoints.push([x2, y2]);
            if (trailPoints.length > 200) trailPoints.shift();
            if (trailPoints.length > 1) {
                var d = 'M' + trailPoints[0][0] + ',' + trailPoints[0][1];
                for (var i = 1; i < trailPoints.length; i++) {
                    d += 'L' + trailPoints[i][0] + ',' + trailPoints[i][1];
                }
                trail.attr('d', d);
            }
        };
        config._resetTrail = function() { trailPoints.length = 0; trail.attr('d', ''); };
    }

    // ===== Spring-Mass =====
    function initSpringMass() {
        var w = config._w, h = config._h;
        var wallX = 40, cy = h / 2;
        var restLen = 150;
        var data = config.data;
        var x = data.q.x || data.q[Object.keys(data.q)[0]] || [];
        var maxDisp = 0;
        for (var i = 0; i < x.length; i++) {
            if (Math.abs(x[i]) > maxDisp) maxDisp = Math.abs(x[i]);
        }
        var scale = maxDisp > 0 ? 80 / maxDisp : 80;

        var g = svgEl.append('g');

        // Wall
        g.append('line')
            .attr('x1', wallX).attr('y1', cy - 50)
            .attr('x2', wallX).attr('y2', cy + 50)
            .attr('stroke', config._fg).attr('stroke-width', 3);

        // Hatch marks on wall
        for (var hi = -4; hi <= 4; hi++) {
            g.append('line')
                .attr('x1', wallX - 8).attr('y1', cy + hi * 12)
                .attr('x2', wallX).attr('y2', cy + hi * 12 + 8)
                .attr('stroke', config._fg).attr('stroke-width', 1);
        }

        // Spring path
        var spring = g.append('path')
            .attr('fill', 'none')
            .attr('stroke', config._accent)
            .attr('stroke-width', 2);

        // Mass block
        var block = g.append('rect')
            .attr('width', 40).attr('height', 40)
            .attr('rx', 4).attr('ry', 4)
            .attr('fill', config._accent);

        // Label
        var label = g.append('text')
            .attr('text-anchor', 'middle')
            .attr('fill', '#fff')
            .attr('font-size', '14px')
            .attr('font-weight', '600')
            .text('m');

        function buildSpringPath(startX, endX, cy) {
            var coils = 12;
            var amplitude = 10;
            var d = 'M' + startX + ',' + cy;
            var len = endX - startX;
            for (var j = 0; j <= coils; j++) {
                var px = startX + (len * j) / coils;
                var py = cy + (j % 2 === 0 ? -1 : 1) * amplitude;
                if (j === 0 || j === coils) py = cy;
                d += 'L' + px + ',' + py;
            }
            return d;
        }

        config._update = function(idx) {
            var disp = (x[idx] || 0) * scale;
            var massX = wallX + restLen + disp;
            spring.attr('d', buildSpringPath(wallX, massX, cy));
            block.attr('x', massX).attr('y', cy - 20);
            label.attr('x', massX + 20).attr('y', cy + 5);
        };
        config._resetTrail = function() {};
    }

    // ===== Kepler Orbit =====
    function initKepler() {
        var w = config._w, h = config._h;
        var cx = w / 2, cy = h / 2;
        var data = config.data;
        var qKeys = Object.keys(data.q);
        var r = data.q[qKeys[0]] || [];
        var theta = data.q[qKeys[1]] || [];
        var maxR = 0;
        for (var i = 0; i < r.length; i++) {
            if (r[i] > maxR) maxR = r[i];
        }
        var scale = maxR > 0 ? 130 / maxR : 130;

        var g = svgEl.append('g');

        // Central body
        g.append('circle')
            .attr('cx', cx).attr('cy', cy).attr('r', 12)
            .attr('fill', '#f59e0b');

        // Trail
        var trail = g.append('path')
            .attr('fill', 'none')
            .attr('stroke', config._trail)
            .attr('stroke-width', 1.5);

        // Orbiting body
        var planet = g.append('circle')
            .attr('r', 7)
            .attr('fill', config._accent);

        var trailPoints = [];

        config._update = function(idx) {
            var rv = (r[idx] || 1) * scale;
            var th = theta[idx] || 0;
            var px = cx + rv * Math.cos(th);
            var py = cy + rv * Math.sin(th);
            planet.attr('cx', px).attr('cy', py);

            trailPoints.push([px, py]);
            if (trailPoints.length > 250) trailPoints.shift();
            if (trailPoints.length > 1) {
                var d = 'M' + trailPoints[0][0] + ',' + trailPoints[0][1];
                for (var i = 1; i < trailPoints.length; i++) {
                    d += 'L' + trailPoints[i][0] + ',' + trailPoints[i][1];
                }
                trail.attr('d', d);
            }
        };
        config._resetTrail = function() { trailPoints.length = 0; trail.attr('d', ''); };
    }

    // ===== Coupled Oscillators =====
    function initCoupled() {
        var w = config._w, h = config._h;
        var wallL = 30, wallR = w - 30, cy = h / 2;
        var data = config.data;
        var qKeys = Object.keys(data.q);
        var x1 = data.q[qKeys[0]] || [];
        var x2 = data.q[qKeys[1]] || [];
        var maxD = 0;
        for (var i = 0; i < x1.length; i++) {
            if (Math.abs(x1[i]) > maxD) maxD = Math.abs(x1[i]);
            if (Math.abs(x2[i]) > maxD) maxD = Math.abs(x2[i]);
        }
        var scale = maxD > 0 ? 50 / maxD : 50;
        var eq1 = (wallR - wallL) / 3 + wallL;
        var eq2 = 2 * (wallR - wallL) / 3 + wallL;

        var g = svgEl.append('g');

        // Walls
        g.append('line').attr('x1', wallL).attr('y1', cy - 40).attr('x2', wallL).attr('y2', cy + 40)
            .attr('stroke', config._fg).attr('stroke-width', 3);
        g.append('line').attr('x1', wallR).attr('y1', cy - 40).attr('x2', wallR).attr('y2', cy + 40)
            .attr('stroke', config._fg).attr('stroke-width', 3);

        // Springs
        var spring1 = g.append('path').attr('fill', 'none').attr('stroke', '#10b981').attr('stroke-width', 2);
        var spring2 = g.append('path').attr('fill', 'none').attr('stroke', config._accent).attr('stroke-width', 2);
        var spring3 = g.append('path').attr('fill', 'none').attr('stroke', '#10b981').attr('stroke-width', 2);

        // Masses
        var mass1 = g.append('rect').attr('width', 30).attr('height', 30).attr('rx', 3).attr('fill', '#ec4899');
        var mass2 = g.append('rect').attr('width', 30).attr('height', 30).attr('rx', 3).attr('fill', config._accent);

        var label1 = g.append('text').attr('text-anchor', 'middle').attr('fill', '#fff').attr('font-size', '12px').attr('font-weight', '600').text('m1');
        var label2 = g.append('text').attr('text-anchor', 'middle').attr('fill', '#fff').attr('font-size', '12px').attr('font-weight', '600').text('m2');

        function zigzag(sx, ex, yc) {
            var coils = 8, amp = 8;
            var d = 'M' + sx + ',' + yc;
            var len = ex - sx;
            for (var j = 0; j <= coils; j++) {
                var px = sx + (len * j) / coils;
                var py = yc + (j % 2 === 0 ? -1 : 1) * amp;
                if (j === 0 || j === coils) py = yc;
                d += 'L' + px + ',' + py;
            }
            return d;
        }

        config._update = function(idx) {
            var d1 = (x1[idx] || 0) * scale;
            var d2 = (x2[idx] || 0) * scale;
            var m1x = eq1 + d1;
            var m2x = eq2 + d2;
            mass1.attr('x', m1x - 15).attr('y', cy - 15);
            mass2.attr('x', m2x - 15).attr('y', cy - 15);
            label1.attr('x', m1x).attr('y', cy + 4);
            label2.attr('x', m2x).attr('y', cy + 4);
            spring1.attr('d', zigzag(wallL, m1x - 15, cy));
            spring2.attr('d', zigzag(m1x + 15, m2x - 15, cy));
            spring3.attr('d', zigzag(m2x + 15, wallR, cy));
        };
        config._resetTrail = function() {};
    }

    // ===== Generic (fallback: animated line marker) =====
    function initGenericPlot() {
        var w = config._w, h = config._h;
        var data = config.data;
        var qKeys = Object.keys(data.q);
        if (qKeys.length === 0) return;
        var qArr = data.q[qKeys[0]];
        var minQ = Infinity, maxQ = -Infinity;
        for (var i = 0; i < qArr.length; i++) {
            if (qArr[i] < minQ) minQ = qArr[i];
            if (qArr[i] > maxQ) maxQ = qArr[i];
        }
        var range = maxQ - minQ || 1;
        var margin = 40;

        var g = svgEl.append('g');

        // Draw axes
        g.append('line').attr('x1', margin).attr('y1', h - margin).attr('x2', w - margin).attr('y2', h - margin)
            .attr('stroke', config._fg).attr('stroke-width', 1);
        g.append('line').attr('x1', margin).attr('y1', margin).attr('x2', margin).attr('y2', h - margin)
            .attr('stroke', config._fg).attr('stroke-width', 1);

        // Plot line
        var scaleX = (w - 2 * margin) / (data.t.length - 1);
        var scaleY = (h - 2 * margin) / range;
        var d = '';
        for (var j = 0; j < qArr.length; j++) {
            var px = margin + j * scaleX;
            var py = h - margin - (qArr[j] - minQ) * scaleY;
            d += (j === 0 ? 'M' : 'L') + px + ',' + py;
        }
        g.append('path').attr('d', d).attr('fill', 'none').attr('stroke', config._accent).attr('stroke-width', 2);

        // Marker
        var marker = g.append('circle').attr('r', 6).attr('fill', '#ef4444');

        g.append('text').attr('x', w / 2).attr('y', h - 10).attr('text-anchor', 'middle')
            .attr('fill', config._fg).attr('font-size', '12px').text('t');
        g.append('text').attr('x', 12).attr('y', h / 2).attr('text-anchor', 'middle')
            .attr('fill', config._fg).attr('font-size', '12px')
            .attr('transform', 'rotate(-90, 12, ' + h / 2 + ')').text(qKeys[0]);

        config._update = function(idx) {
            var px = margin + idx * scaleX;
            var py = h - margin - (qArr[idx] - minQ) * scaleY;
            marker.attr('cx', px).attr('cy', py);
        };
        config._resetTrail = function() {};
    }

    // ===== Animation Loop =====
    function tick(timestamp) {
        if (!playing || !config || !config.data) return;
        if (!startTime) startTime = timestamp;

        var elapsed = (timestamp - startTime) * 0.001 * speed;
        var tArr = config.data.t;
        var tMax = tArr[tArr.length - 1] - tArr[0];

        var tCurrent = elapsed % tMax;
        // Find index
        var idx = 0;
        for (var i = 0; i < tArr.length - 1; i++) {
            if (tArr[i] - tArr[0] <= tCurrent) idx = i;
            else break;
        }

        // Reset trail on loop
        if (idx < currentIdx && config._resetTrail) {
            config._resetTrail();
        }
        currentIdx = idx;

        if (config._update) config._update(idx);
        updateTimeDisplay(tArr[idx]);

        animFrame = requestAnimationFrame(tick);
    }

    function updateTimeDisplay(t) {
        if (timeDisplay) timeDisplay.textContent = 't = ' + (t || 0).toFixed(2) + ' s';
    }

    function play() {
        if (playing) return;
        playing = true;
        startTime = null;
        animFrame = requestAnimationFrame(tick);
    }

    function pause() {
        playing = false;
        if (animFrame) cancelAnimationFrame(animFrame);
        animFrame = null;
    }

    function reset() {
        pause();
        currentIdx = 0;
        startTime = null;
        if (config && config._resetTrail) config._resetTrail();
        if (config && config._update) config._update(0);
        updateTimeDisplay(config && config.data ? config.data.t[0] : 0);
    }

    function setSpeed(s) {
        speed = s;
    }

    // ===== Public API =====
    window.LagrangianAnimations = {
        init: init,
        play: play,
        pause: pause,
        reset: reset,
        setSpeed: setSpeed,
        destroy: destroy
    };

})();
