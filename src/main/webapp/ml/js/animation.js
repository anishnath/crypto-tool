/* NN Animation Suite
   Forward pass, backprop, activation heatmap, dropout, training loop */

'use strict';

var NNAnimation = (function() {

    var playing = false;
    var looping = false;
    var speed = 1.0;
    var animTimers = [];     // track all pending timers
    var particleGroup = null;
    var animMode = 'forward';  // forward | backprop | training | dropout
    var generation = 0;      // incremented on stop — orphaned callbacks check this
    var origNodeRadius = {};  // stored before dropout shrink

    // Colors
    var FWD_COLOR = '#6366f1';
    var FWD_PARTICLE = '#818cf8';
    var FWD_TRAIL = '#c7d2fe';
    var BACK_COLOR = '#ef4444';
    var BACK_PARTICLE = '#f87171';
    var BACK_TRAIL = '#fecaca';
    var DROPOUT_COLOR = '#94a3b8';

    // Activation heatmap
    var showHeatmap = false;
    var heatmapScale = null;

    // Dropout
    var dropoutRate = 0.3;

    // Training state
    var epoch = 0;
    var maxEpochs = 10;
    var simLoss = 1.0;

    // ═══════════════════════════════════════
    //              FCNN ANIMATIONS
    // ═══════════════════════════════════════

    function animateFCNN(viz, mode) {
        if (!viz || !viz.graph || !viz.graph.nodes) return;

        var arch = viz.getArchitecture();
        var numLayers = arch.length;
        if (numLayers < 2) return;

        var g = viz.g();
        var nodeSelection = viz.node();
        var svg = viz.svg();

        ensureGlowFilter(svg);

        if (particleGroup) particleGroup.remove();
        particleGroup = g.append('g').attr('class', 'nn-particles');

        var nodesByLayer = [];
        for (var i = 0; i < numLayers; i++) {
            nodesByLayer.push(viz.graph.nodes.filter(function(n) { return n.layer === i; }));
        }

        var linksByLayer = [];
        for (var i = 0; i < numLayers - 1; i++) {
            (function(li) {
                linksByLayer.push(viz.graph.links.filter(function(l) {
                    return parseInt(l.source.split('_')[0]) === li;
                }));
            })(i);
        }

        // Compute simulated activations for heatmap
        var activations = computeActivations(arch, numLayers);

        // Compute dropout mask
        var dropoutMask = computeDropoutMask(arch, numLayers);

        // Dim everything
        nodeSelection.transition().duration(200).style('opacity', 0.15).style('fill', null);
        g.selectAll('.link').transition().duration(200).style('stroke-opacity', 0.05);

        // Remove any existing skip connection visuals
        g.selectAll('.nn-skip-conn').remove();

        var myGen = generation;
        function genOk() { return playing && generation === myGen; }

        if (mode === 'forward' || mode === 'training' || mode === 'dropout') {
            runForwardPass(nodeSelection, g, nodesByLayer, linksByLayer, numLayers, activations, dropoutMask, mode, function() {
                if (!genOk()) return;
                if (mode === 'training') {
                    animTimers.push(setTimeout(function() {
                        if (!genOk()) return;
                        runBackwardPass(nodeSelection, g, nodesByLayer, linksByLayer, numLayers, function() {
                            if (!genOk()) return;
                            updateWeights(viz, g);
                            epoch++;
                            simLoss = Math.max(0.01, simLoss * (0.7 + Math.random() * 0.2));
                            updateTrainingStatus();
                            if (genOk() && epoch < maxEpochs) {
                                animTimers.push(setTimeout(function() { if (genOk()) animateFCNN(viz, mode); }, 300 / speed));
                            } else {
                                finishAnimation(viz);
                            }
                        });
                    }, 200 / speed));
                } else {
                    if (looping && genOk()) {
                        animTimers.push(setTimeout(function() { if (genOk()) animateFCNN(viz, mode); }, 400 / speed));
                    } else {
                        finishAnimation(viz);
                    }
                }
            });
        } else if (mode === 'backprop') {
            runForwardPass(nodeSelection, g, nodesByLayer, linksByLayer, numLayers, activations, null, 'forward', function() {
                if (!genOk()) return;
                animTimers.push(setTimeout(function() {
                    if (!genOk()) return;
                    runBackwardPass(nodeSelection, g, nodesByLayer, linksByLayer, numLayers, function() {
                        if (!genOk()) return;
                        if (looping && genOk()) {
                            animTimers.push(setTimeout(function() { if (genOk()) animateFCNN(viz, mode); }, 400 / speed));
                        } else {
                            finishAnimation(viz);
                        }
                    });
                }, 200 / speed));
            });
        }
    }

    // ── Forward Pass ──

    function runForwardPass(nodeSelection, g, nodesByLayer, linksByLayer, numLayers, activations, dropoutMask, mode, onComplete) {
        var baseDuration = 600 / speed;
        var currentLayer = 0;

        function animateLayer() {
            if (!playing || currentLayer >= numLayers) {
                if (onComplete) onComplete();
                return;
            }

            var layerNodes = nodesByLayer[currentLayer];

            layerNodes.forEach(function(n, idx) {
                var nodeEl = nodeSelection.filter(function(d) { return d.id === n.id; });

                // Dropout: gray out dropped nodes
                if (mode === 'dropout' && dropoutMask && dropoutMask[n.id]) {
                    // Store original radius for restoration
                    var currentR = parseFloat(nodeEl.attr('r'));
                    origNodeRadius[n.id] = currentR;
                    nodeEl.transition()
                        .delay(idx * (20 / speed))
                        .duration(baseDuration * 0.3)
                        .style('opacity', 0.2)
                        .style('fill', DROPOUT_COLOR)
                        .attr('r', currentR * 0.6);
                    return;
                }

                // Heatmap color or default glow
                var color = FWD_COLOR;
                if (showHeatmap && activations[n.id] !== undefined) {
                    color = getHeatmapColor(activations[n.id]);
                }

                nodeEl.transition()
                    .delay(idx * (30 / speed))
                    .duration(baseDuration * 0.4)
                    .style('opacity', 1)
                    .style('fill', color)
                    .attr('filter', 'url(#nn-glow)')
                    .transition()
                    .duration(baseDuration * 0.6)
                    .style('fill', showHeatmap ? color : FWD_PARTICLE)
                    .attr('filter', null);
            });

            // Edges + particles
            if (currentLayer < numLayers - 1) {
                var layerLinks = linksByLayer[currentLayer];
                var edgeDuration = baseDuration * 1.2;

                // Filter out links to dropped nodes
                var activeLinks = layerLinks;
                if (mode === 'dropout' && dropoutMask) {
                    activeLinks = layerLinks.filter(function(l) {
                        return !dropoutMask[l.source] && !dropoutMask[l.target];
                    });
                }

                activeLinks.forEach(function(l, idx) {
                    var linkEl = g.selectAll('.link').filter(function(d) { return d.id === l.id; });
                    linkEl.transition()
                        .delay(idx * (5 / speed))
                        .duration(edgeDuration * 0.3)
                        .style('stroke-opacity', 0.8)
                        .style('stroke', FWD_COLOR)
                        .transition()
                        .duration(edgeDuration * 0.7)
                        .style('stroke-opacity', 0.25)
                        .style('stroke', FWD_TRAIL);
                });

                spawnParticles(activeLinks, g, edgeDuration, FWD_PARTICLE);
            }

            currentLayer++;
            animTimers.push(setTimeout(animateLayer, baseDuration * 1.4));
        }

        animateLayer();
    }

    // ── Backward Pass ──

    function runBackwardPass(nodeSelection, g, nodesByLayer, linksByLayer, numLayers, onComplete) {
        var baseDuration = 500 / speed;
        var currentLayer = numLayers - 1;

        // Brief pause, then dim forward colors
        nodeSelection.transition().duration(150)
            .style('fill', null).style('opacity', 0.2).attr('filter', null);
        g.selectAll('.link').transition().duration(150)
            .style('stroke-opacity', 0.05).style('stroke', null);

        if (particleGroup) particleGroup.selectAll('*').remove();

        function animateLayer() {
            if (!playing || currentLayer < 0) {
                if (onComplete) onComplete();
                return;
            }

            var layerNodes = nodesByLayer[currentLayer];

            layerNodes.forEach(function(n, idx) {
                var nodeEl = nodeSelection.filter(function(d) { return d.id === n.id; });
                // Gradient magnitude visualization — random intensity
                var intensity = 0.4 + Math.random() * 0.6;
                var color = d3.interpolateRgb('#fecaca', BACK_COLOR)(intensity);

                nodeEl.transition()
                    .delay(idx * (25 / speed))
                    .duration(baseDuration * 0.4)
                    .style('opacity', 1)
                    .style('fill', color)
                    .attr('filter', 'url(#nn-glow)')
                    .transition()
                    .duration(baseDuration * 0.5)
                    .style('fill', BACK_PARTICLE)
                    .attr('filter', null);
            });

            // Animate edges backward
            if (currentLayer > 0) {
                var prevLayerLinks = linksByLayer[currentLayer - 1];
                var edgeDuration = baseDuration * 1.0;

                prevLayerLinks.forEach(function(l, idx) {
                    var linkEl = g.selectAll('.link').filter(function(d) { return d.id === l.id; });
                    // Vary edge width by simulated gradient
                    var gradMag = Math.random();
                    linkEl.transition()
                        .delay(idx * (4 / speed))
                        .duration(edgeDuration * 0.3)
                        .style('stroke-opacity', 0.3 + gradMag * 0.6)
                        .style('stroke', BACK_COLOR)
                        .style('stroke-width', function() { return 0.5 + gradMag * 2.5; })
                        .transition()
                        .duration(edgeDuration * 0.7)
                        .style('stroke-opacity', 0.15)
                        .style('stroke', BACK_TRAIL)
                        .style('stroke-width', null);
                });

                spawnParticlesReverse(prevLayerLinks, g, edgeDuration);
            }

            currentLayer--;
            animTimers.push(setTimeout(animateLayer, baseDuration * 1.2));
        }

        animTimers.push(setTimeout(animateLayer, 300 / speed));
    }

    // ── Weight Update Visual ──

    function updateWeights(viz, g) {
        // Flash all edges briefly to show weight update
        g.selectAll('.link')
            .transition().duration(150)
            .style('stroke', '#fbbf24')
            .style('stroke-opacity', 0.9)
            .style('stroke-width', 1.5)
            .transition().duration(300)
            .style('stroke', null)
            .style('stroke-opacity', null)
            .style('stroke-width', null);
    }

    // ── Particles ──

    function spawnParticles(links, g, duration, color) {
        var sampled = links.length > 60
            ? links.filter(function(_, i) { return i % Math.ceil(links.length / 60) === 0; })
            : links;

        sampled.forEach(function(l, idx) {
            var linkEl = g.selectAll('.link').filter(function(d) { return d.id === l.id; });
            var pathNode = linkEl.node();
            if (!pathNode || !pathNode.getTotalLength) return;

            var totalLength = pathNode.getTotalLength();
            var particle = particleGroup.append('circle')
                .attr('r', 2.5).attr('fill', color || FWD_PARTICLE)
                .attr('opacity', 0.9).attr('filter', 'url(#nn-glow)');

            var startPoint = pathNode.getPointAtLength(0);
            particle.attr('cx', startPoint.x).attr('cy', startPoint.y);

            particle.transition()
                .delay(idx * (3 / speed))
                .duration(duration * 0.8)
                .ease(d3.easeCubicInOut)
                .attrTween('cx', function() { return function(t) { return pathNode.getPointAtLength(t * totalLength).x; }; })
                .attrTween('cy', function() { return function(t) { return pathNode.getPointAtLength(t * totalLength).y; }; })
                .transition().duration(200).attr('opacity', 0).remove();
        });
    }

    function spawnParticlesReverse(links, g, duration) {
        var sampled = links.length > 60
            ? links.filter(function(_, i) { return i % Math.ceil(links.length / 60) === 0; })
            : links;

        sampled.forEach(function(l, idx) {
            var linkEl = g.selectAll('.link').filter(function(d) { return d.id === l.id; });
            var pathNode = linkEl.node();
            if (!pathNode || !pathNode.getTotalLength) return;

            var totalLength = pathNode.getTotalLength();
            var particle = particleGroup.append('circle')
                .attr('r', 2).attr('fill', BACK_PARTICLE)
                .attr('opacity', 0.85).attr('filter', 'url(#nn-glow)');

            var endPoint = pathNode.getPointAtLength(totalLength);
            particle.attr('cx', endPoint.x).attr('cy', endPoint.y);

            particle.transition()
                .delay(idx * (3 / speed))
                .duration(duration * 0.8)
                .ease(d3.easeCubicInOut)
                .attrTween('cx', function() { return function(t) { return pathNode.getPointAtLength((1 - t) * totalLength).x; }; })
                .attrTween('cy', function() { return function(t) { return pathNode.getPointAtLength((1 - t) * totalLength).y; }; })
                .transition().duration(200).attr('opacity', 0).remove();
        });
    }

    // ── Activation Heatmap ──

    function computeActivations(arch, numLayers) {
        var activations = {};
        for (var i = 0; i < numLayers; i++) {
            for (var j = 0; j < arch[i]; j++) {
                var id = i + '_' + j;
                if (i === 0) {
                    activations[id] = Math.random();
                } else {
                    // Simulated ReLU: some neurons "dead"
                    var raw = Math.random() * 2 - 0.5;
                    activations[id] = Math.max(0, raw); // ReLU
                }
            }
        }
        return activations;
    }

    function getHeatmapColor(val) {
        // 0 = dead (gray), low = blue, high = red
        if (val <= 0.01) return '#64748b'; // dead neuron
        // Clamp to [0,1]
        var v = Math.min(1, Math.max(0, val));
        return d3.interpolateRdYlBu(1 - v); // red=hot, blue=cold
    }

    // ── Dropout Mask ──

    function computeDropoutMask(arch, numLayers) {
        var mask = {};
        for (var i = 1; i < numLayers - 1; i++) { // Never drop input or output
            for (var j = 0; j < arch[i]; j++) {
                if (Math.random() < dropoutRate) {
                    mask[i + '_' + j] = true;
                }
            }
        }
        return mask;
    }

    // ── LeNet Animation ──

    function animateLeNet(viz, mode) {
        if (!viz) return;

        var g = (viz.g && typeof viz.g === 'function') ? viz.g() : d3.select('#nn-graph-container svg g');
        var rects = g.selectAll('.rect');
        var polys = g.selectAll('.poly');

        if (rects.empty()) { playing = false; updateButton(); return; }

        var layers = [];
        rects.each(function(d) { if (layers.indexOf(d.layer) === -1) layers.push(d.layer); });
        polys.each(function(d) { if (layers.indexOf(d.layer) === -1) layers.push(d.layer); });
        layers.sort(function(a, b) { return a - b; });

        var isBackward = (mode === 'backprop');
        var orderedLayers = isBackward ? layers.slice().reverse() : layers;
        var color = isBackward ? BACK_COLOR : FWD_COLOR;
        var trail = isBackward ? BACK_TRAIL : FWD_TRAIL;

        // Dim
        rects.transition().duration(200).style('opacity', 0.1);
        g.selectAll('.conv').transition().duration(200).style('stroke-opacity', 0.1);
        polys.transition().duration(200).style('opacity', 0.1);
        g.selectAll('.link').transition().duration(200).style('stroke-opacity', 0.05);
        g.selectAll('.line').transition().duration(200).style('stroke-opacity', 0.05);

        var baseDuration = 500 / speed;
        var currentIdx = 0;

        function step() {
            if (!playing || currentIdx >= orderedLayers.length) {
                if (mode === 'backprop' && !isBackward) {
                    // We just finished forward, now do backward
                    // (handled by caller)
                }
                if (looping && playing) {
                    currentIdx = 0;
                    rects.transition().duration(200).style('opacity', 0.1);
                    polys.transition().duration(200).style('opacity', 0.1);
                    g.selectAll('.link').transition().duration(200).style('stroke-opacity', 0.05);
                    g.selectAll('.line').transition().duration(200).style('stroke-opacity', 0.05);
                    animTimers.push(setTimeout(step, 400 / speed));
                    return;
                }
                finishLeNet(g, rects, polys);
                return;
            }

            var layer = orderedLayers[currentIdx];

            rects.filter(function(d) { return d.layer === layer; })
                .transition().duration(baseDuration * 0.5)
                .style('opacity', 1).style('fill', color)
                .transition().duration(baseDuration * 0.5)
                .style('fill', null).style('opacity', 0.8);

            polys.filter(function(d) { return d.layer === layer; })
                .transition().duration(baseDuration * 0.5)
                .style('opacity', 1).style('fill', color)
                .transition().duration(baseDuration * 0.5)
                .style('fill', null).style('opacity', 0.8);

            g.selectAll('.link').filter(function(d) { return d.layer === layer; })
                .transition().duration(baseDuration)
                .style('stroke-opacity', 0.8).style('stroke', color)
                .transition().duration(baseDuration * 0.5)
                .style('stroke-opacity', 0.3).style('stroke', null);

            g.selectAll('.line').filter(function(d) { return d.layer === layer; })
                .transition().duration(baseDuration)
                .style('stroke-opacity', 0.8).style('stroke', color)
                .transition().duration(baseDuration * 0.5)
                .style('stroke-opacity', 0.3).style('stroke', null);

            currentIdx++;
            animTimers.push(setTimeout(step, baseDuration * 1.2));
        }

        step();
    }

    function finishLeNet(g, rects, polys) {
        playing = false;
        updateButton();
        rects.transition().duration(400).style('opacity', null).style('fill', null);
        polys.transition().duration(400).style('opacity', null).style('fill', null);
        g.selectAll('.conv').transition().duration(400).style('stroke-opacity', null);
        g.selectAll('.link').transition().duration(400).style('stroke-opacity', null).style('stroke', null);
        g.selectAll('.line').transition().duration(400).style('stroke-opacity', null).style('stroke', null);
    }

    // ── Helpers ──

    function ensureGlowFilter(svg) {
        var defs = svg.select('defs');
        if (defs.empty()) defs = svg.append('defs');
        if (defs.select('#nn-glow').empty()) {
            var filter = defs.append('filter').attr('id', 'nn-glow')
                .attr('x', '-50%').attr('y', '-50%').attr('width', '200%').attr('height', '200%');
            filter.append('feGaussianBlur').attr('stdDeviation', '3').attr('result', 'blur');
            filter.append('feComposite').attr('in', 'SourceGraphic').attr('in2', 'blur').attr('operator', 'over');
        }
    }

    function finishAnimation(viz) {
        playing = false;
        updateButton();
        updateTrainingStatus();

        if (!viz) return;
        var nodeSelection = typeof viz.node === 'function' ? viz.node() : null;
        var g = viz.g ? viz.g() : d3.select('#nn-graph-container svg g');

        if (nodeSelection) {
            nodeSelection.transition().duration(400)
                .style('opacity', 1).style('fill', null).attr('filter', null);
            // Restore original radius for dropout-shrunk nodes
            nodeSelection.each(function(d) {
                var orig = origNodeRadius[d.id];
                if (orig) d3.select(this).transition().duration(400).attr('r', orig);
            });
            origNodeRadius = {};
        }
        g.selectAll('.link').transition().duration(400)
            .style('stroke-opacity', null).style('stroke', null).style('stroke-width', null);

        if (particleGroup) {
            particleGroup.transition().duration(300).attr('opacity', 0).remove();
            particleGroup = null;
        }
    }

    function updateTrainingStatus() {
        var el = document.getElementById('nn-training-status');
        if (!el) return;
        if (animMode === 'training' && playing) {
            el.style.display = 'block';
            el.innerHTML = 'Epoch <strong>' + epoch + '/' + maxEpochs + '</strong> &mdash; Loss: <strong>' + simLoss.toFixed(4) + '</strong>';
        } else if (animMode === 'training' && !playing && epoch > 0) {
            el.innerHTML = 'Training complete &mdash; ' + epoch + ' epochs &mdash; Final loss: <strong>' + simLoss.toFixed(4) + '</strong>';
        } else {
            el.style.display = 'none';
        }
    }

    function updateButton() {
        var btn = document.getElementById('nn-play-btn');
        if (!btn) return;
        if (playing) {
            btn.innerHTML = '<span class="nn-play-icon">&#9646;&#9646;</span> Pause';
            btn.classList.add('nn-playing');
        } else {
            var labels = { forward: 'Forward Pass', backprop: 'Forward + Backprop', training: 'Train', dropout: 'Dropout' };
            btn.innerHTML = '<span class="nn-play-icon">&#9654;</span> ' + (labels[animMode] || 'Play');
            btn.classList.remove('nn-playing');
        }
    }

    // ── Public API ──

    function play(mode, viz) {
        if (playing) { stop(viz); return; }
        playing = true;

        if (animMode === 'training') {
            epoch = 0;
            simLoss = 1.0;
        }

        updateButton();
        updateTrainingStatus();

        var vizMode = mode; // fcnn | lenet | alexnet

        if (vizMode === 'fcnn') {
            animateFCNN(viz, animMode);
        } else if (vizMode === 'lenet') {
            animateLeNet(viz, animMode);
        } else if (vizMode === 'alexnet') {
            // Basic layer pulse for 3D
            playing = false;
            updateButton();
        }
    }

    function stop(viz) {
        playing = false;
        generation++;  // invalidate any in-flight callbacks

        // Clear ALL pending timers
        animTimers.forEach(function(t) { clearTimeout(t); });
        animTimers = [];

        var g = d3.select('#nn-graph-container svg g');
        if (!g.empty()) g.selectAll('*').interrupt();

        if (particleGroup) { particleGroup.remove(); particleGroup = null; }

        // Restore node styles + radius (fix dropout shrink)
        if (viz) {
            var ns = typeof viz.node === 'function' ? viz.node() : null;
            if (ns) {
                ns.style('opacity', 1).style('fill', null).attr('filter', null);
                // Restore original radius from stored values or from viz
                ns.each(function(d) {
                    var orig = origNodeRadius[d.id];
                    if (orig) d3.select(this).attr('r', orig);
                });
            }
        }
        origNodeRadius = {};

        var gSel = d3.select('#nn-graph-container svg g');
        gSel.selectAll('.link').style('stroke-opacity', null).style('stroke', null).style('stroke-width', null);
        gSel.selectAll('.rect').style('opacity', null).style('fill', null);
        gSel.selectAll('.conv').style('stroke-opacity', null);
        gSel.selectAll('.poly').style('opacity', null).style('fill', null);
        gSel.selectAll('.line').style('stroke-opacity', null).style('stroke', null);

        updateButton();
        updateTrainingStatus();
    }

    function setSpeed(val) { speed = Math.max(0.25, Math.min(3, val)); }
    function setLoop(val) { looping = val; }
    function setMode(m) { animMode = m; updateButton(); }
    function setHeatmap(val) { showHeatmap = val; }
    function setDropoutRate(val) { dropoutRate = Math.max(0, Math.min(0.9, val)); }
    function setMaxEpochs(val) { maxEpochs = Math.max(1, Math.min(100, val)); }
    function isPlaying() { return playing; }

    return {
        play: play,
        stop: stop,
        setSpeed: setSpeed,
        setLoop: setLoop,
        setMode: setMode,
        setHeatmap: setHeatmap,
        setDropoutRate: setDropoutRate,
        setMaxEpochs: setMaxEpochs,
        isPlaying: isPlaying
    };

})();
