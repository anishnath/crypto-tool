/* FCNN Visualization — D3.js v7 port
   Adapted from NN-SVG by Alexander LeNail (MIT License) */

'use strict';

function FCNN(container) {

    var randomWeight = function() { return Math.random() * 2 - 1; };

    var el = container || document.getElementById('nn-graph-container');
    var w = el.clientWidth || 800;
    var h = el.clientHeight || 600;

    var svg = d3.select(el).append('svg').attr('xmlns', 'http://www.w3.org/2000/svg');
    var g = svg.append('g');
    svg.style('cursor', 'move');

    var edgeWidthProportional = false;
    var edgeWidth = 0.5;
    var weightedEdgeWidth = d3.scaleLinear().domain([0, 1]).range([0, edgeWidth]);

    var edgeOpacityProportional = false;
    var edgeOpacity = 1.0;
    var weightedEdgeOpacity = d3.scaleLinear().domain([0, 1]).range([0, 1]);

    var edgeColorProportional = false;
    var defaultEdgeColor = '#505050';
    var negativeEdgeColor = '#0000ff';
    var positiveEdgeColor = '#ff0000';
    var weightedEdgeColor = d3.scaleLinear().domain([-1, 0, 1]).range([negativeEdgeColor, 'white', positiveEdgeColor]);

    var nodeDiameter = 20;
    var nodeColor = '#ffffff';
    var nodeBorderColor = '#333333';

    var betweenLayers = 160;

    var architecture = [8, 12, 8];
    var betweenNodesInLayer = [20, 20, 20];
    var graph = {};
    var layer_offsets = [];
    var largest_layer_width = 0;
    var nnDirection = 'right';
    var showBias = false;
    var showLabels = true;
    var showArrowheads = false;
    var arrowheadStyle = 'empty';
    var bezierCurves = false;

    var sup_map = {'0':'⁰','1':'¹','2':'²','3':'³','4':'⁴','5':'⁵','6':'⁶','7':'⁷','8':'⁸','9':'⁹'};
    var sup = function(s) { return Array.prototype.map.call(s, function(d) { return (d in sup_map && sup_map[d]) || d; }).join(''); };

    var textFn = function(layer_index, layer_width) {
        return ((layer_index === 0 ? 'Input' : (layer_index === architecture.length - 1 ? 'Output' : 'Hidden')) + ' Layer \u2208 \u211D' + sup(layer_width.toString()));
    };
    var nominal_text_size = 12;
    var textWidth = 70;

    var marker = svg.append('svg:defs').append('svg:marker')
        .attr('id', 'arrow')
        .attr('viewBox', '0 -5 10 10')
        .attr('markerWidth', 7)
        .attr('markerHeight', 7)
        .attr('orient', 'auto');

    var arrowhead = marker.append('svg:path')
        .attr('d', 'M0,-5L10,0L0,5')
        .style('stroke', defaultEdgeColor);

    var link = g.selectAll('.link');
    var node = g.selectAll('.node');
    var text = g.selectAll('.text');

    // ── Methods ──

    function redraw(opts) {
        opts = opts || {};
        architecture = opts.architecture_ !== undefined ? opts.architecture_ : architecture;
        showBias = opts.showBias_ !== undefined ? opts.showBias_ : showBias;
        showLabels = opts.showLabels_ !== undefined ? opts.showLabels_ : showLabels;
        bezierCurves = opts.bezierCurves_ !== undefined ? opts.bezierCurves_ : bezierCurves;

        graph.nodes = architecture.map(function(layer_width, layer_index) {
            return NNUtil.range(layer_width).map(function(node_index) {
                return {id: layer_index + '_' + node_index, layer: layer_index, node_index: node_index};
            });
        });
        graph.links = NNUtil.pairWise(graph.nodes).map(function(nodes) {
            return nodes[0].map(function(left) {
                return nodes[1].map(function(right) {
                    return right.node_index >= 0 ? {id: left.id + '-' + right.id, source: left.id, target: right.id, weight: randomWeight()} : null;
                });
            });
        });
        graph.nodes = NNUtil.flatten(graph.nodes);
        graph.links = NNUtil.flatten(graph.links).filter(function(l) {
            return l && (showBias ? (parseInt(l.target.split('_')[0]) !== architecture.length - 1 ? (l.target.split('_')[1] !== '0') : true) : true);
        });

        var label = architecture.map(function(layer_width, layer_index) {
            return {id: 'layer_' + layer_index + '_label', layer: layer_index, text: textFn(layer_index, layer_width)};
        });

        link = link.data(graph.links, function(d) { return d.id; });
        link.exit().remove();
        link = link.enter()
            .insert('path', '.node')
            .attr('class', 'link')
            .merge(link);

        node = node.data(graph.nodes, function(d) { return d.id; });
        node.exit().remove();
        node = node.enter()
            .append('circle')
            .attr('r', nodeDiameter / 2)
            .attr('class', 'node')
            .attr('id', function(d) { return d.id; })
            .on('mousedown', function(event, d) { set_focus(event, d); })
            .on('mouseup', function(event) { remove_focus(event); })
            .merge(node);

        text = text.data(label, function(d) { return d.id; });
        text.exit().remove();
        text = text.enter()
            .append('text')
            .attr('class', 'text')
            .attr('dy', '.35em')
            .style('font-size', nominal_text_size + 'px')
            .merge(text)
            .text(function(d) { return showLabels ? d.text : ''; });

        style();
    }

    function redistribute(opts) {
        opts = opts || {};
        betweenNodesInLayer = opts.betweenNodesInLayer_ !== undefined ? opts.betweenNodesInLayer_ : betweenNodesInLayer;
        betweenLayers = opts.betweenLayers_ !== undefined ? opts.betweenLayers_ : betweenLayers;
        nnDirection = opts.nnDirection_ !== undefined ? opts.nnDirection_ : nnDirection;
        bezierCurves = opts.bezierCurves_ !== undefined ? opts.bezierCurves_ : bezierCurves;

        var layer_widths = architecture.map(function(layer_width, i) {
            return layer_width * nodeDiameter + (layer_width - 1) * betweenNodesInLayer[i];
        });

        largest_layer_width = Math.max.apply(null, layer_widths);

        layer_offsets = layer_widths.map(function(lw) { return (largest_layer_width - lw) / 2; });

        var indices_from_id = function(id) { return id.split('_').map(function(x) { return parseInt(x); }); };

        var xR = function(layer, node_index) { return layer * (betweenLayers + nodeDiameter) + w / 2 - (betweenLayers * layer_offsets.length / 3); };
        var yR = function(layer, node_index) { return layer_offsets[layer] + node_index * (nodeDiameter + betweenNodesInLayer[layer]) + h / 2 - largest_layer_width / 2; };

        var xU = function(layer, node_index) { return layer_offsets[layer] + node_index * (nodeDiameter + betweenNodesInLayer[layer]) + w / 2 - largest_layer_width / 2; };
        var yU = function(layer, node_index) { return layer * (betweenLayers + nodeDiameter) + h / 2 - (betweenLayers * layer_offsets.length / 3); };

        var x = nnDirection === 'up' ? xU : xR;
        var y = nnDirection === 'up' ? yU : yR;

        node.attr('cx', function(d) { return x(d.layer, d.node_index); })
            .attr('cy', function(d) { return y(d.layer, d.node_index); });

        if (bezierCurves) {
            link.attr('d', function(d) {
                var source = [x.apply(null, indices_from_id(d.source)), y.apply(null, indices_from_id(d.source))];
                var target = [x.apply(null, indices_from_id(d.target)), y.apply(null, indices_from_id(d.target))];
                var cp1 = [(source[0] + target[0]) / 2, source[1]];
                var cp2 = [(source[0] + target[0]) / 2, target[1]];
                return 'M' + source[0] + ',' + source[1] + 'C' + cp1[0] + ',' + cp1[1] + ' ' + cp2[0] + ',' + cp2[1] + ' ' + target[0] + ',' + target[1];
            });
        } else {
            link.attr('d', function(d) {
                return 'M' + x.apply(null, indices_from_id(d.source)) + ',' + y.apply(null, indices_from_id(d.source)) + ' L' +
                    x.apply(null, indices_from_id(d.target)) + ',' + y.apply(null, indices_from_id(d.target));
            });
        }

        text.attr('x', function(d) { return nnDirection === 'right' ? x(d.layer, d.node_index) - textWidth / 2 : w / 2 + largest_layer_width / 2 + 20; })
            .attr('y', function(d) { return nnDirection === 'right' ? h / 2 + largest_layer_width / 2 + 20 : y(d.layer, d.node_index); });
    }

    function style(opts) {
        opts = opts || {};
        edgeWidthProportional = opts.edgeWidthProportional_ !== undefined ? opts.edgeWidthProportional_ : edgeWidthProportional;
        edgeWidth = opts.edgeWidth_ !== undefined ? opts.edgeWidth_ : edgeWidth;
        weightedEdgeWidth = d3.scaleLinear().domain([0, 1]).range([0, edgeWidth]);
        edgeOpacityProportional = opts.edgeOpacityProportional_ !== undefined ? opts.edgeOpacityProportional_ : edgeOpacityProportional;
        edgeOpacity = opts.edgeOpacity_ !== undefined ? opts.edgeOpacity_ : edgeOpacity;
        defaultEdgeColor = opts.defaultEdgeColor_ !== undefined ? opts.defaultEdgeColor_ : defaultEdgeColor;
        edgeColorProportional = opts.edgeColorProportional_ !== undefined ? opts.edgeColorProportional_ : edgeColorProportional;
        negativeEdgeColor = opts.negativeEdgeColor_ !== undefined ? opts.negativeEdgeColor_ : negativeEdgeColor;
        positiveEdgeColor = opts.positiveEdgeColor_ !== undefined ? opts.positiveEdgeColor_ : positiveEdgeColor;
        weightedEdgeColor = d3.scaleLinear().domain([-1, 0, 1]).range([negativeEdgeColor, 'white', positiveEdgeColor]);
        nodeDiameter = opts.nodeDiameter_ !== undefined ? opts.nodeDiameter_ : nodeDiameter;
        nodeColor = opts.nodeColor_ !== undefined ? opts.nodeColor_ : nodeColor;
        nodeBorderColor = opts.nodeBorderColor_ !== undefined ? opts.nodeBorderColor_ : nodeBorderColor;
        showArrowheads = opts.showArrowheads_ !== undefined ? opts.showArrowheads_ : showArrowheads;
        arrowheadStyle = opts.arrowheadStyle_ !== undefined ? opts.arrowheadStyle_ : arrowheadStyle;
        bezierCurves = opts.bezierCurves_ !== undefined ? opts.bezierCurves_ : bezierCurves;

        link.style('stroke-width', function(d) {
            return edgeWidthProportional ? weightedEdgeWidth(Math.abs(d.weight)) : edgeWidth;
        });
        link.style('stroke-opacity', function(d) {
            return edgeOpacityProportional ? weightedEdgeOpacity(Math.abs(d.weight)) : edgeOpacity;
        });
        link.style('stroke', function(d) {
            return edgeColorProportional ? weightedEdgeColor(d.weight) : defaultEdgeColor;
        });
        link.style('fill', 'none');

        link.attr('marker-end', showArrowheads ? 'url(#arrow)' : '');
        marker.attr('refX', nodeDiameter * 1.4 + 12);
        arrowhead.style('fill', arrowheadStyle === 'empty' ? 'none' : defaultEdgeColor);

        node.attr('r', nodeDiameter / 2);
        node.style('fill', nodeColor);
        node.style('stroke', nodeBorderColor);
    }

    // ── Focus ──

    function set_focus(event, d) {
        event.stopPropagation();
        node.style('opacity', function(o) { return (d === o || o.layer === d.layer - 1) ? 1 : 0.1; });
        link.style('opacity', function(o) { return (o.target === d.id) ? 1 : 0.02; });
    }

    function remove_focus(event) {
        event.stopPropagation();
        node.style('opacity', 1);
        link.style('opacity', function() { return edgeOpacity; });
    }

    // ── Zoom & Resize ──

    svg.call(d3.zoom()
        .scaleExtent([1 / 2, 8])
        .on('zoom', function(event) { g.attr('transform', event.transform); }));

    function resize() {
        w = el.clientWidth || 800;
        h = el.clientHeight || 600;
        svg.attr('width', w).attr('height', h);
    }

    var ro = new ResizeObserver(function() { resize(); redistribute(); });
    ro.observe(el);

    resize();

    // ── Skip connections ──

    var skipGroup = null;
    var skipConnections = []; // [{from: layerIdx, to: layerIdx}]

    function setSkipConnections(skips) {
        skipConnections = skips || [];
        drawSkipConnections();
    }

    function drawSkipConnections() {
        if (skipGroup) skipGroup.remove();
        if (!skipConnections.length) return;

        skipGroup = g.insert('g', '.node').attr('class', 'nn-skip-conns');

        skipConnections.forEach(function(skip) {
            var fromLayer = skip.from;
            var toLayer = skip.to;
            if (fromLayer >= architecture.length || toLayer >= architecture.length) return;
            if (fromLayer >= toLayer) return;

            // Get center positions of the layers
            var fromNodes = graph.nodes.filter(function(n) { return n.layer === fromLayer; });
            var toNodes = graph.nodes.filter(function(n) { return n.layer === toLayer; });
            if (!fromNodes.length || !toNodes.length) return;

            // Find bounds from actual node positions
            var fromNodeEls = node.filter(function(d) { return d.layer === fromLayer; });
            var toNodeEls = node.filter(function(d) { return d.layer === toLayer; });

            var fromCx = 0, fromTopY = Infinity, fromBotY = -Infinity;
            fromNodeEls.each(function() {
                fromCx = parseFloat(d3.select(this).attr('cx'));
                var cy = parseFloat(d3.select(this).attr('cy'));
                if (cy < fromTopY) fromTopY = cy;
                if (cy > fromBotY) fromBotY = cy;
            });

            var toCx = 0, toTopY = Infinity, toBotY = -Infinity;
            toNodeEls.each(function() {
                toCx = parseFloat(d3.select(this).attr('cx'));
                var cy = parseFloat(d3.select(this).attr('cy'));
                if (cy < toTopY) toTopY = cy;
                if (cy > toBotY) toBotY = cy;
            });

            var fromY = (fromTopY + fromBotY) / 2;
            var toY = (toTopY + toBotY) / 2;
            var arcHeight = Math.max(40, (toLayer - fromLayer) * 25);

            // Draw curved arc above the network
            var path;
            if (nnDirection === 'right') {
                var topY = Math.min(fromTopY, toTopY) - arcHeight;
                path = 'M' + fromCx + ',' + fromTopY +
                       ' C' + fromCx + ',' + topY + ' ' + toCx + ',' + topY + ' ' + toCx + ',' + toTopY;
            } else {
                var leftX = Math.min(fromCx, toCx) - arcHeight;
                path = 'M' + fromCx + ',' + fromY +
                       ' C' + leftX + ',' + fromY + ' ' + leftX + ',' + toY + ' ' + toCx + ',' + toY;
            }

            // Arc path
            skipGroup.append('path')
                .attr('d', path)
                .attr('fill', 'none')
                .attr('stroke', '#6366f1')
                .attr('stroke-width', 2)
                .attr('stroke-dasharray', '6,3')
                .attr('stroke-opacity', 0.6)
                .attr('class', 'nn-skip-path');

            // Arrowhead at end
            var arrowSize = 6;
            skipGroup.append('circle')
                .attr('cx', toCx)
                .attr('cy', nnDirection === 'right' ? toTopY : toY)
                .attr('r', arrowSize / 2)
                .attr('fill', '#6366f1')
                .attr('opacity', 0.7);

            // "+" label at junction
            skipGroup.append('text')
                .attr('x', toCx + nodeDiameter / 2 + 4)
                .attr('y', (nnDirection === 'right' ? toTopY : toY) + 4)
                .attr('font-size', '11px')
                .attr('font-weight', '700')
                .attr('fill', '#6366f1')
                .attr('opacity', 0.8)
                .text('+');
        });
    }

    // ── Destroy ──

    function destroy() {
        ro.disconnect();
        svg.remove();
    }

    return {
        redraw: redraw,
        redistribute: redistribute,
        style: style,
        resize: resize,
        destroy: destroy,
        graph: graph,
        link: function() { return link; },
        svg: function() { return svg; },
        g: function() { return g; },
        node: function() { return node; },
        getArchitecture: function() { return architecture; },
        setSkipConnections: setSkipConnections,
        drawSkipConnections: drawSkipConnections
    };
}
