/* NN-SVG Controls — Tab switching, dynamic layer management, event wiring */

'use strict';

(function() {

    var currentMode = 'fcnn';
    var currentViz = null;
    var threeLoaded = false;
    var graphContainer;

    // ── Init ──

    document.addEventListener('DOMContentLoaded', function() {
        graphContainer = document.getElementById('nn-graph-container');

        // Tab switching
        document.querySelectorAll('.nn-tab-btn').forEach(function(btn) {
            btn.addEventListener('click', function() {
                switchTab(this.getAttribute('data-tab'));
            });
        });

        // Start FCNN
        switchTab('fcnn');
    });

    // ── Tab switching ──

    function switchTab(mode) {
        // Stop any running animation
        if (typeof NNAnimation !== 'undefined') { NNAnimation.stop(currentViz); }

        if (currentViz && currentViz.destroy) { currentViz.destroy(); }
        currentViz = null;

        currentMode = mode;

        // Update tab buttons
        document.querySelectorAll('.nn-tab-btn').forEach(function(b) { b.classList.remove('active'); });
        document.querySelector('.nn-tab-btn[data-tab="' + mode + '"]').classList.add('active');

        // Update control panels
        document.querySelectorAll('.nn-tab-panel').forEach(function(p) { p.classList.remove('active'); });
        document.getElementById('controls-' + mode).classList.add('active');

        // Clear canvas
        graphContainer.innerHTML = '';

        if (mode === 'fcnn') { initFCNN(); }
        else if (mode === 'lenet') { initLeNet(); }
        else if (mode === 'alexnet') { initAlexNet(); }

        populatePresets();
        updateStatus();
    }

    // ── FCNN ──

    function initFCNN() {
        currentViz = FCNN(graphContainer);
        // Apply best default preset on first load
        if (typeof NNPresets !== 'undefined' && NNPresets.fcnn['Diamond']) {
            applyPreset('Diamond');
        } else {
            restartFCNN();
        }
        wireFCNNControls();
        // Set dropdown to match
        var sel = document.getElementById('nn-preset');
        if (sel) sel.value = 'Diamond';
    }

    function restartFCNN() {
        var rows = document.querySelectorAll('#fcnn-arch .nn-arch-row');
        var architecture = [];
        var betweenNodesInLayer = [];
        rows.forEach(function(row) {
            var nodeInput = row.querySelector('input[name="fcnn-nodes"]');
            var spacingInput = row.querySelector('input[name="fcnn-spacing"]');
            if (nodeInput && nodeInput.value && !isNaN(parseInt(nodeInput.value))) {
                architecture.push(parseInt(nodeInput.value));
                betweenNodesInLayer.push(spacingInput ? parseFloat(spacingInput.value) : 20);
            }
        });
        if (architecture.length < 2) architecture = [8, 12, 8];
        if (betweenNodesInLayer.length < architecture.length) {
            while (betweenNodesInLayer.length < architecture.length) betweenNodesInLayer.push(20);
        }

        currentViz.redraw({architecture_: architecture});
        currentViz.redistribute({betweenNodesInLayer_: betweenNodesInLayer});
        if (currentViz.drawSkipConnections) currentViz.drawSkipConnections();
        updateStatus();
    }

    function wireFCNNControls() {
        bindChange('fcnn-edgeWidthProp', function(v) { currentViz.style({edgeWidthProportional_: v}); }, 'checked');
        bindChange('fcnn-edgeWidth', function(v) { currentViz.style({edgeWidth_: v}); }, 'float');
        bindChange('fcnn-edgeOpacityProp', function(v) { currentViz.style({edgeOpacityProportional_: v}); }, 'checked');
        bindChange('fcnn-edgeOpacity', function(v) { currentViz.style({edgeOpacity_: v}); }, 'float');
        bindChange('fcnn-edgeColorProp', function(v) { currentViz.style({edgeColorProportional_: v}); }, 'checked');
        bindChange('fcnn-negativeColor', function(v) { currentViz.style({negativeEdgeColor_: v}); });
        bindChange('fcnn-positiveColor', function(v) { currentViz.style({positiveEdgeColor_: v}); });
        bindChange('fcnn-defaultColor', function(v) { currentViz.style({defaultEdgeColor_: v}); });
        bindChange('fcnn-bezier', function(v) { currentViz.redistribute({bezierCurves_: v}); }, 'checked');
        bindChange('fcnn-nodeDiameter', function(v) { currentViz.style({nodeDiameter_: v}); }, 'float');
        bindChange('fcnn-nodeColor', function(v) { currentViz.style({nodeColor_: v}); });
        bindChange('fcnn-nodeBorderColor', function(v) { currentViz.style({nodeBorderColor_: v}); });
        bindChange('fcnn-betweenLayers', function(v) { currentViz.redistribute({betweenLayers_: v}); }, 'float');
        bindChange('fcnn-showBias', function(v) { currentViz.redraw({showBias_: v}); currentViz.redistribute(); }, 'checked');
        bindChange('fcnn-showLabels', function(v) { currentViz.redraw({showLabels_: v}); }, 'checked');
        bindChange('fcnn-showArrowheads', function(v) { currentViz.style({showArrowheads_: v}); }, 'checked');

        document.querySelectorAll('input[name="fcnn-direction"]').forEach(function(radio) {
            radio.addEventListener('change', function() { currentViz.redistribute({nnDirection_: this.value}); });
        });
        document.querySelectorAll('input[name="fcnn-arrowStyle"]').forEach(function(radio) {
            radio.addEventListener('change', function() { currentViz.style({arrowheadStyle_: this.value}); });
        });

        var el = document.getElementById('fcnn-newWeights');
        if (el) el.addEventListener('click', function() {
            currentViz.redraw();
            currentViz.redistribute();
            if (currentViz.drawSkipConnections) currentViz.drawSkipConnections();
        });

        // Skip connections
        var fcnnSkips = [];
        var skipAddBtn = document.getElementById('fcnn-skip-add');
        if (skipAddBtn) skipAddBtn.addEventListener('click', function(e) {
            e.preventDefault();
            var from = parseInt(document.getElementById('fcnn-skip-from').value);
            var to = parseInt(document.getElementById('fcnn-skip-to').value);
            if (isNaN(from) || isNaN(to) || from >= to) return;
            // Avoid duplicates
            var exists = fcnnSkips.some(function(s) { return s.from === from && s.to === to; });
            if (exists) return;
            fcnnSkips.push({from: from, to: to});
            renderSkipList();
            if (currentViz && currentViz.setSkipConnections) {
                currentViz.setSkipConnections(fcnnSkips);
            }
        });

        function renderSkipList() {
            var listEl = document.getElementById('fcnn-skip-list');
            if (!listEl) return;
            listEl.innerHTML = '';
            fcnnSkips.forEach(function(skip, idx) {
                var tag = document.createElement('span');
                tag.className = 'nn-skip-tag';
                tag.innerHTML = 'Layer ' + skip.from + ' &rarr; ' + skip.to +
                    ' <button class="nn-skip-remove" data-idx="' + idx + '">&times;</button>';
                listEl.appendChild(tag);
            });
            listEl.querySelectorAll('.nn-skip-remove').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    fcnnSkips.splice(parseInt(this.getAttribute('data-idx')), 1);
                    renderSkipList();
                    if (currentViz && currentViz.setSkipConnections) {
                        currentViz.setSkipConnections(fcnnSkips);
                    }
                });
            });
        }

        // Dynamic architecture rows
        document.getElementById('fcnn-arch').addEventListener('click', function(e) {
            var btn = e.target.closest('.nn-arch-btn');
            if (!btn) return;
            e.preventDefault();
            if (btn.classList.contains('nn-arch-btn-add')) {
                addFCNNLayer(btn.closest('.nn-arch-row'));
            } else if (btn.classList.contains('nn-arch-btn-remove')) {
                var row = btn.closest('.nn-arch-row');
                if (document.querySelectorAll('#fcnn-arch .nn-arch-row').length > 2) {
                    row.remove();
                    restartFCNN();
                }
            }
        });

        document.getElementById('fcnn-arch').addEventListener('change', function(e) {
            if (e.target.name === 'fcnn-nodes' || e.target.name === 'fcnn-spacing') {
                restartFCNN();
            }
        });
    }

    function addFCNNLayer(afterRow) {
        var newRow = afterRow.cloneNode(true);
        newRow.querySelector('input[name="fcnn-nodes"]').value = '8';
        // Convert add button to remove button in all rows except last
        var archDiv = document.getElementById('fcnn-arch');
        afterRow.parentNode.insertBefore(newRow, afterRow.nextSibling);

        // Ensure only the last row has an add button
        archDiv.querySelectorAll('.nn-arch-row').forEach(function(row, i, rows) {
            var btn = row.querySelector('.nn-arch-btn');
            if (i === rows.length - 1) {
                btn.className = 'nn-arch-btn nn-arch-btn-add';
                btn.innerHTML = '+';
            } else {
                btn.className = 'nn-arch-btn nn-arch-btn-remove';
                btn.innerHTML = '&minus;';
            }
        });

        restartFCNN();
    }

    // ── LeNet ──

    function initLeNet() {
        currentViz = LeNet(graphContainer);
        restartLeNet();
        wireLeNetControls();
    }

    function getLeNetArchitecture() {
        var arch = [];
        document.querySelectorAll('#lenet-arch .nn-arch-row').forEach(function(row) {
            var inputs = row.querySelectorAll('input[type="number"]');
            if (inputs.length >= 5) {
                arch.push({
                    numberOfSquares: parseInt(inputs[0].value) || 1,
                    squareHeight: parseInt(inputs[1].value) || 28,
                    squareWidth: parseInt(inputs[2].value) || 28,
                    filterHeight: parseInt(inputs[3].value) || 5,
                    filterWidth: parseInt(inputs[4].value) || 5,
                    op: row.querySelector('select') ? row.querySelector('select').value : 'Convolution'
                });
            }
        });
        if (arch.length === 0) {
            arch = [
                {numberOfSquares: 1, squareHeight: 28, squareWidth: 28, filterHeight: 5, filterWidth: 5, op: 'Convolution'},
                {numberOfSquares: 6, squareHeight: 24, squareWidth: 24, filterHeight: 2, filterWidth: 2, op: 'Max-Pool'},
                {numberOfSquares: 16, squareHeight: 8, squareWidth: 8, filterHeight: 5, filterWidth: 5, op: 'Convolution'}
            ];
        }
        return arch;
    }

    function getLeNetFC() {
        var fc = [];
        document.querySelectorAll('#lenet-fc input[name="lenet-fc-size"]').forEach(function(inp) {
            var val = parseInt(inp.value);
            if (!isNaN(val)) fc.push(val);
        });
        return fc;
    }

    function restartLeNet() {
        var arch = getLeNetArchitecture();
        var fc = getLeNetFC();
        currentViz.redraw({architecture_: arch, architecture2_: fc});
        currentViz.redistribute();
        updateStatus();
    }

    function wireLeNetControls() {
        bindChange('lenet-color1', function(v) { currentViz.style({color1_: v}); });
        bindChange('lenet-color2', function(v) { currentViz.style({color2_: v}); });
        bindChange('lenet-borderWidth', function(v) { currentViz.style({borderWidth_: v}); }, 'float');
        bindChange('lenet-opacity', function(v) { currentViz.style({rectOpacity_: v}); }, 'float');
        bindChange('lenet-showLabels', function(v) { currentViz.style({showLabels_: v}); }, 'checked');
        bindChange('lenet-betweenSquares', function(v) { currentViz.redistribute({betweenSquares_: v}); }, 'float');

        document.getElementById('lenet-arch').addEventListener('change', restartLeNet);
        document.getElementById('lenet-fc').addEventListener('change', restartLeNet);
    }

    // ── AlexNet ──

    function initAlexNet() {
        if (threeLoaded) {
            createAlexNet();
            return;
        }

        graphContainer.innerHTML = '<div style="padding:2rem;color:#888;">Loading Three.js...</div>';

        loadScript('https://cdn.jsdelivr.net/npm/three@0.137.0/build/three.min.js', function() {
            loadScript('https://cdn.jsdelivr.net/npm/three@0.137.0/examples/js/controls/OrbitControls.js', function() {
                threeLoaded = true;
                graphContainer.innerHTML = '';
                createAlexNet();
            }, function() {
                graphContainer.innerHTML = '<div style="padding:2rem;color:#e74c3c;">Failed to load Three.js OrbitControls.</div>';
            });
        }, function() {
            graphContainer.innerHTML = '<div style="padding:2rem;color:#e74c3c;">Failed to load Three.js. Check your connection.</div>';
        });
    }

    function createAlexNet() {
        currentViz = AlexNet(graphContainer);
        restartAlexNet();
        wireAlexNetControls();
    }

    function getAlexNetArchitecture() {
        var arch = [];
        document.querySelectorAll('#alexnet-arch .nn-arch-row').forEach(function(row) {
            var inputs = row.querySelectorAll('input[type="number"]');
            if (inputs.length >= 5) {
                arch.push({
                    height: parseInt(inputs[0].value) || 32,
                    width: parseInt(inputs[1].value) || 32,
                    depth: parseInt(inputs[2].value) || 3,
                    filterHeight: parseInt(inputs[3].value) || 5,
                    filterWidth: parseInt(inputs[4].value) || 5,
                    rel_x: NNUtil.rand(-0.3, 0.3),
                    rel_y: NNUtil.rand(-0.3, 0.3)
                });
            }
        });
        if (arch.length === 0) {
            arch = [
                {height: 227, width: 227, depth: 3, filterHeight: 11, filterWidth: 11, rel_x: 0.1, rel_y: 0.1},
                {height: 55, width: 55, depth: 64, filterHeight: 5, filterWidth: 5, rel_x: -0.1, rel_y: 0.1},
                {height: 27, width: 27, depth: 192, filterHeight: 3, filterWidth: 3, rel_x: 0.1, rel_y: -0.1}
            ];
        }
        return arch;
    }

    function getAlexNetFC() {
        var fc = [];
        document.querySelectorAll('#alexnet-fc input[name="alexnet-fc-size"]').forEach(function(inp) {
            var val = parseInt(inp.value);
            if (!isNaN(val)) fc.push(val);
        });
        return fc;
    }

    function restartAlexNet() {
        var arch = getAlexNetArchitecture();
        var fc = getAlexNetFC();
        currentViz.redraw({architecture_: arch, architecture2_: fc});
        updateStatus();
    }

    var alexnetRedrawTimer = null;
    function debouncedRestartAlexNet() {
        if (alexnetRedrawTimer) clearTimeout(alexnetRedrawTimer);
        alexnetRedrawTimer = setTimeout(restartAlexNet, 150);
    }

    function wireAlexNetControls() {
        bindChange('alexnet-color1', function(v) { currentViz.style({color1_: v}); });
        bindChange('alexnet-color2', function(v) { currentViz.style({color2_: v}); });
        bindChange('alexnet-color3', function(v) { currentViz.style({color3_: v}); });
        bindChange('alexnet-rectOpacity', function(v) { currentViz.style({rectOpacity_: v}); }, 'float');
        bindChange('alexnet-filterOpacity', function(v) { currentViz.style({filterOpacity_: v}); }, 'float');
        bindChange('alexnet-showDims', function(v) { restartAlexNet(); }, 'checked');
        bindChange('alexnet-showConvDims', function(v) { restartAlexNet(); }, 'checked');
        bindChange('alexnet-logDepth', function(v) { debouncedRestartAlexNet(); }, 'checked');
        bindChange('alexnet-depthScale', function(v) { debouncedRestartAlexNet(); }, 'float');
        bindChange('alexnet-logWidth', function(v) { debouncedRestartAlexNet(); }, 'checked');
        bindChange('alexnet-widthScale', function(v) { debouncedRestartAlexNet(); }, 'float');
        bindChange('alexnet-betweenLayers', function(v) { debouncedRestartAlexNet(); }, 'float');

        document.getElementById('alexnet-arch').addEventListener('change', restartAlexNet);
        document.getElementById('alexnet-fc').addEventListener('change', restartAlexNet);
    }

    // ── Play / Animation ──

    window.nnPlay = function() {
        NNAnimation.play(currentMode, currentViz);
    };

    window.nnRecord = function() {
        var container = document.getElementById('nn-graph-container');
        NNGifExport.toggle(container);
    };

    // Wire animation + preset controls on DOMContentLoaded
    document.addEventListener('DOMContentLoaded', function() {
        // Speed
        bindChange('nn-speed', function(v) { NNAnimation.setSpeed(v); }, 'float');
        // Loop
        var loopEl = document.getElementById('nn-loop');
        if (loopEl) loopEl.addEventListener('change', function() { NNAnimation.setLoop(this.checked); });
        // Heatmap
        var hmEl = document.getElementById('nn-heatmap');
        if (hmEl) hmEl.addEventListener('change', function() { NNAnimation.setHeatmap(this.checked); });
        // Dropout rate
        bindChange('nn-dropout-rate', function(v) { NNAnimation.setDropoutRate(v); }, 'float');
        // Epochs
        bindChange('nn-epochs', function(v) { NNAnimation.setMaxEpochs(v); }, 'int');

        // Animation mode selector
        var modeEl = document.getElementById('nn-anim-mode');
        if (modeEl) {
            modeEl.addEventListener('change', function() {
                NNAnimation.setMode(this.value);
                // Show/hide mode-specific controls
                var dropRow = document.querySelector('.nn-dropout-row');
                var trainRow = document.querySelector('.nn-training-row');
                if (dropRow) dropRow.style.display = this.value === 'dropout' ? 'flex' : 'none';
                if (trainRow) trainRow.style.display = this.value === 'training' ? 'flex' : 'none';
            });
        }

        // Presets
        populatePresets();
        var presetEl = document.getElementById('nn-preset');
        if (presetEl) {
            presetEl.addEventListener('change', function() {
                if (this.value) applyPreset(this.value);
            });
        }
    });

    // ── Presets ──

    function populatePresets() {
        var select = document.getElementById('nn-preset');
        if (!select || typeof NNPresets === 'undefined') return;

        // Clear and repopulate based on current mode
        select.innerHTML = '<option value="">Custom</option>';
        var presets = null;
        if (currentMode === 'fcnn') presets = NNPresets.fcnn;
        else if (currentMode === 'lenet') presets = NNPresets.lenet;
        else if (currentMode === 'alexnet') presets = NNPresets.alexnet;

        if (presets) {
            Object.keys(presets).forEach(function(name) {
                var opt = document.createElement('option');
                opt.value = name;
                opt.textContent = name;
                select.appendChild(opt);
            });
        }
    }

    function applyPreset(name) {
        var preset, archDiv, fcDiv;
        if (currentMode === 'fcnn') {
            preset = NNPresets.fcnn[name];
            if (!preset) return;
            archDiv = document.getElementById('fcnn-arch');
            archDiv.innerHTML = '';
            preset.layers.forEach(function(nodeCount, i) {
                var isLast = (i === preset.layers.length - 1);
                var row = document.createElement('div');
                row.className = 'nn-arch-row';
                row.innerHTML = '<button class="nn-arch-btn ' + (isLast ? 'nn-arch-btn-add' : 'nn-arch-btn-remove') + '">' + (isLast ? '+' : '&minus;') + '</button>' +
                    '<input type="number" name="fcnn-nodes" value="' + nodeCount + '" min="1" max="50">' +
                    '<input type="range" name="fcnn-spacing" min="0" max="100" step="1" value="' + (preset.spacing[i] || 20) + '">';
                archDiv.appendChild(row);
            });
            restartFCNN();
        } else if (currentMode === 'lenet') {
            preset = NNPresets.lenet[name];
            if (!preset) return;
            archDiv = document.getElementById('lenet-arch');
            archDiv.innerHTML = '';
            preset.conv.forEach(function(layer) {
                var row = document.createElement('div');
                row.className = 'nn-arch-row';
                row.innerHTML =
                    '<input type="number" name="lenet-n" value="' + layer.numberOfSquares + '" min="1" max="64" style="width:45px">' +
                    '<input type="number" name="lenet-h" value="' + layer.squareHeight + '" min="1" style="width:45px">' +
                    '<input type="number" name="lenet-w" value="' + layer.squareWidth + '" min="1" style="width:45px">' +
                    '<input type="number" name="lenet-fh" value="' + layer.filterHeight + '" min="1" style="width:40px">' +
                    '<input type="number" name="lenet-fw" value="' + layer.filterWidth + '" min="1" style="width:40px">' +
                    '<select name="lenet-op" style="width:60px;font-size:0.75rem"><option' + (layer.op === 'Convolution' ? ' selected' : '') + '>Convolution</option><option' + (layer.op === 'Max-Pool' ? ' selected' : '') + '>Max-Pool</option></select>';
                archDiv.appendChild(row);
            });
            fcDiv = document.getElementById('lenet-fc');
            fcDiv.innerHTML = '';
            preset.fc.forEach(function(size) {
                var row = document.createElement('div');
                row.className = 'nn-arch-row';
                row.innerHTML = '<input type="number" name="lenet-fc-size" value="' + size + '" min="1">';
                fcDiv.appendChild(row);
            });
            restartLeNet();
        } else if (currentMode === 'alexnet') {
            preset = NNPresets.alexnet[name];
            if (!preset) return;
            archDiv = document.getElementById('alexnet-arch');
            archDiv.innerHTML = '';
            preset.conv.forEach(function(layer) {
                var row = document.createElement('div');
                row.className = 'nn-arch-row';
                row.innerHTML =
                    '<input type="number" name="alexnet-h" value="' + layer.height + '" min="1" style="width:50px">' +
                    '<input type="number" name="alexnet-w" value="' + layer.width + '" min="1" style="width:50px">' +
                    '<input type="number" name="alexnet-d" value="' + layer.depth + '" min="1" style="width:45px">' +
                    '<input type="number" name="alexnet-fh" value="' + layer.filterHeight + '" min="1" style="width:40px">' +
                    '<input type="number" name="alexnet-fw" value="' + layer.filterWidth + '" min="1" style="width:40px">';
                archDiv.appendChild(row);
            });
            fcDiv = document.getElementById('alexnet-fc');
            fcDiv.innerHTML = '';
            preset.fc.forEach(function(size) {
                var row = document.createElement('div');
                row.className = 'nn-arch-row';
                row.innerHTML = '<input type="number" name="alexnet-fc-size" value="' + size + '" min="1">';
                fcDiv.appendChild(row);
            });
            restartAlexNet();
        }
    }

    // ── Download ──

    window.nnDownload = function() {
        var container = document.getElementById('nn-graph-container');
        if (currentMode === 'alexnet') {
            NNExport.downloadPNG(container);
        } else {
            NNExport.downloadSVG(container);
        }
    };

    // ── Helpers ──

    function bindChange(id, fn, type) {
        var el = document.getElementById(id);
        if (!el) return;
        el.addEventListener('change', function() {
            var val;
            if (type === 'checked') val = this.checked;
            else if (type === 'float') val = parseFloat(this.value);
            else if (type === 'int') val = parseInt(this.value);
            else val = this.value;
            fn(val);
        });
        // Also fire on input for range sliders
        if (el.type === 'range') {
            el.addEventListener('input', function() {
                fn(parseFloat(this.value));
            });
        }
    }

    function loadScript(src, callback, onError) {
        var s = document.createElement('script');
        s.src = src;
        s.onload = callback;
        s.onerror = function() {
            console.error('Failed to load: ' + src);
            if (onError) onError();
        };
        document.head.appendChild(s);
    }

    function updateStatus() {
        var statusEl = document.getElementById('nn-status');
        if (!statusEl) return;
        if (currentMode === 'fcnn' && currentViz && currentViz.graph) {
            var nodes = currentViz.graph.nodes ? currentViz.graph.nodes.length : 0;
            var links = currentViz.graph.links ? currentViz.graph.links.length : 0;
            statusEl.textContent = nodes + ' nodes, ' + links + ' edges';
        } else {
            statusEl.textContent = currentMode.toUpperCase() + ' mode';
        }
    }

})();
